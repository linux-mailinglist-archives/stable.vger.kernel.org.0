Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1ACE56FCC7
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:48:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233580AbiGKJsG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:48:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230465AbiGKJre (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:47:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32173AB7C7;
        Mon, 11 Jul 2022 02:23:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 72C9F61361;
        Mon, 11 Jul 2022 09:23:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82633C341C0;
        Mon, 11 Jul 2022 09:23:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531390;
        bh=4g8ckDjMfPAgYHdj3FDaYCIvYJD0IeClaQPl02qoew0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QNR7l1tbj9larK66B+M7vfbCXFW8sBhho82T0uBREsLWLbi6HjsgsHmjJ+NzOKg9h
         /izC0q6tN/rNNqg4pW0tsigY9KhTkr5/Tb/N39TVKzN7tlwIXxL1b428mAaWJIaapZ
         pqRs53dm4odnpt3LejoawITx1FZaAarSvYwjy4RE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>,
        Anand Jain <anand.jain@oracle.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 086/230] btrfs: add a btrfs_get_dev_args_from_path helper
Date:   Mon, 11 Jul 2022 11:05:42 +0200
Message-Id: <20220711090606.512344336@linuxfoundation.org>
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

[ Upstream commit faa775c41d655a4786e9d53cb075a77bb5a75f66 ]

We are going to want to populate our device lookup args outside of any
locks and then do the actual device lookup later, so add a helper to do
this work and make btrfs_find_device_by_devspec() use this helper for
now.

Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Reviewed-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/volumes.c | 96 ++++++++++++++++++++++++++++++----------------
 fs/btrfs/volumes.h |  4 ++
 2 files changed, 68 insertions(+), 32 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 53417a1c5402..8d09e6d442b2 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2361,45 +2361,81 @@ void btrfs_destroy_dev_replace_tgtdev(struct btrfs_device *tgtdev)
 	btrfs_free_device(tgtdev);
 }
 
-static struct btrfs_device *btrfs_find_device_by_path(
-		struct btrfs_fs_info *fs_info, const char *device_path)
+/**
+ * Populate args from device at path
+ *
+ * @fs_info:	the filesystem
+ * @args:	the args to populate
+ * @path:	the path to the device
+ *
+ * This will read the super block of the device at @path and populate @args with
+ * the devid, fsid, and uuid.  This is meant to be used for ioctls that need to
+ * lookup a device to operate on, but need to do it before we take any locks.
+ * This properly handles the special case of "missing" that a user may pass in,
+ * and does some basic sanity checks.  The caller must make sure that @path is
+ * properly NUL terminated before calling in, and must call
+ * btrfs_put_dev_args_from_path() in order to free up the temporary fsid and
+ * uuid buffers.
+ *
+ * Return: 0 for success, -errno for failure
+ */
+int btrfs_get_dev_args_from_path(struct btrfs_fs_info *fs_info,
+				 struct btrfs_dev_lookup_args *args,
+				 const char *path)
 {
-	BTRFS_DEV_LOOKUP_ARGS(args);
-	int ret = 0;
 	struct btrfs_super_block *disk_super;
 	struct block_device *bdev;
-	struct btrfs_device *device;
+	int ret;
 
-	ret = btrfs_get_bdev_and_sb(device_path, FMODE_READ,
-				    fs_info->bdev_holder, 0, &bdev, &disk_super);
-	if (ret)
-		return ERR_PTR(ret);
+	if (!path || !path[0])
+		return -EINVAL;
+	if (!strcmp(path, "missing")) {
+		args->missing = true;
+		return 0;
+	}
+
+	args->uuid = kzalloc(BTRFS_UUID_SIZE, GFP_KERNEL);
+	args->fsid = kzalloc(BTRFS_FSID_SIZE, GFP_KERNEL);
+	if (!args->uuid || !args->fsid) {
+		btrfs_put_dev_args_from_path(args);
+		return -ENOMEM;
+	}
 
-	args.devid = btrfs_stack_device_id(&disk_super->dev_item);
-	args.uuid = disk_super->dev_item.uuid;
+	ret = btrfs_get_bdev_and_sb(path, FMODE_READ, fs_info->bdev_holder, 0,
+				    &bdev, &disk_super);
+	if (ret)
+		return ret;
+	args->devid = btrfs_stack_device_id(&disk_super->dev_item);
+	memcpy(args->uuid, disk_super->dev_item.uuid, BTRFS_UUID_SIZE);
 	if (btrfs_fs_incompat(fs_info, METADATA_UUID))
-		args.fsid = disk_super->metadata_uuid;
+		memcpy(args->fsid, disk_super->metadata_uuid, BTRFS_FSID_SIZE);
 	else
-		args.fsid = disk_super->fsid;
-
-	device = btrfs_find_device(fs_info->fs_devices, &args);
-
+		memcpy(args->fsid, disk_super->fsid, BTRFS_FSID_SIZE);
 	btrfs_release_disk_super(disk_super);
-	if (!device)
-		device = ERR_PTR(-ENOENT);
 	blkdev_put(bdev, FMODE_READ);
-	return device;
+	return 0;
 }
 
 /*
- * Lookup a device given by device id, or the path if the id is 0.
+ * Only use this jointly with btrfs_get_dev_args_from_path() because we will
+ * allocate our ->uuid and ->fsid pointers, everybody else uses local variables
+ * that don't need to be freed.
  */
+void btrfs_put_dev_args_from_path(struct btrfs_dev_lookup_args *args)
+{
+	kfree(args->uuid);
+	kfree(args->fsid);
+	args->uuid = NULL;
+	args->fsid = NULL;
+}
+
 struct btrfs_device *btrfs_find_device_by_devspec(
 		struct btrfs_fs_info *fs_info, u64 devid,
 		const char *device_path)
 {
 	BTRFS_DEV_LOOKUP_ARGS(args);
 	struct btrfs_device *device;
+	int ret;
 
 	if (devid) {
 		args.devid = devid;
@@ -2409,18 +2445,14 @@ struct btrfs_device *btrfs_find_device_by_devspec(
 		return device;
 	}
 
-	if (!device_path || !device_path[0])
-		return ERR_PTR(-EINVAL);
-
-	if (strcmp(device_path, "missing") == 0) {
-		args.missing = true;
-		device = btrfs_find_device(fs_info->fs_devices, &args);
-		if (!device)
-			return ERR_PTR(-ENOENT);
-		return device;
-	}
-
-	return btrfs_find_device_by_path(fs_info, device_path);
+	ret = btrfs_get_dev_args_from_path(fs_info, &args, device_path);
+	if (ret)
+		return ERR_PTR(ret);
+	device = btrfs_find_device(fs_info->fs_devices, &args);
+	btrfs_put_dev_args_from_path(&args);
+	if (!device)
+		return ERR_PTR(-ENOENT);
+	return device;
 }
 
 /*
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index f3b1380f45ad..d1df03f77e29 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -487,9 +487,13 @@ void btrfs_assign_next_active_device(struct btrfs_device *device,
 struct btrfs_device *btrfs_find_device_by_devspec(struct btrfs_fs_info *fs_info,
 						  u64 devid,
 						  const char *devpath);
+int btrfs_get_dev_args_from_path(struct btrfs_fs_info *fs_info,
+				 struct btrfs_dev_lookup_args *args,
+				 const char *path);
 struct btrfs_device *btrfs_alloc_device(struct btrfs_fs_info *fs_info,
 					const u64 *devid,
 					const u8 *uuid);
+void btrfs_put_dev_args_from_path(struct btrfs_dev_lookup_args *args);
 void btrfs_free_device(struct btrfs_device *device);
 int btrfs_rm_device(struct btrfs_fs_info *fs_info,
 		    const char *device_path, u64 devid,
-- 
2.35.1



