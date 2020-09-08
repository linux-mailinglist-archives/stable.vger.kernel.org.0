Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B3C6261779
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 19:35:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731389AbgIHRfR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 13:35:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:56674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731697AbgIHQOj (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 12:14:39 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 03DC42490E;
        Tue,  8 Sep 2020 15:53:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599580426;
        bh=6ifxDlQ6ev8LOmJvA9bVehEdRq7EoNP5KFk2lyqzWi8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lfwGTEjsvhtpYPEInJHaRlSwThs6PZBSNSa8bHDAHyYUakx4/dahMCuk1RsmuTRqx
         TY+imx/4SYygOWLQ7tTtLbtQ0feR/b5cetL7ocdPjlFOh7NCK6iZkNeazKI2TsK7UT
         cKLaHY1mfnZ6Q6a3PnIv0FOQa+urWnG/D/F0kM40=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Mike Snitzer <snitzer@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Minchan Kim <minchan@kernel.org>,
        Nitin Gupta <ngupta@vflare.org>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Christoph Hellwig <hch@lst.de>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Bart Van Assche <bart.vanassche@wdc.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4.14 53/65] block: Move SECTOR_SIZE and SECTOR_SHIFT definitions into <linux/blkdev.h>
Date:   Tue,  8 Sep 2020 17:26:38 +0200
Message-Id: <20200908152219.820909997@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152217.022816723@linuxfoundation.org>
References: <20200908152217.022816723@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bart Van Assche <bart.vanassche@wdc.com>

commit 233bde21aa43516baa013ef7ac33f3427056db3e upstream.

It happens often while I'm preparing a patch for a block driver that
I'm wondering: is a definition of SECTOR_SIZE and/or SECTOR_SHIFT
available for this driver? Do I have to introduce definitions of these
constants before I can use these constants? To avoid this confusion,
move the existing definitions of SECTOR_SIZE and SECTOR_SHIFT into the
<linux/blkdev.h> header file such that these become available for all
block drivers. Make the SECTOR_SIZE definition in the uapi msdos_fs.h
header file conditional to avoid that including that header file after
<linux/blkdev.h> causes the compiler to complain about a SECTOR_SIZE
redefinition.

Note: the SECTOR_SIZE / SECTOR_SHIFT / SECTOR_BITS definitions have
not been removed from uapi header files nor from NAND drivers in
which these constants are used for another purpose than converting
block layer offsets and sizes into a number of sectors.

Cc: David S. Miller <davem@davemloft.net>
Cc: Mike Snitzer <snitzer@redhat.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Reviewed-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/xtensa/platforms/iss/simdisk.c |    1 
 drivers/block/brd.c                 |    1 
 drivers/block/null_blk.c            |    2 -
 drivers/block/rbd.c                 |    9 -------
 drivers/block/zram/zram_drv.h       |    1 
 drivers/ide/ide-cd.c                |    8 +++---
 drivers/ide/ide-cd.h                |    6 -----
 drivers/nvdimm/nd.h                 |    1 
 drivers/scsi/gdth.h                 |    3 --
 include/linux/blkdev.h              |   42 ++++++++++++++++++++++++++----------
 include/linux/device-mapper.h       |    2 -
 include/linux/ide.h                 |    1 
 include/uapi/linux/msdos_fs.h       |    2 +
 13 files changed, 38 insertions(+), 41 deletions(-)

--- a/arch/xtensa/platforms/iss/simdisk.c
+++ b/arch/xtensa/platforms/iss/simdisk.c
@@ -21,7 +21,6 @@
 #include <platform/simcall.h>
 
 #define SIMDISK_MAJOR 240
-#define SECTOR_SHIFT 9
 #define SIMDISK_MINORS 1
 #define MAX_SIMDISK_COUNT 10
 
--- a/drivers/block/brd.c
+++ b/drivers/block/brd.c
@@ -28,7 +28,6 @@
 
 #include <linux/uaccess.h>
 
-#define SECTOR_SHIFT		9
 #define PAGE_SECTORS_SHIFT	(PAGE_SHIFT - SECTOR_SHIFT)
 #define PAGE_SECTORS		(1 << PAGE_SECTORS_SHIFT)
 
--- a/drivers/block/null_blk.c
+++ b/drivers/block/null_blk.c
@@ -16,10 +16,8 @@
 #include <linux/configfs.h>
 #include <linux/badblocks.h>
 
-#define SECTOR_SHIFT		9
 #define PAGE_SECTORS_SHIFT	(PAGE_SHIFT - SECTOR_SHIFT)
 #define PAGE_SECTORS		(1 << PAGE_SECTORS_SHIFT)
-#define SECTOR_SIZE		(1 << SECTOR_SHIFT)
 #define SECTOR_MASK		(PAGE_SECTORS - 1)
 
 #define FREE_BATCH		16
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -51,15 +51,6 @@
 #define RBD_DEBUG	/* Activate rbd_assert() calls */
 
 /*
- * The basic unit of block I/O is a sector.  It is interpreted in a
- * number of contexts in Linux (blk, bio, genhd), but the default is
- * universally 512 bytes.  These symbols are just slightly more
- * meaningful than the bare numbers they represent.
- */
-#define	SECTOR_SHIFT	9
-#define	SECTOR_SIZE	(1ULL << SECTOR_SHIFT)
-
-/*
  * Increment the given counter and return its updated value.
  * If the counter is already 0 it will not be incremented.
  * If the counter is already at its maximum value returns
--- a/drivers/block/zram/zram_drv.h
+++ b/drivers/block/zram/zram_drv.h
@@ -37,7 +37,6 @@ static const size_t max_zpage_size = PAG
 
 /*-- End of configurable params */
 
-#define SECTOR_SHIFT		9
 #define SECTORS_PER_PAGE_SHIFT	(PAGE_SHIFT - SECTOR_SHIFT)
 #define SECTORS_PER_PAGE	(1 << SECTORS_PER_PAGE_SHIFT)
 #define ZRAM_LOGICAL_BLOCK_SHIFT 12
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -712,7 +712,7 @@ static ide_startstop_t cdrom_start_rw(id
 	struct request_queue *q = drive->queue;
 	int write = rq_data_dir(rq) == WRITE;
 	unsigned short sectors_per_frame =
-		queue_logical_block_size(q) >> SECTOR_BITS;
+		queue_logical_block_size(q) >> SECTOR_SHIFT;
 
 	ide_debug_log(IDE_DBG_RQ, "rq->cmd[0]: 0x%x, rq->cmd_flags: 0x%x, "
 				  "secs_per_frame: %u",
@@ -919,7 +919,7 @@ static int cdrom_read_capacity(ide_drive
 	 * end up being bogus.
 	 */
 	blocklen = be32_to_cpu(capbuf.blocklen);
-	blocklen = (blocklen >> SECTOR_BITS) << SECTOR_BITS;
+	blocklen = (blocklen >> SECTOR_SHIFT) << SECTOR_SHIFT;
 	switch (blocklen) {
 	case 512:
 	case 1024:
@@ -935,7 +935,7 @@ static int cdrom_read_capacity(ide_drive
 	}
 
 	*capacity = 1 + be32_to_cpu(capbuf.lba);
-	*sectors_per_frame = blocklen >> SECTOR_BITS;
+	*sectors_per_frame = blocklen >> SECTOR_SHIFT;
 
 	ide_debug_log(IDE_DBG_PROBE, "cap: %lu, sectors_per_frame: %lu",
 				     *capacity, *sectors_per_frame);
@@ -1012,7 +1012,7 @@ int ide_cd_read_toc(ide_drive_t *drive,
 	drive->probed_capacity = toc->capacity * sectors_per_frame;
 
 	blk_queue_logical_block_size(drive->queue,
-				     sectors_per_frame << SECTOR_BITS);
+				     sectors_per_frame << SECTOR_SHIFT);
 
 	/* first read just the header, so we know how long the TOC is */
 	stat = cdrom_read_tocentry(drive, 0, 1, 0, (char *) &toc->hdr,
--- a/drivers/ide/ide-cd.h
+++ b/drivers/ide/ide-cd.h
@@ -21,11 +21,7 @@
 
 /************************************************************************/
 
-#define SECTOR_BITS 		9
-#ifndef SECTOR_SIZE
-#define SECTOR_SIZE		(1 << SECTOR_BITS)
-#endif
-#define SECTORS_PER_FRAME	(CD_FRAMESIZE >> SECTOR_BITS)
+#define SECTORS_PER_FRAME	(CD_FRAMESIZE >> SECTOR_SHIFT)
 #define SECTOR_BUFFER_SIZE	(CD_FRAMESIZE * 32)
 
 /* Capabilities Page size including 8 bytes of Mode Page Header */
--- a/drivers/nvdimm/nd.h
+++ b/drivers/nvdimm/nd.h
@@ -29,7 +29,6 @@ enum {
 	 * BTT instance
 	 */
 	ND_MAX_LANES = 256,
-	SECTOR_SHIFT = 9,
 	INT_LBASIZE_ALIGNMENT = 64,
 	NVDIMM_IO_ATOMIC = 1,
 };
--- a/drivers/scsi/gdth.h
+++ b/drivers/scsi/gdth.h
@@ -178,9 +178,6 @@
 #define MSG_SIZE        34                      /* size of message structure */
 #define MSG_REQUEST     0                       /* async. event: message */
 
-/* cacheservice defines */
-#define SECTOR_SIZE     0x200                   /* always 512 bytes per sec. */
-
 /* DPMEM constants */
 #define DPMEM_MAGIC     0xC0FFEE11
 #define IC_HEADER_BYTES 48
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1016,6 +1016,19 @@ static inline struct request_queue *bdev
 }
 
 /*
+ * The basic unit of block I/O is a sector. It is used in a number of contexts
+ * in Linux (blk, bio, genhd). The size of one sector is 512 = 2**9
+ * bytes. Variables of type sector_t represent an offset or size that is a
+ * multiple of 512 bytes. Hence these two constants.
+ */
+#ifndef SECTOR_SHIFT
+#define SECTOR_SHIFT 9
+#endif
+#ifndef SECTOR_SIZE
+#define SECTOR_SIZE (1 << SECTOR_SHIFT)
+#endif
+
+/*
  * blk_rq_pos()			: the current sector
  * blk_rq_bytes()		: bytes left in the entire request
  * blk_rq_cur_bytes()		: bytes left in the current segment
@@ -1042,12 +1055,12 @@ extern unsigned int blk_rq_err_bytes(con
 
 static inline unsigned int blk_rq_sectors(const struct request *rq)
 {
-	return blk_rq_bytes(rq) >> 9;
+	return blk_rq_bytes(rq) >> SECTOR_SHIFT;
 }
 
 static inline unsigned int blk_rq_cur_sectors(const struct request *rq)
 {
-	return blk_rq_cur_bytes(rq) >> 9;
+	return blk_rq_cur_bytes(rq) >> SECTOR_SHIFT;
 }
 
 /*
@@ -1067,7 +1080,8 @@ static inline unsigned int blk_queue_get
 						     int op)
 {
 	if (unlikely(op == REQ_OP_DISCARD || op == REQ_OP_SECURE_ERASE))
-		return min(q->limits.max_discard_sectors, UINT_MAX >> 9);
+		return min(q->limits.max_discard_sectors,
+			   UINT_MAX >> SECTOR_SHIFT);
 
 	if (unlikely(op == REQ_OP_WRITE_SAME))
 		return q->limits.max_write_same_sectors;
@@ -1376,16 +1390,21 @@ extern int blkdev_issue_zeroout(struct b
 static inline int sb_issue_discard(struct super_block *sb, sector_t block,
 		sector_t nr_blocks, gfp_t gfp_mask, unsigned long flags)
 {
-	return blkdev_issue_discard(sb->s_bdev, block << (sb->s_blocksize_bits - 9),
-				    nr_blocks << (sb->s_blocksize_bits - 9),
+	return blkdev_issue_discard(sb->s_bdev,
+				    block << (sb->s_blocksize_bits -
+					      SECTOR_SHIFT),
+				    nr_blocks << (sb->s_blocksize_bits -
+						  SECTOR_SHIFT),
 				    gfp_mask, flags);
 }
 static inline int sb_issue_zeroout(struct super_block *sb, sector_t block,
 		sector_t nr_blocks, gfp_t gfp_mask)
 {
 	return blkdev_issue_zeroout(sb->s_bdev,
-				    block << (sb->s_blocksize_bits - 9),
-				    nr_blocks << (sb->s_blocksize_bits - 9),
+				    block << (sb->s_blocksize_bits -
+					      SECTOR_SHIFT),
+				    nr_blocks << (sb->s_blocksize_bits -
+						  SECTOR_SHIFT),
 				    gfp_mask, 0);
 }
 
@@ -1492,7 +1511,8 @@ static inline int queue_alignment_offset
 static inline int queue_limit_alignment_offset(struct queue_limits *lim, sector_t sector)
 {
 	unsigned int granularity = max(lim->physical_block_size, lim->io_min);
-	unsigned int alignment = sector_div(sector, granularity >> 9) << 9;
+	unsigned int alignment = sector_div(sector, granularity >> SECTOR_SHIFT)
+		<< SECTOR_SHIFT;
 
 	return (granularity + lim->alignment_offset - alignment) % granularity;
 }
@@ -1526,8 +1546,8 @@ static inline int queue_limit_discard_al
 		return 0;
 
 	/* Why are these in bytes, not sectors? */
-	alignment = lim->discard_alignment >> 9;
-	granularity = lim->discard_granularity >> 9;
+	alignment = lim->discard_alignment >> SECTOR_SHIFT;
+	granularity = lim->discard_granularity >> SECTOR_SHIFT;
 	if (!granularity)
 		return 0;
 
@@ -1538,7 +1558,7 @@ static inline int queue_limit_discard_al
 	offset = (granularity + alignment - offset) % granularity;
 
 	/* Turn it back into bytes, gaah */
-	return offset << 9;
+	return offset << SECTOR_SHIFT;
 }
 
 static inline int bdev_discard_alignment(struct block_device *bdev)
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -577,8 +577,6 @@ do {									\
 #define DMEMIT(x...) sz += ((sz >= maxlen) ? \
 			  0 : scnprintf(result + sz, maxlen - sz, x))
 
-#define SECTOR_SHIFT 9
-
 /*
  * Definitions of return values from target end_io function.
  */
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -165,7 +165,6 @@ struct ide_io_ports {
  */
 #define PARTN_BITS	6	/* number of minor dev bits for partitions */
 #define MAX_DRIVES	2	/* per interface; 2 assumed by lots of code */
-#define SECTOR_SIZE	512
 
 /*
  * Timeouts for various operations:
--- a/include/uapi/linux/msdos_fs.h
+++ b/include/uapi/linux/msdos_fs.h
@@ -10,7 +10,9 @@
  * The MS-DOS filesystem constants/structures
  */
 
+#ifndef SECTOR_SIZE
 #define SECTOR_SIZE	512		/* sector size (bytes) */
+#endif
 #define SECTOR_BITS	9		/* log2(SECTOR_SIZE) */
 #define MSDOS_DPB	(MSDOS_DPS)	/* dir entries per block */
 #define MSDOS_DPB_BITS	4		/* log2(MSDOS_DPB) */


