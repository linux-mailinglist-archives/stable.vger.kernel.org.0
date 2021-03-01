Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0516A32911A
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:22:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243235AbhCAUTA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:19:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:39930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238647AbhCAUMI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:12:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 92FD2653BA;
        Mon,  1 Mar 2021 18:01:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621663;
        bh=pJokFcR22i4jiWQom5ex45sXALWtsD+4HzfOGH8DOSM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GBumYwvxrPb2Pd2Fu+CYA3NKSh9RlupMTTsjs/qBGCxYJVS1uKDL4lI5m+aJkRqrR
         BPZzniQyEGMco4hMJk4bx6yDfKsiFP3+DT//HJUrJj9HYCPsJ+EQGCdmF383vRcgsP
         CLsD8+CBiLVpedO0LiYZI0PY+PIN/S+hNmSlUQ2k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Tom Seewald <tseewald@gmail.com>,
        Ming Lei <ming.lei@redhat.com>,
        Minwoo Im <minwoo.im.dev@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 568/775] block: reopen the device in blkdev_reread_part
Date:   Mon,  1 Mar 2021 17:12:16 +0100
Message-Id: <20210301161229.534271062@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 4601b4b130de2329fe06df80ed5d77265f2058e5 ]

Historically the BLKRRPART ioctls called into the now defunct ->revalidate
method, which caused the sd driver to check if any media is present.
When the ->revalidate method was removed this revalidation was lost,
leading to lots of I/O errors when using the eject command.  Fix this by
reopening the device to rescan the partitions, and thus calling the
revalidation logic in the sd driver.

Fixes: 471bd0af544b ("sd: use bdev_check_media_change")
Reported--by: Tom Seewald <tseewald@gmail.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Tested-by: Tom Seewald <tseewald@gmail.com>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Reviewed-by: Minwoo Im <minwoo.im.dev@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/ioctl.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/block/ioctl.c b/block/ioctl.c
index d61d652078f41..ff241e663c018 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -81,20 +81,27 @@ static int compat_blkpg_ioctl(struct block_device *bdev,
 }
 #endif
 
-static int blkdev_reread_part(struct block_device *bdev)
+static int blkdev_reread_part(struct block_device *bdev, fmode_t mode)
 {
-	int ret;
+	struct block_device *tmp;
 
 	if (!disk_part_scan_enabled(bdev->bd_disk) || bdev_is_partition(bdev))
 		return -EINVAL;
 	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
 
-	mutex_lock(&bdev->bd_mutex);
-	ret = bdev_disk_changed(bdev, false);
-	mutex_unlock(&bdev->bd_mutex);
+	/*
+	 * Reopen the device to revalidate the driver state and force a
+	 * partition rescan.
+	 */
+	mode &= ~FMODE_EXCL;
+	set_bit(GD_NEED_PART_SCAN, &bdev->bd_disk->state);
 
-	return ret;
+	tmp = blkdev_get_by_dev(bdev->bd_dev, mode, NULL);
+	if (IS_ERR(tmp))
+		return PTR_ERR(tmp);
+	blkdev_put(tmp, mode);
+	return 0;
 }
 
 static int blk_ioctl_discard(struct block_device *bdev, fmode_t mode,
@@ -498,7 +505,7 @@ static int blkdev_common_ioctl(struct block_device *bdev, fmode_t mode,
 		bdev->bd_bdi->ra_pages = (arg * 512) / PAGE_SIZE;
 		return 0;
 	case BLKRRPART:
-		return blkdev_reread_part(bdev);
+		return blkdev_reread_part(bdev, mode);
 	case BLKTRACESTART:
 	case BLKTRACESTOP:
 	case BLKTRACETEARDOWN:
-- 
2.27.0



