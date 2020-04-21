Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD5DA1B2990
	for <lists+stable@lfdr.de>; Tue, 21 Apr 2020 16:28:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728316AbgDUO2v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Apr 2020 10:28:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:41740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726628AbgDUO2v (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 Apr 2020 10:28:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4F159206B9;
        Tue, 21 Apr 2020 14:28:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587479329;
        bh=8dUTNpU6gEEFnpgFYso1t0ss0oTDAtDmwCq2aFDYHpE=;
        h=Subject:To:From:Date:From;
        b=JJUshre6+ziDU6siq74k/1AUO1exagTgrutADXFRjiMUjRTQ5yD18QPHDM7UvuL+E
         RWbVj6iZgApXzwSO0pkm5SKQMGbSlfrggemKiC35viAHoAZdi2fYW59UFFiD4WNrwo
         XmiZGvj3s//OjJelNuD4/qjmIxXbimCoPNFDjk2U=
Subject: patch "xhci: Don't clear hub TT buffer on ep0 protocol stall" added to usb-linus
To:     mathias.nyman@linux.intel.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 21 Apr 2020 16:28:21 +0200
Message-ID: <1587479301865@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    xhci: Don't clear hub TT buffer on ep0 protocol stall

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 8f97250c21f0cf36434bf5b7ddf4377406534cd1 Mon Sep 17 00:00:00 2001
From: Mathias Nyman <mathias.nyman@linux.intel.com>
Date: Tue, 21 Apr 2020 17:08:22 +0300
Subject: xhci: Don't clear hub TT buffer on ep0 protocol stall

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
 drivers/usb/host/xhci-ring.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index a7f4cd35da55..0fda0c0f4d31 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -1876,7 +1876,6 @@ static void xhci_cleanup_halted_endpoint(struct xhci_hcd *xhci,
 		ep->ep_state |= EP_HARD_CLEAR_TOGGLE;
 		xhci_cleanup_stalled_ring(xhci, slot_id, ep_index, stream_id,
 					  td);
-		xhci_clear_hub_tt_buffer(xhci, td, ep);
 	}
 	xhci_ring_cmd_db(xhci);
 }
@@ -1997,11 +1996,18 @@ static int finish_td(struct xhci_hcd *xhci, struct xhci_td *td,
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
-- 
2.26.2


