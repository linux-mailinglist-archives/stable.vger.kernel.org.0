Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3180B590145
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 17:52:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236768AbiHKPsr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 11:48:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236567AbiHKPqw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 11:46:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31D10979DC;
        Thu, 11 Aug 2022 08:41:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D1E50B82123;
        Thu, 11 Aug 2022 15:41:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70B78C433D6;
        Thu, 11 Aug 2022 15:41:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660232480;
        bh=0X7d2vVCnscHY+6hmUUVhmuMArqbxKaO7oqZADTT5o0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jGglWDUh1Q/cK8apgeqBB1hOKnI0umhlmO2wo79DYvBZrh4x5vu45VebpHaWYJZEO
         sn/PEdu1zpIb0+UmDBj2ok4IoPIZKsaNigeKp1BgFKL5t29PVPsAmsNEbMSgudUwDB
         O7kv8PeiNx4umu2G5oMC5bVi6hLixH8mMs0wPjQJeozaSCdo/k50PmumAnsMc57VgG
         Rtmh7gCzoTSv5CKRhz/59j6UAMstOHGHwt9p/SMMASScM73ROZ1OaiMC7C+artUl7I
         q6P771CUZZuXR3ZHtvcGBr2XVt97HABM73P7ht2tCFPZi8GqueXFUUKxC1Cy1x4Wnl
         dNgkr17v0phcg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>,
        Nikolay Borisov <nborisov@suse.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, clm@fb.com,
        josef@toxicpanda.com, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.19 094/105] btrfs: repair all known bad mirrors
Date:   Thu, 11 Aug 2022 11:28:18 -0400
Message-Id: <20220811152851.1520029-94-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220811152851.1520029-1-sashal@kernel.org>
References: <20220811152851.1520029-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit c144c63fd33a1fc0e43e0b851a35b09c9460d94d ]

When there is more than a single level of redundancy there can also be
multiple bad mirrors, and the current read repair code only repairs the
last bad one.

Restructure btrfs_repair_one_sector so that it records the originally
failed mirror and the number of copies, and then repair all known bad
copies until we reach the originally failed copy in clean_io_failure.
Note that this also means the read repair reads will always start from
the next bad mirror and not mirror 0.

This fixes btrfs/265 in xfstests.

Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/extent_io.c | 126 +++++++++++++++++++++----------------------
 fs/btrfs/extent_io.h |   1 +
 2 files changed, 61 insertions(+), 66 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index f03ab5dbda7a..48fff4801eb7 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2418,6 +2418,20 @@ int btrfs_repair_eb_io_failure(const struct extent_buffer *eb, int mirror_num)
 	return ret;
 }
 
+static int next_mirror(const struct io_failure_record *failrec, int cur_mirror)
+{
+	if (cur_mirror == failrec->num_copies)
+		return cur_mirror + 1 - failrec->num_copies;
+	return cur_mirror + 1;
+}
+
+static int prev_mirror(const struct io_failure_record *failrec, int cur_mirror)
+{
+	if (cur_mirror == 1)
+		return failrec->num_copies;
+	return cur_mirror - 1;
+}
+
 /*
  * each time an IO finishes, we do a fast check in the IO failure tree
  * to see if we need to process or clean up an io_failure_record
@@ -2430,7 +2444,7 @@ int clean_io_failure(struct btrfs_fs_info *fs_info,
 	u64 private;
 	struct io_failure_record *failrec;
 	struct extent_state *state;
-	int num_copies;
+	int mirror;
 	int ret;
 
 	private = 0;
@@ -2454,20 +2468,19 @@ int clean_io_failure(struct btrfs_fs_info *fs_info,
 					    EXTENT_LOCKED);
 	spin_unlock(&io_tree->lock);
 
-	if (state && state->start <= failrec->start &&
-	    state->end >= failrec->start + failrec->len - 1) {
-		num_copies = btrfs_num_copies(fs_info, failrec->logical,
-					      failrec->len);
-		if (num_copies > 1)  {
-			repair_io_failure(fs_info, ino, start, failrec->len,
-					  failrec->logical, page, pg_offset,
-					  failrec->failed_mirror);
-		}
-	}
+	if (!state || state->start > failrec->start ||
+	    state->end < failrec->start + failrec->len - 1)
+		goto out;
+
+	mirror = failrec->this_mirror;
+	do {
+		mirror = prev_mirror(failrec, mirror);
+		repair_io_failure(fs_info, ino, start, failrec->len,
+				  failrec->logical, page, pg_offset, mirror);
+	} while (mirror != failrec->failed_mirror);
 
 out:
 	free_io_failure(failure_tree, io_tree, failrec);
-
 	return 0;
 }
 
@@ -2506,7 +2519,8 @@ void btrfs_free_io_failure_record(struct btrfs_inode *inode, u64 start, u64 end)
 }
 
 static struct io_failure_record *btrfs_get_io_failure_record(struct inode *inode,
-							     u64 start)
+							     u64 start,
+							     int failed_mirror)
 {
 	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
 	struct io_failure_record *failrec;
@@ -2528,7 +2542,8 @@ static struct io_failure_record *btrfs_get_io_failure_record(struct inode *inode
 		 * (e.g. with a list for failed_mirror) to make
 		 * clean_io_failure() clean all those errors at once.
 		 */
-
+		ASSERT(failrec->this_mirror == failed_mirror);
+		ASSERT(failrec->len == fs_info->sectorsize);
 		return failrec;
 	}
 
@@ -2538,7 +2553,8 @@ static struct io_failure_record *btrfs_get_io_failure_record(struct inode *inode
 
 	failrec->start = start;
 	failrec->len = sectorsize;
-	failrec->this_mirror = 0;
+	failrec->failed_mirror = failed_mirror;
+	failrec->this_mirror = failed_mirror;
 	failrec->compress_type = BTRFS_COMPRESS_NONE;
 
 	read_lock(&em_tree->lock);
@@ -2573,6 +2589,20 @@ static struct io_failure_record *btrfs_get_io_failure_record(struct inode *inode
 	failrec->logical = logical;
 	free_extent_map(em);
 
+	failrec->num_copies = btrfs_num_copies(fs_info, logical, sectorsize);
+	if (failrec->num_copies == 1) {
+		/*
+		 * We only have a single copy of the data, so don't bother with
+		 * all the retry and error correction code that follows. No
+		 * matter what the error is, it is very likely to persist.
+		 */
+		btrfs_debug(fs_info,
+			"cannot repair logical %llu num_copies %d",
+			failrec->logical, failrec->num_copies);
+		kfree(failrec);
+		return ERR_PTR(-EIO);
+	}
+
 	/* Set the bits in the private failure tree */
 	ret = set_extent_bits(failure_tree, start, start + sectorsize - 1,
 			      EXTENT_LOCKED | EXTENT_DIRTY);
@@ -2589,54 +2619,6 @@ static struct io_failure_record *btrfs_get_io_failure_record(struct inode *inode
 	return failrec;
 }
 
-static bool btrfs_check_repairable(struct inode *inode,
-				   struct io_failure_record *failrec,
-				   int failed_mirror)
-{
-	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
-	int num_copies;
-
-	num_copies = btrfs_num_copies(fs_info, failrec->logical, failrec->len);
-	if (num_copies == 1) {
-		/*
-		 * we only have a single copy of the data, so don't bother with
-		 * all the retry and error correction code that follows. no
-		 * matter what the error is, it is very likely to persist.
-		 */
-		btrfs_debug(fs_info,
-			"Check Repairable: cannot repair, num_copies=%d, next_mirror %d, failed_mirror %d",
-			num_copies, failrec->this_mirror, failed_mirror);
-		return false;
-	}
-
-	/* The failure record should only contain one sector */
-	ASSERT(failrec->len == fs_info->sectorsize);
-
-	/*
-	 * There are two premises:
-	 * a) deliver good data to the caller
-	 * b) correct the bad sectors on disk
-	 *
-	 * Since we're only doing repair for one sector, we only need to get
-	 * a good copy of the failed sector and if we succeed, we have setup
-	 * everything for repair_io_failure to do the rest for us.
-	 */
-	ASSERT(failed_mirror);
-	failrec->failed_mirror = failed_mirror;
-	failrec->this_mirror++;
-	if (failrec->this_mirror == failed_mirror)
-		failrec->this_mirror++;
-
-	if (failrec->this_mirror > num_copies) {
-		btrfs_debug(fs_info,
-			"Check Repairable: (fail) num_copies=%d, next_mirror %d, failed_mirror %d",
-			num_copies, failrec->this_mirror, failed_mirror);
-		return false;
-	}
-
-	return true;
-}
-
 int btrfs_repair_one_sector(struct inode *inode,
 			    struct bio *failed_bio, u32 bio_offset,
 			    struct page *page, unsigned int pgoff,
@@ -2657,12 +2639,24 @@ int btrfs_repair_one_sector(struct inode *inode,
 
 	BUG_ON(bio_op(failed_bio) == REQ_OP_WRITE);
 
-	failrec = btrfs_get_io_failure_record(inode, start);
+	failrec = btrfs_get_io_failure_record(inode, start, failed_mirror);
 	if (IS_ERR(failrec))
 		return PTR_ERR(failrec);
 
-
-	if (!btrfs_check_repairable(inode, failrec, failed_mirror)) {
+	/*
+	 * There are two premises:
+	 * a) deliver good data to the caller
+	 * b) correct the bad sectors on disk
+	 *
+	 * Since we're only doing repair for one sector, we only need to get
+	 * a good copy of the failed sector and if we succeed, we have setup
+	 * everything for repair_io_failure to do the rest for us.
+	 */
+	failrec->this_mirror = next_mirror(failrec, failrec->this_mirror);
+	if (failrec->this_mirror == failrec->failed_mirror) {
+		btrfs_debug(fs_info,
+			"failed to repair num_copies %d this_mirror %d failed_mirror %d",
+			failrec->num_copies, failrec->this_mirror, failrec->failed_mirror);
 		free_io_failure(failure_tree, tree, failrec);
 		return -EIO;
 	}
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 23d4103c8831..acee497bab7b 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -269,6 +269,7 @@ struct io_failure_record {
 	enum btrfs_compression_type compress_type;
 	int this_mirror;
 	int failed_mirror;
+	int num_copies;
 };
 
 int btrfs_repair_one_sector(struct inode *inode,
-- 
2.35.1

