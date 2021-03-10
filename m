Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C701333E47
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 14:36:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233524AbhCJNZv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 08:25:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:46756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233240AbhCJNZJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Mar 2021 08:25:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2542A64FE8;
        Wed, 10 Mar 2021 13:25:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615382709;
        bh=8UEULThda0zb1dpOftKPyVveN8J2uffEVc1xGgEQsiM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WX+NL1MoP17ntJEnG+X9MXFs7cWNNzoQ7gVwzhRim3InCbnfQzhieYPIl6wJi64b9
         zrGEprMzipYRPyuMQwbYFKOc9ldfi5wv1uKVAxjktKyN6Mugygek3DHWZDrZ1zpf8d
         hqIhWAMOOBHPMjwYwt/UJmnoQnmJWXkqgkcqI6AM=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeffle Xu <jefflexu@linux.alibaba.com>
Subject: [PATCH 4.19 10/39] Revert "zram: close udev startup race condition as default groups"
Date:   Wed, 10 Mar 2021 14:24:18 +0100
Message-Id: <20210310132320.053170237@linuxfoundation.org>
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

This reverts commit 9e07f4e243791e00a4086ad86e573705cf7b2c65.

The original commit is actually a "merged" fix of [1] and [2], as
described in [3]. Since now we have more fixes that rely on [1], revert
this commit first, and then get the original [1] and [2] merged.

[1] fef912bf860e, block: genhd: add 'groups' argument to device_add_disk
[2] 98af4d4df889, zram: register default groups with device_add_disk()
[3] https://www.spinics.net/lists/stable/msg442196.html

Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/zram/zram_drv.c |   26 ++++++++++++++++++++------
 1 file changed, 20 insertions(+), 6 deletions(-)

--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -1644,11 +1644,6 @@ static const struct attribute_group zram
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
@@ -1766,6 +1770,16 @@ static int zram_remove(struct zram *zram
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


