Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECFCE3291FE
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:39:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243376AbhCAUhd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:37:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:49672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243485AbhCAUal (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:30:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CEB25650BE;
        Mon,  1 Mar 2021 18:08:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614622099;
        bh=oKQUDrIVdOI8l2ZSgiUEu1KiwmMJIlT6kVQlJUzoS8Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HQNvkLfpTBT0MBH3NOGgZcpKkEtScEnJ3qlooT7hszvtr1zSFB8hOme9fG7EXnSu0
         YDtNzNn5MqOqd2iNE4VJq7BBpylOsRAXIkToaPZP7Lz9+KJ9atNJL+2csOUro1muFw
         jHec0AK0AYGiJXfFPs42K/P8bJ3I4LCcwl71TKA0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeffle Xu <jefflexu@linux.alibaba.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 5.11 755/775] dm table: fix DAX iterate_devices based device capability checks
Date:   Mon,  1 Mar 2021 17:15:23 +0100
Message-Id: <20210301161238.630589943@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeffle Xu <jefflexu@linux.alibaba.com>

commit 5b0fab508992c2e120971da658ce80027acbc405 upstream.

Fix dm_table_supports_dax() and invert logic of both
iterate_devices_callout_fn so that all devices' DAX capabilities are
properly checked.

Fixes: 545ed20e6df6 ("dm: add infrastructure for DAX support")
Cc: stable@vger.kernel.org
Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-table.c |   37 ++++++++++---------------------------
 drivers/md/dm.c       |    2 +-
 drivers/md/dm.h       |    2 +-
 3 files changed, 12 insertions(+), 29 deletions(-)

--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -820,24 +820,24 @@ void dm_table_set_type(struct dm_table *
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
@@ -854,7 +854,7 @@ bool dm_table_supports_dax(struct dm_tab
 			return false;
 
 		if (!ti->type->iterate_devices ||
-		    !ti->type->iterate_devices(ti, iterate_fn, blocksize))
+		    ti->type->iterate_devices(ti, iterate_fn, blocksize))
 			return false;
 	}
 
@@ -925,7 +925,7 @@ static int dm_table_determine_type(struc
 verify_bio_based:
 		/* We must use this table as bio-based */
 		t->type = DM_TYPE_BIO_BASED;
-		if (dm_table_supports_dax(t, device_supports_dax, &page_size) ||
+		if (dm_table_supports_dax(t, device_not_dax_capable, &page_size) ||
 		    (list_empty(devices) && live_md_type == DM_TYPE_DAX_BIO_BASED)) {
 			t->type = DM_TYPE_DAX_BIO_BASED;
 		}
@@ -1618,23 +1618,6 @@ static int device_dax_write_cache_enable
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
@@ -1839,15 +1822,15 @@ void dm_table_set_restrictions(struct dm
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
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1148,7 +1148,7 @@ static bool dm_dax_supported(struct dax_
 	if (!map)
 		goto out;
 
-	ret = dm_table_supports_dax(map, device_supports_dax, &blocksize);
+	ret = dm_table_supports_dax(map, device_not_dax_capable, &blocksize);
 
 out:
 	dm_put_live_table(md, srcu_idx);
--- a/drivers/md/dm.h
+++ b/drivers/md/dm.h
@@ -73,7 +73,7 @@ void dm_table_free_md_mempools(struct dm
 struct dm_md_mempools *dm_table_get_md_mempools(struct dm_table *t);
 bool dm_table_supports_dax(struct dm_table *t, iterate_devices_callout_fn fn,
 			   int *blocksize);
-int device_supports_dax(struct dm_target *ti, struct dm_dev *dev,
+int device_not_dax_capable(struct dm_target *ti, struct dm_dev *dev,
 			   sector_t start, sector_t len, void *data);
 
 void dm_lock_md_type(struct mapped_device *md);


