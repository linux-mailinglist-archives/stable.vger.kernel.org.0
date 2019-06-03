Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6668832C8C
	for <lists+stable@lfdr.de>; Mon,  3 Jun 2019 11:18:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728121AbfFCJSM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jun 2019 05:18:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:42660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728141AbfFCJSJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Jun 2019 05:18:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3BF3327EA1;
        Mon,  3 Jun 2019 09:18:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559553488;
        bh=Lt/qL/eepdqdsjHExYn+iYNXL0BoBGBKCS3gT53fRS4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GdO9HzOakoxdW174s7Kr/KokoheD4dGLn2lm7wJUu4s16k5ZvpBXjb96s22Wakgan
         Fb2J4RM4L418j/IA4Hp8NqxfLwzoyQSLg1VXPY3yK+AXXJGAMAzlGqlz3wcarHsJw6
         k4pBNvchN8M92DGAeXJs0jTU+NG6DWfh0/OFZuMk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Zhang, Baoli" <baoli.zhang@intel.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Weifeng Voon <weifeng.voon@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.0 25/36] net: stmmac: dma channel control register need to be init first
Date:   Mon,  3 Jun 2019 11:09:13 +0200
Message-Id: <20190603090522.628056197@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190603090520.998342694@linuxfoundation.org>
References: <20190603090520.998342694@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Weifeng Voon <weifeng.voon@intel.com>

stmmac_init_chan() needs to be called before stmmac_init_rx_chan() and
stmmac_init_tx_chan(). This is because if PBLx8 is to be used,
"DMA_CH(#i)_Control.PBLx8" needs to be set before programming
"DMA_CH(#i)_TX_Control.TxPBL" and "DMA_CH(#i)_RX_Control.RxPBL".

Fixes: 47f2a9ce527a ("net: stmmac: dma channel init prepared for multiple queues")
Reviewed-by: Zhang, Baoli <baoli.zhang@intel.com>
Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
Signed-off-by: Weifeng Voon <weifeng.voon@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -2190,6 +2190,10 @@ static int stmmac_init_dma_engine(struct
 	if (priv->plat->axi)
 		stmmac_axi(priv, priv->ioaddr, priv->plat->axi);
 
+	/* DMA CSR Channel configuration */
+	for (chan = 0; chan < dma_csr_ch; chan++)
+		stmmac_init_chan(priv, priv->ioaddr, priv->plat->dma_cfg, chan);
+
 	/* DMA RX Channel Configuration */
 	for (chan = 0; chan < rx_channels_count; chan++) {
 		rx_q = &priv->rx_queue[chan];
@@ -2215,10 +2219,6 @@ static int stmmac_init_dma_engine(struct
 				       tx_q->tx_tail_addr, chan);
 	}
 
-	/* DMA CSR Channel configuration */
-	for (chan = 0; chan < dma_csr_ch; chan++)
-		stmmac_init_chan(priv, priv->ioaddr, priv->plat->dma_cfg, chan);
-
 	return ret;
 }
 


