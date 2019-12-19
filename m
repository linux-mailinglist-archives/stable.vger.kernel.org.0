Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BBCD2126C35
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 20:02:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729847AbfLSStp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 13:49:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:43266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729839AbfLSSto (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:49:44 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3D9942064B;
        Thu, 19 Dec 2019 18:49:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576781383;
        bh=dy+zMnStKF/2KvJ7CfByOjDrFTAXT0XwsYSM3wKCSEs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YMByO0Tn0XvhGUvo1UzTGsfUdJmO/LDC16qoSVnhkzNhtZrU8RIW6AFedghsIKYXZ
         HARWFfXjMyCeRgoL113WDzkj28yNmSsjVm14kb7iN4AnDksS2+W2dSQw6MEhje6lpZ
         3Z18nMZbTnSQWCMo8sAnirAXTGcmfH9SwxvsSRw4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aaro Koskinen <aaro.koskinen@nokia.com>,
        "David S. Miller" <davem@davemloft.net>, Aviraj CJ <acj@cisco.com>
Subject: [PATCH 4.9 198/199] net: stmmac: use correct DMA buffer size in the RX descriptor
Date:   Thu, 19 Dec 2019 19:34:40 +0100
Message-Id: <20191219183226.778156887@linuxfoundation.org>
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

commit 583e6361414903c5206258a30e5bd88cb03c0254 upstream.

We always program the maximum DMA buffer size into the receive descriptor,
although the allocated size may be less. E.g. with the default MTU size
we allocate only 1536 bytes. If somebody sends us a bigger frame, then
memory may get corrupted.

Fix by using exact buffer sizes.

Signed-off-by: Aaro Koskinen <aaro.koskinen@nokia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
[acj: backport to v4.9 -stable :
- adjust context
- skipped the section modifying non-existent functions in dwxgmac2_descs.c and
hwif.h ]
Signed-off-by: Aviraj CJ <acj@cisco.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/stmicro/stmmac/common.h       |    2 -
 drivers/net/ethernet/stmicro/stmmac/descs_com.h    |   23 +++++++++++++--------
 drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.c |    2 -
 drivers/net/ethernet/stmicro/stmmac/enh_desc.c     |   10 ++++++---
 drivers/net/ethernet/stmicro/stmmac/norm_desc.c    |   10 ++++++---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |    6 ++---
 6 files changed, 34 insertions(+), 19 deletions(-)

--- a/drivers/net/ethernet/stmicro/stmmac/common.h
+++ b/drivers/net/ethernet/stmicro/stmmac/common.h
@@ -354,7 +354,7 @@ struct dma_features {
 struct stmmac_desc_ops {
 	/* DMA RX descriptor ring initialization */
 	void (*init_rx_desc) (struct dma_desc *p, int disable_rx_ic, int mode,
-			      int end);
+			      int end, int bfsize);
 	/* DMA TX descriptor ring initialization */
 	void (*init_tx_desc) (struct dma_desc *p, int mode, int end);
 
--- a/drivers/net/ethernet/stmicro/stmmac/descs_com.h
+++ b/drivers/net/ethernet/stmicro/stmmac/descs_com.h
@@ -33,11 +33,14 @@
 /* Specific functions used for Ring mode */
 
 /* Enhanced descriptors */
-static inline void ehn_desc_rx_set_on_ring(struct dma_desc *p, int end)
+static inline void ehn_desc_rx_set_on_ring(struct dma_desc *p, int end,
+					   int bfsize)
 {
-	p->des1 |= cpu_to_le32(((BUF_SIZE_8KiB - 1)
-			<< ERDES1_BUFFER2_SIZE_SHIFT)
-		   & ERDES1_BUFFER2_SIZE_MASK);
+	if (bfsize == BUF_SIZE_16KiB)
+		p->des1 |= cpu_to_le32((BUF_SIZE_8KiB
+				<< ERDES1_BUFFER2_SIZE_SHIFT)
+                & ERDES1_BUFFER2_SIZE_MASK);
+
 
 	if (end)
 		p->des1 |= cpu_to_le32(ERDES1_END_RING);
@@ -63,11 +66,15 @@ static inline void enh_set_tx_desc_len_o
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
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.c
@@ -289,7 +289,7 @@ exit:
 }
 
 static void dwmac4_rd_init_rx_desc(struct dma_desc *p, int disable_rx_ic,
-				   int mode, int end)
+				   int mode, int end, int bfsize)
 {
 	p->des3 = cpu_to_le32(RDES3_OWN | RDES3_BUFFER1_VALID_ADDR);
 
--- a/drivers/net/ethernet/stmicro/stmmac/enh_desc.c
+++ b/drivers/net/ethernet/stmicro/stmmac/enh_desc.c
@@ -269,15 +269,19 @@ static int enh_desc_get_rx_status(void *
 }
 
 static void enh_desc_init_rx_desc(struct dma_desc *p, int disable_rx_ic,
-				  int mode, int end)
+				  int mode, int end, int bfsize)
 {
+	int bfsize1;
+
 	p->des0 |= cpu_to_le32(RDES0_OWN);
-	p->des1 |= cpu_to_le32((BUF_SIZE_8KiB - 1) & ERDES1_BUFFER1_SIZE_MASK);
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
--- a/drivers/net/ethernet/stmicro/stmmac/norm_desc.c
+++ b/drivers/net/ethernet/stmicro/stmmac/norm_desc.c
@@ -137,15 +137,19 @@ static int ndesc_get_rx_status(void *dat
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
+	p->des1 |= cpu_to_le32(bfsize1 & RDES1_BUFFER1_SIZE_MASK);
 
 	if (mode == STMMAC_CHAIN_MODE)
 		ndesc_rx_set_on_chain(p, end);
 	else
-		ndesc_rx_set_on_ring(p, end);
+		ndesc_rx_set_on_ring(p, end, bfsize);
 
 	if (disable_rx_ic)
 		p->des1 |= cpu_to_le32(RDES1_DISABLE_IC);
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -956,11 +956,11 @@ static void stmmac_clear_descriptors(str
 		if (priv->extend_desc)
 			priv->hw->desc->init_rx_desc(&priv->dma_erx[i].basic,
 						     priv->use_riwt, priv->mode,
-						     (i == DMA_RX_SIZE - 1));
+						     (i == DMA_RX_SIZE - 1), priv->dma_buf_sz);
 		else
 			priv->hw->desc->init_rx_desc(&priv->dma_rx[i],
 						     priv->use_riwt, priv->mode,
-						     (i == DMA_RX_SIZE - 1));
+						     (i == DMA_RX_SIZE - 1), priv->dma_buf_sz);
 	for (i = 0; i < DMA_TX_SIZE; i++)
 		if (priv->extend_desc)
 			priv->hw->desc->init_tx_desc(&priv->dma_etx[i].basic,
@@ -2479,7 +2479,7 @@ static inline void stmmac_rx_refill(stru
 		wmb();
 
 		if (unlikely(priv->synopsys_id >= DWMAC_CORE_4_00))
-			priv->hw->desc->init_rx_desc(p, priv->use_riwt, 0, 0);
+			priv->hw->desc->init_rx_desc(p, priv->use_riwt, 0, 0, priv->dma_buf_sz);
 		else
 			priv->hw->desc->set_rx_owner(p);
 


