Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EC1D59B8F9
	for <lists+stable@lfdr.de>; Mon, 22 Aug 2022 08:08:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232766AbiHVGHe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Aug 2022 02:07:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232684AbiHVGHc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Aug 2022 02:07:32 -0400
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D512526568;
        Sun, 21 Aug 2022 23:07:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1661148451; x=1692684451;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=nLw+0WBUmxLDNMLDXeNhVUbDnyQadVyurxqiCzFyX4k=;
  b=R2syFCTTZFsubF9CibwnTqZBrjrRHz9D32HZJD+1omWTxA/asE0GHbz/
   SYa75Xf4Sh5mhMEHobfeIUuerZv0YC4SgpCB2UktSBm8X1XuL/TAz84pe
   b37QCOzm39R17SyTAeu9tSLmXyjS5qKIKBOV3TNiHecEl0dgymGZaN84G
   wlvpGmt7XeuzjKBUgjMwVEHXkKzghBdfOK7aS3FUqy5q90TQrUG4lqGWW
   vwaxHgqP9D0B6qpI+AaQFc3llSF27RtBPDvqRzfKfmIyVL1cQggGtnkRy
   YoG5++iwz2WTlTEQl8JF6UbpxZCrMlMtQsBix8Lg9ZpcrPmWK/MjRXU3T
   A==;
X-IronPort-AV: E=Sophos;i="5.93,254,1654531200"; 
   d="scan'208";a="321397073"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 22 Aug 2022 14:07:31 +0800
IronPort-SDR: hl105plH8itLbQVdVGq7to6Zs1xD16A1BSWeLrONw7Ws5svOWUhRKrGkFgRRkxywefUScOl/MK
 LiZpNpbltZ2QRIYbooEqSaFQGV/YIVoxJDIw5MYQTh/KnC/eqeV7vGojBq3QaY7c4yBcnse8xh
 Am51liQ9Gg/13F0Jyu7cSIhhaHaJgJaOhrikERQSF9rkT5DH8PYtD3L2Eug6bYDQiiMl6A4q9s
 ThIwDO3zC4xWkjph5y24DiXGt4A2bLYBosQhmE7aoT6sguWsv7Lo8zJ3XQ86rEaWuVASX0qqbp
 n8QpEANEJh5qhVfQlwgaKXGv
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 21 Aug 2022 22:28:13 -0700
IronPort-SDR: qPPGlLoTlobOvHwyCk9lml5LTzJrgTBjKgWkVDNhsUYDgASAB9xJJQlwstPyBWk9oXMwkAFgdN
 /ksNbYPBMVcUB2rqLys0trSp0mWx4PfySzs1k8NEgXgQ+Mr3NWjOZym4HU/qYzjJqdBwNJAymj
 j0ZFiSBZ9kJFuG0kQfPxvGVg92KHzpLpn50yyezCZtiuVYDcMy1Z24N/e97ECFip3eV4zgEhKk
 lDhkxDfZVp1qY3qY/hL8CM+TMtX9F6uye4qyJBYmTbCd2vxCgyFnjoxtWsd6TzTvoIF43uGrEu
 92I=
WDCIronportException: Internal
Received: from unknown (HELO naota-xeon.wdc.com) ([10.225.50.191])
  by uls-op-cesaip02.wdc.com with ESMTP; 21 Aug 2022 23:07:30 -0700
From:   Naohiro Aota <naohiro.aota@wdc.com>
To:     linux-btrfs@vger.kernel.org, stable@vger.kernel.org
Cc:     Naohiro Aota <naohiro.aota@wdc.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH STABLE 5.15 3/5] btrfs: zoned: revive max_zone_append_bytes
Date:   Mon, 22 Aug 2022 15:07:02 +0900
Message-Id: <20220822060704.1278361-4-naohiro.aota@wdc.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220822060704.1278361-1-naohiro.aota@wdc.com>
References: <20220822060704.1278361-1-naohiro.aota@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit c2ae7b772ef4e86c5ddf3fd47bf59045ae96a414 upstream

This patch is basically a revert of commit 5a80d1c6a270 ("btrfs: zoned:
remove max_zone_append_size logic"), but without unnecessary ASSERT and
check. The max_zone_append_size will be used as a hint to estimate the
number of extents to cover delalloc/writeback region in the later commits.

The size of a ZONE APPEND bio is also limited by queue_max_segments(), so
this commit considers it to calculate max_zone_append_size. Technically, a
bio can be larger than queue_max_segments() * PAGE_SIZE if the pages are
contiguous. But, it is safe to consider "queue_max_segments() * PAGE_SIZE"
as an upper limit of an extent size to calculate the number of extents
needed to write data.

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/ctree.h |  2 ++
 fs/btrfs/zoned.c | 17 +++++++++++++++++
 fs/btrfs/zoned.h |  1 +
 3 files changed, 20 insertions(+)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index d1838de0b39c..099c30477cf2 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1017,6 +1017,8 @@ struct btrfs_fs_info {
 		u64 zoned;
 	};
 
+	/* Max size to emit ZONE_APPEND write command */
+	u64 max_zone_append_size;
 	struct mutex zoned_meta_io_lock;
 	spinlock_t treelog_bg_lock;
 	u64 treelog_bg;
diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index fc791f7c7142..bfbceb94c4e2 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -386,6 +386,16 @@ int btrfs_get_dev_zone_info(struct btrfs_device *device, bool populate_cache)
 	nr_sectors = bdev_nr_sectors(bdev);
 	zone_info->zone_size_shift = ilog2(zone_info->zone_size);
 	zone_info->nr_zones = nr_sectors >> ilog2(zone_sectors);
+	/*
+	 * We limit max_zone_append_size also by max_segments *
+	 * PAGE_SIZE. Technically, we can have multiple pages per segment. But,
+	 * since btrfs adds the pages one by one to a bio, and btrfs cannot
+	 * increase the metadata reservation even if it increases the number of
+	 * extents, it is safe to stick with the limit.
+	 */
+	zone_info->max_zone_append_size =
+		min_t(u64, (u64)bdev_max_zone_append_sectors(bdev) << SECTOR_SHIFT,
+		      (u64)bdev_max_segments(bdev) << PAGE_SHIFT);
 	if (!IS_ALIGNED(nr_sectors, zone_sectors))
 		zone_info->nr_zones++;
 
@@ -570,6 +580,7 @@ int btrfs_check_zoned_mode(struct btrfs_fs_info *fs_info)
 	u64 zoned_devices = 0;
 	u64 nr_devices = 0;
 	u64 zone_size = 0;
+	u64 max_zone_append_size = 0;
 	const bool incompat_zoned = btrfs_fs_incompat(fs_info, ZONED);
 	int ret = 0;
 
@@ -605,6 +616,11 @@ int btrfs_check_zoned_mode(struct btrfs_fs_info *fs_info)
 				ret = -EINVAL;
 				goto out;
 			}
+			if (!max_zone_append_size ||
+			    (zone_info->max_zone_append_size &&
+			     zone_info->max_zone_append_size < max_zone_append_size))
+				max_zone_append_size =
+					zone_info->max_zone_append_size;
 		}
 		nr_devices++;
 	}
@@ -654,6 +670,7 @@ int btrfs_check_zoned_mode(struct btrfs_fs_info *fs_info)
 	}
 
 	fs_info->zone_size = zone_size;
+	fs_info->max_zone_append_size = max_zone_append_size;
 	fs_info->fs_devices->chunk_alloc_policy = BTRFS_CHUNK_ALLOC_ZONED;
 
 	/*
diff --git a/fs/btrfs/zoned.h b/fs/btrfs/zoned.h
index 574490ea2cc8..1ef493fcd504 100644
--- a/fs/btrfs/zoned.h
+++ b/fs/btrfs/zoned.h
@@ -23,6 +23,7 @@ struct btrfs_zoned_device_info {
 	 */
 	u64 zone_size;
 	u8  zone_size_shift;
+	u64 max_zone_append_size;
 	u32 nr_zones;
 	unsigned long *seq_zones;
 	unsigned long *empty_zones;
-- 
2.37.2

