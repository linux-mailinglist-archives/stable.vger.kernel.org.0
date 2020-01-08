Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1EC9134BB0
	for <lists+stable@lfdr.de>; Wed,  8 Jan 2020 20:46:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730503AbgAHTqG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jan 2020 14:46:06 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43816 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730477AbgAHTqF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jan 2020 14:46:05 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1ipHHE-0006p3-66; Wed, 08 Jan 2020 19:46:00 +0000
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1ipHHD-007doj-7C; Wed, 08 Jan 2020 19:45:59 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Mathias Nyman" <mathias.nyman@linux.intel.com>,
        "Lee, Chiasheng" <chiasheng.lee@intel.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Lee, Hou-hsun" <hou-hsun.lee@intel.com>
Date:   Wed, 08 Jan 2020 19:43:51 +0000
Message-ID: <lsq.1578512578.115859111@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 53/63] xhci: fix USB3 device initiated resume race
 with roothub autosuspend
In-Reply-To: <lsq.1578512578.117275639@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.81-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Mathias Nyman <mathias.nyman@linux.intel.com>

commit 057d476fff778f1d3b9f861fdb5437ea1a3cfc99 upstream.

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

Cc: Lee, Hou-hsun <hou-hsun.lee@intel.com>
Reported-by: Lee, Chiasheng <chiasheng.lee@intel.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20191211142007.8847-3-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[Mathias Nyman: Backport for 4.9 and 4.4 stable kernels]
[bwh: Backported to 3.16: USB 3.0 SS is the highest speed we handle]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/host/xhci-hub.c  | 8 ++++++++
 drivers/usb/host/xhci-ring.c | 6 +-----
 drivers/usb/host/xhci.h      | 1 +
 3 files changed, 10 insertions(+), 5 deletions(-)

--- a/drivers/usb/host/xhci-hub.c
+++ b/drivers/usb/host/xhci-hub.c
@@ -612,6 +612,14 @@ static u32 xhci_get_port_status(struct u
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
 
 	if (hcd->speed != HCD_USB3) {
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -1605,9 +1605,6 @@ static void handle_port_status(struct xh
 		usb_hcd_resume_root_hub(hcd);
 	}
 
-	if (hcd->speed == HCD_USB3 && (temp & PORT_PLS_MASK) == XDEV_INACTIVE)
-		bus_state->port_remote_wakeup &= ~(1 << faked_port_index);
-
 	if ((temp & PORT_PLC) && (temp & PORT_PLS_MASK) == XDEV_RESUME) {
 		xhci_dbg(xhci, "port resume event for port %d\n", port_id);
 
@@ -1626,6 +1623,7 @@ static void handle_port_status(struct xh
 			bus_state->port_remote_wakeup |= 1 << faked_port_index;
 			xhci_test_and_clear_bit(xhci, port_array,
 					faked_port_index, PORT_PLC);
+			usb_hcd_start_port_resume(&hcd->self, faked_port_index);
 			xhci_set_link_state(xhci, port_array, faked_port_index,
 						XDEV_U0);
 			/* Need to wait until the next link state change
@@ -1663,8 +1661,6 @@ static void handle_port_status(struct xh
 		if (slot_id && xhci->devs[slot_id])
 			xhci_ring_device(xhci, slot_id);
 		if (bus_state->port_remote_wakeup & (1 << faked_port_index)) {
-			bus_state->port_remote_wakeup &=
-				~(1 << faked_port_index);
 			xhci_test_and_clear_bit(xhci, port_array,
 					faked_port_index, PORT_PLC);
 			usb_wakeup_notification(hcd->self.root_hub,
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -288,6 +288,7 @@ struct xhci_op_regs {
 #define XDEV_U3		(0x3 << 5)
 #define XDEV_INACTIVE	(0x6 << 5)
 #define XDEV_POLLING	(0x7 << 5)
+#define XDEV_RECOVERY	(0x8 << 5)
 #define XDEV_COMP_MODE  (0xa << 5)
 #define XDEV_RESUME	(0xf << 5)
 /* true: port has power (see HCC_PPC) */

