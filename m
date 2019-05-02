Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38FFE11ECF
	for <lists+stable@lfdr.de>; Thu,  2 May 2019 17:46:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728257AbfEBPkm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 May 2019 11:40:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:46634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728338AbfEBP3G (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 May 2019 11:29:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E36D120B7C;
        Thu,  2 May 2019 15:29:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556810945;
        bh=oOKUrr0Ez26leioFSInvPPnvZigoZ19MteDvUal0BX4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q/v/paov/W2XXBt1AZRWgIrINpFsnBVYGwKg17W8QSwWhm36sfzzg7kmI8paZWZPU
         qh6jHLpXYo3GGARPWAzyCbjddkJWp0WH43wYT0Am+UKWgDuS8xEjHN6gGqlRcClTKp
         MdelJ2d7rDZVK764Exn5OjDPSWFXwNtbVxgjQGXc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aaro Koskinen <aaro.koskinen@nokia.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Sasha Levin (Microsoft)" <sashal@kernel.org>
Subject: [PATCH 5.0 017/101] net: stmmac: dont set own bit too early for jumbo frames
Date:   Thu,  2 May 2019 17:20:19 +0200
Message-Id: <20190502143341.179623330@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190502143339.434882399@linuxfoundation.org>
References: <20190502143339.434882399@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 80acbed9f8fca1db3fbe915540b756f048aa0fd7 ]

Commit 0e80bdc9a72d ("stmmac: first frame prep at the end of xmit
routine") overlooked jumbo frames when re-ordering the code, and as a
result the own bit was not getting set anymore for the first jumbo frame
descriptor. Commit 487e2e22ab79 ("net: stmmac: Set OWN bit for jumbo
frames") tried to fix this, but now the bit is getting set too early and
the DMA may start while we are still setting up the remaining descriptors.
And with the chain mode the own bit remains still unset.

Fix by setting the own bit at the end of xmit also with jumbo frames.

Fixes: 0e80bdc9a72d ("stmmac: first frame prep at the end of xmit routine")
Fixes: 487e2e22ab79 ("net: stmmac: Set OWN bit for jumbo frames")
Signed-off-by: Aaro Koskinen <aaro.koskinen@nokia.com>
Acked-by: Jose Abreu <joabreu@synopsys.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin (Microsoft) <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/ring_mode.c   |  4 ++--
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 14 ++++++++------
 2 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/ring_mode.c b/drivers/net/ethernet/stmicro/stmmac/ring_mode.c
index c0c75c111abb..afed0f0f4027 100644
--- a/drivers/net/ethernet/stmicro/stmmac/ring_mode.c
+++ b/drivers/net/ethernet/stmicro/stmmac/ring_mode.c
@@ -59,7 +59,7 @@ static int jumbo_frm(void *p, struct sk_buff *skb, int csum)
 
 		desc->des3 = cpu_to_le32(des2 + BUF_SIZE_4KiB);
 		stmmac_prepare_tx_desc(priv, desc, 1, bmax, csum,
-				STMMAC_RING_MODE, 1, false, skb->len);
+				STMMAC_RING_MODE, 0, false, skb->len);
 		tx_q->tx_skbuff[entry] = NULL;
 		entry = STMMAC_GET_ENTRY(entry, DMA_TX_SIZE);
 
@@ -91,7 +91,7 @@ static int jumbo_frm(void *p, struct sk_buff *skb, int csum)
 		tx_q->tx_skbuff_dma[entry].is_jumbo = true;
 		desc->des3 = cpu_to_le32(des2 + BUF_SIZE_4KiB);
 		stmmac_prepare_tx_desc(priv, desc, 1, nopaged_len, csum,
-				STMMAC_RING_MODE, 1, true, skb->len);
+				STMMAC_RING_MODE, 0, true, skb->len);
 	}
 
 	tx_q->cur_tx = entry;
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 1d8d6f2ddfd6..0bc3632880b5 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -3190,14 +3190,16 @@ static netdev_tx_t stmmac_xmit(struct sk_buff *skb, struct net_device *dev)
 		stmmac_prepare_tx_desc(priv, first, 1, nopaged_len,
 				csum_insertion, priv->mode, 1, last_segment,
 				skb->len);
-
-		/* The own bit must be the latest setting done when prepare the
-		 * descriptor and then barrier is needed to make sure that
-		 * all is coherent before granting the DMA engine.
-		 */
-		wmb();
+	} else {
+		stmmac_set_tx_owner(priv, first);
 	}
 
+	/* The own bit must be the latest setting done when prepare the
+	 * descriptor and then barrier is needed to make sure that
+	 * all is coherent before granting the DMA engine.
+	 */
+	wmb();
+
 	netdev_tx_sent_queue(netdev_get_tx_queue(dev, queue), skb->len);
 
 	stmmac_enable_dma_transmission(priv, priv->ioaddr);
-- 
2.19.1



