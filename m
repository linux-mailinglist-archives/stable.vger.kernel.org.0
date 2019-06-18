Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 775154A663
	for <lists+stable@lfdr.de>; Tue, 18 Jun 2019 18:15:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729655AbfFRQPy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jun 2019 12:15:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:52364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729386AbfFRQPy (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Jun 2019 12:15:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 99759213F2;
        Tue, 18 Jun 2019 16:15:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560874554;
        bh=6auq0aCzEEdxBiTpUDAKZDPjNMktlQmkhCY+LSwgp+4=;
        h=Subject:To:From:Date:From;
        b=wE+LNoIEV9bE8xUiH+OLo8G+hsavnlVT5eOn1mxjSDKg6Hvq9ajntSBHruMQsGBWV
         vM4ffeF5fY0jq+sfOoaqh70ypmIw54PHExJGk7dCH9HfZ1Tgm7wCCZFaVg7Hbdzpem
         1fNuk1jrSEXzn75eal8vEAdZl7jCv3w/9Tiu9EEc=
Subject: patch "usb: xhci: Don't try to recover an endpoint if port is in error" added to usb-linus
To:     mathias.nyman@linux.intel.com, chiranjeevi.rapolu@intel.com,
        gregkh@linuxfoundation.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 18 Jun 2019 18:15:51 +0200
Message-ID: <1560874551213124@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: xhci: Don't try to recover an endpoint if port is in error

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From b8c3b718087bf7c3c8e388eb1f72ac1108a4926e Mon Sep 17 00:00:00 2001
From: Mathias Nyman <mathias.nyman@linux.intel.com>
Date: Tue, 18 Jun 2019 17:27:47 +0300
Subject: usb: xhci: Don't try to recover an endpoint if port is in error
 state.

A USB3 device needs to be reset and re-enumarated if the port it
connects to goes to a error state, with link state inactive.

There is no use in trying to recover failed transactions by resetting
endpoints at this stage. Tests show that in rare cases, after multiple
endpoint resets of a roothub port the whole host controller might stop
completely.

Several retries to recover from transaction error can happen as
it can take a long time before the hub thread discovers the USB3
port error and inactive link.

We can't reliably detect the port error from slot or endpoint context
due to a limitation in xhci, see xhci specs section 4.8.3:
"There are several cases where the EP State field in the Output
Endpoint Context may not reflect the current state of an endpoint"
and
"Software should maintain an accurate value for EP State, by tracking it
with an internal variable that is driven by Events and Doorbell accesses"

Same appears to be true for slot state.

set a flag to the corresponding slot if a USB3 roothub port link goes
inactive to prevent both queueing new URBs and resetting endpoints.

Reported-by: Rapolu Chiranjeevi <chiranjeevi.rapolu@intel.com>
Tested-by: Rapolu Chiranjeevi <chiranjeevi.rapolu@intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-ring.c | 15 ++++++++++++++-
 drivers/usb/host/xhci.c      |  5 +++++
 drivers/usb/host/xhci.h      |  9 +++++++++
 3 files changed, 28 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index feffceb31e8a..121782e22c01 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -1612,8 +1612,13 @@ static void handle_port_status(struct xhci_hcd *xhci,
 		usb_hcd_resume_root_hub(hcd);
 	}
 
-	if (hcd->speed >= HCD_USB3 && (portsc & PORT_PLS_MASK) == XDEV_INACTIVE)
+	if (hcd->speed >= HCD_USB3 &&
+	    (portsc & PORT_PLS_MASK) == XDEV_INACTIVE) {
+		slot_id = xhci_find_slot_id_by_port(hcd, xhci, hcd_portnum + 1);
+		if (slot_id && xhci->devs[slot_id])
+			xhci->devs[slot_id]->flags |= VDEV_PORT_ERROR;
 		bus_state->port_remote_wakeup &= ~(1 << hcd_portnum);
+	}
 
 	if ((portsc & PORT_PLC) && (portsc & PORT_PLS_MASK) == XDEV_RESUME) {
 		xhci_dbg(xhci, "port resume event for port %d\n", port_id);
@@ -1801,6 +1806,14 @@ static void xhci_cleanup_halted_endpoint(struct xhci_hcd *xhci,
 {
 	struct xhci_virt_ep *ep = &xhci->devs[slot_id]->eps[ep_index];
 	struct xhci_command *command;
+
+	/*
+	 * Avoid resetting endpoint if link is inactive. Can cause host hang.
+	 * Device will be reset soon to recover the link so don't do anything
+	 */
+	if (xhci->devs[slot_id]->flags & VDEV_PORT_ERROR)
+		return;
+
 	command = xhci_alloc_command(xhci, false, GFP_ATOMIC);
 	if (!command)
 		return;
diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 20db378a6012..78a2a937dd83 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -1466,6 +1466,10 @@ static int xhci_urb_enqueue(struct usb_hcd *hcd, struct urb *urb, gfp_t mem_flag
 			xhci_dbg(xhci, "urb submitted during PCI suspend\n");
 		return -ESHUTDOWN;
 	}
+	if (xhci->devs[slot_id]->flags & VDEV_PORT_ERROR) {
+		xhci_dbg(xhci, "Can't queue urb, port error, link inactive\n");
+		return -ENODEV;
+	}
 
 	if (usb_endpoint_xfer_isoc(&urb->ep->desc))
 		num_tds = urb->number_of_packets;
@@ -3754,6 +3758,7 @@ static int xhci_discover_or_reset_device(struct usb_hcd *hcd,
 	}
 	/* If necessary, update the number of active TTs on this root port */
 	xhci_update_tt_active_eps(xhci, virt_dev, old_active_eps);
+	virt_dev->flags = 0;
 	ret = 0;
 
 command_cleanup:
diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
index 7f8b950d1a73..92e764c54154 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -1010,6 +1010,15 @@ struct xhci_virt_device {
 	u8				real_port;
 	struct xhci_interval_bw_table	*bw_table;
 	struct xhci_tt_bw_info		*tt_info;
+	/*
+	 * flags for state tracking based on events and issued commands.
+	 * Software can not rely on states from output contexts because of
+	 * latency between events and xHC updating output context values.
+	 * See xhci 1.1 section 4.8.3 for more details
+	 */
+	unsigned long			flags;
+#define VDEV_PORT_ERROR			BIT(0) /* Port error, link inactive */
+
 	/* The current max exit latency for the enabled USB3 link states. */
 	u16				current_mel;
 	/* Used for the debugfs interfaces. */
-- 
2.22.0


