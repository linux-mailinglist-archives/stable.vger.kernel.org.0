Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4750819158
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 20:56:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726888AbfEISz7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 14:55:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:50446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729226AbfEISzY (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 May 2019 14:55:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C6E522177E;
        Thu,  9 May 2019 18:55:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557428123;
        bh=hFGAcTGN8+exjIpw3elz3HCRPqeJPoKx3U8wzUVaBrI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1ouUgs92g2DcbmRMaD2T8Bp88WJVS7rnIyc5roVrYyH+GIwwCaXA50fDj9WwZcEYg
         SiUM+dwLdU6NJDk0dD25zDqZVPbLuSv1q40xjkelDxdODDwrcCEbc83V8f9IU7TCXE
         +gojYpNRDB5O/c0YHU2AmVf5X6ZkVwmniEskn0nE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oliver Neukum <oneukum@suse.com>
Subject: [PATCH 5.1 26/30] UAS: fix alignment of scatter/gather segments
Date:   Thu,  9 May 2019 20:42:58 +0200
Message-Id: <20190509181256.628727841@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190509181250.417203112@linuxfoundation.org>
References: <20190509181250.417203112@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oliver Neukum <oneukum@suse.com>

commit 3ae62a42090f1ed48e2313ed256a1182a85fb575 upstream.

This is the UAS version of

747668dbc061b3e62bc1982767a3a1f9815fcf0e
usb-storage: Set virt_boundary_mask to avoid SG overflows

We are not as likely to be vulnerable as storage, as it is unlikelier
that UAS is run over a controller without native support for SG,
but the issue exists.
The issue has been existing since the inception of the driver.

Fixes: 115bb1ffa54c ("USB: Add UAS driver")
Signed-off-by: Oliver Neukum <oneukum@suse.com>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/storage/uas.c |   35 ++++++++++++++++++++++-------------
 1 file changed, 22 insertions(+), 13 deletions(-)

--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -789,24 +789,33 @@ static int uas_slave_alloc(struct scsi_d
 {
 	struct uas_dev_info *devinfo =
 		(struct uas_dev_info *)sdev->host->hostdata;
+	int maxp;
 
 	sdev->hostdata = devinfo;
 
 	/*
-	 * USB has unusual DMA-alignment requirements: Although the
-	 * starting address of each scatter-gather element doesn't matter,
-	 * the length of each element except the last must be divisible
-	 * by the Bulk maxpacket value.  There's currently no way to
-	 * express this by block-layer constraints, so we'll cop out
-	 * and simply require addresses to be aligned at 512-byte
-	 * boundaries.  This is okay since most block I/O involves
-	 * hardware sectors that are multiples of 512 bytes in length,
-	 * and since host controllers up through USB 2.0 have maxpacket
-	 * values no larger than 512.
+	 * We have two requirements here. We must satisfy the requirements
+	 * of the physical HC and the demands of the protocol, as we
+	 * definitely want no additional memory allocation in this path
+	 * ruling out using bounce buffers.
 	 *
-	 * But it doesn't suffice for Wireless USB, where Bulk maxpacket
-	 * values can be as large as 2048.  To make that work properly
-	 * will require changes to the block layer.
+	 * For a transmission on USB to continue we must never send
+	 * a package that is smaller than maxpacket. Hence the length of each
+         * scatterlist element except the last must be divisible by the
+         * Bulk maxpacket value.
+	 * If the HC does not ensure that through SG,
+	 * the upper layer must do that. We must assume nothing
+	 * about the capabilities off the HC, so we use the most
+	 * pessimistic requirement.
+	 */
+
+	maxp = usb_maxpacket(devinfo->udev, devinfo->data_in_pipe, 0);
+	blk_queue_virt_boundary(sdev->request_queue, maxp - 1);
+
+	/*
+	 * The protocol has no requirements on alignment in the strict sense.
+	 * Controllers may or may not have alignment restrictions.
+	 * As this is not exported, we use an extremely conservative guess.
 	 */
 	blk_queue_update_dma_alignment(sdev->request_queue, (512 - 1));
 


