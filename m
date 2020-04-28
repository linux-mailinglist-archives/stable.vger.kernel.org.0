Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2084A1BC9F0
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 20:48:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731353AbgD1SoN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:44:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:37078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731347AbgD1SoK (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:44:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3B9A6206D6;
        Tue, 28 Apr 2020 18:44:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588099449;
        bh=PvhzddcV4LfMVCiDpVZEFtGJ0jU8K4eM4uyLQeZ+RjQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OD/v0S0cc1nf82iA/MCR3zpy4D+uqQUmI7n5HN7WVjHxuFBYFgo4o+3B1787zipe0
         j9zni1y0bx0REpX/eVOddzsHh1aZY0nRG+Z9wjLYgUNeji0fOFhlMU1s4JDUmpya6W
         kjLsgUoqC9nYBtMzZXrzEVEGD21izKCUS15l15Yo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 5.4 156/168] xhci: Dont clear hub TT buffer on ep0 protocol stall
Date:   Tue, 28 Apr 2020 20:25:30 +0200
Message-Id: <20200428182250.939365900@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200428182231.704304409@linuxfoundation.org>
References: <20200428182231.704304409@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mathias Nyman <mathias.nyman@linux.intel.com>

commit 8f97250c21f0cf36434bf5b7ddf4377406534cd1 upstream.

The default control endpoint ep0 can return a STALL indicating the
device does not support the control transfer requests. This is called
a protocol stall and does not halt the endpoint.

xHC behaves a bit different. Its internal endpoint state will always
be halted on any stall, even if the device side of the endpiont is not
halted. So we do need to issue the reset endpoint command to clear the
xHC host intenal endpoint halt state, but should not request the HS hub
to clear the TT buffer unless device side of endpoint is halted.

Clearing the hub TT buffer at protocol stall caused ep0 to become
unresponsive for some FS/LS devices behind HS hubs, and class drivers
failed to set the interface due to timeout:

usb 1-2.1: 1:1: usb_set_interface failed (-110)

Fixes: ef513be0a905 ("usb: xhci: Add Clear_TT_Buffer")
Cc: <stable@vger.kernel.org> # v5.3
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20200421140822.28233-4-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/xhci-ring.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -1868,7 +1868,6 @@ static void xhci_cleanup_halted_endpoint
 		ep->ep_state |= EP_HARD_CLEAR_TOGGLE;
 		xhci_cleanup_stalled_ring(xhci, slot_id, ep_index, stream_id,
 					  td);
-		xhci_clear_hub_tt_buffer(xhci, td, ep);
 	}
 	xhci_ring_cmd_db(xhci);
 }
@@ -1989,11 +1988,18 @@ static int finish_td(struct xhci_hcd *xh
 	if (trb_comp_code == COMP_STALL_ERROR ||
 		xhci_requires_manual_halt_cleanup(xhci, ep_ctx,
 						trb_comp_code)) {
-		/* Issue a reset endpoint command to clear the host side
-		 * halt, followed by a set dequeue command to move the
-		 * dequeue pointer past the TD.
-		 * The class driver clears the device side halt later.
+		/*
+		 * xhci internal endpoint state will go to a "halt" state for
+		 * any stall, including default control pipe protocol stall.
+		 * To clear the host side halt we need to issue a reset endpoint
+		 * command, followed by a set dequeue command to move past the
+		 * TD.
+		 * Class drivers clear the device side halt from a functional
+		 * stall later. Hub TT buffer should only be cleared for FS/LS
+		 * devices behind HS hubs for functional stalls.
 		 */
+		if ((ep_index != 0) || (trb_comp_code != COMP_STALL_ERROR))
+			xhci_clear_hub_tt_buffer(xhci, td, ep);
 		xhci_cleanup_halted_endpoint(xhci, slot_id, ep_index,
 					ep_ring->stream_id, td, EP_HARD_RESET);
 	} else {


