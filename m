Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD4C21260B9
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 12:21:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726695AbfLSLVD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 06:21:03 -0500
Received: from mga06.intel.com ([134.134.136.31]:13040 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726652AbfLSLVD (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 06:21:03 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Dec 2019 03:21:02 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,331,1571727600"; 
   d="scan'208";a="241133503"
Received: from mattu-haswell.fi.intel.com ([10.237.72.170])
  by fmsmga004.fm.intel.com with ESMTP; 19 Dec 2019 03:21:00 -0800
From:   Mathias Nyman <mathias.nyman@linux.intel.com>
To:     stable@vger.kernel.org
Cc:     Mathias Nyman <mathias.nyman@linux.intel.com>, Lee@vger.kernel.org,
        Hou-hsun <hou-hsun.lee@intel.com>
Subject: [PATCH] xhci: fix USB3 device initiated resume race with roothub autosuspend
Date:   Thu, 19 Dec 2019 13:22:52 +0200
Message-Id: <20191219112252.6890-1-mathias.nyman@linux.intel.com>
X-Mailer: git-send-email 2.17.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 057d476fff778f1d3b9f861fdb5437ea1a3cfc99 upstream

Backport for linux-4.19.y stable

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
 drivers/usb/host/xhci-hub.c  | 8 ++++++++
 drivers/usb/host/xhci-ring.c | 3 +--
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/host/xhci-hub.c b/drivers/usb/host/xhci-hub.c
index 02843c16f9c7..8f180bf7561a 100644
--- a/drivers/usb/host/xhci-hub.c
+++ b/drivers/usb/host/xhci-hub.c
@@ -868,6 +868,14 @@ static u32 xhci_get_port_status(struct usb_hcd *hcd,
 			status |= USB_PORT_STAT_C_BH_RESET << 16;
 		if ((raw_port_status & PORT_CEC))
 			status |= USB_PORT_STAT_C_CONFIG_ERROR << 16;
+
+		/* USB3 remote wake resume signaling completed */
+		if (bus_state->port_remote_wakeup & (1 << wIndex) &&
+		    (raw_port_status & PORT_PLS_MASK) != XDEV_RESUME &&
+		    (raw_port_status & PORT_PLS_MASK) != XDEV_RECOVERY) {
+			bus_state->port_remote_wakeup &= ~(1 << wIndex);
+			usb_hcd_end_port_resume(&hcd->self, wIndex);
+		}
 	}
 
 	if (hcd->speed < HCD_USB3) {
diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index b03974958a28..98b67605d3cf 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -1609,7 +1609,6 @@ static void handle_port_status(struct xhci_hcd *xhci,
 		slot_id = xhci_find_slot_id_by_port(hcd, xhci, hcd_portnum + 1);
 		if (slot_id && xhci->devs[slot_id])
 			xhci->devs[slot_id]->flags |= VDEV_PORT_ERROR;
-		bus_state->port_remote_wakeup &= ~(1 << hcd_portnum);
 	}
 
 	if ((portsc & PORT_PLC) && (portsc & PORT_PLS_MASK) == XDEV_RESUME) {
@@ -1630,6 +1629,7 @@ static void handle_port_status(struct xhci_hcd *xhci,
 			bus_state->port_remote_wakeup |= 1 << hcd_portnum;
 			xhci_test_and_clear_bit(xhci, port, PORT_PLC);
 			xhci_set_link_state(xhci, port, XDEV_U0);
+			usb_hcd_start_port_resume(&hcd->self, hcd_portnum);
 			/* Need to wait until the next link state change
 			 * indicates the device is actually in U0.
 			 */
@@ -1669,7 +1669,6 @@ static void handle_port_status(struct xhci_hcd *xhci,
 		if (slot_id && xhci->devs[slot_id])
 			xhci_ring_device(xhci, slot_id);
 		if (bus_state->port_remote_wakeup & (1 << hcd_portnum)) {
-			bus_state->port_remote_wakeup &= ~(1 << hcd_portnum);
 			xhci_test_and_clear_bit(xhci, port, PORT_PLC);
 			usb_wakeup_notification(hcd->self.root_hub,
 					hcd_portnum + 1);
-- 
2.17.1

