Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72D342EE825
	for <lists+stable@lfdr.de>; Thu,  7 Jan 2021 23:09:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726989AbhAGWJN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jan 2021 17:09:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726326AbhAGWJN (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Jan 2021 17:09:13 -0500
Received: from mail-qk1-x72c.google.com (mail-qk1-x72c.google.com [IPv6:2607:f8b0:4864:20::72c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 541EBC0612F4
        for <stable@vger.kernel.org>; Thu,  7 Jan 2021 14:08:33 -0800 (PST)
Received: by mail-qk1-x72c.google.com with SMTP id n142so6987266qkn.2
        for <stable@vger.kernel.org>; Thu, 07 Jan 2021 14:08:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ygm22H9Zo1y2Pjo2hIggiVafx+Xxm1wsNSuAi3DruUI=;
        b=CRX+do8DpP2MULpKmYmrXOsT1g5jOIUcbik8pPsR4hcu0hI0yDq4DznCreYOOWe/Di
         DGPb6m1VBOc6ChdJjC8x87DXcG6QeV9AfBfe5cu8dDHWGaWt14k3j6Wi3o7EUJcnBVzw
         Pg3IIHCPJbsJknhLWfH9gbV5FZIfIp//XKJvAx2QQxABbplk5g9/Rcpx4upr34sBSh9S
         tjuerh/g6tkltufvdL6y4BAqKp+Pk+MVhy5MQIOUSuhEI6zmTsBI4u1WcLEzR/FCqW1r
         dwHQ1bwbPicO/SvfDH4Ryk7/lS4XoewyvPrRe1pr4aM0ZHVlAhSx7/0IFDAvclWUyPSm
         yv/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ygm22H9Zo1y2Pjo2hIggiVafx+Xxm1wsNSuAi3DruUI=;
        b=VOBa1Y4nKX7rsKBiLHgbCTjf4STxpjLXtibeqAzQcmXfgwoGj3/JrN6tlUquA/MkKJ
         XoC2FEmV5fGn9F12QV96inrXnkaOTuUjwr8pQE3mdFF6lpMUnTOHM2rLh+7Gfg2U/oo3
         O/wh6YbyG4ZwIE4elAIodd87vVJ9sbzC9iencED2F7qbdXev1B8R/ANONJB8IqXG4LvG
         f+D5XHWlnejxAwcvaAAHxP7t0LhVrfOAW+upyy+PV6LfQULCW6SBdJMQgIWiHc+S5s4O
         mv1WCnof6Wqd6IbXJFUTv11k/4O2HI6WPBxcHmOhJJDQHXecqm/HLfhaT9TOf2d/rFMm
         ah1Q==
X-Gm-Message-State: AOAM5334IjtDWmWvkhuUc6H3OovKFVbDVGNOAt7nwKNxg/FKVMVJuHO6
        icaKFuvPEL7SToUaYbheEbGwNk3CYy8jnOkm
X-Google-Smtp-Source: ABdhPJw8+sXx4p0QupsWVlAgP3VItI6sWxNBBic1kKYNJEYNZJVmIXP9s3ovKyisQV430MaQHCIy2Q==
X-Received: by 2002:a37:c49:: with SMTP id 70mr1120186qkm.365.1610057312398;
        Thu, 07 Jan 2021 14:08:32 -0800 (PST)
Received: from localhost (cpe-174-109-172-136.nc.res.rr.com. [174.109.172.136])
        by smtp.gmail.com with ESMTPSA id 184sm3950910qkg.92.2021.01.07.14.08.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 14:08:31 -0800 (PST)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Cc:     stable@vger.kernel.org,
        =?UTF-8?q?Ren=C3=A9=20Rebe?= <rene@exactcode.de>
Subject: [PATCH v3] btrfs: shrink delalloc pages instead of full inodes
Date:   Thu,  7 Jan 2021 17:08:30 -0500
Message-Id: <5618514ccb0d1e823fe5ae41b3da6e1e76ddd792.1610057243.git.josef@toxicpanda.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 38d715f494f2 ("btrfs: use btrfs_start_delalloc_roots in
shrink_delalloc") cleaned up how we do delalloc shrinking by utilizing
some infrastructure we have in place to flush inodes that we use for
device replace and snapshot.  However this introduced a pretty serious
performance regression.  To reproduce the user untarred the source
tarball of Firefox, and would see it take anywhere from 5 to 20 times as
long to untar in 5.10 compared to 5.9.

The root cause is because before we would generally use the normal
writeback path to reclaim delalloc space, and for this we would provide
it with the number of pages we wanted to flush.  The referenced commit
changed this to flush that many inodes, which drastically increased the
amount of space we were flushing in certain cases, which severely
affected performance.

We cannot revert this patch unfortunately because of

	btrfs: fix deadlock when cloning inline extent and low on free
		metadata space

which requires the ability to skip flushing inodes that are being cloned
in certain scenarios, which means we need to keep using our flushing
infrastructure or risk re-introducing the deadlock.

Instead to fix this problem we can go back to providing
btrfs_start_delalloc_roots with a number of pages to flush, and then set
up a writeback_control and utilize sync_inode() to handle the flushing
for us.  This gives us the same behavior we had prior to the fix, while
still allowing us to avoid the deadlock that was fixed by Filipe.  I
redid the users original test and got the following results on one of
our test machines (256gib of ram, 56 cores, 2tib Intel NVME drive)

5.9		0m54.258s
5.10		1m26.212s
5.10+patch	0m38.800s

5.10+patch is significantly faster than plain 5.9 because of my patch
series "Change data reservations to use the ticketing infra" which
contained the patch that introduced the regression, but generally
improved the overall ENOSPC flushing mechanisms.

CC: stable@vger.kernel.org # 5.10
Reported-by: René Rebe <rene@exactcode.de>
Fixes: 38d715f494f2 ("btrfs: use btrfs_start_delalloc_roots in shrink_delalloc")
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
v2->v3:
- modified the changelog to add information about the patches referenced, and
  detail the specs of the machine I used for the performance numbers.

 fs/btrfs/inode.c      | 60 +++++++++++++++++++++++++++++++------------
 fs/btrfs/space-info.c |  4 ++-
 2 files changed, 46 insertions(+), 18 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 070716650df8..a8e0a6b038d3 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -9390,7 +9390,8 @@ static struct btrfs_delalloc_work *btrfs_alloc_delalloc_work(struct inode *inode
  * some fairly slow code that needs optimization. This walks the list
  * of all the inodes with pending delalloc and forces them to disk.
  */
-static int start_delalloc_inodes(struct btrfs_root *root, u64 *nr, bool snapshot,
+static int start_delalloc_inodes(struct btrfs_root *root,
+				 struct writeback_control *wbc, bool snapshot,
 				 bool in_reclaim_context)
 {
 	struct btrfs_inode *binode;
@@ -9399,6 +9400,7 @@ static int start_delalloc_inodes(struct btrfs_root *root, u64 *nr, bool snapshot
 	struct list_head works;
 	struct list_head splice;
 	int ret = 0;
+	bool full_flush = wbc->nr_to_write == LONG_MAX;
 
 	INIT_LIST_HEAD(&works);
 	INIT_LIST_HEAD(&splice);
@@ -9427,18 +9429,24 @@ static int start_delalloc_inodes(struct btrfs_root *root, u64 *nr, bool snapshot
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
@@ -9464,18 +9472,29 @@ static int start_delalloc_inodes(struct btrfs_root *root, u64 *nr, bool snapshot
 
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
@@ -9489,6 +9508,13 @@ int btrfs_start_delalloc_roots(struct btrfs_fs_info *fs_info, u64 nr,
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
@@ -9497,9 +9523,9 @@ int btrfs_start_delalloc_roots(struct btrfs_fs_info *fs_info, u64 nr,
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
index 67e55c5479b8..e8347461c8dd 100644
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
2.26.2

