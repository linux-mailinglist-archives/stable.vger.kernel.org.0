Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C09271A7F63
	for <lists+stable@lfdr.de>; Tue, 14 Apr 2020 16:17:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389294AbgDNORI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Apr 2020 10:17:08 -0400
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:55657 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389298AbgDNORF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Apr 2020 10:17:05 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 0CEF4A4D;
        Tue, 14 Apr 2020 10:17:03 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Tue, 14 Apr 2020 10:17:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=Q5/fW5
        9G1sAV6odyP/7EtoEVzLF/+lY2RtWnO12qAoA=; b=mvWSa0zZ78YrkaO3sSwyXT
        d51FLTXG5+iWi2+5HNFoJf65v4b6E/Jas9bRbnEXDneJQJ4fPNcaH/mQkt5CV7zc
        mUZmyRGj4AZyRbcG+oq8VwHr2w7XPtythUKaGKOvY0Ofpb0Ix5hnWDArBd+VqejZ
        y7+irfcXW0Pq7gLOsmItnXaTUafqTluT8WSO78BhwcZirX9A1RAjT+nz766R2RQs
        JYKL/PLP4gPveUPl0OwkpcQSHVLqTJb01J5T6zlz5Sq/x7mH7eNwZ4INlpKABPlG
        /pDK9ZyFtbANp3T3X74BoesvpL7lHVzSyrObQ/QT2D9sSsQ9VbxDl3oZ3ixFX1Qg
        ==
X-ME-Sender: <xms:38WVXrLk4OZC3xi0d7WoL10YSfqliYLZKviy69nHbhLbTzpazMpPLA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrfedugdejfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgepleenuc
    frrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:38WVXhH6auU8ZmBUcy3liClUta77TaRK7mNJb_sc1K11BkkYKwSLqw>
    <xmx:38WVXuGyacDjkyrvOVqdxoXr6lj80vTmlpaepZNHGfYfG_fy7F5Nug>
    <xmx:38WVXht2lcyefP7U2yZSSsmKMtbCRybMQV-MwuqLxNAg8AiOZlZARA>
    <xmx:38WVXimyEtqz-jZh2_UIJ3f7dpkPDoEuIOmE4cWWUmeMbSY96-QIcA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 46CB93280069;
        Tue, 14 Apr 2020 10:17:03 -0400 (EDT)
Subject: FAILED: patch "[PATCH] btrfs: use nofs allocations for running delayed items" failed to apply to 4.4-stable tree
To:     josef@toxicpanda.com, dsterba@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 14 Apr 2020 16:17:00 +0200
Message-ID: <1586873820176209@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 351cbf6e4410e7ece05e35d0a07320538f2418b4 Mon Sep 17 00:00:00 2001
From: Josef Bacik <josef@toxicpanda.com>
Date: Thu, 19 Mar 2020 10:11:32 -0400
Subject: [PATCH] btrfs: use nofs allocations for running delayed items

Zygo reported the following lockdep splat while testing the balance
patches

======================================================
WARNING: possible circular locking dependency detected
5.6.0-c6f0579d496a+ #53 Not tainted
------------------------------------------------------
kswapd0/1133 is trying to acquire lock:
ffff888092f622c0 (&delayed_node->mutex){+.+.}, at: __btrfs_release_delayed_node+0x7c/0x5b0

but task is already holding lock:
ffffffff8fc5f860 (fs_reclaim){+.+.}, at: __fs_reclaim_acquire+0x5/0x30

which lock already depends on the new lock.

the existing dependency chain (in reverse order) is:

-> #1 (fs_reclaim){+.+.}:
       fs_reclaim_acquire.part.91+0x29/0x30
       fs_reclaim_acquire+0x19/0x20
       kmem_cache_alloc_trace+0x32/0x740
       add_block_entry+0x45/0x260
       btrfs_ref_tree_mod+0x6e2/0x8b0
       btrfs_alloc_tree_block+0x789/0x880
       alloc_tree_block_no_bg_flush+0xc6/0xf0
       __btrfs_cow_block+0x270/0x940
       btrfs_cow_block+0x1ba/0x3a0
       btrfs_search_slot+0x999/0x1030
       btrfs_insert_empty_items+0x81/0xe0
       btrfs_insert_delayed_items+0x128/0x7d0
       __btrfs_run_delayed_items+0xf4/0x2a0
       btrfs_run_delayed_items+0x13/0x20
       btrfs_commit_transaction+0x5cc/0x1390
       insert_balance_item.isra.39+0x6b2/0x6e0
       btrfs_balance+0x72d/0x18d0
       btrfs_ioctl_balance+0x3de/0x4c0
       btrfs_ioctl+0x30ab/0x44a0
       ksys_ioctl+0xa1/0xe0
       __x64_sys_ioctl+0x43/0x50
       do_syscall_64+0x77/0x2c0
       entry_SYSCALL_64_after_hwframe+0x49/0xbe

-> #0 (&delayed_node->mutex){+.+.}:
       __lock_acquire+0x197e/0x2550
       lock_acquire+0x103/0x220
       __mutex_lock+0x13d/0xce0
       mutex_lock_nested+0x1b/0x20
       __btrfs_release_delayed_node+0x7c/0x5b0
       btrfs_remove_delayed_node+0x49/0x50
       btrfs_evict_inode+0x6fc/0x900
       evict+0x19a/0x2c0
       dispose_list+0xa0/0xe0
       prune_icache_sb+0xbd/0xf0
       super_cache_scan+0x1b5/0x250
       do_shrink_slab+0x1f6/0x530
       shrink_slab+0x32e/0x410
       shrink_node+0x2a5/0xba0
       balance_pgdat+0x4bd/0x8a0
       kswapd+0x35a/0x800
       kthread+0x1e9/0x210
       ret_from_fork+0x3a/0x50

other info that might help us debug this:

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(fs_reclaim);
                               lock(&delayed_node->mutex);
                               lock(fs_reclaim);
  lock(&delayed_node->mutex);

 *** DEADLOCK ***

3 locks held by kswapd0/1133:
 #0: ffffffff8fc5f860 (fs_reclaim){+.+.}, at: __fs_reclaim_acquire+0x5/0x30
 #1: ffffffff8fc380d8 (shrinker_rwsem){++++}, at: shrink_slab+0x1e8/0x410
 #2: ffff8881e0e6c0e8 (&type->s_umount_key#42){++++}, at: trylock_super+0x1b/0x70

stack backtrace:
CPU: 2 PID: 1133 Comm: kswapd0 Not tainted 5.6.0-c6f0579d496a+ #53
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.12.0-1 04/01/2014
Call Trace:
 dump_stack+0xc1/0x11a
 print_circular_bug.isra.38.cold.57+0x145/0x14a
 check_noncircular+0x2a9/0x2f0
 ? print_circular_bug.isra.38+0x130/0x130
 ? stack_trace_consume_entry+0x90/0x90
 ? save_trace+0x3cc/0x420
 __lock_acquire+0x197e/0x2550
 ? btrfs_inode_clear_file_extent_range+0x9b/0xb0
 ? register_lock_class+0x960/0x960
 lock_acquire+0x103/0x220
 ? __btrfs_release_delayed_node+0x7c/0x5b0
 __mutex_lock+0x13d/0xce0
 ? __btrfs_release_delayed_node+0x7c/0x5b0
 ? __asan_loadN+0xf/0x20
 ? pvclock_clocksource_read+0xeb/0x190
 ? __btrfs_release_delayed_node+0x7c/0x5b0
 ? mutex_lock_io_nested+0xc20/0xc20
 ? __kasan_check_read+0x11/0x20
 ? check_chain_key+0x1e6/0x2e0
 mutex_lock_nested+0x1b/0x20
 ? mutex_lock_nested+0x1b/0x20
 __btrfs_release_delayed_node+0x7c/0x5b0
 btrfs_remove_delayed_node+0x49/0x50
 btrfs_evict_inode+0x6fc/0x900
 ? btrfs_setattr+0x840/0x840
 ? do_raw_spin_unlock+0xa8/0x140
 evict+0x19a/0x2c0
 dispose_list+0xa0/0xe0
 prune_icache_sb+0xbd/0xf0
 ? invalidate_inodes+0x310/0x310
 super_cache_scan+0x1b5/0x250
 do_shrink_slab+0x1f6/0x530
 shrink_slab+0x32e/0x410
 ? do_shrink_slab+0x530/0x530
 ? do_shrink_slab+0x530/0x530
 ? __kasan_check_read+0x11/0x20
 ? mem_cgroup_protected+0x13d/0x260
 shrink_node+0x2a5/0xba0
 balance_pgdat+0x4bd/0x8a0
 ? mem_cgroup_shrink_node+0x490/0x490
 ? _raw_spin_unlock_irq+0x27/0x40
 ? finish_task_switch+0xce/0x390
 ? rcu_read_lock_bh_held+0xb0/0xb0
 kswapd+0x35a/0x800
 ? _raw_spin_unlock_irqrestore+0x4c/0x60
 ? balance_pgdat+0x8a0/0x8a0
 ? finish_wait+0x110/0x110
 ? __kasan_check_read+0x11/0x20
 ? __kthread_parkme+0xc6/0xe0
 ? balance_pgdat+0x8a0/0x8a0
 kthread+0x1e9/0x210
 ? kthread_create_worker_on_cpu+0xc0/0xc0
 ret_from_fork+0x3a/0x50

This is because we hold that delayed node's mutex while doing tree
operations.  Fix this by just wrapping the searches in nofs.

CC: stable@vger.kernel.org # 4.4+
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index f678980fe564..bf1595a42a98 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -6,6 +6,7 @@
 
 #include <linux/slab.h>
 #include <linux/iversion.h>
+#include <linux/sched/mm.h>
 #include "misc.h"
 #include "delayed-inode.h"
 #include "disk-io.h"
@@ -803,11 +804,14 @@ static int btrfs_insert_delayed_item(struct btrfs_trans_handle *trans,
 				     struct btrfs_delayed_item *delayed_item)
 {
 	struct extent_buffer *leaf;
+	unsigned int nofs_flag;
 	char *ptr;
 	int ret;
 
+	nofs_flag = memalloc_nofs_save();
 	ret = btrfs_insert_empty_item(trans, root, path, &delayed_item->key,
 				      delayed_item->data_len);
+	memalloc_nofs_restore(nofs_flag);
 	if (ret < 0 && ret != -EEXIST)
 		return ret;
 
@@ -935,6 +939,7 @@ static int btrfs_delete_delayed_items(struct btrfs_trans_handle *trans,
 				      struct btrfs_delayed_node *node)
 {
 	struct btrfs_delayed_item *curr, *prev;
+	unsigned int nofs_flag;
 	int ret = 0;
 
 do_again:
@@ -943,7 +948,9 @@ static int btrfs_delete_delayed_items(struct btrfs_trans_handle *trans,
 	if (!curr)
 		goto delete_fail;
 
+	nofs_flag = memalloc_nofs_save();
 	ret = btrfs_search_slot(trans, root, &curr->key, path, -1, 1);
+	memalloc_nofs_restore(nofs_flag);
 	if (ret < 0)
 		goto delete_fail;
 	else if (ret > 0) {
@@ -1010,6 +1017,7 @@ static int __btrfs_update_delayed_inode(struct btrfs_trans_handle *trans,
 	struct btrfs_key key;
 	struct btrfs_inode_item *inode_item;
 	struct extent_buffer *leaf;
+	unsigned int nofs_flag;
 	int mod;
 	int ret;
 
@@ -1022,7 +1030,9 @@ static int __btrfs_update_delayed_inode(struct btrfs_trans_handle *trans,
 	else
 		mod = 1;
 
+	nofs_flag = memalloc_nofs_save();
 	ret = btrfs_lookup_inode(trans, root, path, &key, mod);
+	memalloc_nofs_restore(nofs_flag);
 	if (ret > 0) {
 		btrfs_release_path(path);
 		return -ENOENT;
@@ -1073,7 +1083,10 @@ static int __btrfs_update_delayed_inode(struct btrfs_trans_handle *trans,
 
 	key.type = BTRFS_INODE_EXTREF_KEY;
 	key.offset = -1;
+
+	nofs_flag = memalloc_nofs_save();
 	ret = btrfs_search_slot(trans, root, &key, path, -1, 1);
+	memalloc_nofs_restore(nofs_flag);
 	if (ret < 0)
 		goto err_out;
 	ASSERT(ret);

