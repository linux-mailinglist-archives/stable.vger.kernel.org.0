Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1833B1057E
	for <lists+stable@lfdr.de>; Wed,  1 May 2019 08:40:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725958AbfEAGku (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 May 2019 02:40:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:36888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725776AbfEAGkt (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 May 2019 02:40:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8F8DE2085A;
        Wed,  1 May 2019 06:40:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556692849;
        bh=B0uRu3eWbJM6ulwYW9ynkQWvKw2a2k9Dkg2o5WSLuU8=;
        h=Subject:To:From:Date:From;
        b=dE7m4vlHUD89mHkmIFY8f0cO8wjot9Ke0ENSdqW3Ew15XsAUY6QPUc3L8BCUZFzve
         FgI1EX+WidY/1obnVntP0FFfnXmfQeZ+SRdCKQMAPZBhwWqCwy5yWieABBjLofyCz9
         IUVdrT0MX2Xd6M6EsZmQ3FcRYmiZhzGadWObdSeA=
Subject: patch "UAS: fix alignment of scatter/gather segments" added to usb-next
To:     oneukum@suse.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 01 May 2019 08:40:30 +0200
Message-ID: <1556692830131221@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    UAS: fix alignment of scatter/gather segments

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From 3ae62a42090f1ed48e2313ed256a1182a85fb575 Mon Sep 17 00:00:00 2001
From: Oliver Neukum <oneukum@suse.com>
Date: Tue, 30 Apr 2019 12:21:45 +0200
Subject: UAS: fix alignment of scatter/gather segments

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
---
 drivers/usb/storage/uas.c | 35 ++++++++++++++++++++++-------------
 1 file changed, 22 insertions(+), 13 deletions(-)

diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index a6d68191c861..047c5922618f 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -789,24 +789,33 @@ static int uas_slave_alloc(struct scsi_device *sdev)
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
 
-- 
2.21.0


