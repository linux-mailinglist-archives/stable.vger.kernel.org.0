Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FC061B67F7
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 01:12:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728941AbgDWXLS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 19:11:18 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50258 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728573AbgDWXGw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 19:06:52 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvb-0004mt-0m; Fri, 24 Apr 2020 00:06:43 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvW-00E6x4-V2; Fri, 24 Apr 2020 00:06:38 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Mikulas Patocka" <mpatocka@redhat.com>,
        "Ming Lei" <ming.lei@redhat.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "Jens Axboe" <axboe@kernel.dk>
Date:   Fri, 24 Apr 2020 00:06:56 +0100
Message-ID: <lsq.1587683028.54828058@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 189/245] block: fix an integer overflow in logical
 block size
In-Reply-To: <lsq.1587683027.831233700@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.83-rc1 review patch.  If anyone has any objections, please let me know.

------------------

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

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
[bwh: Backported to 3.16: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 block/blk-settings.c            | 2 +-
 drivers/md/dm-snap-persistent.c | 2 +-
 drivers/md/raid0.c              | 2 +-
 include/linux/blkdev.h          | 8 ++++----
 4 files changed, 7 insertions(+), 7 deletions(-)

--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -373,7 +373,7 @@ EXPORT_SYMBOL(blk_queue_max_segment_size
  *   storage device can address.  The default of 512 covers most
  *   hardware.
  **/
-void blk_queue_logical_block_size(struct request_queue *q, unsigned short size)
+void blk_queue_logical_block_size(struct request_queue *q, unsigned int size)
 {
 	q->limits.logical_block_size = size;
 
--- a/drivers/md/dm-snap-persistent.c
+++ b/drivers/md/dm-snap-persistent.c
@@ -16,7 +16,7 @@
 #include "dm-bufio.h"
 
 #define DM_MSG_PREFIX "persistent snapshot"
-#define DM_CHUNK_SIZE_DEFAULT_SECTORS 32	/* 16KB */
+#define DM_CHUNK_SIZE_DEFAULT_SECTORS 32U	/* 16KB */
 
 #define DM_PREFETCH_CHUNKS		12
 
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -88,7 +88,7 @@ static int create_strip_zones(struct mdd
 	char b[BDEVNAME_SIZE];
 	char b2[BDEVNAME_SIZE];
 	struct r0conf *conf = kzalloc(sizeof(*conf), GFP_KERNEL);
-	unsigned short blksize = 512;
+	unsigned blksize = 512;
 
 	if (!conf)
 		return -ENOMEM;
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -284,6 +284,7 @@ struct queue_limits {
 	unsigned int		max_sectors;
 	unsigned int		max_segment_size;
 	unsigned int		physical_block_size;
+	unsigned int		logical_block_size;
 	unsigned int		alignment_offset;
 	unsigned int		io_min;
 	unsigned int		io_opt;
@@ -292,7 +293,6 @@ struct queue_limits {
 	unsigned int		discard_granularity;
 	unsigned int		discard_alignment;
 
-	unsigned short		logical_block_size;
 	unsigned short		max_segments;
 	unsigned short		max_integrity_segments;
 
@@ -1017,7 +1017,7 @@ extern void blk_queue_max_discard_sector
 		unsigned int max_discard_sectors);
 extern void blk_queue_max_write_same_sectors(struct request_queue *q,
 		unsigned int max_write_same_sectors);
-extern void blk_queue_logical_block_size(struct request_queue *, unsigned short);
+extern void blk_queue_logical_block_size(struct request_queue *, unsigned int);
 extern void blk_queue_physical_block_size(struct request_queue *, unsigned int);
 extern void blk_queue_alignment_offset(struct request_queue *q,
 				       unsigned int alignment);
@@ -1232,7 +1232,7 @@ static inline unsigned int queue_max_seg
 	return q->limits.max_segment_size;
 }
 
-static inline unsigned short queue_logical_block_size(struct request_queue *q)
+static inline unsigned queue_logical_block_size(struct request_queue *q)
 {
 	int retval = 512;
 
@@ -1242,7 +1242,7 @@ static inline unsigned short queue_logic
 	return retval;
 }
 
-static inline unsigned short bdev_logical_block_size(struct block_device *bdev)
+static inline unsigned int bdev_logical_block_size(struct block_device *bdev)
 {
 	return queue_logical_block_size(bdev_get_queue(bdev));
 }

