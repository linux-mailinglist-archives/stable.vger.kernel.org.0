Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7DED4505D2
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 14:43:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234939AbhKONqd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 08:46:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:51378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231833AbhKONmA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 08:42:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 424516322A;
        Mon, 15 Nov 2021 13:39:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636983544;
        bh=+nzGqJjtCHiG4tHhl4vCQQ7KhI89Vvcs4vIdqk3J5VU=;
        h=Subject:To:Cc:From:Date:From;
        b=eMl3pg1SrPdYD02gRijx93t7Wzy/+rL/lMeES+YfO9ycfvioVmXnM+sM/+3jrsowp
         F4ZtXlKOBwga+hxS0f1MM/bJHYCu1iRaiSj8u1LQsxCv2Go0IUh1NudgWIei6JYURr
         IXZghJWFpofKXTbStc9iXOh5+ycBL+9SBCRvJpx0=
Subject: FAILED: patch "[PATCH] block: Hold invalidate_lock in BLKZEROOUT ioctl" failed to apply to 5.4-stable tree
To:     shinichiro.kawasaki@wdc.com, axboe@kernel.dk, jack@suse.cz
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 15 Nov 2021 14:38:49 +0100
Message-ID: <16369835292598@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 35e4c6c1a2fc2eb11b9306e95cda1fa06a511948 Mon Sep 17 00:00:00 2001
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Date: Tue, 9 Nov 2021 19:47:23 +0900
Subject: [PATCH] block: Hold invalidate_lock in BLKZEROOUT ioctl

When BLKZEROOUT ioctl and data read race, the data read leaves stale
page cache. To avoid the stale page cache, hold invalidate_lock of the
block device file mapping. The stale page cache is observed when
blktests test case block/009 is modified to call "blkdiscard -z" command
and repeated hundreds of times.

This patch can be applied back to the stable kernel version v5.15.y.
Rework is required for older stable kernels.

Fixes: 22dd6d356628 ("block: invalidate the page cache when issuing BLKZEROOUT")
Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc: stable@vger.kernel.org # v5.15
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20211109104723.835533-3-shinichiro.kawasaki@wdc.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/block/ioctl.c b/block/ioctl.c
index 9fa87f64f703..0a1d10ac2e1a 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -154,6 +154,7 @@ static int blk_ioctl_zeroout(struct block_device *bdev, fmode_t mode,
 {
 	uint64_t range[2];
 	uint64_t start, end, len;
+	struct inode *inode = bdev->bd_inode;
 	int err;
 
 	if (!(mode & FMODE_WRITE))
@@ -176,12 +177,17 @@ static int blk_ioctl_zeroout(struct block_device *bdev, fmode_t mode,
 		return -EINVAL;
 
 	/* Invalidate the page cache, including dirty pages */
+	filemap_invalidate_lock(inode->i_mapping);
 	err = truncate_bdev_range(bdev, mode, start, end);
 	if (err)
-		return err;
+		goto fail;
+
+	err = blkdev_issue_zeroout(bdev, start >> 9, len >> 9, GFP_KERNEL,
+				   BLKDEV_ZERO_NOUNMAP);
 
-	return blkdev_issue_zeroout(bdev, start >> 9, len >> 9, GFP_KERNEL,
-			BLKDEV_ZERO_NOUNMAP);
+fail:
+	filemap_invalidate_unlock(inode->i_mapping);
+	return err;
 }
 
 static int put_ushort(unsigned short __user *argp, unsigned short val)

