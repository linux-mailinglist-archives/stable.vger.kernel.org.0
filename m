Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AFA711AD8B
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 15:33:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729879AbfLKOdY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 09:33:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:38168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729858AbfLKOdY (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 09:33:24 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ACA3F20836;
        Wed, 11 Dec 2019 14:33:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576074804;
        bh=Jac2Nl1IQ5Dv3qbwCDowRavPWjG01jXiGy6kyzYEjR8=;
        h=Subject:To:From:Date:From;
        b=hFQc6F0heUsDmH9kWrwCDMRzlUAG47heS0jU/9zcR8I8QYmp2v/EPtdx6QeIIR0zc
         6/M5YqqbTQ5/Ummyi/DSp/RaY4dDIdb7Us80+wZ6jQPBnzFOYp+V0AvF4Tzq40RJD9
         2KW/w1nyC+YrN9mywyU/OKr7HdqhIt30gR94YP9s=
Subject: patch "xhci: handle some XHCI_TRUST_TX_LENGTH quirks cases as default" added to usb-linus
To:     mathias.nyman@linux.intel.com, ardb@kernel.org,
        eli.billauer@gmail.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 11 Dec 2019 15:33:11 +0100
Message-ID: <1576074791125224@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    xhci: handle some XHCI_TRUST_TX_LENGTH quirks cases as default

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 7ff11162808cc2ec66353fc012c58bb449c892c3 Mon Sep 17 00:00:00 2001
From: Mathias Nyman <mathias.nyman@linux.intel.com>
Date: Wed, 11 Dec 2019 16:20:06 +0200
Subject: xhci: handle some XHCI_TRUST_TX_LENGTH quirks cases as default
 behaviour.

xhci driver claims it needs XHCI_TRUST_TX_LENGTH quirk for both
Broadcom/Cavium and a Renesas xHC controllers.

The quirk was inteded for handling false "success" complete event for
transfers that had data left untransferred.
These transfers should complete with "short packet" events instead.

In these two new cases the false "success" completion is reported
after a "short packet" if the TD consists of several TRBs.
xHCI specs 4.10.1.1.2 say remaining TRBs should report "short packet"
as well after the first short packet in a TD, but this issue seems so
common it doesn't make sense to add the quirk for all vendors.

Turn these events into short packets automatically instead.

This gets rid of the  "The WARN Successful completion on short TX for
slot 1 ep 1: needs XHCI_TRUST_TX_LENGTH quirk" warning in many cases.

Cc: <stable@vger.kernel.org>
Reported-by: Eli Billauer <eli.billauer@gmail.com>
Reported-by: Ard Biesheuvel <ardb@kernel.org>
Tested-by: Eli Billauer <eli.billauer@gmail.com>
Tested-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20191211142007.8847-6-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-ring.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index 9ebaa8e132a9..d23f7408c81f 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -2381,7 +2381,8 @@ static int handle_tx_event(struct xhci_hcd *xhci,
 	case COMP_SUCCESS:
 		if (EVENT_TRB_LEN(le32_to_cpu(event->transfer_len)) == 0)
 			break;
-		if (xhci->quirks & XHCI_TRUST_TX_LENGTH)
+		if (xhci->quirks & XHCI_TRUST_TX_LENGTH ||
+		    ep_ring->last_td_was_short)
 			trb_comp_code = COMP_SHORT_PACKET;
 		else
 			xhci_warn_ratelimited(xhci,
-- 
2.24.1


