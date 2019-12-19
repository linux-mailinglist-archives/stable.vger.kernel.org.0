Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA3651261A4
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 13:05:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727201AbfLSMEn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 07:04:43 -0500
Received: from mga14.intel.com ([192.55.52.115]:31176 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727189AbfLSMEm (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 07:04:42 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Dec 2019 04:04:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,331,1571727600"; 
   d="scan'208";a="222273941"
Received: from mattu-haswell.fi.intel.com ([10.237.72.170])
  by fmsmga001.fm.intel.com with ESMTP; 19 Dec 2019 04:04:40 -0800
From:   Mathias Nyman <mathias.nyman@linux.intel.com>
To:     stable@vger.kernel.org
Cc:     Mathias Nyman <mathias.nyman@linux.intel.com>,
        Lee Hou-hsun <hou-hsun.lee@intel.com>,
        Lee Chiasheng <chiasheng.lee@intel.com>
Subject: [PATCH backport 4.9 4.4] xhci: fix USB3 device initiated resume race with roothub autosuspend
Date:   Thu, 19 Dec 2019 14:06:32 +0200
Message-Id: <20191219120632.4037-1-mathias.nyman@linux.intel.com>
X-Mailer: git-send-email 2.17.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 057d476fff778f1d3b9f861fdb5437ea1a3cfc99 upstream

Backport for 4.9 and 4.4 stable kernels

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

Cc: Lee Hou-hsun <hou-hsun.lee@intel.com>
Cc: Lee Chiasheng <chiasheng.lee@intel.com>
Reported-by: Lee Chiasheng <chiasheng.lee@intel.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
---
 drivers/usb/host/xhci-hub.c  | 8 ++++++++
 drivers/usb/host/xhci-ring.c | 6 +-----
 drivers/usb/host/xhci.h      | 1 +
 3 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/host/xhci-hub.c b/drivers/usb/host/xhci-hub.c
index 39e2d3271035..1d9cb29400f3 100644
--- a/drivers/usb/host/xhci-hub.c
+++ b/drivers/usb/host/xhci-hub.c
@@ -760,6 +760,14 @@ static u32 xhci_get_port_status(struct usb_hcd *hcd,
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
index 69ad9817076a..b426c83ecb9b 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -1609,9 +1609,6 @@ static void handle_port_status(struct xhci_hcd *xhci,
 		usb_hcd_resume_root_hub(hcd);
 	}
 
-	if (hcd->speed >= HCD_USB3 && (temp & PORT_PLS_MASK) == XDEV_INACTIVE)
-		bus_state->port_remote_wakeup &= ~(1 << faked_port_index);
-
 	if ((temp & PORT_PLC) && (temp & PORT_PLS_MASK) == XDEV_RESUME) {
 		xhci_dbg(xhci, "port resume event for port %d\n", port_id);
 
@@ -1630,6 +1627,7 @@ static void handle_port_status(struct xhci_hcd *xhci,
 			bus_state->port_remote_wakeup |= 1 << faked_port_index;
 			xhci_test_and_clear_bit(xhci, port_array,
 					faked_port_index, PORT_PLC);
+			usb_hcd_start_port_resume(&hcd->self, faked_port_index);
 			xhci_set_link_state(xhci, port_array, faked_port_index,
 						XDEV_U0);
 			/* Need to wait until the next link state change
@@ -1667,8 +1665,6 @@ static void handle_port_status(struct xhci_hcd *xhci,
 		if (slot_id && xhci->devs[slot_id])
 			xhci_ring_device(xhci, slot_id);
 		if (bus_state->port_remote_wakeup & (1 << faked_port_index)) {
-			bus_state->port_remote_wakeup &=
-				~(1 << faked_port_index);
 			xhci_test_and_clear_bit(xhci, port_array,
 					faked_port_index, PORT_PLC);
 			usb_wakeup_notification(hcd->self.root_hub,
diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
index de4771ce0df6..424c07d1ac0e 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -316,6 +316,7 @@ struct xhci_op_regs {
 #define XDEV_U3		(0x3 << 5)
 #define XDEV_INACTIVE	(0x6 << 5)
 #define XDEV_POLLING	(0x7 << 5)
+#define XDEV_RECOVERY	(0x8 << 5)
 #define XDEV_COMP_MODE  (0xa << 5)
 #define XDEV_RESUME	(0xf << 5)
 /* true: port has power (see HCC_PPC) */
-- 
2.17.1

