Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AEE44505B8
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 14:40:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231764AbhKONmt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 08:42:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:51086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234821AbhKONlY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 08:41:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 43F8A61A82;
        Mon, 15 Nov 2021 13:38:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636983508;
        bh=zbv7O8FO398OSYUEPx9XRNy2GjgB/L7le0F4z6c/4mg=;
        h=Subject:To:Cc:From:Date:From;
        b=vF37WvBfmvfSDWWpgVlG4/iGz6HFNtKEJRTKf5X4dzKS2nj9KXO1qjF0hMixxwffx
         rNNcyn2QouCToK+cSh89PDaZVuHJ+gVBE9LeDSbbcoexvzdjV44e2DKqAxT8GcC0hr
         2RIQASPG/waipm/7ZvOKRSmv92sXQOTbibtNoIc8=
Subject: FAILED: patch "[PATCH] block: Hold invalidate_lock in BLKDISCARD ioctl" failed to apply to 5.4-stable tree
To:     shinichiro.kawasaki@wdc.com, axboe@kernel.dk, jack@suse.cz
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 15 Nov 2021 14:38:26 +0100
Message-ID: <16369835066386@kroah.com>
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

From 7607c44c157d343223510c8ffdf7206fdd2a6213 Mon Sep 17 00:00:00 2001
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Date: Tue, 9 Nov 2021 19:47:22 +0900
Subject: [PATCH] block: Hold invalidate_lock in BLKDISCARD ioctl

When BLKDISCARD ioctl and data read race, the data read leaves stale
page cache. To avoid the stale page cache, hold invalidate_lock of the
block device file mapping. The stale page cache is observed when
blktests test case block/009 is repeated hundreds of times.

This patch can be applied back to the stable kernel version v5.15.y
with slight patch edit. Rework is required for older stable kernels.

Fixes: 351499a172c0 ("block: Invalidate cache on discard v2")
Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc: stable@vger.kernel.org # v5.15
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20211109104723.835533-2-shinichiro.kawasaki@wdc.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/block/ioctl.c b/block/ioctl.c
index d6af0ac97e57..9fa87f64f703 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -113,6 +113,7 @@ static int blk_ioctl_discard(struct block_device *bdev, fmode_t mode,
 	uint64_t range[2];
 	uint64_t start, len;
 	struct request_queue *q = bdev_get_queue(bdev);
+	struct inode *inode = bdev->bd_inode;
 	int err;
 
 	if (!(mode & FMODE_WRITE))
@@ -135,12 +136,17 @@ static int blk_ioctl_discard(struct block_device *bdev, fmode_t mode,
 	if (start + len > bdev_nr_bytes(bdev))
 		return -EINVAL;
 
+	filemap_invalidate_lock(inode->i_mapping);
 	err = truncate_bdev_range(bdev, mode, start, start + len - 1);
 	if (err)
-		return err;
+		goto fail;
+
+	err = blkdev_issue_discard(bdev, start >> 9, len >> 9,
+				   GFP_KERNEL, flags);
 
-	return blkdev_issue_discard(bdev, start >> 9, len >> 9,
-				    GFP_KERNEL, flags);
+fail:
+	filemap_invalidate_unlock(inode->i_mapping);
+	return err;
 }
 
 static int blk_ioctl_zeroout(struct block_device *bdev, fmode_t mode,

