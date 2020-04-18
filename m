Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAC301AF0DB
	for <lists+stable@lfdr.de>; Sat, 18 Apr 2020 16:53:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728246AbgDROmF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Apr 2020 10:42:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:51862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728243AbgDROmF (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 18 Apr 2020 10:42:05 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 091DB2224E;
        Sat, 18 Apr 2020 14:42:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587220924;
        bh=sFS1aTN77s462QSqkmbpOiTld0tKgWA3KLsgWWCSkBY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XoTQu4g8L/frPBHYqQMU7/KrUjzxi6Xlex0z1n4pD3W7EGfp7qLZweBv3u6472oKI
         /7Eg64v+Sku8FwNzQrniqd/jx8BCnyYt58vqyGPs8uq7F5maqrx5Ei4Q2REU56hIUO
         yxgh/9fszm4ly7QNQfPqkvzoGa5SwhrSJjl/YnZA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 62/78] xhci: Wait until link state trainsits to U0 after setting USB_SS_PORT_LS_U0
Date:   Sat, 18 Apr 2020 10:40:31 -0400
Message-Id: <20200418144047.9013-62-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200418144047.9013-1-sashal@kernel.org>
References: <20200418144047.9013-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai-Heng Feng <kai.heng.feng@canonical.com>

[ Upstream commit 0200b9f790b0fc9e9a42f685f5ad54b23fe959f4 ]

Like U3 case, xHCI spec doesn't specify the upper bound of U0 transition
time. The 20ms is not enough for some devices.

Intead of polling PLS or PLC, we can facilitate the port change event to
know that the link transits to U0 is completed.

While at it, also separate U0 and U3 case to make the code cleaner.

[variable rename to u3exit, and skip completion for usb2 ports -Mathias ]
Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20200312144517.1593-8-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/xhci-hub.c  | 44 +++++++++++++++++++++++++-----------
 drivers/usb/host/xhci-mem.c  |  1 +
 drivers/usb/host/xhci-ring.c |  1 +
 drivers/usb/host/xhci.h      |  1 +
 4 files changed, 34 insertions(+), 13 deletions(-)

diff --git a/drivers/usb/host/xhci-hub.c b/drivers/usb/host/xhci-hub.c
index 712cd44f05ace..02f52d4f74df8 100644
--- a/drivers/usb/host/xhci-hub.c
+++ b/drivers/usb/host/xhci-hub.c
@@ -1306,7 +1306,33 @@ int xhci_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue,
 					 wIndex, link_state);
 				goto error;
 			}
+
+			if (link_state == USB_SS_PORT_LS_U0) {
+				if ((temp & PORT_PLS_MASK) == XDEV_U0)
+					break;
+
+				if (!((temp & PORT_PLS_MASK) == XDEV_U1 ||
+				    (temp & PORT_PLS_MASK) == XDEV_U2 ||
+				    (temp & PORT_PLS_MASK) == XDEV_U3)) {
+					xhci_warn(xhci, "Can only set port %d to U0 from U state\n",
+							wIndex);
+					goto error;
+				}
+				reinit_completion(&bus_state->u3exit_done[wIndex]);
+				xhci_set_link_state(xhci, ports[wIndex],
+						    USB_SS_PORT_LS_U0);
+				spin_unlock_irqrestore(&xhci->lock, flags);
+				if (!wait_for_completion_timeout(&bus_state->u3exit_done[wIndex],
+								 msecs_to_jiffies(100)))
+					xhci_dbg(xhci, "missing U0 port change event for port %d\n",
+						 wIndex);
+				spin_lock_irqsave(&xhci->lock, flags);
+				temp = readl(ports[wIndex]->addr);
+				break;
+			}
+
 			if (link_state == USB_SS_PORT_LS_U3) {
+				int retries = 16;
 				slot_id = xhci_find_slot_id_by_port(hcd, xhci,
 						wIndex + 1);
 				if (slot_id) {
@@ -1317,26 +1343,18 @@ int xhci_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue,
 					xhci_stop_device(xhci, slot_id, 1);
 					spin_lock_irqsave(&xhci->lock, flags);
 				}
-			}
-
-			xhci_set_link_state(xhci, ports[wIndex], link_state);
-
-			spin_unlock_irqrestore(&xhci->lock, flags);
-			if (link_state == USB_SS_PORT_LS_U3) {
-				int retries = 16;
-
+				xhci_set_link_state(xhci, ports[wIndex], USB_SS_PORT_LS_U3);
+				spin_unlock_irqrestore(&xhci->lock, flags);
 				while (retries--) {
 					usleep_range(4000, 8000);
 					temp = readl(ports[wIndex]->addr);
 					if ((temp & PORT_PLS_MASK) == XDEV_U3)
 						break;
 				}
-			}
-			spin_lock_irqsave(&xhci->lock, flags);
-
-			temp = readl(ports[wIndex]->addr);
-			if (link_state == USB_SS_PORT_LS_U3)
+				spin_lock_irqsave(&xhci->lock, flags);
+				temp = readl(ports[wIndex]->addr);
 				bus_state->suspended_ports |= 1 << wIndex;
+			}
 			break;
 		case USB_PORT_FEAT_POWER:
 			/*
diff --git a/drivers/usb/host/xhci-mem.c b/drivers/usb/host/xhci-mem.c
index 884c601bfa15f..9764122c9cdf2 100644
--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -2552,6 +2552,7 @@ int xhci_mem_init(struct xhci_hcd *xhci, gfp_t flags)
 		xhci->usb3_rhub.bus_state.resume_done[i] = 0;
 		/* Only the USB 2.0 completions will ever be used. */
 		init_completion(&xhci->usb2_rhub.bus_state.rexit_done[i]);
+		init_completion(&xhci->usb3_rhub.bus_state.u3exit_done[i]);
 	}
 
 	if (scratchpad_alloc(xhci, flags))
diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index f7a190fb2353d..a952d99f0456b 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -1673,6 +1673,7 @@ static void handle_port_status(struct xhci_hcd *xhci,
 	     (portsc & PORT_PLS_MASK) == XDEV_U1 ||
 	     (portsc & PORT_PLS_MASK) == XDEV_U2)) {
 		xhci_dbg(xhci, "resume SS port %d finished\n", port_id);
+		complete(&bus_state->u3exit_done[hcd_portnum]);
 		/* We've just brought the device into U0/1/2 through either the
 		 * Resume state after a device remote wakeup, or through the
 		 * U3Exit state after a host-initiated resume.  If it's a device
diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
index 98b98a0cd2a8b..3ad4f80960d08 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -1694,6 +1694,7 @@ struct xhci_bus_state {
 	/* Which ports are waiting on RExit to U0 transition. */
 	unsigned long		rexit_ports;
 	struct completion	rexit_done[USB_MAXCHILDREN];
+	struct completion	u3exit_done[USB_MAXCHILDREN];
 };
 
 
-- 
2.20.1

