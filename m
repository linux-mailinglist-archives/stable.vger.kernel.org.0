Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 194F513330B
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 22:16:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729263AbgAGVPw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 16:15:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:58552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729514AbgAGVHd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 16:07:33 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BCA5B2077B;
        Tue,  7 Jan 2020 21:07:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578431253;
        bh=1NcdiNwnH7To/Iqx5SZD2vBXi3MHmzy7tb1EB9E8u9g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gdJoLCkWZqNtBMiqhQtxZR8ZO7golz9ZH7rNB/2H0mOhOCf09wLKRXWwVXcr4/vju
         DoYOJDXW3bd6Jdujd51yyvOYtRtfqALn+LPIL5S+YLh/3iQjx8SbN23KD9JWr8Psv5
         34eNf/FUZND9Ht+s1eSddNugKdBpZX+YC/j3wRHg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4.19 097/115] bdev: Refresh bdev size for disks without partitioning
Date:   Tue,  7 Jan 2020 21:55:07 +0100
Message-Id: <20200107205307.375255965@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107205240.283674026@linuxfoundation.org>
References: <20200107205240.283674026@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/block_dev.c |   19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1328,11 +1328,7 @@ static void flush_disk(struct block_devi
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
@@ -1432,10 +1428,15 @@ static void __blkdev_put(struct block_de
 
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


