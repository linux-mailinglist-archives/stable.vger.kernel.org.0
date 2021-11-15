Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 742DE451E70
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:33:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355156AbhKPAgG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:36:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:45398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344953AbhKOTZs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:25:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C079763263;
        Mon, 15 Nov 2021 19:07:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637003254;
        bh=bpQbNlBDfYiGrDNLjJfu9EWC4GMElJxzaOPd2x4XDmw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hkOUZqH0JDdzWdBX5nzOO3Ba8FRD8pDHTJO+vAhrs4JrssBPjVa+NlMWOPl95i2jf
         FsE2S66g9gPE5TkdNfhymoiABngVvtz8T0PRzyTTVv0+nC3fbCj3twtQUsd/iB3B+2
         t9rIbQ0PRwkFIk9lAu6yn/Q1d/td39MdKgzSvaow=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        Jan Kara <jack@suse.cz>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.15 867/917] block: Hold invalidate_lock in BLKZEROOUT ioctl
Date:   Mon, 15 Nov 2021 18:06:02 +0100
Message-Id: <20211115165458.441677235@linuxfoundation.org>
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

commit 35e4c6c1a2fc2eb11b9306e95cda1fa06a511948 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/ioctl.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -154,6 +154,7 @@ static int blk_ioctl_zeroout(struct bloc
 {
 	uint64_t range[2];
 	uint64_t start, end, len;
+	struct inode *inode = bdev->bd_inode;
 	int err;
 
 	if (!(mode & FMODE_WRITE))
@@ -176,12 +177,17 @@ static int blk_ioctl_zeroout(struct bloc
 		return -EINVAL;
 
 	/* Invalidate the page cache, including dirty pages */
+	filemap_invalidate_lock(inode->i_mapping);
 	err = truncate_bdev_range(bdev, mode, start, end);
 	if (err)
-		return err;
+		goto fail;
 
-	return blkdev_issue_zeroout(bdev, start >> 9, len >> 9, GFP_KERNEL,
-			BLKDEV_ZERO_NOUNMAP);
+	err = blkdev_issue_zeroout(bdev, start >> 9, len >> 9, GFP_KERNEL,
+				   BLKDEV_ZERO_NOUNMAP);
+
+fail:
+	filemap_invalidate_unlock(inode->i_mapping);
+	return err;
 }
 
 static int put_ushort(unsigned short __user *argp, unsigned short val)


