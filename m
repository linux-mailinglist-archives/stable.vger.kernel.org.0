Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84B3624F525
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 10:45:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728480AbgHXIpR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 04:45:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:42124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729211AbgHXIpQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 04:45:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8F30D2075B;
        Mon, 24 Aug 2020 08:45:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598258715;
        bh=44e3L+wfAhsJFaYQWD5Hycna69Md2DIlFvyL3u8gXZc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GfMdnEXBF2QfZG9SDSoXMb7vYKL1v5sX5xtfCV84WraFa7hdTwP3HajuJiM68FPw2
         JOrll3P6Fzm0hjkwBAtdiOhmMD57zxO2xOfcm6g7rrp71yYvPJobAnsZNPlcAlvGto
         k5pGNyLavIHhFeahLHePLtPlttBLws15gpPB7X20=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 020/107] btrfs: add wrapper for transaction abort predicate
Date:   Mon, 24 Aug 2020 10:29:46 +0200
Message-Id: <20200824082406.096763389@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200824082405.020301642@linuxfoundation.org>
References: <20200824082405.020301642@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Sterba <dsterba@suse.com>

[ Upstream commit bf31f87f71cc7a89871ab0a451c047a0c0144bf1 ]

The status of aborted transaction can change between calls and it needs
to be accessed by READ_ONCE. Add a helper that also wraps the unlikely
hint.

Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/block-group.c   |  2 +-
 fs/btrfs/delayed-inode.c |  2 +-
 fs/btrfs/extent-tree.c   | 10 +++++-----
 fs/btrfs/super.c         |  2 +-
 fs/btrfs/transaction.c   | 25 +++++++++++++------------
 fs/btrfs/transaction.h   | 12 ++++++++++++
 6 files changed, 33 insertions(+), 20 deletions(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index 42d69e77f89d9..b167649f5f5de 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -2168,7 +2168,7 @@ static int cache_save_setup(struct btrfs_block_group_cache *block_group,
 		return 0;
 	}
 
-	if (trans->aborted)
+	if (TRANS_ABORTED(trans))
 		return 0;
 again:
 	inode = lookup_free_space_inode(block_group, path);
diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index 5bcccfbcc7c15..a34ee9c2f3151 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -1151,7 +1151,7 @@ static int __btrfs_run_delayed_items(struct btrfs_trans_handle *trans, int nr)
 	int ret = 0;
 	bool count = (nr > 0);
 
-	if (trans->aborted)
+	if (TRANS_ABORTED(trans))
 		return -EIO;
 
 	path = btrfs_alloc_path();
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 739332b462059..a36bd4507bacd 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -1561,7 +1561,7 @@ static int run_delayed_extent_op(struct btrfs_trans_handle *trans,
 	int err = 0;
 	int metadata = !extent_op->is_data;
 
-	if (trans->aborted)
+	if (TRANS_ABORTED(trans))
 		return 0;
 
 	if (metadata && !btrfs_fs_incompat(fs_info, SKINNY_METADATA))
@@ -1681,7 +1681,7 @@ static int run_one_delayed_ref(struct btrfs_trans_handle *trans,
 {
 	int ret = 0;
 
-	if (trans->aborted) {
+	if (TRANS_ABORTED(trans)) {
 		if (insert_reserved)
 			btrfs_pin_extent(trans->fs_info, node->bytenr,
 					 node->num_bytes, 1);
@@ -2169,7 +2169,7 @@ int btrfs_run_delayed_refs(struct btrfs_trans_handle *trans,
 	int run_all = count == (unsigned long)-1;
 
 	/* We'll clean this up in btrfs_cleanup_transaction */
-	if (trans->aborted)
+	if (TRANS_ABORTED(trans))
 		return 0;
 
 	if (test_bit(BTRFS_FS_CREATING_FREE_SPACE_TREE, &fs_info->flags))
@@ -2892,7 +2892,7 @@ int btrfs_finish_extent_commit(struct btrfs_trans_handle *trans)
 	else
 		unpin = &fs_info->freed_extents[0];
 
-	while (!trans->aborted) {
+	while (!TRANS_ABORTED(trans)) {
 		struct extent_state *cached_state = NULL;
 
 		mutex_lock(&fs_info->unused_bg_unpin_mutex);
@@ -2924,7 +2924,7 @@ int btrfs_finish_extent_commit(struct btrfs_trans_handle *trans)
 		u64 trimmed = 0;
 
 		ret = -EROFS;
-		if (!trans->aborted)
+		if (!TRANS_ABORTED(trans))
 			ret = btrfs_discard_extent(fs_info,
 						   block_group->key.objectid,
 						   block_group->key.offset,
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index e21cae80c6d58..a1498df419b4f 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -241,7 +241,7 @@ void __btrfs_abort_transaction(struct btrfs_trans_handle *trans,
 {
 	struct btrfs_fs_info *fs_info = trans->fs_info;
 
-	trans->aborted = errno;
+	WRITE_ONCE(trans->aborted, errno);
 	/* Nothing used. The other threads that have joined this
 	 * transaction may be able to continue. */
 	if (!trans->dirty && list_empty(&trans->new_bgs)) {
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 465ddb297c381..c346ee7ec18d4 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -174,7 +174,7 @@ loop:
 
 	cur_trans = fs_info->running_transaction;
 	if (cur_trans) {
-		if (cur_trans->aborted) {
+		if (TRANS_ABORTED(cur_trans)) {
 			spin_unlock(&fs_info->trans_lock);
 			return cur_trans->aborted;
 		}
@@ -390,7 +390,7 @@ static inline int is_transaction_blocked(struct btrfs_transaction *trans)
 {
 	return (trans->state >= TRANS_STATE_BLOCKED &&
 		trans->state < TRANS_STATE_UNBLOCKED &&
-		!trans->aborted);
+		!TRANS_ABORTED(trans));
 }
 
 /* wait for commit against the current transaction to become unblocked
@@ -409,7 +409,7 @@ static void wait_current_trans(struct btrfs_fs_info *fs_info)
 
 		wait_event(fs_info->transaction_wait,
 			   cur_trans->state >= TRANS_STATE_UNBLOCKED ||
-			   cur_trans->aborted);
+			   TRANS_ABORTED(cur_trans));
 		btrfs_put_transaction(cur_trans);
 	} else {
 		spin_unlock(&fs_info->trans_lock);
@@ -870,7 +870,7 @@ static int __btrfs_end_transaction(struct btrfs_trans_handle *trans,
 	if (throttle)
 		btrfs_run_delayed_iputs(info);
 
-	if (trans->aborted ||
+	if (TRANS_ABORTED(trans) ||
 	    test_bit(BTRFS_FS_STATE_ERROR, &info->fs_state)) {
 		wake_up_process(info->transaction_kthread);
 		if (TRANS_ABORTED(trans))
@@ -1730,7 +1730,8 @@ static void wait_current_trans_commit_start(struct btrfs_fs_info *fs_info,
 					    struct btrfs_transaction *trans)
 {
 	wait_event(fs_info->transaction_blocked_wait,
-		   trans->state >= TRANS_STATE_COMMIT_START || trans->aborted);
+		   trans->state >= TRANS_STATE_COMMIT_START ||
+		   TRANS_ABORTED(trans));
 }
 
 /*
@@ -1742,7 +1743,8 @@ static void wait_current_trans_commit_start_and_unblock(
 					struct btrfs_transaction *trans)
 {
 	wait_event(fs_info->transaction_wait,
-		   trans->state >= TRANS_STATE_UNBLOCKED || trans->aborted);
+		   trans->state >= TRANS_STATE_UNBLOCKED ||
+		   TRANS_ABORTED(trans));
 }
 
 /*
@@ -1960,7 +1962,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
 	trans->dirty = true;
 
 	/* Stop the commit early if ->aborted is set */
-	if (unlikely(READ_ONCE(cur_trans->aborted))) {
+	if (TRANS_ABORTED(cur_trans)) {
 		ret = cur_trans->aborted;
 		btrfs_end_transaction(trans);
 		return ret;
@@ -2034,7 +2036,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
 
 		wait_for_commit(cur_trans);
 
-		if (unlikely(cur_trans->aborted))
+		if (TRANS_ABORTED(cur_trans))
 			ret = cur_trans->aborted;
 
 		btrfs_put_transaction(cur_trans);
@@ -2053,7 +2055,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
 			spin_unlock(&fs_info->trans_lock);
 
 			wait_for_commit(prev_trans);
-			ret = prev_trans->aborted;
+			ret = READ_ONCE(prev_trans->aborted);
 
 			btrfs_put_transaction(prev_trans);
 			if (ret)
@@ -2107,8 +2109,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
 	wait_event(cur_trans->writer_wait,
 		   atomic_read(&cur_trans->num_writers) == 1);
 
-	/* ->aborted might be set after the previous check, so check it */
-	if (unlikely(READ_ONCE(cur_trans->aborted))) {
+	if (TRANS_ABORTED(cur_trans)) {
 		ret = cur_trans->aborted;
 		goto scrub_continue;
 	}
@@ -2226,7 +2227,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
 	 * The tasks which save the space cache and inode cache may also
 	 * update ->aborted, check it.
 	 */
-	if (unlikely(READ_ONCE(cur_trans->aborted))) {
+	if (TRANS_ABORTED(cur_trans)) {
 		ret = cur_trans->aborted;
 		mutex_unlock(&fs_info->tree_log_mutex);
 		mutex_unlock(&fs_info->reloc_mutex);
diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
index b15c31d231488..7291a2a930751 100644
--- a/fs/btrfs/transaction.h
+++ b/fs/btrfs/transaction.h
@@ -116,6 +116,10 @@ struct btrfs_trans_handle {
 	struct btrfs_block_rsv *orig_rsv;
 	refcount_t use_count;
 	unsigned int type;
+	/*
+	 * Error code of transaction abort, set outside of locks and must use
+	 * the READ_ONCE/WRITE_ONCE access
+	 */
 	short aborted;
 	bool adding_csums;
 	bool allocating_chunk;
@@ -127,6 +131,14 @@ struct btrfs_trans_handle {
 	struct list_head new_bgs;
 };
 
+/*
+ * The abort status can be changed between calls and is not protected by locks.
+ * This accepts btrfs_transaction and btrfs_trans_handle as types. Once it's
+ * set to a non-zero value it does not change, so the macro should be in checks
+ * but is not necessary for further reads of the value.
+ */
+#define TRANS_ABORTED(trans)		(unlikely(READ_ONCE((trans)->aborted)))
+
 struct btrfs_pending_snapshot {
 	struct dentry *dentry;
 	struct inode *dir;
-- 
2.25.1



