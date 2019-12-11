Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08DB311AD30
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 15:18:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729829AbfLKOSa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 09:18:30 -0500
Received: from mga07.intel.com ([134.134.136.100]:52849 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727554AbfLKOSa (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 09:18:30 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Dec 2019 06:18:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,301,1571727600"; 
   d="scan'208";a="414868233"
Received: from mattu-haswell.fi.intel.com ([10.237.72.170])
  by fmsmga006.fm.intel.com with ESMTP; 11 Dec 2019 06:18:25 -0800
From:   Mathias Nyman <mathias.nyman@linux.intel.com>
To:     <gregkh@linuxfoundation.org>
Cc:     <linux-usb@vger.kernel.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        stable@vger.kernel.org, Lee@vger.kernel.org,
        Hou-hsun <hou-hsun.lee@intel.com>
Subject: [PATCH 2/6] xhci: fix USB3 device initiated resume race with roothub autosuspend
Date:   Wed, 11 Dec 2019 16:20:03 +0200
Message-Id: <20191211142007.8847-3-mathias.nyman@linux.intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191211142007.8847-1-mathias.nyman@linux.intel.com>
References: <20191211142007.8847-1-mathias.nyman@linux.intel.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
2.17.1

