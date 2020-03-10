Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BB6817F4EB
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 11:20:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725845AbgCJKTz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 06:19:55 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:51299 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726436AbgCJKTz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Mar 2020 06:19:55 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id CEC91220E7;
        Tue, 10 Mar 2020 06:19:53 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Tue, 10 Mar 2020 06:19:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=//hjSh
        ujScCSLILL1WCmByMkx8FiWi5+FtS6oHV1Qlo=; b=fvqf4n1gkQQikMiA34Kjfk
        bBBtrSHutGIRJ8snTqeY8HUbPNwUsIPJBTI2pYs19L7T0MCg0RFxQriRwxkQZxnr
        0x3eA/pbt9bU1fPbjsBEavElGAT2m+mxJtoDjJQYlLHKd0+ni06pIRBIjxcmXneU
        KRYP1134JfPNAeOWsXzUd1G+iPBl4KHJnMsP47dunP9LLSVTiTvv5AF7cCT1WS9a
        gaqGO815RQxRZ2KoKhGVc/r/c96MkrqvovoTo987WYhs7r+ew0v7m2GFmBZiZwc1
        FgdhVNFMfKq7afC/8wFhL358lZ7EbDrCCo06wkiY/FWaobrpjwbTRmYo09OsZo9Q
        ==
X-ME-Sender: <xms:yWlnXpq_DCn7GOvb7i_0lU2wkR_wM_EPOpR5anZMhDZd8Uw055ojDA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedruddvtddgudefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:yWlnXrzQkYqWRpUaJGxOsuWnvxb-qhWqlutL5t_oPesd9kO_jIV3Cw>
    <xmx:yWlnXkAmxXFE4YPn36-wzIipZqPlr4eiUYTSp_cIWfgk6lEWVwXU8A>
    <xmx:yWlnXpIIROjv9F2_rEpoVeTaeWlVjVDIUVs2NU7Ey1yA3GrwufKKBg>
    <xmx:yWlnXksZnmUzAmbw3sn__tXpOna_0xdYV1M3EyoFNvg-m7LukogPPA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 02C3D328005E;
        Tue, 10 Mar 2020 06:19:52 -0400 (EDT)
Subject: FAILED: patch "[PATCH] phy: brcm-sata: Correct MDIO operations for 40nm platforms" failed to apply to 4.19-stable tree
To:     f.fainelli@gmail.com, kishon@ti.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 10 Mar 2020 11:19:50 +0100
Message-ID: <158383559098173@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 0ed41b33882c577e1d6582913163a2f5727765fe Mon Sep 17 00:00:00 2001
From: Florian Fainelli <f.fainelli@gmail.com>
Date: Thu, 20 Feb 2020 20:14:23 -0800
Subject: [PATCH] phy: brcm-sata: Correct MDIO operations for 40nm platforms

The logic to write to MDIO registers on 40nm platforms was wrong
because it would use the port number as an offset from the base address
rather than the bank address of the PHY. This is hardly noticeable
because the only programming we do is enabling SSC or not, which is not
really causing an observable functional change.

Correct that mistake by passing down the struct brcm_sata_port structure
down to the brcm_sata_mdio_wr() and brcm_sata_mdio_rd() functions and do
the proper offsetting for 28nm, respectively 40nm platforms from there.
This means that brcm_sata_pcb_base() is now useless and is therefore
removed.

Fixes: c1602a1a0fbe ("phy: phy_brcmstb_sata: add support for MIPS-based platforms")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>

diff --git a/drivers/phy/broadcom/phy-brcm-sata.c b/drivers/phy/broadcom/phy-brcm-sata.c
index 4710cfcc3037..18251f232172 100644
--- a/drivers/phy/broadcom/phy-brcm-sata.c
+++ b/drivers/phy/broadcom/phy-brcm-sata.c
@@ -186,29 +186,6 @@ enum sata_phy_ctrl_regs {
 	PHY_CTRL_1_RESET			= BIT(0),
 };
 
-static inline void __iomem *brcm_sata_pcb_base(struct brcm_sata_port *port)
-{
-	struct brcm_sata_phy *priv = port->phy_priv;
-	u32 size = 0;
-
-	switch (priv->version) {
-	case BRCM_SATA_PHY_STB_16NM:
-	case BRCM_SATA_PHY_STB_28NM:
-	case BRCM_SATA_PHY_IPROC_NS2:
-	case BRCM_SATA_PHY_DSL_28NM:
-		size = SATA_PCB_REG_28NM_SPACE_SIZE;
-		break;
-	case BRCM_SATA_PHY_STB_40NM:
-		size = SATA_PCB_REG_40NM_SPACE_SIZE;
-		break;
-	default:
-		dev_err(priv->dev, "invalid phy version\n");
-		break;
-	}
-
-	return priv->phy_base + (port->portnum * size);
-}
-
 static inline void __iomem *brcm_sata_ctrl_base(struct brcm_sata_port *port)
 {
 	struct brcm_sata_phy *priv = port->phy_priv;
@@ -226,19 +203,34 @@ static inline void __iomem *brcm_sata_ctrl_base(struct brcm_sata_port *port)
 	return priv->ctrl_base + (port->portnum * size);
 }
 
-static void brcm_sata_phy_wr(void __iomem *pcb_base, u32 bank,
+static void brcm_sata_phy_wr(struct brcm_sata_port *port, u32 bank,
 			     u32 ofs, u32 msk, u32 value)
 {
+	struct brcm_sata_phy *priv = port->phy_priv;
+	void __iomem *pcb_base = priv->phy_base;
 	u32 tmp;
 
+	if (priv->version == BRCM_SATA_PHY_STB_40NM)
+		bank += (port->portnum * SATA_PCB_REG_40NM_SPACE_SIZE);
+	else
+		pcb_base += (port->portnum * SATA_PCB_REG_28NM_SPACE_SIZE);
+
 	writel(bank, pcb_base + SATA_PCB_BANK_OFFSET);
 	tmp = readl(pcb_base + SATA_PCB_REG_OFFSET(ofs));
 	tmp = (tmp & msk) | value;
 	writel(tmp, pcb_base + SATA_PCB_REG_OFFSET(ofs));
 }
 
-static u32 brcm_sata_phy_rd(void __iomem *pcb_base, u32 bank, u32 ofs)
+static u32 brcm_sata_phy_rd(struct brcm_sata_port *port, u32 bank, u32 ofs)
 {
+	struct brcm_sata_phy *priv = port->phy_priv;
+	void __iomem *pcb_base = priv->phy_base;
+
+	if (priv->version == BRCM_SATA_PHY_STB_40NM)
+		bank += (port->portnum * SATA_PCB_REG_40NM_SPACE_SIZE);
+	else
+		pcb_base += (port->portnum * SATA_PCB_REG_28NM_SPACE_SIZE);
+
 	writel(bank, pcb_base + SATA_PCB_BANK_OFFSET);
 	return readl(pcb_base + SATA_PCB_REG_OFFSET(ofs));
 }
@@ -250,16 +242,15 @@ static u32 brcm_sata_phy_rd(void __iomem *pcb_base, u32 bank, u32 ofs)
 
 static void brcm_stb_sata_ssc_init(struct brcm_sata_port *port)
 {
-	void __iomem *base = brcm_sata_pcb_base(port);
 	struct brcm_sata_phy *priv = port->phy_priv;
 	u32 tmp;
 
 	/* override the TX spread spectrum setting */
 	tmp = TXPMD_CONTROL1_TX_SSC_EN_FRC_VAL | TXPMD_CONTROL1_TX_SSC_EN_FRC;
-	brcm_sata_phy_wr(base, TXPMD_REG_BANK, TXPMD_CONTROL1, ~tmp, tmp);
+	brcm_sata_phy_wr(port, TXPMD_REG_BANK, TXPMD_CONTROL1, ~tmp, tmp);
 
 	/* set fixed min freq */
-	brcm_sata_phy_wr(base, TXPMD_REG_BANK, TXPMD_TX_FREQ_CTRL_CONTROL2,
+	brcm_sata_phy_wr(port, TXPMD_REG_BANK, TXPMD_TX_FREQ_CTRL_CONTROL2,
 			 ~TXPMD_TX_FREQ_CTRL_CONTROL2_FMIN_MASK,
 			 STB_FMIN_VAL_DEFAULT);
 
@@ -271,7 +262,7 @@ static void brcm_stb_sata_ssc_init(struct brcm_sata_port *port)
 		tmp = STB_FMAX_VAL_DEFAULT;
 	}
 
-	brcm_sata_phy_wr(base, TXPMD_REG_BANK, TXPMD_TX_FREQ_CTRL_CONTROL3,
+	brcm_sata_phy_wr(port, TXPMD_REG_BANK, TXPMD_TX_FREQ_CTRL_CONTROL3,
 			  ~TXPMD_TX_FREQ_CTRL_CONTROL3_FMAX_MASK, tmp);
 }
 
@@ -280,7 +271,6 @@ static void brcm_stb_sata_ssc_init(struct brcm_sata_port *port)
 
 static int brcm_stb_sata_rxaeq_init(struct brcm_sata_port *port)
 {
-	void __iomem *base = brcm_sata_pcb_base(port);
 	u32 tmp = 0, reg = 0;
 
 	switch (port->rxaeq_mode) {
@@ -301,8 +291,8 @@ static int brcm_stb_sata_rxaeq_init(struct brcm_sata_port *port)
 		break;
 	}
 
-	brcm_sata_phy_wr(base, AEQRX_REG_BANK_0, reg, ~tmp, tmp);
-	brcm_sata_phy_wr(base, AEQRX_REG_BANK_1, reg, ~tmp, tmp);
+	brcm_sata_phy_wr(port, AEQRX_REG_BANK_0, reg, ~tmp, tmp);
+	brcm_sata_phy_wr(port, AEQRX_REG_BANK_1, reg, ~tmp, tmp);
 
 	return 0;
 }
@@ -316,18 +306,17 @@ static int brcm_stb_sata_init(struct brcm_sata_port *port)
 
 static int brcm_stb_sata_16nm_ssc_init(struct brcm_sata_port *port)
 {
-	void __iomem *base = brcm_sata_pcb_base(port);
 	u32 tmp, value;
 
 	/* Reduce CP tail current to 1/16th of its default value */
-	brcm_sata_phy_wr(base, PLL1_REG_BANK, PLL1_ACTRL6, 0, 0x141);
+	brcm_sata_phy_wr(port, PLL1_REG_BANK, PLL1_ACTRL6, 0, 0x141);
 
 	/* Turn off CP tail current boost */
-	brcm_sata_phy_wr(base, PLL1_REG_BANK, PLL1_ACTRL8, 0, 0xc006);
+	brcm_sata_phy_wr(port, PLL1_REG_BANK, PLL1_ACTRL8, 0, 0xc006);
 
 	/* Set a specific AEQ equalizer value */
 	tmp = AEQ_FRC_EQ_FORCE_VAL | AEQ_FRC_EQ_FORCE;
-	brcm_sata_phy_wr(base, AEQRX_REG_BANK_0, AEQ_FRC_EQ,
+	brcm_sata_phy_wr(port, AEQRX_REG_BANK_0, AEQ_FRC_EQ,
 			 ~(tmp | AEQ_RFZ_FRC_VAL |
 			   AEQ_FRC_EQ_VAL_MASK << AEQ_FRC_EQ_VAL_SHIFT),
 			 tmp | 32 << AEQ_FRC_EQ_VAL_SHIFT);
@@ -337,7 +326,7 @@ static int brcm_stb_sata_16nm_ssc_init(struct brcm_sata_port *port)
 		value = 0x52;
 	else
 		value = 0;
-	brcm_sata_phy_wr(base, RXPMD_REG_BANK, RXPMD_RX_CDR_CONTROL1,
+	brcm_sata_phy_wr(port, RXPMD_REG_BANK, RXPMD_RX_CDR_CONTROL1,
 			 ~RXPMD_RX_PPM_VAL_MASK, value);
 
 	/* Set proportional loop bandwith Gen1/2/3 */
@@ -352,7 +341,7 @@ static int brcm_stb_sata_16nm_ssc_init(struct brcm_sata_port *port)
 		value = 1 << RXPMD_G1_CDR_PROP_BW_SHIFT |
 			1 << RXPMD_G2_CDR_PROP_BW_SHIFT |
 			1 << RXPMD_G3_CDR_PROB_BW_SHIFT;
-	brcm_sata_phy_wr(base, RXPMD_REG_BANK, RXPMD_RX_CDR_CDR_PROP_BW, ~tmp,
+	brcm_sata_phy_wr(port, RXPMD_REG_BANK, RXPMD_RX_CDR_CDR_PROP_BW, ~tmp,
 			 value);
 
 	/* Set CDR integral loop acquisition bandwidth for Gen1/2/3 */
@@ -365,7 +354,7 @@ static int brcm_stb_sata_16nm_ssc_init(struct brcm_sata_port *port)
 			1 << RXPMD_G3_CDR_ACQ_INT_BW_SHIFT;
 	else
 		value = 0;
-	brcm_sata_phy_wr(base, RXPMD_REG_BANK, RXPMD_RX_CDR_CDR_ACQ_INTEG_BW,
+	brcm_sata_phy_wr(port, RXPMD_REG_BANK, RXPMD_RX_CDR_CDR_ACQ_INTEG_BW,
 			 ~tmp, value);
 
 	/* Set CDR integral loop locking bandwidth to 1 for Gen 1/2/3 */
@@ -378,7 +367,7 @@ static int brcm_stb_sata_16nm_ssc_init(struct brcm_sata_port *port)
 			1 << RXPMD_G3_CDR_LOCK_INT_BW_SHIFT;
 	else
 		value = 0;
-	brcm_sata_phy_wr(base, RXPMD_REG_BANK, RXPMD_RX_CDR_CDR_LOCK_INTEG_BW,
+	brcm_sata_phy_wr(port, RXPMD_REG_BANK, RXPMD_RX_CDR_CDR_LOCK_INTEG_BW,
 			 ~tmp, value);
 
 	/* Set no guard band and clamp CDR */
@@ -387,11 +376,11 @@ static int brcm_stb_sata_16nm_ssc_init(struct brcm_sata_port *port)
 		value = 0x51;
 	else
 		value = 0;
-	brcm_sata_phy_wr(base, RXPMD_REG_BANK, RXPMD_RX_FREQ_MON_CONTROL1,
+	brcm_sata_phy_wr(port, RXPMD_REG_BANK, RXPMD_RX_FREQ_MON_CONTROL1,
 			 ~tmp, RXPMD_MON_CORRECT_EN | value);
 
 	/* Turn on/off SSC */
-	brcm_sata_phy_wr(base, TX_REG_BANK, TX_ACTRL5, ~TX_ACTRL5_SSC_EN,
+	brcm_sata_phy_wr(port, TX_REG_BANK, TX_ACTRL5, ~TX_ACTRL5_SSC_EN,
 			 port->ssc_en ? TX_ACTRL5_SSC_EN : 0);
 
 	return 0;
@@ -411,7 +400,6 @@ static int brcm_ns2_sata_init(struct brcm_sata_port *port)
 {
 	int try;
 	unsigned int val;
-	void __iomem *base = brcm_sata_pcb_base(port);
 	void __iomem *ctrl_base = brcm_sata_ctrl_base(port);
 	struct device *dev = port->phy_priv->dev;
 
@@ -421,24 +409,24 @@ static int brcm_ns2_sata_init(struct brcm_sata_port *port)
 	val |= (0x4 << OOB_CTRL1_BURST_MIN_SHIFT);
 	val |= (0x9 << OOB_CTRL1_WAKE_IDLE_MAX_SHIFT);
 	val |= (0x3 << OOB_CTRL1_WAKE_IDLE_MIN_SHIFT);
-	brcm_sata_phy_wr(base, OOB_REG_BANK, OOB_CTRL1, 0x0, val);
+	brcm_sata_phy_wr(port, OOB_REG_BANK, OOB_CTRL1, 0x0, val);
 	val = 0x0;
 	val |= (0x1b << OOB_CTRL2_RESET_IDLE_MAX_SHIFT);
 	val |= (0x2 << OOB_CTRL2_BURST_CNT_SHIFT);
 	val |= (0x9 << OOB_CTRL2_RESET_IDLE_MIN_SHIFT);
-	brcm_sata_phy_wr(base, OOB_REG_BANK, OOB_CTRL2, 0x0, val);
+	brcm_sata_phy_wr(port, OOB_REG_BANK, OOB_CTRL2, 0x0, val);
 
 	/* Configure PHY PLL register bank 1 */
 	val = NS2_PLL1_ACTRL2_MAGIC;
-	brcm_sata_phy_wr(base, PLL1_REG_BANK, PLL1_ACTRL2, 0x0, val);
+	brcm_sata_phy_wr(port, PLL1_REG_BANK, PLL1_ACTRL2, 0x0, val);
 	val = NS2_PLL1_ACTRL3_MAGIC;
-	brcm_sata_phy_wr(base, PLL1_REG_BANK, PLL1_ACTRL3, 0x0, val);
+	brcm_sata_phy_wr(port, PLL1_REG_BANK, PLL1_ACTRL3, 0x0, val);
 	val = NS2_PLL1_ACTRL4_MAGIC;
-	brcm_sata_phy_wr(base, PLL1_REG_BANK, PLL1_ACTRL4, 0x0, val);
+	brcm_sata_phy_wr(port, PLL1_REG_BANK, PLL1_ACTRL4, 0x0, val);
 
 	/* Configure PHY BLOCK0 register bank */
 	/* Set oob_clk_sel to refclk/2 */
-	brcm_sata_phy_wr(base, BLOCK0_REG_BANK, BLOCK0_SPARE,
+	brcm_sata_phy_wr(port, BLOCK0_REG_BANK, BLOCK0_SPARE,
 			 ~BLOCK0_SPARE_OOB_CLK_SEL_MASK,
 			 BLOCK0_SPARE_OOB_CLK_SEL_REFBY2);
 
@@ -451,7 +439,7 @@ static int brcm_ns2_sata_init(struct brcm_sata_port *port)
 	/* Wait for PHY PLL lock by polling pll_lock bit */
 	try = 50;
 	while (try) {
-		val = brcm_sata_phy_rd(base, BLOCK0_REG_BANK,
+		val = brcm_sata_phy_rd(port, BLOCK0_REG_BANK,
 					BLOCK0_XGXSSTATUS);
 		if (val & BLOCK0_XGXSSTATUS_PLL_LOCK)
 			break;
@@ -471,9 +459,7 @@ static int brcm_ns2_sata_init(struct brcm_sata_port *port)
 
 static int brcm_nsp_sata_init(struct brcm_sata_port *port)
 {
-	struct brcm_sata_phy *priv = port->phy_priv;
 	struct device *dev = port->phy_priv->dev;
-	void __iomem *base = priv->phy_base;
 	unsigned int oob_bank;
 	unsigned int val, try;
 
@@ -490,36 +476,36 @@ static int brcm_nsp_sata_init(struct brcm_sata_port *port)
 	val |= (0x06 << OOB_CTRL1_BURST_MIN_SHIFT);
 	val |= (0x0f << OOB_CTRL1_WAKE_IDLE_MAX_SHIFT);
 	val |= (0x06 << OOB_CTRL1_WAKE_IDLE_MIN_SHIFT);
-	brcm_sata_phy_wr(base, oob_bank, OOB_CTRL1, 0x0, val);
+	brcm_sata_phy_wr(port, oob_bank, OOB_CTRL1, 0x0, val);
 
 	val = 0x0;
 	val |= (0x2e << OOB_CTRL2_RESET_IDLE_MAX_SHIFT);
 	val |= (0x02 << OOB_CTRL2_BURST_CNT_SHIFT);
 	val |= (0x16 << OOB_CTRL2_RESET_IDLE_MIN_SHIFT);
-	brcm_sata_phy_wr(base, oob_bank, OOB_CTRL2, 0x0, val);
+	brcm_sata_phy_wr(port, oob_bank, OOB_CTRL2, 0x0, val);
 
 
-	brcm_sata_phy_wr(base, PLL_REG_BANK_0, PLL_ACTRL2,
+	brcm_sata_phy_wr(port, PLL_REG_BANK_0, PLL_ACTRL2,
 		~(PLL_ACTRL2_SELDIV_MASK << PLL_ACTRL2_SELDIV_SHIFT),
 		0x0c << PLL_ACTRL2_SELDIV_SHIFT);
 
-	brcm_sata_phy_wr(base, PLL_REG_BANK_0, PLL_CAP_CONTROL,
+	brcm_sata_phy_wr(port, PLL_REG_BANK_0, PLL_CAP_CONTROL,
 						0xff0, 0x4f0);
 
 	val = PLLCONTROL_0_FREQ_DET_RESTART | PLLCONTROL_0_FREQ_MONITOR;
-	brcm_sata_phy_wr(base, PLL_REG_BANK_0, PLL_REG_BANK_0_PLLCONTROL_0,
+	brcm_sata_phy_wr(port, PLL_REG_BANK_0, PLL_REG_BANK_0_PLLCONTROL_0,
 								~val, val);
 	val = PLLCONTROL_0_SEQ_START;
-	brcm_sata_phy_wr(base, PLL_REG_BANK_0, PLL_REG_BANK_0_PLLCONTROL_0,
+	brcm_sata_phy_wr(port, PLL_REG_BANK_0, PLL_REG_BANK_0_PLLCONTROL_0,
 								~val, 0);
 	mdelay(10);
-	brcm_sata_phy_wr(base, PLL_REG_BANK_0, PLL_REG_BANK_0_PLLCONTROL_0,
+	brcm_sata_phy_wr(port, PLL_REG_BANK_0, PLL_REG_BANK_0_PLLCONTROL_0,
 								~val, val);
 
 	/* Wait for pll_seq_done bit */
 	try = 50;
 	while (--try) {
-		val = brcm_sata_phy_rd(base, BLOCK0_REG_BANK,
+		val = brcm_sata_phy_rd(port, BLOCK0_REG_BANK,
 					BLOCK0_XGXSSTATUS);
 		if (val & BLOCK0_XGXSSTATUS_PLL_LOCK)
 			break;
@@ -546,27 +532,25 @@ static int brcm_nsp_sata_init(struct brcm_sata_port *port)
 
 static int brcm_sr_sata_init(struct brcm_sata_port *port)
 {
-	struct brcm_sata_phy *priv = port->phy_priv;
 	struct device *dev = port->phy_priv->dev;
-	void __iomem *base = priv->phy_base;
 	unsigned int val, try;
 
 	/* Configure PHY PLL register bank 1 */
 	val = SR_PLL1_ACTRL2_MAGIC;
-	brcm_sata_phy_wr(base, PLL1_REG_BANK, PLL1_ACTRL2, 0x0, val);
+	brcm_sata_phy_wr(port, PLL1_REG_BANK, PLL1_ACTRL2, 0x0, val);
 	val = SR_PLL1_ACTRL3_MAGIC;
-	brcm_sata_phy_wr(base, PLL1_REG_BANK, PLL1_ACTRL3, 0x0, val);
+	brcm_sata_phy_wr(port, PLL1_REG_BANK, PLL1_ACTRL3, 0x0, val);
 	val = SR_PLL1_ACTRL4_MAGIC;
-	brcm_sata_phy_wr(base, PLL1_REG_BANK, PLL1_ACTRL4, 0x0, val);
+	brcm_sata_phy_wr(port, PLL1_REG_BANK, PLL1_ACTRL4, 0x0, val);
 
 	/* Configure PHY PLL register bank 0 */
 	val = SR_PLL0_ACTRL6_MAGIC;
-	brcm_sata_phy_wr(base, PLL_REG_BANK_0, PLL_ACTRL6, 0x0, val);
+	brcm_sata_phy_wr(port, PLL_REG_BANK_0, PLL_ACTRL6, 0x0, val);
 
 	/* Wait for PHY PLL lock by polling pll_lock bit */
 	try = 50;
 	do {
-		val = brcm_sata_phy_rd(base, BLOCK0_REG_BANK,
+		val = brcm_sata_phy_rd(port, BLOCK0_REG_BANK,
 					BLOCK0_XGXSSTATUS);
 		if (val & BLOCK0_XGXSSTATUS_PLL_LOCK)
 			break;
@@ -581,7 +565,7 @@ static int brcm_sr_sata_init(struct brcm_sata_port *port)
 	}
 
 	/* Invert Tx polarity */
-	brcm_sata_phy_wr(base, TX_REG_BANK, TX_ACTRL0,
+	brcm_sata_phy_wr(port, TX_REG_BANK, TX_ACTRL0,
 			 ~TX_ACTRL0_TXPOL_FLIP, TX_ACTRL0_TXPOL_FLIP);
 
 	/* Configure OOB control to handle 100MHz reference clock */
@@ -589,52 +573,51 @@ static int brcm_sr_sata_init(struct brcm_sata_port *port)
 		(0x4 << OOB_CTRL1_BURST_MIN_SHIFT) |
 		(0x8 << OOB_CTRL1_WAKE_IDLE_MAX_SHIFT) |
 		(0x3 << OOB_CTRL1_WAKE_IDLE_MIN_SHIFT));
-	brcm_sata_phy_wr(base, OOB_REG_BANK, OOB_CTRL1, 0x0, val);
+	brcm_sata_phy_wr(port, OOB_REG_BANK, OOB_CTRL1, 0x0, val);
 	val = ((0x1b << OOB_CTRL2_RESET_IDLE_MAX_SHIFT) |
 		(0x2 << OOB_CTRL2_BURST_CNT_SHIFT) |
 		(0x9 << OOB_CTRL2_RESET_IDLE_MIN_SHIFT));
-	brcm_sata_phy_wr(base, OOB_REG_BANK, OOB_CTRL2, 0x0, val);
+	brcm_sata_phy_wr(port, OOB_REG_BANK, OOB_CTRL2, 0x0, val);
 
 	return 0;
 }
 
 static int brcm_dsl_sata_init(struct brcm_sata_port *port)
 {
-	void __iomem *base = brcm_sata_pcb_base(port);
 	struct device *dev = port->phy_priv->dev;
 	unsigned int try;
 	u32 tmp;
 
-	brcm_sata_phy_wr(base, PLL1_REG_BANK, PLL1_ACTRL7, 0, 0x873);
+	brcm_sata_phy_wr(port, PLL1_REG_BANK, PLL1_ACTRL7, 0, 0x873);
 
-	brcm_sata_phy_wr(base, PLL1_REG_BANK, PLL1_ACTRL6, 0, 0xc000);
+	brcm_sata_phy_wr(port, PLL1_REG_BANK, PLL1_ACTRL6, 0, 0xc000);
 
-	brcm_sata_phy_wr(base, PLL_REG_BANK_0, PLL_REG_BANK_0_PLLCONTROL_0,
+	brcm_sata_phy_wr(port, PLL_REG_BANK_0, PLL_REG_BANK_0_PLLCONTROL_0,
 			 0, 0x3089);
 	usleep_range(1000, 2000);
 
-	brcm_sata_phy_wr(base, PLL_REG_BANK_0, PLL_REG_BANK_0_PLLCONTROL_0,
+	brcm_sata_phy_wr(port, PLL_REG_BANK_0, PLL_REG_BANK_0_PLLCONTROL_0,
 			 0, 0x3088);
 	usleep_range(1000, 2000);
 
-	brcm_sata_phy_wr(base, AEQRX_REG_BANK_1, AEQRX_SLCAL0_CTRL0,
+	brcm_sata_phy_wr(port, AEQRX_REG_BANK_1, AEQRX_SLCAL0_CTRL0,
 			 0, 0x3000);
 
-	brcm_sata_phy_wr(base, AEQRX_REG_BANK_1, AEQRX_SLCAL1_CTRL0,
+	brcm_sata_phy_wr(port, AEQRX_REG_BANK_1, AEQRX_SLCAL1_CTRL0,
 			 0, 0x3000);
 	usleep_range(1000, 2000);
 
-	brcm_sata_phy_wr(base, PLL_REG_BANK_0, PLL_CAP_CHARGE_TIME, 0, 0x32);
+	brcm_sata_phy_wr(port, PLL_REG_BANK_0, PLL_CAP_CHARGE_TIME, 0, 0x32);
 
-	brcm_sata_phy_wr(base, PLL_REG_BANK_0, PLL_VCO_CAL_THRESH, 0, 0xa);
+	brcm_sata_phy_wr(port, PLL_REG_BANK_0, PLL_VCO_CAL_THRESH, 0, 0xa);
 
-	brcm_sata_phy_wr(base, PLL_REG_BANK_0, PLL_FREQ_DET_TIME, 0, 0x64);
+	brcm_sata_phy_wr(port, PLL_REG_BANK_0, PLL_FREQ_DET_TIME, 0, 0x64);
 	usleep_range(1000, 2000);
 
 	/* Acquire PLL lock */
 	try = 50;
 	while (try) {
-		tmp = brcm_sata_phy_rd(base, BLOCK0_REG_BANK,
+		tmp = brcm_sata_phy_rd(port, BLOCK0_REG_BANK,
 				       BLOCK0_XGXSSTATUS);
 		if (tmp & BLOCK0_XGXSSTATUS_PLL_LOCK)
 			break;
@@ -687,10 +670,9 @@ static int brcm_sata_phy_init(struct phy *phy)
 
 static void brcm_stb_sata_calibrate(struct brcm_sata_port *port)
 {
-	void __iomem *base = brcm_sata_pcb_base(port);
 	u32 tmp = BIT(8);
 
-	brcm_sata_phy_wr(base, RXPMD_REG_BANK, RXPMD_RX_FREQ_MON_CONTROL1,
+	brcm_sata_phy_wr(port, RXPMD_REG_BANK, RXPMD_RX_FREQ_MON_CONTROL1,
 			 ~tmp, tmp);
 }
 

