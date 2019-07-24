Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A4BB731A1
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 16:29:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387455AbfGXO25 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 10:28:57 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:37589 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727294AbfGXO24 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Jul 2019 10:28:56 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 39F1B21F85;
        Wed, 24 Jul 2019 10:28:53 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Wed, 24 Jul 2019 10:28:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=oYXwuK
        9k0rev+So7KAxyA4Lmx5nb1u2u5cA3e8KT1cI=; b=K+KHGyKYJYmHWtGy4FSKhr
        xekCgva/fANPLNEFSKMbcCwNWIK5UJoq4UdvvLCp+sJRXRH88cJGmhD9xyt0O6dv
        /aTV7eeRIAZlMFOiDRpIyvT19zwksp+472Mb7CPY0Kw8osTds17yCU3lHncGKaXX
        ctkuxOBdV+wE08DeUi54JeiC0pPii5p7iiKfpwszisjS6hYNKlsew0NoWGUqltz/
        PrtsMthtsUUFI9Co6/Qomp5d9KkwEtKQP/rkze5rZ9g73gfOfg77Z9O1uIdEHMVB
        uhfdNTvGiwCx7zXdNP29dkTXnQZ2sryZ9RfjejnNurVV+niwaqf9nWV4CAFKDm6w
        ==
X-ME-Sender: <xms:JGs4XefMt5xIOcaLFjb_R6A-_9Y_nvb77QCmxZtmIAexKYbW97zCdw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrkedtgdejudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:JGs4XYVZCVY_VFlX8SNl-vrkpQzqL9P0Hmg12COZMdOsscwXimOlvg>
    <xmx:JGs4XW-wOWzzl8Q8_MAYJvvJxbSGWrK1sA0HwJiPAy-EicOZ3MO95A>
    <xmx:JGs4XSh5Ln7tH3l2sJQWHFrVcLbSArn5ATqD2f9Bw5ooeJDwPVRXlg>
    <xmx:JWs4XWT6Jd6P3qbPwx_PRBoCtXkLjDN6B-rHPHCgG4igsCeDdYJ5nw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id CDAD08005B;
        Wed, 24 Jul 2019 10:28:51 -0400 (EDT)
Subject: FAILED: patch "[PATCH] sd_zbc: Fix report zones buffer allocation" failed to apply to 5.2-stable tree
To:     damien.lemoal@wdc.com, axboe@kernel.dk, hch@lst.de,
        martin.petersen@oracle.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 24 Jul 2019 16:24:11 +0200
Message-ID: <15639782515728@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.2-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From b091ac616846a1da75b1f2566b41255ce7f0e0a6 Mon Sep 17 00:00:00 2001
From: Damien Le Moal <damien.lemoal@wdc.com>
Date: Mon, 1 Jul 2019 14:09:17 +0900
Subject: [PATCH] sd_zbc: Fix report zones buffer allocation

During disk scan and revalidation done with sd_revalidate(), the zones
of a zoned disk are checked using the helper function
blk_revalidate_disk_zones() if a configuration change is detected
(change in the number of zones or zone size). The function
blk_revalidate_disk_zones() issues report_zones calls that are very
large, that is, to obtain zone information for all zones of the disk
with a single command. The size of the report zones command buffer
necessary for such large request generally is lower than the disk
max_hw_sectors and KMALLOC_MAX_SIZE (4MB) and succeeds on boot (no
memory fragmentation), but often fail at run time (e.g. hot-plug
event). This causes the disk revalidation to fail and the disk
capacity to be changed to 0.

This problem can be avoided by using vmalloc() instead of kmalloc() for
the buffer allocation. To limit the amount of memory to be allocated,
this patch also introduces the arbitrary SD_ZBC_REPORT_MAX_ZONES
maximum number of zones to report with a single report zones command.
This limit may be lowered further to satisfy the disk max_hw_sectors
limit. Finally, to ensure that the vmalloc-ed buffer can always be
mapped in a request, the buffer size is further limited to at most
queue_max_segments() pages, allowing successful mapping of the buffer
even in the worst case scenario where none of the buffer pages are
contiguous.

Fixes: 515ce6061312 ("scsi: sd_zbc: Fix sd_zbc_report_zones() buffer allocation")
Fixes: e76239a3748c ("block: add a report_zones method")
Cc: stable@vger.kernel.org
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index ec3764c8f3f1..db16c19e05c4 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -9,6 +9,8 @@
  */
 
 #include <linux/blkdev.h>
+#include <linux/vmalloc.h>
+#include <linux/sched/mm.h>
 
 #include <asm/unaligned.h>
 
@@ -50,7 +52,7 @@ static void sd_zbc_parse_report(struct scsi_disk *sdkp, u8 *buf,
 /**
  * sd_zbc_do_report_zones - Issue a REPORT ZONES scsi command.
  * @sdkp: The target disk
- * @buf: Buffer to use for the reply
+ * @buf: vmalloc-ed buffer to use for the reply
  * @buflen: the buffer size
  * @lba: Start LBA of the report
  * @partial: Do partial report
@@ -79,7 +81,6 @@ static int sd_zbc_do_report_zones(struct scsi_disk *sdkp, unsigned char *buf,
 	put_unaligned_be32(buflen, &cmd[10]);
 	if (partial)
 		cmd[14] = ZBC_REPORT_ZONE_PARTIAL;
-	memset(buf, 0, buflen);
 
 	result = scsi_execute_req(sdp, cmd, DMA_FROM_DEVICE,
 				  buf, buflen, &sshdr,
@@ -103,6 +104,53 @@ static int sd_zbc_do_report_zones(struct scsi_disk *sdkp, unsigned char *buf,
 	return 0;
 }
 
+/*
+ * Maximum number of zones to get with one report zones command.
+ */
+#define SD_ZBC_REPORT_MAX_ZONES		8192U
+
+/**
+ * Allocate a buffer for report zones reply.
+ * @sdkp: The target disk
+ * @nr_zones: Maximum number of zones to report
+ * @buflen: Size of the buffer allocated
+ *
+ * Try to allocate a reply buffer for the number of requested zones.
+ * The size of the buffer allocated may be smaller than requested to
+ * satify the device constraint (max_hw_sectors, max_segments, etc).
+ *
+ * Return the address of the allocated buffer and update @buflen with
+ * the size of the allocated buffer.
+ */
+static void *sd_zbc_alloc_report_buffer(struct scsi_disk *sdkp,
+					unsigned int nr_zones, size_t *buflen)
+{
+	struct request_queue *q = sdkp->disk->queue;
+	size_t bufsize;
+	void *buf;
+
+	/*
+	 * Report zone buffer size should be at most 64B times the number of
+	 * zones requested plus the 64B reply header, but should be at least
+	 * SECTOR_SIZE for ATA devices.
+	 * Make sure that this size does not exceed the hardware capabilities.
+	 * Furthermore, since the report zone command cannot be split, make
+	 * sure that the allocated buffer can always be mapped by limiting the
+	 * number of pages allocated to the HBA max segments limit.
+	 */
+	nr_zones = min(nr_zones, SD_ZBC_REPORT_MAX_ZONES);
+	bufsize = roundup((nr_zones + 1) * 64, 512);
+	bufsize = min_t(size_t, bufsize,
+			queue_max_hw_sectors(q) << SECTOR_SHIFT);
+	bufsize = min_t(size_t, bufsize, queue_max_segments(q) << PAGE_SHIFT);
+
+	buf = vzalloc(bufsize);
+	if (buf)
+		*buflen = bufsize;
+
+	return buf;
+}
+
 /**
  * sd_zbc_report_zones - Disk report zones operation.
  * @disk: The target disk
@@ -116,30 +164,23 @@ int sd_zbc_report_zones(struct gendisk *disk, sector_t sector,
 			struct blk_zone *zones, unsigned int *nr_zones)
 {
 	struct scsi_disk *sdkp = scsi_disk(disk);
-	unsigned int i, buflen, nrz = *nr_zones;
+	unsigned int i, nrz = *nr_zones;
 	unsigned char *buf;
-	size_t offset = 0;
+	size_t buflen = 0, offset = 0;
 	int ret = 0;
 
 	if (!sd_is_zoned(sdkp))
 		/* Not a zoned device */
 		return -EOPNOTSUPP;
 
-	/*
-	 * Get a reply buffer for the number of requested zones plus a header,
-	 * without exceeding the device maximum command size. For ATA disks,
-	 * buffers must be aligned to 512B.
-	 */
-	buflen = min(queue_max_hw_sectors(disk->queue) << 9,
-		     roundup((nrz + 1) * 64, 512));
-	buf = kmalloc(buflen, GFP_KERNEL);
+	buf = sd_zbc_alloc_report_buffer(sdkp, nrz, &buflen);
 	if (!buf)
 		return -ENOMEM;
 
 	ret = sd_zbc_do_report_zones(sdkp, buf, buflen,
 			sectors_to_logical(sdkp->device, sector), true);
 	if (ret)
-		goto out_free_buf;
+		goto out;
 
 	nrz = min(nrz, get_unaligned_be32(&buf[0]) / 64);
 	for (i = 0; i < nrz; i++) {
@@ -150,8 +191,8 @@ int sd_zbc_report_zones(struct gendisk *disk, sector_t sector,
 
 	*nr_zones = nrz;
 
-out_free_buf:
-	kfree(buf);
+out:
+	kvfree(buf);
 
 	return ret;
 }
@@ -285,8 +326,6 @@ static int sd_zbc_check_zoned_characteristics(struct scsi_disk *sdkp,
 	return 0;
 }
 
-#define SD_ZBC_BUF_SIZE 131072U
-
 /**
  * sd_zbc_check_zones - Check the device capacity and zone sizes
  * @sdkp: Target disk
@@ -302,22 +341,28 @@ static int sd_zbc_check_zoned_characteristics(struct scsi_disk *sdkp,
  */
 static int sd_zbc_check_zones(struct scsi_disk *sdkp, u32 *zblocks)
 {
+	size_t bufsize, buflen;
+	unsigned int noio_flag;
 	u64 zone_blocks = 0;
 	sector_t max_lba, block = 0;
 	unsigned char *buf;
 	unsigned char *rec;
-	unsigned int buf_len;
-	unsigned int list_length;
 	int ret;
 	u8 same;
 
+	/* Do all memory allocations as if GFP_NOIO was specified */
+	noio_flag = memalloc_noio_save();
+
 	/* Get a buffer */
-	buf = kmalloc(SD_ZBC_BUF_SIZE, GFP_KERNEL);
-	if (!buf)
-		return -ENOMEM;
+	buf = sd_zbc_alloc_report_buffer(sdkp, SD_ZBC_REPORT_MAX_ZONES,
+					 &bufsize);
+	if (!buf) {
+		ret = -ENOMEM;
+		goto out;
+	}
 
 	/* Do a report zone to get max_lba and the same field */
-	ret = sd_zbc_do_report_zones(sdkp, buf, SD_ZBC_BUF_SIZE, 0, false);
+	ret = sd_zbc_do_report_zones(sdkp, buf, bufsize, 0, false);
 	if (ret)
 		goto out_free;
 
@@ -353,12 +398,12 @@ static int sd_zbc_check_zones(struct scsi_disk *sdkp, u32 *zblocks)
 	do {
 
 		/* Parse REPORT ZONES header */
-		list_length = get_unaligned_be32(&buf[0]) + 64;
+		buflen = min_t(size_t, get_unaligned_be32(&buf[0]) + 64,
+			       bufsize);
 		rec = buf + 64;
-		buf_len = min(list_length, SD_ZBC_BUF_SIZE);
 
 		/* Parse zone descriptors */
-		while (rec < buf + buf_len) {
+		while (rec < buf + buflen) {
 			u64 this_zone_blocks = get_unaligned_be64(&rec[8]);
 
 			if (zone_blocks == 0) {
@@ -374,8 +419,8 @@ static int sd_zbc_check_zones(struct scsi_disk *sdkp, u32 *zblocks)
 		}
 
 		if (block < sdkp->capacity) {
-			ret = sd_zbc_do_report_zones(sdkp, buf, SD_ZBC_BUF_SIZE,
-						     block, true);
+			ret = sd_zbc_do_report_zones(sdkp, buf, bufsize, block,
+						     true);
 			if (ret)
 				goto out_free;
 		}
@@ -406,7 +451,8 @@ static int sd_zbc_check_zones(struct scsi_disk *sdkp, u32 *zblocks)
 	}
 
 out_free:
-	kfree(buf);
+	memalloc_noio_restore(noio_flag);
+	kvfree(buf);
 
 	return ret;
 }

