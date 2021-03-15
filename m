Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30FAD33B9D8
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:09:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234993AbhCOOGx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:06:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:48170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233493AbhCOOBw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:01:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 22DCC64F44;
        Mon, 15 Mar 2021 14:01:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816911;
        bh=b/wjv+TaXy3JctKRELBAG1GtOJTlYgRS9cSqdaiFkdY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kSKb9xv7CDA0+ERaMjKiLphRCwG/DpCg/XsFzccCKvXbSadqYgAufnDfGCAOA9n1k
         4Tma1ntHwKdtGkaUN2W07/9r7DsvEX2sXsHezY3S8++08omQjlCmS8H2rk01Y6M6de
         XABOvkZD0rWYk1hsG+EfRdMV/y9/IVS5vIeMsTBk=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        Christoph Hellwig <hch@lst.de>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 184/290] block: Discard page cache of zone reset target range
Date:   Mon, 15 Mar 2021 14:54:37 +0100
Message-Id: <20210315135548.137253859@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135541.921894249@linuxfoundation.org>
References: <20210315135541.921894249@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>

commit e5113505904ea1c1c0e1f92c1cfa91fbf4da1694 upstream.

When zone reset ioctl and data read race for a same zone on zoned block
devices, the data read leaves stale page cache even though the zone
reset ioctl zero clears all the zone data on the device. To avoid
non-zero data read from the stale page cache after zone reset, discard
page cache of reset target zones in blkdev_zone_mgmt_ioctl(). Introduce
the helper function blkdev_truncate_zone_range() to discard the page
cache. Ensure the page cache discarded by calling the helper function
before and after zone reset in same manner as fallocate does.

This patch can be applied back to the stable kernel version v5.10.y.
Rework is needed for older stable kernels.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Fixes: 3ed05a987e0f ("blk-zoned: implement ioctls")
Cc: <stable@vger.kernel.org> # 5.10+
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Link: https://lore.kernel.org/r/20210311072546.678999-1-shinichiro.kawasaki@wdc.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/blk-zoned.c |   38 ++++++++++++++++++++++++++++++++++++--
 1 file changed, 36 insertions(+), 2 deletions(-)

--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -318,6 +318,22 @@ int blkdev_report_zones_ioctl(struct blo
 	return 0;
 }
 
+static int blkdev_truncate_zone_range(struct block_device *bdev, fmode_t mode,
+				      const struct blk_zone_range *zrange)
+{
+	loff_t start, end;
+
+	if (zrange->sector + zrange->nr_sectors <= zrange->sector ||
+	    zrange->sector + zrange->nr_sectors > get_capacity(bdev->bd_disk))
+		/* Out of range */
+		return -EINVAL;
+
+	start = zrange->sector << SECTOR_SHIFT;
+	end = ((zrange->sector + zrange->nr_sectors) << SECTOR_SHIFT) - 1;
+
+	return truncate_bdev_range(bdev, mode, start, end);
+}
+
 /*
  * BLKRESETZONE, BLKOPENZONE, BLKCLOSEZONE and BLKFINISHZONE ioctl processing.
  * Called from blkdev_ioctl.
@@ -329,6 +345,7 @@ int blkdev_zone_mgmt_ioctl(struct block_
 	struct request_queue *q;
 	struct blk_zone_range zrange;
 	enum req_opf op;
+	int ret;
 
 	if (!argp)
 		return -EINVAL;
@@ -352,6 +369,11 @@ int blkdev_zone_mgmt_ioctl(struct block_
 	switch (cmd) {
 	case BLKRESETZONE:
 		op = REQ_OP_ZONE_RESET;
+
+		/* Invalidate the page cache, including dirty pages. */
+		ret = blkdev_truncate_zone_range(bdev, mode, &zrange);
+		if (ret)
+			return ret;
 		break;
 	case BLKOPENZONE:
 		op = REQ_OP_ZONE_OPEN;
@@ -366,8 +388,20 @@ int blkdev_zone_mgmt_ioctl(struct block_
 		return -ENOTTY;
 	}
 
-	return blkdev_zone_mgmt(bdev, op, zrange.sector, zrange.nr_sectors,
-				GFP_KERNEL);
+	ret = blkdev_zone_mgmt(bdev, op, zrange.sector, zrange.nr_sectors,
+			       GFP_KERNEL);
+
+	/*
+	 * Invalidate the page cache again for zone reset: writes can only be
+	 * direct for zoned devices so concurrent writes would not add any page
+	 * to the page cache after/during reset. The page cache may be filled
+	 * again due to concurrent reads though and dropping the pages for
+	 * these is fine.
+	 */
+	if (!ret && cmd == BLKRESETZONE)
+		ret = blkdev_truncate_zone_range(bdev, mode, &zrange);
+
+	return ret;
 }
 
 static inline unsigned long *blk_alloc_zone_bitmap(int node,


