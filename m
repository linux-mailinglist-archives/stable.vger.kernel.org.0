Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AA171920B
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 21:04:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728161AbfEIStE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 14:49:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:42298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728157AbfEIStD (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 May 2019 14:49:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 126C2217D7;
        Thu,  9 May 2019 18:49:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557427742;
        bh=HwTDDQgpdyLKymq762qog44ANmbDGP/fSirsRKzlApc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J0SBOuyG9NZEaSB7ljZ4I0UO16Ne3Z5g9SJwHQZ+NcbFh9dR8NrAL8NfwmPXLW/Fn
         YTKisgC4+5sQ0a3Pgwo7h89Xt8U9kUZTR1+2udJ3WOshRQLmD8uRoAOUb0zAJqCMRV
         nntPD3CHi9EcSSXsaFuI87KOW04fbGy8INQRIoDk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Seth Bollinger <Seth.Bollinger@digi.com>,
        Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH 4.19 54/66] usb-storage: Set virt_boundary_mask to avoid SG overflows
Date:   Thu,  9 May 2019 20:42:29 +0200
Message-Id: <20190509181307.248818725@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190509181301.719249738@linuxfoundation.org>
References: <20190509181301.719249738@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alan Stern <stern@rowland.harvard.edu>

commit 747668dbc061b3e62bc1982767a3a1f9815fcf0e upstream.

The USB subsystem has always had an unusual requirement for its
scatter-gather transfers: Each element in the scatterlist (except the
last one) must have a length divisible by the bulk maxpacket size.
This is a particular issue for USB mass storage, which uses SG lists
created by the block layer rather than setting up its own.

So far we have scraped by okay because most devices have a logical
block size of 512 bytes or larger, and the bulk maxpacket sizes for
USB 2 and below are all <= 512.  However, USB 3 has a bulk maxpacket
size of 1024.  Since the xhci-hcd driver includes native SG support,
this hasn't mattered much.  But now people are trying to use USB-3
mass storage devices with USBIP, and the vhci-hcd driver currently
does not have full SG support.

The result is an overflow error, when the driver attempts to implement
an SG transfer of 63 512-byte blocks as a single
3584-byte (7 blocks) transfer followed by seven 4096-byte (8 blocks)
transfers.  The device instead sends 31 1024-byte packets followed by
a 512-byte packet, and this overruns the first SG buffer.

Ideally this would be fixed by adding better SG support to vhci-hcd.
But for now it appears we can work around the problem by
asking the block layer to respect the maxpacket limitation, through
the use of the virt_boundary_mask.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Reported-by: Seth Bollinger <Seth.Bollinger@digi.com>
Tested-by: Seth Bollinger <Seth.Bollinger@digi.com>
CC: Ming Lei <tom.leiming@gmail.com>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/storage/scsiglue.c |   26 ++++++++++++--------------
 1 file changed, 12 insertions(+), 14 deletions(-)

--- a/drivers/usb/storage/scsiglue.c
+++ b/drivers/usb/storage/scsiglue.c
@@ -65,6 +65,7 @@ static const char* host_info(struct Scsi
 static int slave_alloc (struct scsi_device *sdev)
 {
 	struct us_data *us = host_to_us(sdev->host);
+	int maxp;
 
 	/*
 	 * Set the INQUIRY transfer length to 36.  We don't use any of
@@ -74,20 +75,17 @@ static int slave_alloc (struct scsi_devi
 	sdev->inquiry_len = 36;
 
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
-	 *
-	 * But it doesn't suffice for Wireless USB, where Bulk maxpacket
-	 * values can be as large as 2048.  To make that work properly
-	 * will require changes to the block layer.
+	 * USB has unusual scatter-gather requirements: the length of each
+	 * scatterlist element except the last must be divisible by the
+	 * Bulk maxpacket value.  Fortunately this value is always a
+	 * power of 2.  Inform the block layer about this requirement.
+	 */
+	maxp = usb_maxpacket(us->pusb_dev, us->recv_bulk_pipe, 0);
+	blk_queue_virt_boundary(sdev->request_queue, maxp - 1);
+
+	/*
+	 * Some host controllers may have alignment requirements.
+	 * We'll play it safe by requiring 512-byte alignment always.
 	 */
 	blk_queue_update_dma_alignment(sdev->request_queue, (512 - 1));
 


