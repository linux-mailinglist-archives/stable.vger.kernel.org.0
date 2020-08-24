Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2AB124F7BC
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 11:21:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728478AbgHXJVI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 05:21:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:38386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730230AbgHXIzu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 04:55:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 334AA204FD;
        Mon, 24 Aug 2020 08:55:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598259347;
        bh=TOH0XfetC5x5cPnPlP3/ST+07xfAaN/CKrgzAfroaaQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZmvNwKgvDy5WnzJGDwgBdqLmCIETga1x8nXBXGH7wUX7xXd1h/K/y2pQExqv3VycI
         SCR9WQ/4/En8zwsisKvLTaHX5+yJyd6zEpYwgDyBExM52vNOLxO9wRyDoVJG5ogNLl
         COiIO+ubBnCVBoXRMgW8SKYeQilB2YXOXirwUu0I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Sterba <dsterba@suse.com>,
        Josef Bacik <josef@toxicpanda.com>
Subject: [PATCH 4.19 09/71] btrfs: sysfs: use NOFS for device creation
Date:   Mon, 24 Aug 2020 10:31:00 +0200
Message-Id: <20200824082356.348762357@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200824082355.848475917@linuxfoundation.org>
References: <20200824082355.848475917@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josef Bacik <josef@toxicpanda.com>

Dave hit this splat during testing btrfs/078:

  ======================================================
  WARNING: possible circular locking dependency detected
  5.8.0-rc6-default+ #1191 Not tainted
  ------------------------------------------------------
  kswapd0/75 is trying to acquire lock:
  ffffa040e9d04ff8 (&delayed_node->mutex){+.+.}-{3:3}, at: __btrfs_release_delayed_node.part.0+0x3f/0x310 [btrfs]

  but task is already holding lock:
  ffffffff8b0c8040 (fs_reclaim){+.+.}-{0:0}, at: __fs_reclaim_acquire+0x5/0x30

  which lock already depends on the new lock.

  the existing dependency chain (in reverse order) is:

  -> #2 (fs_reclaim){+.+.}-{0:0}:
	 __lock_acquire+0x56f/0xaa0
	 lock_acquire+0xa3/0x440
	 fs_reclaim_acquire.part.0+0x25/0x30
	 __kmalloc_track_caller+0x49/0x330
	 kstrdup+0x2e/0x60
	 __kernfs_new_node.constprop.0+0x44/0x250
	 kernfs_new_node+0x25/0x50
	 kernfs_create_link+0x34/0xa0
	 sysfs_do_create_link_sd+0x5e/0xd0
	 btrfs_sysfs_add_devices_dir+0x65/0x100 [btrfs]
	 btrfs_init_new_device+0x44c/0x12b0 [btrfs]
	 btrfs_ioctl+0xc3c/0x25c0 [btrfs]
	 ksys_ioctl+0x68/0xa0
	 __x64_sys_ioctl+0x16/0x20
	 do_syscall_64+0x50/0xe0
	 entry_SYSCALL_64_after_hwframe+0x44/0xa9

  -> #1 (&fs_info->chunk_mutex){+.+.}-{3:3}:
	 __lock_acquire+0x56f/0xaa0
	 lock_acquire+0xa3/0x440
	 __mutex_lock+0xa0/0xaf0
	 btrfs_chunk_alloc+0x137/0x3e0 [btrfs]
	 find_free_extent+0xb44/0xfb0 [btrfs]
	 btrfs_reserve_extent+0x9b/0x180 [btrfs]
	 btrfs_alloc_tree_block+0xc1/0x350 [btrfs]
	 alloc_tree_block_no_bg_flush+0x4a/0x60 [btrfs]
	 __btrfs_cow_block+0x143/0x7a0 [btrfs]
	 btrfs_cow_block+0x15f/0x310 [btrfs]
	 push_leaf_right+0x150/0x240 [btrfs]
	 split_leaf+0x3cd/0x6d0 [btrfs]
	 btrfs_search_slot+0xd14/0xf70 [btrfs]
	 btrfs_insert_empty_items+0x64/0xc0 [btrfs]
	 __btrfs_commit_inode_delayed_items+0xb2/0x840 [btrfs]
	 btrfs_async_run_delayed_root+0x10e/0x1d0 [btrfs]
	 btrfs_work_helper+0x2f9/0x650 [btrfs]
	 process_one_work+0x22c/0x600
	 worker_thread+0x50/0x3b0
	 kthread+0x137/0x150
	 ret_from_fork+0x1f/0x30

  -> #0 (&delayed_node->mutex){+.+.}-{3:3}:
	 check_prev_add+0x98/0xa20
	 validate_chain+0xa8c/0x2a00
	 __lock_acquire+0x56f/0xaa0
	 lock_acquire+0xa3/0x440
	 __mutex_lock+0xa0/0xaf0
	 __btrfs_release_delayed_node.part.0+0x3f/0x310 [btrfs]
	 btrfs_evict_inode+0x3bf/0x560 [btrfs]
	 evict+0xd6/0x1c0
	 dispose_list+0x48/0x70
	 prune_icache_sb+0x54/0x80
	 super_cache_scan+0x121/0x1a0
	 do_shrink_slab+0x175/0x420
	 shrink_slab+0xb1/0x2e0
	 shrink_node+0x192/0x600
	 balance_pgdat+0x31f/0x750
	 kswapd+0x206/0x510
	 kthread+0x137/0x150
	 ret_from_fork+0x1f/0x30

  other info that might help us debug this:

  Chain exists of:
    &delayed_node->mutex --> &fs_info->chunk_mutex --> fs_reclaim

   Possible unsafe locking scenario:

	 CPU0                    CPU1
	 ----                    ----
    lock(fs_reclaim);
				 lock(&fs_info->chunk_mutex);
				 lock(fs_reclaim);
    lock(&delayed_node->mutex);

   *** DEADLOCK ***

  3 locks held by kswapd0/75:
   #0: ffffffff8b0c8040 (fs_reclaim){+.+.}-{0:0}, at: __fs_reclaim_acquire+0x5/0x30
   #1: ffffffff8b0b50b8 (shrinker_rwsem){++++}-{3:3}, at: shrink_slab+0x54/0x2e0
   #2: ffffa040e057c0e8 (&type->s_umount_key#26){++++}-{3:3}, at: trylock_super+0x16/0x50

  stack backtrace:
  CPU: 2 PID: 75 Comm: kswapd0 Not tainted 5.8.0-rc6-default+ #1191
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.12.0-59-gc9ba527-rebuilt.opensuse.org 04/01/2014
  Call Trace:
   dump_stack+0x78/0xa0
   check_noncircular+0x16f/0x190
   check_prev_add+0x98/0xa20
   validate_chain+0xa8c/0x2a00
   __lock_acquire+0x56f/0xaa0
   lock_acquire+0xa3/0x440
   ? __btrfs_release_delayed_node.part.0+0x3f/0x310 [btrfs]
   __mutex_lock+0xa0/0xaf0
   ? __btrfs_release_delayed_node.part.0+0x3f/0x310 [btrfs]
   ? __lock_acquire+0x56f/0xaa0
   ? __btrfs_release_delayed_node.part.0+0x3f/0x310 [btrfs]
   ? lock_acquire+0xa3/0x440
   ? btrfs_evict_inode+0x138/0x560 [btrfs]
   ? btrfs_evict_inode+0x2fe/0x560 [btrfs]
   ? __btrfs_release_delayed_node.part.0+0x3f/0x310 [btrfs]
   __btrfs_release_delayed_node.part.0+0x3f/0x310 [btrfs]
   btrfs_evict_inode+0x3bf/0x560 [btrfs]
   evict+0xd6/0x1c0
   dispose_list+0x48/0x70
   prune_icache_sb+0x54/0x80
   super_cache_scan+0x121/0x1a0
   do_shrink_slab+0x175/0x420
   shrink_slab+0xb1/0x2e0
   shrink_node+0x192/0x600
   balance_pgdat+0x31f/0x750
   kswapd+0x206/0x510
   ? _raw_spin_unlock_irqrestore+0x3e/0x50
   ? finish_wait+0x90/0x90
   ? balance_pgdat+0x750/0x750
   kthread+0x137/0x150
   ? kthread_stop+0x2a0/0x2a0
   ret_from_fork+0x1f/0x30

This is because we're holding the chunk_mutex while adding this device
and adding its sysfs entries.  We actually hold different locks in
different places when calling this function, the dev_replace semaphore
for instance in dev replace, so instead of moving this call around
simply wrap it's operations in NOFS.

CC: stable@vger.kernel.org # 4.14+
Reported-by: David Sterba <dsterba@suse.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/sysfs.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index aefb0169d46d7..afec808a763b1 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -10,6 +10,7 @@
 #include <linux/kobject.h>
 #include <linux/bug.h>
 #include <linux/debugfs.h>
+#include <linux/sched/mm.h>
 
 #include "ctree.h"
 #include "disk-io.h"
@@ -766,7 +767,9 @@ int btrfs_sysfs_add_device_link(struct btrfs_fs_devices *fs_devices,
 {
 	int error = 0;
 	struct btrfs_device *dev;
+	unsigned int nofs_flag;
 
+	nofs_flag = memalloc_nofs_save();
 	list_for_each_entry(dev, &fs_devices->devices, dev_list) {
 		struct hd_struct *disk;
 		struct kobject *disk_kobj;
@@ -785,6 +788,7 @@ int btrfs_sysfs_add_device_link(struct btrfs_fs_devices *fs_devices,
 		if (error)
 			break;
 	}
+	memalloc_nofs_restore(nofs_flag);
 
 	return error;
 }
-- 
2.25.1



