Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C1BB769E0
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 15:55:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728328AbfGZNys (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 09:54:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:49988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387994AbfGZNml (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jul 2019 09:42:41 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D413522BF5;
        Fri, 26 Jul 2019 13:42:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564148559;
        bh=DTIc6VTaVNjMmBBwFovbYHvA1Ed9uQq49OveYm5vSnI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CbFbX2f3cJwzV5rPsbYeF20N9+7Bcet+QwHU26j5NmGQ5bxyLcttn79Z5MyhiFRnL
         JJbPehWg85jMuCJ8DgJCvzfY+ls1/oKkD+Y5UPMws7zMq+6JNK9Gne7T/6IbVAtKJQ
         j2Ibgdaj8+MjufKlnMxHvRM45Djfrf6Jm1kuTqmk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qu Wenruo <wqu@suse.com>, Nikolay Borisov <nborisov@suse.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 16/47] btrfs: qgroup: Don't hold qgroup_ioctl_lock in btrfs_qgroup_inherit()
Date:   Fri, 26 Jul 2019 09:41:39 -0400
Message-Id: <20190726134210.12156-16-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190726134210.12156-1-sashal@kernel.org>
References: <20190726134210.12156-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qu Wenruo <wqu@suse.com>

[ Upstream commit e88439debd0a7f969b3ddba6f147152cd0732676 ]

[BUG]
Lockdep will report the following circular locking dependency:

  WARNING: possible circular locking dependency detected
  5.2.0-rc2-custom #24 Tainted: G           O
  ------------------------------------------------------
  btrfs/8631 is trying to acquire lock:
  000000002536438c (&fs_info->qgroup_ioctl_lock#2){+.+.}, at: btrfs_qgroup_inherit+0x40/0x620 [btrfs]

  but task is already holding lock:
  000000003d52cc23 (&fs_info->tree_log_mutex){+.+.}, at: create_pending_snapshot+0x8b6/0xe60 [btrfs]

  which lock already depends on the new lock.

  the existing dependency chain (in reverse order) is:

  -> #2 (&fs_info->tree_log_mutex){+.+.}:
         __mutex_lock+0x76/0x940
         mutex_lock_nested+0x1b/0x20
         btrfs_commit_transaction+0x475/0xa00 [btrfs]
         btrfs_commit_super+0x71/0x80 [btrfs]
         close_ctree+0x2bd/0x320 [btrfs]
         btrfs_put_super+0x15/0x20 [btrfs]
         generic_shutdown_super+0x72/0x110
         kill_anon_super+0x18/0x30
         btrfs_kill_super+0x16/0xa0 [btrfs]
         deactivate_locked_super+0x3a/0x80
         deactivate_super+0x51/0x60
         cleanup_mnt+0x3f/0x80
         __cleanup_mnt+0x12/0x20
         task_work_run+0x94/0xb0
         exit_to_usermode_loop+0xd8/0xe0
         do_syscall_64+0x210/0x240
         entry_SYSCALL_64_after_hwframe+0x49/0xbe

  -> #1 (&fs_info->reloc_mutex){+.+.}:
         __mutex_lock+0x76/0x940
         mutex_lock_nested+0x1b/0x20
         btrfs_commit_transaction+0x40d/0xa00 [btrfs]
         btrfs_quota_enable+0x2da/0x730 [btrfs]
         btrfs_ioctl+0x2691/0x2b40 [btrfs]
         do_vfs_ioctl+0xa9/0x6d0
         ksys_ioctl+0x67/0x90
         __x64_sys_ioctl+0x1a/0x20
         do_syscall_64+0x65/0x240
         entry_SYSCALL_64_after_hwframe+0x49/0xbe

  -> #0 (&fs_info->qgroup_ioctl_lock#2){+.+.}:
         lock_acquire+0xa7/0x190
         __mutex_lock+0x76/0x940
         mutex_lock_nested+0x1b/0x20
         btrfs_qgroup_inherit+0x40/0x620 [btrfs]
         create_pending_snapshot+0x9d7/0xe60 [btrfs]
         create_pending_snapshots+0x94/0xb0 [btrfs]
         btrfs_commit_transaction+0x415/0xa00 [btrfs]
         btrfs_mksubvol+0x496/0x4e0 [btrfs]
         btrfs_ioctl_snap_create_transid+0x174/0x180 [btrfs]
         btrfs_ioctl_snap_create_v2+0x11c/0x180 [btrfs]
         btrfs_ioctl+0xa90/0x2b40 [btrfs]
         do_vfs_ioctl+0xa9/0x6d0
         ksys_ioctl+0x67/0x90
         __x64_sys_ioctl+0x1a/0x20
         do_syscall_64+0x65/0x240
         entry_SYSCALL_64_after_hwframe+0x49/0xbe

  other info that might help us debug this:

  Chain exists of:
    &fs_info->qgroup_ioctl_lock#2 --> &fs_info->reloc_mutex --> &fs_info->tree_log_mutex

   Possible unsafe locking scenario:

         CPU0                    CPU1
         ----                    ----
    lock(&fs_info->tree_log_mutex);
                                 lock(&fs_info->reloc_mutex);
                                 lock(&fs_info->tree_log_mutex);
    lock(&fs_info->qgroup_ioctl_lock#2);

   *** DEADLOCK ***

  6 locks held by btrfs/8631:
   #0: 00000000ed8f23f6 (sb_writers#12){.+.+}, at: mnt_want_write_file+0x28/0x60
   #1: 000000009fb1597a (&type->i_mutex_dir_key#10/1){+.+.}, at: btrfs_mksubvol+0x70/0x4e0 [btrfs]
   #2: 0000000088c5ad88 (&fs_info->subvol_sem){++++}, at: btrfs_mksubvol+0x128/0x4e0 [btrfs]
   #3: 000000009606fc3e (sb_internal#2){.+.+}, at: start_transaction+0x37a/0x520 [btrfs]
   #4: 00000000f82bbdf5 (&fs_info->reloc_mutex){+.+.}, at: btrfs_commit_transaction+0x40d/0xa00 [btrfs]
   #5: 000000003d52cc23 (&fs_info->tree_log_mutex){+.+.}, at: create_pending_snapshot+0x8b6/0xe60 [btrfs]

[CAUSE]
Due to the delayed subvolume creation, we need to call
btrfs_qgroup_inherit() inside commit transaction code, with a lot of
other mutex hold.
This hell of lock chain can lead to above problem.

[FIX]
On the other hand, we don't really need to hold qgroup_ioctl_lock if
we're in the context of create_pending_snapshot().
As in that context, we're the only one being able to modify qgroup.

All other qgroup functions which needs qgroup_ioctl_lock are either
holding a transaction handle, or will start a new transaction:
  Functions will start a new transaction():
  * btrfs_quota_enable()
  * btrfs_quota_disable()
  Functions hold a transaction handler:
  * btrfs_add_qgroup_relation()
  * btrfs_del_qgroup_relation()
  * btrfs_create_qgroup()
  * btrfs_remove_qgroup()
  * btrfs_limit_qgroup()
  * btrfs_qgroup_inherit() call inside create_subvol()

So we have a higher level protection provided by transaction, thus we
don't need to always hold qgroup_ioctl_lock in btrfs_qgroup_inherit().

Only the btrfs_qgroup_inherit() call in create_subvol() needs to hold
qgroup_ioctl_lock, while the btrfs_qgroup_inherit() call in
create_pending_snapshot() is already protected by transaction.

So the fix is to detect the context by checking
trans->transaction->state.
If we're at TRANS_STATE_COMMIT_DOING, then we're in commit transaction
context and no need to get the mutex.

Reported-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/qgroup.c | 24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index e46e83e87600..734866ab5194 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -2249,6 +2249,7 @@ int btrfs_qgroup_inherit(struct btrfs_trans_handle *trans, u64 srcid,
 	int ret = 0;
 	int i;
 	u64 *i_qgroups;
+	bool committing = false;
 	struct btrfs_fs_info *fs_info = trans->fs_info;
 	struct btrfs_root *quota_root;
 	struct btrfs_qgroup *srcgroup;
@@ -2256,7 +2257,25 @@ int btrfs_qgroup_inherit(struct btrfs_trans_handle *trans, u64 srcid,
 	u32 level_size = 0;
 	u64 nums;
 
-	mutex_lock(&fs_info->qgroup_ioctl_lock);
+	/*
+	 * There are only two callers of this function.
+	 *
+	 * One in create_subvol() in the ioctl context, which needs to hold
+	 * the qgroup_ioctl_lock.
+	 *
+	 * The other one in create_pending_snapshot() where no other qgroup
+	 * code can modify the fs as they all need to either start a new trans
+	 * or hold a trans handler, thus we don't need to hold
+	 * qgroup_ioctl_lock.
+	 * This would avoid long and complex lock chain and make lockdep happy.
+	 */
+	spin_lock(&fs_info->trans_lock);
+	if (trans->transaction->state == TRANS_STATE_COMMIT_DOING)
+		committing = true;
+	spin_unlock(&fs_info->trans_lock);
+
+	if (!committing)
+		mutex_lock(&fs_info->qgroup_ioctl_lock);
 	if (!test_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags))
 		goto out;
 
@@ -2420,7 +2439,8 @@ int btrfs_qgroup_inherit(struct btrfs_trans_handle *trans, u64 srcid,
 unlock:
 	spin_unlock(&fs_info->qgroup_lock);
 out:
-	mutex_unlock(&fs_info->qgroup_ioctl_lock);
+	if (!committing)
+		mutex_unlock(&fs_info->qgroup_ioctl_lock);
 	return ret;
 }
 
-- 
2.20.1

