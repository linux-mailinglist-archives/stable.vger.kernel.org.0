Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B79D838EFA1
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:57:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235372AbhEXP6q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:58:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:42834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235397AbhEXP5z (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:57:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8D5F4613BF;
        Mon, 24 May 2021 15:43:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621871027;
        bh=AwsFzr+m3jBYFBPWOAogj6ndrKrIURfhbUoGlk+sfDw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k49rxTkAKRf+XxxYVIe2RZzPCeWBX5VR8owyQOIGyj15uCV557J9BK912VwMPZ/CO
         EHgLOkTsP7OXE6kNfRl446EW7CCyB2n8NlcBvBRIOIACfN+RcqbLn0YzC9pEzaA8dd
         XLG4x0s7SwScc4RHODN7W5C4oRp8HKc62kDT9ojg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Sterba <dsterba@suse.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH 5.12 038/127] btrfs: zoned: fix parallel compressed writes
Date:   Mon, 24 May 2021 17:25:55 +0200
Message-Id: <20210524152336.139215075@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524152334.857620285@linuxfoundation.org>
References: <20210524152334.857620285@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Thumshirn <johannes.thumshirn@wdc.com>

commit 764c7c9a464b68f7c6a5a9ec0b923176a05e8e8f upstream.

When multiple processes write data to the same block group on a
compressed zoned filesystem, the underlying device could report I/O
errors and data corruption is possible.

This happens because on a zoned file system, compressed data writes
where sent to the device via a REQ_OP_WRITE instead of a
REQ_OP_ZONE_APPEND operation. But with REQ_OP_WRITE and parallel
submission it cannot be guaranteed that the data is always submitted
aligned to the underlying zone's write pointer.

The change to using REQ_OP_ZONE_APPEND instead of REQ_OP_WRITE on a
zoned filesystem is non intrusive on a regular file system or when
submitting to a conventional zone on a zoned filesystem, as it is
guarded by btrfs_use_zone_append.

Reported-by: David Sterba <dsterba@suse.com>
Fixes: 9d294a685fbc ("btrfs: zoned: enable to mount ZONED incompat flag")
CC: stable@vger.kernel.org # 5.12.x: e380adfc213a13: btrfs: zoned: pass start block to btrfs_use_zone_append
CC: stable@vger.kernel.org # 5.12.x
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/compression.c |   42 ++++++++++++++++++++++++++++++++++++++----
 1 file changed, 38 insertions(+), 4 deletions(-)

--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -28,6 +28,7 @@
 #include "compression.h"
 #include "extent_io.h"
 #include "extent_map.h"
+#include "zoned.h"
 
 static const char* const btrfs_compress_types[] = { "", "zlib", "lzo", "zstd" };
 
@@ -349,6 +350,7 @@ static void end_compressed_bio_write(str
 	 */
 	inode = cb->inode;
 	cb->compressed_pages[0]->mapping = cb->inode->i_mapping;
+	btrfs_record_physical_zoned(inode, cb->start, bio);
 	btrfs_writepage_endio_finish_ordered(cb->compressed_pages[0],
 			cb->start, cb->start + cb->len - 1,
 			bio->bi_status == BLK_STS_OK);
@@ -401,6 +403,8 @@ blk_status_t btrfs_submit_compressed_wri
 	u64 first_byte = disk_start;
 	blk_status_t ret;
 	int skip_sum = inode->flags & BTRFS_INODE_NODATASUM;
+	const bool use_append = btrfs_use_zone_append(inode, disk_start);
+	const unsigned int bio_op = use_append ? REQ_OP_ZONE_APPEND : REQ_OP_WRITE;
 
 	WARN_ON(!PAGE_ALIGNED(start));
 	cb = kmalloc(compressed_bio_size(fs_info, compressed_len), GFP_NOFS);
@@ -418,10 +422,31 @@ blk_status_t btrfs_submit_compressed_wri
 	cb->nr_pages = nr_pages;
 
 	bio = btrfs_bio_alloc(first_byte);
-	bio->bi_opf = REQ_OP_WRITE | write_flags;
+	bio->bi_opf = bio_op | write_flags;
 	bio->bi_private = cb;
 	bio->bi_end_io = end_compressed_bio_write;
 
+	if (use_append) {
+		struct extent_map *em;
+		struct map_lookup *map;
+		struct block_device *bdev;
+
+		em = btrfs_get_chunk_map(fs_info, disk_start, PAGE_SIZE);
+		if (IS_ERR(em)) {
+			kfree(cb);
+			bio_put(bio);
+			return BLK_STS_NOTSUPP;
+		}
+
+		map = em->map_lookup;
+		/* We only support single profile for now */
+		ASSERT(map->num_stripes == 1);
+		bdev = map->stripes[0].dev->bdev;
+
+		bio_set_dev(bio, bdev);
+		free_extent_map(em);
+	}
+
 	if (blkcg_css) {
 		bio->bi_opf |= REQ_CGROUP_PUNT;
 		kthread_associate_blkcg(blkcg_css);
@@ -432,6 +457,7 @@ blk_status_t btrfs_submit_compressed_wri
 	bytes_left = compressed_len;
 	for (pg_index = 0; pg_index < cb->nr_pages; pg_index++) {
 		int submit = 0;
+		int len;
 
 		page = compressed_pages[pg_index];
 		page->mapping = inode->vfs_inode.i_mapping;
@@ -439,9 +465,13 @@ blk_status_t btrfs_submit_compressed_wri
 			submit = btrfs_bio_fits_in_stripe(page, PAGE_SIZE, bio,
 							  0);
 
+		if (pg_index == 0 && use_append)
+			len = bio_add_zone_append_page(bio, page, PAGE_SIZE, 0);
+		else
+			len = bio_add_page(bio, page, PAGE_SIZE, 0);
+
 		page->mapping = NULL;
-		if (submit || bio_add_page(bio, page, PAGE_SIZE, 0) <
-		    PAGE_SIZE) {
+		if (submit || len < PAGE_SIZE) {
 			/*
 			 * inc the count before we submit the bio so
 			 * we know the end IO handler won't happen before
@@ -465,11 +495,15 @@ blk_status_t btrfs_submit_compressed_wri
 			}
 
 			bio = btrfs_bio_alloc(first_byte);
-			bio->bi_opf = REQ_OP_WRITE | write_flags;
+			bio->bi_opf = bio_op | write_flags;
 			bio->bi_private = cb;
 			bio->bi_end_io = end_compressed_bio_write;
 			if (blkcg_css)
 				bio->bi_opf |= REQ_CGROUP_PUNT;
+			/*
+			 * Use bio_add_page() to ensure the bio has at least one
+			 * page.
+			 */
 			bio_add_page(bio, page, PAGE_SIZE, 0);
 		}
 		if (bytes_left < PAGE_SIZE) {


