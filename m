Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEB003371CD
	for <lists+stable@lfdr.de>; Thu, 11 Mar 2021 12:53:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232842AbhCKLwk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Mar 2021 06:52:40 -0500
Received: from mga07.intel.com ([134.134.136.100]:40662 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232785AbhCKLwe (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Mar 2021 06:52:34 -0500
IronPort-SDR: IwRHDjTs/w55ttQAst6aLD+RmjbRHcQoY8a3oWdToCGE3kwCMYDYuWfBDgFp/drA5gNc/pJVFG
 kvdpTlxPOjKg==
X-IronPort-AV: E=McAfee;i="6000,8403,9919"; a="252671308"
X-IronPort-AV: E=Sophos;i="5.81,240,1610438400"; 
   d="scan'208";a="252671308"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2021 03:52:33 -0800
IronPort-SDR: j8l4qiryyenj/QQUQoLd+AXl6f4PVdT1Fvf8Pu1AQo8ZZhoMy79Hkf50YE4aoaCnLypaJ1NTzt
 bFl+Q0cUvVUg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,240,1610438400"; 
   d="scan'208";a="409463991"
Received: from mattu-haswell.fi.intel.com ([10.237.72.170])
  by orsmga007.jf.intel.com with ESMTP; 11 Mar 2021 03:52:32 -0800
From:   Mathias Nyman <mathias.nyman@linux.intel.com>
To:     <gregkh@linuxfoundation.org>
Cc:     <linux-usb@vger.kernel.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        stable@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 4/4] xhci: Fix repeated xhci wake after suspend due to uncleared internal wake state
Date:   Thu, 11 Mar 2021 13:53:53 +0200
Message-Id: <20210311115353.2137560-5-mathias.nyman@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210311115353.2137560-1-mathias.nyman@linux.intel.com>
References: <20210311115353.2137560-1-mathias.nyman@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 drivers/usb/host/xhci.c | 62 ++++++++++++++++++++---------------------
 1 file changed, 30 insertions(+), 32 deletions(-)

diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 48a68fcf2b36..1975016f46bf 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -883,44 +883,42 @@ static void xhci_clear_command_ring(struct xhci_hcd *xhci)
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
@@ -983,8 +981,8 @@ int xhci_suspend(struct xhci_hcd *xhci, bool do_wakeup)
 		return -EINVAL;
 
 	/* Clear root port wake on bits if wakeup not allowed. */
-	if (!do_wakeup)
-		xhci_disable_port_wake_on_bits(xhci);
+	xhci_disable_hub_port_wake(xhci, &xhci->usb3_rhub, do_wakeup);
+	xhci_disable_hub_port_wake(xhci, &xhci->usb2_rhub, do_wakeup);
 
 	if (!HCD_HW_ACCESSIBLE(hcd))
 		return 0;
-- 
2.25.1

