Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8BD52D4347
	for <lists+stable@lfdr.de>; Wed,  9 Dec 2020 14:32:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732352AbgLINcC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Dec 2020 08:32:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:42470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732040AbgLINcC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 9 Dec 2020 08:32:02 -0500
Subject: patch "xhci: Give USB2 ports time to enter U3 in bus suspend" added to usb-testing
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1607520681;
        bh=dADRuK+aZgaswmRPkaKqPBRjwei0DFgM0e4B34LW1j8=;
        h=To:From:Date:From;
        b=bWexI4oRzOSIw8OBhLWudiExo7ecYJypJjyZYJT7I1UXaGHtNDDC2DNcoLzPKLJqK
         O30xxM/DwNq+TGm64YrhHBC19hRCegg19lozwGSvDOkiPoURFILxggrBnykRReDGLx
         ydkyFC6TQN/QRn0/csgxWbCN6x/Us58sGXMYGvVs=
To:     jun.li@nxp.com, gregkh@linuxfoundation.org,
        mathias.nyman@linux.intel.com, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 09 Dec 2020 14:32:13 +0100
Message-ID: <1607520733136231@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    xhci: Give USB2 ports time to enter U3 in bus suspend

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the usb-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From c1373f10479b624fb6dba0805d673e860f1b421d Mon Sep 17 00:00:00 2001
From: Li Jun <jun.li@nxp.com>
Date: Tue, 8 Dec 2020 11:29:12 +0200
Subject: xhci: Give USB2 ports time to enter U3 in bus suspend

If a USB2 device wakeup is not enabled/supported the link state may
still be in U0 in xhci_bus_suspend(), where it's then manually put
to suspended U3 state.

Just as with selective suspend the device needs time to enter U3
suspend before continuing with further suspend operations
(e.g. system suspend), otherwise we may enter system suspend with link
state in U0.

[commit message rewording -Mathias]

Cc: <stable@vger.kernel.org>
Signed-off-by: Li Jun <jun.li@nxp.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20201208092912.1773650-6-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-hub.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/usb/host/xhci-hub.c b/drivers/usb/host/xhci-hub.c
index c799ca5361d4..74c497fd3476 100644
--- a/drivers/usb/host/xhci-hub.c
+++ b/drivers/usb/host/xhci-hub.c
@@ -1712,6 +1712,10 @@ int xhci_bus_suspend(struct usb_hcd *hcd)
 	hcd->state = HC_STATE_SUSPENDED;
 	bus_state->next_statechange = jiffies + msecs_to_jiffies(10);
 	spin_unlock_irqrestore(&xhci->lock, flags);
+
+	if (bus_state->bus_suspended)
+		usleep_range(5000, 10000);
+
 	return 0;
 }
 
-- 
2.29.2


