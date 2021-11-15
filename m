Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7028E451EB0
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:34:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355236AbhKPAhC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:37:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:45126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344952AbhKOTZs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:25:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3F879633FB;
        Mon, 15 Nov 2021 19:07:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637003256;
        bh=YI6vuhFoBARpnvomaPXM4N40l3/JoAzU5yjJxvzhHYI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FFeBGftqxaJsfDjMX1rZr/j02VfaemOAfO3+x0yAv20YWXAwK2SwgQVoQrqraRDDy
         2xvNlEhSAYjzSO95OZvPqRruwDXNLQZwQdKmJyVWlDdYoccOCLk7rxdisN8uYgDynz
         tnsjNyP2eWbq7cwVPoqFRQkBhjkLZuCvRmui4wiw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        Jan Kara <jack@suse.cz>, Ming Lei <ming.lei@redhat.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.15 868/917] block: Hold invalidate_lock in BLKRESETZONE ioctl
Date:   Mon, 15 Nov 2021 18:06:03 +0100
Message-Id: <20211115165458.479820634@linuxfoundation.org>
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

commit 86399ea071099ec8ee0a83ac9ad67f7df96a50ad upstream.

When BLKRESETZONE ioctl and data read race, the data read leaves stale
page cache. The commit e5113505904e ("block: Discard page cache of zone
reset target range") added page cache truncation to avoid stale page
cache after the ioctl. However, the stale page cache still can be read
during the reset zone operation for the ioctl. To avoid the stale page
cache completely, hold invalidate_lock of the block device file mapping.

Fixes: e5113505904e ("block: Discard page cache of zone reset target range")
Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc: stable@vger.kernel.org # v5.15
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Link: https://lore.kernel.org/r/20211111085238.942492-1-shinichiro.kawasaki@wdc.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/blk-zoned.c |   15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -429,9 +429,10 @@ int blkdev_zone_mgmt_ioctl(struct block_
 		op = REQ_OP_ZONE_RESET;
 
 		/* Invalidate the page cache, including dirty pages. */
+		filemap_invalidate_lock(bdev->bd_inode->i_mapping);
 		ret = blkdev_truncate_zone_range(bdev, mode, &zrange);
 		if (ret)
-			return ret;
+			goto fail;
 		break;
 	case BLKOPENZONE:
 		op = REQ_OP_ZONE_OPEN;
@@ -449,15 +450,9 @@ int blkdev_zone_mgmt_ioctl(struct block_
 	ret = blkdev_zone_mgmt(bdev, op, zrange.sector, zrange.nr_sectors,
 			       GFP_KERNEL);
 
-	/*
-	 * Invalidate the page cache again for zone reset: writes can only be
-	 * direct for zoned devices so concurrent writes would not add any page
-	 * to the page cache after/during reset. The page cache may be filled
-	 * again due to concurrent reads though and dropping the pages for
-	 * these is fine.
-	 */
-	if (!ret && cmd == BLKRESETZONE)
-		ret = blkdev_truncate_zone_range(bdev, mode, &zrange);
+fail:
+	if (cmd == BLKRESETZONE)
+		filemap_invalidate_unlock(bdev->bd_inode->i_mapping);
 
 	return ret;
 }


