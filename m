Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 132D576D31
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 17:31:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389283AbfGZPb2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 11:31:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:46498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389280AbfGZPb2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jul 2019 11:31:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ED7A122BF5;
        Fri, 26 Jul 2019 15:31:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564155087;
        bh=Gmf3x3FBU965p7dUHwskFfW4rkX733qy8oCVaRR3zLY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wOxtH/g9o7yoZye4GFCubE+BZOPNuFTJuLpKf6zVK6CaimLxymofUxt+42GzMzf/o
         3INVIRbS5ejF4OEoDrcBwDv2fOILcLo7LCIYQNDvKUBW2aYCMXpAAYBt3PFy4jU3ya
         MIYx6MxY/nXVmARG4xTCI/Q2AwM+mCsmCMxksH3U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.1 61/62] block: Limit zone array allocation size
Date:   Fri, 26 Jul 2019 17:25:13 +0200
Message-Id: <20190726152308.297783287@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190726152301.720139286@linuxfoundation.org>
References: <20190726152301.720139286@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Damien Le Moal <damien.lemoal@wdc.com>

commit 26202928fafad8bda8b478edb7e62c885be623d7 upstream.

Limit the size of the struct blk_zone array used in
blk_revalidate_disk_zones() to avoid memory allocation failures leading
to disk revalidation failure. Also further reduce the likelyhood of
such failures by using kvcalloc() (that is vmalloc()) instead of
allocating contiguous pages with alloc_pages().

Fixes: 515ce6061312 ("scsi: sd_zbc: Fix sd_zbc_report_zones() buffer allocation")
Fixes: e76239a3748c ("block: add a report_zones method")
Cc: stable@vger.kernel.org
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 block/blk-zoned.c      |   46 ++++++++++++++++++++++++++++++----------------
 include/linux/blkdev.h |    5 +++++
 2 files changed, 35 insertions(+), 16 deletions(-)

--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -13,6 +13,9 @@
 #include <linux/rbtree.h>
 #include <linux/blkdev.h>
 #include <linux/blk-mq.h>
+#include <linux/mm.h>
+#include <linux/vmalloc.h>
+#include <linux/sched/mm.h>
 
 #include "blk.h"
 
@@ -372,22 +375,25 @@ static inline unsigned long *blk_alloc_z
  * Allocate an array of struct blk_zone to get nr_zones zone information.
  * The allocated array may be smaller than nr_zones.
  */
-static struct blk_zone *blk_alloc_zones(int node, unsigned int *nr_zones)
+static struct blk_zone *blk_alloc_zones(unsigned int *nr_zones)
 {
-	size_t size = *nr_zones * sizeof(struct blk_zone);
-	struct page *page;
-	int order;
-
-	for (order = get_order(size); order >= 0; order--) {
-		page = alloc_pages_node(node, GFP_NOIO | __GFP_ZERO, order);
-		if (page) {
-			*nr_zones = min_t(unsigned int, *nr_zones,
-				(PAGE_SIZE << order) / sizeof(struct blk_zone));
-			return page_address(page);
-		}
+	struct blk_zone *zones;
+	size_t nrz = min(*nr_zones, BLK_ZONED_REPORT_MAX_ZONES);
+
+	/*
+	 * GFP_KERNEL here is meaningless as the caller task context has
+	 * the PF_MEMALLOC_NOIO flag set in blk_revalidate_disk_zones()
+	 * with memalloc_noio_save().
+	 */
+	zones = kvcalloc(nrz, sizeof(struct blk_zone), GFP_KERNEL);
+	if (!zones) {
+		*nr_zones = 0;
+		return NULL;
 	}
 
-	return NULL;
+	*nr_zones = nrz;
+
+	return zones;
 }
 
 void blk_queue_free_zone_bitmaps(struct request_queue *q)
@@ -414,6 +420,7 @@ int blk_revalidate_disk_zones(struct gen
 	unsigned long *seq_zones_wlock = NULL, *seq_zones_bitmap = NULL;
 	unsigned int i, rep_nr_zones = 0, z = 0, nrz;
 	struct blk_zone *zones = NULL;
+	unsigned int noio_flag;
 	sector_t sector = 0;
 	int ret = 0;
 
@@ -426,6 +433,12 @@ int blk_revalidate_disk_zones(struct gen
 		return 0;
 	}
 
+	/*
+	 * Ensure that all memory allocations in this context are done as
+	 * if GFP_NOIO was specified.
+	 */
+	noio_flag = memalloc_noio_save();
+
 	if (!blk_queue_is_zoned(q) || !nr_zones) {
 		nr_zones = 0;
 		goto update;
@@ -442,7 +455,7 @@ int blk_revalidate_disk_zones(struct gen
 
 	/* Get zone information and initialize seq_zones_bitmap */
 	rep_nr_zones = nr_zones;
-	zones = blk_alloc_zones(q->node, &rep_nr_zones);
+	zones = blk_alloc_zones(&rep_nr_zones);
 	if (!zones)
 		goto out;
 
@@ -479,8 +492,9 @@ update:
 	blk_mq_unfreeze_queue(q);
 
 out:
-	free_pages((unsigned long)zones,
-		   get_order(rep_nr_zones * sizeof(struct blk_zone)));
+	memalloc_noio_restore(noio_flag);
+
+	kvfree(zones);
 	kfree(seq_zones_wlock);
 	kfree(seq_zones_bitmap);
 
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -344,6 +344,11 @@ struct queue_limits {
 
 #ifdef CONFIG_BLK_DEV_ZONED
 
+/*
+ * Maximum number of zones to report with a single report zones command.
+ */
+#define BLK_ZONED_REPORT_MAX_ZONES	8192U
+
 extern unsigned int blkdev_nr_zones(struct block_device *bdev);
 extern int blkdev_report_zones(struct block_device *bdev,
 			       sector_t sector, struct blk_zone *zones,


