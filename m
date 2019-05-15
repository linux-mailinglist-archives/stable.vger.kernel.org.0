Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0ABC11F2EB
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 14:09:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729090AbfEOLI0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:08:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:40740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728603AbfEOLI0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:08:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 804FE20881;
        Wed, 15 May 2019 11:08:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557918505;
        bh=x+50R5NECSLea7dbhs6gHTmUjsK/wQ0YouWXnn/EiAk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rdid+FQDpxg4W2Yh0KwM4nYGQNmFgQyOsGk0DckfJQDhkZ6dgm5xN2puxq4Ax1c7S
         v8oP52sE7XZGWCLPRgl7qkmVwvmPT6OybWLbLHpSBIkv+5ljgrYoPwTXds1VyPDbAy
         8GndmJM+l0p/uG83fFDJ8idPj4hhGsDpYWX33IR8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oliver Neukum <oneukum@suse.com>
Subject: [PATCH 4.4 155/266] UAS: fix alignment of scatter/gather segments
Date:   Wed, 15 May 2019 12:54:22 +0200
Message-Id: <20190515090728.156016081@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090722.696531131@linuxfoundation.org>
References: <20190515090722.696531131@linuxfoundation.org>
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

---
 drivers/usb/storage/uas.c |   38 ++++++++++++++++++++++++--------------
 1 file changed, 24 insertions(+), 14 deletions(-)

--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -772,23 +772,33 @@ static int uas_slave_alloc(struct scsi_d
 {
 	struct uas_dev_info *devinfo =
 		(struct uas_dev_info *)sdev->host->hostdata;
+	int maxp;
 
 	sdev->hostdata = devinfo;
 
-	/* USB has unusual DMA-alignment requirements: Although the
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
+	/*
+	 * We have two requirements here. We must satisfy the requirements
+	 * of the physical HC and the demands of the protocol, as we
+	 * definitely want no additional memory allocation in this path
+	 * ruling out using bounce buffers.
+ 	 *
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
 


