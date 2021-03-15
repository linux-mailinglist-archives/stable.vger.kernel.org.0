Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEF0733BA2A
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:10:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235626AbhCOOIP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:08:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:49180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233908AbhCOOCh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:02:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A04CA64E83;
        Mon, 15 Mar 2021 14:02:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816956;
        bh=UnvoTaee++uQmgZBcbDloBQf3a1K2DhIcoEylFd3FLI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QD75g8Xpux1j7MjKJG1R6Y604kCiYQU939qNnUxnbVBpp2ads8iU+KFXFj6x9BXE1
         st1c5xlaa0eU9T/oZjszZRHfDo5Dl7qd2pE7PaHo4fxfIhr7opiE5JoyT+w/rb7S6o
         crL1hcAG1gwPQKrwN64gdbm3lf2kXyfiHAG4nPgg=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 5.10 211/290] xhci: Fix repeated xhci wake after suspend due to uncleared internal wake state
Date:   Mon, 15 Mar 2021 14:55:04 +0100
Message-Id: <20210315135549.072829721@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135541.921894249@linuxfoundation.org>
References: <20210315135541.921894249@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Mathias Nyman <mathias.nyman@linux.intel.com>

commit d26c00e7276fc92b18c253d69e872f6b03832bad upstream.

If port terminations are detected in suspend, but link never reaches U0
then xHCI may have an internal uncleared wake state that will cause an
immediate wake after suspend.

This wake state is normally cleared when driver clears the PORT_CSC bit,
which is set after a device is enabled and in U0.

Write 1 to clear PORT_CSC for ports that don't have anything connected
when suspending. This makes sure any pending internal wake states in
xHCI are cleared.

Cc: stable@vger.kernel.org
Tested-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20210311115353.2137560-5-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci.c |   62 +++++++++++++++++++++++-------------------------
 1 file changed, 30 insertions(+), 32 deletions(-)

--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -883,44 +883,42 @@ static void xhci_clear_command_ring(stru
 	xhci_set_cmd_ring_deq(xhci);
 }
 
-static void xhci_disable_port_wake_on_bits(struct xhci_hcd *xhci)
+/*
+ * Disable port wake bits if do_wakeup is not set.
+ *
+ * Also clear a possible internal port wake state left hanging for ports that
+ * detected termination but never successfully enumerated (trained to 0U).
+ * Internal wake causes immediate xHCI wake after suspend. PORT_CSC write done
+ * at enumeration clears this wake, force one here as well for unconnected ports
+ */
+
+static void xhci_disable_hub_port_wake(struct xhci_hcd *xhci,
+				       struct xhci_hub *rhub,
+				       bool do_wakeup)
 {
-	struct xhci_port **ports;
-	int port_index;
 	unsigned long flags;
 	u32 t1, t2, portsc;
+	int i;
 
 	spin_lock_irqsave(&xhci->lock, flags);
 
-	/* disable usb3 ports Wake bits */
-	port_index = xhci->usb3_rhub.num_ports;
-	ports = xhci->usb3_rhub.ports;
-	while (port_index--) {
-		t1 = readl(ports[port_index]->addr);
-		portsc = t1;
-		t1 = xhci_port_state_to_neutral(t1);
-		t2 = t1 & ~PORT_WAKE_BITS;
-		if (t1 != t2) {
-			writel(t2, ports[port_index]->addr);
-			xhci_dbg(xhci, "disable wake bits port %d-%d, portsc: 0x%x, write: 0x%x\n",
-				 xhci->usb3_rhub.hcd->self.busnum,
-				 port_index + 1, portsc, t2);
-		}
-	}
+	for (i = 0; i < rhub->num_ports; i++) {
+		portsc = readl(rhub->ports[i]->addr);
+		t1 = xhci_port_state_to_neutral(portsc);
+		t2 = t1;
+
+		/* clear wake bits if do_wake is not set */
+		if (!do_wakeup)
+			t2 &= ~PORT_WAKE_BITS;
+
+		/* Don't touch csc bit if connected or connect change is set */
+		if (!(portsc & (PORT_CSC | PORT_CONNECT)))
+			t2 |= PORT_CSC;
 
-	/* disable usb2 ports Wake bits */
-	port_index = xhci->usb2_rhub.num_ports;
-	ports = xhci->usb2_rhub.ports;
-	while (port_index--) {
-		t1 = readl(ports[port_index]->addr);
-		portsc = t1;
-		t1 = xhci_port_state_to_neutral(t1);
-		t2 = t1 & ~PORT_WAKE_BITS;
 		if (t1 != t2) {
-			writel(t2, ports[port_index]->addr);
-			xhci_dbg(xhci, "disable wake bits port %d-%d, portsc: 0x%x, write: 0x%x\n",
-				 xhci->usb2_rhub.hcd->self.busnum,
-				 port_index + 1, portsc, t2);
+			writel(t2, rhub->ports[i]->addr);
+			xhci_dbg(xhci, "config port %d-%d wake bits, portsc: 0x%x, write: 0x%x\n",
+				 rhub->hcd->self.busnum, i + 1, portsc, t2);
 		}
 	}
 	spin_unlock_irqrestore(&xhci->lock, flags);
@@ -983,8 +981,8 @@ int xhci_suspend(struct xhci_hcd *xhci,
 		return -EINVAL;
 
 	/* Clear root port wake on bits if wakeup not allowed. */
-	if (!do_wakeup)
-		xhci_disable_port_wake_on_bits(xhci);
+	xhci_disable_hub_port_wake(xhci, &xhci->usb3_rhub, do_wakeup);
+	xhci_disable_hub_port_wake(xhci, &xhci->usb2_rhub, do_wakeup);
 
 	if (!HCD_HW_ACCESSIBLE(hcd))
 		return 0;


