Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B04321269D9
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 19:41:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728303AbfLSSlg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 13:41:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:60606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728137AbfLSSld (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:41:33 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0F409206D7;
        Thu, 19 Dec 2019 18:41:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576780892;
        bh=CR7iJLBFC0p+I0svM9R3QUfqLgsXkDgcOEVVfc+aVFQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WfUOBlR55DaqBjeB7w8mCh84jw9FxX1uhYqRcQC/dYPHbLPqhPx48uLzvpHpR1Bpt
         KPADiLcGHUeS3wck9wDY//cuY166UhxfOZrpoS18bkamyeL/p8ogJtnitqCFw+5f0d
         NdtrATjEx3rzlL4ybOWKAz9Y3kOP0lMscNHAnEGw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aaro Koskinen <aaro.koskinen@nokia.com>,
        "David S. Miller" <davem@davemloft.net>, Aviraj CJ <acj@cisco.com>
Subject: [PATCH 4.4 161/162] net: stmmac: use correct DMA buffer size in the RX descriptor
Date:   Thu, 19 Dec 2019 19:34:29 +0100
Message-Id: <20191219183217.559737066@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219183150.477687052@linuxfoundation.org>
References: <20191219183150.477687052@linuxfoundation.org>
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
[acj: backport to v4.4 -stable :
- Modified patch since v4.4 driver has no support for Big endian
- Skipped the section modifying non-existent functions in dwmac4_descs.c and
dwxgmac2_descs.c ]
Signed-off-by: Aviraj CJ <acj@cisco.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/stmicro/stmmac/common.h      |    2 +-
 drivers/net/ethernet/stmicro/stmmac/descs_com.h   |   14 ++++++++++----
 drivers/net/ethernet/stmicro/stmmac/enh_desc.c    |   10 +++++++---
 drivers/net/ethernet/stmicro/stmmac/norm_desc.c   |   10 +++++++---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |    4 ++--
 5 files changed, 27 insertions(+), 13 deletions(-)

--- a/drivers/net/ethernet/stmicro/stmmac/common.h
+++ b/drivers/net/ethernet/stmicro/stmmac/common.h
@@ -301,7 +301,7 @@ struct dma_features {
 struct stmmac_desc_ops {
 	/* DMA RX descriptor ring initialization */
 	void (*init_rx_desc) (struct dma_desc *p, int disable_rx_ic, int mode,
-			      int end);
+			      int end, int bfsize);
 	/* DMA TX descriptor ring initialization */
 	void (*init_tx_desc) (struct dma_desc *p, int mode, int end);
 
--- a/drivers/net/ethernet/stmicro/stmmac/descs_com.h
+++ b/drivers/net/ethernet/stmicro/stmmac/descs_com.h
@@ -33,9 +33,10 @@
 /* Specific functions used for Ring mode */
 
 /* Enhanced descriptors */
-static inline void ehn_desc_rx_set_on_ring(struct dma_desc *p, int end)
+static inline void ehn_desc_rx_set_on_ring(struct dma_desc *p, int end, int bfsize)
 {
-	p->des01.erx.buffer2_size = BUF_SIZE_8KiB - 1;
+	if (bfsize == BUF_SIZE_16KiB)
+		p->des01.erx.buffer2_size = BUF_SIZE_8KiB - 1;
 	if (end)
 		p->des01.erx.end_ring = 1;
 }
@@ -61,9 +62,14 @@ static inline void enh_set_tx_desc_len_o
 }
 
 /* Normal descriptors */
-static inline void ndesc_rx_set_on_ring(struct dma_desc *p, int end)
+static inline void ndesc_rx_set_on_ring(struct dma_desc *p, int end, int bfsize)
 {
-	p->des01.rx.buffer2_size = BUF_SIZE_2KiB - 1;
+	int size;
+
+	if (bfsize >= BUF_SIZE_2KiB) {
+		size = min(bfsize - BUF_SIZE_2KiB + 1, BUF_SIZE_2KiB - 1);
+		p->des01.rx.buffer2_size = size;
+	}
 	if (end)
 		p->des01.rx.end_ring = 1;
 }
--- a/drivers/net/ethernet/stmicro/stmmac/enh_desc.c
+++ b/drivers/net/ethernet/stmicro/stmmac/enh_desc.c
@@ -238,16 +238,20 @@ static int enh_desc_get_rx_status(void *
 }
 
 static void enh_desc_init_rx_desc(struct dma_desc *p, int disable_rx_ic,
-				  int mode, int end)
+				  int mode, int end, int bfsize)
 {
+	int bfsize1;
+
 	p->des01.all_flags = 0;
 	p->des01.erx.own = 1;
-	p->des01.erx.buffer1_size = BUF_SIZE_8KiB - 1;
+
+	bfsize1 = min(bfsize, BUF_SIZE_8KiB - 1);
+	p->des01.erx.buffer1_size = bfsize1;
 
 	if (mode == STMMAC_CHAIN_MODE)
 		ehn_desc_rx_set_on_chain(p, end);
 	else
-		ehn_desc_rx_set_on_ring(p, end);
+		ehn_desc_rx_set_on_ring(p, end, bfsize);
 
 	if (disable_rx_ic)
 		p->des01.erx.disable_ic = 1;
--- a/drivers/net/ethernet/stmicro/stmmac/norm_desc.c
+++ b/drivers/net/ethernet/stmicro/stmmac/norm_desc.c
@@ -121,16 +121,20 @@ static int ndesc_get_rx_status(void *dat
 }
 
 static void ndesc_init_rx_desc(struct dma_desc *p, int disable_rx_ic, int mode,
-			       int end)
+			       int end, int bfsize)
 {
+	int bfsize1;
+
 	p->des01.all_flags = 0;
 	p->des01.rx.own = 1;
-	p->des01.rx.buffer1_size = BUF_SIZE_2KiB - 1;
+
+	bfsize1 = min(bfsize, (BUF_SIZE_2KiB - 1));
+	p->des01.rx.buffer1_size = bfsize1;
 
 	if (mode == STMMAC_CHAIN_MODE)
 		ndesc_rx_set_on_chain(p, end);
 	else
-		ndesc_rx_set_on_ring(p, end);
+		ndesc_rx_set_on_ring(p, end, bfsize);
 
 	if (disable_rx_ic)
 		p->des01.rx.disable_ic = 1;
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -964,11 +964,11 @@ static void stmmac_clear_descriptors(str
 		if (priv->extend_desc)
 			priv->hw->desc->init_rx_desc(&priv->dma_erx[i].basic,
 						     priv->use_riwt, priv->mode,
-						     (i == rxsize - 1));
+						     (i == rxsize - 1), priv->dma_buf_sz);
 		else
 			priv->hw->desc->init_rx_desc(&priv->dma_rx[i],
 						     priv->use_riwt, priv->mode,
-						     (i == rxsize - 1));
+						     (i == rxsize - 1), priv->dma_buf_sz);
 	for (i = 0; i < txsize; i++)
 		if (priv->extend_desc)
 			priv->hw->desc->init_tx_desc(&priv->dma_etx[i].basic,


