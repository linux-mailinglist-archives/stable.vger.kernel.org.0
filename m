Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77E3656FCC6
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:48:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233576AbiGKJsE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:48:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233577AbiGKJre (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:47:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9751AB7C0;
        Mon, 11 Jul 2022 02:23:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 596C2B80E7E;
        Mon, 11 Jul 2022 09:23:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B69D7C34115;
        Mon, 11 Jul 2022 09:23:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531388;
        bh=IAb8LwL92r24iHKH65l8qzlPUc2Zxl8VJi1CLmbM2AM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O/4MroZBROhBsYbxhOjgSJGMr6zcjetx7dehqr1LzdiOyNKxYBgSwMARfnaalzNCX
         r9IqT2+i8iqpNcyjsBck9VK8+q1prAveACXuT1EcbjnbfLFiV4z1sK+HpwMkyPTC0n
         TzE8celL9f3651LQuT8dOBcHyfZKdUqaqCNbOLxs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anand Jain <anand.jain@oracle.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 085/230] btrfs: handle device lookup with btrfs_dev_lookup_args
Date:   Mon, 11 Jul 2022 11:05:41 +0200
Message-Id: <20220711090606.484420518@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090604.055883544@linuxfoundation.org>
References: <20220711090604.055883544@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 562d7b1512f7369a19bca2883e2e8672d78f0481 ]

We have a lot of device lookup functions that all do something slightly
different.  Clean this up by adding a struct to hold the different
lookup criteria, and then pass this around to btrfs_find_device() so it
can do the proper matching based on the lookup criteria.

Reviewed-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/dev-replace.c |  16 +++---
 fs/btrfs/ioctl.c       |  13 +++--
 fs/btrfs/scrub.c       |   6 +-
 fs/btrfs/volumes.c     | 122 +++++++++++++++++++++++++----------------
 fs/btrfs/volumes.h     |  20 ++++++-
 5 files changed, 112 insertions(+), 65 deletions(-)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index bdbc310a8f8c..781556e2a37f 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -70,6 +70,7 @@ static int btrfs_dev_replace_kthread(void *data);
 
 int btrfs_init_dev_replace(struct btrfs_fs_info *fs_info)
 {
+	struct btrfs_dev_lookup_args args = { .devid = BTRFS_DEV_REPLACE_DEVID };
 	struct btrfs_key key;
 	struct btrfs_root *dev_root = fs_info->dev_root;
 	struct btrfs_dev_replace *dev_replace = &fs_info->dev_replace;
@@ -100,8 +101,7 @@ int btrfs_init_dev_replace(struct btrfs_fs_info *fs_info)
 		 * We don't have a replace item or it's corrupted.  If there is
 		 * a replace target, fail the mount.
 		 */
-		if (btrfs_find_device(fs_info->fs_devices,
-				      BTRFS_DEV_REPLACE_DEVID, NULL, NULL)) {
+		if (btrfs_find_device(fs_info->fs_devices, &args)) {
 			btrfs_err(fs_info,
 			"found replace target device without a valid replace item");
 			ret = -EUCLEAN;
@@ -163,8 +163,7 @@ int btrfs_init_dev_replace(struct btrfs_fs_info *fs_info)
 		 * We don't have an active replace item but if there is a
 		 * replace target, fail the mount.
 		 */
-		if (btrfs_find_device(fs_info->fs_devices,
-				      BTRFS_DEV_REPLACE_DEVID, NULL, NULL)) {
+		if (btrfs_find_device(fs_info->fs_devices, &args)) {
 			btrfs_err(fs_info,
 			"replace devid present without an active replace item");
 			ret = -EUCLEAN;
@@ -175,11 +174,10 @@ int btrfs_init_dev_replace(struct btrfs_fs_info *fs_info)
 		break;
 	case BTRFS_IOCTL_DEV_REPLACE_STATE_STARTED:
 	case BTRFS_IOCTL_DEV_REPLACE_STATE_SUSPENDED:
-		dev_replace->srcdev = btrfs_find_device(fs_info->fs_devices,
-						src_devid, NULL, NULL);
-		dev_replace->tgtdev = btrfs_find_device(fs_info->fs_devices,
-							BTRFS_DEV_REPLACE_DEVID,
-							NULL, NULL);
+		dev_replace->tgtdev = btrfs_find_device(fs_info->fs_devices, &args);
+		args.devid = src_devid;
+		dev_replace->srcdev = btrfs_find_device(fs_info->fs_devices, &args);
+
 		/*
 		 * allow 'btrfs dev replace_cancel' if src/tgt device is
 		 * missing
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index a37ab3e89a3b..4951a2ab88dd 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1657,6 +1657,7 @@ static int exclop_start_or_cancel_reloc(struct btrfs_fs_info *fs_info,
 static noinline int btrfs_ioctl_resize(struct file *file,
 					void __user *arg)
 {
+	BTRFS_DEV_LOOKUP_ARGS(args);
 	struct inode *inode = file_inode(file);
 	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
 	u64 new_size;
@@ -1712,7 +1713,8 @@ static noinline int btrfs_ioctl_resize(struct file *file,
 		btrfs_info(fs_info, "resizing devid %llu", devid);
 	}
 
-	device = btrfs_find_device(fs_info->fs_devices, devid, NULL, NULL);
+	args.devid = devid;
+	device = btrfs_find_device(fs_info->fs_devices, &args);
 	if (!device) {
 		btrfs_info(fs_info, "resizer unable to find device %llu",
 			   devid);
@@ -3375,22 +3377,21 @@ static long btrfs_ioctl_fs_info(struct btrfs_fs_info *fs_info,
 static long btrfs_ioctl_dev_info(struct btrfs_fs_info *fs_info,
 				 void __user *arg)
 {
+	BTRFS_DEV_LOOKUP_ARGS(args);
 	struct btrfs_ioctl_dev_info_args *di_args;
 	struct btrfs_device *dev;
 	int ret = 0;
-	char *s_uuid = NULL;
 
 	di_args = memdup_user(arg, sizeof(*di_args));
 	if (IS_ERR(di_args))
 		return PTR_ERR(di_args);
 
+	args.devid = di_args->devid;
 	if (!btrfs_is_empty_uuid(di_args->uuid))
-		s_uuid = di_args->uuid;
+		args.uuid = di_args->uuid;
 
 	rcu_read_lock();
-	dev = btrfs_find_device(fs_info->fs_devices, di_args->devid, s_uuid,
-				NULL);
-
+	dev = btrfs_find_device(fs_info->fs_devices, &args);
 	if (!dev) {
 		ret = -ENODEV;
 		goto out;
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 62f4bafbe54b..6f2787b21530 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -4068,6 +4068,7 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
 		    u64 end, struct btrfs_scrub_progress *progress,
 		    int readonly, int is_dev_replace)
 {
+	struct btrfs_dev_lookup_args args = { .devid = devid };
 	struct scrub_ctx *sctx;
 	int ret;
 	struct btrfs_device *dev;
@@ -4115,7 +4116,7 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
 		goto out_free_ctx;
 
 	mutex_lock(&fs_info->fs_devices->device_list_mutex);
-	dev = btrfs_find_device(fs_info->fs_devices, devid, NULL, NULL);
+	dev = btrfs_find_device(fs_info->fs_devices, &args);
 	if (!dev || (test_bit(BTRFS_DEV_STATE_MISSING, &dev->dev_state) &&
 		     !is_dev_replace)) {
 		mutex_unlock(&fs_info->fs_devices->device_list_mutex);
@@ -4288,11 +4289,12 @@ int btrfs_scrub_cancel_dev(struct btrfs_device *dev)
 int btrfs_scrub_progress(struct btrfs_fs_info *fs_info, u64 devid,
 			 struct btrfs_scrub_progress *progress)
 {
+	struct btrfs_dev_lookup_args args = { .devid = devid };
 	struct btrfs_device *dev;
 	struct scrub_ctx *sctx = NULL;
 
 	mutex_lock(&fs_info->fs_devices->device_list_mutex);
-	dev = btrfs_find_device(fs_info->fs_devices, devid, NULL, NULL);
+	dev = btrfs_find_device(fs_info->fs_devices, &args);
 	if (dev)
 		sctx = dev->scrub_ctx;
 	if (sctx)
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index fa68efd7e610..53417a1c5402 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -844,9 +844,13 @@ static noinline struct btrfs_device *device_list_add(const char *path,
 
 		device = NULL;
 	} else {
+		struct btrfs_dev_lookup_args args = {
+			.devid = devid,
+			.uuid = disk_super->dev_item.uuid,
+		};
+
 		mutex_lock(&fs_devices->device_list_mutex);
-		device = btrfs_find_device(fs_devices, devid,
-				disk_super->dev_item.uuid, NULL);
+		device = btrfs_find_device(fs_devices, &args);
 
 		/*
 		 * If this disk has been pulled into an fs devices created by
@@ -2360,10 +2364,9 @@ void btrfs_destroy_dev_replace_tgtdev(struct btrfs_device *tgtdev)
 static struct btrfs_device *btrfs_find_device_by_path(
 		struct btrfs_fs_info *fs_info, const char *device_path)
 {
+	BTRFS_DEV_LOOKUP_ARGS(args);
 	int ret = 0;
 	struct btrfs_super_block *disk_super;
-	u64 devid;
-	u8 *dev_uuid;
 	struct block_device *bdev;
 	struct btrfs_device *device;
 
@@ -2372,14 +2375,14 @@ static struct btrfs_device *btrfs_find_device_by_path(
 	if (ret)
 		return ERR_PTR(ret);
 
-	devid = btrfs_stack_device_id(&disk_super->dev_item);
-	dev_uuid = disk_super->dev_item.uuid;
+	args.devid = btrfs_stack_device_id(&disk_super->dev_item);
+	args.uuid = disk_super->dev_item.uuid;
 	if (btrfs_fs_incompat(fs_info, METADATA_UUID))
-		device = btrfs_find_device(fs_info->fs_devices, devid, dev_uuid,
-					   disk_super->metadata_uuid);
+		args.fsid = disk_super->metadata_uuid;
 	else
-		device = btrfs_find_device(fs_info->fs_devices, devid, dev_uuid,
-					   disk_super->fsid);
+		args.fsid = disk_super->fsid;
+
+	device = btrfs_find_device(fs_info->fs_devices, &args);
 
 	btrfs_release_disk_super(disk_super);
 	if (!device)
@@ -2395,11 +2398,12 @@ struct btrfs_device *btrfs_find_device_by_devspec(
 		struct btrfs_fs_info *fs_info, u64 devid,
 		const char *device_path)
 {
+	BTRFS_DEV_LOOKUP_ARGS(args);
 	struct btrfs_device *device;
 
 	if (devid) {
-		device = btrfs_find_device(fs_info->fs_devices, devid, NULL,
-					   NULL);
+		args.devid = devid;
+		device = btrfs_find_device(fs_info->fs_devices, &args);
 		if (!device)
 			return ERR_PTR(-ENOENT);
 		return device;
@@ -2409,14 +2413,11 @@ struct btrfs_device *btrfs_find_device_by_devspec(
 		return ERR_PTR(-EINVAL);
 
 	if (strcmp(device_path, "missing") == 0) {
-		/* Find first missing device */
-		list_for_each_entry(device, &fs_info->fs_devices->devices,
-				    dev_list) {
-			if (test_bit(BTRFS_DEV_STATE_IN_FS_METADATA,
-				     &device->dev_state) && !device->bdev)
-				return device;
-		}
-		return ERR_PTR(-ENOENT);
+		args.missing = true;
+		device = btrfs_find_device(fs_info->fs_devices, &args);
+		if (!device)
+			return ERR_PTR(-ENOENT);
+		return device;
 	}
 
 	return btrfs_find_device_by_path(fs_info, device_path);
@@ -2496,6 +2497,7 @@ static int btrfs_prepare_sprout(struct btrfs_fs_info *fs_info)
  */
 static int btrfs_finish_sprout(struct btrfs_trans_handle *trans)
 {
+	BTRFS_DEV_LOOKUP_ARGS(args);
 	struct btrfs_fs_info *fs_info = trans->fs_info;
 	struct btrfs_root *root = fs_info->chunk_root;
 	struct btrfs_path *path;
@@ -2505,7 +2507,6 @@ static int btrfs_finish_sprout(struct btrfs_trans_handle *trans)
 	struct btrfs_key key;
 	u8 fs_uuid[BTRFS_FSID_SIZE];
 	u8 dev_uuid[BTRFS_UUID_SIZE];
-	u64 devid;
 	int ret;
 
 	path = btrfs_alloc_path();
@@ -2544,13 +2545,14 @@ static int btrfs_finish_sprout(struct btrfs_trans_handle *trans)
 
 		dev_item = btrfs_item_ptr(leaf, path->slots[0],
 					  struct btrfs_dev_item);
-		devid = btrfs_device_id(leaf, dev_item);
+		args.devid = btrfs_device_id(leaf, dev_item);
 		read_extent_buffer(leaf, dev_uuid, btrfs_device_uuid(dev_item),
 				   BTRFS_UUID_SIZE);
 		read_extent_buffer(leaf, fs_uuid, btrfs_device_fsid(dev_item),
 				   BTRFS_FSID_SIZE);
-		device = btrfs_find_device(fs_info->fs_devices, devid, dev_uuid,
-					   fs_uuid);
+		args.uuid = dev_uuid;
+		args.fsid = fs_uuid;
+		device = btrfs_find_device(fs_info->fs_devices, &args);
 		BUG_ON(!device); /* Logic error */
 
 		if (device->fs_devices->seeding) {
@@ -6805,6 +6807,33 @@ blk_status_t btrfs_map_bio(struct btrfs_fs_info *fs_info, struct bio *bio,
 	return BLK_STS_OK;
 }
 
+static bool dev_args_match_fs_devices(const struct btrfs_dev_lookup_args *args,
+				      const struct btrfs_fs_devices *fs_devices)
+{
+	if (args->fsid == NULL)
+		return true;
+	if (memcmp(fs_devices->metadata_uuid, args->fsid, BTRFS_FSID_SIZE) == 0)
+		return true;
+	return false;
+}
+
+static bool dev_args_match_device(const struct btrfs_dev_lookup_args *args,
+				  const struct btrfs_device *device)
+{
+	ASSERT((args->devid != (u64)-1) || args->missing);
+
+	if ((args->devid != (u64)-1) && device->devid != args->devid)
+		return false;
+	if (args->uuid && memcmp(device->uuid, args->uuid, BTRFS_UUID_SIZE) != 0)
+		return false;
+	if (!args->missing)
+		return true;
+	if (test_bit(BTRFS_DEV_STATE_IN_FS_METADATA, &device->dev_state) &&
+	    !device->bdev)
+		return true;
+	return false;
+}
+
 /*
  * Find a device specified by @devid or @uuid in the list of @fs_devices, or
  * return NULL.
@@ -6812,31 +6841,25 @@ blk_status_t btrfs_map_bio(struct btrfs_fs_info *fs_info, struct bio *bio,
  * If devid and uuid are both specified, the match must be exact, otherwise
  * only devid is used.
  */
-struct btrfs_device *btrfs_find_device(struct btrfs_fs_devices *fs_devices,
-				       u64 devid, u8 *uuid, u8 *fsid)
+struct btrfs_device *btrfs_find_device(const struct btrfs_fs_devices *fs_devices,
+				       const struct btrfs_dev_lookup_args *args)
 {
 	struct btrfs_device *device;
 	struct btrfs_fs_devices *seed_devs;
 
-	if (!fsid || !memcmp(fs_devices->metadata_uuid, fsid, BTRFS_FSID_SIZE)) {
+	if (dev_args_match_fs_devices(args, fs_devices)) {
 		list_for_each_entry(device, &fs_devices->devices, dev_list) {
-			if (device->devid == devid &&
-			    (!uuid || memcmp(device->uuid, uuid,
-					     BTRFS_UUID_SIZE) == 0))
+			if (dev_args_match_device(args, device))
 				return device;
 		}
 	}
 
 	list_for_each_entry(seed_devs, &fs_devices->seed_list, seed_list) {
-		if (!fsid ||
-		    !memcmp(seed_devs->metadata_uuid, fsid, BTRFS_FSID_SIZE)) {
-			list_for_each_entry(device, &seed_devs->devices,
-					    dev_list) {
-				if (device->devid == devid &&
-				    (!uuid || memcmp(device->uuid, uuid,
-						     BTRFS_UUID_SIZE) == 0))
-					return device;
-			}
+		if (!dev_args_match_fs_devices(args, seed_devs))
+			continue;
+		list_for_each_entry(device, &seed_devs->devices, dev_list) {
+			if (dev_args_match_device(args, device))
+				return device;
 		}
 	}
 
@@ -7002,6 +7025,7 @@ static void warn_32bit_meta_chunk(struct btrfs_fs_info *fs_info,
 static int read_one_chunk(struct btrfs_key *key, struct extent_buffer *leaf,
 			  struct btrfs_chunk *chunk)
 {
+	BTRFS_DEV_LOOKUP_ARGS(args);
 	struct btrfs_fs_info *fs_info = leaf->fs_info;
 	struct extent_map_tree *map_tree = &fs_info->mapping_tree;
 	struct map_lookup *map;
@@ -7079,11 +7103,12 @@ static int read_one_chunk(struct btrfs_key *key, struct extent_buffer *leaf,
 		map->stripes[i].physical =
 			btrfs_stripe_offset_nr(leaf, chunk, i);
 		devid = btrfs_stripe_devid_nr(leaf, chunk, i);
+		args.devid = devid;
 		read_extent_buffer(leaf, uuid, (unsigned long)
 				   btrfs_stripe_dev_uuid_nr(chunk, i),
 				   BTRFS_UUID_SIZE);
-		map->stripes[i].dev = btrfs_find_device(fs_info->fs_devices,
-							devid, uuid, NULL);
+		args.uuid = uuid;
+		map->stripes[i].dev = btrfs_find_device(fs_info->fs_devices, &args);
 		if (!map->stripes[i].dev &&
 		    !btrfs_test_opt(fs_info, DEGRADED)) {
 			free_extent_map(em);
@@ -7201,6 +7226,7 @@ static struct btrfs_fs_devices *open_seed_devices(struct btrfs_fs_info *fs_info,
 static int read_one_dev(struct extent_buffer *leaf,
 			struct btrfs_dev_item *dev_item)
 {
+	BTRFS_DEV_LOOKUP_ARGS(args);
 	struct btrfs_fs_info *fs_info = leaf->fs_info;
 	struct btrfs_fs_devices *fs_devices = fs_info->fs_devices;
 	struct btrfs_device *device;
@@ -7209,11 +7235,13 @@ static int read_one_dev(struct extent_buffer *leaf,
 	u8 fs_uuid[BTRFS_FSID_SIZE];
 	u8 dev_uuid[BTRFS_UUID_SIZE];
 
-	devid = btrfs_device_id(leaf, dev_item);
+	devid = args.devid = btrfs_device_id(leaf, dev_item);
 	read_extent_buffer(leaf, dev_uuid, btrfs_device_uuid(dev_item),
 			   BTRFS_UUID_SIZE);
 	read_extent_buffer(leaf, fs_uuid, btrfs_device_fsid(dev_item),
 			   BTRFS_FSID_SIZE);
+	args.uuid = dev_uuid;
+	args.fsid = fs_uuid;
 
 	if (memcmp(fs_uuid, fs_devices->metadata_uuid, BTRFS_FSID_SIZE)) {
 		fs_devices = open_seed_devices(fs_info, fs_uuid);
@@ -7221,8 +7249,7 @@ static int read_one_dev(struct extent_buffer *leaf,
 			return PTR_ERR(fs_devices);
 	}
 
-	device = btrfs_find_device(fs_info->fs_devices, devid, dev_uuid,
-				   fs_uuid);
+	device = btrfs_find_device(fs_info->fs_devices, &args);
 	if (!device) {
 		if (!btrfs_test_opt(fs_info, DEGRADED)) {
 			btrfs_report_missing_device(fs_info, devid,
@@ -7899,12 +7926,14 @@ static void btrfs_dev_stat_print_on_load(struct btrfs_device *dev)
 int btrfs_get_dev_stats(struct btrfs_fs_info *fs_info,
 			struct btrfs_ioctl_get_dev_stats *stats)
 {
+	BTRFS_DEV_LOOKUP_ARGS(args);
 	struct btrfs_device *dev;
 	struct btrfs_fs_devices *fs_devices = fs_info->fs_devices;
 	int i;
 
 	mutex_lock(&fs_devices->device_list_mutex);
-	dev = btrfs_find_device(fs_info->fs_devices, stats->devid, NULL, NULL);
+	args.devid = stats->devid;
+	dev = btrfs_find_device(fs_info->fs_devices, &args);
 	mutex_unlock(&fs_devices->device_list_mutex);
 
 	if (!dev) {
@@ -7980,6 +8009,7 @@ static int verify_one_dev_extent(struct btrfs_fs_info *fs_info,
 				 u64 chunk_offset, u64 devid,
 				 u64 physical_offset, u64 physical_len)
 {
+	struct btrfs_dev_lookup_args args = { .devid = devid };
 	struct extent_map_tree *em_tree = &fs_info->mapping_tree;
 	struct extent_map *em;
 	struct map_lookup *map;
@@ -8035,7 +8065,7 @@ static int verify_one_dev_extent(struct btrfs_fs_info *fs_info,
 	}
 
 	/* Make sure no dev extent is beyond device boundary */
-	dev = btrfs_find_device(fs_info->fs_devices, devid, NULL, NULL);
+	dev = btrfs_find_device(fs_info->fs_devices, &args);
 	if (!dev) {
 		btrfs_err(fs_info, "failed to find devid %llu", devid);
 		ret = -EUCLEAN;
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index d86a6f9f166c..f3b1380f45ad 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -418,6 +418,22 @@ struct btrfs_balance_control {
 	struct btrfs_balance_progress stat;
 };
 
+/*
+ * Search for a given device by the set parameters
+ */
+struct btrfs_dev_lookup_args {
+	u64 devid;
+	u8 *uuid;
+	u8 *fsid;
+	bool missing;
+};
+
+/* We have to initialize to -1 because BTRFS_DEV_REPLACE_DEVID is 0 */
+#define BTRFS_DEV_LOOKUP_ARGS_INIT { .devid = (u64)-1 }
+
+#define BTRFS_DEV_LOOKUP_ARGS(name) \
+	struct btrfs_dev_lookup_args name = BTRFS_DEV_LOOKUP_ARGS_INIT
+
 enum btrfs_map_op {
 	BTRFS_MAP_READ,
 	BTRFS_MAP_WRITE,
@@ -482,8 +498,8 @@ void __exit btrfs_cleanup_fs_uuids(void);
 int btrfs_num_copies(struct btrfs_fs_info *fs_info, u64 logical, u64 len);
 int btrfs_grow_device(struct btrfs_trans_handle *trans,
 		      struct btrfs_device *device, u64 new_size);
-struct btrfs_device *btrfs_find_device(struct btrfs_fs_devices *fs_devices,
-				       u64 devid, u8 *uuid, u8 *fsid);
+struct btrfs_device *btrfs_find_device(const struct btrfs_fs_devices *fs_devices,
+				       const struct btrfs_dev_lookup_args *args);
 int btrfs_shrink_device(struct btrfs_device *device, u64 new_size);
 int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *path);
 int btrfs_balance(struct btrfs_fs_info *fs_info,
-- 
2.35.1



