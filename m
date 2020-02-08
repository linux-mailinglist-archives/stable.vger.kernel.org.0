Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E96AD156714
	for <lists+stable@lfdr.de>; Sat,  8 Feb 2020 19:39:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727763AbgBHSjB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Feb 2020 13:39:01 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33458 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727549AbgBHS3d (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 Feb 2020 13:29:33 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1j0UrC-0003Zv-Cx; Sat, 08 Feb 2020 18:29:30 +0000
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1j0UrB-000CIv-EV; Sat, 08 Feb 2020 18:29:29 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Aaro Koskinen" <aaro.koskinen@nokia.com>,
        "Aviraj CJ" <acj@cisco.com>,
        "David S. Miller" <davem@davemloft.net>
Date:   Sat, 08 Feb 2020 18:19:06 +0000
Message-ID: <lsq.1581185940.294886007@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 007/148] net: stmmac: use correct DMA buffer size in
 the RX descriptor
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
[bwh: For 3.16, don't subtract 1 from BUF_SIZE_8KiB because I already
 backported commit 8137b6ef0ce4 "net: stmmac: Fix RX packet size > 8191".
 Also fold in commit f87db4dbd52f "net: stmmac: Use bfsize1 in
 ndesc_init_rx_desc".]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/ethernet/stmicro/stmmac/common.h      |  2 +-
 drivers/net/ethernet/stmicro/stmmac/descs_com.h   | 14 ++++++++++----
 drivers/net/ethernet/stmicro/stmmac/enh_desc.c    | 10 +++++++---
 drivers/net/ethernet/stmicro/stmmac/norm_desc.c   | 10 +++++++---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |  4 ++--
 5 files changed, 27 insertions(+), 13 deletions(-)

--- a/drivers/net/ethernet/stmicro/stmmac/common.h
+++ b/drivers/net/ethernet/stmicro/stmmac/common.h
@@ -298,7 +298,7 @@ struct dma_features {
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
-	p->des01.erx.buffer2_size = BUF_SIZE_8KiB;
+	if (bfsize == BUF_SIZE_16KiB)
+		p->des01.erx.buffer2_size = BUF_SIZE_8KiB;
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
-	p->des01.erx.buffer1_size = BUF_SIZE_8KiB;
+
+	bfsize1 = min(bfsize, BUF_SIZE_8KiB);
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
@@ -933,11 +933,11 @@ static void stmmac_clear_descriptors(str
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

