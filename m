Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8039C145544
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 14:24:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729949AbgAVNUV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 08:20:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:36536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729947AbgAVNUV (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 08:20:21 -0500
Received: from localhost (unknown [84.241.205.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D4CB524125;
        Wed, 22 Jan 2020 13:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579699220;
        bh=qYTjOtVB/6GImYvCpgBxWMCVtpws3TOB59bPhO6gvoY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Co6CFDZnmUAyiX3BH6UVyTmc+vR6Q0rTSwRVbt3jBTH8b60kahaFxwyaD91K1wbcS
         fdHtXzfoHRa0wcRkewwEIpro0L16RO4Aa/u0sVuiQ/+rBIfV7jo63YEoD6oJOSzkJo
         AGI4dBNtVyVhnRa/KH2OruWN9Uk4uHgRLwPNcjZ8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Ming Lei <ming.lei@redhat.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.4 031/222] block: fix an integer overflow in logical block size
Date:   Wed, 22 Jan 2020 10:26:57 +0100
Message-Id: <20200122092835.700575757@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092833.339495161@linuxfoundation.org>
References: <20200122092833.339495161@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mikulas Patocka <mpatocka@redhat.com>

commit ad6bf88a6c19a39fb3b0045d78ea880325dfcf15 upstream.

Logical block size has type unsigned short. That means that it can be at
most 32768. However, there are architectures that can run with 64k pages
(for example arm64) and on these architectures, it may be possible to
create block devices with 64k block size.

For exmaple (run this on an architecture with 64k pages):

Mount will fail with this error because it tries to read the superblock using 2-sector
access:
  device-mapper: writecache: I/O is not aligned, sector 2, size 1024, block size 65536
  EXT4-fs (dm-0): unable to read superblock

This patch changes the logical block size from unsigned short to unsigned
int to avoid the overflow.

Cc: stable@vger.kernel.org
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 block/blk-settings.c            |    2 +-
 drivers/md/dm-snap-persistent.c |    2 +-
 drivers/md/raid0.c              |    2 +-
 include/linux/blkdev.h          |    8 ++++----
 4 files changed, 7 insertions(+), 7 deletions(-)

--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -328,7 +328,7 @@ EXPORT_SYMBOL(blk_queue_max_segment_size
  *   storage device can address.  The default of 512 covers most
  *   hardware.
  **/
-void blk_queue_logical_block_size(struct request_queue *q, unsigned short size)
+void blk_queue_logical_block_size(struct request_queue *q, unsigned int size)
 {
 	q->limits.logical_block_size = size;
 
--- a/drivers/md/dm-snap-persistent.c
+++ b/drivers/md/dm-snap-persistent.c
@@ -17,7 +17,7 @@
 #include <linux/dm-bufio.h>
 
 #define DM_MSG_PREFIX "persistent snapshot"
-#define DM_CHUNK_SIZE_DEFAULT_SECTORS 32	/* 16KB */
+#define DM_CHUNK_SIZE_DEFAULT_SECTORS 32U	/* 16KB */
 
 #define DM_PREFETCH_CHUNKS		12
 
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -87,7 +87,7 @@ static int create_strip_zones(struct mdd
 	char b[BDEVNAME_SIZE];
 	char b2[BDEVNAME_SIZE];
 	struct r0conf *conf = kzalloc(sizeof(*conf), GFP_KERNEL);
-	unsigned short blksize = 512;
+	unsigned blksize = 512;
 
 	*private_conf = ERR_PTR(-ENOMEM);
 	if (!conf)
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -328,6 +328,7 @@ struct queue_limits {
 	unsigned int		max_sectors;
 	unsigned int		max_segment_size;
 	unsigned int		physical_block_size;
+	unsigned int		logical_block_size;
 	unsigned int		alignment_offset;
 	unsigned int		io_min;
 	unsigned int		io_opt;
@@ -338,7 +339,6 @@ struct queue_limits {
 	unsigned int		discard_granularity;
 	unsigned int		discard_alignment;
 
-	unsigned short		logical_block_size;
 	unsigned short		max_segments;
 	unsigned short		max_integrity_segments;
 	unsigned short		max_discard_segments;
@@ -1080,7 +1080,7 @@ extern void blk_queue_max_write_same_sec
 		unsigned int max_write_same_sectors);
 extern void blk_queue_max_write_zeroes_sectors(struct request_queue *q,
 		unsigned int max_write_same_sectors);
-extern void blk_queue_logical_block_size(struct request_queue *, unsigned short);
+extern void blk_queue_logical_block_size(struct request_queue *, unsigned int);
 extern void blk_queue_physical_block_size(struct request_queue *, unsigned int);
 extern void blk_queue_alignment_offset(struct request_queue *q,
 				       unsigned int alignment);
@@ -1294,7 +1294,7 @@ static inline unsigned int queue_max_seg
 	return q->limits.max_segment_size;
 }
 
-static inline unsigned short queue_logical_block_size(const struct request_queue *q)
+static inline unsigned queue_logical_block_size(const struct request_queue *q)
 {
 	int retval = 512;
 
@@ -1304,7 +1304,7 @@ static inline unsigned short queue_logic
 	return retval;
 }
 
-static inline unsigned short bdev_logical_block_size(struct block_device *bdev)
+static inline unsigned int bdev_logical_block_size(struct block_device *bdev)
 {
 	return queue_logical_block_size(bdev_get_queue(bdev));
 }


