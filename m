Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7671D4A664
	for <lists+stable@lfdr.de>; Tue, 18 Jun 2019 18:16:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729386AbfFRQQD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jun 2019 12:16:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:52468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729349AbfFRQQD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Jun 2019 12:16:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2383F20B1F;
        Tue, 18 Jun 2019 16:16:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560874562;
        bh=1FIrss7gHYBXPWD1e/rjV+3x4n6lIp1ylsslDp/WAPs=;
        h=Subject:To:From:Date:From;
        b=sZDTAWk0RBsLkfdKlcbrTfWfM0q/wVZC9xTEHWvLi1zh1ac1d4DMgQtg+jqi7n98L
         ugpCRir0F1K9YkhlWGKfPfr6ge05bGnWAaCtOXoAzEgRDJy67NxHokWcxZaEH8kkH9
         AgGewnEsIQypBJ0eHv0u0QRWtkbwRJ+gnlj4AHSk=
Subject: patch "xhci: detect USB 3.2 capable host controllers correctly" added to usb-linus
To:     mathias.nyman@linux.intel.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 18 Jun 2019 18:15:52 +0200
Message-ID: <156087455216977@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    xhci: detect USB 3.2 capable host controllers correctly

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From ddd57980a0fde30f7b5d14b888a2cc84d01610e8 Mon Sep 17 00:00:00 2001
From: Mathias Nyman <mathias.nyman@linux.intel.com>
Date: Tue, 18 Jun 2019 17:27:48 +0300
Subject: xhci: detect USB 3.2 capable host controllers correctly

USB 3.2 capability in a host can be detected from the
xHCI Supported Protocol Capability major and minor revision fields.

If major is 0x3 and minor 0x20 then the host is USB 3.2 capable.

For USB 3.2 capable hosts set the root hub lane count to 2.

The Major Revision and Minor Revision fields contain a BCD version number.
The value of the Major Revision field is JJh and the value of the Minor
Revision field is MNh for version JJ.M.N, where JJ = major revision number,
M - minor version number, N = sub-minor version number,
e.g. version 3.1 is represented with a value of 0310h.

Also fix the extra whitespace printed out when announcing regular
SuperSpeed hosts.

Cc: <stable@vger.kernel.org> # v4.18+
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 78a2a937dd83..3f79f35d0b19 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -5065,16 +5065,26 @@ int xhci_gen_setup(struct usb_hcd *hcd, xhci_get_quirks_t get_quirks)
 	} else {
 		/*
 		 * Some 3.1 hosts return sbrn 0x30, use xhci supported protocol
-		 * minor revision instead of sbrn
+		 * minor revision instead of sbrn. Minor revision is a two digit
+		 * BCD containing minor and sub-minor numbers, only show minor.
 		 */
-		minor_rev = xhci->usb3_rhub.min_rev;
-		if (minor_rev) {
+		minor_rev = xhci->usb3_rhub.min_rev / 0x10;
+
+		switch (minor_rev) {
+		case 2:
+			hcd->speed = HCD_USB32;
+			hcd->self.root_hub->speed = USB_SPEED_SUPER_PLUS;
+			hcd->self.root_hub->rx_lanes = 2;
+			hcd->self.root_hub->tx_lanes = 2;
+			break;
+		case 1:
 			hcd->speed = HCD_USB31;
 			hcd->self.root_hub->speed = USB_SPEED_SUPER_PLUS;
+			break;
 		}
-		xhci_info(xhci, "Host supports USB 3.%x %s SuperSpeed\n",
+		xhci_info(xhci, "Host supports USB 3.%x %sSuperSpeed\n",
 			  minor_rev,
-			  minor_rev ? "Enhanced" : "");
+			  minor_rev ? "Enhanced " : "");
 
 		xhci->usb3_rhub.hcd = hcd;
 		/* xHCI private pointer was set in xhci_pci_probe for the second
-- 
2.22.0


