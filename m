Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CE1913A6BE
	for <lists+stable@lfdr.de>; Tue, 14 Jan 2020 11:25:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732824AbgANKNU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jan 2020 05:13:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:50562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733174AbgANKNT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jan 2020 05:13:19 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 597F420678;
        Tue, 14 Jan 2020 10:13:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578996798;
        bh=k18qRjP/nywpIHZ3grDId+QnddItalWgK5eGRgAKNkk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DFJo32+TX3L+QQa559GBv0/ewbgX7itK+sWBpwBo+9Wx2duJdVc9MPzDf0FuN0CLp
         gaeJlPYd7avcQRqyTNTPxSVYgtgJsv/3yrrT398uyog95PYlCnnVRQRbqs40KsVqqo
         DocMGhUI15U+zIkA+KJL/Bm5GALezIzlLqOkaQZs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Faber <faber@faberman.de>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 4.4 13/28] can: mscan: mscan_rx_poll(): fix rx path lockup when returning from polling to irq mode
Date:   Tue, 14 Jan 2020 11:02:15 +0100
Message-Id: <20200114094342.088889078@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200114094336.845958665@linuxfoundation.org>
References: <20200114094336.845958665@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Cc: linux-stable <stable@vger.kernel.org>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/can/mscan/mscan.c |   21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

--- a/drivers/net/can/mscan/mscan.c
+++ b/drivers/net/can/mscan/mscan.c
@@ -392,13 +392,12 @@ static int mscan_rx_poll(struct napi_str
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
@@ -419,18 +418,18 @@ static int mscan_rx_poll(struct napi_str
 
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


