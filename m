Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C0052E15D8
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 03:59:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730966AbgLWCyN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:54:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:49842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727042AbgLWCVG (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:21:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C6C4D22D73;
        Wed, 23 Dec 2020 02:20:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690025;
        bh=SswW3qNL+ETTgMTJlwZZ9/3Bt0tqzb74Kujpw7k9mtI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h1TZLo4bu7r643vMoCh9YuuwnGcKHeqETMD6gegZP48ZlMeeFKA6p43koYmhwm4tT
         HUb5D/6N/FJrFPKgmntNxwYGh/0MiKFwKlzsnmRr2ey9dieER4Z0ZDrKIKlvdikujP
         QVgSqkkHsNFMZ2+EcZqDqiAWCS7WPlFclXcqKNclxEJrFBfzYC4wKX2DV2jjEGqMRf
         +Fae6rAbu5pZAR2/uOOxoHJnYUpOTPVM2u+JdFt8migT5YyHHSgDlvDMvGXeYqi9Eo
         GPPESEHeN8RPTxBblW6cvtfO5OSBXLhi3t865JfFkRfEtumQYxr5arwiboB5KE7j7W
         WvwHd42pUBFDg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Filipe Manana <fdmanana@suse.com>, David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 102/130] btrfs: fix race that makes inode logging fallback to transaction commit
Date:   Tue, 22 Dec 2020 21:17:45 -0500
Message-Id: <20201223021813.2791612-102-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223021813.2791612-1-sashal@kernel.org>
References: <20201223021813.2791612-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit 47d3db41e190ca4a9c6e4a848052f4c5ca633db1 ]

When logging an inode and the previous transaction is still committing, we
have a time window where we can end up incorrectly think an inode has its
last_unlink_trans field with a value greater than the last transaction
committed, which results in the logging to fallback to a full transaction
commit, which is usually much more expensive than doing a log commit.

The race is described by the following steps:

1) We are at transaction 1000;

2) We modify an inode X (a directory) using transaction 1000 and set its
   last_unlink_trans field to 1000, because for example we removed one
   of its subdirectories;

3) We create a new inode Y with a dentry in inode X using transaction 1000,
   so its generation field is set to 1000;

4) The commit for transaction 1000 is started by task A;

5) The task committing transaction 1000 sets the transaction state to
   unblocked, writes the dirty extent buffers and the super blocks, then
   unlocks tree_log_mutex;

6) Some task starts a new transaction with a generation of 1001;

7) We do some modification to inode Y (using transaction 1001);

8) The transaction 1000 commit starts unpinning extents. At this point
   fs_info->last_trans_committed still has a value of 999;

9) Task B starts an fsync on inode Y, and gets a handle for transaction
   1001. When it gets to check_parent_dirs_for_sync() it does the checking
   of the ancestor dentries because the following check does not evaluate
   to true:

       if (S_ISREG(inode->vfs_inode.i_mode) &&
           inode->generation <= last_committed &&
           inode->last_unlink_trans <= last_committed)
               goto out;

   The generation value for inode Y is 1000 and last_committed, which has
   the value read from fs_info->last_trans_committed, has a value of 999,
   so that check evaluates to false and we proceed to check the ancestor
   inodes.

   Once we get to the first ancestor, inode X, we call
   btrfs_must_commit_transaction() on it, which evaluates to true:

   static bool btrfs_must_commit_transaction(...)
   {
       struct btrfs_fs_info *fs_info = inode->root->fs_info;
       bool ret = false;

       mutex_lock(&inode->log_mutex);
       if (inode->last_unlink_trans > fs_info->last_trans_committed) {
           /*
            * Make sure any commits to the log are forced to be full
            * commits.
            */
            btrfs_set_log_full_commit(trans);
            ret = true;
       }
    (...)

    because inode's X last_unlink_trans has a value of 1000 and
    fs_info->last_trans_committed still has a value of 999, it returns
    true to check_parent_dirs_for_sync(), making it return 1 which is
    propagated up to btrfs_sync_file(), causing it to fallback to a full
    transaction commit of transaction 1001.

    We should have not fallen back to commit transaction 1001, since inode
    X had last_unlink_trans set to 1000 and the super blocks for
    transaction 1000 were already written. So while not resulting in a
    functional problem, it leads to a lot more work and higher latencies
    for a fsync since committing a transaction is usually more expensive
    than committing a log (if other filesystem changes happened under that
    transaction).

Similar problem happens when logging directories, for the same reason as
btrfs_must_commit_transaction() returns true on an inode with its
last_unlink_trans having the generation of the previous transaction and
that transaction is still committing, unpinning its freed extents.

So fix this by comparing last_unlink_trans with the id of the current
transaction instead of fs_info->last_trans_committed.

This case is often hit when running dbench for a long enough duration, as
it does lots of rename and rmdir operations (both update the field
last_unlink_trans of an inode) and fsyncs of files and directories.

This patch belongs to a patch set that is comprised of the following
patches:

  btrfs: fix race causing unnecessary inode logging during link and rename
  btrfs: fix race that results in logging old extents during a fast fsync
  btrfs: fix race that causes unnecessary logging of ancestor inodes
  btrfs: fix race that makes inode logging fallback to transaction commit
  btrfs: fix race leading to unnecessary transaction commit when logging inode
  btrfs: do not block inode logging for so long during transaction commit

Performance results are mentioned in the change log of the last patch.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/tree-log.c | 20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 72e0ff38646a7..54095753f84f0 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -5418,11 +5418,10 @@ static int btrfs_log_inode(struct btrfs_trans_handle *trans,
 static bool btrfs_must_commit_transaction(struct btrfs_trans_handle *trans,
 					  struct btrfs_inode *inode)
 {
-	struct btrfs_fs_info *fs_info = inode->root->fs_info;
 	bool ret = false;
 
 	mutex_lock(&inode->log_mutex);
-	if (inode->last_unlink_trans > fs_info->last_trans_committed) {
+	if (inode->last_unlink_trans >= trans->transid) {
 		/*
 		 * Make sure any commits to the log are forced to be full
 		 * commits.
@@ -5444,8 +5443,7 @@ static bool btrfs_must_commit_transaction(struct btrfs_trans_handle *trans,
 static noinline int check_parent_dirs_for_sync(struct btrfs_trans_handle *trans,
 					       struct btrfs_inode *inode,
 					       struct dentry *parent,
-					       struct super_block *sb,
-					       u64 last_committed)
+					       struct super_block *sb)
 {
 	int ret = 0;
 	struct dentry *old_parent = NULL;
@@ -5457,8 +5455,8 @@ static noinline int check_parent_dirs_for_sync(struct btrfs_trans_handle *trans,
 	 * and other fun in this file.
 	 */
 	if (S_ISREG(inode->vfs_inode.i_mode) &&
-	    inode->generation <= last_committed &&
-	    inode->last_unlink_trans <= last_committed)
+	    inode->generation < trans->transid &&
+	    inode->last_unlink_trans < trans->transid)
 		goto out;
 
 	if (!S_ISDIR(inode->vfs_inode.i_mode)) {
@@ -5993,7 +5991,6 @@ static int btrfs_log_inode_parent(struct btrfs_trans_handle *trans,
 	struct btrfs_fs_info *fs_info = root->fs_info;
 	struct super_block *sb;
 	int ret = 0;
-	u64 last_committed = fs_info->last_trans_committed;
 	bool log_dentries = false;
 
 	sb = inode->vfs_inode.i_sb;
@@ -6018,8 +6015,7 @@ static int btrfs_log_inode_parent(struct btrfs_trans_handle *trans,
 		goto end_no_trans;
 	}
 
-	ret = check_parent_dirs_for_sync(trans, inode, parent, sb,
-			last_committed);
+	ret = check_parent_dirs_for_sync(trans, inode, parent, sb);
 	if (ret)
 		goto end_no_trans;
 
@@ -6049,8 +6045,8 @@ static int btrfs_log_inode_parent(struct btrfs_trans_handle *trans,
 	 * and other fun in this file.
 	 */
 	if (S_ISREG(inode->vfs_inode.i_mode) &&
-	    inode->generation <= last_committed &&
-	    inode->last_unlink_trans <= last_committed) {
+	    inode->generation < trans->transid &&
+	    inode->last_unlink_trans < trans->transid) {
 		ret = 0;
 		goto end_trans;
 	}
@@ -6099,7 +6095,7 @@ static int btrfs_log_inode_parent(struct btrfs_trans_handle *trans,
 	 * but the file inode does not have a matching BTRFS_INODE_REF_KEY item
 	 * and has a link count of 2.
 	 */
-	if (inode->last_unlink_trans > last_committed) {
+	if (inode->last_unlink_trans >= trans->transid) {
 		ret = btrfs_log_all_parents(trans, inode, ctx);
 		if (ret)
 			goto end_trans;
-- 
2.27.0

