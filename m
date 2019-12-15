Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D74F111F6F9
	for <lists+stable@lfdr.de>; Sun, 15 Dec 2019 10:27:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726081AbfLOJ14 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Dec 2019 04:27:56 -0500
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:49689 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726049AbfLOJ1z (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 15 Dec 2019 04:27:55 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id B228E6A5;
        Sun, 15 Dec 2019 04:27:54 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sun, 15 Dec 2019 04:27:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=0Da5nz
        u7uLnRTld2/aTroMTqGNIaQSp7Q4tV8ELRA/E=; b=OyY9z1Jz14GQ+f+s+5rhl3
        B4aNEOEcBspjm5drIL6mv/kc8ofTfsw03vqEYFyeWM/MnNugZognA/YRz/PeAgUj
        ehJQHknmzaDpovyTlTDEHvf51V/zA4S8rb8y4zy0zpT9hYHLPRrVPcjY1pWlXzyn
        SxSsh1zPJK12/vwHkSIoD6oQ0eLiAMdS6JckPKMSw6vR9PTmrpsSyBsPav8SioUV
        ImTNfyuobx9cW7o8OFJ+ic1/QDvrqIsC84FS6aJSLGVZ5EV+bOrF0cYZ4mQbfTJT
        YnBlNHJG8tRRvn8uGJ60LA9AeCUmrwSX+stW16ZFm4YZgU+anDu5jDJNVGYvh7Lg
        ==
X-ME-Sender: <xms:mvz1XfPX5rWv0xa-Q1OE4LpNHQBZNRbawTUPsxzJabqaJnXw5-8nPw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvddtfedgtdehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrd
    dutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhen
    ucevlhhushhtvghrufhiiigvpedu
X-ME-Proxy: <xmx:mvz1XfuMntricPJmB09ve24setmnqYlCJVixZcjRhMJ9859NZ66C5A>
    <xmx:mvz1XcXXkgULJOev2kQIVz2KdN8MHhPa5yiBRV49Sa9GxG1xBM0qCA>
    <xmx:mvz1XeTDEBbRocmz2kX9n36qxv7lTE5Z1dqDStvg3jt-puHII8sr4A>
    <xmx:mvz1XWwBINqJRZpEnmAy37KT7yLsBYTi0EkRT-kPG7GcYtMfiirsKQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id A180880059;
        Sun, 15 Dec 2019 04:27:53 -0500 (EST)
Subject: FAILED: patch "[PATCH] xhci: make sure interrupts are restored to correct state" failed to apply to 4.4-stable tree
To:     mathias.nyman@linux.intel.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 15 Dec 2019 10:27:50 +0100
Message-ID: <1576402070242197@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
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
 

