Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FF4B11B7ED
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 17:11:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730876AbfLKPLH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:11:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:59630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730875AbfLKPLG (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:11:06 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BFE2822B48;
        Wed, 11 Dec 2019 15:11:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077066;
        bh=5gDgrFLeuOQRVW+M3t5BrTdqNSX5WJNIkR5ywsMvMSU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m1w9S9HDZDsJzVpvtUv7ne1Y5a+JIk52370CEqL/8IpwtHzlw8Eqvv5R/VlESIZsl
         xF6zhGD30MNo4ruF2/yLmvLiL7CfIW0MX8FiTp9ouzH9RsduN8aFzpKfcVXu0DfxKj
         Feuuyp86LUqffcy/iveEGl6825PB1qWh5P+Q8fc0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Jens Axboe <axboe@kernel.dk>, Laura Abbott <labbott@redhat.com>
Subject: [PATCH 5.4 84/92] bdev: Factor out bdev revalidation into a common helper
Date:   Wed, 11 Dec 2019 16:06:15 +0100
Message-Id: <20191211150301.305868277@linuxfoundation.org>
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

commit 731dc4868311ee097757b8746eaa1b4f8b2b4f1c upstream.

Factor out code handling revalidation of bdev on disk change into a
common helper.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Cc: Laura Abbott <labbott@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/block_dev.c |   26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1512,6 +1512,14 @@ EXPORT_SYMBOL(bd_set_size);
 
 static void __blkdev_put(struct block_device *bdev, fmode_t mode, int for_part);
 
+static void bdev_disk_changed(struct block_device *bdev, bool invalidate)
+{
+	if (invalidate)
+		invalidate_partitions(bdev->bd_disk, bdev);
+	else
+		rescan_partitions(bdev->bd_disk, bdev);
+}
+
 /*
  * bd_mutex locking:
  *
@@ -1594,12 +1602,9 @@ static int __blkdev_get(struct block_dev
 			 * The latter is necessary to prevent ghost
 			 * partitions on a removed medium.
 			 */
-			if (bdev->bd_invalidated) {
-				if (!ret)
-					rescan_partitions(disk, bdev);
-				else if (ret == -ENOMEDIUM)
-					invalidate_partitions(disk, bdev);
-			}
+			if (bdev->bd_invalidated &&
+			    (!ret || ret == -ENOMEDIUM))
+				bdev_disk_changed(bdev, ret == -ENOMEDIUM);
 
 			if (ret)
 				goto out_clear;
@@ -1632,12 +1637,9 @@ static int __blkdev_get(struct block_dev
 			if (bdev->bd_disk->fops->open)
 				ret = bdev->bd_disk->fops->open(bdev, mode);
 			/* the same as first opener case, read comment there */
-			if (bdev->bd_invalidated) {
-				if (!ret)
-					rescan_partitions(bdev->bd_disk, bdev);
-				else if (ret == -ENOMEDIUM)
-					invalidate_partitions(bdev->bd_disk, bdev);
-			}
+			if (bdev->bd_invalidated &&
+			    (!ret || ret == -ENOMEDIUM))
+				bdev_disk_changed(bdev, ret == -ENOMEDIUM);
 			if (ret)
 				goto out_unlock_bdev;
 		}


