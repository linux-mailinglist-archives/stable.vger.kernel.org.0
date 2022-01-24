Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 386E0499A8E
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:55:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1573512AbiAXVpB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:45:01 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:55524 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357782AbiAXVhQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:37:16 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3D9DE6150E;
        Mon, 24 Jan 2022 21:37:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A42CC340E7;
        Mon, 24 Jan 2022 21:37:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643060234;
        bh=B88h2m79idm4SYEPZYoS03HG4DAKQM2Ij5Q84oDfmyc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H3Da+9lGhOAKTn+KdBaCaxWg5UxZk1X2NtbuO2UKQgm5cnf7UI2YYbZRNmipKwa99
         hIOvSxfipNKF4mZoRbFmt+zCv0R7sKSci/DfGWGFbe8h0ylnvXDAJQlkWQkZO92BY9
         QYB+JR4wH0VjOsDAYObz4B82cOiFqcWEyLU78qU8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Naohiro Aota <naohiro.aota@wdc.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.16 0883/1039] btrfs: zoned: cache reported zone during mount
Date:   Mon, 24 Jan 2022 19:44:32 +0100
Message-Id: <20220124184154.976481441@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Naohiro Aota <naohiro.aota@wdc.com>

commit 16beac87e95e2fb278b552397c8260637f8a63f7 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/dev-replace.c |    2 -
 fs/btrfs/disk-io.c     |    2 +
 fs/btrfs/volumes.c     |    2 -
 fs/btrfs/zoned.c       |   86 +++++++++++++++++++++++++++++++++++++++++++------
 fs/btrfs/zoned.h       |    8 +++-
 5 files changed, 87 insertions(+), 13 deletions(-)

--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -322,7 +322,7 @@ static int btrfs_init_dev_replace_tgtdev
 	set_blocksize(device->bdev, BTRFS_BDEV_BLOCKSIZE);
 	device->fs_devices = fs_info->fs_devices;
 
-	ret = btrfs_get_dev_zone_info(device);
+	ret = btrfs_get_dev_zone_info(device, false);
 	if (ret)
 		goto error;
 
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3571,6 +3571,8 @@ int __cold open_ctree(struct super_block
 		goto fail_sysfs;
 	}
 
+	btrfs_free_zone_cache(fs_info);
+
 	if (!sb_rdonly(sb) && fs_info->fs_devices->missing_devices &&
 	    !btrfs_check_rw_degradable(fs_info, NULL)) {
 		btrfs_warn(fs_info,
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2643,7 +2643,7 @@ int btrfs_init_new_device(struct btrfs_f
 	device->fs_info = fs_info;
 	device->bdev = bdev;
 
-	ret = btrfs_get_dev_zone_info(device);
+	ret = btrfs_get_dev_zone_info(device, false);
 	if (ret)
 		goto error_free_device;
 
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
@@ -213,6 +214,8 @@ static int emulate_report_zones(struct b
 static int btrfs_get_dev_zones(struct btrfs_device *device, u64 pos,
 			       struct blk_zone *zones, unsigned int *nr_zones)
 {
+	struct btrfs_zoned_device_info *zinfo = device->zone_info;
+	u32 zno;
 	int ret;
 
 	if (!*nr_zones)
@@ -224,6 +227,34 @@ static int btrfs_get_dev_zones(struct bt
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
@@ -237,6 +268,11 @@ static int btrfs_get_dev_zones(struct bt
 	if (!ret)
 		return -EIO;
 
+	/* Populate cache */
+	if (zinfo->zone_cache)
+		memcpy(zinfo->zone_cache + zno, zones,
+		       sizeof(*zinfo->zone_cache) * *nr_zones);
+
 	return 0;
 }
 
@@ -300,7 +336,7 @@ int btrfs_get_dev_zone_info_all_devices(
 		if (!device->bdev)
 			continue;
 
-		ret = btrfs_get_dev_zone_info(device);
+		ret = btrfs_get_dev_zone_info(device, true);
 		if (ret)
 			break;
 	}
@@ -309,7 +345,7 @@ int btrfs_get_dev_zone_info_all_devices(
 	return ret;
 }
 
-int btrfs_get_dev_zone_info(struct btrfs_device *device)
+int btrfs_get_dev_zone_info(struct btrfs_device *device, bool populate_cache)
 {
 	struct btrfs_fs_info *fs_info = device->fs_info;
 	struct btrfs_zoned_device_info *zone_info = NULL;
@@ -339,6 +375,8 @@ int btrfs_get_dev_zone_info(struct btrfs
 	if (!zone_info)
 		return -ENOMEM;
 
+	device->zone_info = zone_info;
+
 	if (!bdev_is_zoned(bdev)) {
 		if (!fs_info->zone_size) {
 			ret = calculate_emulated_zone_size(fs_info);
@@ -407,6 +445,23 @@ int btrfs_get_dev_zone_info(struct btrfs
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
@@ -505,8 +560,6 @@ int btrfs_get_dev_zone_info(struct btrfs
 
 	kfree(zones);
 
-	device->zone_info = zone_info;
-
 	switch (bdev_zoned_model(bdev)) {
 	case BLK_ZONED_HM:
 		model = "host-managed zoned";
@@ -539,11 +592,7 @@ int btrfs_get_dev_zone_info(struct btrfs
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
@@ -558,6 +607,7 @@ void btrfs_destroy_dev_zone_info(struct
 	bitmap_free(zone_info->active_zones);
 	bitmap_free(zone_info->seq_zones);
 	bitmap_free(zone_info->empty_zones);
+	vfree(zone_info->zone_cache);
 	kfree(zone_info);
 	device->zone_info = NULL;
 }
@@ -1975,3 +2025,21 @@ void btrfs_clear_data_reloc_bg(struct bt
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
@@ -76,6 +77,7 @@ bool btrfs_can_activate_zone(struct btrf
 void btrfs_zone_finish_endio(struct btrfs_fs_info *fs_info, u64 logical,
 			     u64 length);
 void btrfs_clear_data_reloc_bg(struct btrfs_block_group *bg);
+void btrfs_free_zone_cache(struct btrfs_fs_info *fs_info);
 #else /* CONFIG_BLK_DEV_ZONED */
 static inline int btrfs_get_dev_zone(struct btrfs_device *device, u64 pos,
 				     struct blk_zone *zone)
@@ -88,7 +90,8 @@ static inline int btrfs_get_dev_zone_inf
 	return 0;
 }
 
-static inline int btrfs_get_dev_zone_info(struct btrfs_device *device)
+static inline int btrfs_get_dev_zone_info(struct btrfs_device *device,
+					  bool populate_cache)
 {
 	return 0;
 }
@@ -232,6 +235,7 @@ static inline void btrfs_zone_finish_end
 
 static inline void btrfs_clear_data_reloc_bg(struct btrfs_block_group *bg) { }
 
+static inline void btrfs_free_zone_cache(struct btrfs_fs_info *fs_info) { }
 #endif
 
 static inline bool btrfs_dev_is_sequential(struct btrfs_device *device, u64 pos)


