Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD35211F6FA
	for <lists+stable@lfdr.de>; Sun, 15 Dec 2019 10:27:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726094AbfLOJ17 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Dec 2019 04:27:59 -0500
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:36831 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726049AbfLOJ17 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 15 Dec 2019 04:27:59 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 52FF96A2;
        Sun, 15 Dec 2019 04:27:58 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sun, 15 Dec 2019 04:27:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=sWKCIx
        sefwVbU9CIZKAHm6tUp1FF5E25es+fCB2qnSU=; b=Ovdcd6wyXusvncS9a/UZyR
        yj5+ujQKBHU0qvojqObhudAbi0rd5fKAlBVH5kcnmRu/suFPcWgFZA1pyhSdyZRG
        w78uvaROVGYx8MsIAx8q3NFwqVjpw4+gP1Npx3tmsA6LJ1YBGIxrourAak/yfIt5
        Wq0GYLsBoExBE1vxEMpl3RGLONeD7KK2rdJG0EGZWfIB8pUOqHD402YjWS6QvuVQ
        dWuQ0cB2+8BYNMEVXBn8X2hWpYdukVeVCaCcFxBH5kh8xnViPlDen+8bJ2aBealB
        NLcIHgFs+Pb3Z/wkoD9j1qeUYFs5B9t/TtbNwxRvXIr2wetCJbHmQx+PKktbB53w
        ==
X-ME-Sender: <xms:nfz1Xb7V2winnUGOt1Tptqjyep-Yri_pZFYF2ozpDF5zyu4WOBQYIQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvddtfedgtdehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrd
    dutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhen
    ucevlhhushhtvghrufhiiigvpeef
X-ME-Proxy: <xmx:nfz1XS-8e0PhPOOoFZ20uL76me2McZxgE15WcCEJRXKkZEcAN-Kcyg>
    <xmx:nfz1XcihgJddxrbPOeLA5MgjtLeSMHy1ZC5tIKhWo2K-hQtHGM07fA>
    <xmx:nfz1XW19J60WS0I-qZogBkI-x_Y8oTyVk0atYjGuCv25pCxmGV_tYQ>
    <xmx:nfz1XVPtgaktav5zfRqh5WWjSgxU5OSGR-mEJWHskYUzG-8hwDS-jw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 574778005B;
        Sun, 15 Dec 2019 04:27:57 -0500 (EST)
Subject: FAILED: patch "[PATCH] xhci: make sure interrupts are restored to correct state" failed to apply to 4.9-stable tree
To:     mathias.nyman@linux.intel.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 15 Dec 2019 10:27:51 +0100
Message-ID: <1576402071250110@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From bd82873f23c9a6ad834348f8b83f3b6a5bca2c65 Mon Sep 17 00:00:00 2001
From: Mathias Nyman <mathias.nyman@linux.intel.com>
Date: Wed, 11 Dec 2019 16:20:07 +0200
Subject: [PATCH] xhci: make sure interrupts are restored to correct state

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
 

