Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA445156719
	for <lists+stable@lfdr.de>; Sat,  8 Feb 2020 19:41:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727702AbgBHSjU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Feb 2020 13:39:20 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33466 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727550AbgBHS3d (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 Feb 2020 13:29:33 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1j0UrC-0003Zx-D5; Sat, 08 Feb 2020 18:29:30 +0000
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1j0UrB-000CJ0-G3; Sat, 08 Feb 2020 18:29:29 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Aviraj CJ" <acj@cisco.com>,
        "Aaro Koskinen" <aaro.koskinen@nokia.com>,
        "David S. Miller" <davem@davemloft.net>
Date:   Sat, 08 Feb 2020 18:19:07 +0000
Message-ID: <lsq.1581185940.213979890@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 008/148] net: stmmac: don't stop NAPI processing when
 dropping a packet
In-Reply-To: <lsq.1581185939.857586636@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.82-rc1 review patch.  If anyone has any objections, please let me know.

------------------

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
[acj: backport v4.4 -stable
-adjust context]
Signed-off-by: Aviraj CJ <acj@cisco.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -2060,8 +2060,7 @@ static inline void stmmac_rx_refill(stru
 static int stmmac_rx(struct stmmac_priv *priv, int limit)
 {
 	unsigned int rxsize = priv->dma_rx_size;
-	unsigned int entry = priv->cur_rx % rxsize;
-	unsigned int next_entry;
+	unsigned int next_entry = priv->cur_rx % rxsize;
 	unsigned int count = 0;
 	int coe = priv->plat->rx_coe;
 
@@ -2073,9 +2072,11 @@ static int stmmac_rx(struct stmmac_priv
 			stmmac_display_ring((void *)priv->dma_rx, rxsize, 0);
 	}
 	while (count < limit) {
-		int status;
+		int status, entry;
 		struct dma_desc *p;
 
+		entry = next_entry;
+
 		if (priv->extend_desc)
 			p = (struct dma_desc *)(priv->dma_erx + entry);
 		else
@@ -2123,7 +2124,7 @@ static int stmmac_rx(struct stmmac_priv
 			/*  check if frame_len fits the preallocated memory */
 			if (frame_len > priv->dma_buf_sz) {
 				priv->dev->stats.rx_length_errors++;
-				break;
+				continue;
 			}
 
 			/* ACS is set; GMAC core strips PAD/FCS for IEEE 802.3
@@ -2144,7 +2145,7 @@ static int stmmac_rx(struct stmmac_priv
 				pr_err("%s: Inconsistent Rx descriptor chain\n",
 				       priv->dev->name);
 				priv->dev->stats.rx_dropped++;
-				break;
+				continue;
 			}
 			prefetch(skb->data - NET_IP_ALIGN);
 			priv->rx_skbuff[entry] = NULL;
@@ -2175,7 +2176,6 @@ static int stmmac_rx(struct stmmac_priv
 			priv->dev->stats.rx_packets++;
 			priv->dev->stats.rx_bytes += frame_len;
 		}
-		entry = next_entry;
 	}
 
 	stmmac_rx_refill(priv);

