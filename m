Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4B6334CAC8
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:41:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234982AbhC2Ijw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:39:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:32932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234281AbhC2Iik (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:38:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EB33761580;
        Mon, 29 Mar 2021 08:38:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617007120;
        bh=G9lst5iva3rCBHVaFyoyQEqrDtySlnE1DkvJQkJg+Z8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OXrE2xH0adjihQ2tiNtQ4nuWpEZW3oQFxRtWK9E6ERqHAdqhRT32TSZ5mHXcBP2Vt
         DP28o7Rzyo0kkbJ9BIAb0oBQWgEfgKZuIt0uwEJyIR0Ir2ar5yAy32EejSX+PHorZ0
         xQAWgLbQ250K5cKP1Cv7wCAb19W7VlkuE3YX2Zek=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 227/254] dm table: Fix zoned model check and zone sectors check
Date:   Mon, 29 Mar 2021 09:59:03 +0200
Message-Id: <20210329075640.549601982@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075633.135869143@linuxfoundation.org>
References: <20210329075633.135869143@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>

[ Upstream commit 2d669ceb69c276f7637cf760287ca4187add082e ]

Commit 24f6b6036c9e ("dm table: fix zoned iterate_devices based device
capability checks") triggered dm table load failure when dm-zoned device
is set up for zoned block devices and a regular device for cache.

The commit inverted logic of two callback functions for iterate_devices:
device_is_zoned_model() and device_matches_zone_sectors(). The logic of
device_is_zoned_model() was inverted then all destination devices of all
targets in dm table are required to have the expected zoned model. This
is fine for dm-linear, dm-flakey and dm-crypt on zoned block devices
since each target has only one destination device. However, this results
in failure for dm-zoned with regular cache device since that target has
both regular block device and zoned block devices.

As for device_matches_zone_sectors(), the commit inverted the logic to
require all zoned block devices in each target have the specified
zone_sectors. This check also fails for regular block device which does
not have zones.

To avoid the check failures, fix the zone model check and the zone
sectors check. For zone model check, introduce the new feature flag
DM_TARGET_MIXED_ZONED_MODEL, and set it to dm-zoned target. When the
target has this flag, allow it to have destination devices with any
zoned model. For zone sectors check, skip the check if the destination
device is not a zoned block device. Also add comments and improve an
error message to clarify expectations to the two checks.

Fixes: 24f6b6036c9e ("dm table: fix zoned iterate_devices based device capability checks")
Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-table.c         | 33 +++++++++++++++++++++++++--------
 drivers/md/dm-zoned-target.c  |  2 +-
 include/linux/device-mapper.h | 15 ++++++++++++++-
 3 files changed, 40 insertions(+), 10 deletions(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 77086db8b920..7291fd3106ff 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1380,6 +1380,13 @@ static int device_not_zoned_model(struct dm_target *ti, struct dm_dev *dev,
 	return !q || blk_queue_zoned_model(q) != *zoned_model;
 }
 
+/*
+ * Check the device zoned model based on the target feature flag. If the target
+ * has the DM_TARGET_ZONED_HM feature flag set, host-managed zoned devices are
+ * also accepted but all devices must have the same zoned model. If the target
+ * has the DM_TARGET_MIXED_ZONED_MODEL feature set, the devices can have any
+ * zoned model with all zoned devices having the same zone size.
+ */
 static bool dm_table_supports_zoned_model(struct dm_table *t,
 					  enum blk_zoned_model zoned_model)
 {
@@ -1389,13 +1396,15 @@ static bool dm_table_supports_zoned_model(struct dm_table *t,
 	for (i = 0; i < dm_table_get_num_targets(t); i++) {
 		ti = dm_table_get_target(t, i);
 
-		if (zoned_model == BLK_ZONED_HM &&
-		    !dm_target_supports_zoned_hm(ti->type))
-			return false;
-
-		if (!ti->type->iterate_devices ||
-		    ti->type->iterate_devices(ti, device_not_zoned_model, &zoned_model))
-			return false;
+		if (dm_target_supports_zoned_hm(ti->type)) {
+			if (!ti->type->iterate_devices ||
+			    ti->type->iterate_devices(ti, device_not_zoned_model,
+						      &zoned_model))
+				return false;
+		} else if (!dm_target_supports_mixed_zoned_model(ti->type)) {
+			if (zoned_model == BLK_ZONED_HM)
+				return false;
+		}
 	}
 
 	return true;
@@ -1407,9 +1416,17 @@ static int device_not_matches_zone_sectors(struct dm_target *ti, struct dm_dev *
 	struct request_queue *q = bdev_get_queue(dev->bdev);
 	unsigned int *zone_sectors = data;
 
+	if (!blk_queue_is_zoned(q))
+		return 0;
+
 	return !q || blk_queue_zone_sectors(q) != *zone_sectors;
 }
 
+/*
+ * Check consistency of zoned model and zone sectors across all targets. For
+ * zone sectors, if the destination device is a zoned block device, it shall
+ * have the specified zone_sectors.
+ */
 static int validate_hardware_zoned_model(struct dm_table *table,
 					 enum blk_zoned_model zoned_model,
 					 unsigned int zone_sectors)
@@ -1428,7 +1445,7 @@ static int validate_hardware_zoned_model(struct dm_table *table,
 		return -EINVAL;
 
 	if (dm_table_any_dev_attr(table, device_not_matches_zone_sectors, &zone_sectors)) {
-		DMERR("%s: zone sectors is not consistent across all devices",
+		DMERR("%s: zone sectors is not consistent across all zoned devices",
 		      dm_device_name(table->md));
 		return -EINVAL;
 	}
diff --git a/drivers/md/dm-zoned-target.c b/drivers/md/dm-zoned-target.c
index 697f9de37355..7e88df64d197 100644
--- a/drivers/md/dm-zoned-target.c
+++ b/drivers/md/dm-zoned-target.c
@@ -1143,7 +1143,7 @@ static int dmz_message(struct dm_target *ti, unsigned int argc, char **argv,
 static struct target_type dmz_type = {
 	.name		 = "zoned",
 	.version	 = {2, 0, 0},
-	.features	 = DM_TARGET_SINGLETON | DM_TARGET_ZONED_HM,
+	.features	 = DM_TARGET_SINGLETON | DM_TARGET_MIXED_ZONED_MODEL,
 	.module		 = THIS_MODULE,
 	.ctr		 = dmz_ctr,
 	.dtr		 = dmz_dtr,
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index d2d7f9b6a276..50cc070cb1f7 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -246,7 +246,11 @@ struct target_type {
 #define dm_target_passes_integrity(type) ((type)->features & DM_TARGET_PASSES_INTEGRITY)
 
 /*
- * Indicates that a target supports host-managed zoned block devices.
+ * Indicates support for zoned block devices:
+ * - DM_TARGET_ZONED_HM: the target also supports host-managed zoned
+ *   block devices but does not support combining different zoned models.
+ * - DM_TARGET_MIXED_ZONED_MODEL: the target supports combining multiple
+ *   devices with different zoned models.
  */
 #define DM_TARGET_ZONED_HM		0x00000040
 #define dm_target_supports_zoned_hm(type) ((type)->features & DM_TARGET_ZONED_HM)
@@ -257,6 +261,15 @@ struct target_type {
 #define DM_TARGET_NOWAIT		0x00000080
 #define dm_target_supports_nowait(type) ((type)->features & DM_TARGET_NOWAIT)
 
+#ifdef CONFIG_BLK_DEV_ZONED
+#define DM_TARGET_MIXED_ZONED_MODEL	0x00000200
+#define dm_target_supports_mixed_zoned_model(type) \
+	((type)->features & DM_TARGET_MIXED_ZONED_MODEL)
+#else
+#define DM_TARGET_MIXED_ZONED_MODEL	0x00000000
+#define dm_target_supports_mixed_zoned_model(type) (false)
+#endif
+
 struct dm_target {
 	struct dm_table *table;
 	struct target_type *type;
-- 
2.30.1



