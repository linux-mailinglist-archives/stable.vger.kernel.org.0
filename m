Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA764441820
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:42:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231830AbhKAJos (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:44:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:47856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232935AbhKAJls (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:41:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1FD3B6120F;
        Mon,  1 Nov 2021 09:28:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635758891;
        bh=gWBYAUfBEKjU6FiIFdYBt9YbBlJQNBjaIQBbzEuM6a4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W+WTR9n+kyjTeMB3PJfYnIsdXYk/IirGkKxbS2W+XZ2rIdIqhGESSuDcvsftO1szR
         XZXwww060QplVC7L8V1OhJ3vHpJxfLBEFeMD4rRa66jvOqCYuYV3QwsCM6oPtbhVl2
         WLV5w/3cWIcCVG741+lAUyC5DKoO8cafayvjmSLc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.14 025/125] block: Fix partition check for host-aware zoned block devices
Date:   Mon,  1 Nov 2021 10:16:38 +0100
Message-Id: <20211101082538.183568185@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082533.618411490@linuxfoundation.org>
References: <20211101082533.618411490@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>

commit e0c60d0102a5ad3475401e1a2faa3d3623eefce4 upstream.

Commit a33df75c6328 ("block: use an xarray for disk->part_tbl") modified
the method to check partition existence in host-aware zoned block
devices from disk_has_partitions() helper function call to empty check
of xarray disk->part_tbl. However, disk->part_tbl always has single
entry for disk->part0 and never becomes empty. This resulted in the
host-aware zoned devices always judged to have partitions, and it made
the sysfs queue/zoned attribute to be "none" instead of "host-aware"
regardless of partition existence in the devices.

This also caused DEBUG_LOCKS_WARN_ON(lock->magic != lock) for
sdkp->rev_mutex in scsi layer when the kernel detects host-aware zoned
device. Since block layer handled the host-aware zoned devices as non-
zoned devices, scsi layer did not have chance to initialize the mutex
for zone revalidation. Therefore, the warning was triggered.

To fix the issues, call the helper function disk_has_partitions() in
place of disk->part_tbl empty check. Since the function was removed with
the commit a33df75c6328, reimplement it to walk through entries in the
xarray disk->part_tbl.

Fixes: a33df75c6328 ("block: use an xarray for disk->part_tbl")
Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc: stable@vger.kernel.org # v5.14+
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20211026060115.753746-1-shinichiro.kawasaki@wdc.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/blk-settings.c |   20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -842,6 +842,24 @@ bool blk_queue_can_use_dma_map_merging(s
 }
 EXPORT_SYMBOL_GPL(blk_queue_can_use_dma_map_merging);
 
+static bool disk_has_partitions(struct gendisk *disk)
+{
+	unsigned long idx;
+	struct block_device *part;
+	bool ret = false;
+
+	rcu_read_lock();
+	xa_for_each(&disk->part_tbl, idx, part) {
+		if (bdev_is_partition(part)) {
+			ret = true;
+			break;
+		}
+	}
+	rcu_read_unlock();
+
+	return ret;
+}
+
 /**
  * blk_queue_set_zoned - configure a disk queue zoned model.
  * @disk:	the gendisk of the queue to configure
@@ -876,7 +894,7 @@ void blk_queue_set_zoned(struct gendisk
 		 * we do nothing special as far as the block layer is concerned.
 		 */
 		if (!IS_ENABLED(CONFIG_BLK_DEV_ZONED) ||
-		    !xa_empty(&disk->part_tbl))
+		    disk_has_partitions(disk))
 			model = BLK_ZONED_NONE;
 		break;
 	case BLK_ZONED_NONE:


