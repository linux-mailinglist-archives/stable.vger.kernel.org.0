Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15BEE4BE5B5
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 19:01:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348479AbiBUJUT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:20:19 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348481AbiBUJT3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:19:29 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A550533E32;
        Mon, 21 Feb 2022 01:07:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id D8F1ACE0E86;
        Mon, 21 Feb 2022 09:07:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9DD7C340E9;
        Mon, 21 Feb 2022 09:07:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645434446;
        bh=GHgELpMbuBi4RgTc9u5PwVwcvv+8eW94mjNWXIGJY2Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XkPKk4bVkZU76PRJ5pIPdUaA+FXyZACaCk3BmMyDKsma13DydRJiLzLy4pUCMECQd
         I4JmtVShaBobRCo5hracZ4xo1XYYDC3Z9bVjTWukBkufVvOdEVQA3Exqf1t58mGcU4
         GVCG5biYrPmAnUjSDZp0fBMrxKXixZFzFhRcG0W0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Naohiro Aota <naohiro.aota@wdc.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.15 003/196] btrfs: zoned: cache reported zone during mount
Date:   Mon, 21 Feb 2022 09:47:15 +0100
Message-Id: <20220221084930.993153960@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084930.872957717@linuxfoundation.org>
References: <20220221084930.872957717@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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
 fs/btrfs/zoned.c       |   85 ++++++++++++++++++++++++++++++++++++++++++++-----
 fs/btrfs/zoned.h       |    8 +++-
 5 files changed, 87 insertions(+), 12 deletions(-)

--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -325,7 +325,7 @@ static int btrfs_init_dev_replace_tgtdev
 	set_blocksize(device->bdev, BTRFS_BDEV_BLOCKSIZE);
 	device->fs_devices = fs_info->fs_devices;
 
-	ret = btrfs_get_dev_zone_info(device);
+	ret = btrfs_get_dev_zone_info(device, false);
 	if (ret)
 		goto error;
 
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3565,6 +3565,8 @@ int __cold open_ctree(struct super_block
 		goto fail_sysfs;
 	}
 
+	btrfs_free_zone_cache(fs_info);
+
 	if (!sb_rdonly(sb) && fs_info->fs_devices->missing_devices &&
 	    !btrfs_check_rw_degradable(fs_info, NULL)) {
 		btrfs_warn(fs_info,
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2596,7 +2596,7 @@ int btrfs_init_new_device(struct btrfs_f
 	device->fs_info = fs_info;
 	device->bdev = bdev;
 
-	ret = btrfs_get_dev_zone_info(device);
+	ret = btrfs_get_dev_zone_info(device, false);
 	if (ret)
 		goto error_free_device;
 
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -4,6 +4,7 @@
 #include <linux/slab.h>
 #include <linux/blkdev.h>
 #include <linux/sched/mm.h>
+#include <linux/vmalloc.h>
 #include "ctree.h"
 #include "volumes.h"
 #include "zoned.h"
@@ -195,6 +196,8 @@ static int emulate_report_zones(struct b
 static int btrfs_get_dev_zones(struct btrfs_device *device, u64 pos,
 			       struct blk_zone *zones, unsigned int *nr_zones)
 {
+	struct btrfs_zoned_device_info *zinfo = device->zone_info;
+	u32 zno;
 	int ret;
 
 	if (!*nr_zones)
@@ -206,6 +209,34 @@ static int btrfs_get_dev_zones(struct bt
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
@@ -219,6 +250,11 @@ static int btrfs_get_dev_zones(struct bt
 	if (!ret)
 		return -EIO;
 
+	/* Populate cache */
+	if (zinfo->zone_cache)
+		memcpy(zinfo->zone_cache + zno, zones,
+		       sizeof(*zinfo->zone_cache) * *nr_zones);
+
 	return 0;
 }
 
@@ -282,7 +318,7 @@ int btrfs_get_dev_zone_info_all_devices(
 		if (!device->bdev)
 			continue;
 
-		ret = btrfs_get_dev_zone_info(device);
+		ret = btrfs_get_dev_zone_info(device, true);
 		if (ret)
 			break;
 	}
@@ -291,7 +327,7 @@ int btrfs_get_dev_zone_info_all_devices(
 	return ret;
 }
 
-int btrfs_get_dev_zone_info(struct btrfs_device *device)
+int btrfs_get_dev_zone_info(struct btrfs_device *device, bool populate_cache)
 {
 	struct btrfs_fs_info *fs_info = device->fs_info;
 	struct btrfs_zoned_device_info *zone_info = NULL;
@@ -318,6 +354,8 @@ int btrfs_get_dev_zone_info(struct btrfs
 	if (!zone_info)
 		return -ENOMEM;
 
+	device->zone_info = zone_info;
+
 	if (!bdev_is_zoned(bdev)) {
 		if (!fs_info->zone_size) {
 			ret = calculate_emulated_zone_size(fs_info);
@@ -369,6 +407,23 @@ int btrfs_get_dev_zone_info(struct btrfs
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
 	while (sector < nr_sectors) {
 		nr_zones = BTRFS_REPORT_NR_ZONES;
@@ -444,8 +499,6 @@ int btrfs_get_dev_zone_info(struct btrfs
 
 	kfree(zones);
 
-	device->zone_info = zone_info;
-
 	switch (bdev_zoned_model(bdev)) {
 	case BLK_ZONED_HM:
 		model = "host-managed zoned";
@@ -478,10 +531,7 @@ int btrfs_get_dev_zone_info(struct btrfs
 out:
 	kfree(zones);
 out_free_zone_info:
-	bitmap_free(zone_info->empty_zones);
-	bitmap_free(zone_info->seq_zones);
-	kfree(zone_info);
-	device->zone_info = NULL;
+	btrfs_destroy_dev_zone_info(device);
 
 	return ret;
 }
@@ -495,6 +545,7 @@ void btrfs_destroy_dev_zone_info(struct
 
 	bitmap_free(zone_info->seq_zones);
 	bitmap_free(zone_info->empty_zones);
+	vfree(zone_info->zone_cache);
 	kfree(zone_info);
 	device->zone_info = NULL;
 }
@@ -1551,3 +1602,21 @@ void btrfs_clear_data_reloc_bg(struct bt
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
@@ -25,6 +25,7 @@ struct btrfs_zoned_device_info {
 	u32 nr_zones;
 	unsigned long *seq_zones;
 	unsigned long *empty_zones;
+	struct blk_zone *zone_cache;
 	struct blk_zone sb_zones[2 * BTRFS_SUPER_MIRROR_MAX];
 };
 
@@ -32,7 +33,7 @@ struct btrfs_zoned_device_info {
 int btrfs_get_dev_zone(struct btrfs_device *device, u64 pos,
 		       struct blk_zone *zone);
 int btrfs_get_dev_zone_info_all_devices(struct btrfs_fs_info *fs_info);
-int btrfs_get_dev_zone_info(struct btrfs_device *device);
+int btrfs_get_dev_zone_info(struct btrfs_device *device, bool populate_cache);
 void btrfs_destroy_dev_zone_info(struct btrfs_device *device);
 int btrfs_check_zoned_mode(struct btrfs_fs_info *fs_info);
 int btrfs_check_mountopts_zoned(struct btrfs_fs_info *info);
@@ -67,6 +68,7 @@ int btrfs_sync_zone_write_pointer(struct
 struct btrfs_device *btrfs_zoned_get_device(struct btrfs_fs_info *fs_info,
 					    u64 logical, u64 length);
 void btrfs_clear_data_reloc_bg(struct btrfs_block_group *bg);
+void btrfs_free_zone_cache(struct btrfs_fs_info *fs_info);
 #else /* CONFIG_BLK_DEV_ZONED */
 static inline int btrfs_get_dev_zone(struct btrfs_device *device, u64 pos,
 				     struct blk_zone *zone)
@@ -79,7 +81,8 @@ static inline int btrfs_get_dev_zone_inf
 	return 0;
 }
 
-static inline int btrfs_get_dev_zone_info(struct btrfs_device *device)
+static inline int btrfs_get_dev_zone_info(struct btrfs_device *device,
+					  bool populate_cache)
 {
 	return 0;
 }
@@ -202,6 +205,7 @@ static inline struct btrfs_device *btrfs
 
 static inline void btrfs_clear_data_reloc_bg(struct btrfs_block_group *bg) { }
 
+static inline void btrfs_free_zone_cache(struct btrfs_fs_info *fs_info) { }
 #endif
 
 static inline bool btrfs_dev_is_sequential(struct btrfs_device *device, u64 pos)


