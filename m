Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D4E5331D9D
	for <lists+stable@lfdr.de>; Tue,  9 Mar 2021 04:34:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229701AbhCIDdu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Mar 2021 22:33:50 -0500
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:60473 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229829AbhCIDds (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Mar 2021 22:33:48 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=alimailimapcm10staff010182156082;MF=jefflexu@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0UR.n4PD_1615260825;
Received: from localhost(mailfrom:jefflexu@linux.alibaba.com fp:SMTPD_---0UR.n4PD_1615260825)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 09 Mar 2021 11:33:46 +0800
From:   Jeffle Xu <jefflexu@linux.alibaba.com>
To:     snitzer@redhat.com, gregkh@linuxfoundation.org, sashal@kernel.org
Cc:     stable@vger.kernel.org, jefflexu@linux.alibaba.com
Subject: [PATCH v2 4.19 1/3] dm table: fix iterate_devices based device capability checks
Date:   Tue,  9 Mar 2021 11:33:42 +0800
Message-Id: <20210309033344.111111-2-jefflexu@linux.alibaba.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210309033344.111111-1-jefflexu@linux.alibaba.com>
References: <20210309033344.111111-1-jefflexu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit a4c8dd9c2d0987cf542a2a0c42684c9c6d78a04e upstream.

According to the definition of dm_iterate_devices_fn:
 * This function must iterate through each section of device used by the
 * target until it encounters a non-zero return code, which it then returns.
 * Returns zero if no callout returned non-zero.

For some target type (e.g. dm-stripe), one call of iterate_devices() may
iterate multiple underlying devices internally, in which case a non-zero
return code returned by iterate_devices_callout_fn will stop the iteration
in advance. No iterate_devices_callout_fn should return non-zero unless
device iteration should stop.

Rename dm_table_requires_stable_pages() to dm_table_any_dev_attr() and
elevate it for reuse to stop iterating (and return non-zero) on the
first device that causes iterate_devices_callout_fn to return non-zero.
Use dm_table_any_dev_attr() to properly iterate through devices.

Rename device_is_nonrot() to device_is_rotational() and invert logic
accordingly to fix improper disposition.

[jeffle: backport notes]
Also convert the no_sg_merge capability check, which is introduced by
commit 200612ec33e5 ("dm table: propagate QUEUE_FLAG_NO_SG_MERGE"), and
removed since commit 2705c93742e9 ("block: kill QUEUE_FLAG_NO_SG_MERGE")
in v5.1.

Also convert the partial completion capability check, which is
introduced by commit 22c11858e800 ("dm: introduce
DM_TYPE_NVME_BIO_BASED"), and removed since commit 9c37de297f65 ("dm:
remove special-casing of bio-based immutable singleton target on NVMe")
in v5.10.

Fixes: c3c4555edd10 ("dm table: clear add_random unless all devices have it set")
Fixes: 4693c9668fdc ("dm table: propagate non rotational flag")
Cc: stable@vger.kernel.org
Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-table.c | 115 ++++++++++++++++++++++--------------------
 1 file changed, 60 insertions(+), 55 deletions(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 916433742485..1f745d371957 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1392,6 +1392,46 @@ struct dm_target *dm_table_find_target(struct dm_table *t, sector_t sector)
 	return &t->targets[(KEYS_PER_NODE * n) + k];
 }
 
+/*
+ * type->iterate_devices() should be called when the sanity check needs to
+ * iterate and check all underlying data devices. iterate_devices() will
+ * iterate all underlying data devices until it encounters a non-zero return
+ * code, returned by whether the input iterate_devices_callout_fn, or
+ * iterate_devices() itself internally.
+ *
+ * For some target type (e.g. dm-stripe), one call of iterate_devices() may
+ * iterate multiple underlying devices internally, in which case a non-zero
+ * return code returned by iterate_devices_callout_fn will stop the iteration
+ * in advance.
+ *
+ * Cases requiring _any_ underlying device supporting some kind of attribute,
+ * should use the iteration structure like dm_table_any_dev_attr(), or call
+ * it directly. @func should handle semantics of positive examples, e.g.
+ * capable of something.
+ *
+ * Cases requiring _all_ underlying devices supporting some kind of attribute,
+ * should use the iteration structure like dm_table_supports_nowait() or
+ * dm_table_supports_discards(). Or introduce dm_table_all_devs_attr() that
+ * uses an @anti_func that handle semantics of counter examples, e.g. not
+ * capable of something. So: return !dm_table_any_dev_attr(t, anti_func);
+ */
+static bool dm_table_any_dev_attr(struct dm_table *t,
+				  iterate_devices_callout_fn func)
+{
+	struct dm_target *ti;
+	unsigned int i;
+
+	for (i = 0; i < dm_table_get_num_targets(t); i++) {
+		ti = dm_table_get_target(t, i);
+
+		if (ti->type->iterate_devices &&
+		    ti->type->iterate_devices(ti, func, NULL))
+			return true;
+        }
+
+	return false;
+}
+
 static int count_device(struct dm_target *ti, struct dm_dev *dev,
 			sector_t start, sector_t len, void *data)
 {
@@ -1708,12 +1748,12 @@ static int dm_table_supports_dax_write_cache(struct dm_table *t)
 	return false;
 }
 
-static int device_is_nonrot(struct dm_target *ti, struct dm_dev *dev,
-			    sector_t start, sector_t len, void *data)
+static int device_is_rotational(struct dm_target *ti, struct dm_dev *dev,
+				sector_t start, sector_t len, void *data)
 {
 	struct request_queue *q = bdev_get_queue(dev->bdev);
 
-	return q && blk_queue_nonrot(q);
+	return q && !blk_queue_nonrot(q);
 }
 
 static int device_is_not_random(struct dm_target *ti, struct dm_dev *dev,
@@ -1724,43 +1764,26 @@ static int device_is_not_random(struct dm_target *ti, struct dm_dev *dev,
 	return q && !blk_queue_add_random(q);
 }
 
-static int queue_supports_sg_merge(struct dm_target *ti, struct dm_dev *dev,
-				   sector_t start, sector_t len, void *data)
+static int queue_no_sg_merge(struct dm_target *ti, struct dm_dev *dev,
+			     sector_t start, sector_t len, void *data)
 {
 	struct request_queue *q = bdev_get_queue(dev->bdev);
 
-	return q && !test_bit(QUEUE_FLAG_NO_SG_MERGE, &q->queue_flags);
-}
-
-static bool dm_table_all_devices_attribute(struct dm_table *t,
-					   iterate_devices_callout_fn func)
-{
-	struct dm_target *ti;
-	unsigned i;
-
-	for (i = 0; i < dm_table_get_num_targets(t); i++) {
-		ti = dm_table_get_target(t, i);
-
-		if (!ti->type->iterate_devices ||
-		    !ti->type->iterate_devices(ti, func, NULL))
-			return false;
-	}
-
-	return true;
+	return q && test_bit(QUEUE_FLAG_NO_SG_MERGE, &q->queue_flags);
 }
 
-static int device_no_partial_completion(struct dm_target *ti, struct dm_dev *dev,
+static int device_is_partial_completion(struct dm_target *ti, struct dm_dev *dev,
 					sector_t start, sector_t len, void *data)
 {
 	char b[BDEVNAME_SIZE];
 
 	/* For now, NVMe devices are the only devices of this class */
-	return (strncmp(bdevname(dev->bdev, b), "nvme", 4) == 0);
+	return (strncmp(bdevname(dev->bdev, b), "nvme", 4) != 0);
 }
 
 static bool dm_table_does_not_support_partial_completion(struct dm_table *t)
 {
-	return dm_table_all_devices_attribute(t, device_no_partial_completion);
+	return !dm_table_any_dev_attr(t, device_is_partial_completion);
 }
 
 static int device_not_write_same_capable(struct dm_target *ti, struct dm_dev *dev,
@@ -1887,27 +1910,6 @@ static int device_requires_stable_pages(struct dm_target *ti,
 	return q && bdi_cap_stable_pages_required(q->backing_dev_info);
 }
 
-/*
- * If any underlying device requires stable pages, a table must require
- * them as well.  Only targets that support iterate_devices are considered:
- * don't want error, zero, etc to require stable pages.
- */
-static bool dm_table_requires_stable_pages(struct dm_table *t)
-{
-	struct dm_target *ti;
-	unsigned i;
-
-	for (i = 0; i < dm_table_get_num_targets(t); i++) {
-		ti = dm_table_get_target(t, i);
-
-		if (ti->type->iterate_devices &&
-		    ti->type->iterate_devices(ti, device_requires_stable_pages, NULL))
-			return true;
-	}
-
-	return false;
-}
-
 void dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
 			       struct queue_limits *limits)
 {
@@ -1948,28 +1950,31 @@ void dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
 		dax_write_cache(t->md->dax_dev, true);
 
 	/* Ensure that all underlying devices are non-rotational. */
-	if (dm_table_all_devices_attribute(t, device_is_nonrot))
-		blk_queue_flag_set(QUEUE_FLAG_NONROT, q);
-	else
+	if (dm_table_any_dev_attr(t, device_is_rotational))
 		blk_queue_flag_clear(QUEUE_FLAG_NONROT, q);
+	else
+		blk_queue_flag_set(QUEUE_FLAG_NONROT, q);
 
 	if (!dm_table_supports_write_same(t))
 		q->limits.max_write_same_sectors = 0;
 	if (!dm_table_supports_write_zeroes(t))
 		q->limits.max_write_zeroes_sectors = 0;
 
-	if (dm_table_all_devices_attribute(t, queue_supports_sg_merge))
-		blk_queue_flag_clear(QUEUE_FLAG_NO_SG_MERGE, q);
-	else
+	if (dm_table_any_dev_attr(t, queue_no_sg_merge))
 		blk_queue_flag_set(QUEUE_FLAG_NO_SG_MERGE, q);
+	else
+		blk_queue_flag_clear(QUEUE_FLAG_NO_SG_MERGE, q);
 
 	dm_table_verify_integrity(t);
 
 	/*
 	 * Some devices don't use blk_integrity but still want stable pages
 	 * because they do their own checksumming.
+	 * If any underlying device requires stable pages, a table must require
+	 * them as well.  Only targets that support iterate_devices are considered:
+	 * don't want error, zero, etc to require stable pages.
 	 */
-	if (dm_table_requires_stable_pages(t))
+	if (dm_table_any_dev_attr(t, device_requires_stable_pages))
 		q->backing_dev_info->capabilities |= BDI_CAP_STABLE_WRITES;
 	else
 		q->backing_dev_info->capabilities &= ~BDI_CAP_STABLE_WRITES;
@@ -1980,7 +1985,7 @@ void dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
 	 * Clear QUEUE_FLAG_ADD_RANDOM if any underlying device does not
 	 * have it set.
 	 */
-	if (blk_queue_add_random(q) && dm_table_all_devices_attribute(t, device_is_not_random))
+	if (blk_queue_add_random(q) && dm_table_any_dev_attr(t, device_is_not_random))
 		blk_queue_flag_clear(QUEUE_FLAG_ADD_RANDOM, q);
 }
 
-- 
2.27.0

