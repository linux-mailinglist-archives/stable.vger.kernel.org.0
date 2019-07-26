Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A44876D2F
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 17:31:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389276AbfGZPb0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 11:31:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:46434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389270AbfGZPb0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jul 2019 11:31:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 60BEF2054F;
        Fri, 26 Jul 2019 15:31:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564155084;
        bh=Mpb07gJ0E4cKNq5ji2XmcZwCGnNUl+EoyaYztgnW9Jc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vxIr+5xDsO99x7ofevPeSo2RqryO8aE53nLF4hP5b2YZxrsnaBK9WVNnu+1h8gL/3
         9BLS+0tcks29Sz3bIu6CEWuFHcc9KCeHe1TzAxi9rNuvb/sMlVEwlVzP4zdye8mTaA
         wyU4ei+JOrwo4odMGXfdlEkw9lc3/BK5SR/W9hgg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.1 60/62] sd_zbc: Fix report zones buffer allocation
Date:   Fri, 26 Jul 2019 17:25:12 +0200
Message-Id: <20190726152308.220867204@linuxfoundation.org>
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

commit b091ac616846a1da75b1f2566b41255ce7f0e0a6 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 drivers/scsi/sd_zbc.c |  104 ++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 75 insertions(+), 29 deletions(-)

--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -23,6 +23,8 @@
  */
 
 #include <linux/blkdev.h>
+#include <linux/vmalloc.h>
+#include <linux/sched/mm.h>
 
 #include <asm/unaligned.h>
 
@@ -64,7 +66,7 @@ static void sd_zbc_parse_report(struct s
 /**
  * sd_zbc_do_report_zones - Issue a REPORT ZONES scsi command.
  * @sdkp: The target disk
- * @buf: Buffer to use for the reply
+ * @buf: vmalloc-ed buffer to use for the reply
  * @buflen: the buffer size
  * @lba: Start LBA of the report
  * @partial: Do partial report
@@ -93,7 +95,6 @@ static int sd_zbc_do_report_zones(struct
 	put_unaligned_be32(buflen, &cmd[10]);
 	if (partial)
 		cmd[14] = ZBC_REPORT_ZONE_PARTIAL;
-	memset(buf, 0, buflen);
 
 	result = scsi_execute_req(sdp, cmd, DMA_FROM_DEVICE,
 				  buf, buflen, &sshdr,
@@ -117,6 +118,53 @@ static int sd_zbc_do_report_zones(struct
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
@@ -132,30 +180,23 @@ int sd_zbc_report_zones(struct gendisk *
 			gfp_t gfp_mask)
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
-	buf = kmalloc(buflen, gfp_mask);
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
@@ -166,8 +207,8 @@ int sd_zbc_report_zones(struct gendisk *
 
 	*nr_zones = nrz;
 
-out_free_buf:
-	kfree(buf);
+out:
+	kvfree(buf);
 
 	return ret;
 }
@@ -301,8 +342,6 @@ static int sd_zbc_check_zoned_characteri
 	return 0;
 }
 
-#define SD_ZBC_BUF_SIZE 131072U
-
 /**
  * sd_zbc_check_zones - Check the device capacity and zone sizes
  * @sdkp: Target disk
@@ -318,22 +357,28 @@ static int sd_zbc_check_zoned_characteri
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
 
@@ -369,12 +414,12 @@ static int sd_zbc_check_zones(struct scs
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
@@ -390,8 +435,8 @@ static int sd_zbc_check_zones(struct scs
 		}
 
 		if (block < sdkp->capacity) {
-			ret = sd_zbc_do_report_zones(sdkp, buf, SD_ZBC_BUF_SIZE,
-						     block, true);
+			ret = sd_zbc_do_report_zones(sdkp, buf, bufsize, block,
+						     true);
 			if (ret)
 				goto out_free;
 		}
@@ -422,7 +467,8 @@ out:
 	}
 
 out_free:
-	kfree(buf);
+	memalloc_noio_restore(noio_flag);
+	kvfree(buf);
 
 	return ret;
 }


