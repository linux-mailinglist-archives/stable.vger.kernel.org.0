Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12E476BB318
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:41:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232901AbjCOMla (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:41:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232891AbjCOMlD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:41:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 592D35DEFF
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:40:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A860F61D51
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:38:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDD80C4339B;
        Wed, 15 Mar 2023 12:38:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678883926;
        bh=1yo2KcCxfaEyofz354vcdGSJanherrkelxMUZOFqUiw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Kp8Df6ywoLgtQESZoggCO+JU9AGEZ7VEmGt0Cg4ZgVC0493+pi9iBVIJknWkuEDpO
         +3P6xD+XI1+iCZRbDkeMenj/dtleOnmsGnY8TOHQpeYkb7sLQU/g5aP9DsL+TpkRnN
         UIIY/adWjhfnPgkn4R/x++XHrTcu08Gj08OcJ1G4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jan Kara <jack@suse.cz>,
        Yu Kuai <yukuai3@huawei.com>, Christoph Hellwig <hch@lst.de>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 041/141] block: fix scan partition for exclusively open device again
Date:   Wed, 15 Mar 2023 13:12:24 +0100
Message-Id: <20230315115741.214538630@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115739.932786806@linuxfoundation.org>
References: <20230315115739.932786806@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yu Kuai <yukuai3@huawei.com>

[ Upstream commit e5cfefa97bccf956ea0bb6464c1f6c84fd7a8d9f ]

As explained in commit 36369f46e917 ("block: Do not reread partition table
on exclusively open device"), reread partition on the device that is
exclusively opened by someone else is problematic.

This patch will make sure partition scan will only be proceed if current
thread open the device exclusively, or the device is not opened
exclusively, and in the later case, other scanners and exclusive openers
will be blocked temporarily until partition scan is done.

Fixes: 10c70d95c0f2 ("block: remove the bd_openers checks in blk_drop_partitions")
Cc: <stable@vger.kernel.org>
Suggested-by: Jan Kara <jack@suse.cz>
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20230217022200.3092987-3-yukuai1@huaweicloud.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/genhd.c | 30 ++++++++++++++++++++++++++----
 block/ioctl.c |  2 +-
 2 files changed, 27 insertions(+), 5 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index fe47071f79e88..6cdaeb7169004 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -359,6 +359,7 @@ EXPORT_SYMBOL_GPL(disk_uevent);
 int disk_scan_partitions(struct gendisk *disk, fmode_t mode)
 {
 	struct block_device *bdev;
+	int ret = 0;
 
 	if (disk->flags & (GENHD_FL_NO_PART | GENHD_FL_HIDDEN))
 		return -EINVAL;
@@ -368,11 +369,27 @@ int disk_scan_partitions(struct gendisk *disk, fmode_t mode)
 		return -EBUSY;
 
 	set_bit(GD_NEED_PART_SCAN, &disk->state);
-	bdev = blkdev_get_by_dev(disk_devt(disk), mode, NULL);
+	/*
+	 * If the device is opened exclusively by current thread already, it's
+	 * safe to scan partitons, otherwise, use bd_prepare_to_claim() to
+	 * synchronize with other exclusive openers and other partition
+	 * scanners.
+	 */
+	if (!(mode & FMODE_EXCL)) {
+		ret = bd_prepare_to_claim(disk->part0, disk_scan_partitions);
+		if (ret)
+			return ret;
+	}
+
+	bdev = blkdev_get_by_dev(disk_devt(disk), mode & ~FMODE_EXCL, NULL);
 	if (IS_ERR(bdev))
-		return PTR_ERR(bdev);
-	blkdev_put(bdev, mode);
-	return 0;
+		ret =  PTR_ERR(bdev);
+	else
+		blkdev_put(bdev, mode);
+
+	if (!(mode & FMODE_EXCL))
+		bd_abort_claiming(disk->part0, disk_scan_partitions);
+	return ret;
 }
 
 /**
@@ -494,6 +511,11 @@ int __must_check device_add_disk(struct device *parent, struct gendisk *disk,
 		if (ret)
 			goto out_unregister_bdi;
 
+		/* Make sure the first partition scan will be proceed */
+		if (get_capacity(disk) && !(disk->flags & GENHD_FL_NO_PART) &&
+		    !test_bit(GD_SUPPRESS_PART_SCAN, &disk->state))
+			set_bit(GD_NEED_PART_SCAN, &disk->state);
+
 		bdev_add(disk->part0, ddev->devt);
 		if (get_capacity(disk))
 			disk_scan_partitions(disk, FMODE_READ);
diff --git a/block/ioctl.c b/block/ioctl.c
index 6dd49d877584a..9c5f637ff153f 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -528,7 +528,7 @@ static int blkdev_common_ioctl(struct block_device *bdev, fmode_t mode,
 			return -EACCES;
 		if (bdev_is_partition(bdev))
 			return -EINVAL;
-		return disk_scan_partitions(bdev->bd_disk, mode & ~FMODE_EXCL);
+		return disk_scan_partitions(bdev->bd_disk, mode);
 	case BLKTRACESTART:
 	case BLKTRACESTOP:
 	case BLKTRACETEARDOWN:
-- 
2.39.2



