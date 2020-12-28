Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0A692E3A78
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:37:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390743AbgL1NhY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:37:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:37046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390736AbgL1NhX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:37:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3E3FD207C9;
        Mon, 28 Dec 2020 13:37:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609162627;
        bh=8g9+d2hB4xrT9Xv3W0xTCppMzn2CqcULZuB9RKXCTvU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GwaiuB9Cni2BMrdGLeelb1nuGESFpTi6T874KGBdt4JzN0Kk/K/6qCS0Ok+37xZTg
         xVb9bjWBtQmPRg/S0FOL0W0HFOFlhfz/imqD2qfcJyxrTUOzxU3J8rcUXazLhH9/rl
         fvs2JdcAsR3gu9IcFnRulrAgXXIJKbEBux2f1nBQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 018/453] block: Simplify REQ_OP_ZONE_RESET_ALL handling
Date:   Mon, 28 Dec 2020 13:44:14 +0100
Message-Id: <20201228124938.129556147@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Damien Le Moal <damien.lemoal@wdc.com>

[ Upstream commit c7a1d926dc4076aadad187614500afcd8de78818 ]

There is no need for the function __blkdev_reset_all_zones() as
REQ_OP_ZONE_RESET_ALL can be handled directly in blkdev_reset_zones()
bio loop with an early break from the loop. This patch removes this
function and modifies blkdev_reset_zones(), simplifying the code.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-zoned.c | 40 +++++++++++++---------------------------
 1 file changed, 13 insertions(+), 27 deletions(-)

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index 4bc5f260248a6..b17c094cb977c 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -202,32 +202,14 @@ int blkdev_report_zones(struct block_device *bdev, sector_t sector,
 }
 EXPORT_SYMBOL_GPL(blkdev_report_zones);
 
-/*
- * Special case of zone reset operation to reset all zones in one command,
- * useful for applications like mkfs.
- */
-static int __blkdev_reset_all_zones(struct block_device *bdev, gfp_t gfp_mask)
-{
-	struct bio *bio = bio_alloc(gfp_mask, 0);
-	int ret;
-
-	/* across the zones operations, don't need any sectors */
-	bio_set_dev(bio, bdev);
-	bio_set_op_attrs(bio, REQ_OP_ZONE_RESET_ALL, 0);
-
-	ret = submit_bio_wait(bio);
-	bio_put(bio);
-
-	return ret;
-}
-
 static inline bool blkdev_allow_reset_all_zones(struct block_device *bdev,
+						sector_t sector,
 						sector_t nr_sectors)
 {
 	if (!blk_queue_zone_resetall(bdev_get_queue(bdev)))
 		return false;
 
-	if (nr_sectors != part_nr_sects_read(bdev->bd_part))
+	if (sector || nr_sectors != part_nr_sects_read(bdev->bd_part))
 		return false;
 	/*
 	 * REQ_OP_ZONE_RESET_ALL can be executed only if the block device is
@@ -271,9 +253,6 @@ int blkdev_reset_zones(struct block_device *bdev,
 		/* Out of range */
 		return -EINVAL;
 
-	if (blkdev_allow_reset_all_zones(bdev, nr_sectors))
-		return  __blkdev_reset_all_zones(bdev, gfp_mask);
-
 	/* Check alignment (handle eventual smaller last zone) */
 	zone_sectors = blk_queue_zone_sectors(q);
 	if (sector & (zone_sectors - 1))
@@ -285,17 +264,24 @@ int blkdev_reset_zones(struct block_device *bdev,
 
 	blk_start_plug(&plug);
 	while (sector < end_sector) {
-
 		bio = blk_next_bio(bio, 0, gfp_mask);
-		bio->bi_iter.bi_sector = sector;
 		bio_set_dev(bio, bdev);
-		bio_set_op_attrs(bio, REQ_OP_ZONE_RESET, 0);
 
+		/*
+		 * Special case for the zone reset operation that reset all
+		 * zones, this is useful for applications like mkfs.
+		 */
+		if (blkdev_allow_reset_all_zones(bdev, sector, nr_sectors)) {
+			bio->bi_opf = REQ_OP_ZONE_RESET_ALL;
+			break;
+		}
+
+		bio->bi_opf = REQ_OP_ZONE_RESET;
+		bio->bi_iter.bi_sector = sector;
 		sector += zone_sectors;
 
 		/* This may take a while, so be nice to others */
 		cond_resched();
-
 	}
 
 	ret = submit_bio_wait(bio);
-- 
2.27.0



