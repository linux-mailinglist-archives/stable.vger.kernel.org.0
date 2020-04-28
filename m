Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF2C11BCAD2
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 20:53:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730383AbgD1SwF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:52:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:54036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729631AbgD1Sge (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:36:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 025A320575;
        Tue, 28 Apr 2020 18:36:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588098993;
        bh=mbsr4pUywiBf3efxDxkiIZhl7JcP3EsZbHgjH0OG9wA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wiN1zUt2A7fFXda2P9cyS+mgleWgn5vf/7Dv7Mt+GIzQrLgkZNCVveXCxW1PX2AIk
         tvcxrgImrQ7GCETAI6fs0wnkeCzFkDpnyYS5ewRznsExmAn6QbMfQMeQYiTRk8N+HJ
         aSjWSqGLLpv9+2ElJA0LUawBA9RiUcaP/f4NPlBI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 043/168] xhci: Finetune host initiated USB3 rootport link suspend and resume
Date:   Tue, 28 Apr 2020 20:23:37 +0200
Message-Id: <20200428182237.291490232@linuxfoundation.org>
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

[ Upstream commit ceca49382ac20e06ce04c21279c7f2868c4ec1d4 ]

Depending on the current link state the steps to resume the link to U0
varies. The normal case when a port is suspended (U3) we set the link
to U0 and wait for a port event when U3exit completed and port moved to
U0.

If the port is in U1/U2, then no event is issued, just set link to U0

If port is in Resume or Recovery state then the device has already
initiated resume, and this host initiated resume is racing against it.
Port event handler for device initiated resume will set link to U0,
just wait for the port to reach U0 before returning.

Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20200312144517.1593-9-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/xhci-hub.c | 36 +++++++++++++++++++++++++-----------
 1 file changed, 25 insertions(+), 11 deletions(-)

diff --git a/drivers/usb/host/xhci-hub.c b/drivers/usb/host/xhci-hub.c
index 02f52d4f74df8..a9c87eb8951e8 100644
--- a/drivers/usb/host/xhci-hub.c
+++ b/drivers/usb/host/xhci-hub.c
@@ -1307,20 +1307,34 @@ int xhci_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue,
 				goto error;
 			}
 
+			/*
+			 * set link to U0, steps depend on current link state.
+			 * U3: set link to U0 and wait for u3exit completion.
+			 * U1/U2:  no PLC complete event, only set link to U0.
+			 * Resume/Recovery: device initiated U0, only wait for
+			 * completion
+			 */
 			if (link_state == USB_SS_PORT_LS_U0) {
-				if ((temp & PORT_PLS_MASK) == XDEV_U0)
-					break;
+				u32 pls = temp & PORT_PLS_MASK;
+				bool wait_u0 = false;
 
-				if (!((temp & PORT_PLS_MASK) == XDEV_U1 ||
-				    (temp & PORT_PLS_MASK) == XDEV_U2 ||
-				    (temp & PORT_PLS_MASK) == XDEV_U3)) {
-					xhci_warn(xhci, "Can only set port %d to U0 from U state\n",
-							wIndex);
-					goto error;
+				/* already in U0 */
+				if (pls == XDEV_U0)
+					break;
+				if (pls == XDEV_U3 ||
+				    pls == XDEV_RESUME ||
+				    pls == XDEV_RECOVERY) {
+					wait_u0 = true;
+					reinit_completion(&bus_state->u3exit_done[wIndex]);
+				}
+				if (pls <= XDEV_U3) /* U1, U2, U3 */
+					xhci_set_link_state(xhci, ports[wIndex],
+							    USB_SS_PORT_LS_U0);
+				if (!wait_u0) {
+					if (pls > XDEV_U3)
+						goto error;
+					break;
 				}
-				reinit_completion(&bus_state->u3exit_done[wIndex]);
-				xhci_set_link_state(xhci, ports[wIndex],
-						    USB_SS_PORT_LS_U0);
 				spin_unlock_irqrestore(&xhci->lock, flags);
 				if (!wait_for_completion_timeout(&bus_state->u3exit_done[wIndex],
 								 msecs_to_jiffies(100)))
-- 
2.20.1



