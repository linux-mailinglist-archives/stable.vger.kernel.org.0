Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6725E7710
	for <lists+stable@lfdr.de>; Mon, 28 Oct 2019 17:55:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730550AbfJ1QzM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Oct 2019 12:55:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:52788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726234AbfJ1QzM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Oct 2019 12:55:12 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 254BC21744;
        Mon, 28 Oct 2019 16:55:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572281711;
        bh=jckPOOiYQQNbkLKnA5USZLqd3mccflwO5hFc1CWTZjk=;
        h=Subject:To:From:Date:From;
        b=DrakwDmPVGvPpS+NZEoLe+45130g29H2IF/mVT4Q6i9oTBiNclbxhEZlLGQng0mkK
         fDBFvMHW0cigXiMbxADLOIWtlp0gsYiB+0mMRWLLUvFRHGWh1c53+/hiH3reqUeYEz
         THoj803RVwWdp7wiIzZ8lYlT3gYaXi/2vBZiz/EE=
Subject: patch "UAS: Revert commit 3ae62a42090f ("UAS: fix alignment of" added to usb-linus
To:     stern@rowland.harvard.edu, gregkh@linuxfoundation.org, hch@lst.de,
        oneukum@suse.com, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 28 Oct 2019 17:55:04 +0100
Message-ID: <157228170448175@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    UAS: Revert commit 3ae62a42090f ("UAS: fix alignment of

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 1186f86a71130a7635a20843e355bb880c7349b2 Mon Sep 17 00:00:00 2001
From: Alan Stern <stern@rowland.harvard.edu>
Date: Wed, 23 Oct 2019 11:34:33 -0400
Subject: UAS: Revert commit 3ae62a42090f ("UAS: fix alignment of
 scatter/gather segments")

Commit 3ae62a42090f ("UAS: fix alignment of scatter/gather segments"),
copying a similar commit for usb-storage, attempted to solve a problem
involving scatter-gather I/O and USB/IP by setting the
virt_boundary_mask for mass-storage devices.

However, it now turns out that the analogous change in usb-storage
interacted badly with commit 09324d32d2a0 ("block: force an unlimited
segment size on queues with a virt boundary"), which was added later.
A typical error message is:

	ehci-pci 0000:00:13.2: swiotlb buffer is full (sz: 327680 bytes),
	total 32768 (slots), used 97 (slots)

There is no longer any reason to keep the virt_boundary_mask setting
in the uas driver.  It was needed in the first place only for
handling devices with a block size smaller than the maxpacket size and
where the host controller was not capable of fully general
scatter-gather operation (that is, able to merge two SG segments into
a single USB packet).  But:

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
with no need for any special virt_boundary_mask.  So in order to head
off potential problems similar to those affecting usb-storage, this
patch reverts commit 3ae62a42090f.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
CC: Oliver Neukum <oneukum@suse.com>
CC: <stable@vger.kernel.org>
Acked-by: Christoph Hellwig <hch@lst.de>
Fixes: 3ae62a42090f ("UAS: fix alignment of scatter/gather segments")
Link: https://lore.kernel.org/r/Pine.LNX.4.44L0.1910231132470.1878-100000@iolanthe.rowland.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/storage/uas.c | 20 --------------------
 1 file changed, 20 deletions(-)

diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index bf80d6f81f58..34538253f12c 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -789,29 +789,9 @@ static int uas_slave_alloc(struct scsi_device *sdev)
 {
 	struct uas_dev_info *devinfo =
 		(struct uas_dev_info *)sdev->host->hostdata;
-	int maxp;
 
 	sdev->hostdata = devinfo;
 
-	/*
-	 * We have two requirements here. We must satisfy the requirements
-	 * of the physical HC and the demands of the protocol, as we
-	 * definitely want no additional memory allocation in this path
-	 * ruling out using bounce buffers.
-	 *
-	 * For a transmission on USB to continue we must never send
-	 * a package that is smaller than maxpacket. Hence the length of each
-         * scatterlist element except the last must be divisible by the
-         * Bulk maxpacket value.
-	 * If the HC does not ensure that through SG,
-	 * the upper layer must do that. We must assume nothing
-	 * about the capabilities off the HC, so we use the most
-	 * pessimistic requirement.
-	 */
-
-	maxp = usb_maxpacket(devinfo->udev, devinfo->data_in_pipe, 0);
-	blk_queue_virt_boundary(sdev->request_queue, maxp - 1);
-
 	/*
 	 * The protocol has no requirements on alignment in the strict sense.
 	 * Controllers may or may not have alignment restrictions.
-- 
2.23.0


