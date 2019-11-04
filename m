Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9143CEEF02
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:19:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389199AbfKDWST (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 17:18:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:60310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388613AbfKDWCB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 17:02:01 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5E5C620650;
        Mon,  4 Nov 2019 22:02:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572904920;
        bh=dbfnmF4MTitvESuoiUp5eiYv2w4XZsqdp7uk+45n8Lk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n2bs2C6tL5g5Z2tdCRHTSaMSEgD2MsIsVTmPnRZXL6q8RHFg0wsAnzvyoxtVo8WR4
         egnAbKJsQe2/edfluTH1Y8SqdRiPAWhGvWqYVHjN0tBD4YcIpIz2MK6O+G/XSuIT6N
         a/U0ZZ5Ir4FqEqKSBDGlvc4WRUElKAaVz7u3WR/8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Seth Bollinger <Seth.Bollinger@digi.com>,
        Christoph Hellwig <hch@lst.de>,
        Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: [PATCH 4.19 116/149] usb-storage: Revert commit 747668dbc061 ("usb-storage: Set virt_boundary_mask to avoid SG overflows")
Date:   Mon,  4 Nov 2019 22:45:09 +0100
Message-Id: <20191104212144.459583669@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104212126.090054740@linuxfoundation.org>
References: <20191104212126.090054740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alan Stern <stern@rowland.harvard.edu>

commit 9a976949613132977098fc49510b46fa8678d864 upstream.

Commit 747668dbc061 ("usb-storage: Set virt_boundary_mask to avoid SG
overflows") attempted to solve a problem involving scatter-gather I/O
and USB/IP by setting the virt_boundary_mask for mass-storage devices.

However, it now turns out that this interacts badly with commit
09324d32d2a0 ("block: force an unlimited segment size on queues with a
virt boundary"), which was added later.  A typical error message is:

	ehci-pci 0000:00:13.2: swiotlb buffer is full (sz: 327680 bytes),
	total 32768 (slots), used 97 (slots)

There is no longer any reason to keep the virt_boundary_mask setting
for usb-storage.  It was needed in the first place only for handling
devices with a block size smaller than the maxpacket size and where
the host controller was not capable of fully general scatter-gather
operation (that is, able to merge two SG segments into a single USB
packet).  But:

	High-speed or slower connections never use a bulk maxpacket
	value larger than 512;

	The SCSI layer does not handle block devices with a block size
	smaller than 512 bytes;

	All the host controllers capable of SuperSpeed operation can
	handle fully general SG;

	Since commit ea44d190764b ("usbip: Implement SG support to
	vhci-hcd and stub driver") was merged, the USB/IP driver can
	also handle SG.

Therefore all supported device/controller combinations should be okay
with no need for any special virt_boundary_mask.  So in order to fix
the swiotlb problem, this patch reverts commit 747668dbc061.

Reported-and-tested-by: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Link: https://marc.info/?l=linux-usb&m=157134199501202&w=2
Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
CC: Seth Bollinger <Seth.Bollinger@digi.com>
CC: <stable@vger.kernel.org>
Fixes: 747668dbc061 ("usb-storage: Set virt_boundary_mask to avoid SG overflows")
Acked-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/Pine.LNX.4.44L0.1910211145520.1673-100000@iolanthe.rowland.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/storage/scsiglue.c |   10 ----------
 1 file changed, 10 deletions(-)

--- a/drivers/usb/storage/scsiglue.c
+++ b/drivers/usb/storage/scsiglue.c
@@ -65,7 +65,6 @@ static const char* host_info(struct Scsi
 static int slave_alloc (struct scsi_device *sdev)
 {
 	struct us_data *us = host_to_us(sdev->host);
-	int maxp;
 
 	/*
 	 * Set the INQUIRY transfer length to 36.  We don't use any of
@@ -75,15 +74,6 @@ static int slave_alloc (struct scsi_devi
 	sdev->inquiry_len = 36;
 
 	/*
-	 * USB has unusual scatter-gather requirements: the length of each
-	 * scatterlist element except the last must be divisible by the
-	 * Bulk maxpacket value.  Fortunately this value is always a
-	 * power of 2.  Inform the block layer about this requirement.
-	 */
-	maxp = usb_maxpacket(us->pusb_dev, us->recv_bulk_pipe, 0);
-	blk_queue_virt_boundary(sdev->request_queue, maxp - 1);
-
-	/*
 	 * Some host controllers may have alignment requirements.
 	 * We'll play it safe by requiring 512-byte alignment always.
 	 */


