Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88976E770F
	for <lists+stable@lfdr.de>; Mon, 28 Oct 2019 17:55:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729317AbfJ1QzL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Oct 2019 12:55:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:52768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726234AbfJ1QzL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Oct 2019 12:55:11 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7707B21721;
        Mon, 28 Oct 2019 16:55:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572281709;
        bh=zU5wn3kZVtjzMCwNoJgtVXV9l1NGPZ0r0pMuv4nTST8=;
        h=Subject:To:From:Date:From;
        b=diHORhyU5Jv9ZDn7DIzZM06IKwTsxMxrhtvroSBfgxfuVdHyLhfmDo2ahKfQ0Khs1
         7LmuOnS+fVRy7MYQKJmeB04n1Zer6kuupl04eVAVu51GlJ0/80qbXRBvE1sFC1YP0N
         8VB0YvnMbkbDkGANkgb5p7/+nqqKhkOaVUrREm1c=
Subject: patch "usb-storage: Revert commit 747668dbc061 ("usb-storage: Set" added to usb-linus
To:     stern@rowland.harvard.edu, Seth.Bollinger@digi.com,
        gregkh@linuxfoundation.org, hch@lst.de,
        piergiorgio.sartor@nexgo.de, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 28 Oct 2019 17:55:02 +0100
Message-ID: <1572281702164@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb-storage: Revert commit 747668dbc061 ("usb-storage: Set

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 9a976949613132977098fc49510b46fa8678d864 Mon Sep 17 00:00:00 2001
From: Alan Stern <stern@rowland.harvard.edu>
Date: Mon, 21 Oct 2019 11:48:06 -0400
Subject: usb-storage: Revert commit 747668dbc061 ("usb-storage: Set
 virt_boundary_mask to avoid SG overflows")

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
 drivers/usb/storage/scsiglue.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/usb/storage/scsiglue.c b/drivers/usb/storage/scsiglue.c
index 6737fab94959..54a3c8195c96 100644
--- a/drivers/usb/storage/scsiglue.c
+++ b/drivers/usb/storage/scsiglue.c
@@ -68,7 +68,6 @@ static const char* host_info(struct Scsi_Host *host)
 static int slave_alloc (struct scsi_device *sdev)
 {
 	struct us_data *us = host_to_us(sdev->host);
-	int maxp;
 
 	/*
 	 * Set the INQUIRY transfer length to 36.  We don't use any of
@@ -77,15 +76,6 @@ static int slave_alloc (struct scsi_device *sdev)
 	 */
 	sdev->inquiry_len = 36;
 
-	/*
-	 * USB has unusual scatter-gather requirements: the length of each
-	 * scatterlist element except the last must be divisible by the
-	 * Bulk maxpacket value.  Fortunately this value is always a
-	 * power of 2.  Inform the block layer about this requirement.
-	 */
-	maxp = usb_maxpacket(us->pusb_dev, us->recv_bulk_pipe, 0);
-	blk_queue_virt_boundary(sdev->request_queue, maxp - 1);
-
 	/*
 	 * Some host controllers may have alignment requirements.
 	 * We'll play it safe by requiring 512-byte alignment always.
-- 
2.23.0


