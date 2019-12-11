Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D02BE11AD8A
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 15:33:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729841AbfLKOdX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 09:33:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:38132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727851AbfLKOdW (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 09:33:22 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1CC7322B48;
        Wed, 11 Dec 2019 14:33:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576074801;
        bh=LeafcZ8rXSfByTPKdliGGIxO7zF0URiJs/ONTauq2KQ=;
        h=Subject:To:From:Date:From;
        b=K/JIzAVUCayQX8uujJ2TmVqcmwa/RzQshfzYGFKgVaHv/PztRXMHH/u4qiTVi5guD
         8vjWONBHZ0Zv7dATgWb3eo1fXIXvDh4yBBLYauVtpTYP9pt60xJnSB4ULnTpj/laKR
         hIoyBwaQnqBMlWURKe2V6CCvMksrOx/jRlDSFBoo=
Subject: patch "xhci: make sure interrupts are restored to correct state" added to usb-linus
To:     mathias.nyman@linux.intel.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 11 Dec 2019 15:33:11 +0100
Message-ID: <1576074791102252@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    xhci: make sure interrupts are restored to correct state

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From bd82873f23c9a6ad834348f8b83f3b6a5bca2c65 Mon Sep 17 00:00:00 2001
From: Mathias Nyman <mathias.nyman@linux.intel.com>
Date: Wed, 11 Dec 2019 16:20:07 +0200
Subject: xhci: make sure interrupts are restored to correct state

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
Link: https://lore.kernel.org/r/20191211142007.8847-7-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
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
2.24.1


