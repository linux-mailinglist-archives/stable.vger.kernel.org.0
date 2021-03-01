Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62EB8328DBC
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:18:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240848AbhCATQ0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:16:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:39810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241130AbhCATMm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:12:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1B61B65241;
        Mon,  1 Mar 2021 17:27:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619653;
        bh=dSWCZld/NnK6d1LIRwZSc5FuGNzD7Cdm13umwFBGe3Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wo3HTdXGwy3PotWVEI7g4aivC4u8uEbyScjFWE6P91HzUqEbzF6bAF+fNn7PQE/V0
         L3hwvrSiiMvGejgJxEhky4T/HpBxW1Zq7I6fE+1tHeKjyi6u8akdkl9EuyAMcVHINn
         QpzYIdLuC4BWbQzXBAy72eo2CirxcLgGiYK9Q2AY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.10 533/663] btrfs: add asserts for deleting backref cache nodes
Date:   Mon,  1 Mar 2021 17:13:01 +0100
Message-Id: <20210301161208.223446553@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josef Bacik <josef@toxicpanda.com>

commit eddda68d97732ce05ca145f8e85e8a447f65cdad upstream.

A weird KASAN problem that Zygo reported could have been easily caught
if we checked for basic things in our backref freeing code.  We have two
methods of freeing a backref node

- btrfs_backref_free_node: this just is kfree() essentially.
- btrfs_backref_drop_node: this actually unlinks the node and cleans up
  everything and then calls btrfs_backref_free_node().

We should mostly be using btrfs_backref_drop_node(), to make sure the
node is properly unlinked from the backref cache, and only use
btrfs_backref_free_node() when we know the node isn't actually linked to
the backref cache.  We made a mistake here and thus got the KASAN splat.

Make this style of issue easier to find by adding some ASSERT()'s to
btrfs_backref_free_node() and adjusting our deletion stuff to properly
init the list so we can rely on list_empty() checks working properly.

  BUG: KASAN: use-after-free in btrfs_backref_cleanup_node+0x18a/0x420
  Read of size 8 at addr ffff888112402950 by task btrfs/28836

  CPU: 0 PID: 28836 Comm: btrfs Tainted: G        W         5.10.0-e35f27394290-for-next+ #23
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.12.0-1 04/01/2014
  Call Trace:
   dump_stack+0xbc/0xf9
   ? btrfs_backref_cleanup_node+0x18a/0x420
   print_address_description.constprop.8+0x21/0x210
   ? record_print_text.cold.34+0x11/0x11
   ? btrfs_backref_cleanup_node+0x18a/0x420
   ? btrfs_backref_cleanup_node+0x18a/0x420
   kasan_report.cold.10+0x20/0x37
   ? btrfs_backref_cleanup_node+0x18a/0x420
   __asan_load8+0x69/0x90
   btrfs_backref_cleanup_node+0x18a/0x420
   btrfs_backref_release_cache+0x83/0x1b0
   relocate_block_group+0x394/0x780
   ? merge_reloc_roots+0x4a0/0x4a0
   btrfs_relocate_block_group+0x26e/0x4c0
   btrfs_relocate_chunk+0x52/0x120
   btrfs_balance+0xe2e/0x1900
   ? check_flags.part.50+0x6c/0x1e0
   ? btrfs_relocate_chunk+0x120/0x120
   ? kmem_cache_alloc_trace+0xa06/0xcb0
   ? _copy_from_user+0x83/0xc0
   btrfs_ioctl_balance+0x3a7/0x460
   btrfs_ioctl+0x24c8/0x4360
   ? __kasan_check_read+0x11/0x20
   ? check_chain_key+0x1f4/0x2f0
   ? __asan_loadN+0xf/0x20
   ? btrfs_ioctl_get_supported_features+0x30/0x30
   ? kvm_sched_clock_read+0x18/0x30
   ? check_chain_key+0x1f4/0x2f0
   ? lock_downgrade+0x3f0/0x3f0
   ? handle_mm_fault+0xad6/0x2150
   ? do_vfs_ioctl+0xfc/0x9d0
   ? ioctl_file_clone+0xe0/0xe0
   ? check_flags.part.50+0x6c/0x1e0
   ? check_flags.part.50+0x6c/0x1e0
   ? check_flags+0x26/0x30
   ? lock_is_held_type+0xc3/0xf0
   ? syscall_enter_from_user_mode+0x1b/0x60
   ? do_syscall_64+0x13/0x80
   ? rcu_read_lock_sched_held+0xa1/0xd0
   ? __kasan_check_read+0x11/0x20
   ? __fget_light+0xae/0x110
   __x64_sys_ioctl+0xc3/0x100
   do_syscall_64+0x37/0x80
   entry_SYSCALL_64_after_hwframe+0x44/0xa9
  RIP: 0033:0x7f4c4bdfe427
  RSP: 002b:00007fff33ee6df8 EFLAGS: 00000202 ORIG_RAX: 0000000000000010
  RAX: ffffffffffffffda RBX: 00007fff33ee6e98 RCX: 00007f4c4bdfe427
  RDX: 00007fff33ee6e98 RSI: 00000000c4009420 RDI: 0000000000000003
  RBP: 0000000000000003 R08: 0000000000000003 R09: 0000000000000078
  R10: fffffffffffff59d R11: 0000000000000202 R12: 0000000000000001
  R13: 0000000000000000 R14: 00007fff33ee8a34 R15: 0000000000000001

  Allocated by task 28836:
   kasan_save_stack+0x21/0x50
   __kasan_kmalloc.constprop.18+0xbe/0xd0
   kasan_kmalloc+0x9/0x10
   kmem_cache_alloc_trace+0x410/0xcb0
   btrfs_backref_alloc_node+0x46/0xf0
   btrfs_backref_add_tree_node+0x60d/0x11d0
   build_backref_tree+0xc5/0x700
   relocate_tree_blocks+0x2be/0xb90
   relocate_block_group+0x2eb/0x780
   btrfs_relocate_block_group+0x26e/0x4c0
   btrfs_relocate_chunk+0x52/0x120
   btrfs_balance+0xe2e/0x1900
   btrfs_ioctl_balance+0x3a7/0x460
   btrfs_ioctl+0x24c8/0x4360
   __x64_sys_ioctl+0xc3/0x100
   do_syscall_64+0x37/0x80
   entry_SYSCALL_64_after_hwframe+0x44/0xa9

  Freed by task 28836:
   kasan_save_stack+0x21/0x50
   kasan_set_track+0x20/0x30
   kasan_set_free_info+0x1f/0x30
   __kasan_slab_free+0xf3/0x140
   kasan_slab_free+0xe/0x10
   kfree+0xde/0x200
   btrfs_backref_error_cleanup+0x452/0x530
   build_backref_tree+0x1a5/0x700
   relocate_tree_blocks+0x2be/0xb90
   relocate_block_group+0x2eb/0x780
   btrfs_relocate_block_group+0x26e/0x4c0
   btrfs_relocate_chunk+0x52/0x120
   btrfs_balance+0xe2e/0x1900
   btrfs_ioctl_balance+0x3a7/0x460
   btrfs_ioctl+0x24c8/0x4360
   __x64_sys_ioctl+0xc3/0x100
   do_syscall_64+0x37/0x80
   entry_SYSCALL_64_after_hwframe+0x44/0xa9

  The buggy address belongs to the object at ffff888112402900
   which belongs to the cache kmalloc-128 of size 128
  The buggy address is located 80 bytes inside of
   128-byte region [ffff888112402900, ffff888112402980)
  The buggy address belongs to the page:
  page:0000000028b1cd08 refcount:1 mapcount:0 mapping:0000000000000000 index:0xffff888131c810c0 pfn:0x112402
  flags: 0x17ffe0000000200(slab)
  raw: 017ffe0000000200 ffffea000424f308 ffffea0007d572c8 ffff888100040440
  raw: ffff888131c810c0 ffff888112402000 0000000100000009 0000000000000000
  page dumped because: kasan: bad access detected

  Memory state around the buggy address:
   ffff888112402800: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
   ffff888112402880: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
  >ffff888112402900: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                                   ^
   ffff888112402980: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
   ffff888112402a00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb

Link: https://lore.kernel.org/linux-btrfs/20201208194607.GI31381@hungrycats.org/
CC: stable@vger.kernel.org # 5.10+
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/backref.h |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/fs/btrfs/backref.h
+++ b/fs/btrfs/backref.h
@@ -296,6 +296,9 @@ static inline void btrfs_backref_free_no
 					   struct btrfs_backref_node *node)
 {
 	if (node) {
+		ASSERT(list_empty(&node->list));
+		ASSERT(list_empty(&node->lower));
+		ASSERT(node->eb == NULL);
 		cache->nr_nodes--;
 		btrfs_put_root(node->root);
 		kfree(node);
@@ -340,11 +343,11 @@ static inline void btrfs_backref_drop_no
 static inline void btrfs_backref_drop_node(struct btrfs_backref_cache *tree,
 					   struct btrfs_backref_node *node)
 {
-	BUG_ON(!list_empty(&node->upper));
+	ASSERT(list_empty(&node->upper));
 
 	btrfs_backref_drop_node_buffer(node);
-	list_del(&node->list);
-	list_del(&node->lower);
+	list_del_init(&node->list);
+	list_del_init(&node->lower);
 	if (!RB_EMPTY_NODE(&node->rb_node))
 		rb_erase(&node->rb_node, &tree->rb_root);
 	btrfs_backref_free_node(tree, node);


