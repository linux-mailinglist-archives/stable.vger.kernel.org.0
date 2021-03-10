Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15185333E84
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 14:36:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233837AbhCJN0P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 08:26:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:47832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233422AbhCJNZf (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Mar 2021 08:25:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8057665004;
        Wed, 10 Mar 2021 13:25:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615382733;
        bh=/GhcZhxpE/8p2EAY/bbPYaHl0d+6gptWXp1K5B/5XlI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h1dDZ9Eoeiq3ryisMGNwysRmI1vWw0DSfWbO/eVgPb1GVcJzbBQ1VURmzwJxlJ2Yv
         xbASBoCMvxhDup+ZznE2enHNLBp6/FTFunChFN2TS2tedMoDALn6pim7Ra0UoHbvYA
         9T8NM/aocE1w1WEGaTtrdBsot+M6XbB7OkpdFA4k=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeffle Xu <jefflexu@linux.alibaba.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 4.4 5/7] dm table: fix iterate_devices based device capability checks
Date:   Wed, 10 Mar 2021 14:25:18 +0100
Message-Id: <20210310132319.358494901@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210310132319.155338551@linuxfoundation.org>
References: <20210310132319.155338551@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Jeffle Xu <jefflexu@linux.alibaba.com>

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
No stable writes. Also convert the no_sg_merge capability check,
which is introduced by commit 200612ec33e5 ("dm table: propagate
QUEUE_FLAG_NO_SG_MERGE"), and removed since commit 2705c93742e9 ("block:
kill QUEUE_FLAG_NO_SG_MERGE") in v5.1.

Fixes: c3c4555edd10 ("dm table: clear add_random unless all devices have it set")
Fixes: 4693c9668fdc ("dm table: propagate non rotational flag")
Cc: stable@vger.kernel.org
Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-table.c |   83 +++++++++++++++++++++++++++++++-------------------
 1 file changed, 53 insertions(+), 30 deletions(-)

--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1210,6 +1210,46 @@ struct dm_target *dm_table_find_target(s
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
@@ -1380,12 +1420,12 @@ static bool dm_table_discard_zeroes_data
 	return true;
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
@@ -1396,29 +1436,12 @@ static int device_is_not_random(struct d
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
-	unsigned i = 0;
-
-	while (i < dm_table_get_num_targets(t)) {
-		ti = dm_table_get_target(t, i++);
-
-		if (!ti->type->iterate_devices ||
-		    !ti->type->iterate_devices(ti, func, NULL))
-			return false;
-	}
-
-	return true;
+	return q && test_bit(QUEUE_FLAG_NO_SG_MERGE, &q->queue_flags);
 }
 
 static int device_not_write_same_capable(struct dm_target *ti, struct dm_dev *dev,
@@ -1511,18 +1534,18 @@ void dm_table_set_restrictions(struct dm
 		q->limits.discard_zeroes_data = 0;
 
 	/* Ensure that all underlying devices are non-rotational. */
-	if (dm_table_all_devices_attribute(t, device_is_nonrot))
-		queue_flag_set_unlocked(QUEUE_FLAG_NONROT, q);
-	else
+	if (dm_table_any_dev_attr(t, device_is_rotational))
 		queue_flag_clear_unlocked(QUEUE_FLAG_NONROT, q);
+	else
+		queue_flag_set_unlocked(QUEUE_FLAG_NONROT, q);
 
 	if (!dm_table_supports_write_same(t))
 		q->limits.max_write_same_sectors = 0;
 
-	if (dm_table_all_devices_attribute(t, queue_supports_sg_merge))
-		queue_flag_clear_unlocked(QUEUE_FLAG_NO_SG_MERGE, q);
-	else
+	if (dm_table_any_dev_attr(t, queue_no_sg_merge))
 		queue_flag_set_unlocked(QUEUE_FLAG_NO_SG_MERGE, q);
+	else
+		queue_flag_clear_unlocked(QUEUE_FLAG_NO_SG_MERGE, q);
 
 	dm_table_verify_integrity(t);
 
@@ -1532,7 +1555,7 @@ void dm_table_set_restrictions(struct dm
 	 * Clear QUEUE_FLAG_ADD_RANDOM if any underlying device does not
 	 * have it set.
 	 */
-	if (blk_queue_add_random(q) && dm_table_all_devices_attribute(t, device_is_not_random))
+	if (blk_queue_add_random(q) && dm_table_any_dev_attr(t, device_is_not_random))
 		queue_flag_clear_unlocked(QUEUE_FLAG_ADD_RANDOM, q);
 
 	/*


