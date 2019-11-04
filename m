Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC06FEF083
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:28:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730073AbfKDVsh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 16:48:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:39176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730050AbfKDVsg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 16:48:36 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 61A1F21744;
        Mon,  4 Nov 2019 21:48:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572904115;
        bh=gK0apV4xGm2rbDpBWgguKjcnDsIC/t2J8Y9zM7fm0uE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jK/anFnjXbxAObjqSWKfP3GUAGxXbP+HXEhXcl2aHVNGFb+GKnM8CVUsI1VJn/r1H
         22dKpOX2Hrh7vcLUiKrk6hl5ocxqN14OS9RrED3kgruOTrMC/EC6OXZXKpeGnVtQCK
         Vad9uWmaEmdvs6jQcjzVxxGP3mEMeZIb5Kl8wqjc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Oliver Neukum <oneukum@suse.com>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH 4.4 28/46] UAS: Revert commit 3ae62a42090f ("UAS: fix alignment of scatter/gather segments")
Date:   Mon,  4 Nov 2019 22:44:59 +0100
Message-Id: <20191104211901.335806642@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104211830.912265604@linuxfoundation.org>
References: <20191104211830.912265604@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alan Stern <stern@rowland.harvard.edu>

commit 1186f86a71130a7635a20843e355bb880c7349b2 upstream.

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
 drivers/usb/storage/uas.c |   20 --------------------
 1 file changed, 20 deletions(-)

--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -772,30 +772,10 @@ static int uas_slave_alloc(struct scsi_d
 {
 	struct uas_dev_info *devinfo =
 		(struct uas_dev_info *)sdev->host->hostdata;
-	int maxp;
 
 	sdev->hostdata = devinfo;
 
 	/*
-	 * We have two requirements here. We must satisfy the requirements
-	 * of the physical HC and the demands of the protocol, as we
-	 * definitely want no additional memory allocation in this path
-	 * ruling out using bounce buffers.
- 	 *
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
-	/*
 	 * The protocol has no requirements on alignment in the strict sense.
 	 * Controllers may or may not have alignment restrictions.
 	 * As this is not exported, we use an extremely conservative guess.


