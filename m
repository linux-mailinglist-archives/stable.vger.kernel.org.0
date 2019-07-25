Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2296A747E5
	for <lists+stable@lfdr.de>; Thu, 25 Jul 2019 09:12:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387783AbfGYHMT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jul 2019 03:12:19 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:18635 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387765AbfGYHMT (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Jul 2019 03:12:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1564038738; x=1595574738;
  h=from:to:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=4jIwuKKR2jSeu4JKRuSFF1fQr93cS2/2zNbcYcjaFTc=;
  b=kkqfMVgioBba0KctNYjRjvuiAkZzd04B4AxQWuC6cgvyolQ62/OA81I/
   5Ts7d/ZJup0CreggUoWBiEr3WPfzdNQ1a+r+8S16opBIAmlv52MdCkjDb
   xMmpfQGH69e7OXwC+Acq642m3S3SVtgho7WMsqloNccnpVNfKj9tEQnWt
   FrlO8Uvdh3r6GboylJilO4oCNkZyjvSQMoffhibnPp+5ywUK+jcPghF/6
   npGckrhd+NeCrxmTRnJ/1LGcK3Q2KQAN25GCdhW7VrOBdCh0k+Y24t2Fd
   m76KamZ6h0nP2fRqelFZ83S16khh5TP2kHX0Z4gMbHen9rse9EBKFu4uk
   A==;
IronPort-SDR: Uj34DQn8eqZJVYZtNwkj3nSP2CyddfMaZ58WbHYB+BMImPcebxP/IGO9eRTjsmfk9Ap0n7p1tp
 avzPsanTLFFlM686gYiODP4mdlBY1TYhkRg+YXq9KztAhmLelcl0e8QFqfHg1ILxM+jJ61R6gF
 qp+O3m2GxZWs12yPq+p2NHR17gaL/VHoUzGgxsyM3Tx5sX2D0PsXu57eKlhiMcp79Edwewnmsz
 2inHOOAI5CnuhIaIq5op+GWR5IJkjbCcx5PUxTN3X7OKjikCJSNaVtG2GUuknlzDoXb07tFqV5
 lXk=
X-IronPort-AV: E=Sophos;i="5.64,305,1559491200"; 
   d="scan'208";a="220433744"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 25 Jul 2019 15:12:18 +0800
IronPort-SDR: NiPHgCN0UHHrYVilUAdUjGpHMFA1wE96USB0OpIhS6m1emYfUGx8brCI8+D0owg0WJ+Z5Ly5eV
 QDjp/wgtpnkYI4CYPymwwUb5P1uP1hEsGYjMoG8faXUlSR3G2E6ihKP4pCs1JXAqduEUIQyNjh
 9Msmo4sbZM3MSnb8oLGoB2LgTE7uXtTTiIshg4MH4sLjf6o/D+I/d2i3I9yzvVW+uVSLhALCQ8
 pIBFltwouudfYZKnBqBPFdDk8ZsIzvd3RwiqTxKQYEcr+mszFuCrZuR6NhTkOL7NRo2Yiwklsa
 NKMRSodqDXs6IleUVyLOBnpA
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP; 25 Jul 2019 00:10:29 -0700
IronPort-SDR: SCDaAPwjtCm073s03BstORI3FFDwfJgWp9cnzFWrRxBjtIMAvf4MEbTwXylQi4gWJRiU6dH5I4
 6VW706xmtoSi2sEL9Hrj0tATgocvhu3dZSVqkX00R2IzyM7vOsiI0VgFo4WczrHyRQIa3O2HzO
 y5xh8NKHcTEdcqAS+YttxOMFt/ShKs7F8at3r2vH0WhYl9xVGEiMWG4jHPX30Q2RgdxXQ5Y+Lp
 U91V73aP/JZKsxDH7/CvJA7v7lDvWimlFkusKQaSzu/lDe7eptt/qNI4CQG8KfWKdbQUED6c03
 wVc=
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip01.wdc.com with ESMTP; 25 Jul 2019 00:12:17 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH] sd_zbc: Fix report zones buffer allocation
Date:   Thu, 25 Jul 2019 16:12:16 +0900
Message-Id: <20190725071217.15551-1-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Cc: stable@vger.kernel.org # 5.1.x
Cc: stable@vger.kernel.org # 5.2.x
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 drivers/scsi/sd_zbc.c | 104 ++++++++++++++++++++++++++++++------------
 1 file changed, 75 insertions(+), 29 deletions(-)

diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index a340af797a85..a9f3a8d77ee7 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -23,6 +23,8 @@
  */
 
 #include <linux/blkdev.h>
+#include <linux/vmalloc.h>
+#include <linux/sched/mm.h>
 
 #include <asm/unaligned.h>
 
@@ -64,7 +66,7 @@ static void sd_zbc_parse_report(struct scsi_disk *sdkp, u8 *buf,
 /**
  * sd_zbc_do_report_zones - Issue a REPORT ZONES scsi command.
  * @sdkp: The target disk
- * @buf: Buffer to use for the reply
+ * @buf: vmalloc-ed buffer to use for the reply
  * @buflen: the buffer size
  * @lba: Start LBA of the report
  * @partial: Do partial report
@@ -93,7 +95,6 @@ static int sd_zbc_do_report_zones(struct scsi_disk *sdkp, unsigned char *buf,
 	put_unaligned_be32(buflen, &cmd[10]);
 	if (partial)
 		cmd[14] = ZBC_REPORT_ZONE_PARTIAL;
-	memset(buf, 0, buflen);
 
 	result = scsi_execute_req(sdp, cmd, DMA_FROM_DEVICE,
 				  buf, buflen, &sshdr,
@@ -117,6 +118,53 @@ static int sd_zbc_do_report_zones(struct scsi_disk *sdkp, unsigned char *buf,
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
@@ -132,30 +180,23 @@ int sd_zbc_report_zones(struct gendisk *disk, sector_t sector,
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
@@ -166,8 +207,8 @@ int sd_zbc_report_zones(struct gendisk *disk, sector_t sector,
 
 	*nr_zones = nrz;
 
-out_free_buf:
-	kfree(buf);
+out:
+	kvfree(buf);
 
 	return ret;
 }
@@ -301,8 +342,6 @@ static int sd_zbc_check_zoned_characteristics(struct scsi_disk *sdkp,
 	return 0;
 }
 
-#define SD_ZBC_BUF_SIZE 131072U
-
 /**
  * sd_zbc_check_zones - Check the device capacity and zone sizes
  * @sdkp: Target disk
@@ -318,22 +357,28 @@ static int sd_zbc_check_zoned_characteristics(struct scsi_disk *sdkp,
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
 
@@ -369,12 +414,12 @@ static int sd_zbc_check_zones(struct scsi_disk *sdkp, u32 *zblocks)
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
@@ -390,8 +435,8 @@ static int sd_zbc_check_zones(struct scsi_disk *sdkp, u32 *zblocks)
 		}
 
 		if (block < sdkp->capacity) {
-			ret = sd_zbc_do_report_zones(sdkp, buf, SD_ZBC_BUF_SIZE,
-						     block, true);
+			ret = sd_zbc_do_report_zones(sdkp, buf, bufsize, block,
+						     true);
 			if (ret)
 				goto out_free;
 		}
@@ -422,7 +467,8 @@ static int sd_zbc_check_zones(struct scsi_disk *sdkp, u32 *zblocks)
 	}
 
 out_free:
-	kfree(buf);
+	memalloc_noio_restore(noio_flag);
+	kvfree(buf);
 
 	return ret;
 }
-- 
2.21.0

