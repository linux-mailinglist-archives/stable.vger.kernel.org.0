Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10FE82E9965
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 17:01:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727745AbhADP7V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 10:59:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:36472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727695AbhADP7V (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Jan 2021 10:59:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9302F224D2;
        Mon,  4 Jan 2021 15:58:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609775893;
        bh=gntcKiKH6MKwyJ13aC9reLITQxIHhBnob8ZN6++dOwg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W0nXoYcuMkgyyVtUWNOf0wZI3+Il4MmPVGwnV78EKVfeKovZDwQrTvA3itx5jgA87
         m59Zyw5P7eUPAghHT/2cEAN5LUEYxMBhH3A4uFQ5xZBTnQBSajD2zlXqIpez8grbuV
         bWd+m2hHbn/agO7/Dn8vo1yjJ+9JOwDGvWniwI14=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Naohiro Aota <naohiro.aota@wdc.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Christoph Hellwig <hch@lst.de>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4.19 13/35] null_blk: Fix zone size initialization
Date:   Mon,  4 Jan 2021 16:57:16 +0100
Message-Id: <20210104155704.049016882@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210104155703.375788488@linuxfoundation.org>
References: <20210104155703.375788488@linuxfoundation.org>
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
 drivers/block/null_blk_zoned.c |   20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

--- a/drivers/block/null_blk_zoned.c
+++ b/drivers/block/null_blk_zoned.c
@@ -1,9 +1,9 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <linux/vmalloc.h>
+#include <linux/sizes.h>
 #include "null_blk.h"
 
-/* zone_size in MBs to sectors. */
-#define ZONE_SIZE_SHIFT		11
+#define MB_TO_SECTS(mb) (((sector_t)mb * SZ_1M) >> SECTOR_SHIFT)
 
 static inline unsigned int null_zone_no(struct nullb_device *dev, sector_t sect)
 {
@@ -12,7 +12,7 @@ static inline unsigned int null_zone_no(
 
 int null_zone_init(struct nullb_device *dev)
 {
-	sector_t dev_size = (sector_t)dev->size * 1024 * 1024;
+	sector_t dev_capacity_sects;
 	sector_t sector = 0;
 	unsigned int i;
 
@@ -25,9 +25,12 @@ int null_zone_init(struct nullb_device *
 		return -EINVAL;
 	}
 
-	dev->zone_size_sects = dev->zone_size << ZONE_SIZE_SHIFT;
-	dev->nr_zones = dev_size >>
-				(SECTOR_SHIFT + ilog2(dev->zone_size_sects));
+	dev_capacity_sects = MB_TO_SECTS(dev->size);
+	dev->zone_size_sects = MB_TO_SECTS(dev->zone_size);
+	dev->nr_zones = dev_capacity_sects >> ilog2(dev->zone_size_sects);
+	if (dev_capacity_sects & (dev->zone_size_sects - 1))
+		dev->nr_zones++;
+
 	dev->zones = kvmalloc_array(dev->nr_zones, sizeof(struct blk_zone),
 			GFP_KERNEL | __GFP_ZERO);
 	if (!dev->zones)
@@ -37,7 +40,10 @@ int null_zone_init(struct nullb_device *
 		struct blk_zone *zone = &dev->zones[i];
 
 		zone->start = zone->wp = sector;
-		zone->len = dev->zone_size_sects;
+		if (zone->start + dev->zone_size_sects > dev_capacity_sects)
+			zone->len = dev_capacity_sects - zone->start;
+		else
+			zone->len = dev->zone_size_sects;
 		zone->type = BLK_ZONE_TYPE_SEQWRITE_REQ;
 		zone->cond = BLK_ZONE_COND_EMPTY;
 


