Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BD62283A8E
	for <lists+stable@lfdr.de>; Mon,  5 Oct 2020 17:35:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728257AbgJEPeR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Oct 2020 11:34:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:34658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728192AbgJEPeI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Oct 2020 11:34:08 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2E546207BC;
        Mon,  5 Oct 2020 15:34:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601912047;
        bh=saTBI3Qlc+vcJykPkLmPkk6UwN9R2xA52nmsh4NpV8Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sEBS5dUIzo5X2dSP8AnalRwBTVjaZ1OyIV1bO6xV9J0ySZagyiPbASToILlVZxB/V
         p011ezMXsviLffui6//AK+EKuf86bkLxJ7iYunoCLKA6MBNb7xP4n8zxI/HIvymHUm
         wu1Ek3uh2FdsRzHS0qabHs032KLvkWexLRMQjitI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Borislav Petkov <bp@alien8.de>,
        Borislav Petkov <bp@suse.de>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Christoph Hellwig <hch@lst.de>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.8 81/85] scsi: sd: sd_zbc: Fix ZBC disk initialization
Date:   Mon,  5 Oct 2020 17:27:17 +0200
Message-Id: <20201005142118.629497606@linuxfoundation.org>
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

commit 6c5dee18756b4721ac8518c69b22ee8ac0c9c442 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/sd.c     |    4 --
 drivers/scsi/sd.h     |   12 ------
 drivers/scsi/sd_zbc.c |   94 +++++++++++++++++++++++++++-----------------------
 3 files changed, 52 insertions(+), 58 deletions(-)

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
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -213,7 +213,6 @@ static inline int sd_is_zoned(struct scs
 
 #ifdef CONFIG_BLK_DEV_ZONED
 
-int sd_zbc_init_disk(struct scsi_disk *sdkp);
 void sd_zbc_release_disk(struct scsi_disk *sdkp);
 extern int sd_zbc_read_zones(struct scsi_disk *sdkp, unsigned char *buffer);
 extern void sd_zbc_print_zones(struct scsi_disk *sdkp);
@@ -229,17 +228,6 @@ blk_status_t sd_zbc_prepare_zone_append(
 
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
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -633,6 +633,45 @@ static int sd_zbc_check_capacity(struct
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
@@ -650,6 +689,19 @@ static int sd_zbc_revalidate_zones(struc
 	int ret = 0;
 
 	/*
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
+	/*
 	 * There is nothing to do for regular disks, including host-aware disks
 	 * that have partitions.
 	 */
@@ -754,45 +806,3 @@ err:
 
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


