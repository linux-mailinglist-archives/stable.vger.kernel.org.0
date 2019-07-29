Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2ECB7973F
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 21:59:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390951AbfG2T6h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:58:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:45860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404003AbfG2Txa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:53:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4BB9A2171F;
        Mon, 29 Jul 2019 19:53:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564430009;
        bh=ZfoP31n5GUF7bzTvIabAhQHOtyckrMdjUQ76F0eMe+U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i4/yfyhl+6LYJpsqleVlVdQFWymbNhgOYKZsuNwmPLilX8RWx9kB2PZPxckSgDneK
         aGZEcigYJgEEG9TaKLdw5Tp2stM8HlEZ8UqolB7bP8lx0WVFQDYy7pY6uPQ6SqOxa8
         loGSYpgBcBYgcoHIqPq3aYJHLpz/3q2DsWXHijA0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH 5.2 168/215] usb-storage: Add a limitation for blk_queue_max_hw_sectors()
Date:   Mon, 29 Jul 2019 21:22:44 +0200
Message-Id: <20190729190808.996241839@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190739.971253303@linuxfoundation.org>
References: <20190729190739.971253303@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>

commit d74ffae8b8dd17eaa8b82fc163e6aa2076dc8fb1 upstream.

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
 drivers/usb/storage/scsiglue.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/drivers/usb/storage/scsiglue.c
+++ b/drivers/usb/storage/scsiglue.c
@@ -28,6 +28,8 @@
  * status of a command.
  */
 
+#include <linux/blkdev.h>
+#include <linux/dma-mapping.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
 
@@ -99,6 +101,7 @@ static int slave_alloc (struct scsi_devi
 static int slave_configure(struct scsi_device *sdev)
 {
 	struct us_data *us = host_to_us(sdev->host);
+	struct device *dev = us->pusb_dev->bus->sysdev;
 
 	/*
 	 * Many devices have trouble transferring more than 32KB at a time,
@@ -129,6 +132,14 @@ static int slave_configure(struct scsi_d
 	}
 
 	/*
+	 * The max_hw_sectors should be up to maximum size of a mapping for
+	 * the device. Otherwise, a DMA API might fail on swiotlb environment.
+	 */
+	blk_queue_max_hw_sectors(sdev->request_queue,
+		min_t(size_t, queue_max_hw_sectors(sdev->request_queue),
+		      dma_max_mapping_size(dev) >> SECTOR_SHIFT));
+
+	/*
 	 * Some USB host controllers can't do DMA; they have to use PIO.
 	 * They indicate this by setting their dma_mask to NULL.  For
 	 * such controllers we need to make sure the block layer sets


