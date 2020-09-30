Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC28627E0E5
	for <lists+stable@lfdr.de>; Wed, 30 Sep 2020 08:13:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725440AbgI3GNc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Sep 2020 02:13:32 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:13905 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725320AbgI3GNc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Sep 2020 02:13:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1601446411; x=1632982411;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dGTH656forNBQVNgr1Cm5REGFp3EREOXaacgD60ohj0=;
  b=OwJ6WhaWFyti0im3KxQG1DYRe5H7Tp9siE+YQBiK0TFzQFvjKxu7km0s
   wTwYwWDIJNtlSYEPl1ZlPyErviwE5hzopblJcb0TvaPw6qMdoGKRkYnpa
   nfs2fbOY9vRmOKDMgHgnPwmnJwHaHYyYieNvb3dvY6MnbEyv/PLLNfYgF
   T8pK6KR/RQ6Lunt7VPnz2e+Pc+ivCVq5cLgPEPCMJa6xIuj2Kxpsr9/Kx
   69CRl4kfjGub2M4uATVnV5/zmrBq9F/1mODmQkSsAPWDga1PGb1gMotmV
   t3YWjcZtSs3A6KPSnZFBYaQ4rcUvqqFfRqDxfOtreiYpmXCAwpiNnOIPf
   A==;
IronPort-SDR: 4PVnmtB7evjxewt2f6y7JnIJ8m5a01QwdVWzsXhdYXBI6HaBy9lC8QcMEZBYplogyMFxLyCJe6
 U/kw+ursGxE1HeEhbb5IXh2wXfCDSurA8WgEX+wYFEkD2TLIn7qONm3kksEx5RuCJiVmlMsPll
 P6zRowmTjm79/Rbqvh4HR232FV83imdrZJZtnEoI0Mzb1KQryOd2+813s2HUq0tUMicL7Rn/D0
 0RKVPyfs5gF2XCVEOnAURxLFJ95HCgJlHT8PkHtIoowgnxn/U5Xy441dIsM+FlBh2LTxXUSndw
 Eec=
X-IronPort-AV: E=Sophos;i="5.77,321,1596470400"; 
   d="scan'208";a="258369098"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 30 Sep 2020 14:13:31 +0800
IronPort-SDR: dgjkGSJYoAzQubNgGLz4dYfkhB6KOm2mIAgQky1LhLUsp1LKcsYonsX+1MWpUkiLt8KFeq/e3G
 hVj3bcOFyp4A==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2020 22:59:30 -0700
IronPort-SDR: ox5ZyNVPXKBCJwi78KHtBTbYkAFl309b9AAygPvyr+st+/oG/rydP2IiOM9JKjrmgvWh/ajyDV
 hg7HuyD/2ONg==
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip02.wdc.com with ESMTP; 29 Sep 2020 23:13:31 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, bp@alien8.de,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH 1/2] scsi: sd: sd_zbc: Fix handling of host-aware ZBC disks
Date:   Wed, 30 Sep 2020 15:13:29 +0900
Message-Id: <20200930061329.562168-1-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <1601302609229102@kroah.com>
References: <1601302609229102@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Upstream commit 27ba3e8ff3ab86449e63d38a8d623053591e65fa

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
---
 block/blk-settings.c   | 46 ++++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/sd.c      | 30 ++++++++++++++++-----------
 drivers/scsi/sd.h      |  2 +-
 drivers/scsi/sd_zbc.c  | 37 +++++++++++++++++++--------------
 include/linux/blkdev.h |  2 ++
 5 files changed, 89 insertions(+), 28 deletions(-)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index 9a2c23cd9700..525bdb699deb 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -832,6 +832,52 @@ bool blk_queue_can_use_dma_map_merging(struct request_queue *q,
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
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index d90fefffe31b..0e1bd2e0475a 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2966,26 +2966,32 @@ static void sd_read_block_characteristics(struct scsi_disk *sdkp)
 
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
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index 3a74f4b45134..e23d8e4ff654 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -260,7 +260,7 @@ static inline blk_status_t sd_zbc_setup_zone_mgmt_cmnd(struct scsi_cmnd *cmd,
 static inline unsigned int sd_zbc_complete(struct scsi_cmnd *cmd,
 			unsigned int good_bytes, struct scsi_sense_hdr *sshdr)
 {
-	return 0;
+	return good_bytes;
 }
 
 static inline blk_status_t sd_zbc_prepare_zone_append(struct scsi_cmnd *cmd,
diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index 6f7eba66687e..9618eea2a638 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -645,8 +645,17 @@ static int sd_zbc_revalidate_zones(struct scsi_disk *sdkp,
 				   unsigned int nr_zones)
 {
 	struct gendisk *disk = sdkp->disk;
+	struct request_queue *q = disk->queue;
+	u32 max_append;
 	int ret = 0;
 
+	/*
+	 * There is nothing to do for regular disks, including host-aware disks
+	 * that have partitions.
+	 */
+	if (!blk_queue_is_zoned(q))
+		return 0;
+
 	/*
 	 * Make sure revalidate zones are serialized to ensure exclusive
 	 * updates of the scsi disk data.
@@ -681,6 +690,19 @@ static int sd_zbc_revalidate_zones(struct scsi_disk *sdkp,
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
 
@@ -693,7 +715,6 @@ int sd_zbc_read_zones(struct scsi_disk *sdkp, unsigned char *buf)
 	struct request_queue *q = disk->queue;
 	unsigned int nr_zones;
 	u32 zone_blocks = 0;
-	u32 max_append;
 	int ret;
 
 	if (!sd_is_zoned(sdkp))
@@ -726,20 +747,6 @@ int sd_zbc_read_zones(struct scsi_disk *sdkp, unsigned char *buf)
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
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 57241417ff2f..1af8c9ac50a4 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -354,6 +354,8 @@ struct queue_limits {
 typedef int (*report_zones_cb)(struct blk_zone *zone, unsigned int idx,
 			       void *data);
 
+void blk_queue_set_zoned(struct gendisk *disk, enum blk_zoned_model model);
+
 #ifdef CONFIG_BLK_DEV_ZONED
 
 #define BLK_ALL_ZONES  ((unsigned int)-1)
-- 
2.26.2

