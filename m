Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2F6632E28B
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 07:52:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229458AbhCEGw5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 01:52:57 -0500
Received: from out30-45.freemail.mail.aliyun.com ([115.124.30.45]:45002 "EHLO
        out30-45.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229469AbhCEGw4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Mar 2021 01:52:56 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R791e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=jefflexu@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0UQWlLs-_1614927174;
Received: from localhost(mailfrom:jefflexu@linux.alibaba.com fp:SMTPD_---0UQWlLs-_1614927174)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 05 Mar 2021 14:52:54 +0800
From:   Jeffle Xu <jefflexu@linux.alibaba.com>
To:     gregkh@linuxfoundation.org, sashal@kernel.org
Cc:     stable@vger.kernel.org, jefflexu@linux.alibaba.com,
        snitzer@redhat.com
Subject: [PATCH 4.14.y 3/4] dm table: fix DAX iterate_devices based device capability checks
Date:   Fri,  5 Mar 2021 14:52:49 +0800
Message-Id: <20210305065250.70340-4-jefflexu@linux.alibaba.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210305065250.70340-1-jefflexu@linux.alibaba.com>
References: <16146062492354@kroah.com>
 <20210305065250.70340-1-jefflexu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 57ba3e506c30a84b1ba1dd77ddd9f2be9d472e98 upstream.

Fix dm_table_supports_dax() and invert logic of both
iterate_devices_callout_fn so that all devices' DAX capabilities are
properly checked.

Fixes: 545ed20e6df6 ("dm: add infrastructure for DAX support")
Cc: stable@vger.kernel.org
Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
[jeffle: no dax synchronous]
---
 drivers/md/dm-table.c | 25 ++++---------------------
 1 file changed, 4 insertions(+), 21 deletions(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index a40c51459ef5..96ac87f9cb85 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -889,10 +889,10 @@ void dm_table_set_type(struct dm_table *t, enum dm_queue_mode type)
 }
 EXPORT_SYMBOL_GPL(dm_table_set_type);
 
-static int device_supports_dax(struct dm_target *ti, struct dm_dev *dev,
+static int device_not_dax_capable(struct dm_target *ti, struct dm_dev *dev,
 			       sector_t start, sector_t len, void *data)
 {
-	return bdev_dax_supported(dev->bdev, PAGE_SIZE);
+	return !bdev_dax_supported(dev->bdev, PAGE_SIZE);
 }
 
 static bool dm_table_supports_dax(struct dm_table *t)
@@ -908,7 +908,7 @@ static bool dm_table_supports_dax(struct dm_table *t)
 			return false;
 
 		if (!ti->type->iterate_devices ||
-		    !ti->type->iterate_devices(ti, device_supports_dax, NULL))
+		    ti->type->iterate_devices(ti, device_not_dax_capable, NULL))
 			return false;
 	}
 
@@ -1690,23 +1690,6 @@ static int device_dax_write_cache_enabled(struct dm_target *ti,
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
@@ -1854,7 +1837,7 @@ void dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
 	else
 		queue_flag_clear_unlocked(QUEUE_FLAG_DAX, q);
 
-	if (dm_table_supports_dax_write_cache(t))
+	if (dm_table_any_dev_attr(t, device_dax_write_cache_enabled))
 		dax_write_cache(t->md->dax_dev, true);
 
 	/* Ensure that all underlying devices are non-rotational. */
-- 
2.27.0

