Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A68571C4535
	for <lists+stable@lfdr.de>; Mon,  4 May 2020 20:13:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731150AbgEDSBY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 May 2020 14:01:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:56878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731145AbgEDSBX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 May 2020 14:01:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0A1B0206B8;
        Mon,  4 May 2020 18:01:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588615282;
        bh=7/qnSfUBs+1jIHe1HqF94F0r4bVp2HssIChY1dp/Xlg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s2nHX4Kv3XYWnhjj3vHyfo+bFvThHBrmr22VFqqavo825xCQHHybF7BS0p9iskshZ
         nksGHQG3AbmGny8mycG9TYqm+n8nTfA9Japrj02UJct5i83PECSRqHXw2FIuVK3Ajo
         m5A3YiL5rUC2JPcz/t1XhHl9rRQJBT+t4k09C/Kg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 4.19 13/37] dm writecache: fix data corruption when reloading the target
Date:   Mon,  4 May 2020 19:57:26 +0200
Message-Id: <20200504165449.916465238@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200504165448.264746645@linuxfoundation.org>
References: <20200504165448.264746645@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mikulas Patocka <mpatocka@redhat.com>

commit 31b22120194b5c0d460f59e0c98504de1d3f1f14 upstream.

The dm-writecache reads metadata in the target constructor. However, when
we reload the target, there could be another active instance running on
the same device. This is the sequence of operations when doing a reload:

1. construct new target
2. suspend old target
3. resume new target
4. destroy old target

Metadata that were written by the old target between steps 1 and 2 would
not be visible by the new target.

Fix the data corruption by loading the metadata in the resume handler.

Also, validate block_size is at least as large as both the devices'
logical block size and only read 1 block from the metadata during
target constructor -- no need to read entirety of metadata now that it
is done during resume.

Fixes: 48debafe4f2f ("dm: add writecache target")
Cc: stable@vger.kernel.org # v4.18+
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-writecache.c |   52 ++++++++++++++++++++++++++++++++-------------
 1 file changed, 37 insertions(+), 15 deletions(-)

--- a/drivers/md/dm-writecache.c
+++ b/drivers/md/dm-writecache.c
@@ -884,6 +884,24 @@ static int writecache_alloc_entries(stru
 	return 0;
 }
 
+static int writecache_read_metadata(struct dm_writecache *wc, sector_t n_sectors)
+{
+	struct dm_io_region region;
+	struct dm_io_request req;
+
+	region.bdev = wc->ssd_dev->bdev;
+	region.sector = wc->start_sector;
+	region.count = n_sectors;
+	req.bi_op = REQ_OP_READ;
+	req.bi_op_flags = REQ_SYNC;
+	req.mem.type = DM_IO_VMA;
+	req.mem.ptr.vma = (char *)wc->memory_map;
+	req.client = wc->dm_io;
+	req.notify.fn = NULL;
+
+	return dm_io(&req, 1, &region, NULL);
+}
+
 static void writecache_resume(struct dm_target *ti)
 {
 	struct dm_writecache *wc = ti->private;
@@ -894,8 +912,18 @@ static void writecache_resume(struct dm_
 
 	wc_lock(wc);
 
-	if (WC_MODE_PMEM(wc))
+	if (WC_MODE_PMEM(wc)) {
 		persistent_memory_invalidate_cache(wc->memory_map, wc->memory_map_size);
+	} else {
+		r = writecache_read_metadata(wc, wc->metadata_sectors);
+		if (r) {
+			size_t sb_entries_offset;
+			writecache_error(wc, r, "unable to read metadata: %d", r);
+			sb_entries_offset = offsetof(struct wc_memory_superblock, entries);
+			memset((char *)wc->memory_map + sb_entries_offset, -1,
+			       (wc->metadata_sectors << SECTOR_SHIFT) - sb_entries_offset);
+		}
+	}
 
 	wc->tree = RB_ROOT;
 	INIT_LIST_HEAD(&wc->lru);
@@ -1978,6 +2006,12 @@ static int writecache_ctr(struct dm_targ
 		ti->error = "Invalid block size";
 		goto bad;
 	}
+	if (wc->block_size < bdev_logical_block_size(wc->dev->bdev) ||
+	    wc->block_size < bdev_logical_block_size(wc->ssd_dev->bdev)) {
+		r = -EINVAL;
+		ti->error = "Block size is smaller than device logical block size";
+		goto bad;
+	}
 	wc->block_size_bits = __ffs(wc->block_size);
 
 	wc->max_writeback_jobs = MAX_WRITEBACK_JOBS;
@@ -2066,8 +2100,6 @@ invalid_optional:
 			goto bad;
 		}
 	} else {
-		struct dm_io_region region;
-		struct dm_io_request req;
 		size_t n_blocks, n_metadata_blocks;
 		uint64_t n_bitmap_bits;
 
@@ -2124,19 +2156,9 @@ invalid_optional:
 			goto bad;
 		}
 
-		region.bdev = wc->ssd_dev->bdev;
-		region.sector = wc->start_sector;
-		region.count = wc->metadata_sectors;
-		req.bi_op = REQ_OP_READ;
-		req.bi_op_flags = REQ_SYNC;
-		req.mem.type = DM_IO_VMA;
-		req.mem.ptr.vma = (char *)wc->memory_map;
-		req.client = wc->dm_io;
-		req.notify.fn = NULL;
-
-		r = dm_io(&req, 1, &region, NULL);
+		r = writecache_read_metadata(wc, wc->block_size >> SECTOR_SHIFT);
 		if (r) {
-			ti->error = "Unable to read metadata";
+			ti->error = "Unable to read first block of metadata";
 			goto bad;
 		}
 	}


