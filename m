Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E91A614E7E
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 17:03:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727152AbfEFPCe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 11:02:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:33856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728033AbfEFOka (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 May 2019 10:40:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 88E5D20449;
        Mon,  6 May 2019 14:40:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557153629;
        bh=LBNIA2N01xiX+SJu8EL/hWKIx+7oFO08rvmKtjuiILA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O9gOaF5qpEzUzPbHH2dRpTtzctfzvy+bPqNKQ9WGysUwwDBWSdLRkXZjmcVXJo21z
         TxgDRFG5OwDkJxNHfjI8bBeP3Gm4hZ8FQl0ax9MUV2m4kp0xxB+bij5gvG5m4ag4Y4
         RavyUelcdA5URolK8e9qHxylNTeGLClqbZ+D3cGY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aaro Koskinen <aaro.koskinen@nokia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 38/99] net: stmmac: use correct DMA buffer size in the RX descriptor
Date:   Mon,  6 May 2019 16:32:11 +0200
Message-Id: <20190506143057.399914447@linuxfoundation.org>
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

[ Upstream commit 583e6361414903c5206258a30e5bd88cb03c0254 ]

We always program the maximum DMA buffer size into the receive descriptor,
although the allocated size may be less. E.g. with the default MTU size
we allocate only 1536 bytes. If somebody sends us a bigger frame, then
memory may get corrupted.

Fix by using exact buffer sizes.

Signed-off-by: Aaro Koskinen <aaro.koskinen@nokia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/stmicro/stmmac/descs_com.h   | 22 ++++++++++++-------
 .../ethernet/stmicro/stmmac/dwmac4_descs.c    |  2 +-
 .../ethernet/stmicro/stmmac/dwxgmac2_descs.c  |  2 +-
 .../net/ethernet/stmicro/stmmac/enh_desc.c    | 10 ++++++---
 drivers/net/ethernet/stmicro/stmmac/hwif.h    |  2 +-
 .../net/ethernet/stmicro/stmmac/norm_desc.c   | 10 ++++++---
 .../net/ethernet/stmicro/stmmac/stmmac_main.c |  6 +++--
 7 files changed, 35 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/descs_com.h b/drivers/net/ethernet/stmicro/stmmac/descs_com.h
index 40d6356a7e73..3dfb07a78952 100644
--- a/drivers/net/ethernet/stmicro/stmmac/descs_com.h
+++ b/drivers/net/ethernet/stmicro/stmmac/descs_com.h
@@ -29,11 +29,13 @@
 /* Specific functions used for Ring mode */
 
 /* Enhanced descriptors */
-static inline void ehn_desc_rx_set_on_ring(struct dma_desc *p, int end)
+static inline void ehn_desc_rx_set_on_ring(struct dma_desc *p, int end,
+					   int bfsize)
 {
-	p->des1 |= cpu_to_le32((BUF_SIZE_8KiB
-			<< ERDES1_BUFFER2_SIZE_SHIFT)
-		   & ERDES1_BUFFER2_SIZE_MASK);
+	if (bfsize == BUF_SIZE_16KiB)
+		p->des1 |= cpu_to_le32((BUF_SIZE_8KiB
+				<< ERDES1_BUFFER2_SIZE_SHIFT)
+			   & ERDES1_BUFFER2_SIZE_MASK);
 
 	if (end)
 		p->des1 |= cpu_to_le32(ERDES1_END_RING);
@@ -59,11 +61,15 @@ static inline void enh_set_tx_desc_len_on_ring(struct dma_desc *p, int len)
 }
 
 /* Normal descriptors */
-static inline void ndesc_rx_set_on_ring(struct dma_desc *p, int end)
+static inline void ndesc_rx_set_on_ring(struct dma_desc *p, int end, int bfsize)
 {
-	p->des1 |= cpu_to_le32(((BUF_SIZE_2KiB - 1)
-				<< RDES1_BUFFER2_SIZE_SHIFT)
-		    & RDES1_BUFFER2_SIZE_MASK);
+	if (bfsize >= BUF_SIZE_2KiB) {
+		int bfsize2;
+
+		bfsize2 = min(bfsize - BUF_SIZE_2KiB + 1, BUF_SIZE_2KiB - 1);
+		p->des1 |= cpu_to_le32((bfsize2 << RDES1_BUFFER2_SIZE_SHIFT)
+			    & RDES1_BUFFER2_SIZE_MASK);
+	}
 
 	if (end)
 		p->des1 |= cpu_to_le32(RDES1_END_RING);
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.c
index 736e29635b77..313a58b68fee 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.c
@@ -296,7 +296,7 @@ static int dwmac4_wrback_get_rx_timestamp_status(void *desc, void *next_desc,
 }
 
 static void dwmac4_rd_init_rx_desc(struct dma_desc *p, int disable_rx_ic,
-				   int mode, int end)
+				   int mode, int end, int bfsize)
 {
 	dwmac4_set_rx_owner(p, disable_rx_ic);
 }
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_descs.c b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_descs.c
index 1d858fdec997..98fa471da7c0 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_descs.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_descs.c
@@ -123,7 +123,7 @@ static int dwxgmac2_get_rx_timestamp_status(void *desc, void *next_desc,
 }
 
 static void dwxgmac2_init_rx_desc(struct dma_desc *p, int disable_rx_ic,
-				  int mode, int end)
+				  int mode, int end, int bfsize)
 {
 	dwxgmac2_set_rx_owner(p, disable_rx_ic);
 }
diff --git a/drivers/net/ethernet/stmicro/stmmac/enh_desc.c b/drivers/net/ethernet/stmicro/stmmac/enh_desc.c
index 5ef91a790f9d..e8855e6adb48 100644
--- a/drivers/net/ethernet/stmicro/stmmac/enh_desc.c
+++ b/drivers/net/ethernet/stmicro/stmmac/enh_desc.c
@@ -259,15 +259,19 @@ static int enh_desc_get_rx_status(void *data, struct stmmac_extra_stats *x,
 }
 
 static void enh_desc_init_rx_desc(struct dma_desc *p, int disable_rx_ic,
-				  int mode, int end)
+				  int mode, int end, int bfsize)
 {
+	int bfsize1;
+
 	p->des0 |= cpu_to_le32(RDES0_OWN);
-	p->des1 |= cpu_to_le32(BUF_SIZE_8KiB & ERDES1_BUFFER1_SIZE_MASK);
+
+	bfsize1 = min(bfsize, BUF_SIZE_8KiB);
+	p->des1 |= cpu_to_le32(bfsize1 & ERDES1_BUFFER1_SIZE_MASK);
 
 	if (mode == STMMAC_CHAIN_MODE)
 		ehn_desc_rx_set_on_chain(p);
 	else
-		ehn_desc_rx_set_on_ring(p, end);
+		ehn_desc_rx_set_on_ring(p, end, bfsize);
 
 	if (disable_rx_ic)
 		p->des1 |= cpu_to_le32(ERDES1_DISABLE_IC);
diff --git a/drivers/net/ethernet/stmicro/stmmac/hwif.h b/drivers/net/ethernet/stmicro/stmmac/hwif.h
index 92b8944f26e3..5bb00234d961 100644
--- a/drivers/net/ethernet/stmicro/stmmac/hwif.h
+++ b/drivers/net/ethernet/stmicro/stmmac/hwif.h
@@ -33,7 +33,7 @@ struct dma_extended_desc;
 struct stmmac_desc_ops {
 	/* DMA RX descriptor ring initialization */
 	void (*init_rx_desc)(struct dma_desc *p, int disable_rx_ic, int mode,
-			int end);
+			int end, int bfsize);
 	/* DMA TX descriptor ring initialization */
 	void (*init_tx_desc)(struct dma_desc *p, int mode, int end);
 	/* Invoked by the xmit function to prepare the tx descriptor */
diff --git a/drivers/net/ethernet/stmicro/stmmac/norm_desc.c b/drivers/net/ethernet/stmicro/stmmac/norm_desc.c
index de65bb29feba..c55a9815b394 100644
--- a/drivers/net/ethernet/stmicro/stmmac/norm_desc.c
+++ b/drivers/net/ethernet/stmicro/stmmac/norm_desc.c
@@ -135,15 +135,19 @@ static int ndesc_get_rx_status(void *data, struct stmmac_extra_stats *x,
 }
 
 static void ndesc_init_rx_desc(struct dma_desc *p, int disable_rx_ic, int mode,
-			       int end)
+			       int end, int bfsize)
 {
+	int bfsize1;
+
 	p->des0 |= cpu_to_le32(RDES0_OWN);
-	p->des1 |= cpu_to_le32((BUF_SIZE_2KiB - 1) & RDES1_BUFFER1_SIZE_MASK);
+
+	bfsize1 = min(bfsize, BUF_SIZE_2KiB - 1);
+	p->des1 |= cpu_to_le32(bfsize & RDES1_BUFFER1_SIZE_MASK);
 
 	if (mode == STMMAC_CHAIN_MODE)
 		ndesc_rx_set_on_chain(p, end);
 	else
-		ndesc_rx_set_on_ring(p, end);
+		ndesc_rx_set_on_ring(p, end, bfsize);
 
 	if (disable_rx_ic)
 		p->des1 |= cpu_to_le32(RDES1_DISABLE_IC);
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 39c105092214..b44ca0c90c5c 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -1111,11 +1111,13 @@ static void stmmac_clear_rx_descriptors(struct stmmac_priv *priv, u32 queue)
 		if (priv->extend_desc)
 			stmmac_init_rx_desc(priv, &rx_q->dma_erx[i].basic,
 					priv->use_riwt, priv->mode,
-					(i == DMA_RX_SIZE - 1));
+					(i == DMA_RX_SIZE - 1),
+					priv->dma_buf_sz);
 		else
 			stmmac_init_rx_desc(priv, &rx_q->dma_rx[i],
 					priv->use_riwt, priv->mode,
-					(i == DMA_RX_SIZE - 1));
+					(i == DMA_RX_SIZE - 1),
+					priv->dma_buf_sz);
 }
 
 /**
-- 
2.20.1



