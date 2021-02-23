Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D20EA3227DC
	for <lists+stable@lfdr.de>; Tue, 23 Feb 2021 10:33:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231274AbhBWJbd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Feb 2021 04:31:33 -0500
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:53574 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231688AbhBWJ3n (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Feb 2021 04:29:43 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=jefflexu@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0UPLlpEN_1614072540;
Received: from localhost(mailfrom:jefflexu@linux.alibaba.com fp:SMTPD_---0UPLlpEN_1614072540)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 23 Feb 2021 17:29:01 +0800
From:   Jeffle Xu <jefflexu@linux.alibaba.com>
To:     gregkh@linuxfoundation.org, sashal@kernel.org
Cc:     stable@vger.kernel.org, joseph.qi@linux.alibaba.com,
        jefflexu@linux.alibaba.com, hare@suse.com
Subject: [PATCH v2 4.19 1/6] Revert "zram: close udev startup race condition as default groups"
Date:   Tue, 23 Feb 2021 17:28:54 +0800
Message-Id: <20210223092859.17033-2-jefflexu@linux.alibaba.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210223092859.17033-1-jefflexu@linux.alibaba.com>
References: <20210223092859.17033-1-jefflexu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit 9e07f4e243791e00a4086ad86e573705cf7b2c65.

The original commit is actually a "merged" fix of [1] and [2], as
described in [3]. Since now we have more fixes that rely on [1], revert
this commit first, and then get the original [1] and [2] merged.

[1] fef912bf860e, block: genhd: add 'groups' argument to device_add_disk
[2] 98af4d4df889, zram: register default groups with device_add_disk()
[3] https://www.spinics.net/lists/stable/msg442196.html

Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
---
 drivers/block/zram/zram_drv.c | 26 ++++++++++++++++++++------
 1 file changed, 20 insertions(+), 6 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 52850c10165e..dfc53619dcdd 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -1644,11 +1644,6 @@ static const struct attribute_group zram_disk_attr_group = {
 	.attrs = zram_disk_attrs,
 };
 
-static const struct attribute_group *zram_disk_attr_groups[] = {
-	&zram_disk_attr_group,
-	NULL,
-};
-
 /*
  * Allocate and initialize new zram device. the function returns
  * '>= 0' device_id upon success, and negative value otherwise.
@@ -1729,15 +1724,24 @@ static int zram_add(void)
 
 	zram->disk->queue->backing_dev_info->capabilities |=
 			(BDI_CAP_STABLE_WRITES | BDI_CAP_SYNCHRONOUS_IO);
-	disk_to_dev(zram->disk)->groups = zram_disk_attr_groups;
 	add_disk(zram->disk);
 
+	ret = sysfs_create_group(&disk_to_dev(zram->disk)->kobj,
+				&zram_disk_attr_group);
+	if (ret < 0) {
+		pr_err("Error creating sysfs group for device %d\n",
+				device_id);
+		goto out_free_disk;
+	}
 	strlcpy(zram->compressor, default_compressor, sizeof(zram->compressor));
 
 	zram_debugfs_register(zram);
 	pr_info("Added device: %s\n", zram->disk->disk_name);
 	return device_id;
 
+out_free_disk:
+	del_gendisk(zram->disk);
+	put_disk(zram->disk);
 out_free_queue:
 	blk_cleanup_queue(queue);
 out_free_idr:
@@ -1766,6 +1770,16 @@ static int zram_remove(struct zram *zram)
 	mutex_unlock(&bdev->bd_mutex);
 
 	zram_debugfs_unregister(zram);
+	/*
+	 * Remove sysfs first, so no one will perform a disksize
+	 * store while we destroy the devices. This also helps during
+	 * hot_remove -- zram_reset_device() is the last holder of
+	 * ->init_lock, no later/concurrent disksize_store() or any
+	 * other sysfs handlers are possible.
+	 */
+	sysfs_remove_group(&disk_to_dev(zram->disk)->kobj,
+			&zram_disk_attr_group);
+
 	/* Make sure all the pending I/O are finished */
 	fsync_bdev(bdev);
 	zram_reset_device(zram);
-- 
2.27.0

