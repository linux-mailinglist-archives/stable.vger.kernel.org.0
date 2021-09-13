Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6592C40A06F
	for <lists+stable@lfdr.de>; Tue, 14 Sep 2021 00:38:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349354AbhIMWjK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 18:39:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:51058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348590AbhIMWhK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 18:37:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C96E361244;
        Mon, 13 Sep 2021 22:35:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631572512;
        bh=wRwm4+eOwbfg1VAQhYMF0xT/PRQJ2jWWPwpd4DP+qa4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TpanLh4xq+7tvBbaT9IxI/bCdqITYpXK8/3tbL2yAO7Jj55ACs1JTE87bp+5Jg9As
         IX5nmMhn+E6/bFBS2gfdb+aGgNVnXEUXnfmYcgBgjOH1TMwi3DYoSWA2gZNnZ1tPIR
         b/Yj/ltyzdpI+rmic36IzRL7HyfpG+/+IXV7zYI9aU1eOSVYOpHAgdLjZcD0UZQkC4
         7csA4tORf93e3FD4LpJHttsPXyXrwaygE2BRIiChxjX/fLNFi1jZEIiKBhNApgJghx
         VCq8aVmBsQeeuYzOSB1MkoBqauorC5rGOiavDay1iI/5np74PBc99atOK6DsXpcQYK
         ufmUAnj0JftwA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Anand Jain <anand.jain@oracle.com>, Su Yue <l@damenly.su>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 06/12] btrfs: fix lockdep warning while mounting sprout fs
Date:   Mon, 13 Sep 2021 18:34:58 -0400
Message-Id: <20210913223504.436087-6-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210913223504.436087-1-sashal@kernel.org>
References: <20210913223504.436087-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anand Jain <anand.jain@oracle.com>

[ Upstream commit c124706900c20dee70f921bb3a90492431561a0a ]

Following test case reproduces lockdep warning.

  Test case:

  $ mkfs.btrfs -f <dev1>
  $ btrfstune -S 1 <dev1>
  $ mount <dev1> <mnt>
  $ btrfs device add <dev2> <mnt> -f
  $ umount <mnt>
  $ mount <dev2> <mnt>
  $ umount <mnt>

The warning claims a possible ABBA deadlock between the threads
initiated by [#1] btrfs device add and [#0] the mount.

  [ 540.743122] WARNING: possible circular locking dependency detected
  [ 540.743129] 5.11.0-rc7+ #5 Not tainted
  [ 540.743135] ------------------------------------------------------
  [ 540.743142] mount/2515 is trying to acquire lock:
  [ 540.743149] ffffa0c5544c2ce0 (&fs_devs->device_list_mutex){+.+.}-{4:4}, at: clone_fs_devices+0x6d/0x210 [btrfs]
  [ 540.743458] but task is already holding lock:
  [ 540.743461] ffffa0c54a7932b8 (btrfs-chunk-00){++++}-{4:4}, at: __btrfs_tree_read_lock+0x32/0x200 [btrfs]
  [ 540.743541] which lock already depends on the new lock.
  [ 540.743543] the existing dependency chain (in reverse order) is:

  [ 540.743546] -> #1 (btrfs-chunk-00){++++}-{4:4}:
  [ 540.743566] down_read_nested+0x48/0x2b0
  [ 540.743585] __btrfs_tree_read_lock+0x32/0x200 [btrfs]
  [ 540.743650] btrfs_read_lock_root_node+0x70/0x200 [btrfs]
  [ 540.743733] btrfs_search_slot+0x6c6/0xe00 [btrfs]
  [ 540.743785] btrfs_update_device+0x83/0x260 [btrfs]
  [ 540.743849] btrfs_finish_chunk_alloc+0x13f/0x660 [btrfs] <--- device_list_mutex
  [ 540.743911] btrfs_create_pending_block_groups+0x18d/0x3f0 [btrfs]
  [ 540.743982] btrfs_commit_transaction+0x86/0x1260 [btrfs]
  [ 540.744037] btrfs_init_new_device+0x1600/0x1dd0 [btrfs]
  [ 540.744101] btrfs_ioctl+0x1c77/0x24c0 [btrfs]
  [ 540.744166] __x64_sys_ioctl+0xe4/0x140
  [ 540.744170] do_syscall_64+0x4b/0x80
  [ 540.744174] entry_SYSCALL_64_after_hwframe+0x44/0xa9

  [ 540.744180] -> #0 (&fs_devs->device_list_mutex){+.+.}-{4:4}:
  [ 540.744184] __lock_acquire+0x155f/0x2360
  [ 540.744188] lock_acquire+0x10b/0x5c0
  [ 540.744190] __mutex_lock+0xb1/0xf80
  [ 540.744193] mutex_lock_nested+0x27/0x30
  [ 540.744196] clone_fs_devices+0x6d/0x210 [btrfs]
  [ 540.744270] btrfs_read_chunk_tree+0x3c7/0xbb0 [btrfs]
  [ 540.744336] open_ctree+0xf6e/0x2074 [btrfs]
  [ 540.744406] btrfs_mount_root.cold.72+0x16/0x127 [btrfs]
  [ 540.744472] legacy_get_tree+0x38/0x90
  [ 540.744475] vfs_get_tree+0x30/0x140
  [ 540.744478] fc_mount+0x16/0x60
  [ 540.744482] vfs_kern_mount+0x91/0x100
  [ 540.744484] btrfs_mount+0x1e6/0x670 [btrfs]
  [ 540.744536] legacy_get_tree+0x38/0x90
  [ 540.744537] vfs_get_tree+0x30/0x140
  [ 540.744539] path_mount+0x8d8/0x1070
  [ 540.744541] do_mount+0x8d/0xc0
  [ 540.744543] __x64_sys_mount+0x125/0x160
  [ 540.744545] do_syscall_64+0x4b/0x80
  [ 540.744547] entry_SYSCALL_64_after_hwframe+0x44/0xa9

  [ 540.744551] other info that might help us debug this:
  [ 540.744552] Possible unsafe locking scenario:

  [ 540.744553] CPU0 				CPU1
  [ 540.744554] ---- 				----
  [ 540.744555] lock(btrfs-chunk-00);
  [ 540.744557] 					lock(&fs_devs->device_list_mutex);
  [ 540.744560] 					lock(btrfs-chunk-00);
  [ 540.744562] lock(&fs_devs->device_list_mutex);
  [ 540.744564]
   *** DEADLOCK ***

  [ 540.744565] 3 locks held by mount/2515:
  [ 540.744567] #0: ffffa0c56bf7a0e0 (&type->s_umount_key#42/1){+.+.}-{4:4}, at: alloc_super.isra.16+0xdf/0x450
  [ 540.744574] #1: ffffffffc05a9628 (uuid_mutex){+.+.}-{4:4}, at: btrfs_read_chunk_tree+0x63/0xbb0 [btrfs]
  [ 540.744640] #2: ffffa0c54a7932b8 (btrfs-chunk-00){++++}-{4:4}, at: __btrfs_tree_read_lock+0x32/0x200 [btrfs]
  [ 540.744708]
   stack backtrace:
  [ 540.744712] CPU: 2 PID: 2515 Comm: mount Not tainted 5.11.0-rc7+ #5

But the device_list_mutex in clone_fs_devices() is redundant, as
explained below.  Two threads [1]  and [2] (below) could lead to
clone_fs_device().

  [1]
  open_ctree <== mount sprout fs
   btrfs_read_chunk_tree()
    mutex_lock(&uuid_mutex) <== global lock
    read_one_dev()
     open_seed_devices()
      clone_fs_devices() <== seed fs_devices
       mutex_lock(&orig->device_list_mutex) <== seed fs_devices

  [2]
  btrfs_init_new_device() <== sprouting
   mutex_lock(&uuid_mutex); <== global lock
   btrfs_prepare_sprout()
     lockdep_assert_held(&uuid_mutex)
     clone_fs_devices(seed_fs_device) <== seed fs_devices

Both of these threads hold uuid_mutex which is sufficient to protect
getting the seed device(s) freed while we are trying to clone it for
sprouting [2] or mounting a sprout [1] (as above). A mounted seed device
can not free/write/replace because it is read-only. An unmounted seed
device can be freed by btrfs_free_stale_devices(), but it needs
uuid_mutex.  So this patch removes the unnecessary device_list_mutex in
clone_fs_devices().  And adds a lockdep_assert_held(&uuid_mutex) in
clone_fs_devices().

Reported-by: Su Yue <l@damenly.su>
Tested-by: Su Yue <l@damenly.su>
Signed-off-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/volumes.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index e882c790292f..4851e1e7ea35 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -742,6 +742,8 @@ static int btrfs_free_stale_devices(const char *path,
 	struct btrfs_device *device, *tmp_device;
 	int ret = 0;
 
+	lockdep_assert_held(&uuid_mutex);
+
 	if (path)
 		ret = -ENOENT;
 
@@ -1181,11 +1183,12 @@ static struct btrfs_fs_devices *clone_fs_devices(struct btrfs_fs_devices *orig)
 	struct btrfs_device *orig_dev;
 	int ret = 0;
 
+	lockdep_assert_held(&uuid_mutex);
+
 	fs_devices = alloc_fs_devices(orig->fsid, NULL);
 	if (IS_ERR(fs_devices))
 		return fs_devices;
 
-	mutex_lock(&orig->device_list_mutex);
 	fs_devices->total_devices = orig->total_devices;
 
 	list_for_each_entry(orig_dev, &orig->devices, dev_list) {
@@ -1217,10 +1220,8 @@ static struct btrfs_fs_devices *clone_fs_devices(struct btrfs_fs_devices *orig)
 		device->fs_devices = fs_devices;
 		fs_devices->num_devices++;
 	}
-	mutex_unlock(&orig->device_list_mutex);
 	return fs_devices;
 error:
-	mutex_unlock(&orig->device_list_mutex);
 	free_fs_devices(fs_devices);
 	return ERR_PTR(ret);
 }
-- 
2.30.2

