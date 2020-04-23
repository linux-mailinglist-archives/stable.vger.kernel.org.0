Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CC511B681F
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 01:13:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728547AbgDWXGv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 19:06:51 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:49754 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728430AbgDWXGs (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 19:06:48 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvS-0004h9-Ln; Fri, 24 Apr 2020 00:06:34 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvS-00E6r5-C9; Fri, 24 Apr 2020 00:06:34 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Marc Kleine-Budde" <mkl@pengutronix.de>,
        "Florian Faber" <faber@faberman.de>
Date:   Fri, 24 Apr 2020 00:06:17 +0100
Message-ID: <lsq.1587683028.567419965@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 150/245] can: mscan: mscan_rx_poll(): fix rx path
 lockup when returning from polling to irq mode
In-Reply-To: <lsq.1587683027.831233700@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.83-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Faber <faber@faberman.de>

commit 2d77bd61a2927be8f4e00d9478fe6996c47e8d45 upstream.

Under load, the RX side of the mscan driver can get stuck while TX still
works. Restarting the interface locks up the system. This behaviour
could be reproduced reliably on a MPC5121e based system.

The patch fixes the return value of the NAPI polling function (should be
the number of processed packets, not constant 1) and the condition under
which IRQs are enabled again after polling is finished.

With this patch, no more lockups were observed over a test period of ten
days.

Fixes: afa17a500a36 ("net/can: add driver for mscan family & mpc52xx_mscan")
Signed-off-by: Florian Faber <faber@faberman.de>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/can/mscan/mscan.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

--- a/drivers/net/can/mscan/mscan.c
+++ b/drivers/net/can/mscan/mscan.c
@@ -412,13 +412,12 @@ static int mscan_rx_poll(struct napi_str
 	struct net_device *dev = napi->dev;
 	struct mscan_regs __iomem *regs = priv->reg_base;
 	struct net_device_stats *stats = &dev->stats;
-	int npackets = 0;
-	int ret = 1;
+	int work_done = 0;
 	struct sk_buff *skb;
 	struct can_frame *frame;
 	u8 canrflg;
 
-	while (npackets < quota) {
+	while (work_done < quota) {
 		canrflg = in_8(&regs->canrflg);
 		if (!(canrflg & (MSCAN_RXF | MSCAN_ERR_IF)))
 			break;
@@ -439,18 +438,18 @@ static int mscan_rx_poll(struct napi_str
 
 		stats->rx_packets++;
 		stats->rx_bytes += frame->can_dlc;
-		npackets++;
+		work_done++;
 		netif_receive_skb(skb);
 	}
 
-	if (!(in_8(&regs->canrflg) & (MSCAN_RXF | MSCAN_ERR_IF))) {
-		napi_complete(&priv->napi);
-		clear_bit(F_RX_PROGRESS, &priv->flags);
-		if (priv->can.state < CAN_STATE_BUS_OFF)
-			out_8(&regs->canrier, priv->shadow_canrier);
-		ret = 0;
+	if (work_done < quota) {
+		if (likely(napi_complete_done(&priv->napi, work_done))) {
+			clear_bit(F_RX_PROGRESS, &priv->flags);
+			if (priv->can.state < CAN_STATE_BUS_OFF)
+				out_8(&regs->canrier, priv->shadow_canrier);
+		}
 	}
-	return ret;
+	return work_done;
 }
 
 static irqreturn_t mscan_isr(int irq, void *dev_id)

