Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67DF7497380
	for <lists+stable@lfdr.de>; Sun, 23 Jan 2022 18:11:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236887AbiAWRLi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Jan 2022 12:11:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239158AbiAWRLe (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Jan 2022 12:11:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91DA3C06173B
        for <stable@vger.kernel.org>; Sun, 23 Jan 2022 09:11:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 29DBE60F9F
        for <stable@vger.kernel.org>; Sun, 23 Jan 2022 17:11:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BBFFC340E5;
        Sun, 23 Jan 2022 17:11:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642957893;
        bh=EQURNDjdRwOEqwhW4q8yOxlvUDBSuTkYIKRdkC3IDws=;
        h=Subject:To:Cc:From:Date:From;
        b=ICu+lFGTLN8QG1ukDEovcJ6Kqd4YzcTIAiu/P3rgexgXS4S6nmhAgYYpdByM47Xlx
         ZrVtLl5y/f5YI/ebF3mYEq0SGW3q+11M5MoMgm9A8EBiRnnmwvkbmt3JM/PAl96bEY
         JSHMDpc9ZeqchrG4zYvovO1tAxVnNkcoUiPFUBJI=
Subject: FAILED: patch "[PATCH] btrfs: zoned: cache reported zone during mount" failed to apply to 5.15-stable tree
To:     naohiro.aota@wdc.com, dsterba@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 23 Jan 2022 18:11:30 +0100
Message-ID: <1642957890177197@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 16beac87e95e2fb278b552397c8260637f8a63f7 Mon Sep 17 00:00:00 2001
From: Naohiro Aota <naohiro.aota@wdc.com>
Date: Thu, 11 Nov 2021 14:14:38 +0900
Subject: [PATCH] btrfs: zoned: cache reported zone during mount

When mounting a device, we are reporting the zones twice: once for
checking the zone attributes in btrfs_get_dev_zone_info and once for
loading block groups' zone info in
btrfs_load_block_group_zone_info(). With a lot of block groups, that
leads to a lot of REPORT ZONE commands and slows down the mount
process.

This patch introduces a zone info cache in struct
btrfs_zoned_device_info. The cache is populated while in
btrfs_get_dev_zone_info() and used for
btrfs_load_block_group_zone_info() to reduce the number of REPORT ZONE
commands. The zone cache is then released after loading the block
groups, as it will not be much effective during the run time.

Benchmark: Mount an HDD with 57,007 block groups
Before patch: 171.368 seconds
After patch: 64.064 seconds

While it still takes a minute due to the slowness of loading all the
block groups, the patch reduces the mount time by 1/3.

Link: https://lore.kernel.org/linux-btrfs/CAHQ7scUiLtcTqZOMMY5kbWUBOhGRwKo6J6wYPT5WY+C=cD49nQ@mail.gmail.com/
Fixes: 5b316468983d ("btrfs: get zone information of zoned block devices")
CC: stable@vger.kernel.org
Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index 82769f1c17ee..66fa61cb3f23 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -322,7 +322,7 @@ static int btrfs_init_dev_replace_tgtdev(struct btrfs_fs_info *fs_info,
 	set_blocksize(device->bdev, BTRFS_BDEV_BLOCKSIZE);
 	device->fs_devices = fs_info->fs_devices;
 
-	ret = btrfs_get_dev_zone_info(device);
+	ret = btrfs_get_dev_zone_info(device, false);
 	if (ret)
 		goto error;
 
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 6408948b3e2c..67533b13e1eb 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3570,6 +3570,8 @@ int __cold open_ctree(struct super_block *sb, struct btrfs_fs_devices *fs_device
 		goto fail_sysfs;
 	}
 
+	btrfs_free_zone_cache(fs_info);
+
 	if (!sb_rdonly(sb) && fs_info->fs_devices->missing_devices &&
 	    !btrfs_check_rw_degradable(fs_info, NULL)) {
 		btrfs_warn(fs_info,
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 53753e04af14..cafd490da072 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2669,7 +2669,7 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
 	device->fs_info = fs_info;
 	device->bdev = bdev;
 
-	ret = btrfs_get_dev_zone_info(device);
+	ret = btrfs_get_dev_zone_info(device, false);
 	if (ret)
 		goto error_free_device;
 
diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 678a29469511..b06059a5db2a 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -5,6 +5,7 @@
 #include <linux/blkdev.h>
 #include <linux/sched/mm.h>
 #include <linux/atomic.h>
+#include <linux/vmalloc.h>
 #include "ctree.h"
 #include "volumes.h"
 #include "zoned.h"
@@ -213,6 +214,8 @@ static int emulate_report_zones(struct btrfs_device *device, u64 pos,
 static int btrfs_get_dev_zones(struct btrfs_device *device, u64 pos,
 			       struct blk_zone *zones, unsigned int *nr_zones)
 {
+	struct btrfs_zoned_device_info *zinfo = device->zone_info;
+	u32 zno;
 	int ret;
 
 	if (!*nr_zones)
@@ -224,6 +227,34 @@ static int btrfs_get_dev_zones(struct btrfs_device *device, u64 pos,
 		return 0;
 	}
 
+	/* Check cache */
+	if (zinfo->zone_cache) {
+		unsigned int i;
+
+		ASSERT(IS_ALIGNED(pos, zinfo->zone_size));
+		zno = pos >> zinfo->zone_size_shift;
+		/*
+		 * We cannot report zones beyond the zone end. So, it is OK to
+		 * cap *nr_zones to at the end.
+		 */
+		*nr_zones = min_t(u32, *nr_zones, zinfo->nr_zones - zno);
+
+		for (i = 0; i < *nr_zones; i++) {
+			struct blk_zone *zone_info;
+
+			zone_info = &zinfo->zone_cache[zno + i];
+			if (!zone_info->len)
+				break;
+		}
+
+		if (i == *nr_zones) {
+			/* Cache hit on all the zones */
+			memcpy(zones, zinfo->zone_cache + zno,
+			       sizeof(*zinfo->zone_cache) * *nr_zones);
+			return 0;
+		}
+	}
+
 	ret = blkdev_report_zones(device->bdev, pos >> SECTOR_SHIFT, *nr_zones,
 				  copy_zone_info_cb, zones);
 	if (ret < 0) {
@@ -237,6 +268,11 @@ static int btrfs_get_dev_zones(struct btrfs_device *device, u64 pos,
 	if (!ret)
 		return -EIO;
 
+	/* Populate cache */
+	if (zinfo->zone_cache)
+		memcpy(zinfo->zone_cache + zno, zones,
+		       sizeof(*zinfo->zone_cache) * *nr_zones);
+
 	return 0;
 }
 
@@ -300,7 +336,7 @@ int btrfs_get_dev_zone_info_all_devices(struct btrfs_fs_info *fs_info)
 		if (!device->bdev)
 			continue;
 
-		ret = btrfs_get_dev_zone_info(device);
+		ret = btrfs_get_dev_zone_info(device, true);
 		if (ret)
 			break;
 	}
@@ -309,7 +345,7 @@ int btrfs_get_dev_zone_info_all_devices(struct btrfs_fs_info *fs_info)
 	return ret;
 }
 
-int btrfs_get_dev_zone_info(struct btrfs_device *device)
+int btrfs_get_dev_zone_info(struct btrfs_device *device, bool populate_cache)
 {
 	struct btrfs_fs_info *fs_info = device->fs_info;
 	struct btrfs_zoned_device_info *zone_info = NULL;
@@ -339,6 +375,8 @@ int btrfs_get_dev_zone_info(struct btrfs_device *device)
 	if (!zone_info)
 		return -ENOMEM;
 
+	device->zone_info = zone_info;
+
 	if (!bdev_is_zoned(bdev)) {
 		if (!fs_info->zone_size) {
 			ret = calculate_emulated_zone_size(fs_info);
@@ -407,6 +445,23 @@ int btrfs_get_dev_zone_info(struct btrfs_device *device)
 		goto out;
 	}
 
+	/*
+	 * Enable zone cache only for a zoned device. On a non-zoned device, we
+	 * fill the zone info with emulated CONVENTIONAL zones, so no need to
+	 * use the cache.
+	 */
+	if (populate_cache && bdev_is_zoned(device->bdev)) {
+		zone_info->zone_cache = vzalloc(sizeof(struct blk_zone) *
+						zone_info->nr_zones);
+		if (!zone_info->zone_cache) {
+			btrfs_err_in_rcu(device->fs_info,
+				"zoned: failed to allocate zone cache for %s",
+				rcu_str_deref(device->name));
+			ret = -ENOMEM;
+			goto out;
+		}
+	}
+
 	/* Get zones type */
 	nactive = 0;
 	while (sector < nr_sectors) {
@@ -505,8 +560,6 @@ int btrfs_get_dev_zone_info(struct btrfs_device *device)
 
 	kfree(zones);
 
-	device->zone_info = zone_info;
-
 	switch (bdev_zoned_model(bdev)) {
 	case BLK_ZONED_HM:
 		model = "host-managed zoned";
@@ -539,11 +592,7 @@ int btrfs_get_dev_zone_info(struct btrfs_device *device)
 out:
 	kfree(zones);
 out_free_zone_info:
-	bitmap_free(zone_info->active_zones);
-	bitmap_free(zone_info->empty_zones);
-	bitmap_free(zone_info->seq_zones);
-	kfree(zone_info);
-	device->zone_info = NULL;
+	btrfs_destroy_dev_zone_info(device);
 
 	return ret;
 }
@@ -558,6 +607,7 @@ void btrfs_destroy_dev_zone_info(struct btrfs_device *device)
 	bitmap_free(zone_info->active_zones);
 	bitmap_free(zone_info->seq_zones);
 	bitmap_free(zone_info->empty_zones);
+	vfree(zone_info->zone_cache);
 	kfree(zone_info);
 	device->zone_info = NULL;
 }
@@ -1975,3 +2025,21 @@ void btrfs_clear_data_reloc_bg(struct btrfs_block_group *bg)
 		fs_info->data_reloc_bg = 0;
 	spin_unlock(&fs_info->relocation_bg_lock);
 }
+
+void btrfs_free_zone_cache(struct btrfs_fs_info *fs_info)
+{
+	struct btrfs_fs_devices *fs_devices = fs_info->fs_devices;
+	struct btrfs_device *device;
+
+	if (!btrfs_is_zoned(fs_info))
+		return;
+
+	mutex_lock(&fs_devices->device_list_mutex);
+	list_for_each_entry(device, &fs_devices->devices, dev_list) {
+		if (device->zone_info) {
+			vfree(device->zone_info->zone_cache);
+			device->zone_info->zone_cache = NULL;
+		}
+	}
+	mutex_unlock(&fs_devices->device_list_mutex);
+}
diff --git a/fs/btrfs/zoned.h b/fs/btrfs/zoned.h
index e53ab7b96437..4344f4818389 100644
--- a/fs/btrfs/zoned.h
+++ b/fs/btrfs/zoned.h
@@ -28,6 +28,7 @@ struct btrfs_zoned_device_info {
 	unsigned long *seq_zones;
 	unsigned long *empty_zones;
 	unsigned long *active_zones;
+	struct blk_zone *zone_cache;
 	struct blk_zone sb_zones[2 * BTRFS_SUPER_MIRROR_MAX];
 };
 
@@ -35,7 +36,7 @@ struct btrfs_zoned_device_info {
 int btrfs_get_dev_zone(struct btrfs_device *device, u64 pos,
 		       struct blk_zone *zone);
 int btrfs_get_dev_zone_info_all_devices(struct btrfs_fs_info *fs_info);
-int btrfs_get_dev_zone_info(struct btrfs_device *device);
+int btrfs_get_dev_zone_info(struct btrfs_device *device, bool populate_cache);
 void btrfs_destroy_dev_zone_info(struct btrfs_device *device);
 int btrfs_check_zoned_mode(struct btrfs_fs_info *fs_info);
 int btrfs_check_mountopts_zoned(struct btrfs_fs_info *info);
@@ -76,6 +77,7 @@ bool btrfs_can_activate_zone(struct btrfs_fs_devices *fs_devices,
 void btrfs_zone_finish_endio(struct btrfs_fs_info *fs_info, u64 logical,
 			     u64 length);
 void btrfs_clear_data_reloc_bg(struct btrfs_block_group *bg);
+void btrfs_free_zone_cache(struct btrfs_fs_info *fs_info);
 #else /* CONFIG_BLK_DEV_ZONED */
 static inline int btrfs_get_dev_zone(struct btrfs_device *device, u64 pos,
 				     struct blk_zone *zone)
@@ -88,7 +90,8 @@ static inline int btrfs_get_dev_zone_info_all_devices(struct btrfs_fs_info *fs_i
 	return 0;
 }
 
-static inline int btrfs_get_dev_zone_info(struct btrfs_device *device)
+static inline int btrfs_get_dev_zone_info(struct btrfs_device *device,
+					  bool populate_cache)
 {
 	return 0;
 }
@@ -232,6 +235,7 @@ static inline void btrfs_zone_finish_endio(struct btrfs_fs_info *fs_info,
 
 static inline void btrfs_clear_data_reloc_bg(struct btrfs_block_group *bg) { }
 
+static inline void btrfs_free_zone_cache(struct btrfs_fs_info *fs_info) { }
 #endif
 
 static inline bool btrfs_dev_is_sequential(struct btrfs_device *device, u64 pos)

