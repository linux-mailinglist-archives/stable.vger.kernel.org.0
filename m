Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC3062872E3
	for <lists+stable@lfdr.de>; Thu,  8 Oct 2020 12:56:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729672AbgJHK4N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Oct 2020 06:56:13 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:54884 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729668AbgJHK4M (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Oct 2020 06:56:12 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 098AoG8t078993;
        Thu, 8 Oct 2020 10:55:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2020-01-29; bh=ZvZAHHTU/C6cQ1dNZHy1spHhYmvK+bswmzuSDDFZmmM=;
 b=DilKSKtAFHvOgSKuwjNoPES2nsMlZHb994oYj4iCgJRQHV6liN5ckq5rcOR2FxNJANUa
 EbFiQaDjTplJXiYiUKl39VsAzGqpz8ZdbwjDgJKLmt9HVfmcRtZnnjxpB27W3ZD2YrXU
 3EoIOKnRhxZ0O0A/tQ8EoCAOfXLrl861/ws80IDSmR/V6vb6VJ9I39x66F0lwTALsAVN
 3f5yzu7vRqBlGcKFs2JBKwN6mGbTMKUuWAtSTYIErDlP2FLlcU0C+Xnr8AlX6BznYvAG
 aLhjcPiOEGJhkAjNpw34sg1iSBSRrk7xuW0zzY+RvlV78wHabpuh+ArYFwslxlj1251X PQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 33xetb75j1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 08 Oct 2020 10:55:57 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 098Astrj087645;
        Thu, 8 Oct 2020 10:55:56 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 3410k0yv3c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Oct 2020 10:55:56 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 098AttsP018183;
        Thu, 8 Oct 2020 10:55:55 GMT
Received: from ltp.sg.oracle.com (/10.191.35.225)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 08 Oct 2020 03:55:54 -0700
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     robbieko@synology.com, fdmanana@suse.com, dsterba@suse.com,
        linux-btrfs@vger.kernel.org
Subject: [PATCH stable-4.14.y] Btrfs: fix unexpected failure of nocow buffered writes after snapshotting when low on space
Date:   Thu,  8 Oct 2020 18:55:45 +0800
Message-Id: <82a2f4d5d8a847ac005356cbdb065e28c867e91c.1602130595.git.anand.jain@oracle.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9767 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 spamscore=0
 adultscore=0 bulkscore=0 malwarescore=0 suspectscore=2 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010080081
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9767 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxscore=0
 clxscore=1011 priorityscore=1501 adultscore=0 mlxlogscore=999 phishscore=0
 impostorscore=0 malwarescore=0 suspectscore=2 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010080080
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robbie Ko <robbieko@synology.com>

[ Upstream commit 8ecebf4d767e2307a946c8905278d6358eda35c3 ]

Commit e9894fd3e3b3 ("Btrfs: fix snapshot vs nocow writting") forced
nocow writes to fallback to COW, during writeback, when a snapshot is
created. This resulted in writes made before creating the snapshot to
unexpectedly fail with ENOSPC during writeback when success (0) was
returned to user space through the write system call.

The steps leading to this problem are:

1. When it's not possible to allocate data space for a write, the
   buffered write path checks if a NOCOW write is possible.  If it is,
   it will not reserve space and success (0) is returned to user space.

2. Then when a snapshot is created, the root's will_be_snapshotted
   atomic is incremented and writeback is triggered for all inode's that
   belong to the root being snapshotted. Incrementing that atomic forces
   all previous writes to fallback to COW during writeback (running
   delalloc).

3. This results in the writeback for the inodes to fail and therefore
   setting the ENOSPC error in their mappings, so that a subsequent
   fsync on them will report the error to user space. So it's not a
   completely silent data loss (since fsync will report ENOSPC) but it's
   a very unexpected and undesirable behaviour, because if a clean
   shutdown/unmount of the filesystem happens without previous calls to
   fsync, it is expected to have the data present in the files after
   mounting the filesystem again.

So fix this by adding a new atomic named snapshot_force_cow to the
root structure which prevents this behaviour and works the following way:

1. It is incremented when we start to create a snapshot after triggering
   writeback and before waiting for writeback to finish.

2. This new atomic is now what is used by writeback (running delalloc)
   to decide whether we need to fallback to COW or not. Because we
   incremented this new atomic after triggering writeback in the
   snapshot creation ioctl, we ensure that all buffered writes that
   happened before snapshot creation will succeed and not fallback to
   COW (which would make them fail with ENOSPC).

3. The existing atomic, will_be_snapshotted, is kept because it is used
   to force new buffered writes, that start after we started
   snapshotting, to reserve data space even when NOCOW is possible.
   This makes these writes fail early with ENOSPC when there's no
   available space to allocate, preventing the unexpected behaviour of
   writeback later failing with ENOSPC due to a fallback to COW mode.

Fixes: e9894fd3e3b3 ("Btrfs: fix snapshot vs nocow writting")
Signed-off-by: Robbie Ko <robbieko@synology.com>
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Anand Jain <anand.jain@oracle.com>
 Conflicts:
	fs/btrfs/disk-io.c
---
 fs/btrfs/ctree.h   |  1 +
 fs/btrfs/disk-io.c |  1 +
 fs/btrfs/inode.c   | 25 ++++---------------------
 fs/btrfs/ioctl.c   | 16 ++++++++++++++++
 4 files changed, 22 insertions(+), 21 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index de951987fd23..19a668e9164b 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1257,6 +1257,7 @@ struct btrfs_root {
 	int send_in_progress;
 	struct btrfs_subvolume_writers *subv_writers;
 	atomic_t will_be_snapshotted;
+	atomic_t snapshot_force_cow;
 
 	/* For qgroup metadata space reserve */
 	atomic64_t qgroup_meta_rsv;
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 495430e4f84b..ace58d6a270b 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1200,6 +1200,7 @@ static void __setup_root(struct btrfs_root *root, struct btrfs_fs_info *fs_info,
 	refcount_set(&root->refs, 1);
 	atomic_set(&root->will_be_snapshotted, 0);
 	atomic64_set(&root->qgroup_meta_rsv, 0);
+	atomic_set(&root->snapshot_force_cow, 0);
 	root->log_transid = 0;
 	root->log_transid_committed = -1;
 	root->last_log_commit = 0;
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index c9e7b92d0f21..e985e820724e 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1335,7 +1335,7 @@ static noinline int run_delalloc_nocow(struct inode *inode,
 	u64 disk_num_bytes;
 	u64 ram_bytes;
 	int extent_type;
-	int ret, err;
+	int ret;
 	int type;
 	int nocow;
 	int check_prev = 1;
@@ -1460,11 +1460,8 @@ static noinline int run_delalloc_nocow(struct inode *inode,
 			 * if there are pending snapshots for this root,
 			 * we fall into common COW way.
 			 */
-			if (!nolock) {
-				err = btrfs_start_write_no_snapshotting(root);
-				if (!err)
-					goto out_check;
-			}
+			if (!nolock && atomic_read(&root->snapshot_force_cow))
+				goto out_check;
 			/*
 			 * force cow if csum exists in the range.
 			 * this ensure that csum for a given extent are
@@ -1473,9 +1470,6 @@ static noinline int run_delalloc_nocow(struct inode *inode,
 			ret = csum_exist_in_range(fs_info, disk_bytenr,
 						  num_bytes);
 			if (ret) {
-				if (!nolock)
-					btrfs_end_write_no_snapshotting(root);
-
 				/*
 				 * ret could be -EIO if the above fails to read
 				 * metadata.
@@ -1488,11 +1482,8 @@ static noinline int run_delalloc_nocow(struct inode *inode,
 				WARN_ON_ONCE(nolock);
 				goto out_check;
 			}
-			if (!btrfs_inc_nocow_writers(fs_info, disk_bytenr)) {
-				if (!nolock)
-					btrfs_end_write_no_snapshotting(root);
+			if (!btrfs_inc_nocow_writers(fs_info, disk_bytenr))
 				goto out_check;
-			}
 			nocow = 1;
 		} else if (extent_type == BTRFS_FILE_EXTENT_INLINE) {
 			extent_end = found_key.offset +
@@ -1505,8 +1496,6 @@ static noinline int run_delalloc_nocow(struct inode *inode,
 out_check:
 		if (extent_end <= start) {
 			path->slots[0]++;
-			if (!nolock && nocow)
-				btrfs_end_write_no_snapshotting(root);
 			if (nocow)
 				btrfs_dec_nocow_writers(fs_info, disk_bytenr);
 			goto next_slot;
@@ -1528,8 +1517,6 @@ static noinline int run_delalloc_nocow(struct inode *inode,
 					     end, page_started, nr_written, 1,
 					     NULL);
 			if (ret) {
-				if (!nolock && nocow)
-					btrfs_end_write_no_snapshotting(root);
 				if (nocow)
 					btrfs_dec_nocow_writers(fs_info,
 								disk_bytenr);
@@ -1549,8 +1536,6 @@ static noinline int run_delalloc_nocow(struct inode *inode,
 					  ram_bytes, BTRFS_COMPRESS_NONE,
 					  BTRFS_ORDERED_PREALLOC);
 			if (IS_ERR(em)) {
-				if (!nolock && nocow)
-					btrfs_end_write_no_snapshotting(root);
 				if (nocow)
 					btrfs_dec_nocow_writers(fs_info,
 								disk_bytenr);
@@ -1589,8 +1574,6 @@ static noinline int run_delalloc_nocow(struct inode *inode,
 					     EXTENT_CLEAR_DATA_RESV,
 					     PAGE_UNLOCK | PAGE_SET_PRIVATE2);
 
-		if (!nolock && nocow)
-			btrfs_end_write_no_snapshotting(root);
 		cur_offset = extent_end;
 
 		/*
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 73a0fc60e395..56123ce3b9f0 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -655,6 +655,7 @@ static int create_snapshot(struct btrfs_root *root, struct inode *dir,
 	struct btrfs_pending_snapshot *pending_snapshot;
 	struct btrfs_trans_handle *trans;
 	int ret;
+	bool snapshot_force_cow = false;
 
 	if (!test_bit(BTRFS_ROOT_REF_COWS, &root->state))
 		return -EINVAL;
@@ -671,6 +672,11 @@ static int create_snapshot(struct btrfs_root *root, struct inode *dir,
 		goto free_pending;
 	}
 
+	/*
+	 * Force new buffered writes to reserve space even when NOCOW is
+	 * possible. This is to avoid later writeback (running dealloc) to
+	 * fallback to COW mode and unexpectedly fail with ENOSPC.
+	 */
 	atomic_inc(&root->will_be_snapshotted);
 	smp_mb__after_atomic();
 	btrfs_wait_for_no_snapshotting_writes(root);
@@ -679,6 +685,14 @@ static int create_snapshot(struct btrfs_root *root, struct inode *dir,
 	if (ret)
 		goto dec_and_free;
 
+	/*
+	 * All previous writes have started writeback in NOCOW mode, so now
+	 * we force future writes to fallback to COW mode during snapshot
+	 * creation.
+	 */
+	atomic_inc(&root->snapshot_force_cow);
+	snapshot_force_cow = true;
+
 	btrfs_wait_ordered_extents(root, U64_MAX, 0, (u64)-1);
 
 	btrfs_init_block_rsv(&pending_snapshot->block_rsv,
@@ -744,6 +758,8 @@ static int create_snapshot(struct btrfs_root *root, struct inode *dir,
 fail:
 	btrfs_subvolume_release_metadata(fs_info, &pending_snapshot->block_rsv);
 dec_and_free:
+	if (snapshot_force_cow)
+		atomic_dec(&root->snapshot_force_cow);
 	if (atomic_dec_and_test(&root->will_be_snapshotted))
 		wake_up_atomic_t(&root->will_be_snapshotted);
 free_pending:
-- 
2.25.1

