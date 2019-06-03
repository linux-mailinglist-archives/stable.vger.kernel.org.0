Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70AB732C8A
	for <lists+stable@lfdr.de>; Mon,  3 Jun 2019 11:18:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727951AbfFCJSI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jun 2019 05:18:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:42512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728062AbfFCJSD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Jun 2019 05:18:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9DCEB27EA1;
        Mon,  3 Jun 2019 09:18:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559553483;
        bh=apmDn9e7EHYtKheI9oJYwY5vH4hfrUYCM5LDOt9D9hs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1qbkzRU9mwlTPzwj2ZPmcw4pohPGEH4k0NNs2N2cVPKrJhiA1uOPy0mkPT75GOV8B
         42P2WDi3y041St59k5kwlFoWaGbhSbHYscvosjtBPA5w39I/v5oCSMy9YqF0GAdqcI
         k42v/XsvqZN9G72G+NRo2yevly7vpll3VKaK6Yhc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Zhang, Baoli" <baoli.zhang@intel.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Weifeng Voon <weifeng.voon@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 22/32] net: stmmac: dma channel control register need to be init first
Date:   Mon,  3 Jun 2019 11:08:16 +0200
Message-Id: <20190603090314.784323813@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190603090308.472021390@linuxfoundation.org>
References: <20190603090308.472021390@linuxfoundation.org>
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
@@ -2195,6 +2195,10 @@ static int stmmac_init_dma_engine(struct
 	if (priv->plat->axi)
 		stmmac_axi(priv, priv->ioaddr, priv->plat->axi);
 
+	/* DMA CSR Channel configuration */
+	for (chan = 0; chan < dma_csr_ch; chan++)
+		stmmac_init_chan(priv, priv->ioaddr, priv->plat->dma_cfg, chan);
+
 	/* DMA RX Channel Configuration */
 	for (chan = 0; chan < rx_channels_count; chan++) {
 		rx_q = &priv->rx_queue[chan];
@@ -2220,10 +2224,6 @@ static int stmmac_init_dma_engine(struct
 				       tx_q->tx_tail_addr, chan);
 	}
 
-	/* DMA CSR Channel configuration */
-	for (chan = 0; chan < dma_csr_ch; chan++)
-		stmmac_init_chan(priv, priv->ioaddr, priv->plat->dma_cfg, chan);
-
 	return ret;
 }
 


