Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93E4F27E0E6
	for <lists+stable@lfdr.de>; Wed, 30 Sep 2020 08:15:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725771AbgI3GPH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Sep 2020 02:15:07 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:1635 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725535AbgI3GPG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Sep 2020 02:15:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1601446506; x=1632982506;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=buTiEkHOqSyRutgW2DZqlLpDhbWPxoKZ+lrvxtwqT6I=;
  b=g5qrRFd7TfM+vexdCnqPlrzHeCeNpocWW+v3bBW6De24OZ4B0dGHpF+B
   11BwqTR9C/ZkAK2tYxyaBAsNlT8jr9eFatB+ILD/DIG5zi2krjUgueADM
   VIu7KN5jdOU8Fraty+os8eXoN4Do7E6bsnRfFLl3QYz89sFlAnaRA4b4v
   yWToGdSf1wwSLSnicUZE6se2HJukJw1M7siAcfk5CbUC/abvzyXQlffpc
   w1ywh5fx4NQgDGJcNfeAE6y1RZO4DTrBJOYiXa5NB1zxDldC2aeffCloO
   WtpHSL+s3UJ7uRShdg45nYJtKosptWNm+PSWdknbhpkYyN2dhVvwGLEiD
   g==;
IronPort-SDR: yUdw1k9RMfz9Gq9L1do291g8ha8yntQgYgi83c9omlhmLMWMkjVYG8YJPIkUpAhg6u2bgAVc26
 Zbjj24WT6zb4YQC1mmW3DTn+YEN4G/sw9nsSjlyY4iG01Qz4YqLBquj9nnSHNpBA0Jn4NbTQd1
 W8vV4RV84vkpzYYf2TTsI9EluNs/S7cq/DH7s/2Aiw3Z1+xM/FtK3F5JHbPaDOYPsacZw85fJ0
 y3hlOqFNWvJ7uMIwscHAjsdFRubhQU/Va6Ex+dVWY2tk8Pg1RiV91xpd2v0fOH71WuZay8i9UA
 F3M=
X-IronPort-AV: E=Sophos;i="5.77,321,1596470400"; 
   d="scan'208";a="148545976"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 30 Sep 2020 14:15:06 +0800
IronPort-SDR: yYhwMsRVY1GcMvUYwluYp8cdueKYGwqACYnWnHQh3uSQ2nvA2XX3LlxiFh6T9etj1RzQzwxeG7
 ExARuEbUtVDw==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2020 23:01:04 -0700
IronPort-SDR: KqVjV2gSjTqzM4mADR+3NJFJsHhxqMbCPa2vca98rbAKezyYMxKTMWgIJKeIHeap2r8OvOXKO+
 RS+rEnYiufJw==
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip02.wdc.com with ESMTP; 29 Sep 2020 23:15:06 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, bp@alien8.de,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH 2/2] scsi: sd: sd_zbc: Fix ZBC disk initialization
Date:   Wed, 30 Sep 2020 15:15:04 +0900
Message-Id: <20200930061504.562239-1-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <16013026203615@kroah.com>
References: <16013026203615@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Upstream commit 6c5dee18756b4721ac8518c69b22ee8ac0c9c442

Make sure to call sd_zbc_init_disk() when the sdkp->zoned field is known,
that is, once sd_read_block_characteristics() is executed in
sd_revalidate_disk(), so that host-aware disks also get initialized.  To do
so, move sd_zbc_init_disk() call in sd_zbc_revalidate_zones() and make sure
to execute it for all zoned disks, including for host-aware disks used as
regular disks as these disk zoned model may be changed back to BLK_ZONED_HA
when partitions are deleted.

Link: https://lore.kernel.org/r/20200915073347.832424-3-damien.lemoal@wdc.com
Fixes: 5795eb443060 ("scsi: sd_zbc: emulate ZONE_APPEND commands")
Cc: <stable@vger.kernel.org> # v5.8+
Reported-by: Borislav Petkov <bp@alien8.de>
Tested-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/scsi/sd.c     |  4 --
 drivers/scsi/sd.h     | 12 ------
 drivers/scsi/sd_zbc.c | 94 ++++++++++++++++++++++++-------------------
 3 files changed, 52 insertions(+), 58 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 0e1bd2e0475a..4b2117cb8483 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3404,10 +3404,6 @@ static int sd_probe(struct device *dev)
 	sdkp->first_scan = 1;
 	sdkp->max_medium_access_timeouts = SD_MAX_MEDIUM_TIMEOUTS;
 
-	error = sd_zbc_init_disk(sdkp);
-	if (error)
-		goto out_free_index;
-
 	sd_revalidate_disk(gd);
 
 	gd->flags = GENHD_FL_EXT_DEVT;
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index e23d8e4ff654..9c24de305c6b 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -213,7 +213,6 @@ static inline int sd_is_zoned(struct scsi_disk *sdkp)
 
 #ifdef CONFIG_BLK_DEV_ZONED
 
-int sd_zbc_init_disk(struct scsi_disk *sdkp);
 void sd_zbc_release_disk(struct scsi_disk *sdkp);
 extern int sd_zbc_read_zones(struct scsi_disk *sdkp, unsigned char *buffer);
 extern void sd_zbc_print_zones(struct scsi_disk *sdkp);
@@ -229,17 +228,6 @@ blk_status_t sd_zbc_prepare_zone_append(struct scsi_cmnd *cmd, sector_t *lba,
 
 #else /* CONFIG_BLK_DEV_ZONED */
 
-static inline int sd_zbc_init(void)
-{
-	return 0;
-}
-
-static inline int sd_zbc_init_disk(struct scsi_disk *sdkp)
-{
-	return 0;
-}
-
-static inline void sd_zbc_exit(void) {}
 static inline void sd_zbc_release_disk(struct scsi_disk *sdkp) {}
 
 static inline int sd_zbc_read_zones(struct scsi_disk *sdkp,
diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index 9618eea2a638..8384b5dcfa02 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -633,6 +633,45 @@ static int sd_zbc_check_capacity(struct scsi_disk *sdkp, unsigned char *buf,
 	return 0;
 }
 
+void sd_zbc_print_zones(struct scsi_disk *sdkp)
+{
+	if (!sd_is_zoned(sdkp) || !sdkp->capacity)
+		return;
+
+	if (sdkp->capacity & (sdkp->zone_blocks - 1))
+		sd_printk(KERN_NOTICE, sdkp,
+			  "%u zones of %u logical blocks + 1 runt zone\n",
+			  sdkp->nr_zones - 1,
+			  sdkp->zone_blocks);
+	else
+		sd_printk(KERN_NOTICE, sdkp,
+			  "%u zones of %u logical blocks\n",
+			  sdkp->nr_zones,
+			  sdkp->zone_blocks);
+}
+
+static int sd_zbc_init_disk(struct scsi_disk *sdkp)
+{
+	sdkp->zones_wp_offset = NULL;
+	spin_lock_init(&sdkp->zones_wp_offset_lock);
+	sdkp->rev_wp_offset = NULL;
+	mutex_init(&sdkp->rev_mutex);
+	INIT_WORK(&sdkp->zone_wp_offset_work, sd_zbc_update_wp_offset_workfn);
+	sdkp->zone_wp_update_buf = kzalloc(SD_BUF_SIZE, GFP_KERNEL);
+	if (!sdkp->zone_wp_update_buf)
+		return -ENOMEM;
+
+	return 0;
+}
+
+void sd_zbc_release_disk(struct scsi_disk *sdkp)
+{
+	kvfree(sdkp->zones_wp_offset);
+	sdkp->zones_wp_offset = NULL;
+	kfree(sdkp->zone_wp_update_buf);
+	sdkp->zone_wp_update_buf = NULL;
+}
+
 static void sd_zbc_revalidate_zones_cb(struct gendisk *disk)
 {
 	struct scsi_disk *sdkp = scsi_disk(disk);
@@ -649,6 +688,19 @@ static int sd_zbc_revalidate_zones(struct scsi_disk *sdkp,
 	u32 max_append;
 	int ret = 0;
 
+	/*
+	 * For all zoned disks, initialize zone append emulation data if not
+	 * already done. This is necessary also for host-aware disks used as
+	 * regular disks due to the presence of partitions as these partitions
+	 * may be deleted and the disk zoned model changed back from
+	 * BLK_ZONED_NONE to BLK_ZONED_HA.
+	 */
+	if (sd_is_zoned(sdkp) && !sdkp->zone_wp_update_buf) {
+		ret = sd_zbc_init_disk(sdkp);
+		if (ret)
+			return ret;
+	}
+
 	/*
 	 * There is nothing to do for regular disks, including host-aware disks
 	 * that have partitions.
@@ -754,45 +806,3 @@ int sd_zbc_read_zones(struct scsi_disk *sdkp, unsigned char *buf)
 
 	return ret;
 }
-
-void sd_zbc_print_zones(struct scsi_disk *sdkp)
-{
-	if (!sd_is_zoned(sdkp) || !sdkp->capacity)
-		return;
-
-	if (sdkp->capacity & (sdkp->zone_blocks - 1))
-		sd_printk(KERN_NOTICE, sdkp,
-			  "%u zones of %u logical blocks + 1 runt zone\n",
-			  sdkp->nr_zones - 1,
-			  sdkp->zone_blocks);
-	else
-		sd_printk(KERN_NOTICE, sdkp,
-			  "%u zones of %u logical blocks\n",
-			  sdkp->nr_zones,
-			  sdkp->zone_blocks);
-}
-
-int sd_zbc_init_disk(struct scsi_disk *sdkp)
-{
-	if (!sd_is_zoned(sdkp))
-		return 0;
-
-	sdkp->zones_wp_offset = NULL;
-	spin_lock_init(&sdkp->zones_wp_offset_lock);
-	sdkp->rev_wp_offset = NULL;
-	mutex_init(&sdkp->rev_mutex);
-	INIT_WORK(&sdkp->zone_wp_offset_work, sd_zbc_update_wp_offset_workfn);
-	sdkp->zone_wp_update_buf = kzalloc(SD_BUF_SIZE, GFP_KERNEL);
-	if (!sdkp->zone_wp_update_buf)
-		return -ENOMEM;
-
-	return 0;
-}
-
-void sd_zbc_release_disk(struct scsi_disk *sdkp)
-{
-	kvfree(sdkp->zones_wp_offset);
-	sdkp->zones_wp_offset = NULL;
-	kfree(sdkp->zone_wp_update_buf);
-	sdkp->zone_wp_update_buf = NULL;
-}
-- 
2.26.2

