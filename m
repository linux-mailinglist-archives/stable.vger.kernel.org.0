Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 393AD4EA0B1
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 21:51:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343697AbiC1Tqi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Mar 2022 15:46:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343690AbiC1Tps (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 15:45:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD9E46833A;
        Mon, 28 Mar 2022 12:42:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8EAF661291;
        Mon, 28 Mar 2022 19:42:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0B3BC36AE2;
        Mon, 28 Mar 2022 19:42:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648496571;
        bh=r22Org1ZbKSB65acS8V3e6cCs/LI69xKLR2hmxYz7jI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MCg/AXr5X2sEMDomaO7oZWxuzs3ITp3NJvPeNf6QxpNHa+aDbdF5+OhdKWNl1dsAJ
         VOtnjOyYAM/LqJ+wVsf+b7v2fFVluDB7QnCO0jlI9plrXAGIOpbjJInyQPd6IpjkcH
         7zYXQHqRqGblCdeJohAssSkRHDH1gLxXld4ooZlQylaY3h6hOLz4laSwhwCQqB/jxT
         u0wV5tQTMTNLWyb4an5y9nrMr83ZItxCANv9utabm1wNqjmQ2tjFHomaiE/q3RVMOT
         JxIBIiSSfSln8QwSA2+SbKBSQZDq6kwDcfjni0vHETBu+31++B6sxKwRxACXrLckCH
         fb5Ht9zvI2mJQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, clm@fb.com, jbacik@fb.com,
        linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 15/20] btrfs: do not double complete bio on errors during compressed reads
Date:   Mon, 28 Mar 2022 15:42:21 -0400
Message-Id: <20220328194226.1585920-15-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220328194226.1585920-1-sashal@kernel.org>
References: <20220328194226.1585920-1-sashal@kernel.org>
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
index b2bb96934a8f..b3ab5a447ada 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -807,7 +807,7 @@ blk_status_t btrfs_submit_compressed_read(struct inode *inode, struct bio *bio,
 	u64 em_len;
 	u64 em_start;
 	struct extent_map *em;
-	blk_status_t ret = BLK_STS_RESOURCE;
+	blk_status_t ret;
 	int faili = 0;
 	u8 *sums;
 
@@ -820,14 +820,18 @@ blk_status_t btrfs_submit_compressed_read(struct inode *inode, struct bio *bio,
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
@@ -850,8 +854,10 @@ blk_status_t btrfs_submit_compressed_read(struct inode *inode, struct bio *bio,
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
@@ -937,7 +943,7 @@ blk_status_t btrfs_submit_compressed_read(struct inode *inode, struct bio *bio,
 			comp_bio = NULL;
 		}
 	}
-	return 0;
+	return BLK_STS_OK;
 
 fail2:
 	while (faili >= 0) {
@@ -950,6 +956,8 @@ blk_status_t btrfs_submit_compressed_read(struct inode *inode, struct bio *bio,
 	kfree(cb);
 out:
 	free_extent_map(em);
+	bio->bi_status = ret;
+	bio_endio(bio);
 	return ret;
 finish_cb:
 	if (comp_bio) {
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 6680e74b1977..27a725814e0b 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2536,10 +2536,15 @@ blk_status_t btrfs_submit_data_bio(struct inode *inode, struct bio *bio,
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
@@ -2573,6 +2578,7 @@ blk_status_t btrfs_submit_data_bio(struct inode *inode, struct bio *bio,
 		bio->bi_status = ret;
 		bio_endio(bio);
 	}
+out_no_endio:
 	return ret;
 }
 
-- 
2.34.1

