Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1995746C4
	for <lists+stable@lfdr.de>; Thu, 25 Jul 2019 08:04:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727890AbfGYGEz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jul 2019 02:04:55 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:23417 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726547AbfGYGEz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Jul 2019 02:04:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1564034695; x=1595570695;
  h=from:to:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=hKpUPh7Bvj7oZjf/nWIWylvddGgnm5mc31w74D9oudc=;
  b=nqk6vo9NYz5sl6l+YQ2ioo3mBkoUNCu0rsy3gjR2O6/wwJh4Ppm5E3yU
   i4zM97v2OaRpy7tOzrbtH8vy2BbzrQpVA9OAoRhu9z920b2qNyczA0v1h
   rS/hMARvY4QaqQ6J9AQpj7RKjne6rWTIGwQEc30ZVhHbe4R1A7Jr0FAfT
   fF4BPPLRRkMsOl513nSVNYdEhGxTotNw1QFi0w4wQW3n5J7nWFMypZUtR
   7iwahYHzaiZdi842pXV56U0Xa2zGBDvYfrT0Kq5X0+yUm2VR0nLV0CCfE
   WNbRWv38w9TJdvOUEMRcxjjMWS7Mo9LtQoCN6ubSYmZkdlEpyVuMmgIL2
   Q==;
IronPort-SDR: 4NVxLlll8BqMRhCm+WG4AoONw+C/Z6FidE+AYD7hL3bJaWVPn3pkYzyn2UOsGbH8rxwAnFHT5O
 /djYpQhQZgWwwN+8xl6tCvKCoY2PRFakGzJ782X9L4/7RWC9o6CWGPHn8zcu+QA7FQClp01nA4
 BT+mSy1HmEefLSWvOcoZ4Ky4PTv5FA792rXz4F6j6+CsGSnWOvoSQXSgqMjQx02rguTDu1z8U9
 3K5Xb6s0j7qRaUAivCyRz7SiYjYBpXvj8ebHm0mKg6jvBhkg63VVoF2YH1/fk9WSjnqvEpRhzW
 WPM=
X-IronPort-AV: E=Sophos;i="5.64,305,1559491200"; 
   d="scan'208";a="113984845"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 25 Jul 2019 14:04:55 +0800
IronPort-SDR: sv4bt1i9NVGnVUnRPXJkpEOTbQQph7k29t5nGGUSvHHN7i8GWDuz61HxVrlS/ZB7yhnmtdS+Jk
 z3uICEe5CLp0fG+w/MLm8YapJl855fZb7Qr3LLWAQA/tnG4+6/FDCrnyDngdRquQUA4d71/n10
 bs2Mq4khrb8TbnwRiQmEbV1VNMTRzFG0zgrPed4GJfRuEHsJVWaP1ZylkI5jF3A+LTfw1bmrY6
 b4bCKRQcyw2mkYSUM8rXaUKnv4wVSoRYWFbKnQuW3AyrFbUwmHxYM3Vd6p7YOFWiVQElXN6Off
 FMhPi3oGuI6jfjAyAo3QRxeI
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP; 24 Jul 2019 23:03:05 -0700
IronPort-SDR: lnEnDIDR97i/mzZa1USxvN247FLI022TG/W7gYacK0TBVoQIpmehwh5pa4gNuK+ZsEvCfocDGE
 Ic82IeBL6paWG7xDEKTRT4mLurmtBhbk7sq0skKSeLfkyn3mulXnnqkeB6otn8ZDHEs12fGmvM
 CGGNrfGg2rh1pdIvmGpBcRfMOFRWDl12bxQrdc8RExulLGwHIT2UWSj1u6P1ymRvlJCBQ0yDgQ
 uPOcGbjiWT7oJL8F+gCTtO1XYYztDIO191eyZF+gYbYz/8Nn9HEVlX5E4USqFB9M+1uxxubUXi
 M6A=
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip02.wdc.com with ESMTP; 24 Jul 2019 23:04:54 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH] block: Limit zone array allocation size
Date:   Thu, 25 Jul 2019 15:04:52 +0900
Message-Id: <20190725060453.26910-1-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>

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
index ae7e91bd0618..c29929b0bc06 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -14,6 +14,9 @@
 #include <linux/rbtree.h>
 #include <linux/blkdev.h>
 #include <linux/blk-mq.h>
+#include <linux/mm.h>
+#include <linux/vmalloc.h>
+#include <linux/sched/mm.h>
 
 #include "blk.h"
 
@@ -373,22 +376,25 @@ static inline unsigned long *blk_alloc_zone_bitmap(int node,
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
@@ -415,6 +421,7 @@ int blk_revalidate_disk_zones(struct gendisk *disk)
 	unsigned long *seq_zones_wlock = NULL, *seq_zones_bitmap = NULL;
 	unsigned int i, rep_nr_zones = 0, z = 0, nrz;
 	struct blk_zone *zones = NULL;
+	unsigned int noio_flag;
 	sector_t sector = 0;
 	int ret = 0;
 
@@ -427,6 +434,12 @@ int blk_revalidate_disk_zones(struct gendisk *disk)
 		return 0;
 	}
 
+	/*
+	* Ensure that all memory allocations in this context are done as
+	* if GFP_NOIO was specified.
+	*/
+	noio_flag = memalloc_noio_save();
+
 	if (!blk_queue_is_zoned(q) || !nr_zones) {
 		nr_zones = 0;
 		goto update;
@@ -443,7 +456,7 @@ int blk_revalidate_disk_zones(struct gendisk *disk)
 
 	/* Get zone information and initialize seq_zones_bitmap */
 	rep_nr_zones = nr_zones;
-	zones = blk_alloc_zones(q->node, &rep_nr_zones);
+	zones = blk_alloc_zones(&rep_nr_zones);
 	if (!zones)
 		goto out;
 
@@ -480,8 +493,9 @@ int blk_revalidate_disk_zones(struct gendisk *disk)
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
index 592669bcc536..f7faac856017 100644
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

