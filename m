Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EF9220E74C
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 00:10:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730565AbgF2V4A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 17:56:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:56910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726527AbgF2Sfb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 14:35:31 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 529C6247A6;
        Mon, 29 Jun 2020 15:21:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444113;
        bh=Ib9uaJRwu7PjqRSULrc/RVTtx7kBtkPd2bYReuBdmiw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=od/lhvwic35ZIzVtwELwGO1Yta+QciAMEMAF5lcfAc5wDAQESoqTUkVaoRdLzGsqb
         WSdGs8Jkbom58nJBXQO+SyMsv2JF/OQROe4wzmu3p3HSqfdSioDo/ZUyrfGCZcKX2t
         0XDEBcpTRxyMXGhtNdqFi7gwz5CJ26aLQlTNG5eA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Filipe Manana <fdmanana@suse.com>,
        kernel test robot <rong.a.chen@intel.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.7 224/265] btrfs: check if a log root exists before locking the log_mutex on unlink
Date:   Mon, 29 Jun 2020 11:17:37 -0400
Message-Id: <20200629151818.2493727-225-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629151818.2493727-1-sashal@kernel.org>
References: <20200629151818.2493727-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.7-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.7.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.7.7-rc1
X-KernelTest-Deadline: 2020-07-01T15:14+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

commit e7a79811d0db136dc2d336b56d54cf1b774ce972 upstream.

This brings back an optimization that commit e678934cbe5f02 ("btrfs:
Remove unnecessary check from join_running_log_trans") removed, but in
a different form. So it's almost equivalent to a revert.

That commit removed an optimization where we avoid locking a root's
log_mutex when there is no log tree created in the current transaction.
The affected code path is triggered through unlink operations.

That commit was based on the assumption that the optimization was not
necessary because we used to have the following checks when the patch
was authored:

  int btrfs_del_dir_entries_in_log(...)
  {
        (...)
        if (dir->logged_trans < trans->transid)
            return 0;

        ret = join_running_log_trans(root);
        (...)
   }

   int btrfs_del_inode_ref_in_log(...)
   {
        (...)
        if (inode->logged_trans < trans->transid)
            return 0;

        ret = join_running_log_trans(root);
        (...)
   }

However before that patch was merged, another patch was merged first which
replaced those checks because they were buggy.

That other patch corresponds to commit 803f0f64d17769 ("Btrfs: fix fsync
not persisting dentry deletions due to inode evictions"). The assumption
that if the logged_trans field of an inode had a smaller value then the
current transaction's generation (transid) meant that the inode was not
logged in the current transaction was only correct if the inode was not
evicted and reloaded in the current transaction. So the corresponding bug
fix changed those checks and replaced them with the following helper
function:

  static bool inode_logged(struct btrfs_trans_handle *trans,
                           struct btrfs_inode *inode)
  {
        if (inode->logged_trans == trans->transid)
                return true;

        if (inode->last_trans == trans->transid &&
            test_bit(BTRFS_INODE_NEEDS_FULL_SYNC, &inode->runtime_flags) &&
            !test_bit(BTRFS_FS_LOG_RECOVERING, &trans->fs_info->flags))
                return true;

        return false;
  }

So if we have a subvolume without a log tree in the current transaction
(because we had no fsyncs), every time we unlink an inode we can end up
trying to lock the log_mutex of the root through join_running_log_trans()
twice, once for the inode being unlinked (by btrfs_del_inode_ref_in_log())
and once for the parent directory (with btrfs_del_dir_entries_in_log()).

This means if we have several unlink operations happening in parallel for
inodes in the same subvolume, and the those inodes and/or their parent
inode were changed in the current transaction, we end up having a lot of
contention on the log_mutex.

The test robots from intel reported a -30.7% performance regression for
a REAIM test after commit e678934cbe5f02 ("btrfs: Remove unnecessary check
from join_running_log_trans").

So just bring back the optimization to join_running_log_trans() where we
check first if a log root exists before trying to lock the log_mutex. This
is done by checking for a bit that is set on the root when a log tree is
created and removed when a log tree is freed (at transaction commit time).

Commit e678934cbe5f02 ("btrfs: Remove unnecessary check from
join_running_log_trans") was merged in the 5.4 merge window while commit
803f0f64d17769 ("Btrfs: fix fsync not persisting dentry deletions due to
inode evictions") was merged in the 5.3 merge window. But the first
commit was actually authored before the second commit (May 23 2019 vs
June 19 2019).

Reported-by: kernel test robot <rong.a.chen@intel.com>
Link: https://lore.kernel.org/lkml/20200611090233.GL12456@shao2-debian/
Fixes: e678934cbe5f02 ("btrfs: Remove unnecessary check from join_running_log_trans")
CC: stable@vger.kernel.org # 5.4+
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/ctree.h    | 2 ++
 fs/btrfs/tree-log.c | 5 +++++
 2 files changed, 7 insertions(+)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 196d4511f8126..09e6dff8a8f85 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -988,6 +988,8 @@ enum {
 	BTRFS_ROOT_DEAD_RELOC_TREE,
 	/* Mark dead root stored on device whose cleanup needs to be resumed */
 	BTRFS_ROOT_DEAD_TREE,
+	/* The root has a log tree. Used only for subvolume roots. */
+	BTRFS_ROOT_HAS_LOG_TREE,
 };
 
 /*
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index ea72b9d54ec86..bdfc421494481 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -169,6 +169,7 @@ static int start_log_trans(struct btrfs_trans_handle *trans,
 		if (ret)
 			goto out;
 
+		set_bit(BTRFS_ROOT_HAS_LOG_TREE, &root->state);
 		clear_bit(BTRFS_ROOT_MULTI_LOG_TASKS, &root->state);
 		root->log_start_pid = current->pid;
 	}
@@ -195,6 +196,9 @@ static int join_running_log_trans(struct btrfs_root *root)
 {
 	int ret = -ENOENT;
 
+	if (!test_bit(BTRFS_ROOT_HAS_LOG_TREE, &root->state))
+		return ret;
+
 	mutex_lock(&root->log_mutex);
 	if (root->log_root) {
 		ret = 0;
@@ -3312,6 +3316,7 @@ int btrfs_free_log(struct btrfs_trans_handle *trans, struct btrfs_root *root)
 	if (root->log_root) {
 		free_log_tree(trans, root->log_root);
 		root->log_root = NULL;
+		clear_bit(BTRFS_ROOT_HAS_LOG_TREE, &root->state);
 	}
 	return 0;
 }
-- 
2.25.1

