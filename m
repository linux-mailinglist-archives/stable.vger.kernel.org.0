Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14005283A82
	for <lists+stable@lfdr.de>; Mon,  5 Oct 2020 17:35:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727774AbgJEPfF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Oct 2020 11:35:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:35368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728320AbgJEPei (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Oct 2020 11:34:38 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7ED78206DD;
        Mon,  5 Oct 2020 15:34:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601912077;
        bh=8lsASifu66HGaUjnRD8xbUIuyCJ5DZRLZ91yWpdaEtU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f6TRvEOpOUdKjSrK3LlwmC+a89vuvl5a3TtvSMvYzRqRbkOIE0WUYOAocK316NKra
         YKAlZM6joeW+KYvJkpTy5xnKmrBahXt59gtixzkcMqHNqniJRFi03wIGqdMkiRmxG3
         vtDCFnH0VbRom5q1oJYOMLAyWHXF44+LxEMqpaZw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Borislav Petkov <bp@alien8.de>,
        Christoph Hellwig <hch@infradead.org>,
        Christoph Hellwig <hch@lst.de>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.8 80/85] scsi: sd: sd_zbc: Fix handling of host-aware ZBC disks
Date:   Mon,  5 Oct 2020 17:27:16 +0200
Message-Id: <20201005142118.582328343@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201005142114.732094228@linuxfoundation.org>
References: <20201005142114.732094228@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Damien Le Moal <damien.lemoal@wdc.com>

commit 27ba3e8ff3ab86449e63d38a8d623053591e65fa upstream.

When CONFIG_BLK_DEV_ZONED is disabled, allow using host-aware ZBC disks as
regular disks. In this case, ensure that command completion is correctly
executed by changing sd_zbc_complete() to return good_bytes instead of 0
and causing a hang during device probe (endless retries).

When CONFIG_BLK_DEV_ZONED is enabled and a host-aware disk is detected to
have partitions, it will be used as a regular disk. In this case, make sure
to not do anything in sd_zbc_revalidate_zones() as that triggers warnings.

Since all these different cases result in subtle settings of the disk queue
zoned model, introduce the block layer helper function
blk_queue_set_zoned() to generically implement setting up the effective
zoned model according to the disk type, the presence of partitions on the
disk and CONFIG_BLK_DEV_ZONED configuration.

Link: https://lore.kernel.org/r/20200915073347.832424-2-damien.lemoal@wdc.com
Fixes: b72053072c0b ("block: allow partitions on host aware zone devices")
Cc: <stable@vger.kernel.org>
Reported-by: Borislav Petkov <bp@alien8.de>
Suggested-by: Christoph Hellwig <hch@infradead.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/blk-settings.c   |   46 ++++++++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/sd.c      |   30 ++++++++++++++++++------------
 drivers/scsi/sd.h      |    2 +-
 drivers/scsi/sd_zbc.c  |   37 ++++++++++++++++++++++---------------
 include/linux/blkdev.h |    2 ++
 5 files changed, 89 insertions(+), 28 deletions(-)

--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -832,6 +832,52 @@ bool blk_queue_can_use_dma_map_merging(s
 }
 EXPORT_SYMBOL_GPL(blk_queue_can_use_dma_map_merging);
 
+/**
+ * blk_queue_set_zoned - configure a disk queue zoned model.
+ * @disk:	the gendisk of the queue to configure
+ * @model:	the zoned model to set
+ *
+ * Set the zoned model of the request queue of @disk according to @model.
+ * When @model is BLK_ZONED_HM (host managed), this should be called only
+ * if zoned block device support is enabled (CONFIG_BLK_DEV_ZONED option).
+ * If @model specifies BLK_ZONED_HA (host aware), the effective model used
+ * depends on CONFIG_BLK_DEV_ZONED settings and on the existence of partitions
+ * on the disk.
+ */
+void blk_queue_set_zoned(struct gendisk *disk, enum blk_zoned_model model)
+{
+	switch (model) {
+	case BLK_ZONED_HM:
+		/*
+		 * Host managed devices are supported only if
+		 * CONFIG_BLK_DEV_ZONED is enabled.
+		 */
+		WARN_ON_ONCE(!IS_ENABLED(CONFIG_BLK_DEV_ZONED));
+		break;
+	case BLK_ZONED_HA:
+		/*
+		 * Host aware devices can be treated either as regular block
+		 * devices (similar to drive managed devices) or as zoned block
+		 * devices to take advantage of the zone command set, similarly
+		 * to host managed devices. We try the latter if there are no
+		 * partitions and zoned block device support is enabled, else
+		 * we do nothing special as far as the block layer is concerned.
+		 */
+		if (!IS_ENABLED(CONFIG_BLK_DEV_ZONED) ||
+		    disk_has_partitions(disk))
+			model = BLK_ZONED_NONE;
+		break;
+	case BLK_ZONED_NONE:
+	default:
+		if (WARN_ON_ONCE(model != BLK_ZONED_NONE))
+			model = BLK_ZONED_NONE;
+		break;
+	}
+
+	disk->queue->limits.zoned = model;
+}
+EXPORT_SYMBOL_GPL(blk_queue_set_zoned);
+
 static int __init blk_settings_init(void)
 {
 	blk_max_low_pfn = max_low_pfn - 1;
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2966,26 +2966,32 @@ static void sd_read_block_characteristic
 
 	if (sdkp->device->type == TYPE_ZBC) {
 		/* Host-managed */
-		q->limits.zoned = BLK_ZONED_HM;
+		blk_queue_set_zoned(sdkp->disk, BLK_ZONED_HM);
 	} else {
 		sdkp->zoned = (buffer[8] >> 4) & 3;
-		if (sdkp->zoned == 1 && !disk_has_partitions(sdkp->disk)) {
+		if (sdkp->zoned == 1) {
 			/* Host-aware */
-			q->limits.zoned = BLK_ZONED_HA;
+			blk_queue_set_zoned(sdkp->disk, BLK_ZONED_HA);
 		} else {
-			/*
-			 * Treat drive-managed devices and host-aware devices
-			 * with partitions as regular block devices.
-			 */
-			q->limits.zoned = BLK_ZONED_NONE;
-			if (sdkp->zoned == 2 && sdkp->first_scan)
-				sd_printk(KERN_NOTICE, sdkp,
-					  "Drive-managed SMR disk\n");
+			/* Regular disk or drive managed disk */
+			blk_queue_set_zoned(sdkp->disk, BLK_ZONED_NONE);
 		}
 	}
-	if (blk_queue_is_zoned(q) && sdkp->first_scan)
+
+	if (!sdkp->first_scan)
+		goto out;
+
+	if (blk_queue_is_zoned(q)) {
 		sd_printk(KERN_NOTICE, sdkp, "Host-%s zoned block device\n",
 		      q->limits.zoned == BLK_ZONED_HM ? "managed" : "aware");
+	} else {
+		if (sdkp->zoned == 1)
+			sd_printk(KERN_NOTICE, sdkp,
+				  "Host-aware SMR disk used as regular disk\n");
+		else if (sdkp->zoned == 2)
+			sd_printk(KERN_NOTICE, sdkp,
+				  "Drive-managed SMR disk\n");
+	}
 
  out:
 	kfree(buffer);
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -260,7 +260,7 @@ static inline blk_status_t sd_zbc_setup_
 static inline unsigned int sd_zbc_complete(struct scsi_cmnd *cmd,
 			unsigned int good_bytes, struct scsi_sense_hdr *sshdr)
 {
-	return 0;
+	return good_bytes;
 }
 
 static inline blk_status_t sd_zbc_prepare_zone_append(struct scsi_cmnd *cmd,
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -645,9 +645,18 @@ static int sd_zbc_revalidate_zones(struc
 				   unsigned int nr_zones)
 {
 	struct gendisk *disk = sdkp->disk;
+	struct request_queue *q = disk->queue;
+	u32 max_append;
 	int ret = 0;
 
 	/*
+	 * There is nothing to do for regular disks, including host-aware disks
+	 * that have partitions.
+	 */
+	if (!blk_queue_is_zoned(q))
+		return 0;
+
+	/*
 	 * Make sure revalidate zones are serialized to ensure exclusive
 	 * updates of the scsi disk data.
 	 */
@@ -681,6 +690,19 @@ static int sd_zbc_revalidate_zones(struc
 	kvfree(sdkp->rev_wp_offset);
 	sdkp->rev_wp_offset = NULL;
 
+	if (ret) {
+		sdkp->zone_blocks = 0;
+		sdkp->nr_zones = 0;
+		sdkp->capacity = 0;
+		goto unlock;
+	}
+
+	max_append = min_t(u32, logical_to_sectors(sdkp->device, zone_blocks),
+			   q->limits.max_segments << (PAGE_SHIFT - 9));
+	max_append = min_t(u32, max_append, queue_max_hw_sectors(q));
+
+	blk_queue_max_zone_append_sectors(q, max_append);
+
 unlock:
 	mutex_unlock(&sdkp->rev_mutex);
 
@@ -693,7 +715,6 @@ int sd_zbc_read_zones(struct scsi_disk *
 	struct request_queue *q = disk->queue;
 	unsigned int nr_zones;
 	u32 zone_blocks = 0;
-	u32 max_append;
 	int ret;
 
 	if (!sd_is_zoned(sdkp))
@@ -726,20 +747,6 @@ int sd_zbc_read_zones(struct scsi_disk *
 	if (ret)
 		goto err;
 
-	/*
-	 * On the first scan 'chunk_sectors' isn't setup yet, so calling
-	 * blk_queue_max_zone_append_sectors() will result in a WARN(). Defer
-	 * this setting to the second scan.
-	 */
-	if (sdkp->first_scan)
-		return 0;
-
-	max_append = min_t(u32, logical_to_sectors(sdkp->device, zone_blocks),
-			   q->limits.max_segments << (PAGE_SHIFT - 9));
-	max_append = min_t(u32, max_append, queue_max_hw_sectors(q));
-
-	blk_queue_max_zone_append_sectors(q, max_append);
-
 	return 0;
 
 err:
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -354,6 +354,8 @@ struct queue_limits {
 typedef int (*report_zones_cb)(struct blk_zone *zone, unsigned int idx,
 			       void *data);
 
+void blk_queue_set_zoned(struct gendisk *disk, enum blk_zoned_model model);
+
 #ifdef CONFIG_BLK_DEV_ZONED
 
 #define BLK_ALL_ZONES  ((unsigned int)-1)


