Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF1312D6883
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 21:19:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390073AbgLJO1e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 09:27:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:36124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390069AbgLJO1b (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Dec 2020 09:27:31 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Sterba <dsterba@suse.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 13/39] btrfs: sysfs: init devices outside of the chunk_mutex
Date:   Thu, 10 Dec 2020 15:26:24 +0100
Message-Id: <20201210142601.551238514@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201210142600.887734129@linuxfoundation.org>
References: <20201210142600.887734129@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josef Bacik <josef@toxicpanda.com>

commit ca10845a56856fff4de3804c85e6424d0f6d0cde upstream

While running btrfs/061, btrfs/073, btrfs/078, or btrfs/178 we hit the
following lockdep splat:

  ======================================================
  WARNING: possible circular locking dependency detected
  5.9.0-rc3+ #4 Not tainted
  ------------------------------------------------------
  kswapd0/100 is trying to acquire lock:
  ffff96ecc22ef4a0 (&delayed_node->mutex){+.+.}-{3:3}, at: __btrfs_release_delayed_node.part.0+0x3f/0x330

  but task is already holding lock:
  ffffffff8dd74700 (fs_reclaim){+.+.}-{0:0}, at: __fs_reclaim_acquire+0x5/0x30

  which lock already depends on the new lock.

  the existing dependency chain (in reverse order) is:

  -> #3 (fs_reclaim){+.+.}-{0:0}:
	 fs_reclaim_acquire+0x65/0x80
	 slab_pre_alloc_hook.constprop.0+0x20/0x200
	 kmem_cache_alloc+0x37/0x270
	 alloc_inode+0x82/0xb0
	 iget_locked+0x10d/0x2c0
	 kernfs_get_inode+0x1b/0x130
	 kernfs_get_tree+0x136/0x240
	 sysfs_get_tree+0x16/0x40
	 vfs_get_tree+0x28/0xc0
	 path_mount+0x434/0xc00
	 __x64_sys_mount+0xe3/0x120
	 do_syscall_64+0x33/0x40
	 entry_SYSCALL_64_after_hwframe+0x44/0xa9

  -> #2 (kernfs_mutex){+.+.}-{3:3}:
	 __mutex_lock+0x7e/0x7e0
	 kernfs_add_one+0x23/0x150
	 kernfs_create_link+0x63/0xa0
	 sysfs_do_create_link_sd+0x5e/0xd0
	 btrfs_sysfs_add_devices_dir+0x81/0x130
	 btrfs_init_new_device+0x67f/0x1250
	 btrfs_ioctl+0x1ef/0x2e20
	 __x64_sys_ioctl+0x83/0xb0
	 do_syscall_64+0x33/0x40
	 entry_SYSCALL_64_after_hwframe+0x44/0xa9

  -> #1 (&fs_info->chunk_mutex){+.+.}-{3:3}:
	 __mutex_lock+0x7e/0x7e0
	 btrfs_chunk_alloc+0x125/0x3a0
	 find_free_extent+0xdf6/0x1210
	 btrfs_reserve_extent+0xb3/0x1b0
	 btrfs_alloc_tree_block+0xb0/0x310
	 alloc_tree_block_no_bg_flush+0x4a/0x60
	 __btrfs_cow_block+0x11a/0x530
	 btrfs_cow_block+0x104/0x220
	 btrfs_search_slot+0x52e/0x9d0
	 btrfs_insert_empty_items+0x64/0xb0
	 btrfs_insert_delayed_items+0x90/0x4f0
	 btrfs_commit_inode_delayed_items+0x93/0x140
	 btrfs_log_inode+0x5de/0x2020
	 btrfs_log_inode_parent+0x429/0xc90
	 btrfs_log_new_name+0x95/0x9b
	 btrfs_rename2+0xbb9/0x1800
	 vfs_rename+0x64f/0x9f0
	 do_renameat2+0x320/0x4e0
	 __x64_sys_rename+0x1f/0x30
	 do_syscall_64+0x33/0x40
	 entry_SYSCALL_64_after_hwframe+0x44/0xa9

  -> #0 (&delayed_node->mutex){+.+.}-{3:3}:
	 __lock_acquire+0x119c/0x1fc0
	 lock_acquire+0xa7/0x3d0
	 __mutex_lock+0x7e/0x7e0
	 __btrfs_release_delayed_node.part.0+0x3f/0x330
	 btrfs_evict_inode+0x24c/0x500
	 evict+0xcf/0x1f0
	 dispose_list+0x48/0x70
	 prune_icache_sb+0x44/0x50
	 super_cache_scan+0x161/0x1e0
	 do_shrink_slab+0x178/0x3c0
	 shrink_slab+0x17c/0x290
	 shrink_node+0x2b2/0x6d0
	 balance_pgdat+0x30a/0x670
	 kswapd+0x213/0x4c0
	 kthread+0x138/0x160
	 ret_from_fork+0x1f/0x30

  other info that might help us debug this:

  Chain exists of:
    &delayed_node->mutex --> kernfs_mutex --> fs_reclaim

   Possible unsafe locking scenario:

	 CPU0                    CPU1
	 ----                    ----
    lock(fs_reclaim);
				 lock(kernfs_mutex);
				 lock(fs_reclaim);
    lock(&delayed_node->mutex);

   *** DEADLOCK ***

  3 locks held by kswapd0/100:
   #0: ffffffff8dd74700 (fs_reclaim){+.+.}-{0:0}, at: __fs_reclaim_acquire+0x5/0x30
   #1: ffffffff8dd65c50 (shrinker_rwsem){++++}-{3:3}, at: shrink_slab+0x115/0x290
   #2: ffff96ed2ade30e0 (&type->s_umount_key#36){++++}-{3:3}, at: super_cache_scan+0x38/0x1e0

  stack backtrace:
  CPU: 0 PID: 100 Comm: kswapd0 Not tainted 5.9.0-rc3+ #4
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.13.0-2.fc32 04/01/2014
  Call Trace:
   dump_stack+0x8b/0xb8
   check_noncircular+0x12d/0x150
   __lock_acquire+0x119c/0x1fc0
   lock_acquire+0xa7/0x3d0
   ? __btrfs_release_delayed_node.part.0+0x3f/0x330
   __mutex_lock+0x7e/0x7e0
   ? __btrfs_release_delayed_node.part.0+0x3f/0x330
   ? __btrfs_release_delayed_node.part.0+0x3f/0x330
   ? lock_acquire+0xa7/0x3d0
   ? find_held_lock+0x2b/0x80
   __btrfs_release_delayed_node.part.0+0x3f/0x330
   btrfs_evict_inode+0x24c/0x500
   evict+0xcf/0x1f0
   dispose_list+0x48/0x70
   prune_icache_sb+0x44/0x50
   super_cache_scan+0x161/0x1e0
   do_shrink_slab+0x178/0x3c0
   shrink_slab+0x17c/0x290
   shrink_node+0x2b2/0x6d0
   balance_pgdat+0x30a/0x670
   kswapd+0x213/0x4c0
   ? _raw_spin_unlock_irqrestore+0x41/0x50
   ? add_wait_queue_exclusive+0x70/0x70
   ? balance_pgdat+0x670/0x670
   kthread+0x138/0x160
   ? kthread_create_worker_on_cpu+0x40/0x40
   ret_from_fork+0x1f/0x30

This happens because we are holding the chunk_mutex at the time of
adding in a new device.  However we only need to hold the
device_list_mutex, as we're going to iterate over the fs_devices
devices.  Move the sysfs init stuff outside of the chunk_mutex to get
rid of this lockdep splat.

CC: stable@vger.kernel.org # 4.4.x: f3cd2c58110dad14e: btrfs: sysfs, rename device_link add/remove functions
CC: stable@vger.kernel.org # 4.4.x
Reported-by: David Sterba <dsterba@suse.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
[sudip: adjust context]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/volumes.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index cd1e9411f9269..d6383d362e271 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2357,9 +2357,6 @@ int btrfs_init_new_device(struct btrfs_root *root, char *device_path)
 	btrfs_set_super_num_devices(root->fs_info->super_copy,
 				    tmp + 1);
 
-	/* add sysfs device entry */
-	btrfs_sysfs_add_device_link(root->fs_info->fs_devices, device);
-
 	/*
 	 * we've got more storage, clear any full flags on the space
 	 * infos
@@ -2367,6 +2364,10 @@ int btrfs_init_new_device(struct btrfs_root *root, char *device_path)
 	btrfs_clear_space_info_full(root->fs_info);
 
 	unlock_chunks(root);
+
+	/* add sysfs device entry */
+	btrfs_sysfs_add_device_link(root->fs_info->fs_devices, device);
+
 	mutex_unlock(&root->fs_info->fs_devices->device_list_mutex);
 
 	if (seeding_dev) {
-- 
2.27.0



