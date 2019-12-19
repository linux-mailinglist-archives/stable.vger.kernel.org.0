Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB5C7126C33
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 20:02:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729856AbfLSStr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 13:49:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:43330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729850AbfLSStq (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:49:46 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8217E24672;
        Thu, 19 Dec 2019 18:49:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576781386;
        bh=o3ktvA+EiatetoIy9/RAgk8wlz/pnSPTx9v3FR2top8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GK0fU52NNHAPwU1+CdAW4uC+/PRMcldfMYCIdU50zY7nQomgDDjRHYIBfuYbsimhT
         SL6kQ55LrMuuqlND/eiq0WPjHCGQ5W1cBMw9sBPe9BUJHfDoyDOav7ErOryypDSWLY
         FeAjeGAT7AV46vB+hRGtbjh+b3FXCYlTiCOSAGdY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aaro Koskinen <aaro.koskinen@nokia.com>,
        "David S. Miller" <davem@davemloft.net>, Aviraj CJ <acj@cisco.com>
Subject: [PATCH 4.9 199/199] net: stmmac: dont stop NAPI processing when dropping a packet
Date:   Thu, 19 Dec 2019 19:34:41 +0100
Message-Id: <20191219183226.843312108@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219183214.629503389@linuxfoundation.org>
References: <20191219183214.629503389@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aaro Koskinen <aaro.koskinen@nokia.com>

commit 07b3975352374c3f5ebb4a42ef0b253fe370542d upstream.

Currently, if we drop a packet, we exit from NAPI loop before the budget
is consumed. In some situations this will make the RX processing stall
e.g. when flood pinging the system with oversized packets, as the
errorneous packets are not dropped efficiently.

If we drop a packet, we should just continue to the next one as long as
the budget allows.

Signed-off-by: Aaro Koskinen <aaro.koskinen@nokia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
[acj: backport v4.9 -stable
-adjust context]
Signed-off-by: Aviraj CJ <acj@cisco.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -2499,8 +2499,7 @@ static inline void stmmac_rx_refill(stru
  */
 static int stmmac_rx(struct stmmac_priv *priv, int limit)
 {
-	unsigned int entry = priv->cur_rx;
-	unsigned int next_entry;
+	unsigned int next_entry = priv->cur_rx;
 	unsigned int count = 0;
 	int coe = priv->hw->rx_csum;
 
@@ -2516,10 +2515,12 @@ static int stmmac_rx(struct stmmac_priv
 		priv->hw->desc->display_ring(rx_head, DMA_RX_SIZE, true);
 	}
 	while (count < limit) {
-		int status;
+		int entry, status;
 		struct dma_desc *p;
 		struct dma_desc *np;
 
+		entry = next_entry;
+
 		if (priv->extend_desc)
 			p = (struct dma_desc *)(priv->dma_erx + entry);
 		else
@@ -2584,7 +2585,7 @@ static int stmmac_rx(struct stmmac_priv
 				       priv->dev->name, frame_len,
 				       priv->dma_buf_sz);
 				priv->dev->stats.rx_length_errors++;
-				break;
+				continue;
 			}
 
 			/* ACS is set; GMAC core strips PAD/FCS for IEEE 802.3
@@ -2615,7 +2616,7 @@ static int stmmac_rx(struct stmmac_priv
 						dev_warn(priv->device,
 							 "packet dropped\n");
 					priv->dev->stats.rx_dropped++;
-					break;
+					continue;
 				}
 
 				dma_sync_single_for_cpu(priv->device,
@@ -2638,7 +2639,7 @@ static int stmmac_rx(struct stmmac_priv
 					pr_err("%s: Inconsistent Rx chain\n",
 					       priv->dev->name);
 					priv->dev->stats.rx_dropped++;
-					break;
+					continue;
 				}
 				prefetch(skb->data - NET_IP_ALIGN);
 				priv->rx_skbuff[entry] = NULL;
@@ -2672,7 +2673,6 @@ static int stmmac_rx(struct stmmac_priv
 			priv->dev->stats.rx_packets++;
 			priv->dev->stats.rx_bytes += frame_len;
 		}
-		entry = next_entry;
 	}
 
 	stmmac_rx_refill(priv);


