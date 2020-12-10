Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12D642D55DA
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 09:56:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728200AbgLJI4r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 03:56:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:49154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388179AbgLJI4D (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Dec 2020 03:56:03 -0500
Subject: patch "xhci: Give USB2 ports time to enter U3 in bus suspend" added to usb-next
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1607590523;
        bh=8fgOLgVVuoBrT1yR37mSd9FCTh9h+bvZZqsfwVeV3E8=;
        h=To:From:Date:From;
        b=hjNNbsW82ukLIS1o7FGwGdhG4G7edn2Y8ljrzFGrmzv/sghB8rZTMh5bBdROUg/zN
         Yix80jN4KOMlZnTsNax8bPhKdIr+rt/+JiXvq2w3BW+Wdbu39eS3RAo26Qb5IjdY7A
         dH9j8QPQ0AnTMbMCSfgKDDUW88z5z/4vOP0L+/68=
To:     jun.li@nxp.com, gregkh@linuxfoundation.org,
        mathias.nyman@linux.intel.com, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 10 Dec 2020 09:56:29 +0100
Message-ID: <160759058916392@kroah.com>
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
in the usb-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

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


