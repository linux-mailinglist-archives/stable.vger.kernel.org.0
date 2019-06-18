Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 272DD4A3DC
	for <lists+stable@lfdr.de>; Tue, 18 Jun 2019 16:25:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729078AbfFROZC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jun 2019 10:25:02 -0400
Received: from mga07.intel.com ([134.134.136.100]:24098 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728982AbfFROZC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Jun 2019 10:25:02 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Jun 2019 07:25:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,389,1557212400"; 
   d="scan'208";a="243006661"
Received: from mattu-haswell.fi.intel.com ([10.237.72.164])
  by orsmga001.jf.intel.com with ESMTP; 18 Jun 2019 07:25:00 -0700
From:   Mathias Nyman <mathias.nyman@linux.intel.com>
To:     <gregkh@linuxfoundation.org>
Cc:     <linux-usb@vger.kernel.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        stable@vger.kernel.org
Subject: [PATCH 1/2] usb: xhci: Don't try to recover an endpoint if port is in error state.
Date:   Tue, 18 Jun 2019 17:27:47 +0300
Message-Id: <1560868068-2583-2-git-send-email-mathias.nyman@linux.intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1560868068-2583-1-git-send-email-mathias.nyman@linux.intel.com>
References: <1560868068-2583-1-git-send-email-mathias.nyman@linux.intel.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 drivers/usb/host/xhci-ring.c | 15 ++++++++++++++-
 drivers/usb/host/xhci.c      |  5 +++++
 drivers/usb/host/xhci.h      |  9 +++++++++
 3 files changed, 28 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index feffceb..121782e 100644
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
index 20db378..78a2a93 100644
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
index 7f8b950..92e764c 100644
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
2.7.4

