//
//  LinkedList.swift
//  双向循环链表
//
//  Created by 周伟克 on 2020/8/28.
//  Copyright © 2020 周伟克. All rights reserved.
//

import Foundation

class LinkedList<T> {
    
    var size = UInt(0)
    var head: LinkedNode<T>?
    var tail: LinkedNode<T>?
    
    /// 追加节点
    func append(_ value: T) {
        let node = LinkedNode(value)
        node.prev = tail
        tail?.next = node
        tail = node
        head = head ?? node
        // 建立环
        head?.prev = node
        node.next = head
        
        size += 1
    }
    
    /// 插入节点
    func insert(_ value: T, at index: UInt) {
        if index > size {
            fatalError("\(index) out of bunds 0 ... \(size)")
        }
        if index == size {
            append(value)
            return
        }
        
        let newNode = LinkedNode(value)
        if index == 0 {
            newNode.next = head
            head?.prev = newNode
            head = newNode
            tail?.next = head
            head?.prev = tail
        } else {
            let old = node(at: index)
            let prev = old?.prev
            prev?.next = newNode
            newNode.prev = prev
            newNode.next = old
            old?.prev = newNode
        }
        size += 1
    }
    
    /// 删除对应位置的节点
    func deleteNode(at index: UInt) -> LinkedNode<T> {
        if index >= size {
            fatalError("\(index) out of bunds 0 ..< \(size)")
        }
        let target: LinkedNode<T>
        if size == 1 {
            target = head!
            clear()
            return target
        }
        if index == 0 {
            head = head?.next
            tail?.next = head
            head?.prev = tail
            target = head!
        } else {
            target = node(at: index)!
            target.prev?.next = target.next
            target.next?.prev = target.prev
            if index == size - 1 {
                tail = target.prev
            }
        }
        size -= 1
        return target
    }
    
    /// 第index个节点
    func node(at index: UInt) -> LinkedNode<T>? {
        if index >= size {
            fatalError("\(index) out of bounds 0 ..< \(size)")
        }
        var cursor: UInt
        var node: LinkedNode<T>?
        if (index > size >> 1) {
            cursor = size - 1
            node = tail
            while cursor != index {
                node = node?.prev
                cursor -= 1
            }
            return node
        }
        
        cursor = 0
        node = head
        while cursor != index {
            node = node?.next
            cursor += 1
        }
        return node
    }

    
    /// 反转
    func reverse() {
        var newHead = head
        var next: LinkedNode<T>?
        var nextNext: LinkedNode<T>?
        while newHead !== tail {
            next = head?.next
            nextNext = head?.next?.next
            next?.next = newHead
            newHead?.prev = next
            newHead = next //①
            head?.next = nextNext //②
        }
        /**
         * 假如原链表为0 1 2 3 4，0是head，4是tail
         * while之后为4 3 2 1 0，但是 4的prev是3，0的next是0
         * 因为从3 2 1 0 4开始反转的时候，nextNext就是4的next，即为0，
         * ②处的代码的实际效果是head.next = head，
         * ①把4作为newHead的时候，退出while循环没有重新设置4的prev
         * 4依然保留了之前的prev，即使3
         */
        tail = head
        head = newHead
        head?.prev = tail
        tail?.next = head
    }
    
    /// 从头结点开始遍历
    func travelFromHead() {
        if size == 0 {
            print("空链表")
            return
        }
        var node = head
        var str = ""
        repeat {
            str += "\(node!.value)" + arrow
            node = node?.next
        } while node !== head
        str += "null"
        print(str)
    }
    
    /// 从尾结点开始遍历
    func travelFromTail() {
        if (size == 0) {
            print("空链表")
            return
        }
        var node = tail
        var str = "null"
        repeat {
            str += arrow + "\(node!.value)"
            node = node?.prev
        } while node !== tail
        print(str)
    }
    
    func rangeCheck(index: UInt) {
        if index >= size - 1 {
            fatalError("\(index) out of bunds 0 ..< \(size)")
        }
    }
    
    let arrow = "  -->  "
    
    
    func clear() {
        head?.next = nil // next -> next -> next 形成环，next是强应用
        head = nil
        tail = nil
        size = 0
    }
}
