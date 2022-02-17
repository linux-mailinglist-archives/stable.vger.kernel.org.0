Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52FEC4B97DF
	for <lists+stable@lfdr.de>; Thu, 17 Feb 2022 05:51:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233963AbiBQEvV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Feb 2022 23:51:21 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229697AbiBQEvV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Feb 2022 23:51:21 -0500
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F58729ADF3;
        Wed, 16 Feb 2022 20:51:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1645073462; x=1676609462;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=0fW34QBhNu2dlUg6rtjvlL+/jJwRP6gaB6+jWK3OMz4=;
  b=Or3Qq9LH8z3DjNtcoeQvr5YjyESsIxlAxdPlA8qQvX7g5syjyVxalFP8
   anN+tmit/d7fhXRlZiLWSHicEry06IcVvkY79zWVy+g/qaN/powDq4Sj8
   LXbzLXaQsRURufd2i5SQC/OTjSoCctai6cKu1UkfnR1atfs+dluZZHrpG
   SCHcpsUrJt+nURl9RjizfPZF3tb2NKpL2j/IoZ2CrdaXJJIJFi39TnhIF
   C6JETNz/UVXFyHvnolYx8EU2iuxITaeot6e1bs1YfqgcG4VVJdjldtR0h
   bTxOoZui6C5O6aTeIYF+VFFcrEZBFLKl9hnYK6x6mPjjzfWDnKum9Ho4R
   g==;
X-IronPort-AV: E=Sophos;i="5.88,375,1635177600"; 
   d="scan'208";a="197980863"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 17 Feb 2022 12:51:02 +0800
IronPort-SDR: oks99Hbarppijx2uvdOdC9tsXxVSNE0fyKeM6Q6L/UkSYgVugaBFRvSe8xOv1B9O/+qnbR6R7i
 8fZT12BSpRsi+6rnZSTXxhOTYWOqjNnDJHcyr48ul3AWa0aUxDKchB2/o8AYznHQ8rGwEmVH+4
 MmLhjOHGyMs4OHLcE+pTRZjVBhYGGOSOAkdAOUWmzLJNbx/LYujjW+Rwq+eRIvuB7OLS7taM38
 2PUjei+nwMMiAn5Eqxnb0GoJeQBPSeQAfWHK6byCvcPjiBDg9l/b82Wks0e7apO3cLXKsNoqxO
 K2f4LVzZESWbDb0iCIxyOqeJ
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2022 20:23:51 -0800
IronPort-SDR: +dj3z84T7SQtqXHglLiFie1vH7L4/p6vAtLZrkHR0ez0hbSScy4IkAVYvfccN56Pj+iio2Lgc5
 LVB5IJ3dFJFbn1nMFIG8Qs/Z3s1r88pPzAZ6rfpWx8wR5t/157W2ezjl8rJs2e8l+K50kYO85v
 6zL9Eq0TkhAHyYLtngpXQ845Ya8K3fcv0YlsfkE07LRGpIqclpMR2xakX1LonJKxX2T+3eZsrr
 vaYrhY+ji0WzN6b1SGbeQTFPWLBiFIf34xqcjYFUPAAOX/5//wxlCpoN6LWsKsGmG6yl+/UNKg
 1xk=
WDCIronportException: Internal
Received: from 3lhthr2.ad.shared (HELO naota-xeon.wdc.com) ([10.225.53.247])
  by uls-op-cesaip01.wdc.com with ESMTP; 16 Feb 2022 20:51:04 -0800
From:   Naohiro Aota <naohiro.aota@wdc.com>
To:     stable@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org, Naohiro Aota <naohiro.aota@wdc.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH for-5.15.y] btrfs: zoned: cache reported zone during mount
Date:   Thu, 17 Feb 2022 13:50:56 +0900
Message-Id: <20220217045056.1299721-1-naohiro.aota@wdc.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 fs/btrfs/dev-replace.c |  2 +-
 fs/btrfs/disk-io.c     |  2 +
 fs/btrfs/volumes.c     |  2 +-
 fs/btrfs/zoned.c       | 85 ++++++++++++++++++++++++++++++++++++++----
 fs/btrfs/zoned.h       |  8 +++-
 5 files changed, 87 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index d029be40ea6f..bdbc310a8f8c 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -325,7 +325,7 @@ static int btrfs_init_dev_replace_tgtdev(struct btrfs_fs_info *fs_info,
 	set_blocksize(device->bdev, BTRFS_BDEV_BLOCKSIZE);
 	device->fs_devices = fs_info->fs_devices;
 
-	ret = btrfs_get_dev_zone_info(device);
+	ret = btrfs_get_dev_zone_info(device, false);
 	if (ret)
 		goto error;
 
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index e1a262120e02..2c3e106a0270 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3565,6 +3565,8 @@ int __cold open_ctree(struct super_block *sb, struct btrfs_fs_devices *fs_device
 		goto fail_sysfs;
 	}
 
+	btrfs_free_zone_cache(fs_info);
+
 	if (!sb_rdonly(sb) && fs_info->fs_devices->missing_devices &&
 	    !btrfs_check_rw_degradable(fs_info, NULL)) {
 		btrfs_warn(fs_info,
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index c34efdc1ecdd..06a1a7c2254c 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2596,7 +2596,7 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
 	device->fs_info = fs_info;
 	device->bdev = bdev;
 
-	ret = btrfs_get_dev_zone_info(device);
+	ret = btrfs_get_dev_zone_info(device, false);
 	if (ret)
 		goto error_free_device;
 
diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 5672c24a2d58..596b2148807d 100644
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
@@ -195,6 +196,8 @@ static int emulate_report_zones(struct btrfs_device *device, u64 pos,
 static int btrfs_get_dev_zones(struct btrfs_device *device, u64 pos,
 			       struct blk_zone *zones, unsigned int *nr_zones)
 {
+	struct btrfs_zoned_device_info *zinfo = device->zone_info;
+	u32 zno;
 	int ret;
 
 	if (!*nr_zones)
@@ -206,6 +209,34 @@ static int btrfs_get_dev_zones(struct btrfs_device *device, u64 pos,
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
@@ -219,6 +250,11 @@ static int btrfs_get_dev_zones(struct btrfs_device *device, u64 pos,
 	if (!ret)
 		return -EIO;
 
+	/* Populate cache */
+	if (zinfo->zone_cache)
+		memcpy(zinfo->zone_cache + zno, zones,
+		       sizeof(*zinfo->zone_cache) * *nr_zones);
+
 	return 0;
 }
 
@@ -282,7 +318,7 @@ int btrfs_get_dev_zone_info_all_devices(struct btrfs_fs_info *fs_info)
 		if (!device->bdev)
 			continue;
 
-		ret = btrfs_get_dev_zone_info(device);
+		ret = btrfs_get_dev_zone_info(device, true);
 		if (ret)
 			break;
 	}
@@ -291,7 +327,7 @@ int btrfs_get_dev_zone_info_all_devices(struct btrfs_fs_info *fs_info)
 	return ret;
 }
 
-int btrfs_get_dev_zone_info(struct btrfs_device *device)
+int btrfs_get_dev_zone_info(struct btrfs_device *device, bool populate_cache)
 {
 	struct btrfs_fs_info *fs_info = device->fs_info;
 	struct btrfs_zoned_device_info *zone_info = NULL;
@@ -318,6 +354,8 @@ int btrfs_get_dev_zone_info(struct btrfs_device *device)
 	if (!zone_info)
 		return -ENOMEM;
 
+	device->zone_info = zone_info;
+
 	if (!bdev_is_zoned(bdev)) {
 		if (!fs_info->zone_size) {
 			ret = calculate_emulated_zone_size(fs_info);
@@ -369,6 +407,23 @@ int btrfs_get_dev_zone_info(struct btrfs_device *device)
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
@@ -444,8 +499,6 @@ int btrfs_get_dev_zone_info(struct btrfs_device *device)
 
 	kfree(zones);
 
-	device->zone_info = zone_info;
-
 	switch (bdev_zoned_model(bdev)) {
 	case BLK_ZONED_HM:
 		model = "host-managed zoned";
@@ -478,10 +531,7 @@ int btrfs_get_dev_zone_info(struct btrfs_device *device)
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
@@ -495,6 +545,7 @@ void btrfs_destroy_dev_zone_info(struct btrfs_device *device)
 
 	bitmap_free(zone_info->seq_zones);
 	bitmap_free(zone_info->empty_zones);
+	vfree(zone_info->zone_cache);
 	kfree(zone_info);
 	device->zone_info = NULL;
 }
@@ -1551,3 +1602,21 @@ void btrfs_clear_data_reloc_bg(struct btrfs_block_group *bg)
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
index 70b3be517599..813aa3cddc11 100644
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
@@ -67,6 +68,7 @@ int btrfs_sync_zone_write_pointer(struct btrfs_device *tgt_dev, u64 logical,
 struct btrfs_device *btrfs_zoned_get_device(struct btrfs_fs_info *fs_info,
 					    u64 logical, u64 length);
 void btrfs_clear_data_reloc_bg(struct btrfs_block_group *bg);
+void btrfs_free_zone_cache(struct btrfs_fs_info *fs_info);
 #else /* CONFIG_BLK_DEV_ZONED */
 static inline int btrfs_get_dev_zone(struct btrfs_device *device, u64 pos,
 				     struct blk_zone *zone)
@@ -79,7 +81,8 @@ static inline int btrfs_get_dev_zone_info_all_devices(struct btrfs_fs_info *fs_i
 	return 0;
 }
 
-static inline int btrfs_get_dev_zone_info(struct btrfs_device *device)
+static inline int btrfs_get_dev_zone_info(struct btrfs_device *device,
+					  bool populate_cache)
 {
 	return 0;
 }
@@ -202,6 +205,7 @@ static inline struct btrfs_device *btrfs_zoned_get_device(
 
 static inline void btrfs_clear_data_reloc_bg(struct btrfs_block_group *bg) { }
 
+static inline void btrfs_free_zone_cache(struct btrfs_fs_info *fs_info) { }
 #endif
 
 static inline bool btrfs_dev_is_sequential(struct btrfs_device *device, u64 pos)
-- 
2.35.1

