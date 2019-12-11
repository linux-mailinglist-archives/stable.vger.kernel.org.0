Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55CBB11AD38
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 15:18:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729855AbfLKOSl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 09:18:41 -0500
Received: from mga07.intel.com ([134.134.136.100]:52849 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727554AbfLKOSl (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 09:18:41 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Dec 2019 06:18:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,301,1571727600"; 
   d="scan'208";a="414868256"
Received: from mattu-haswell.fi.intel.com ([10.237.72.170])
  by fmsmga006.fm.intel.com with ESMTP; 11 Dec 2019 06:18:38 -0800
From:   Mathias Nyman <mathias.nyman@linux.intel.com>
To:     <gregkh@linuxfoundation.org>
Cc:     <linux-usb@vger.kernel.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        stable@vger.kernel.org
Subject: [PATCH 6/6] xhci: make sure interrupts are restored to correct state
Date:   Wed, 11 Dec 2019 16:20:07 +0200
Message-Id: <20191211142007.8847-7-mathias.nyman@linux.intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191211142007.8847-1-mathias.nyman@linux.intel.com>
References: <20191211142007.8847-1-mathias.nyman@linux.intel.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

spin_unlock_irqrestore() might be called with stale flags after
reading port status, possibly restoring interrupts to a incorrect
state.

If a usb2 port just finished resuming while the port status is read
the spin lock will be temporary released and re-acquired in a separate
function. The flags parameter is passed as value instead of a pointer,
not updating flags properly before the final spin_unlock_irqrestore()
is called.

Cc: <stable@vger.kernel.org> # v3.12+
Fixes: 8b3d45705e54 ("usb: Fix xHCI host issues on remote wakeup.")
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
---
 drivers/usb/host/xhci-hub.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/host/xhci-hub.c b/drivers/usb/host/xhci-hub.c
index 4b870cd6c575..7a3a29e5e9d2 100644
--- a/drivers/usb/host/xhci-hub.c
+++ b/drivers/usb/host/xhci-hub.c
@@ -806,7 +806,7 @@ static void xhci_del_comp_mod_timer(struct xhci_hcd *xhci, u32 status,
 
 static int xhci_handle_usb2_port_link_resume(struct xhci_port *port,
 					     u32 *status, u32 portsc,
-					     unsigned long flags)
+					     unsigned long *flags)
 {
 	struct xhci_bus_state *bus_state;
 	struct xhci_hcd	*xhci;
@@ -860,11 +860,11 @@ static int xhci_handle_usb2_port_link_resume(struct xhci_port *port,
 		xhci_test_and_clear_bit(xhci, port, PORT_PLC);
 		xhci_set_link_state(xhci, port, XDEV_U0);
 
-		spin_unlock_irqrestore(&xhci->lock, flags);
+		spin_unlock_irqrestore(&xhci->lock, *flags);
 		time_left = wait_for_completion_timeout(
 			&bus_state->rexit_done[wIndex],
 			msecs_to_jiffies(XHCI_MAX_REXIT_TIMEOUT_MS));
-		spin_lock_irqsave(&xhci->lock, flags);
+		spin_lock_irqsave(&xhci->lock, *flags);
 
 		if (time_left) {
 			slot_id = xhci_find_slot_id_by_port(hcd, xhci,
@@ -967,7 +967,7 @@ static void xhci_get_usb3_port_status(struct xhci_port *port, u32 *status,
 }
 
 static void xhci_get_usb2_port_status(struct xhci_port *port, u32 *status,
-				      u32 portsc, unsigned long flags)
+				      u32 portsc, unsigned long *flags)
 {
 	struct xhci_bus_state *bus_state;
 	u32 link_state;
@@ -1017,7 +1017,7 @@ static void xhci_get_usb2_port_status(struct xhci_port *port, u32 *status,
 static u32 xhci_get_port_status(struct usb_hcd *hcd,
 		struct xhci_bus_state *bus_state,
 	u16 wIndex, u32 raw_port_status,
-		unsigned long flags)
+		unsigned long *flags)
 	__releases(&xhci->lock)
 	__acquires(&xhci->lock)
 {
@@ -1140,7 +1140,7 @@ int xhci_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue,
 		}
 		trace_xhci_get_port_status(wIndex, temp);
 		status = xhci_get_port_status(hcd, bus_state, wIndex, temp,
-					      flags);
+					      &flags);
 		if (status == 0xffffffff)
 			goto error;
 
-- 
2.17.1

