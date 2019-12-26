Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BC6D12AE19
	for <lists+stable@lfdr.de>; Thu, 26 Dec 2019 19:59:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726894AbfLZS7V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Dec 2019 13:59:21 -0500
Received: from informare.org ([217.11.52.70]:43664 "EHLO informare.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726480AbfLZS7V (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 26 Dec 2019 13:59:21 -0500
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Thu, 26 Dec 2019 13:59:20 EST
Received: (qmail 8852 invoked from network); 26 Dec 2019 18:52:37 -0000
Received: from unknown (HELO ?192.168.178.40?) (faber@faberman.de@87.123.203.102)
  by 0 with ESMTPA; 26 Dec 2019 18:52:37 -0000
To:     linux-can@vger.kernel.org
Cc:     stable@vger.kernel.org
From:   Florian Faber <faber@faberman.de>
Subject: [PATCH] mscan: fix rx path lockup when returning from polling to irq
 mode
Message-ID: <860de41f-bb60-728b-7602-90dced920c27@faberman.de>
Date:   Thu, 26 Dec 2019 19:51:24 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Under load, the RX side of the mscan driver can get stuck while TX still
works. Restarting the interface locks up the system. This behaviour 
could be reproduced reliably on a MPC5121e based system.

The patch fixes the return value of the NAPI polling function (should be
the number of processed packets, not constant 1) and the condition under
which IRQs are enabled again after polling is finished.

With this patch, no more lockups were observed over a test period of ten 
days.

Signed-off-by: Florian Faber <faber@faberman.de>
---
diff -uprN a/drivers/net/can/mscan/mscan.c b/drivers/net/can/mscan/mscan.c
--- a/drivers/net/can/mscan/mscan.c
+++ b/drivers/net/can/mscan/mscan.c
@@ -381,10 +381,9 @@ static int mscan_rx_poll(struct napi_str
         struct net_device *dev = napi->dev;
         struct mscan_regs __iomem *regs = priv->reg_base;
         struct net_device_stats *stats = &dev->stats;
-       int npackets = 0;
-       int ret = 1;
+	int work_done = 0;
         struct sk_buff *skb;
         struct can_frame *frame;
         u8 canrflg;

-       while (npackets < quota) {
+	while (work_done < quota) {
		canrflg = in_8(&regs->canrflg);
		if (!(canrflg & (MSCAN_RXF | MSCAN_ERR_IF)))
@@ -408,15 +409,16 @@ static int mscan_rx_poll(struct napi_str

                 stats->rx_packets++;
                 stats->rx_bytes += frame->can_dlc;
-               npackets++;
+		work_done++;
                 netif_receive_skb(skb);
         }

-       if (!(in_8(&regs->canrflg) & (MSCAN_RXF | MSCAN_ERR_IF))) {
-               napi_complete(&priv->napi);
-               clear_bit(F_RX_PROGRESS, &priv->flags);
-               if (priv->can.state < CAN_STATE_BUS_OFF)
-                       out_8(&regs->canrier, priv->shadow_canrier);
-               ret = 0;
+	if (work_done < quota) {
+		if (likely(napi_complete_done(&priv->napi, work_done))) {
+			clear_bit(F_RX_PROGRESS, &priv->flags);
+			if (priv->can.state < CAN_STATE_BUS_OFF)
+				out_8(&regs->canrier, priv->shadow_canrier);
+		}
         }
-       return ret;
+
+	return work_done;
}
-- 
Machines can do the work, so people have time to think.
