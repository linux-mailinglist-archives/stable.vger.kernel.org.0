Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E84AC451E71
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:33:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347495AbhKPAgG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:36:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:45204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344951AbhKOTZs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:25:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E0184633FA;
        Mon, 15 Nov 2021 19:07:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637003251;
        bh=bXaezZ6kRGfsjCKqfL5Q0OUnyboOsqDAJWO8aekBPwI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r2kk1B+GtMUSxNv2D0cU00GLU2pl6gfmDUkhuw6oSK8NsRB9fp9eNO/kdxz6+YO5q
         i5x9IB6kV910ipCxneHSBxJP/0OtoKk2KzQ4ynaICQvQhJXkHvrYAjYW2vAOjY7e9A
         +Y2NshaGowx+31QSyhMzF8Aq5WfzK/Qvryb43owg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        Jan Kara <jack@suse.cz>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.15 866/917] block: Hold invalidate_lock in BLKDISCARD ioctl
Date:   Mon, 15 Nov 2021 18:06:01 +0100
Message-Id: <20211115165458.404242156@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>

commit 7607c44c157d343223510c8ffdf7206fdd2a6213 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/ioctl.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -113,6 +113,7 @@ static int blk_ioctl_discard(struct bloc
 	uint64_t range[2];
 	uint64_t start, len;
 	struct request_queue *q = bdev_get_queue(bdev);
+	struct inode *inode = bdev->bd_inode;
 	int err;
 
 	if (!(mode & FMODE_WRITE))
@@ -135,12 +136,17 @@ static int blk_ioctl_discard(struct bloc
 	if (start + len > i_size_read(bdev->bd_inode))
 		return -EINVAL;
 
+	filemap_invalidate_lock(inode->i_mapping);
 	err = truncate_bdev_range(bdev, mode, start, start + len - 1);
 	if (err)
-		return err;
+		goto fail;
 
-	return blkdev_issue_discard(bdev, start >> 9, len >> 9,
-				    GFP_KERNEL, flags);
+	err = blkdev_issue_discard(bdev, start >> 9, len >> 9,
+				   GFP_KERNEL, flags);
+
+fail:
+	filemap_invalidate_unlock(inode->i_mapping);
+	return err;
 }
 
 static int blk_ioctl_zeroout(struct block_device *bdev, fmode_t mode,


