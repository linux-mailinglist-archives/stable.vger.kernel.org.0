Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8C8C747E6
	for <lists+stable@lfdr.de>; Thu, 25 Jul 2019 09:12:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387765AbfGYHMU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jul 2019 03:12:20 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:18635 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387780AbfGYHMT (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Jul 2019 03:12:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1564038739; x=1595574739;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=B1ndJYKrHOlxMpdqN9Cjso6sP/9tagzFg3/ntpJzX1M=;
  b=fD5lj98bxXLxI84ywDqlU6/iZhWygVeTw6VHXer42k7bopV4/i+YIgo4
   d2x7YEJKFxCXYlBfXttuGZm9sh7o9UKFt3oM1uhYi91QWgZcBqGZ8+KlG
   UoFHaArze/ueBTFmEO/jxxLmS0O39p1ZWc4vuYciPvasFQYe2GBFw9IaD
   t34Kh+1u2Yuyih54ny8mGzWvnNvhGoswvIN0KEQ+TBweH6jnmQkOG3E0p
   adRjCRziV8Emz6p8eoZEWEgdk/ACbEhPfDEwJNFXrnSPJ4YbylVkfh1zY
   52E4gP0PYdaZZojLvIzh7Ok1LchbjKxSmWnReAQ3IOmxVOd8dSIGGcIIL
   g==;
IronPort-SDR: DML86UFjhpFxB/TXdQg7/OcjWnIJ3ORL3x3lm6w10FsDNL/vwL+uxmb+GkpnKlxfMO/MdtRcQq
 fi0o5/omzJExaLgTMU5sDjUrlPepGGciey6UgWw9/uNlPF6ImqU3ADf+zlDMBipNzSHhjuJ0Yj
 W/5zHT7RQ7eK+X5h/p9QSGMgtFYI5QZBYbtIYyvTxQxLMxXV2Whb0vz7VoDoAjyG4VFVrD7xqX
 UMC7jquryRwoVHW0r+fmr5WZNnIQbRBH8QaI0+5WxieC/ZVVUoIuwqh+LBtyCw+aKKd6utBMwT
 mjg=
X-IronPort-AV: E=Sophos;i="5.64,305,1559491200"; 
   d="scan'208";a="220433746"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 25 Jul 2019 15:12:18 +0800
IronPort-SDR: ODnxW1QmsY4EERIfMWFXMEHrD1E7h6oKmZ8H3Tk4sKTupkaBQ9Gk7VNnxrQhHSbk08d6rRNMIK
 JuMKRKgW3WIg5WlcvAI4d/HAZyr0xHMnQqMzzCzD+pYp7KbYJY6SawOw+cGQjjlMPa2yOH/v6w
 U5npRgpf4s23DnfjNGV8JrrJpA0MBtkCBHFC3SWteZXoY3OwAgOz2dtIHLVHpZIamxrQOrBMjD
 /t3O0L/qZAw5ur9FyArO3Z3zPNi0X07L/pgtLeZ08iHsmthUGQzwMSrgJaTH63acejmuz0o0ic
 ZNUWSt2DQCa+4h6H7FUo/l3S
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP; 25 Jul 2019 00:10:30 -0700
IronPort-SDR: PkSfUnQrHfcLOePiSy616ppI2jmv76fUW/VRn48uHXS3euDoDYkxWoUF7AYw3w9yH8AHO6emvJ
 1L8zYCytZkToA52hco81nku7dTk241EDlarZ1sv025KdFfNxyJG8JLZwf96Q+HbGlPWnyVWIDZ
 AkFp6c5LeBYZq3crKLLJhvPb1XxMw2bEyvWcFM2aJcAV9YIIzJaLzC/HVVZU/Du6SmW79hVCE3
 zx0L5h3URNAuCYVC/WYCzA2CnrajQzVc7n4c8PpSvb6aftTSHByZcY28zZFR1o0w84tsWqgL3O
 59g=
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip01.wdc.com with ESMTP; 25 Jul 2019 00:12:18 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH] block: Limit zone array allocation size
Date:   Thu, 25 Jul 2019 16:12:17 +0900
Message-Id: <20190725071217.15551-2-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190725071217.15551-1-damien.lemoal@wdc.com>
References: <20190725071217.15551-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 26202928fafad8bda8b478edb7e62c885be623d7 upstream.

Limit the size of the struct blk_zone array used in
blk_revalidate_disk_zones() to avoid memory allocation failures leading
to disk revalidation failure. Also further reduce the likelyhood of
such failures by using kvcalloc() (that is vmalloc()) instead of
allocating contiguous pages with alloc_pages().

Fixes: 515ce6061312 ("scsi: sd_zbc: Fix sd_zbc_report_zones() buffer allocation")
Fixes: e76239a3748c ("block: add a report_zones method")
Cc: stable@vger.kernel.org # 5.1.x
Cc: stable@vger.kernel.org # 5.2.x
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 block/blk-zoned.c      | 46 +++++++++++++++++++++++++++---------------
 include/linux/blkdev.h |  5 +++++
 2 files changed, 35 insertions(+), 16 deletions(-)

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index 2d98803faec2..ecae851d063a 100644
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
 
@@ -372,22 +375,25 @@ static inline unsigned long *blk_alloc_zone_bitmap(int node,
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
@@ -414,6 +420,7 @@ int blk_revalidate_disk_zones(struct gendisk *disk)
 	unsigned long *seq_zones_wlock = NULL, *seq_zones_bitmap = NULL;
 	unsigned int i, rep_nr_zones = 0, z = 0, nrz;
 	struct blk_zone *zones = NULL;
+	unsigned int noio_flag;
 	sector_t sector = 0;
 	int ret = 0;
 
@@ -426,6 +433,12 @@ int blk_revalidate_disk_zones(struct gendisk *disk)
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
@@ -442,7 +455,7 @@ int blk_revalidate_disk_zones(struct gendisk *disk)
 
 	/* Get zone information and initialize seq_zones_bitmap */
 	rep_nr_zones = nr_zones;
-	zones = blk_alloc_zones(q->node, &rep_nr_zones);
+	zones = blk_alloc_zones(&rep_nr_zones);
 	if (!zones)
 		goto out;
 
@@ -479,8 +492,9 @@ int blk_revalidate_disk_zones(struct gendisk *disk)
 	blk_mq_unfreeze_queue(q);
 
 out:
-	free_pages((unsigned long)zones,
-		   get_order(rep_nr_zones * sizeof(struct blk_zone)));
+	memalloc_noio_restore(noio_flag);
+
+	kvfree(zones);
 	kfree(seq_zones_wlock);
 	kfree(seq_zones_bitmap);
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 317ab30d2904..01f1eade5319 100644
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
-- 
2.21.0

