Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70F871B298F
	for <lists+stable@lfdr.de>; Tue, 21 Apr 2020 16:28:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728671AbgDUO2t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Apr 2020 10:28:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:41708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726628AbgDUO2s (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 Apr 2020 10:28:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E12E9206F4;
        Tue, 21 Apr 2020 14:28:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587479327;
        bh=taE9+PJf9lU75wnrJDYim0hwcdRB2/SdDok+nmr+B0E=;
        h=Subject:To:From:Date:From;
        b=mTfP5SqFuyD39B2xsjztMwRtmvHqpN6W/9PtJt3ekS/6DI0BhxHMfL4AKPXXwtMpX
         xCKuLHRcXJvaWgPw6B2WiN1y90IXh/6q3pXXjWG6aQlSTX+hxWPbBl/qV3Cp2CI7X9
         hIKvzqaPgfCQprABP2swJbxbpIi64ratrqoc7Hrg=
Subject: patch "xhci: prevent bus suspend if a roothub port detected a over-current" added to usb-linus
To:     mathias.nyman@linux.intel.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 21 Apr 2020 16:28:20 +0200
Message-ID: <158747930012339@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    xhci: prevent bus suspend if a roothub port detected a over-current

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From e9fb08d617bfae5471d902112667d0eeb9dee3c4 Mon Sep 17 00:00:00 2001
From: Mathias Nyman <mathias.nyman@linux.intel.com>
Date: Tue, 21 Apr 2020 17:08:21 +0300
Subject: xhci: prevent bus suspend if a roothub port detected a over-current
 condition

Suspending the bus and host controller while a port is in a over-current
condition may halt the host.
Also keep the roothub running if over-current is active.

Cc: <stable@vger.kernel.org>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20200421140822.28233-3-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-hub.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/usb/host/xhci-hub.c b/drivers/usb/host/xhci-hub.c
index 9eca1fe81061..f37316d2c8fa 100644
--- a/drivers/usb/host/xhci-hub.c
+++ b/drivers/usb/host/xhci-hub.c
@@ -1571,6 +1571,8 @@ int xhci_hub_status_data(struct usb_hcd *hcd, char *buf)
 		}
 		if ((temp & PORT_RC))
 			reset_change = true;
+		if (temp & PORT_OC)
+			status = 1;
 	}
 	if (!status && !reset_change) {
 		xhci_dbg(xhci, "%s: stopping port polling.\n", __func__);
@@ -1636,6 +1638,13 @@ int xhci_bus_suspend(struct usb_hcd *hcd)
 				 port_index);
 			goto retry;
 		}
+		/* bail out if port detected a over-current condition */
+		if (t1 & PORT_OC) {
+			bus_state->bus_suspended = 0;
+			spin_unlock_irqrestore(&xhci->lock, flags);
+			xhci_dbg(xhci, "Bus suspend bailout, port over-current detected\n");
+			return -EBUSY;
+		}
 		/* suspend ports in U0, or bail out for new connect changes */
 		if ((t1 & PORT_PE) && (t1 & PORT_PLS_MASK) == XDEV_U0) {
 			if ((t1 & PORT_CSC) && wake_enabled) {
-- 
2.26.2


