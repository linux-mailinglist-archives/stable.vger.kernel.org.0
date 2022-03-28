Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDA864EA001
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 21:43:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242498AbiC1ToR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Mar 2022 15:44:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343574AbiC1ToF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 15:44:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B8225E169;
        Mon, 28 Mar 2022 12:42:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3295FB81214;
        Mon, 28 Mar 2022 19:42:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0537CC36AE5;
        Mon, 28 Mar 2022 19:42:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648496537;
        bh=lNpPtBPmupGdvKQXKwMAimjlb9x/Xk2tXHvLiWg62cc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fRvDzdHyAFOnmQHh6mzowG/oGQ4x1R5eUWQ0vXArSjRaAiFcZ4/jzK2IaRjvy6TyH
         2OKDOp/5hKtPXbYnmsAtr36c3OtW+LJOl2qhHA0OwpgZ+jMxJwRGfzZmCjZcuC4Z3O
         iuJvCQfsjAKFuuKoXU8mX9wO+gVeAf5TMFQGZ4I1YUaY/b2NDBecsT1iekQiTEId4f
         4mTlZ0Nkm/5n5zBTWn+YjYIQFuxI4IIlcDM/7Uieo12aNEls6hahU/MlP1fwuYzX/R
         a39u+7hnVz9DxhL1CrgLerxI6otslsbTaOAsM693LV0YM+Wk6/vq1FP3ZI2c+PJZKT
         IC2n5mxlfG4SQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, clm@fb.com, jbacik@fb.com,
        linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 15/21] btrfs: do not double complete bio on errors during compressed reads
Date:   Mon, 28 Mar 2022 15:41:50 -0400
Message-Id: <20220328194157.1585642-15-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220328194157.1585642-1-sashal@kernel.org>
References: <20220328194157.1585642-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit f9f15de85d74e7eef021af059ca53a15f041cdd8 ]

I hit some weird panics while fixing up the error handling from
btrfs_lookup_bio_sums().  Turns out the compression path will complete
the bio we use if we set up any of the compression bios and then return
an error, and then btrfs_submit_data_bio() will also call bio_endio() on
the bio.

Fix this by making btrfs_submit_compressed_read() responsible for
calling bio_endio() on the bio if there are any errors.  Currently it
was only doing it if we created the compression bios, otherwise it was
depending on btrfs_submit_data_bio() to do the right thing.  This
creates the above problem, so fix up btrfs_submit_compressed_read() to
always call bio_endio() in case of an error, and then simply return from
btrfs_submit_data_bio() if we had to call
btrfs_submit_compressed_read().

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/compression.c | 20 ++++++++++++++------
 fs/btrfs/inode.c       |  8 +++++++-
 2 files changed, 21 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 8b3bca269de3..59f50d362db3 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -808,7 +808,7 @@ blk_status_t btrfs_submit_compressed_read(struct inode *inode, struct bio *bio,
 	u64 em_len;
 	u64 em_start;
 	struct extent_map *em;
-	blk_status_t ret = BLK_STS_RESOURCE;
+	blk_status_t ret;
 	int faili = 0;
 	u8 *sums;
 
@@ -821,14 +821,18 @@ blk_status_t btrfs_submit_compressed_read(struct inode *inode, struct bio *bio,
 	read_lock(&em_tree->lock);
 	em = lookup_extent_mapping(em_tree, file_offset, fs_info->sectorsize);
 	read_unlock(&em_tree->lock);
-	if (!em)
-		return BLK_STS_IOERR;
+	if (!em) {
+		ret = BLK_STS_IOERR;
+		goto out;
+	}
 
 	ASSERT(em->compress_type != BTRFS_COMPRESS_NONE);
 	compressed_len = em->block_len;
 	cb = kmalloc(compressed_bio_size(fs_info, compressed_len), GFP_NOFS);
-	if (!cb)
+	if (!cb) {
+		ret = BLK_STS_RESOURCE;
 		goto out;
+	}
 
 	refcount_set(&cb->pending_sectors, compressed_len >> fs_info->sectorsize_bits);
 	cb->errors = 0;
@@ -851,8 +855,10 @@ blk_status_t btrfs_submit_compressed_read(struct inode *inode, struct bio *bio,
 	nr_pages = DIV_ROUND_UP(compressed_len, PAGE_SIZE);
 	cb->compressed_pages = kcalloc(nr_pages, sizeof(struct page *),
 				       GFP_NOFS);
-	if (!cb->compressed_pages)
+	if (!cb->compressed_pages) {
+		ret = BLK_STS_RESOURCE;
 		goto fail1;
+	}
 
 	for (pg_index = 0; pg_index < nr_pages; pg_index++) {
 		cb->compressed_pages[pg_index] = alloc_page(GFP_NOFS);
@@ -938,7 +944,7 @@ blk_status_t btrfs_submit_compressed_read(struct inode *inode, struct bio *bio,
 			comp_bio = NULL;
 		}
 	}
-	return 0;
+	return BLK_STS_OK;
 
 fail2:
 	while (faili >= 0) {
@@ -951,6 +957,8 @@ blk_status_t btrfs_submit_compressed_read(struct inode *inode, struct bio *bio,
 	kfree(cb);
 out:
 	free_extent_map(em);
+	bio->bi_status = ret;
+	bio_endio(bio);
 	return ret;
 finish_cb:
 	if (comp_bio) {
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 826f94b2fda5..5aace4c13519 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2538,10 +2538,15 @@ blk_status_t btrfs_submit_data_bio(struct inode *inode, struct bio *bio,
 			goto out;
 
 		if (bio_flags & EXTENT_BIO_COMPRESSED) {
+			/*
+			 * btrfs_submit_compressed_read will handle completing
+			 * the bio if there were any errors, so just return
+			 * here.
+			 */
 			ret = btrfs_submit_compressed_read(inode, bio,
 							   mirror_num,
 							   bio_flags);
-			goto out;
+			goto out_no_endio;
 		} else {
 			/*
 			 * Lookup bio sums does extra checks around whether we
@@ -2575,6 +2580,7 @@ blk_status_t btrfs_submit_data_bio(struct inode *inode, struct bio *bio,
 		bio->bi_status = ret;
 		bio_endio(bio);
 	}
+out_no_endio:
 	return ret;
 }
 
-- 
2.34.1

