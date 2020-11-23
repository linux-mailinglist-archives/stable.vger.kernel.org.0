Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FECA2C077F
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 13:44:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732677AbgKWMld (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:41:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:54416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732664AbgKWMl2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:41:28 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3165420732;
        Mon, 23 Nov 2020 12:41:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135287;
        bh=kadin7ZV3Z4Gp+o0HxQblkp5obMA8Q3beswoiACYu3w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hPJaFra1dzCIu5Kq5/WWwtWkSq9OIQYQznIBxPVBEtClnAGbC3T8bjSRdplWoKA/+
         rTEc4TR7Q4Sr7/IJcY8sKwv1KZ6XjeFVmpHWPQ+pwXc2qjNwzC1HSPZjBnutMuQPZi
         zDO26jYzAjTOTdG7zKv1wwJJfxjo9LhHQf+LXALU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alex Marginean <alexandru.marginean@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.9 005/252] enetc: Workaround for MDIO register access issue
Date:   Mon, 23 Nov 2020 13:19:15 +0100
Message-Id: <20201123121835.844283567@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121835.580259631@linuxfoundation.org>
References: <20201123121835.580259631@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Marginean <alexandru.marginean@nxp.com>

[ Upstream commit fd5736bf9f235d26c83cac8a16c70bbdafa55abe ]

Due to a hardware issue, an access to MDIO registers
that is concurrent with other ENETC register accesses
may lead to the MDIO access being dropped or corrupted.
The workaround introduces locking for all register accesses
to the ENETC register space.  To reduce performance impact,
a readers-writers locking scheme has been implemented.
The writer in this case is the MDIO access code (irrelevant
whether that MDIO access is a register read or write), and
the reader is any access code to non-MDIO ENETC registers.
Also, the datapath functions acquire the read lock fewer times
and use _hot accessors.  All the rest of the code uses the _wa
accessors which lock every register access.
The commit introducing MDIO support is -
commit ebfcb23d62ab ("enetc: Add ENETC PF level external MDIO support")
but due to subsequent refactoring this patch is applicable on
top of a later commit.

Fixes: 6517798dd343 ("enetc: Make MDIO accessors more generic and export to include/linux/fsl")
Signed-off-by: Alex Marginean <alexandru.marginean@nxp.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>
Link: https://lore.kernel.org/r/20201112182608.26177-1-claudiu.manoil@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/freescale/enetc/Kconfig      |    1 
 drivers/net/ethernet/freescale/enetc/enetc.c      |   62 ++++++++---
 drivers/net/ethernet/freescale/enetc/enetc_hw.h   |  115 ++++++++++++++++++++--
 drivers/net/ethernet/freescale/enetc/enetc_mdio.c |    8 +
 4 files changed, 161 insertions(+), 25 deletions(-)

--- a/drivers/net/ethernet/freescale/enetc/Kconfig
+++ b/drivers/net/ethernet/freescale/enetc/Kconfig
@@ -15,6 +15,7 @@ config FSL_ENETC
 config FSL_ENETC_VF
 	tristate "ENETC VF driver"
 	depends on PCI && PCI_MSI
+	select FSL_ENETC_MDIO
 	select PHYLIB
 	select DIMLIB
 	help
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -34,7 +34,10 @@ netdev_tx_t enetc_xmit(struct sk_buff *s
 		return NETDEV_TX_BUSY;
 	}
 
+	enetc_lock_mdio();
 	count = enetc_map_tx_buffs(tx_ring, skb, priv->active_offloads);
+	enetc_unlock_mdio();
+
 	if (unlikely(!count))
 		goto drop_packet_err;
 
@@ -240,7 +243,7 @@ static int enetc_map_tx_buffs(struct ene
 	skb_tx_timestamp(skb);
 
 	/* let H/W know BD ring has been updated */
-	enetc_wr_reg(tx_ring->tpir, i); /* includes wmb() */
+	enetc_wr_reg_hot(tx_ring->tpir, i); /* includes wmb() */
 
 	return count;
 
@@ -263,12 +266,16 @@ static irqreturn_t enetc_msix(int irq, v
 	struct enetc_int_vector	*v = data;
 	int i;
 
+	enetc_lock_mdio();
+
 	/* disable interrupts */
-	enetc_wr_reg(v->rbier, 0);
-	enetc_wr_reg(v->ricr1, v->rx_ictt);
+	enetc_wr_reg_hot(v->rbier, 0);
+	enetc_wr_reg_hot(v->ricr1, v->rx_ictt);
 
 	for_each_set_bit(i, &v->tx_rings_map, ENETC_MAX_NUM_TXQS)
-		enetc_wr_reg(v->tbier_base + ENETC_BDR_OFF(i), 0);
+		enetc_wr_reg_hot(v->tbier_base + ENETC_BDR_OFF(i), 0);
+
+	enetc_unlock_mdio();
 
 	napi_schedule(&v->napi);
 
@@ -335,19 +342,23 @@ static int enetc_poll(struct napi_struct
 
 	v->rx_napi_work = false;
 
+	enetc_lock_mdio();
+
 	/* enable interrupts */
-	enetc_wr_reg(v->rbier, ENETC_RBIER_RXTIE);
+	enetc_wr_reg_hot(v->rbier, ENETC_RBIER_RXTIE);
 
 	for_each_set_bit(i, &v->tx_rings_map, ENETC_MAX_NUM_TXQS)
-		enetc_wr_reg(v->tbier_base + ENETC_BDR_OFF(i),
-			     ENETC_TBIER_TXTIE);
+		enetc_wr_reg_hot(v->tbier_base + ENETC_BDR_OFF(i),
+				 ENETC_TBIER_TXTIE);
+
+	enetc_unlock_mdio();
 
 	return work_done;
 }
 
 static int enetc_bd_ready_count(struct enetc_bdr *tx_ring, int ci)
 {
-	int pi = enetc_rd_reg(tx_ring->tcir) & ENETC_TBCIR_IDX_MASK;
+	int pi = enetc_rd_reg_hot(tx_ring->tcir) & ENETC_TBCIR_IDX_MASK;
 
 	return pi >= ci ? pi - ci : tx_ring->bd_count - ci + pi;
 }
@@ -387,7 +398,10 @@ static bool enetc_clean_tx_ring(struct e
 
 	i = tx_ring->next_to_clean;
 	tx_swbd = &tx_ring->tx_swbd[i];
+
+	enetc_lock_mdio();
 	bds_to_clean = enetc_bd_ready_count(tx_ring, i);
+	enetc_unlock_mdio();
 
 	do_tstamp = false;
 
@@ -430,16 +444,20 @@ static bool enetc_clean_tx_ring(struct e
 			tx_swbd = tx_ring->tx_swbd;
 		}
 
+		enetc_lock_mdio();
+
 		/* BD iteration loop end */
 		if (is_eof) {
 			tx_frm_cnt++;
 			/* re-arm interrupt source */
-			enetc_wr_reg(tx_ring->idr, BIT(tx_ring->index) |
-				     BIT(16 + tx_ring->index));
+			enetc_wr_reg_hot(tx_ring->idr, BIT(tx_ring->index) |
+					 BIT(16 + tx_ring->index));
 		}
 
 		if (unlikely(!bds_to_clean))
 			bds_to_clean = enetc_bd_ready_count(tx_ring, i);
+
+		enetc_unlock_mdio();
 	}
 
 	tx_ring->next_to_clean = i;
@@ -516,8 +534,6 @@ static int enetc_refill_rx_ring(struct e
 	if (likely(j)) {
 		rx_ring->next_to_alloc = i; /* keep track from page reuse */
 		rx_ring->next_to_use = i;
-		/* update ENETC's consumer index */
-		enetc_wr_reg(rx_ring->rcir, i);
 	}
 
 	return j;
@@ -535,8 +551,8 @@ static void enetc_get_rx_tstamp(struct n
 	u64 tstamp;
 
 	if (le16_to_cpu(rxbd->r.flags) & ENETC_RXBD_FLAG_TSTMP) {
-		lo = enetc_rd(hw, ENETC_SICTR0);
-		hi = enetc_rd(hw, ENETC_SICTR1);
+		lo = enetc_rd_reg_hot(hw->reg + ENETC_SICTR0);
+		hi = enetc_rd_reg_hot(hw->reg + ENETC_SICTR1);
 		rxbd = enetc_rxbd_ext(rxbd);
 		tstamp_lo = le32_to_cpu(rxbd->ext.tstamp);
 		if (lo <= tstamp_lo)
@@ -685,23 +701,31 @@ static int enetc_clean_rx_ring(struct en
 		u32 bd_status;
 		u16 size;
 
+		enetc_lock_mdio();
+
 		if (cleaned_cnt >= ENETC_RXBD_BUNDLE) {
 			int count = enetc_refill_rx_ring(rx_ring, cleaned_cnt);
 
+			/* update ENETC's consumer index */
+			enetc_wr_reg_hot(rx_ring->rcir, rx_ring->next_to_use);
 			cleaned_cnt -= count;
 		}
 
 		rxbd = enetc_rxbd(rx_ring, i);
 		bd_status = le32_to_cpu(rxbd->r.lstatus);
-		if (!bd_status)
+		if (!bd_status) {
+			enetc_unlock_mdio();
 			break;
+		}
 
-		enetc_wr_reg(rx_ring->idr, BIT(rx_ring->index));
+		enetc_wr_reg_hot(rx_ring->idr, BIT(rx_ring->index));
 		dma_rmb(); /* for reading other rxbd fields */
 		size = le16_to_cpu(rxbd->r.buf_len);
 		skb = enetc_map_rx_buff_to_skb(rx_ring, i, size);
-		if (!skb)
+		if (!skb) {
+			enetc_unlock_mdio();
 			break;
+		}
 
 		enetc_get_offloads(rx_ring, rxbd, skb);
 
@@ -713,6 +737,7 @@ static int enetc_clean_rx_ring(struct en
 
 		if (unlikely(bd_status &
 			     ENETC_RXBD_LSTATUS(ENETC_RXBD_ERR_MASK))) {
+			enetc_unlock_mdio();
 			dev_kfree_skb(skb);
 			while (!(bd_status & ENETC_RXBD_LSTATUS_F)) {
 				dma_rmb();
@@ -752,6 +777,8 @@ static int enetc_clean_rx_ring(struct en
 
 		enetc_process_skb(rx_ring, skb);
 
+		enetc_unlock_mdio();
+
 		napi_gro_receive(napi, skb);
 
 		rx_frm_cnt++;
@@ -1226,6 +1253,7 @@ static void enetc_setup_rxbdr(struct ene
 	rx_ring->idr = hw->reg + ENETC_SIRXIDR;
 
 	enetc_refill_rx_ring(rx_ring, enetc_bd_unused(rx_ring));
+	enetc_wr(hw, ENETC_SIRXIDR, rx_ring->next_to_use);
 
 	/* enable ring */
 	enetc_rxbdr_wr(hw, idx, ENETC_RBMR, rbmr);
--- a/drivers/net/ethernet/freescale/enetc/enetc_hw.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
@@ -324,14 +324,100 @@ struct enetc_hw {
 	void __iomem *global;
 };
 
-/* general register accessors */
-#define enetc_rd_reg(reg)	ioread32((reg))
-#define enetc_wr_reg(reg, val)	iowrite32((val), (reg))
+/* ENETC register accessors */
+
+/* MDIO issue workaround (on LS1028A) -
+ * Due to a hardware issue, an access to MDIO registers
+ * that is concurrent with other ENETC register accesses
+ * may lead to the MDIO access being dropped or corrupted.
+ * To protect the MDIO accesses a readers-writers locking
+ * scheme is used, where the MDIO register accesses are
+ * protected by write locks to insure exclusivity, while
+ * the remaining ENETC registers are accessed under read
+ * locks since they only compete with MDIO accesses.
+ */
+extern rwlock_t enetc_mdio_lock;
+
+/* use this locking primitive only on the fast datapath to
+ * group together multiple non-MDIO register accesses to
+ * minimize the overhead of the lock
+ */
+static inline void enetc_lock_mdio(void)
+{
+	read_lock(&enetc_mdio_lock);
+}
+
+static inline void enetc_unlock_mdio(void)
+{
+	read_unlock(&enetc_mdio_lock);
+}
+
+/* use these accessors only on the fast datapath under
+ * the enetc_lock_mdio() locking primitive to minimize
+ * the overhead of the lock
+ */
+static inline u32 enetc_rd_reg_hot(void __iomem *reg)
+{
+	lockdep_assert_held(&enetc_mdio_lock);
+
+	return ioread32(reg);
+}
+
+static inline void enetc_wr_reg_hot(void __iomem *reg, u32 val)
+{
+	lockdep_assert_held(&enetc_mdio_lock);
+
+	iowrite32(val, reg);
+}
+
+/* internal helpers for the MDIO w/a */
+static inline u32 _enetc_rd_reg_wa(void __iomem *reg)
+{
+	u32 val;
+
+	enetc_lock_mdio();
+	val = ioread32(reg);
+	enetc_unlock_mdio();
+
+	return val;
+}
+
+static inline void _enetc_wr_reg_wa(void __iomem *reg, u32 val)
+{
+	enetc_lock_mdio();
+	iowrite32(val, reg);
+	enetc_unlock_mdio();
+}
+
+static inline u32 _enetc_rd_mdio_reg_wa(void __iomem *reg)
+{
+	unsigned long flags;
+	u32 val;
+
+	write_lock_irqsave(&enetc_mdio_lock, flags);
+	val = ioread32(reg);
+	write_unlock_irqrestore(&enetc_mdio_lock, flags);
+
+	return val;
+}
+
+static inline void _enetc_wr_mdio_reg_wa(void __iomem *reg, u32 val)
+{
+	unsigned long flags;
+
+	write_lock_irqsave(&enetc_mdio_lock, flags);
+	iowrite32(val, reg);
+	write_unlock_irqrestore(&enetc_mdio_lock, flags);
+}
+
 #ifdef ioread64
-#define enetc_rd_reg64(reg)	ioread64((reg))
+static inline u64 _enetc_rd_reg64(void __iomem *reg)
+{
+	return ioread64(reg);
+}
 #else
 /* using this to read out stats on 32b systems */
-static inline u64 enetc_rd_reg64(void __iomem *reg)
+static inline u64 _enetc_rd_reg64(void __iomem *reg)
 {
 	u32 low, high, tmp;
 
@@ -345,12 +431,29 @@ static inline u64 enetc_rd_reg64(void __
 }
 #endif
 
+static inline u64 _enetc_rd_reg64_wa(void __iomem *reg)
+{
+	u64 val;
+
+	enetc_lock_mdio();
+	val = _enetc_rd_reg64(reg);
+	enetc_unlock_mdio();
+
+	return val;
+}
+
+/* general register accessors */
+#define enetc_rd_reg(reg)		_enetc_rd_reg_wa((reg))
+#define enetc_wr_reg(reg, val)		_enetc_wr_reg_wa((reg), (val))
 #define enetc_rd(hw, off)		enetc_rd_reg((hw)->reg + (off))
 #define enetc_wr(hw, off, val)		enetc_wr_reg((hw)->reg + (off), val)
-#define enetc_rd64(hw, off)		enetc_rd_reg64((hw)->reg + (off))
+#define enetc_rd64(hw, off)		_enetc_rd_reg64_wa((hw)->reg + (off))
 /* port register accessors - PF only */
 #define enetc_port_rd(hw, off)		enetc_rd_reg((hw)->port + (off))
 #define enetc_port_wr(hw, off, val)	enetc_wr_reg((hw)->port + (off), val)
+#define enetc_port_rd_mdio(hw, off)	_enetc_rd_mdio_reg_wa((hw)->port + (off))
+#define enetc_port_wr_mdio(hw, off, val)	_enetc_wr_mdio_reg_wa(\
+							(hw)->port + (off), val)
 /* global register accessors - PF only */
 #define enetc_global_rd(hw, off)	enetc_rd_reg((hw)->global + (off))
 #define enetc_global_wr(hw, off, val)	enetc_wr_reg((hw)->global + (off), val)
--- a/drivers/net/ethernet/freescale/enetc/enetc_mdio.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_mdio.c
@@ -16,13 +16,13 @@
 
 static inline u32 _enetc_mdio_rd(struct enetc_mdio_priv *mdio_priv, int off)
 {
-	return enetc_port_rd(mdio_priv->hw, mdio_priv->mdio_base + off);
+	return enetc_port_rd_mdio(mdio_priv->hw, mdio_priv->mdio_base + off);
 }
 
 static inline void _enetc_mdio_wr(struct enetc_mdio_priv *mdio_priv, int off,
 				  u32 val)
 {
-	enetc_port_wr(mdio_priv->hw, mdio_priv->mdio_base + off, val);
+	enetc_port_wr_mdio(mdio_priv->hw, mdio_priv->mdio_base + off, val);
 }
 
 #define enetc_mdio_rd(mdio_priv, off) \
@@ -174,3 +174,7 @@ struct enetc_hw *enetc_hw_alloc(struct d
 	return hw;
 }
 EXPORT_SYMBOL_GPL(enetc_hw_alloc);
+
+/* Lock for MDIO access errata on LS1028A */
+DEFINE_RWLOCK(enetc_mdio_lock);
+EXPORT_SYMBOL_GPL(enetc_mdio_lock);


