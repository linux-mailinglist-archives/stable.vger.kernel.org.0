Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65A5A71792
	for <lists+stable@lfdr.de>; Tue, 23 Jul 2019 13:57:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730349AbfGWL5M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jul 2019 07:57:12 -0400
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:47709 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728418AbfGWL5L (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Jul 2019 07:57:11 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id AE7355E5;
        Tue, 23 Jul 2019 07:57:10 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Tue, 23 Jul 2019 07:57:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=QhaYYj
        cgeSUon2bUR3TH2XCMRoUwykRE4CZgr8wMPIU=; b=Dj9g++OwneL+5pCQNJfNIq
        eRaSBCvNargAdO+T1vR3rR4J0dAGD6w3l6c1bwuElllXgpk1SxUhlPrHDpDzOyq8
        DKIFmtoblUAzuvv9z0GNNqLf+9dOKzN1yMJErToWJlb4K9FZqL12CJJBocRf02/3
        CiYwhscgUyMeH8cEdt72tEeLurPxEjl8CsWrJPm4eNohy4Ki8XKExdserUGmYIgl
        ENed8SY2kyAeisRl1vjWqeq+Hzrk1/bf7gSdGiTj4ndtJO8i5uvEI8/tjJVG870C
        0O1eKovUrFQ5zLFDQr3K+1u1OlXmJdfq2CzIRHJC/gkmhjRLw/bdNLjUm9wdv7wg
        ==
X-ME-Sender: <xms:FvY2XetYYZGRkRNmEf7ENELU4JuFLwj_2FWNkhBWtxO6VQKseqXIbg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrjeekgdegjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedu
X-ME-Proxy: <xmx:FvY2XYKBqj6FsqdBtMl2DDLzXY7OqazEbkHAD289ugpBxwxADoFg8A>
    <xmx:FvY2XaBYumHmWWk-dfa_HdVfyLG4mDtIdeRjW8gRv1tfVgSZGKcCZg>
    <xmx:FvY2XdW4N4bKfQSUFnoL5emMD-OpWxSTybY7QJyQzMLHe6dm7eyPxg>
    <xmx:FvY2XTklroggTiy6XaBZIsI2MKdtYSrYdpLMPpzRasXQyYvTvUSpZg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id AB1CD8005C;
        Tue, 23 Jul 2019 07:57:09 -0400 (EDT)
Subject: FAILED: patch "[PATCH] block: Limit zone array allocation size" failed to apply to 5.1-stable tree
To:     damien.lemoal@wdc.com, axboe@kernel.dk, hch@lst.de,
        martin.petersen@oracle.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 23 Jul 2019 13:56:59 +0200
Message-ID: <1563883019244153@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.1-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 26202928fafad8bda8b478edb7e62c885be623d7 Mon Sep 17 00:00:00 2001
From: Damien Le Moal <damien.lemoal@wdc.com>
Date: Mon, 1 Jul 2019 14:09:18 +0900
Subject: [PATCH] block: Limit zone array allocation size

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

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index 58ced170b424..6c503824ba3f 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -14,6 +14,8 @@
 #include <linux/rbtree.h>
 #include <linux/blkdev.h>
 #include <linux/blk-mq.h>
+#include <linux/mm.h>
+#include <linux/vmalloc.h>
 #include <linux/sched/mm.h>
 
 #include "blk.h"
@@ -371,22 +373,25 @@ static inline unsigned long *blk_alloc_zone_bitmap(int node,
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
@@ -448,7 +453,7 @@ int blk_revalidate_disk_zones(struct gendisk *disk)
 
 	/* Get zone information and initialize seq_zones_bitmap */
 	rep_nr_zones = nr_zones;
-	zones = blk_alloc_zones(q->node, &rep_nr_zones);
+	zones = blk_alloc_zones(&rep_nr_zones);
 	if (!zones)
 		goto out;
 
@@ -487,8 +492,7 @@ int blk_revalidate_disk_zones(struct gendisk *disk)
 out:
 	memalloc_noio_restore(noio_flag);
 
-	free_pages((unsigned long)zones,
-		   get_order(rep_nr_zones * sizeof(struct blk_zone)));
+	kvfree(zones);
 	kfree(seq_zones_wlock);
 	kfree(seq_zones_bitmap);
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 05036e3e3458..1ef375dafb1c 100644
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

