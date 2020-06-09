Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF6A91F346D
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 08:54:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726946AbgFIGyJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 02:54:09 -0400
Received: from ex13-edg-ou-001.vmware.com ([208.91.0.189]:8734 "EHLO
        EX13-EDG-OU-001.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727837AbgFIGyJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Jun 2020 02:54:09 -0400
Received: from sc9-mailhost2.vmware.com (10.113.161.72) by
 EX13-EDG-OU-001.vmware.com (10.113.208.155) with Microsoft SMTP Server id
 15.0.1156.6; Mon, 8 Jun 2020 23:51:15 -0700
Received: from vikash-ubuntu-virtual-machine.eng.vmware.com (unknown [10.197.103.194])
        by sc9-mailhost2.vmware.com (Postfix) with ESMTP id 2882CB2774;
        Tue,  9 Jun 2020 02:51:16 -0400 (EDT)
From:   Vikash Bansal <bvikas@vmware.com>
To:     <gregkh@linuxfoundation.org>
CC:     <stable@vger.kernel.org>, <srivatsab@vmware.com>,
        <srivatsa@csail.mit.edu>, <amakhalov@vmware.com>,
        <srinidhir@vmware.com>, <bvikas@vmware.com>, <anishs@vmware.com>,
        <vsirnapalli@vmware.com>, <akaher@vmware.com>, <clm@fb.com>,
        <josef@toxicpanda.com>, <dsterba@suse.com>,
        <anand.jain@oracle.com>, <linux-btrfs@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v4.19.y 1/2] btrfs: merge btrfs_find_device and find_device
Date:   Tue, 9 Jun 2020 12:20:17 +0530
Message-ID: <20200609065018.26378-2-bvikas@vmware.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200609065018.26378-1-bvikas@vmware.com>
References: <20200609065018.26378-1-bvikas@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain
Received-SPF: None (EX13-EDG-OU-001.vmware.com: bvikas@vmware.com does not
 designate permitted sender hosts)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anand Jain <anand.jain@oracle.com>

commit 09ba3bc9dd150457c506e4661380a6183af651c1 upstream

Both btrfs_find_device() and find_device() does the same thing except
that the latter does not take the seed device onto account in the device
scanning context. We can merge them.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
[4.19.y backport notes:
Vikash : - To apply this patch, a portion of commit e4319cd9cace
           was used to change the first argument of function
           "btrfs_find_device" from "struct btrfs_fs_info" to
           "struct btrfs_fs_devices".
Signed-off-by: Vikash Bansal <bvikas@vmware.com>
---
 fs/btrfs/dev-replace.c |  8 ++--
 fs/btrfs/ioctl.c       |  5 ++-
 fs/btrfs/scrub.c       |  4 +-
 fs/btrfs/volumes.c     | 84 +++++++++++++++++++++---------------------
 fs/btrfs/volumes.h     |  4 +-
 5 files changed, 53 insertions(+), 52 deletions(-)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index 96763805787e..1b9c8ffb038f 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -112,11 +112,11 @@ int btrfs_init_dev_replace(struct btrfs_fs_info *fs_info)
 		break;
 	case BTRFS_IOCTL_DEV_REPLACE_STATE_STARTED:
 	case BTRFS_IOCTL_DEV_REPLACE_STATE_SUSPENDED:
-		dev_replace->srcdev = btrfs_find_device(fs_info, src_devid,
-							NULL, NULL);
-		dev_replace->tgtdev = btrfs_find_device(fs_info,
+		dev_replace->srcdev = btrfs_find_device(fs_info->fs_devices,
+						src_devid, NULL, NULL, true);
+		dev_replace->tgtdev = btrfs_find_device(fs_info->fs_devices,
 							BTRFS_DEV_REPLACE_DEVID,
-							NULL, NULL);
+							NULL, NULL, true);
 		/*
 		 * allow 'btrfs dev replace_cancel' if src/tgt device is
 		 * missing
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 199c70b8f7d8..a5ae02bf3652 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1642,7 +1642,7 @@ static noinline int btrfs_ioctl_resize(struct file *file,
 		btrfs_info(fs_info, "resizing devid %llu", devid);
 	}
 
-	device = btrfs_find_device(fs_info, devid, NULL, NULL);
+	device = btrfs_find_device(fs_info->fs_devices, devid, NULL, NULL, true);
 	if (!device) {
 		btrfs_info(fs_info, "resizer unable to find device %llu",
 			   devid);
@@ -3178,7 +3178,8 @@ static long btrfs_ioctl_dev_info(struct btrfs_fs_info *fs_info,
 		s_uuid = di_args->uuid;
 
 	rcu_read_lock();
-	dev = btrfs_find_device(fs_info, di_args->devid, s_uuid, NULL);
+	dev = btrfs_find_device(fs_info->fs_devices, di_args->devid, s_uuid,
+				NULL, true);
 
 	if (!dev) {
 		ret = -ENODEV;
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 6b6008db3e03..fee8995c9a0c 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -3835,7 +3835,7 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
 		return PTR_ERR(sctx);
 
 	mutex_lock(&fs_info->fs_devices->device_list_mutex);
-	dev = btrfs_find_device(fs_info, devid, NULL, NULL);
+	dev = btrfs_find_device(fs_info->fs_devices, devid, NULL, NULL, true);
 	if (!dev || (test_bit(BTRFS_DEV_STATE_MISSING, &dev->dev_state) &&
 		     !is_dev_replace)) {
 		mutex_unlock(&fs_info->fs_devices->device_list_mutex);
@@ -4019,7 +4019,7 @@ int btrfs_scrub_progress(struct btrfs_fs_info *fs_info, u64 devid,
 	struct scrub_ctx *sctx = NULL;
 
 	mutex_lock(&fs_info->fs_devices->device_list_mutex);
-	dev = btrfs_find_device(fs_info, devid, NULL, NULL);
+	dev = btrfs_find_device(fs_info->fs_devices, devid, NULL, NULL, true);
 	if (dev)
 		sctx = dev->scrub_ctx;
 	if (sctx)
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 9c3b394b99fa..5b0d00c63fbb 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -347,27 +347,6 @@ static struct btrfs_device *__alloc_device(void)
 	return dev;
 }
 
-/*
- * Find a device specified by @devid or @uuid in the list of @fs_devices, or
- * return NULL.
- *
- * If devid and uuid are both specified, the match must be exact, otherwise
- * only devid is used.
- */
-static struct btrfs_device *find_device(struct btrfs_fs_devices *fs_devices,
-		u64 devid, const u8 *uuid)
-{
-	struct btrfs_device *dev;
-
-	list_for_each_entry(dev, &fs_devices->devices, dev_list) {
-		if (dev->devid == devid &&
-		    (!uuid || !memcmp(dev->uuid, uuid, BTRFS_UUID_SIZE))) {
-			return dev;
-		}
-	}
-	return NULL;
-}
-
 static noinline struct btrfs_fs_devices *find_fsid(u8 *fsid)
 {
 	struct btrfs_fs_devices *fs_devices;
@@ -772,8 +751,8 @@ static noinline struct btrfs_device *device_list_add(const char *path,
 		device = NULL;
 	} else {
 		mutex_lock(&fs_devices->device_list_mutex);
-		device = find_device(fs_devices, devid,
-				disk_super->dev_item.uuid);
+		device = btrfs_find_device(fs_devices, devid,
+				disk_super->dev_item.uuid, NULL, false);
 	}
 
 	if (!device) {
@@ -2144,7 +2123,8 @@ static int btrfs_find_device_by_path(struct btrfs_fs_info *fs_info,
 	disk_super = (struct btrfs_super_block *)bh->b_data;
 	devid = btrfs_stack_device_id(&disk_super->dev_item);
 	dev_uuid = disk_super->dev_item.uuid;
-	*device = btrfs_find_device(fs_info, devid, dev_uuid, disk_super->fsid);
+	*device = btrfs_find_device(fs_info->fs_devices, devid, dev_uuid,
+				    disk_super->fsid, true);
 	brelse(bh);
 	if (!*device)
 		ret = -ENOENT;
@@ -2190,7 +2170,8 @@ int btrfs_find_device_by_devspec(struct btrfs_fs_info *fs_info, u64 devid,
 
 	if (devid) {
 		ret = 0;
-		*device = btrfs_find_device(fs_info, devid, NULL, NULL);
+		*device = btrfs_find_device(fs_info->fs_devices, devid,
+					    NULL, NULL, true);
 		if (!*device)
 			ret = -ENOENT;
 	} else {
@@ -2322,7 +2303,8 @@ static int btrfs_finish_sprout(struct btrfs_trans_handle *trans,
 				   BTRFS_UUID_SIZE);
 		read_extent_buffer(leaf, fs_uuid, btrfs_device_fsid(dev_item),
 				   BTRFS_FSID_SIZE);
-		device = btrfs_find_device(fs_info, devid, dev_uuid, fs_uuid);
+		device = btrfs_find_device(fs_info->fs_devices, devid, dev_uuid,
+					   fs_uuid, true);
 		BUG_ON(!device); /* Logic error */
 
 		if (device->fs_devices->seeding) {
@@ -6254,21 +6236,36 @@ blk_status_t btrfs_map_bio(struct btrfs_fs_info *fs_info, struct bio *bio,
 	return BLK_STS_OK;
 }
 
-struct btrfs_device *btrfs_find_device(struct btrfs_fs_info *fs_info, u64 devid,
-				       u8 *uuid, u8 *fsid)
+/*
+ * Find a device specified by @devid or @uuid in the list of @fs_devices, or
+ * return NULL.
+ *
+ * If devid and uuid are both specified, the match must be exact, otherwise
+ * only devid is used.
+ *
+ * If @seed is true, traverse through the seed devices.
+ */
+struct btrfs_device *btrfs_find_device(struct btrfs_fs_devices *fs_devices,
+					u64 devid, u8 *uuid, u8 *fsid,
+					bool seed)
 {
 	struct btrfs_device *device;
-	struct btrfs_fs_devices *cur_devices;
 
-	cur_devices = fs_info->fs_devices;
-	while (cur_devices) {
+	while (fs_devices) {
 		if (!fsid ||
-		    !memcmp(cur_devices->fsid, fsid, BTRFS_FSID_SIZE)) {
-			device = find_device(cur_devices, devid, uuid);
-			if (device)
-				return device;
+		    !memcmp(fs_devices->fsid, fsid, BTRFS_FSID_SIZE)) {
+			list_for_each_entry(device, &fs_devices->devices,
+					    dev_list) {
+				if (device->devid == devid &&
+				    (!uuid || memcmp(device->uuid, uuid,
+						     BTRFS_UUID_SIZE) == 0))
+					return device;
+			}
 		}
-		cur_devices = cur_devices->seed;
+		if (seed)
+			fs_devices = fs_devices->seed;
+		else
+			return NULL;
 	}
 	return NULL;
 }
@@ -6513,8 +6510,8 @@ static int read_one_chunk(struct btrfs_fs_info *fs_info, struct btrfs_key *key,
 		read_extent_buffer(leaf, uuid, (unsigned long)
 				   btrfs_stripe_dev_uuid_nr(chunk, i),
 				   BTRFS_UUID_SIZE);
-		map->stripes[i].dev = btrfs_find_device(fs_info, devid,
-							uuid, NULL);
+		map->stripes[i].dev = btrfs_find_device(fs_info->fs_devices,
+						devid, uuid, NULL, true);
 		if (!map->stripes[i].dev &&
 		    !btrfs_test_opt(fs_info, DEGRADED)) {
 			free_extent_map(em);
@@ -6653,7 +6650,8 @@ static int read_one_dev(struct btrfs_fs_info *fs_info,
 			return PTR_ERR(fs_devices);
 	}
 
-	device = btrfs_find_device(fs_info, devid, dev_uuid, fs_uuid);
+	device = btrfs_find_device(fs_info->fs_devices, devid, dev_uuid,
+				   fs_uuid, true);
 	if (!device) {
 		if (!btrfs_test_opt(fs_info, DEGRADED)) {
 			btrfs_report_missing_device(fs_info, devid,
@@ -7243,7 +7241,8 @@ int btrfs_get_dev_stats(struct btrfs_fs_info *fs_info,
 	int i;
 
 	mutex_lock(&fs_devices->device_list_mutex);
-	dev = btrfs_find_device(fs_info, stats->devid, NULL, NULL);
+	dev = btrfs_find_device(fs_info->fs_devices, stats->devid,
+				NULL, NULL, true);
 	mutex_unlock(&fs_devices->device_list_mutex);
 
 	if (!dev) {
@@ -7460,7 +7459,7 @@ static int verify_one_dev_extent(struct btrfs_fs_info *fs_info,
 	}
 
 	/* Make sure no dev extent is beyond device bondary */
-	dev = btrfs_find_device(fs_info, devid, NULL, NULL);
+	dev = btrfs_find_device(fs_info->fs_devices, devid, NULL, NULL, true);
 	if (!dev) {
 		btrfs_err(fs_info, "failed to find devid %llu", devid);
 		ret = -EUCLEAN;
@@ -7469,7 +7468,8 @@ static int verify_one_dev_extent(struct btrfs_fs_info *fs_info,
 
 	/* It's possible this device is a dummy for seed device */
 	if (dev->disk_total_bytes == 0) {
-		dev = find_device(fs_info->fs_devices->seed, devid, NULL);
+		dev = btrfs_find_device(fs_info->fs_devices->seed, devid,
+					NULL, NULL, false);
 		if (!dev) {
 			btrfs_err(fs_info, "failed to find seed devid %llu",
 				  devid);
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index ac703b15d679..ddd30c162f98 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -430,8 +430,8 @@ void __exit btrfs_cleanup_fs_uuids(void);
 int btrfs_num_copies(struct btrfs_fs_info *fs_info, u64 logical, u64 len);
 int btrfs_grow_device(struct btrfs_trans_handle *trans,
 		      struct btrfs_device *device, u64 new_size);
-struct btrfs_device *btrfs_find_device(struct btrfs_fs_info *fs_info, u64 devid,
-				       u8 *uuid, u8 *fsid);
+struct btrfs_device *btrfs_find_device(struct btrfs_fs_devices *fs_devices,
+				       u64 devid, u8 *uuid, u8 *fsid, bool seed);
 int btrfs_shrink_device(struct btrfs_device *device, u64 new_size);
 int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *path);
 int btrfs_balance(struct btrfs_fs_info *fs_info,
-- 
2.23.1

