Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45ADA14F24
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 17:09:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726457AbfEFOfl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 10:35:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:55818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726983AbfEFOfk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 May 2019 10:35:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA17A214AE;
        Mon,  6 May 2019 14:35:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557153339;
        bh=aBS23To4zgYe4FkCBU84AS1SB4OpLcZTHtMQFMMKQ1M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=egEzfc61qeUVUhX1Xl1gkOoOH6jsuIUHLc84ivWpVps70IuPF6ZLjdmWSxqrHpZXZ
         wcsgT18HipuvrZ6UGUM8Z/vpOHfmZI5lzD53cUGhiXGZSG9fWHlSUkFoyWEi4IDsTN
         W/wkdfyRd2p7La3VzAZ7+IRxAI4rqzzw2F8/IeQA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aaro Koskinen <aaro.koskinen@nokia.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Sasha Levin (Microsoft)" <sashal@kernel.org>
Subject: [PATCH 5.0 052/122] net: stmmac: dont stop NAPI processing when dropping a packet
Date:   Mon,  6 May 2019 16:31:50 +0200
Message-Id: <20190506143059.586115083@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190506143054.670334917@linuxfoundation.org>
References: <20190506143054.670334917@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 07b3975352374c3f5ebb4a42ef0b253fe370542d ]

Currently, if we drop a packet, we exit from NAPI loop before the budget
is consumed. In some situations this will make the RX processing stall
e.g. when flood pinging the system with oversized packets, as the
errorneous packets are not dropped efficiently.

If we drop a packet, we should just continue to the next one as long as
the budget allows.

Signed-off-by: Aaro Koskinen <aaro.koskinen@nokia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin (Microsoft) <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 0ccf91a08290..f0e0593e54f3 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -3328,9 +3328,8 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
 {
 	struct stmmac_rx_queue *rx_q = &priv->rx_queue[queue];
 	struct stmmac_channel *ch = &priv->channel[queue];
-	unsigned int entry = rx_q->cur_rx;
+	unsigned int next_entry = rx_q->cur_rx;
 	int coe = priv->hw->rx_csum;
-	unsigned int next_entry;
 	unsigned int count = 0;
 	bool xmac;
 
@@ -3348,10 +3347,12 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
 		stmmac_display_ring(priv, rx_head, DMA_RX_SIZE, true);
 	}
 	while (count < limit) {
-		int status;
+		int entry, status;
 		struct dma_desc *p;
 		struct dma_desc *np;
 
+		entry = next_entry;
+
 		if (priv->extend_desc)
 			p = (struct dma_desc *)(rx_q->dma_erx + entry);
 		else
@@ -3412,7 +3413,7 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
 						   "len %d larger than size (%d)\n",
 						   frame_len, priv->dma_buf_sz);
 				priv->dev->stats.rx_length_errors++;
-				break;
+				continue;
 			}
 
 			/* ACS is set; GMAC core strips PAD/FCS for IEEE 802.3
@@ -3447,7 +3448,7 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
 						dev_warn(priv->device,
 							 "packet dropped\n");
 					priv->dev->stats.rx_dropped++;
-					break;
+					continue;
 				}
 
 				dma_sync_single_for_cpu(priv->device,
@@ -3472,7 +3473,7 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
 							   "%s: Inconsistent Rx chain\n",
 							   priv->dev->name);
 					priv->dev->stats.rx_dropped++;
-					break;
+					continue;
 				}
 				prefetch(skb->data - NET_IP_ALIGN);
 				rx_q->rx_skbuff[entry] = NULL;
@@ -3507,7 +3508,6 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
 			priv->dev->stats.rx_packets++;
 			priv->dev->stats.rx_bytes += frame_len;
 		}
-		entry = next_entry;
 	}
 
 	stmmac_rx_refill(priv, queue);
-- 
2.20.1



