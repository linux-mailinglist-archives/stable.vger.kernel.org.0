Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 434557496B
	for <lists+stable@lfdr.de>; Thu, 25 Jul 2019 10:54:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389901AbfGYIyS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jul 2019 04:54:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:42302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389898AbfGYIyS (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Jul 2019 04:54:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ED6C122BED;
        Thu, 25 Jul 2019 08:54:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564044857;
        bh=hrAEwcqL6/8shZqhxtkKzS6tsuAsS6tGcnisqkhdJGw=;
        h=Subject:To:From:Date:From;
        b=0liGf2clUQzyR7zZb60kzSfteqiQ90s9vhDn0p7rUAN15qYNwPAxmQfiSFSfv+KEc
         KMGrd1FEMNOZj1uvRQyRsEozbpEmTmklC0hrnU9wm14m2hdMeL8kkiOCmx5mSqaJW6
         xGKoPvW9Sciyy82QqOpbK3AJOIv6k4oSbEY13eQE=
Subject: patch "usb-storage: Add a limitation for blk_queue_max_hw_sectors()" added to usb-linus
To:     yoshihiro.shimoda.uh@renesas.com, gregkh@linuxfoundation.org,
        hch@lst.de, stable@vger.kernel.org, stern@rowland.harvard.edu
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 25 Jul 2019 10:54:12 +0200
Message-ID: <15640448521491@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb-storage: Add a limitation for blk_queue_max_hw_sectors()

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From d74ffae8b8dd17eaa8b82fc163e6aa2076dc8fb1 Mon Sep 17 00:00:00 2001
From: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Date: Mon, 22 Jul 2019 19:58:25 +0900
Subject: usb-storage: Add a limitation for blk_queue_max_hw_sectors()

This patch fixes an issue that the following error happens on
swiotlb environment:

	xhci-hcd ee000000.usb: swiotlb buffer is full (sz: 524288 bytes), total 32768 (slots), used 1338 (slots)

On the kernel v5.1, block settings of a usb-storage with SuperSpeed
were the following so that the block layer will allocate buffers
up to 64 KiB, and then the issue didn't happen.

	max_segment_size = 65536
	max_hw_sectors_kb = 1024

After the commit 09324d32d2a0 ("block: force an unlimited segment
size on queues with a virt boundary") is applied, the block settings
are the following. So, the block layer will allocate buffers up to
1024 KiB, and then the issue happens:

	max_segment_size = 4294967295
	max_hw_sectors_kb = 1024

To fix the issue, the usb-storage driver checks the maximum size of
a mapping for the device and then adjusts the max_hw_sectors_kb
if required. After this patch is applied, the block settings will
be the following, and then the issue doesn't happen.

	max_segment_size = 4294967295
	max_hw_sectors_kb = 256

Fixes: 09324d32d2a0 ("block: force an unlimited segment size on queues with a virt boundary")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/1563793105-20597-1-git-send-email-yoshihiro.shimoda.uh@renesas.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/storage/scsiglue.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/usb/storage/scsiglue.c b/drivers/usb/storage/scsiglue.c
index 30790240aec6..05b80211290d 100644
--- a/drivers/usb/storage/scsiglue.c
+++ b/drivers/usb/storage/scsiglue.c
@@ -28,6 +28,8 @@
  * status of a command.
  */
 
+#include <linux/blkdev.h>
+#include <linux/dma-mapping.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
 
@@ -99,6 +101,7 @@ static int slave_alloc (struct scsi_device *sdev)
 static int slave_configure(struct scsi_device *sdev)
 {
 	struct us_data *us = host_to_us(sdev->host);
+	struct device *dev = us->pusb_dev->bus->sysdev;
 
 	/*
 	 * Many devices have trouble transferring more than 32KB at a time,
@@ -128,6 +131,14 @@ static int slave_configure(struct scsi_device *sdev)
 		blk_queue_max_hw_sectors(sdev->request_queue, 2048);
 	}
 
+	/*
+	 * The max_hw_sectors should be up to maximum size of a mapping for
+	 * the device. Otherwise, a DMA API might fail on swiotlb environment.
+	 */
+	blk_queue_max_hw_sectors(sdev->request_queue,
+		min_t(size_t, queue_max_hw_sectors(sdev->request_queue),
+		      dma_max_mapping_size(dev) >> SECTOR_SHIFT));
+
 	/*
 	 * Some USB host controllers can't do DMA; they have to use PIO.
 	 * They indicate this by setting their dma_mask to NULL.  For
-- 
2.22.0


