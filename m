Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35B65506E9
	for <lists+stable@lfdr.de>; Mon, 24 Jun 2019 12:06:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729417AbfFXKCl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 06:02:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:33878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728656AbfFXKCi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Jun 2019 06:02:38 -0400
Received: from localhost (f4.8f.5177.ip4.static.sl-reverse.com [119.81.143.244])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D7819205ED;
        Mon, 24 Jun 2019 10:02:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561370558;
        bh=rukFq4RrZFg9OQDZWu6H1lVu3OmS3h/nOWo/d04IVHo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eGNPEEbO7DdWJYKXgL43VKRdNyYkvgYMOIodRpbokZ+9sZE/SHqy0g8l0EAapQ7rM
         tPv/X0XpWLOVg/K+1tQs8Mq3OrvtozOY3+QsOpCL/uxRP1OdDSc/oaj86pUUVSUS2t
         GuagpUp6FK00p5Do4J0j3tVDMWbfd+FwwoCTmxDQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Rapolu Chiranjeevi <chiranjeevi.rapolu@intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 4.19 19/90] usb: xhci: Dont try to recover an endpoint if port is in error state.
Date:   Mon, 24 Jun 2019 17:56:09 +0800
Message-Id: <20190624092315.271088087@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190624092313.788773607@linuxfoundation.org>
References: <20190624092313.788773607@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mathias Nyman <mathias.nyman@linux.intel.com>

commit b8c3b718087bf7c3c8e388eb1f72ac1108a4926e upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/xhci-ring.c |   15 ++++++++++++++-
 drivers/usb/host/xhci.c      |    5 +++++
 drivers/usb/host/xhci.h      |    9 +++++++++
 3 files changed, 28 insertions(+), 1 deletion(-)

--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -1604,8 +1604,13 @@ static void handle_port_status(struct xh
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
@@ -1793,6 +1798,14 @@ static void xhci_cleanup_halted_endpoint
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
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -1441,6 +1441,10 @@ static int xhci_urb_enqueue(struct usb_h
 			xhci_dbg(xhci, "urb submitted during PCI suspend\n");
 		return -ESHUTDOWN;
 	}
+	if (xhci->devs[slot_id]->flags & VDEV_PORT_ERROR) {
+		xhci_dbg(xhci, "Can't queue urb, port error, link inactive\n");
+		return -ENODEV;
+	}
 
 	if (usb_endpoint_xfer_isoc(&urb->ep->desc))
 		num_tds = urb->number_of_packets;
@@ -3724,6 +3728,7 @@ static int xhci_discover_or_reset_device
 	}
 	/* If necessary, update the number of active TTs on this root port */
 	xhci_update_tt_active_eps(xhci, virt_dev, old_active_eps);
+	virt_dev->flags = 0;
 	ret = 0;
 
 command_cleanup:
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


