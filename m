Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D007F2E1559
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 03:58:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729211AbgLWCVG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:21:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:49830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729201AbgLWCVF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:21:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A6BCA22285;
        Wed, 23 Dec 2020 02:20:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690024;
        bh=+pfIZ19DT6OciwqxMVUGYiUdF+h8/UsCs/BRCYhN4dM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gQ5gEa8iCVdZjjRvofasDCLHXfuMUCk84aK2vuvZfsX/Eu8uX9HZC0BfCR48m9bjz
         /FH65d6/tM6y9GtqCxXja523X1KqG8So8Pm2UYVFJnBWHqmhC90Vvzo4+tG4UE3xWX
         GdkfU8kM9FOEJnElqaNDW3riT6ivUyzt3Rm5sdAxvZ0upodzXyddYfPtR0ljOhFtYS
         N7vV/rI702hbldc891AdqJIMoL/t+oT7lJei23yAiyEDFHtThz1BjbstOxV/8SzOMb
         jglztAEGByc460OJoxTc1WyHHcAPSCS5WXPb+fSyicBPmyf1ekChyiGphW3YjrFYbe
         j9cRGNamUBUTQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Filipe Manana <fdmanana@suse.com>, David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 101/130] btrfs: fix race that causes unnecessary logging of ancestor inodes
Date:   Tue, 22 Dec 2020 21:17:44 -0500
Message-Id: <20201223021813.2791612-101-sashal@kernel.org>
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

[ Upstream commit 4d6221d7d83141d58ece6560e9cfd4cc92eab044 ]

When logging an inode and we are checking if we need to log ancestors that
are new, if the previous transaction is still committing we have a time
window where we can unnecessarily log ancestor inodes that were created in
the previous transaction.

The race is described by the following steps:

1) We are at transaction 1000;

2) Directory inode X is created, its generation is set to 1000;

3) The commit for transaction 1000 is started by task A;

4) The task committing transaction 1000 sets the transaction state to
   unblocked, writes the dirty extent buffers and the super blocks, then
   unlocks tree_log_mutex;

5) Inode Y, a regular file, is created under directory inode X, this
   results in starting a new transaction with a generation of 1001;

6) The transaction 1000 commit is unpinning extents. At this point
   fs_info->last_trans_committed still has a value of 999;

7) Task B calls fsync on inode Y and gets a handle for transaction 1001;

8) Task B ends up at log_all_new_ancestors() and then because inode Y has
   only one hard link, ends up at log_new_ancestors_fast(). There it reads
   a value of 999 from fs_info->last_trans_committed, and sees that the
   parent inode X has a generation of 1000, so we end up logging inode X:

     if (inode->generation > fs_info->last_trans_committed) {
         ret = btrfs_log_inode(trans, root, inode,
                               LOG_INODE_EXISTS, ctx);
         (...)

   which is not necessary since it was created in the past transaction,
   with a generation of 1000, and that transaction has already committed
   its super blocks - it's still unpinning extents so it has not yet
   updated fs_info->last_trans_committed from 999 to 1000.

   So this just causes us to spend more time logging and allocating and
   writing more tree blocks for the log tree.

So fix this by comparing an inode's generation with the generation of the
transaction our transaction handle refers to - if the inode's generation
matches the generation of the current transaction than we know it is a
new inode we need to log, otherwise don't log it.

This case is often hit when running dbench for a long enough duration.

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
 fs/btrfs/tree-log.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 12182db88222b..72e0ff38646a7 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -5804,7 +5804,6 @@ static int log_new_ancestors(struct btrfs_trans_handle *trans,
 
 	while (true) {
 		struct btrfs_fs_info *fs_info = root->fs_info;
-		const u64 last_committed = fs_info->last_trans_committed;
 		struct extent_buffer *leaf = path->nodes[0];
 		int slot = path->slots[0];
 		struct btrfs_key search_key;
@@ -5820,7 +5819,7 @@ static int log_new_ancestors(struct btrfs_trans_handle *trans,
 		if (IS_ERR(inode))
 			return PTR_ERR(inode);
 
-		if (BTRFS_I(inode)->generation > last_committed)
+		if (BTRFS_I(inode)->generation >= trans->transid)
 			ret = btrfs_log_inode(trans, root, BTRFS_I(inode),
 					      LOG_INODE_EXISTS,
 					      0, LLONG_MAX, ctx);
@@ -5862,7 +5861,6 @@ static int log_new_ancestors_fast(struct btrfs_trans_handle *trans,
 				  struct btrfs_log_ctx *ctx)
 {
 	struct btrfs_root *root = inode->root;
-	struct btrfs_fs_info *fs_info = root->fs_info;
 	struct dentry *old_parent = NULL;
 	struct super_block *sb = inode->vfs_inode.i_sb;
 	int ret = 0;
@@ -5876,7 +5874,7 @@ static int log_new_ancestors_fast(struct btrfs_trans_handle *trans,
 		if (root != inode->root)
 			break;
 
-		if (inode->generation > fs_info->last_trans_committed) {
+		if (inode->generation >= trans->transid) {
 			ret = btrfs_log_inode(trans, root, inode,
 					LOG_INODE_EXISTS, 0, LLONG_MAX, ctx);
 			if (ret)
-- 
2.27.0

