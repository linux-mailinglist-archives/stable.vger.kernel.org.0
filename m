Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B90F72E3F24
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:38:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392156AbgL1Of4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:35:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:40476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2504943AbgL1OdQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:33:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5BD082053B;
        Mon, 28 Dec 2020 14:33:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165980;
        bh=Rwv01PGWWLZf6hc+t2V07kshtlZbgIQx3NHqh79qWLQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fFduu8qXwV1blkYClGvYkYkCxmMcoTitFnLCrV6ddg2L97z2IbHXIUzzmP9deaLzf
         XsdqR5A2Cc/fyaNm/CcKAIGYy2IENik6+HjnKSB/n7rB9VXcldyoptWTuCEEmaK4hT
         BZ/QRIjCk+00NJOnYjZB0DZZKjA+j2WBqaWCdU+A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Naohiro Aota <naohiro.aota@wdc.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Christoph Hellwig <hch@lst.de>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 716/717] null_blk: Fix zone size initialization
Date:   Mon, 28 Dec 2020 13:51:54 +0100
Message-Id: <20201228125055.302296396@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Damien Le Moal <damien.lemoal@wdc.com>

commit 0ebcdd702f49aeb0ad2e2d894f8c124a0acc6e23 upstream.

For a null_blk device with zoned mode enabled is currently initialized
with a number of zones equal to the device capacity divided by the zone
size, without considering if the device capacity is a multiple of the
zone size. If the zone size is not a divisor of the capacity, the zones
end up not covering the entire capacity, potentially resulting is out
of bounds accesses to the zone array.

Fix this by adding one last smaller zone with a size equal to the
remainder of the disk capacity divided by the zone size if the capacity
is not a multiple of the zone size. For such smaller last zone, the zone
capacity is also checked so that it does not exceed the smaller zone
size.

Reported-by: Naohiro Aota <naohiro.aota@wdc.com>
Fixes: ca4b2a011948 ("null_blk: add zone support")
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/block/null_blk_zoned.c |   23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

--- a/drivers/block/null_blk_zoned.c
+++ b/drivers/block/null_blk_zoned.c
@@ -6,8 +6,7 @@
 #define CREATE_TRACE_POINTS
 #include "null_blk_trace.h"
 
-/* zone_size in MBs to sectors. */
-#define ZONE_SIZE_SHIFT		11
+#define MB_TO_SECTS(mb) (((sector_t)mb * SZ_1M) >> SECTOR_SHIFT)
 
 static inline unsigned int null_zone_no(struct nullb_device *dev, sector_t sect)
 {
@@ -16,7 +15,7 @@ static inline unsigned int null_zone_no(
 
 int null_init_zoned_dev(struct nullb_device *dev, struct request_queue *q)
 {
-	sector_t dev_size = (sector_t)dev->size * 1024 * 1024;
+	sector_t dev_capacity_sects, zone_capacity_sects;
 	sector_t sector = 0;
 	unsigned int i;
 
@@ -38,9 +37,13 @@ int null_init_zoned_dev(struct nullb_dev
 		return -EINVAL;
 	}
 
-	dev->zone_size_sects = dev->zone_size << ZONE_SIZE_SHIFT;
-	dev->nr_zones = dev_size >>
-				(SECTOR_SHIFT + ilog2(dev->zone_size_sects));
+	zone_capacity_sects = MB_TO_SECTS(dev->zone_capacity);
+	dev_capacity_sects = MB_TO_SECTS(dev->size);
+	dev->zone_size_sects = MB_TO_SECTS(dev->zone_size);
+	dev->nr_zones = dev_capacity_sects >> ilog2(dev->zone_size_sects);
+	if (dev_capacity_sects & (dev->zone_size_sects - 1))
+		dev->nr_zones++;
+
 	dev->zones = kvmalloc_array(dev->nr_zones, sizeof(struct blk_zone),
 			GFP_KERNEL | __GFP_ZERO);
 	if (!dev->zones)
@@ -101,8 +104,12 @@ int null_init_zoned_dev(struct nullb_dev
 		struct blk_zone *zone = &dev->zones[i];
 
 		zone->start = zone->wp = sector;
-		zone->len = dev->zone_size_sects;
-		zone->capacity = dev->zone_capacity << ZONE_SIZE_SHIFT;
+		if (zone->start + dev->zone_size_sects > dev_capacity_sects)
+			zone->len = dev_capacity_sects - zone->start;
+		else
+			zone->len = dev->zone_size_sects;
+		zone->capacity =
+			min_t(sector_t, zone->len, zone_capacity_sects);
 		zone->type = BLK_ZONE_TYPE_SEQWRITE_REQ;
 		zone->cond = BLK_ZONE_COND_EMPTY;
 


