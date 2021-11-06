Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E41F446E5D
	for <lists+stable@lfdr.de>; Sat,  6 Nov 2021 15:43:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234398AbhKFOp5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 6 Nov 2021 10:45:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:53788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234396AbhKFOp4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 6 Nov 2021 10:45:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 21CB961074;
        Sat,  6 Nov 2021 14:43:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636209795;
        bh=/wJrk5NCft0KLgwY7K1UnEnkMWxEvnQ9EIDFIscbYc0=;
        h=Subject:To:From:Date:From;
        b=VACoYIupv+qk7OTukJF/uD5YJhI2bDLG+PSqmNyONkz462dASUh0jSK+UaxPCZ0UP
         0Qlggq8+dMT8CsVccX7qNL2SuVca9GrW94MgkWu8XcILufm7rsSXuhxnrqNWNcvRiW
         Lxirfq8kcvwbufGQ6axCrGuBRRoODsW3dX7l3x3U=
Subject: patch "xhci: Fix USB 3.1 enumeration issues by increasing roothub" added to usb-linus
To:     mathias.nyman@linux.intel.com, gregkh@linuxfoundation.org,
        mr.yming81@gmail.com, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 06 Nov 2021 15:43:13 +0100
Message-ID: <16362097934024@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    xhci: Fix USB 3.1 enumeration issues by increasing roothub

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From e1959faf085b004e6c3afaaaa743381f00e7c015 Mon Sep 17 00:00:00 2001
From: Mathias Nyman <mathias.nyman@linux.intel.com>
Date: Fri, 5 Nov 2021 18:00:36 +0200
Subject: xhci: Fix USB 3.1 enumeration issues by increasing roothub
 power-on-good delay

Some USB 3.1 enumeration issues were reported after the hub driver removed
the minimum 100ms limit for the power-on-good delay.

Since commit 90d28fb53d4a ("usb: core: reduce power-on-good delay time of
root hub") the hub driver sets the power-on-delay based on the
bPwrOn2PwrGood value in the hub descriptor.

xhci driver has a 20ms bPwrOn2PwrGood value for both roothubs based
on xhci spec section 5.4.8, but it's clearly not enough for the
USB 3.1 devices, causing enumeration issues.

Tests indicate full 100ms delay is needed.

Reported-by: Walt Jr. Brake <mr.yming81@gmail.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Fixes: 90d28fb53d4a ("usb: core: reduce power-on-good delay time of root hub")
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20211105160036.549516-1-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-hub.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/host/xhci-hub.c b/drivers/usb/host/xhci-hub.c
index a3f875eea751..af946c42b6f0 100644
--- a/drivers/usb/host/xhci-hub.c
+++ b/drivers/usb/host/xhci-hub.c
@@ -257,7 +257,6 @@ static void xhci_common_hub_descriptor(struct xhci_hcd *xhci,
 {
 	u16 temp;
 
-	desc->bPwrOn2PwrGood = 10;	/* xhci section 5.4.9 says 20ms max */
 	desc->bHubContrCurrent = 0;
 
 	desc->bNbrPorts = ports;
@@ -292,6 +291,7 @@ static void xhci_usb2_hub_descriptor(struct usb_hcd *hcd, struct xhci_hcd *xhci,
 	desc->bDescriptorType = USB_DT_HUB;
 	temp = 1 + (ports / 8);
 	desc->bDescLength = USB_DT_HUB_NONVAR_SIZE + 2 * temp;
+	desc->bPwrOn2PwrGood = 10;	/* xhci section 5.4.8 says 20ms */
 
 	/* The Device Removable bits are reported on a byte granularity.
 	 * If the port doesn't exist within that byte, the bit is set to 0.
@@ -344,6 +344,7 @@ static void xhci_usb3_hub_descriptor(struct usb_hcd *hcd, struct xhci_hcd *xhci,
 	xhci_common_hub_descriptor(xhci, desc, ports);
 	desc->bDescriptorType = USB_DT_SS_HUB;
 	desc->bDescLength = USB_DT_SS_HUB_SIZE;
+	desc->bPwrOn2PwrGood = 50;	/* usb 3.1 may fail if less than 100ms */
 
 	/* header decode latency should be zero for roothubs,
 	 * see section 4.23.5.2.
-- 
2.33.1


