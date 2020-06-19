Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99AC4201669
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 18:33:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389812AbgFSQa3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 12:30:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:47824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388801AbgFSOxc (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 10:53:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A66B8217D8;
        Fri, 19 Jun 2020 14:53:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592578411;
        bh=VUA5sjrivSNJ6BZho42t/LwkDDfg2x/W2+UEi9LAhfg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dql4Zw1EFOLOnc1RnkQl8vs/brCXlgTU5abZ5N0hXKckNnAWQQJWlvx26sOl7F9v5
         lRnsM8aP5Abb5Tpi0ng3VES4+q5A2PFXXFVBFoIhmB6LchsEhB1NHTr/Hg7H7jsm18
         El1kLhStQpSDe/VFT1bMwQTVkZY93TZX8rWoOilY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anand Jain <anand.jain@oracle.com>,
        David Sterba <dsterba@suse.com>,
        Vikash Bansal <bvikas@vmware.com>
Subject: [PATCH 4.19 012/267] btrfs: merge btrfs_find_device and find_device
Date:   Fri, 19 Jun 2020 16:29:57 +0200
Message-Id: <20200619141649.446819178@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141648.840376470@linuxfoundation.org>
References: <20200619141648.840376470@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anand Jain <anand.jain@oracle.com>

commit 09ba3bc9dd150457c506e4661380a6183af651c1 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/dev-replace.c |    8 ++--
 fs/btrfs/ioctl.c       |    5 +-
 fs/btrfs/scrub.c       |    4 +-
 fs/btrfs/volumes.c     |   84 ++++++++++++++++++++++++-------------------------
 fs/btrfs/volumes.h     |    4 +-
 5 files changed, 53 insertions(+), 52 deletions(-)

--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -112,11 +112,11 @@ no_valid_dev_replace_entry_found:
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
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1642,7 +1642,7 @@ static noinline int btrfs_ioctl_resize(s
 		btrfs_info(fs_info, "resizing devid %llu", devid);
 	}
 
-	device = btrfs_find_device(fs_info, devid, NULL, NULL);
+	device = btrfs_find_device(fs_info->fs_devices, devid, NULL, NULL, true);
 	if (!device) {
 		btrfs_info(fs_info, "resizer unable to find device %llu",
 			   devid);
@@ -3178,7 +3178,8 @@ static long btrfs_ioctl_dev_info(struct
 		s_uuid = di_args->uuid;
 
 	rcu_read_lock();
-	dev = btrfs_find_device(fs_info, di_args->devid, s_uuid, NULL);
+	dev = btrfs_find_device(fs_info->fs_devices, di_args->devid, s_uuid,
+				NULL, true);
 
 	if (!dev) {
 		ret = -ENODEV;
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -3835,7 +3835,7 @@ int btrfs_scrub_dev(struct btrfs_fs_info
 		return PTR_ERR(sctx);
 
 	mutex_lock(&fs_info->fs_devices->device_list_mutex);
-	dev = btrfs_find_device(fs_info, devid, NULL, NULL);
+	dev = btrfs_find_device(fs_info->fs_devices, devid, NULL, NULL, true);
 	if (!dev || (test_bit(BTRFS_DEV_STATE_MISSING, &dev->dev_state) &&
 		     !is_dev_replace)) {
 		mutex_unlock(&fs_info->fs_devices->device_list_mutex);
@@ -4019,7 +4019,7 @@ int btrfs_scrub_progress(struct btrfs_fs
 	struct scrub_ctx *sctx = NULL;
 
 	mutex_lock(&fs_info->fs_devices->device_list_mutex);
-	dev = btrfs_find_device(fs_info, devid, NULL, NULL);
+	dev = btrfs_find_device(fs_info->fs_devices, devid, NULL, NULL, true);
 	if (dev)
 		sctx = dev->scrub_ctx;
 	if (sctx)
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -347,27 +347,6 @@ static struct btrfs_device *__alloc_devi
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
@@ -772,8 +751,8 @@ static noinline struct btrfs_device *dev
 		device = NULL;
 	} else {
 		mutex_lock(&fs_devices->device_list_mutex);
-		device = find_device(fs_devices, devid,
-				disk_super->dev_item.uuid);
+		device = btrfs_find_device(fs_devices, devid,
+				disk_super->dev_item.uuid, NULL, false);
 	}
 
 	if (!device) {
@@ -2144,7 +2123,8 @@ static int btrfs_find_device_by_path(str
 	disk_super = (struct btrfs_super_block *)bh->b_data;
 	devid = btrfs_stack_device_id(&disk_super->dev_item);
 	dev_uuid = disk_super->dev_item.uuid;
-	*device = btrfs_find_device(fs_info, devid, dev_uuid, disk_super->fsid);
+	*device = btrfs_find_device(fs_info->fs_devices, devid, dev_uuid,
+				    disk_super->fsid, true);
 	brelse(bh);
 	if (!*device)
 		ret = -ENOENT;
@@ -2190,7 +2170,8 @@ int btrfs_find_device_by_devspec(struct
 
 	if (devid) {
 		ret = 0;
-		*device = btrfs_find_device(fs_info, devid, NULL, NULL);
+		*device = btrfs_find_device(fs_info->fs_devices, devid,
+					    NULL, NULL, true);
 		if (!*device)
 			ret = -ENOENT;
 	} else {
@@ -2322,7 +2303,8 @@ next_slot:
 				   BTRFS_UUID_SIZE);
 		read_extent_buffer(leaf, fs_uuid, btrfs_device_fsid(dev_item),
 				   BTRFS_FSID_SIZE);
-		device = btrfs_find_device(fs_info, devid, dev_uuid, fs_uuid);
+		device = btrfs_find_device(fs_info->fs_devices, devid, dev_uuid,
+					   fs_uuid, true);
 		BUG_ON(!device); /* Logic error */
 
 		if (device->fs_devices->seeding) {
@@ -6254,21 +6236,36 @@ blk_status_t btrfs_map_bio(struct btrfs_
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
@@ -6513,8 +6510,8 @@ static int read_one_chunk(struct btrfs_f
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
@@ -6653,7 +6650,8 @@ static int read_one_dev(struct btrfs_fs_
 			return PTR_ERR(fs_devices);
 	}
 
-	device = btrfs_find_device(fs_info, devid, dev_uuid, fs_uuid);
+	device = btrfs_find_device(fs_info->fs_devices, devid, dev_uuid,
+				   fs_uuid, true);
 	if (!device) {
 		if (!btrfs_test_opt(fs_info, DEGRADED)) {
 			btrfs_report_missing_device(fs_info, devid,
@@ -7243,7 +7241,8 @@ int btrfs_get_dev_stats(struct btrfs_fs_
 	int i;
 
 	mutex_lock(&fs_devices->device_list_mutex);
-	dev = btrfs_find_device(fs_info, stats->devid, NULL, NULL);
+	dev = btrfs_find_device(fs_info->fs_devices, stats->devid,
+				NULL, NULL, true);
 	mutex_unlock(&fs_devices->device_list_mutex);
 
 	if (!dev) {
@@ -7460,7 +7459,7 @@ static int verify_one_dev_extent(struct
 	}
 
 	/* Make sure no dev extent is beyond device bondary */
-	dev = btrfs_find_device(fs_info, devid, NULL, NULL);
+	dev = btrfs_find_device(fs_info->fs_devices, devid, NULL, NULL, true);
 	if (!dev) {
 		btrfs_err(fs_info, "failed to find devid %llu", devid);
 		ret = -EUCLEAN;
@@ -7469,7 +7468,8 @@ static int verify_one_dev_extent(struct
 
 	/* It's possible this device is a dummy for seed device */
 	if (dev->disk_total_bytes == 0) {
-		dev = find_device(fs_info->fs_devices->seed, devid, NULL);
+		dev = btrfs_find_device(fs_info->fs_devices->seed, devid,
+					NULL, NULL, false);
 		if (!dev) {
 			btrfs_err(fs_info, "failed to find seed devid %llu",
 				  devid);
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -430,8 +430,8 @@ void __exit btrfs_cleanup_fs_uuids(void)
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


