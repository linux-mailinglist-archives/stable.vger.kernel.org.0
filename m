Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D92B911AF1D
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:11:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730545AbfLKPLK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:11:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:59664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730880AbfLKPLJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:11:09 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4BCD6208C3;
        Wed, 11 Dec 2019 15:11:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077068;
        bh=UpBlCeV7bfd29ME9bJvtWmZPHusiY1X6vU4HD458FMU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bfWF0/+FNGlyeTjcxzEocltUFI5s5UyaDUuvs5pKXe+HMTCThE6jU4Chf76FkHUFr
         S4+w0VKm5VuKg+SblrJo+Kr6P6Gn4AMGb+ir2Jqr5U1siwtD3U649m43d86axgr7fK
         PtTscdLYx4SjBs6suGtos8uvWv2vsBQbIl2LhtPM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Jens Axboe <axboe@kernel.dk>, Laura Abbott <labbott@redhat.com>
Subject: [PATCH 5.4 85/92] bdev: Refresh bdev size for disks without partitioning
Date:   Wed, 11 Dec 2019 16:06:16 +0100
Message-Id: <20191211150301.478486571@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150221.977775294@linuxfoundation.org>
References: <20191211150221.977775294@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kara <jack@suse.cz>

commit cba22d86e0a10b7070d2e6a7379dbea51aa0883c upstream.

Currently, block device size in not updated on second and further open
for block devices where partition scan is disabled. This is particularly
annoying for example for DVD drives as that means block device size does
not get updated once the media is inserted into a drive if the device is
already open when inserting the media. This is actually always the case
for example when pktcdvd is in use.

Fix the problem by revalidating block device size on every open even for
devices with partition scan disabled.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Cc: Laura Abbott <labbott@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/block_dev.c |   19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1403,11 +1403,7 @@ static void flush_disk(struct block_devi
 		       "resized disk %s\n",
 		       bdev->bd_disk ? bdev->bd_disk->disk_name : "");
 	}
-
-	if (!bdev->bd_disk)
-		return;
-	if (disk_part_scan_enabled(bdev->bd_disk))
-		bdev->bd_invalidated = 1;
+	bdev->bd_invalidated = 1;
 }
 
 /**
@@ -1514,10 +1510,15 @@ static void __blkdev_put(struct block_de
 
 static void bdev_disk_changed(struct block_device *bdev, bool invalidate)
 {
-	if (invalidate)
-		invalidate_partitions(bdev->bd_disk, bdev);
-	else
-		rescan_partitions(bdev->bd_disk, bdev);
+	if (disk_part_scan_enabled(bdev->bd_disk)) {
+		if (invalidate)
+			invalidate_partitions(bdev->bd_disk, bdev);
+		else
+			rescan_partitions(bdev->bd_disk, bdev);
+	} else {
+		check_disk_size_change(bdev->bd_disk, bdev, !invalidate);
+		bdev->bd_invalidated = 0;
+	}
 }
 
 /*


