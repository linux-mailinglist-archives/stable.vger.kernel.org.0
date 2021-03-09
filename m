Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 618C0331DA5
	for <lists+stable@lfdr.de>; Tue,  9 Mar 2021 04:41:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229497AbhCIDka (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Mar 2021 22:40:30 -0500
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:37406 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229901AbhCIDkI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Mar 2021 22:40:08 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=jefflexu@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0UR.n5Ic_1615261206;
Received: from localhost(mailfrom:jefflexu@linux.alibaba.com fp:SMTPD_---0UR.n5Ic_1615261206)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 09 Mar 2021 11:40:06 +0800
From:   Jeffle Xu <jefflexu@linux.alibaba.com>
To:     snitzer@redhat.com, gregkh@linuxfoundation.org, sashal@kernel.org
Cc:     stable@vger.kernel.org, jefflexu@linux.alibaba.com
Subject: [PATCH v2 5.4 2/3] dm table: fix DAX iterate_devices based device capability checks
Date:   Tue,  9 Mar 2021 11:40:02 +0800
Message-Id: <20210309034003.117541-3-jefflexu@linux.alibaba.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210309034003.117541-1-jefflexu@linux.alibaba.com>
References: <20210309034003.117541-1-jefflexu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 5b0fab508992c2e120971da658ce80027acbc405 upstream.

Fix dm_table_supports_dax() and invert logic of both
iterate_devices_callout_fn so that all devices' DAX capabilities are
properly checked.

Fixes: 545ed20e6df6 ("dm: add infrastructure for DAX support")
Cc: stable@vger.kernel.org
Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-table.c | 37 ++++++++++---------------------------
 drivers/md/dm.c       |  2 +-
 drivers/md/dm.h       |  2 +-
 3 files changed, 12 insertions(+), 29 deletions(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index c470e174e686..07530f2aa027 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -888,24 +888,24 @@ void dm_table_set_type(struct dm_table *t, enum dm_queue_mode type)
 EXPORT_SYMBOL_GPL(dm_table_set_type);
 
 /* validate the dax capability of the target device span */
-int device_supports_dax(struct dm_target *ti, struct dm_dev *dev,
+int device_not_dax_capable(struct dm_target *ti, struct dm_dev *dev,
 			sector_t start, sector_t len, void *data)
 {
 	int blocksize = *(int *) data, id;
 	bool rc;
 
 	id = dax_read_lock();
-	rc = dax_supported(dev->dax_dev, dev->bdev, blocksize, start, len);
+	rc = !dax_supported(dev->dax_dev, dev->bdev, blocksize, start, len);
 	dax_read_unlock(id);
 
 	return rc;
 }
 
 /* Check devices support synchronous DAX */
-static int device_dax_synchronous(struct dm_target *ti, struct dm_dev *dev,
-				  sector_t start, sector_t len, void *data)
+static int device_not_dax_synchronous_capable(struct dm_target *ti, struct dm_dev *dev,
+					      sector_t start, sector_t len, void *data)
 {
-	return dev->dax_dev && dax_synchronous(dev->dax_dev);
+	return !dev->dax_dev || !dax_synchronous(dev->dax_dev);
 }
 
 bool dm_table_supports_dax(struct dm_table *t,
@@ -922,7 +922,7 @@ bool dm_table_supports_dax(struct dm_table *t,
 			return false;
 
 		if (!ti->type->iterate_devices ||
-		    !ti->type->iterate_devices(ti, iterate_fn, blocksize))
+		    ti->type->iterate_devices(ti, iterate_fn, blocksize))
 			return false;
 	}
 
@@ -996,7 +996,7 @@ static int dm_table_determine_type(struct dm_table *t)
 verify_bio_based:
 		/* We must use this table as bio-based */
 		t->type = DM_TYPE_BIO_BASED;
-		if (dm_table_supports_dax(t, device_supports_dax, &page_size) ||
+		if (dm_table_supports_dax(t, device_not_dax_capable, &page_size) ||
 		    (list_empty(devices) && live_md_type == DM_TYPE_DAX_BIO_BASED)) {
 			t->type = DM_TYPE_DAX_BIO_BASED;
 		} else {
@@ -1715,23 +1715,6 @@ static int device_dax_write_cache_enabled(struct dm_target *ti,
 	return false;
 }
 
-static int dm_table_supports_dax_write_cache(struct dm_table *t)
-{
-	struct dm_target *ti;
-	unsigned i;
-
-	for (i = 0; i < dm_table_get_num_targets(t); i++) {
-		ti = dm_table_get_target(t, i);
-
-		if (ti->type->iterate_devices &&
-		    ti->type->iterate_devices(ti,
-				device_dax_write_cache_enabled, NULL))
-			return true;
-	}
-
-	return false;
-}
-
 static int device_is_rotational(struct dm_target *ti, struct dm_dev *dev,
 				sector_t start, sector_t len, void *data)
 {
@@ -1918,15 +1901,15 @@ void dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
 	}
 	blk_queue_write_cache(q, wc, fua);
 
-	if (dm_table_supports_dax(t, device_supports_dax, &page_size)) {
+	if (dm_table_supports_dax(t, device_not_dax_capable, &page_size)) {
 		blk_queue_flag_set(QUEUE_FLAG_DAX, q);
-		if (dm_table_supports_dax(t, device_dax_synchronous, NULL))
+		if (dm_table_supports_dax(t, device_not_dax_synchronous_capable, NULL))
 			set_dax_synchronous(t->md->dax_dev);
 	}
 	else
 		blk_queue_flag_clear(QUEUE_FLAG_DAX, q);
 
-	if (dm_table_supports_dax_write_cache(t))
+	if (dm_table_any_dev_attr(t, device_dax_write_cache_enabled))
 		dax_write_cache(t->md->dax_dev, true);
 
 	/* Ensure that all underlying devices are non-rotational. */
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index de32f8553735..530c0fe14229 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1139,7 +1139,7 @@ static bool dm_dax_supported(struct dax_device *dax_dev, struct block_device *bd
 	if (!map)
 		goto out;
 
-	ret = dm_table_supports_dax(map, device_supports_dax, &blocksize);
+	ret = dm_table_supports_dax(map, device_not_dax_capable, &blocksize);
 
 out:
 	dm_put_live_table(md, srcu_idx);
diff --git a/drivers/md/dm.h b/drivers/md/dm.h
index d7c4f6606b5f..9fbf87e04019 100644
--- a/drivers/md/dm.h
+++ b/drivers/md/dm.h
@@ -74,7 +74,7 @@ void dm_table_free_md_mempools(struct dm_table *t);
 struct dm_md_mempools *dm_table_get_md_mempools(struct dm_table *t);
 bool dm_table_supports_dax(struct dm_table *t, iterate_devices_callout_fn fn,
 			   int *blocksize);
-int device_supports_dax(struct dm_target *ti, struct dm_dev *dev,
+int device_not_dax_capable(struct dm_target *ti, struct dm_dev *dev,
 			   sector_t start, sector_t len, void *data);
 
 void dm_lock_md_type(struct mapped_device *md);
-- 
2.27.0

