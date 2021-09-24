Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A103E417369
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 14:57:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344321AbhIXMzv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 08:55:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:46062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344329AbhIXMxz (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 08:53:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 207B66135E;
        Fri, 24 Sep 2021 12:50:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632487830;
        bh=f5djH18sAfJGfX1xLADVRV1uMnIQz+uabTcfLgsWY6A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vN1ClE/avcdLHyq4cc35oD70bsD6z8iw7b5wZRUgzgM06X31Fxf1+4J0nVK8S1CdO
         OeeAb5s7UkEQmlARhRyGJikxoIh9RZzvBXo513S5m+JtUwuztiX7GMVvrMvg+LJghV
         +a+pv03/0UYM12i0m5h+5Mwi9Ul2UgZnueGLpilQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jongsung Kim <neidhard.kim@lge.com>,
        "David S. Miller" <davem@davemloft.net>,
        Macpaul Lin <macpaul.lin@mediatek.com>
Subject: [PATCH 5.4 28/50] net: stmmac: reset Tx desc base address before restarting Tx
Date:   Fri, 24 Sep 2021 14:44:17 +0200
Message-Id: <20210924124333.192785639@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210924124332.229289734@linuxfoundation.org>
References: <20210924124332.229289734@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jongsung Kim <neidhard.kim@lge.com>

commit f421031e3ff0dd288a6e1bbde9aa41a25bb814e6 upstream.

Refer to the databook of DesignWare Cores Ethernet MAC Universal:

6.2.1.5 Register 4 (Transmit Descriptor List Address Register

If this register is not changed when the ST bit is set to 0, then
the DMA takes the descriptor address where it was stopped earlier.

The stmmac_tx_err() does zero indices to Tx descriptors, but does
not reset HW current Tx descriptor address. To fix inconsistency,
the base address of the Tx descriptors should be rewritten before
restarting Tx.

Signed-off-by: Jongsung Kim <neidhard.kim@lge.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Macpaul Lin <macpaul.lin@mediatek.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -1987,6 +1987,8 @@ static void stmmac_tx_err(struct stmmac_
 	tx_q->cur_tx = 0;
 	tx_q->mss = 0;
 	netdev_tx_reset_queue(netdev_get_tx_queue(priv->dev, chan));
+	stmmac_init_tx_chan(priv, priv->ioaddr, priv->plat->dma_cfg,
+			    tx_q->dma_tx_phy, chan);
 	stmmac_start_tx_dma(priv, chan);
 
 	priv->dev->stats.tx_errors++;


