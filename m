Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 508F965B132
	for <lists+stable@lfdr.de>; Mon,  2 Jan 2023 12:31:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235952AbjABLbD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Jan 2023 06:31:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236161AbjABLaS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Jan 2023 06:30:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50A5C64D6
        for <stable@vger.kernel.org>; Mon,  2 Jan 2023 03:30:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E1E8A60F21
        for <stable@vger.kernel.org>; Mon,  2 Jan 2023 11:30:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01233C433EF;
        Mon,  2 Jan 2023 11:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672659006;
        bh=hVP9hppalFoxEyMc/MrU3ur0YK6Vixt6XX7v7RUcVO4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M6H+IbR0c/3qQdBxCARJaO2hu/0rVgAdiVpGEckp1k0tyEiiHpuAfjhmO/ktEniCE
         ASVtj2I8r1HbvkW4erpUZ+3hplVGOHNUtydlsd8ZThznBAutpiphR7DksgGBBe3O07
         UOJOKxZbIs58I3WYmZbJU94TALuZ1/WdGVCyKBY0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jan Kara <jack@suse.cz>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.0 68/74] block: Do not reread partition table on exclusively open device
Date:   Mon,  2 Jan 2023 12:22:41 +0100
Message-Id: <20230102110554.997273585@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230102110552.061937047@linuxfoundation.org>
References: <20230102110552.061937047@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kara <jack@suse.cz>

commit 36369f46e91785688a5f39d7a5590e3f07981316 upstream.

Since commit 10c70d95c0f2 ("block: remove the bd_openers checks in
blk_drop_partitions") we allow rereading of partition table although
there are users of the block device. This has an undesirable consequence
that e.g. if sda and sdb are assembled to a RAID1 device md0 with
partitions, BLKRRPART ioctl on sda will rescan partition table and
create sda1 device. This partition device under a raid device confuses
some programs (such as libstorage-ng used for initial partitioning for
distribution installation) leading to failures.

Fix the problem refusing to rescan partitions if there is another user
that has the block device exclusively open.

Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/all/20221130135344.2ul4cyfstfs3znxg@quack3
Fixes: 10c70d95c0f2 ("block: remove the bd_openers checks in blk_drop_partitions")
Signed-off-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20221130175653.24299-1-jack@suse.cz
[axboe: fold in followup fix]
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/blk.h   |    2 +-
 block/genhd.c |    7 +++++--
 block/ioctl.c |   12 +++++++-----
 3 files changed, 13 insertions(+), 8 deletions(-)

--- a/block/blk.h
+++ b/block/blk.h
@@ -429,7 +429,7 @@ static inline struct kmem_cache *blk_get
 }
 struct request_queue *blk_alloc_queue(int node_id, bool alloc_srcu);
 
-int disk_scan_partitions(struct gendisk *disk, fmode_t mode);
+int disk_scan_partitions(struct gendisk *disk, fmode_t mode, void *owner);
 
 int disk_alloc_events(struct gendisk *disk);
 void disk_add_events(struct gendisk *disk);
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -356,7 +356,7 @@ void disk_uevent(struct gendisk *disk, e
 }
 EXPORT_SYMBOL_GPL(disk_uevent);
 
-int disk_scan_partitions(struct gendisk *disk, fmode_t mode)
+int disk_scan_partitions(struct gendisk *disk, fmode_t mode, void *owner)
 {
 	struct block_device *bdev;
 
@@ -366,6 +366,9 @@ int disk_scan_partitions(struct gendisk
 		return -EINVAL;
 	if (disk->open_partitions)
 		return -EBUSY;
+	/* Someone else has bdev exclusively open? */
+	if (disk->part0->bd_holder && disk->part0->bd_holder != owner)
+		return -EBUSY;
 
 	set_bit(GD_NEED_PART_SCAN, &disk->state);
 	bdev = blkdev_get_by_dev(disk_devt(disk), mode, NULL);
@@ -499,7 +502,7 @@ int __must_check device_add_disk(struct
 
 		bdev_add(disk->part0, ddev->devt);
 		if (get_capacity(disk))
-			disk_scan_partitions(disk, FMODE_READ);
+			disk_scan_partitions(disk, FMODE_READ, NULL);
 
 		/*
 		 * Announce the disk and partitions after all partitions are
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -467,9 +467,10 @@ static int blkdev_bszset(struct block_de
  * user space. Note the separate arg/argp parameters that are needed
  * to deal with the compat_ptr() conversion.
  */
-static int blkdev_common_ioctl(struct block_device *bdev, fmode_t mode,
-				unsigned cmd, unsigned long arg, void __user *argp)
+static int blkdev_common_ioctl(struct file *file, fmode_t mode, unsigned cmd,
+			       unsigned long arg, void __user *argp)
 {
+	struct block_device *bdev = I_BDEV(file->f_mapping->host);
 	unsigned int max_sectors;
 
 	switch (cmd) {
@@ -527,7 +528,8 @@ static int blkdev_common_ioctl(struct bl
 			return -EACCES;
 		if (bdev_is_partition(bdev))
 			return -EINVAL;
-		return disk_scan_partitions(bdev->bd_disk, mode & ~FMODE_EXCL);
+		return disk_scan_partitions(bdev->bd_disk, mode & ~FMODE_EXCL,
+					    file);
 	case BLKTRACESTART:
 	case BLKTRACESTOP:
 	case BLKTRACETEARDOWN:
@@ -605,7 +607,7 @@ long blkdev_ioctl(struct file *file, uns
 		break;
 	}
 
-	ret = blkdev_common_ioctl(bdev, mode, cmd, arg, argp);
+	ret = blkdev_common_ioctl(file, mode, cmd, arg, argp);
 	if (ret != -ENOIOCTLCMD)
 		return ret;
 
@@ -674,7 +676,7 @@ long compat_blkdev_ioctl(struct file *fi
 		break;
 	}
 
-	ret = blkdev_common_ioctl(bdev, mode, cmd, arg, argp);
+	ret = blkdev_common_ioctl(file, mode, cmd, arg, argp);
 	if (ret == -ENOIOCTLCMD && disk->fops->compat_ioctl)
 		ret = disk->fops->compat_ioctl(bdev, mode, cmd, arg);
 


