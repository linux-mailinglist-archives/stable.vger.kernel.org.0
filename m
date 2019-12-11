Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7533F11AD87
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 15:33:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729989AbfLKOdP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 09:33:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:37964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727851AbfLKOdO (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 09:33:14 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AA7C920836;
        Wed, 11 Dec 2019 14:33:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576074794;
        bh=NzFql8PyY+qR0bBq9TRdX4nqkutKHQwajKyxLo0Wbc8=;
        h=Subject:To:From:Date:From;
        b=LpZ9mn35K4juQsrVshh/lAD03OfzX9nn20M0WUJmJ/imi/7dUAHXU1qHK+IO0rQsL
         rGbUXrQ3aW48I1grPadtrILQihnY+DaP8uGVYJi8Y38iU9sc7MW8aBxd7VpsFvHR4y
         EH14q+qJLcCRhZ1pJb9jf4/6sTHB6Sdkf4uOQPr8=
Subject: patch "xhci: fix USB3 device initiated resume race with roothub autosuspend" added to usb-linus
To:     mathias.nyman@linux.intel.com, chiasheng.lee@intel.com,
        gregkh@linuxfoundation.org, hou-hsun.lee@intel.com,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 11 Dec 2019 15:33:09 +0100
Message-ID: <157607478979203@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    xhci: fix USB3 device initiated resume race with roothub autosuspend

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 057d476fff778f1d3b9f861fdb5437ea1a3cfc99 Mon Sep 17 00:00:00 2001
From: Mathias Nyman <mathias.nyman@linux.intel.com>
Date: Wed, 11 Dec 2019 16:20:03 +0200
Subject: xhci: fix USB3 device initiated resume race with roothub autosuspend

A race in xhci USB3 remote wake handling may force device back to suspend
after it initiated resume siganaling, causing a missed resume event or warm
reset of device.

When a USB3 link completes resume signaling and goes to enabled (UO)
state a interrupt is issued and the interrupt handler will clear the
bus_state->port_remote_wakeup resume flag, allowing bus suspend.

If the USB3 roothub thread just finished reading port status before
the interrupt, finding ports still in suspended (U3) state, but hasn't
yet started suspending the hub, then the xhci interrupt handler will clear
the flag that prevented roothub suspend and allow bus to suspend, forcing
all port links back to suspended (U3) state.

Example case:
usb_runtime_suspend() # because all ports still show suspended U3
  usb_suspend_both()
    hub_suspend();   # successful as hub->wakeup_bits not set yet
==> INTERRUPT
xhci_irq()
  handle_port_status()
    clear bus_state->port_remote_wakeup
    usb_wakeup_notification()
      sets hub->wakeup_bits;
        kick_hub_wq()
<== END INTERRUPT
      hcd_bus_suspend()
        xhci_bus_suspend() # success as port_remote_wakeup bits cleared

Fix this by increasing roothub usage count during port resume to prevent
roothub autosuspend, and by making sure bus_state->port_remote_wakeup
flag is only cleared after resume completion is visible, i.e.
after xhci roothub returned U0 or other non-U3 link state link on a
get port status request.

Issue rootcaused by Chiasheng Lee

Cc: <stable@vger.kernel.org>
Cc: Lee, Hou-hsun <hou-hsun.lee@intel.com>
Reported-by: Lee, Chiasheng <chiasheng.lee@intel.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20191211142007.8847-3-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-hub.c  | 10 ++++++++++
 drivers/usb/host/xhci-ring.c |  3 +--
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/host/xhci-hub.c b/drivers/usb/host/xhci-hub.c
index b7d23c438756..4b870cd6c575 100644
--- a/drivers/usb/host/xhci-hub.c
+++ b/drivers/usb/host/xhci-hub.c
@@ -920,11 +920,13 @@ static void xhci_get_usb3_port_status(struct xhci_port *port, u32 *status,
 {
 	struct xhci_bus_state *bus_state;
 	struct xhci_hcd	*xhci;
+	struct usb_hcd *hcd;
 	u32 link_state;
 	u32 portnum;
 
 	bus_state = &port->rhub->bus_state;
 	xhci = hcd_to_xhci(port->rhub->hcd);
+	hcd = port->rhub->hcd;
 	link_state = portsc & PORT_PLS_MASK;
 	portnum = port->hcd_portnum;
 
@@ -952,6 +954,14 @@ static void xhci_get_usb3_port_status(struct xhci_port *port, u32 *status,
 			bus_state->suspended_ports &= ~(1 << portnum);
 	}
 
+	/* remote wake resume signaling complete */
+	if (bus_state->port_remote_wakeup & (1 << portnum) &&
+	    link_state != XDEV_RESUME &&
+	    link_state != XDEV_RECOVERY) {
+		bus_state->port_remote_wakeup &= ~(1 << portnum);
+		usb_hcd_end_port_resume(&hcd->self, portnum);
+	}
+
 	xhci_hub_report_usb3_link_state(xhci, status, portsc);
 	xhci_del_comp_mod_timer(xhci, portsc, portnum);
 }
diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index 6475c3d3b43b..9ebaa8e132a9 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -1628,7 +1628,6 @@ static void handle_port_status(struct xhci_hcd *xhci,
 		slot_id = xhci_find_slot_id_by_port(hcd, xhci, hcd_portnum + 1);
 		if (slot_id && xhci->devs[slot_id])
 			xhci->devs[slot_id]->flags |= VDEV_PORT_ERROR;
-		bus_state->port_remote_wakeup &= ~(1 << hcd_portnum);
 	}
 
 	if ((portsc & PORT_PLC) && (portsc & PORT_PLS_MASK) == XDEV_RESUME) {
@@ -1648,6 +1647,7 @@ static void handle_port_status(struct xhci_hcd *xhci,
 			 */
 			bus_state->port_remote_wakeup |= 1 << hcd_portnum;
 			xhci_test_and_clear_bit(xhci, port, PORT_PLC);
+			usb_hcd_start_port_resume(&hcd->self, hcd_portnum);
 			xhci_set_link_state(xhci, port, XDEV_U0);
 			/* Need to wait until the next link state change
 			 * indicates the device is actually in U0.
@@ -1688,7 +1688,6 @@ static void handle_port_status(struct xhci_hcd *xhci,
 		if (slot_id && xhci->devs[slot_id])
 			xhci_ring_device(xhci, slot_id);
 		if (bus_state->port_remote_wakeup & (1 << hcd_portnum)) {
-			bus_state->port_remote_wakeup &= ~(1 << hcd_portnum);
 			xhci_test_and_clear_bit(xhci, port, PORT_PLC);
 			usb_wakeup_notification(hcd->self.root_hub,
 					hcd_portnum + 1);
-- 
2.24.1


