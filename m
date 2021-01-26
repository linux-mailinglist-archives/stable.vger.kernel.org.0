Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E927B304B85
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 22:28:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726545AbhAZEmX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 23:42:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:58348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727093AbhAYSm3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:42:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2886B22D58;
        Mon, 25 Jan 2021 18:41:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600091;
        bh=GWw0fXgZDQAzfnrpZENeGM09c0xmMp2QFGbeH534L6k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GRC1h+qXpWZhzey6/eX05vvRgLmXnBiLkrEixnGHUsYnrMm1QuORyvHU/2zT2TCMR
         CoNBErsqUPpBqD3K/eF/wqwKCDZUTHRLvdwzodtU+4j8crmKSidbK4NOcxQGkJBboD
         UsdsPBUO3sb54jrivF4hh+GNHvV+/WVb4ekPex7w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qu Wenruo <wqu@suse.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 4.19 05/58] btrfs: fix lockdep splat in btrfs_recover_relocation
Date:   Mon, 25 Jan 2021 19:39:06 +0100
Message-Id: <20210125183156.928639401@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183156.702907356@linuxfoundation.org>
References: <20210125183156.702907356@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josef Bacik <josef@toxicpanda.com>

commit fb286100974e7239af243bc2255a52f29442f9c8 upstream.

While testing the error paths of relocation I hit the following lockdep
splat:

  ======================================================
  WARNING: possible circular locking dependency detected
  5.10.0-rc6+ #217 Not tainted
  ------------------------------------------------------
  mount/779 is trying to acquire lock:
  ffffa0e676945418 (&fs_info->balance_mutex){+.+.}-{3:3}, at: btrfs_recover_balance+0x2f0/0x340

  but task is already holding lock:
  ffffa0e60ee31da8 (btrfs-root-00){++++}-{3:3}, at: __btrfs_tree_read_lock+0x27/0x100

  which lock already depends on the new lock.

  the existing dependency chain (in reverse order) is:

  -> #2 (btrfs-root-00){++++}-{3:3}:
	 down_read_nested+0x43/0x130
	 __btrfs_tree_read_lock+0x27/0x100
	 btrfs_read_lock_root_node+0x31/0x40
	 btrfs_search_slot+0x462/0x8f0
	 btrfs_update_root+0x55/0x2b0
	 btrfs_drop_snapshot+0x398/0x750
	 clean_dirty_subvols+0xdf/0x120
	 btrfs_recover_relocation+0x534/0x5a0
	 btrfs_start_pre_rw_mount+0xcb/0x170
	 open_ctree+0x151f/0x1726
	 btrfs_mount_root.cold+0x12/0xea
	 legacy_get_tree+0x30/0x50
	 vfs_get_tree+0x28/0xc0
	 vfs_kern_mount.part.0+0x71/0xb0
	 btrfs_mount+0x10d/0x380
	 legacy_get_tree+0x30/0x50
	 vfs_get_tree+0x28/0xc0
	 path_mount+0x433/0xc10
	 __x64_sys_mount+0xe3/0x120
	 do_syscall_64+0x33/0x40
	 entry_SYSCALL_64_after_hwframe+0x44/0xa9

  -> #1 (sb_internal#2){.+.+}-{0:0}:
	 start_transaction+0x444/0x700
	 insert_balance_item.isra.0+0x37/0x320
	 btrfs_balance+0x354/0xf40
	 btrfs_ioctl_balance+0x2cf/0x380
	 __x64_sys_ioctl+0x83/0xb0
	 do_syscall_64+0x33/0x40
	 entry_SYSCALL_64_after_hwframe+0x44/0xa9

  -> #0 (&fs_info->balance_mutex){+.+.}-{3:3}:
	 __lock_acquire+0x1120/0x1e10
	 lock_acquire+0x116/0x370
	 __mutex_lock+0x7e/0x7b0
	 btrfs_recover_balance+0x2f0/0x340
	 open_ctree+0x1095/0x1726
	 btrfs_mount_root.cold+0x12/0xea
	 legacy_get_tree+0x30/0x50
	 vfs_get_tree+0x28/0xc0
	 vfs_kern_mount.part.0+0x71/0xb0
	 btrfs_mount+0x10d/0x380
	 legacy_get_tree+0x30/0x50
	 vfs_get_tree+0x28/0xc0
	 path_mount+0x433/0xc10
	 __x64_sys_mount+0xe3/0x120
	 do_syscall_64+0x33/0x40
	 entry_SYSCALL_64_after_hwframe+0x44/0xa9

  other info that might help us debug this:

  Chain exists of:
    &fs_info->balance_mutex --> sb_internal#2 --> btrfs-root-00

   Possible unsafe locking scenario:

	 CPU0                    CPU1
	 ----                    ----
    lock(btrfs-root-00);
				 lock(sb_internal#2);
				 lock(btrfs-root-00);
    lock(&fs_info->balance_mutex);

   *** DEADLOCK ***

  2 locks held by mount/779:
   #0: ffffa0e60dc040e0 (&type->s_umount_key#47/1){+.+.}-{3:3}, at: alloc_super+0xb5/0x380
   #1: ffffa0e60ee31da8 (btrfs-root-00){++++}-{3:3}, at: __btrfs_tree_read_lock+0x27/0x100

  stack backtrace:
  CPU: 0 PID: 779 Comm: mount Not tainted 5.10.0-rc6+ #217
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.13.0-2.fc32 04/01/2014
  Call Trace:
   dump_stack+0x8b/0xb0
   check_noncircular+0xcf/0xf0
   ? trace_call_bpf+0x139/0x260
   __lock_acquire+0x1120/0x1e10
   lock_acquire+0x116/0x370
   ? btrfs_recover_balance+0x2f0/0x340
   __mutex_lock+0x7e/0x7b0
   ? btrfs_recover_balance+0x2f0/0x340
   ? btrfs_recover_balance+0x2f0/0x340
   ? rcu_read_lock_sched_held+0x3f/0x80
   ? kmem_cache_alloc_trace+0x2c4/0x2f0
   ? btrfs_get_64+0x5e/0x100
   btrfs_recover_balance+0x2f0/0x340
   open_ctree+0x1095/0x1726
   btrfs_mount_root.cold+0x12/0xea
   ? rcu_read_lock_sched_held+0x3f/0x80
   legacy_get_tree+0x30/0x50
   vfs_get_tree+0x28/0xc0
   vfs_kern_mount.part.0+0x71/0xb0
   btrfs_mount+0x10d/0x380
   ? __kmalloc_track_caller+0x2f2/0x320
   legacy_get_tree+0x30/0x50
   vfs_get_tree+0x28/0xc0
   ? capable+0x3a/0x60
   path_mount+0x433/0xc10
   __x64_sys_mount+0xe3/0x120
   do_syscall_64+0x33/0x40
   entry_SYSCALL_64_after_hwframe+0x44/0xa9

This is straightforward to fix, simply release the path before we setup
the balance_ctl.

CC: stable@vger.kernel.org # 4.4+
Reviewed-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/volumes.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -4011,6 +4011,8 @@ int btrfs_recover_balance(struct btrfs_f
 		btrfs_warn(fs_info,
 	"balance: cannot set exclusive op status, resume manually");
 
+	btrfs_release_path(path);
+
 	mutex_lock(&fs_info->balance_mutex);
 	BUG_ON(fs_info->balance_ctl);
 	spin_lock(&fs_info->balance_lock);


