Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B747F2F7A4E
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 13:50:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732764AbhAOMgp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 07:36:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:43858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387559AbhAOMgo (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 07:36:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5078C223E0;
        Fri, 15 Jan 2021 12:36:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610714162;
        bh=MsAjCZcXeadkKAluHyOS07Pym0gFeBnZzTeCFyVi/Rg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iLqkUGdH7ROYDNwN4x3DbwMAQnFazgP/5VjBBxgYGWrJS5cPQyDnMT5YP3L5JS/L4
         w4nQ+8kWa5L+fF82W/wZgHYZon/KGVZxuPRBS+5943d2JUYy+JOke9CuRBz3eon/A7
         ppRIgkywUuedsBCqHgl/3nc+FpKJ/I8NczbjS64w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Ren=C3=A9=20Rebe?= <rene@exactcode.de>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 012/103] btrfs: shrink delalloc pages instead of full inodes
Date:   Fri, 15 Jan 2021 13:27:05 +0100
Message-Id: <20210115122006.638450051@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210115122006.047132306@linuxfoundation.org>
References: <20210115122006.047132306@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit e076ab2a2ca70a0270232067cd49f76cd92efe64 ]

Commit 38d715f494f2 ("btrfs: use btrfs_start_delalloc_roots in
shrink_delalloc") cleaned up how we do delalloc shrinking by utilizing
some infrastructure we have in place to flush inodes that we use for
device replace and snapshot.  However this introduced a pretty serious
performance regression.  To reproduce the user untarred the source
tarball of Firefox (360MiB xz compressed/1.5GiB uncompressed), and would
see it take anywhere from 5 to 20 times as long to untar in 5.10
compared to 5.9. This was observed on fast devices (SSD and better) and
not on HDD.

The root cause is because before we would generally use the normal
writeback path to reclaim delalloc space, and for this we would provide
it with the number of pages we wanted to flush.  The referenced commit
changed this to flush that many inodes, which drastically increased the
amount of space we were flushing in certain cases, which severely
affected performance.

We cannot revert this patch unfortunately because of 3d45f221ce62
("btrfs: fix deadlock when cloning inline extent and low on free
metadata space") which requires the ability to skip flushing inodes that
are being cloned in certain scenarios, which means we need to keep using
our flushing infrastructure or risk re-introducing the deadlock.

Instead to fix this problem we can go back to providing
btrfs_start_delalloc_roots with a number of pages to flush, and then set
up a writeback_control and utilize sync_inode() to handle the flushing
for us.  This gives us the same behavior we had prior to the fix, while
still allowing us to avoid the deadlock that was fixed by Filipe.  I
redid the users original test and got the following results on one of
our test machines (256GiB of ram, 56 cores, 2TiB Intel NVMe drive)

  5.9		0m54.258s
  5.10		1m26.212s
  5.10+patch	0m38.800s

5.10+patch is significantly faster than plain 5.9 because of my patch
series "Change data reservations to use the ticketing infra" which
contained the patch that introduced the regression, but generally
improved the overall ENOSPC flushing mechanisms.

Additional testing on consumer-grade SSD (8GiB ram, 8 CPU) confirm
the results:

  5.10.5            4m00s
  5.10.5+patch      1m08s
  5.11-rc2	    5m14s
  5.11-rc2+patch    1m30s

Reported-by: René Rebe <rene@exactcode.de>
Fixes: 38d715f494f2 ("btrfs: use btrfs_start_delalloc_roots in shrink_delalloc")
CC: stable@vger.kernel.org # 5.10
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Tested-by: David Sterba <dsterba@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
[ add my test results ]
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/inode.c      | 60 +++++++++++++++++++++++++++++++------------
 fs/btrfs/space-info.c |  4 ++-
 2 files changed, 46 insertions(+), 18 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 07479250221da..acc47e2ffb46b 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -9389,7 +9389,8 @@ static struct btrfs_delalloc_work *btrfs_alloc_delalloc_work(struct inode *inode
  * some fairly slow code that needs optimization. This walks the list
  * of all the inodes with pending delalloc and forces them to disk.
  */
-static int start_delalloc_inodes(struct btrfs_root *root, u64 *nr, bool snapshot,
+static int start_delalloc_inodes(struct btrfs_root *root,
+				 struct writeback_control *wbc, bool snapshot,
 				 bool in_reclaim_context)
 {
 	struct btrfs_inode *binode;
@@ -9398,6 +9399,7 @@ static int start_delalloc_inodes(struct btrfs_root *root, u64 *nr, bool snapshot
 	struct list_head works;
 	struct list_head splice;
 	int ret = 0;
+	bool full_flush = wbc->nr_to_write == LONG_MAX;
 
 	INIT_LIST_HEAD(&works);
 	INIT_LIST_HEAD(&splice);
@@ -9426,18 +9428,24 @@ static int start_delalloc_inodes(struct btrfs_root *root, u64 *nr, bool snapshot
 		if (snapshot)
 			set_bit(BTRFS_INODE_SNAPSHOT_FLUSH,
 				&binode->runtime_flags);
-		work = btrfs_alloc_delalloc_work(inode);
-		if (!work) {
-			iput(inode);
-			ret = -ENOMEM;
-			goto out;
-		}
-		list_add_tail(&work->list, &works);
-		btrfs_queue_work(root->fs_info->flush_workers,
-				 &work->work);
-		if (*nr != U64_MAX) {
-			(*nr)--;
-			if (*nr == 0)
+		if (full_flush) {
+			work = btrfs_alloc_delalloc_work(inode);
+			if (!work) {
+				iput(inode);
+				ret = -ENOMEM;
+				goto out;
+			}
+			list_add_tail(&work->list, &works);
+			btrfs_queue_work(root->fs_info->flush_workers,
+					 &work->work);
+		} else {
+			ret = sync_inode(inode, wbc);
+			if (!ret &&
+			    test_bit(BTRFS_INODE_HAS_ASYNC_EXTENT,
+				     &BTRFS_I(inode)->runtime_flags))
+				ret = sync_inode(inode, wbc);
+			btrfs_add_delayed_iput(inode);
+			if (ret || wbc->nr_to_write <= 0)
 				goto out;
 		}
 		cond_resched();
@@ -9463,18 +9471,29 @@ static int start_delalloc_inodes(struct btrfs_root *root, u64 *nr, bool snapshot
 
 int btrfs_start_delalloc_snapshot(struct btrfs_root *root)
 {
+	struct writeback_control wbc = {
+		.nr_to_write = LONG_MAX,
+		.sync_mode = WB_SYNC_NONE,
+		.range_start = 0,
+		.range_end = LLONG_MAX,
+	};
 	struct btrfs_fs_info *fs_info = root->fs_info;
-	u64 nr = U64_MAX;
 
 	if (test_bit(BTRFS_FS_STATE_ERROR, &fs_info->fs_state))
 		return -EROFS;
 
-	return start_delalloc_inodes(root, &nr, true, false);
+	return start_delalloc_inodes(root, &wbc, true, false);
 }
 
 int btrfs_start_delalloc_roots(struct btrfs_fs_info *fs_info, u64 nr,
 			       bool in_reclaim_context)
 {
+	struct writeback_control wbc = {
+		.nr_to_write = (nr == U64_MAX) ? LONG_MAX : (unsigned long)nr,
+		.sync_mode = WB_SYNC_NONE,
+		.range_start = 0,
+		.range_end = LLONG_MAX,
+	};
 	struct btrfs_root *root;
 	struct list_head splice;
 	int ret;
@@ -9488,6 +9507,13 @@ int btrfs_start_delalloc_roots(struct btrfs_fs_info *fs_info, u64 nr,
 	spin_lock(&fs_info->delalloc_root_lock);
 	list_splice_init(&fs_info->delalloc_roots, &splice);
 	while (!list_empty(&splice) && nr) {
+		/*
+		 * Reset nr_to_write here so we know that we're doing a full
+		 * flush.
+		 */
+		if (nr == U64_MAX)
+			wbc.nr_to_write = LONG_MAX;
+
 		root = list_first_entry(&splice, struct btrfs_root,
 					delalloc_root);
 		root = btrfs_grab_root(root);
@@ -9496,9 +9522,9 @@ int btrfs_start_delalloc_roots(struct btrfs_fs_info *fs_info, u64 nr,
 			       &fs_info->delalloc_roots);
 		spin_unlock(&fs_info->delalloc_root_lock);
 
-		ret = start_delalloc_inodes(root, &nr, false, in_reclaim_context);
+		ret = start_delalloc_inodes(root, &wbc, false, in_reclaim_context);
 		btrfs_put_root(root);
-		if (ret < 0)
+		if (ret < 0 || wbc.nr_to_write <= 0)
 			goto out;
 		spin_lock(&fs_info->delalloc_root_lock);
 	}
diff --git a/fs/btrfs/space-info.c b/fs/btrfs/space-info.c
index 67e55c5479b8e..e8347461c8ddd 100644
--- a/fs/btrfs/space-info.c
+++ b/fs/btrfs/space-info.c
@@ -532,7 +532,9 @@ static void shrink_delalloc(struct btrfs_fs_info *fs_info,
 
 	loops = 0;
 	while ((delalloc_bytes || dio_bytes) && loops < 3) {
-		btrfs_start_delalloc_roots(fs_info, items, true);
+		u64 nr_pages = min(delalloc_bytes, to_reclaim) >> PAGE_SHIFT;
+
+		btrfs_start_delalloc_roots(fs_info, nr_pages, true);
 
 		loops++;
 		if (wait_ordered && !trans) {
-- 
2.27.0



