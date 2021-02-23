Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5E9B3227E2
	for <lists+stable@lfdr.de>; Tue, 23 Feb 2021 10:33:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232133AbhBWJcI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Feb 2021 04:32:08 -0500
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:51586 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232342AbhBWJ3t (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Feb 2021 04:29:49 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=jefflexu@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0UPMP7ZV_1614072545;
Received: from localhost(mailfrom:jefflexu@linux.alibaba.com fp:SMTPD_---0UPMP7ZV_1614072545)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 23 Feb 2021 17:29:05 +0800
From:   Jeffle Xu <jefflexu@linux.alibaba.com>
To:     gregkh@linuxfoundation.org, sashal@kernel.org
Cc:     stable@vger.kernel.org, joseph.qi@linux.alibaba.com,
        jefflexu@linux.alibaba.com, hare@suse.com
Subject: [PATCH v2 4.19 5/6] zram: register default groups with device_add_disk()
Date:   Tue, 23 Feb 2021 17:28:58 +0800
Message-Id: <20210223092859.17033-6-jefflexu@linux.alibaba.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210223092859.17033-1-jefflexu@linux.alibaba.com>
References: <20210223092859.17033-1-jefflexu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hannes Reinecke <hare@suse.de>

commit 98af4d4df889dcea3bc0ce6b8a04759658ba8826 upstream.

Register default sysfs groups during device_add_disk() to avoid a
race condition with udev during startup.

Signed-off-by: Hannes Reinecke <hare@suse.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Bart Van Assche <bart.vanassche@wdc.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
---
 drivers/block/zram/zram_drv.c | 28 +++++++---------------------
 1 file changed, 7 insertions(+), 21 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index dfc53619dcdd..b32da655ec30 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -1644,6 +1644,11 @@ static const struct attribute_group zram_disk_attr_group = {
 	.attrs = zram_disk_attrs,
 };
 
+static const struct attribute_group *zram_disk_attr_groups[] = {
+	&zram_disk_attr_group,
+	NULL,
+};
+
 /*
  * Allocate and initialize new zram device. the function returns
  * '>= 0' device_id upon success, and negative value otherwise.
@@ -1724,24 +1729,14 @@ static int zram_add(void)
 
 	zram->disk->queue->backing_dev_info->capabilities |=
 			(BDI_CAP_STABLE_WRITES | BDI_CAP_SYNCHRONOUS_IO);
-	add_disk(zram->disk);
-
-	ret = sysfs_create_group(&disk_to_dev(zram->disk)->kobj,
-				&zram_disk_attr_group);
-	if (ret < 0) {
-		pr_err("Error creating sysfs group for device %d\n",
-				device_id);
-		goto out_free_disk;
-	}
+	device_add_disk(NULL, zram->disk, zram_disk_attr_groups);
+
 	strlcpy(zram->compressor, default_compressor, sizeof(zram->compressor));
 
 	zram_debugfs_register(zram);
 	pr_info("Added device: %s\n", zram->disk->disk_name);
 	return device_id;
 
-out_free_disk:
-	del_gendisk(zram->disk);
-	put_disk(zram->disk);
 out_free_queue:
 	blk_cleanup_queue(queue);
 out_free_idr:
@@ -1770,15 +1765,6 @@ static int zram_remove(struct zram *zram)
 	mutex_unlock(&bdev->bd_mutex);
 
 	zram_debugfs_unregister(zram);
-	/*
-	 * Remove sysfs first, so no one will perform a disksize
-	 * store while we destroy the devices. This also helps during
-	 * hot_remove -- zram_reset_device() is the last holder of
-	 * ->init_lock, no later/concurrent disksize_store() or any
-	 * other sysfs handlers are possible.
-	 */
-	sysfs_remove_group(&disk_to_dev(zram->disk)->kobj,
-			&zram_disk_attr_group);
 
 	/* Make sure all the pending I/O are finished */
 	fsync_bdev(bdev);
-- 
2.27.0

