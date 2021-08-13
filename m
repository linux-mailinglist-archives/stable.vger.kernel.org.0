Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 430F43EB8A1
	for <lists+stable@lfdr.de>; Fri, 13 Aug 2021 17:26:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242017AbhHMPO4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Aug 2021 11:14:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:57162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241771AbhHMPOF (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Aug 2021 11:14:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 14E0B61106;
        Fri, 13 Aug 2021 15:13:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628867607;
        bh=ewLont36IElKRzWdeq7NmWJLdGtK+biioOlqNHFYD/0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a+ieEdpScPkSNBhIe3t+FBF4yG7GHpbmJ3m17jl4M2o+7sZ+aRitU8OR1tT4jxSK3
         Bjk0pjXCqn+zCcUEM3InRi8/71QXAB7u5pOvZiuYOqgy0oFbd0LWsJAqX8vX2wVsrX
         kRHPAX9/x2Gej1piMSm9jw6l6vXgNZrq2tSE+E7w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        Qu Wenruo <wqu@suse.com>, David Sterba <dsterba@suse.com>,
        Anand Jain <anand.jain@oracle.com>
Subject: [PATCH 5.4 20/27] btrfs: qgroup: try to flush qgroup space when we get -EDQUOT
Date:   Fri, 13 Aug 2021 17:07:18 +0200
Message-Id: <20210813150524.028400965@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210813150523.364549385@linuxfoundation.org>
References: <20210813150523.364549385@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qu Wenruo <wqu@suse.com>

commit c53e9653605dbf708f5be02902de51831be4b009 upstream

[PROBLEM]
There are known problem related to how btrfs handles qgroup reserved
space.  One of the most obvious case is the the test case btrfs/153,
which do fallocate, then write into the preallocated range.

#  btrfs/153 1s ... - output mismatch (see xfstests-dev/results//btrfs/153.out.bad)
#      --- tests/btrfs/153.out     2019-10-22 15:18:14.068965341 +0800
#      +++ xfstests-dev/results//btrfs/153.out.bad      2020-07-01 20:24:40.730000089 +0800
#      @@ -1,2 +1,5 @@
#       QA output created by 153
#      +pwrite: Disk quota exceeded
#      +/mnt/scratch/testfile2: Disk quota exceeded
#      +/mnt/scratch/testfile2: Disk quota exceeded
#       Silence is golden
#      ...
#      (Run 'diff -u xfstests-dev/tests/btrfs/153.out xfstests-dev/results//btrfs/153.out.bad'  to see the entire diff)

[CAUSE]
Since commit c6887cd11149 ("Btrfs: don't do nocow check unless we have to"),
we always reserve space no matter if it's COW or not.

Such behavior change is mostly for performance, and reverting it is not
a good idea anyway.

For preallcoated extent, we reserve qgroup data space for it already,
and since we also reserve data space for qgroup at buffered write time,
it needs twice the space for us to write into preallocated space.

This leads to the -EDQUOT in buffered write routine.

And we can't follow the same solution, unlike data/meta space check,
qgroup reserved space is shared between data/metadata.
The EDQUOT can happen at the metadata reservation, so doing NODATACOW
check after qgroup reservation failure is not a solution.

[FIX]
To solve the problem, we don't return -EDQUOT directly, but every time
we got a -EDQUOT, we try to flush qgroup space:

- Flush all inodes of the root
  NODATACOW writes will free the qgroup reserved at run_dealloc_range().
  However we don't have the infrastructure to only flush NODATACOW
  inodes, here we flush all inodes anyway.

- Wait for ordered extents
  This would convert the preallocated metadata space into per-trans
  metadata, which can be freed in later transaction commit.

- Commit transaction
  This will free all per-trans metadata space.

Also we don't want to trigger flush multiple times, so here we introduce
a per-root wait list and a new root status, to ensure only one thread
starts the flushing.

Fixes: c6887cd11149 ("Btrfs: don't do nocow check unless we have to")
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/ctree.h   |    3 +
 fs/btrfs/disk-io.c |    1 
 fs/btrfs/qgroup.c  |  100 ++++++++++++++++++++++++++++++++++++++++++++++++-----
 3 files changed, 96 insertions(+), 8 deletions(-)

--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -945,6 +945,8 @@ enum {
 	BTRFS_ROOT_DEAD_TREE,
 	/* The root has a log tree. Used only for subvolume roots. */
 	BTRFS_ROOT_HAS_LOG_TREE,
+	/* Qgroup flushing is in progress */
+	BTRFS_ROOT_QGROUP_FLUSHING,
 };
 
 /*
@@ -1097,6 +1099,7 @@ struct btrfs_root {
 	spinlock_t qgroup_meta_rsv_lock;
 	u64 qgroup_meta_rsv_pertrans;
 	u64 qgroup_meta_rsv_prealloc;
+	wait_queue_head_t qgroup_flush_wait;
 
 	/* Number of active swapfiles */
 	atomic_t nr_swapfiles;
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1154,6 +1154,7 @@ static void __setup_root(struct btrfs_ro
 	mutex_init(&root->log_mutex);
 	mutex_init(&root->ordered_extent_mutex);
 	mutex_init(&root->delalloc_mutex);
+	init_waitqueue_head(&root->qgroup_flush_wait);
 	init_waitqueue_head(&root->log_writer_wait);
 	init_waitqueue_head(&root->log_commit_wait[0]);
 	init_waitqueue_head(&root->log_commit_wait[1]);
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -3479,17 +3479,58 @@ static int qgroup_unreserve_range(struct
 }
 
 /*
- * Reserve qgroup space for range [start, start + len).
+ * Try to free some space for qgroup.
  *
- * This function will either reserve space from related qgroups or doing
- * nothing if the range is already reserved.
+ * For qgroup, there are only 3 ways to free qgroup space:
+ * - Flush nodatacow write
+ *   Any nodatacow write will free its reserved data space at run_delalloc_range().
+ *   In theory, we should only flush nodatacow inodes, but it's not yet
+ *   possible, so we need to flush the whole root.
  *
- * Return 0 for successful reserve
- * Return <0 for error (including -EQUOT)
+ * - Wait for ordered extents
+ *   When ordered extents are finished, their reserved metadata is finally
+ *   converted to per_trans status, which can be freed by later commit
+ *   transaction.
  *
- * NOTE: this function may sleep for memory allocation.
+ * - Commit transaction
+ *   This would free the meta_per_trans space.
+ *   In theory this shouldn't provide much space, but any more qgroup space
+ *   is needed.
  */
-int btrfs_qgroup_reserve_data(struct btrfs_inode *inode,
+static int try_flush_qgroup(struct btrfs_root *root)
+{
+	struct btrfs_trans_handle *trans;
+	int ret;
+
+	/*
+	 * We don't want to run flush again and again, so if there is a running
+	 * one, we won't try to start a new flush, but exit directly.
+	 */
+	if (test_and_set_bit(BTRFS_ROOT_QGROUP_FLUSHING, &root->state)) {
+		wait_event(root->qgroup_flush_wait,
+			!test_bit(BTRFS_ROOT_QGROUP_FLUSHING, &root->state));
+		return 0;
+	}
+
+	ret = btrfs_start_delalloc_snapshot(root);
+	if (ret < 0)
+		goto out;
+	btrfs_wait_ordered_extents(root, U64_MAX, 0, (u64)-1);
+
+	trans = btrfs_join_transaction(root);
+	if (IS_ERR(trans)) {
+		ret = PTR_ERR(trans);
+		goto out;
+	}
+
+	ret = btrfs_commit_transaction(trans);
+out:
+	clear_bit(BTRFS_ROOT_QGROUP_FLUSHING, &root->state);
+	wake_up(&root->qgroup_flush_wait);
+	return ret;
+}
+
+static int qgroup_reserve_data(struct btrfs_inode *inode,
 			struct extent_changeset **reserved_ret, u64 start,
 			u64 len)
 {
@@ -3542,6 +3583,34 @@ out:
 	return ret;
 }
 
+/*
+ * Reserve qgroup space for range [start, start + len).
+ *
+ * This function will either reserve space from related qgroups or do nothing
+ * if the range is already reserved.
+ *
+ * Return 0 for successful reservation
+ * Return <0 for error (including -EQUOT)
+ *
+ * NOTE: This function may sleep for memory allocation, dirty page flushing and
+ *	 commit transaction. So caller should not hold any dirty page locked.
+ */
+int btrfs_qgroup_reserve_data(struct btrfs_inode *inode,
+			struct extent_changeset **reserved_ret, u64 start,
+			u64 len)
+{
+	int ret;
+
+	ret = qgroup_reserve_data(inode, reserved_ret, start, len);
+	if (ret <= 0 && ret != -EDQUOT)
+		return ret;
+
+	ret = try_flush_qgroup(inode->root);
+	if (ret < 0)
+		return ret;
+	return qgroup_reserve_data(inode, reserved_ret, start, len);
+}
+
 /* Free ranges specified by @reserved, normally in error path */
 static int qgroup_free_reserved_data(struct btrfs_inode *inode,
 			struct extent_changeset *reserved, u64 start, u64 len)
@@ -3712,7 +3781,7 @@ static int sub_root_meta_rsv(struct btrf
 	return num_bytes;
 }
 
-int __btrfs_qgroup_reserve_meta(struct btrfs_root *root, int num_bytes,
+static int qgroup_reserve_meta(struct btrfs_root *root, int num_bytes,
 				enum btrfs_qgroup_rsv_type type, bool enforce)
 {
 	struct btrfs_fs_info *fs_info = root->fs_info;
@@ -3739,6 +3808,21 @@ int __btrfs_qgroup_reserve_meta(struct b
 	return ret;
 }
 
+int __btrfs_qgroup_reserve_meta(struct btrfs_root *root, int num_bytes,
+				enum btrfs_qgroup_rsv_type type, bool enforce)
+{
+	int ret;
+
+	ret = qgroup_reserve_meta(root, num_bytes, type, enforce);
+	if (ret <= 0 && ret != -EDQUOT)
+		return ret;
+
+	ret = try_flush_qgroup(root);
+	if (ret < 0)
+		return ret;
+	return qgroup_reserve_meta(root, num_bytes, type, enforce);
+}
+
 void btrfs_qgroup_free_meta_all_pertrans(struct btrfs_root *root)
 {
 	struct btrfs_fs_info *fs_info = root->fs_info;


