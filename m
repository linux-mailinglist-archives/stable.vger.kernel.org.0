Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C7C765B01F
	for <lists+stable@lfdr.de>; Mon,  2 Jan 2023 11:57:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230177AbjABK47 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Jan 2023 05:56:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232896AbjABK4d (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Jan 2023 05:56:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C372B98
        for <stable@vger.kernel.org>; Mon,  2 Jan 2023 02:55:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4383BB80D08
        for <stable@vger.kernel.org>; Mon,  2 Jan 2023 10:55:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3FF0C433D2;
        Mon,  2 Jan 2023 10:55:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672656951;
        bh=a23RfBp1BiOfsP1aSfWd4uCvrs1855HsDMR1+VqC5NA=;
        h=Subject:To:Cc:From:Date:From;
        b=JQA0GG5DWz+jPEH48Uh6WxYzvTzjckA3ZmgSVqOnj0BmSYTvfWfsjmDAimUbic5Qc
         qW2CMhRq2LauyMtxr9cUnfnkpObutAe3FwocJme7mWHrGK23HpAl4f8xPwRO417zuS
         nwQcRfbkkEBMBbnqPcEp2ljENXo0i1tnAzVwqlrg=
Subject: FAILED: patch "[PATCH] block: Do not reread partition table on exclusively open" failed to apply to 5.10-stable tree
To:     jack@suse.cz, axboe@kernel.dk
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 02 Jan 2023 11:55:40 +0100
Message-ID: <1672656940140155@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

36369f46e917 ("block: Do not reread partition table on exclusively open device")
704b914f15fb ("blk-mq: move srcu from blk_mq_hw_ctx to request_queue")
2a904d00855f ("blk-mq: remove hctx_lock and hctx_unlock")
1e9c23034d7b ("blk-mq: move more plug handling from blk_mq_submit_bio into blk_add_rq_to_plug")
0c5bcc92d94a ("blk-mq: simplify the plug handling in blk_mq_submit_bio")
e16e506ccd67 ("block: merge disk_scan_partitions and blkdev_reread_part")
95febeb61bf8 ("block: fix missing queue put in error path")
b637108a4022 ("blk-mq: fix filesystem I/O request allocation")
b131f2011115 ("blk-mq: rename blk_attempt_bio_merge")
9ef4d0209cba ("blk-mq: add one API for waiting until quiesce is done")
900e08075202 ("block: move queue enter logic into blk_mq_submit_bio()")
c98cb5bbdab1 ("block: make bio_queue_enter() fast-path available inline")
71539717c105 ("block: split request allocation components into helpers")
a1cb65377e70 ("blk-mq: only try to run plug merge if request has same queue with incoming bio")
781dd830ec4f ("block: move RQF_ELV setting into allocators")
a2247f19ee1c ("block: Add independent access ranges support")
e94f68527a35 ("block: kill extra rcu lock/unlock in queue enter")
179ae84f7ef5 ("block: clean up blk_mq_submit_bio() merging")
a214b949d8e3 ("blk-mq: only flush requests from the plug in blk_mq_submit_bio")
1497a51a3287 ("block: don't bloat enter_queue with percpu_ref")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 36369f46e91785688a5f39d7a5590e3f07981316 Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Wed, 30 Nov 2022 18:56:53 +0100
Subject: [PATCH] block: Do not reread partition table on exclusively open
 device

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

diff --git a/block/blk.h b/block/blk.h
index a8ac9803fcb3..8900001946c7 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -426,7 +426,7 @@ int bio_add_hw_page(struct request_queue *q, struct bio *bio,
 
 struct request_queue *blk_alloc_queue(int node_id);
 
-int disk_scan_partitions(struct gendisk *disk, fmode_t mode);
+int disk_scan_partitions(struct gendisk *disk, fmode_t mode, void *owner);
 
 int disk_alloc_events(struct gendisk *disk);
 void disk_add_events(struct gendisk *disk);
diff --git a/block/genhd.c b/block/genhd.c
index 075d8da284f5..52d71a94a809 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -356,7 +356,7 @@ void disk_uevent(struct gendisk *disk, enum kobject_action action)
 }
 EXPORT_SYMBOL_GPL(disk_uevent);
 
-int disk_scan_partitions(struct gendisk *disk, fmode_t mode)
+int disk_scan_partitions(struct gendisk *disk, fmode_t mode, void *owner)
 {
 	struct block_device *bdev;
 
@@ -366,6 +366,9 @@ int disk_scan_partitions(struct gendisk *disk, fmode_t mode)
 		return -EINVAL;
 	if (disk->open_partitions)
 		return -EBUSY;
+	/* Someone else has bdev exclusively open? */
+	if (disk->part0->bd_holder && disk->part0->bd_holder != owner)
+		return -EBUSY;
 
 	set_bit(GD_NEED_PART_SCAN, &disk->state);
 	bdev = blkdev_get_by_dev(disk_devt(disk), mode, NULL);
@@ -495,7 +498,7 @@ int __must_check device_add_disk(struct device *parent, struct gendisk *disk,
 
 		bdev_add(disk->part0, ddev->devt);
 		if (get_capacity(disk))
-			disk_scan_partitions(disk, FMODE_READ);
+			disk_scan_partitions(disk, FMODE_READ, NULL);
 
 		/*
 		 * Announce the disk and partitions after all partitions are
diff --git a/block/ioctl.c b/block/ioctl.c
index 60121e89052b..96617512982e 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -467,9 +467,10 @@ static int blkdev_bszset(struct block_device *bdev, fmode_t mode,
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
@@ -527,7 +528,8 @@ static int blkdev_common_ioctl(struct block_device *bdev, fmode_t mode,
 			return -EACCES;
 		if (bdev_is_partition(bdev))
 			return -EINVAL;
-		return disk_scan_partitions(bdev->bd_disk, mode & ~FMODE_EXCL);
+		return disk_scan_partitions(bdev->bd_disk, mode & ~FMODE_EXCL,
+					    file);
 	case BLKTRACESTART:
 	case BLKTRACESTOP:
 	case BLKTRACETEARDOWN:
@@ -605,7 +607,7 @@ long blkdev_ioctl(struct file *file, unsigned cmd, unsigned long arg)
 		break;
 	}
 
-	ret = blkdev_common_ioctl(bdev, mode, cmd, arg, argp);
+	ret = blkdev_common_ioctl(file, mode, cmd, arg, argp);
 	if (ret != -ENOIOCTLCMD)
 		return ret;
 
@@ -674,7 +676,7 @@ long compat_blkdev_ioctl(struct file *file, unsigned cmd, unsigned long arg)
 		break;
 	}
 
-	ret = blkdev_common_ioctl(bdev, mode, cmd, arg, argp);
+	ret = blkdev_common_ioctl(file, mode, cmd, arg, argp);
 	if (ret == -ENOIOCTLCMD && disk->fops->compat_ioctl)
 		ret = disk->fops->compat_ioctl(bdev, mode, cmd, arg);
 

