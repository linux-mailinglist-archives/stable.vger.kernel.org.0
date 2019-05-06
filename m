Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3F7014E7C
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 17:03:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727323AbfEFOke (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 10:40:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:33942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727546AbfEFOkd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 May 2019 10:40:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2DEBF206A3;
        Mon,  6 May 2019 14:40:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557153632;
        bh=sLEDN4UY5ON00Xd2UXWG+DEihZsnnhWUNqBCx0MiS5k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XkRhech1KV+/utJeH92P1weZYGHJkeRW7ZwmTejoPuD+VAAvhRzCnhKSxWg421wsD
         ZmSjoRf8rJMCDKNtTSadRAXPQCQPULWo6hMfb7T33N4txKc7LEspETrcKxIPNdiCrA
         zawH6VJVQ87W8IjSBrRSt8DEGS8kJgVsTBwtOGWE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aaro Koskinen <aaro.koskinen@nokia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 39/99] net: stmmac: ratelimit RX error logs
Date:   Mon,  6 May 2019 16:32:12 +0200
Message-Id: <20190506143057.490077018@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190506143053.899356316@linuxfoundation.org>
References: <20190506143053.899356316@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 972c9be784e077bc56472c78243e0326e525b689 ]

Ratelimit RX error logs.

Signed-off-by: Aaro Koskinen <aaro.koskinen@nokia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index b44ca0c90c5c..bacc2fd63bfc 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -3412,9 +3412,10 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
 			 *  ignored
 			 */
 			if (frame_len > priv->dma_buf_sz) {
-				netdev_err(priv->dev,
-					   "len %d larger than size (%d)\n",
-					   frame_len, priv->dma_buf_sz);
+				if (net_ratelimit())
+					netdev_err(priv->dev,
+						   "len %d larger than size (%d)\n",
+						   frame_len, priv->dma_buf_sz);
 				priv->dev->stats.rx_length_errors++;
 				break;
 			}
@@ -3471,9 +3472,10 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
 			} else {
 				skb = rx_q->rx_skbuff[entry];
 				if (unlikely(!skb)) {
-					netdev_err(priv->dev,
-						   "%s: Inconsistent Rx chain\n",
-						   priv->dev->name);
+					if (net_ratelimit())
+						netdev_err(priv->dev,
+							   "%s: Inconsistent Rx chain\n",
+							   priv->dev->name);
 					priv->dev->stats.rx_dropped++;
 					break;
 				}
-- 
2.20.1



