Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40B09333E96
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 14:36:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233577AbhCJN0Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 08:26:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:47960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233427AbhCJNZg (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Mar 2021 08:25:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CB07B650B2;
        Wed, 10 Mar 2021 13:25:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615382733;
        bh=nHG3tjfGzsmYwoKkC+TkT76s/zBiGzSC/ewR2liVWVA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kHTXcPfBuyqe8NJct/nXVxTRdBQbWTVwTJRYoScssmL0n5lISaW9+QwgBrPCpFm/6
         QWhl11X69EBT7sm9JAvh7zzofgq1qN3FKi1jJxn0VKY5gR+7gvXXYza5OxtIb2a5PE
         dvazSdrXDPQ5MaF/fF5BczMH8kNosNxPpE4Iwr5M=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeffle Xu <jefflexu@linux.alibaba.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 4.19 24/39] dm table: fix zoned iterate_devices based device capability checks
Date:   Wed, 10 Mar 2021 14:24:32 +0100
Message-Id: <20210310132320.478521101@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210310132319.708237392@linuxfoundation.org>
References: <20210310132319.708237392@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Jeffle Xu <jefflexu@linux.alibaba.com>

commit 24f6b6036c9eec21191646930ad42808e6180510 upstream.

Fix dm_table_supports_zoned_model() and invert logic of both
iterate_devices_callout_fn so that all devices' zoned capabilities are
properly checked.

Add one more parameter to dm_table_any_dev_attr(), which is actually
used as the @data parameter of iterate_devices_callout_fn, so that
dm_table_matches_zone_sectors() can be replaced by
dm_table_any_dev_attr().

Fixes: dd88d313bef02 ("dm table: add zoned block devices validation")
Cc: stable@vger.kernel.org
Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
[jeffle: also convert no_sg_merge and partial completion check]
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-table.c |   52 +++++++++++++++++---------------------------------
 1 file changed, 18 insertions(+), 34 deletions(-)

--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1413,10 +1413,10 @@ struct dm_target *dm_table_find_target(s
  * should use the iteration structure like dm_table_supports_nowait() or
  * dm_table_supports_discards(). Or introduce dm_table_all_devs_attr() that
  * uses an @anti_func that handle semantics of counter examples, e.g. not
- * capable of something. So: return !dm_table_any_dev_attr(t, anti_func);
+ * capable of something. So: return !dm_table_any_dev_attr(t, anti_func, data);
  */
 static bool dm_table_any_dev_attr(struct dm_table *t,
-				  iterate_devices_callout_fn func)
+				  iterate_devices_callout_fn func, void *data)
 {
 	struct dm_target *ti;
 	unsigned int i;
@@ -1425,7 +1425,7 @@ static bool dm_table_any_dev_attr(struct
 		ti = dm_table_get_target(t, i);
 
 		if (ti->type->iterate_devices &&
-		    ti->type->iterate_devices(ti, func, NULL))
+		    ti->type->iterate_devices(ti, func, data))
 			return true;
         }
 
@@ -1468,13 +1468,13 @@ bool dm_table_has_no_data_devices(struct
 	return true;
 }
 
-static int device_is_zoned_model(struct dm_target *ti, struct dm_dev *dev,
-				 sector_t start, sector_t len, void *data)
+static int device_not_zoned_model(struct dm_target *ti, struct dm_dev *dev,
+				  sector_t start, sector_t len, void *data)
 {
 	struct request_queue *q = bdev_get_queue(dev->bdev);
 	enum blk_zoned_model *zoned_model = data;
 
-	return q && blk_queue_zoned_model(q) == *zoned_model;
+	return !q || blk_queue_zoned_model(q) != *zoned_model;
 }
 
 static bool dm_table_supports_zoned_model(struct dm_table *t,
@@ -1491,37 +1491,20 @@ static bool dm_table_supports_zoned_mode
 			return false;
 
 		if (!ti->type->iterate_devices ||
-		    !ti->type->iterate_devices(ti, device_is_zoned_model, &zoned_model))
+		    ti->type->iterate_devices(ti, device_not_zoned_model, &zoned_model))
 			return false;
 	}
 
 	return true;
 }
 
-static int device_matches_zone_sectors(struct dm_target *ti, struct dm_dev *dev,
-				       sector_t start, sector_t len, void *data)
+static int device_not_matches_zone_sectors(struct dm_target *ti, struct dm_dev *dev,
+					   sector_t start, sector_t len, void *data)
 {
 	struct request_queue *q = bdev_get_queue(dev->bdev);
 	unsigned int *zone_sectors = data;
 
-	return q && blk_queue_zone_sectors(q) == *zone_sectors;
-}
-
-static bool dm_table_matches_zone_sectors(struct dm_table *t,
-					  unsigned int zone_sectors)
-{
-	struct dm_target *ti;
-	unsigned i;
-
-	for (i = 0; i < dm_table_get_num_targets(t); i++) {
-		ti = dm_table_get_target(t, i);
-
-		if (!ti->type->iterate_devices ||
-		    !ti->type->iterate_devices(ti, device_matches_zone_sectors, &zone_sectors))
-			return false;
-	}
-
-	return true;
+	return !q || blk_queue_zone_sectors(q) != *zone_sectors;
 }
 
 static int validate_hardware_zoned_model(struct dm_table *table,
@@ -1541,7 +1524,7 @@ static int validate_hardware_zoned_model
 	if (!zone_sectors || !is_power_of_2(zone_sectors))
 		return -EINVAL;
 
-	if (!dm_table_matches_zone_sectors(table, zone_sectors)) {
+	if (dm_table_any_dev_attr(table, device_not_matches_zone_sectors, &zone_sectors)) {
 		DMERR("%s: zone sectors is not consistent across all devices",
 		      dm_device_name(table->md));
 		return -EINVAL;
@@ -1766,7 +1749,7 @@ static int device_is_partial_completion(
 
 static bool dm_table_does_not_support_partial_completion(struct dm_table *t)
 {
-	return !dm_table_any_dev_attr(t, device_is_partial_completion);
+	return !dm_table_any_dev_attr(t, device_is_partial_completion, NULL);
 }
 
 static int device_not_write_same_capable(struct dm_target *ti, struct dm_dev *dev,
@@ -1929,11 +1912,11 @@ void dm_table_set_restrictions(struct dm
 	else
 		blk_queue_flag_clear(QUEUE_FLAG_DAX, q);
 
-	if (dm_table_any_dev_attr(t, device_dax_write_cache_enabled))
+	if (dm_table_any_dev_attr(t, device_dax_write_cache_enabled, NULL))
 		dax_write_cache(t->md->dax_dev, true);
 
 	/* Ensure that all underlying devices are non-rotational. */
-	if (dm_table_any_dev_attr(t, device_is_rotational))
+	if (dm_table_any_dev_attr(t, device_is_rotational, NULL))
 		blk_queue_flag_clear(QUEUE_FLAG_NONROT, q);
 	else
 		blk_queue_flag_set(QUEUE_FLAG_NONROT, q);
@@ -1943,7 +1926,7 @@ void dm_table_set_restrictions(struct dm
 	if (!dm_table_supports_write_zeroes(t))
 		q->limits.max_write_zeroes_sectors = 0;
 
-	if (dm_table_any_dev_attr(t, queue_no_sg_merge))
+	if (dm_table_any_dev_attr(t, queue_no_sg_merge, NULL))
 		blk_queue_flag_set(QUEUE_FLAG_NO_SG_MERGE, q);
 	else
 		blk_queue_flag_clear(QUEUE_FLAG_NO_SG_MERGE, q);
@@ -1957,7 +1940,7 @@ void dm_table_set_restrictions(struct dm
 	 * them as well.  Only targets that support iterate_devices are considered:
 	 * don't want error, zero, etc to require stable pages.
 	 */
-	if (dm_table_any_dev_attr(t, device_requires_stable_pages))
+	if (dm_table_any_dev_attr(t, device_requires_stable_pages, NULL))
 		q->backing_dev_info->capabilities |= BDI_CAP_STABLE_WRITES;
 	else
 		q->backing_dev_info->capabilities &= ~BDI_CAP_STABLE_WRITES;
@@ -1968,7 +1951,8 @@ void dm_table_set_restrictions(struct dm
 	 * Clear QUEUE_FLAG_ADD_RANDOM if any underlying device does not
 	 * have it set.
 	 */
-	if (blk_queue_add_random(q) && dm_table_any_dev_attr(t, device_is_not_random))
+	if (blk_queue_add_random(q) &&
+	    dm_table_any_dev_attr(t, device_is_not_random, NULL))
 		blk_queue_flag_clear(QUEUE_FLAG_ADD_RANDOM, q);
 }
 


