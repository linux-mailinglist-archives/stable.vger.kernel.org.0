Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F3A4328AD9
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:24:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239136AbhCASX6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:23:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:38298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235324AbhCASSp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:18:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C2A37650B8;
        Mon,  1 Mar 2021 17:41:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620491;
        bh=g6fIdg7iY8iZh6WEe5CSyxZoChMnW0B1HUH3sgjze0o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DX+FS5n8kTWU7QmJzR0xpeWHqrsXd11vWIghi6lea4VOO0rHhscKoTteulWIWu+y6
         FIgyVXl7AtgTsJShiU16Gitwsl4+hlaViXj9AaNMWk1+sFu3RwwQ3RsJKjJCWBlLwQ
         /mi/YWwptkSdUr+fvF4y8NOZb3+IPfH7OWKdbEDU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Steen Hegelund <steen.hegelund@microchip.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 133/775] net: phy: mscc: adding LCPLL reset to VSC8514
Date:   Mon,  1 Mar 2021 17:05:01 +0100
Message-Id: <20210301161208.238329398@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bjarni Jonasson <bjarni.jonasson@microchip.com>

[ Upstream commit 3cc2c646be0b22037f31c958e96c0544a073d108 ]

At Power-On Reset, transients may cause the LCPLL to lock onto a
clock that is momentarily unstable. This is normally seen in QSGMII
setups where the higher speed 6G SerDes is being used.
This patch adds an initial LCPLL Reset to the PHY (first instance)
to avoid this issue.

Fixes: e4f9ba642f0b ("net: phy: mscc: add support for VSC8514 PHY.")
Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
Signed-off-by: Bjarni Jonasson <bjarni.jonasson@microchip.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/mscc/mscc.h      |   8 +
 drivers/net/phy/mscc/mscc_main.c | 350 ++++++++++++++++++++-----------
 2 files changed, 236 insertions(+), 122 deletions(-)

diff --git a/drivers/net/phy/mscc/mscc.h b/drivers/net/phy/mscc/mscc.h
index 9481bce94c2ed..c2023f93c0b24 100644
--- a/drivers/net/phy/mscc/mscc.h
+++ b/drivers/net/phy/mscc/mscc.h
@@ -102,6 +102,7 @@ enum rgmii_clock_delay {
 #define PHY_MCB_S6G_READ		  BIT(30)
 
 #define PHY_S6G_PLL5G_CFG0		  0x06
+#define PHY_S6G_PLL5G_CFG2		  0x08
 #define PHY_S6G_LCPLL_CFG		  0x11
 #define PHY_S6G_PLL_CFG			  0x2b
 #define PHY_S6G_COMMON_CFG		  0x2c
@@ -121,6 +122,9 @@ enum rgmii_clock_delay {
 #define PHY_S6G_PLL_FSM_CTRL_DATA_POS	  8
 #define PHY_S6G_PLL_FSM_ENA_POS		  7
 
+#define PHY_S6G_CFG2_FSM_DIS              1
+#define PHY_S6G_CFG2_FSM_CLK_BP          23
+
 #define MSCC_EXT_PAGE_ACCESS		  31
 #define MSCC_PHY_PAGE_STANDARD		  0x0000 /* Standard registers */
 #define MSCC_PHY_PAGE_EXTENDED		  0x0001 /* Extended registers */
@@ -412,6 +416,10 @@ struct vsc8531_edge_rate_table {
 };
 #endif /* CONFIG_OF_MDIO */
 
+enum csr_target {
+	MACRO_CTRL  = 0x07,
+};
+
 #if IS_ENABLED(CONFIG_MACSEC)
 int vsc8584_macsec_init(struct phy_device *phydev);
 void vsc8584_handle_macsec_interrupt(struct phy_device *phydev);
diff --git a/drivers/net/phy/mscc/mscc_main.c b/drivers/net/phy/mscc/mscc_main.c
index 2f2157e3deab5..7830340b9cdc8 100644
--- a/drivers/net/phy/mscc/mscc_main.c
+++ b/drivers/net/phy/mscc/mscc_main.c
@@ -710,6 +710,113 @@ static int phy_base_read(struct phy_device *phydev, u32 regnum)
 	return __phy_package_read(phydev, regnum);
 }
 
+static u32 vsc85xx_csr_read(struct phy_device *phydev,
+			    enum csr_target target, u32 reg)
+{
+	unsigned long deadline;
+	u32 val, val_l, val_h;
+
+	phy_base_write(phydev, MSCC_EXT_PAGE_ACCESS, MSCC_PHY_PAGE_CSR_CNTL);
+
+	/* CSR registers are grouped under different Target IDs.
+	 * 6-bit Target_ID is split between MSCC_EXT_PAGE_CSR_CNTL_20 and
+	 * MSCC_EXT_PAGE_CSR_CNTL_19 registers.
+	 * Target_ID[5:2] maps to bits[3:0] of MSCC_EXT_PAGE_CSR_CNTL_20
+	 * and Target_ID[1:0] maps to bits[13:12] of MSCC_EXT_PAGE_CSR_CNTL_19.
+	 */
+
+	/* Setup the Target ID */
+	phy_base_write(phydev, MSCC_EXT_PAGE_CSR_CNTL_20,
+		       MSCC_PHY_CSR_CNTL_20_TARGET(target >> 2));
+
+	if ((target >> 2 == 0x1) || (target >> 2 == 0x3))
+		/* non-MACsec access */
+		target &= 0x3;
+	else
+		target = 0;
+
+	/* Trigger CSR Action - Read into the CSR's */
+	phy_base_write(phydev, MSCC_EXT_PAGE_CSR_CNTL_19,
+		       MSCC_PHY_CSR_CNTL_19_CMD | MSCC_PHY_CSR_CNTL_19_READ |
+		       MSCC_PHY_CSR_CNTL_19_REG_ADDR(reg) |
+		       MSCC_PHY_CSR_CNTL_19_TARGET(target));
+
+	/* Wait for register access*/
+	deadline = jiffies + msecs_to_jiffies(PROC_CMD_NCOMPLETED_TIMEOUT_MS);
+	do {
+		usleep_range(500, 1000);
+		val = phy_base_read(phydev, MSCC_EXT_PAGE_CSR_CNTL_19);
+	} while (time_before(jiffies, deadline) &&
+		!(val & MSCC_PHY_CSR_CNTL_19_CMD));
+
+	if (!(val & MSCC_PHY_CSR_CNTL_19_CMD))
+		return 0xffffffff;
+
+	/* Read the Least Significant Word (LSW) (17) */
+	val_l = phy_base_read(phydev, MSCC_EXT_PAGE_CSR_CNTL_17);
+
+	/* Read the Most Significant Word (MSW) (18) */
+	val_h = phy_base_read(phydev, MSCC_EXT_PAGE_CSR_CNTL_18);
+
+	phy_base_write(phydev, MSCC_EXT_PAGE_ACCESS,
+		       MSCC_PHY_PAGE_STANDARD);
+
+	return (val_h << 16) | val_l;
+}
+
+static int vsc85xx_csr_write(struct phy_device *phydev,
+			     enum csr_target target, u32 reg, u32 val)
+{
+	unsigned long deadline;
+
+	phy_base_write(phydev, MSCC_EXT_PAGE_ACCESS, MSCC_PHY_PAGE_CSR_CNTL);
+
+	/* CSR registers are grouped under different Target IDs.
+	 * 6-bit Target_ID is split between MSCC_EXT_PAGE_CSR_CNTL_20 and
+	 * MSCC_EXT_PAGE_CSR_CNTL_19 registers.
+	 * Target_ID[5:2] maps to bits[3:0] of MSCC_EXT_PAGE_CSR_CNTL_20
+	 * and Target_ID[1:0] maps to bits[13:12] of MSCC_EXT_PAGE_CSR_CNTL_19.
+	 */
+
+	/* Setup the Target ID */
+	phy_base_write(phydev, MSCC_EXT_PAGE_CSR_CNTL_20,
+		       MSCC_PHY_CSR_CNTL_20_TARGET(target >> 2));
+
+	/* Write the Least Significant Word (LSW) (17) */
+	phy_base_write(phydev, MSCC_EXT_PAGE_CSR_CNTL_17, (u16)val);
+
+	/* Write the Most Significant Word (MSW) (18) */
+	phy_base_write(phydev, MSCC_EXT_PAGE_CSR_CNTL_18, (u16)(val >> 16));
+
+	if ((target >> 2 == 0x1) || (target >> 2 == 0x3))
+		/* non-MACsec access */
+		target &= 0x3;
+	else
+		target = 0;
+
+	/* Trigger CSR Action - Write into the CSR's */
+	phy_base_write(phydev, MSCC_EXT_PAGE_CSR_CNTL_19,
+		       MSCC_PHY_CSR_CNTL_19_CMD |
+		       MSCC_PHY_CSR_CNTL_19_REG_ADDR(reg) |
+		       MSCC_PHY_CSR_CNTL_19_TARGET(target));
+
+	/* Wait for register access */
+	deadline = jiffies + msecs_to_jiffies(PROC_CMD_NCOMPLETED_TIMEOUT_MS);
+	do {
+		usleep_range(500, 1000);
+		val = phy_base_read(phydev, MSCC_EXT_PAGE_CSR_CNTL_19);
+	} while (time_before(jiffies, deadline) &&
+		 !(val & MSCC_PHY_CSR_CNTL_19_CMD));
+
+	if (!(val & MSCC_PHY_CSR_CNTL_19_CMD))
+		return -ETIMEDOUT;
+
+	phy_base_write(phydev, MSCC_EXT_PAGE_ACCESS,
+		       MSCC_PHY_PAGE_STANDARD);
+
+	return 0;
+}
+
 /* bus->mdio_lock should be locked when using this function */
 static void vsc8584_csr_write(struct phy_device *phydev, u16 addr, u32 val)
 {
@@ -1131,6 +1238,92 @@ out:
 	return ret;
 }
 
+/* Access LCPLL Cfg_2 */
+static void vsc8584_pll5g_cfg2_wr(struct phy_device *phydev,
+				  bool disable_fsm)
+{
+	u32 rd_dat;
+
+	rd_dat = vsc85xx_csr_read(phydev, MACRO_CTRL, PHY_S6G_PLL5G_CFG2);
+	rd_dat &= ~BIT(PHY_S6G_CFG2_FSM_DIS);
+	rd_dat |= (disable_fsm << PHY_S6G_CFG2_FSM_DIS);
+	vsc85xx_csr_write(phydev, MACRO_CTRL, PHY_S6G_PLL5G_CFG2, rd_dat);
+}
+
+/* trigger a read to the spcified MCB */
+static int vsc8584_mcb_rd_trig(struct phy_device *phydev,
+			       u32 mcb_reg_addr, u8 mcb_slave_num)
+{
+	u32 rd_dat = 0;
+
+	/* read MCB */
+	vsc85xx_csr_write(phydev, MACRO_CTRL, mcb_reg_addr,
+			  (0x40000000 | (1L << mcb_slave_num)));
+
+	return read_poll_timeout(vsc85xx_csr_read, rd_dat,
+				 !(rd_dat & 0x40000000),
+				 4000, 200000, 0,
+				 phydev, MACRO_CTRL, mcb_reg_addr);
+}
+
+/* trigger a write to the spcified MCB */
+static int vsc8584_mcb_wr_trig(struct phy_device *phydev,
+			       u32 mcb_reg_addr,
+			       u8 mcb_slave_num)
+{
+	u32 rd_dat = 0;
+
+	/* write back MCB */
+	vsc85xx_csr_write(phydev, MACRO_CTRL, mcb_reg_addr,
+			  (0x80000000 | (1L << mcb_slave_num)));
+
+	return read_poll_timeout(vsc85xx_csr_read, rd_dat,
+				 !(rd_dat & 0x80000000),
+				 4000, 200000, 0,
+				 phydev, MACRO_CTRL, mcb_reg_addr);
+}
+
+/* Sequence to Reset LCPLL for the VIPER and ELISE PHY */
+static int vsc8584_pll5g_reset(struct phy_device *phydev)
+{
+	bool dis_fsm;
+	int ret = 0;
+
+	ret = vsc8584_mcb_rd_trig(phydev, 0x11, 0);
+	if (ret < 0)
+		goto done;
+	dis_fsm = 1;
+
+	/* Reset LCPLL */
+	vsc8584_pll5g_cfg2_wr(phydev, dis_fsm);
+
+	/* write back LCPLL MCB */
+	ret = vsc8584_mcb_wr_trig(phydev, 0x11, 0);
+	if (ret < 0)
+		goto done;
+
+	/* 10 mSec sleep while LCPLL is hold in reset */
+	usleep_range(10000, 20000);
+
+	/* read LCPLL MCB into CSRs */
+	ret = vsc8584_mcb_rd_trig(phydev, 0x11, 0);
+	if (ret < 0)
+		goto done;
+	dis_fsm = 0;
+
+	/* Release the Reset of LCPLL */
+	vsc8584_pll5g_cfg2_wr(phydev, dis_fsm);
+
+	/* write back LCPLL MCB */
+	ret = vsc8584_mcb_wr_trig(phydev, 0x11, 0);
+	if (ret < 0)
+		goto done;
+
+	usleep_range(110000, 200000);
+done:
+	return ret;
+}
+
 /* bus->mdio_lock should be locked when using this function */
 static int vsc8584_config_pre_init(struct phy_device *phydev)
 {
@@ -1569,8 +1762,16 @@ static int vsc8514_config_pre_init(struct phy_device *phydev)
 		{0x16b2, 0x00007000},
 		{0x16b4, 0x00000814},
 	};
+	struct device *dev = &phydev->mdio.dev;
 	unsigned int i;
 	u16 reg;
+	int ret;
+
+	ret = vsc8584_pll5g_reset(phydev);
+	if (ret < 0) {
+		dev_err(dev, "failed LCPLL reset, ret: %d\n", ret);
+		return ret;
+	}
 
 	phy_base_write(phydev, MSCC_EXT_PAGE_ACCESS, MSCC_PHY_PAGE_STANDARD);
 
@@ -1605,101 +1806,6 @@ static int vsc8514_config_pre_init(struct phy_device *phydev)
 	return 0;
 }
 
-static u32 vsc85xx_csr_ctrl_phy_read(struct phy_device *phydev,
-				     u32 target, u32 reg)
-{
-	unsigned long deadline;
-	u32 val, val_l, val_h;
-
-	phy_base_write(phydev, MSCC_EXT_PAGE_ACCESS, MSCC_PHY_PAGE_CSR_CNTL);
-
-	/* CSR registers are grouped under different Target IDs.
-	 * 6-bit Target_ID is split between MSCC_EXT_PAGE_CSR_CNTL_20 and
-	 * MSCC_EXT_PAGE_CSR_CNTL_19 registers.
-	 * Target_ID[5:2] maps to bits[3:0] of MSCC_EXT_PAGE_CSR_CNTL_20
-	 * and Target_ID[1:0] maps to bits[13:12] of MSCC_EXT_PAGE_CSR_CNTL_19.
-	 */
-
-	/* Setup the Target ID */
-	phy_base_write(phydev, MSCC_EXT_PAGE_CSR_CNTL_20,
-		       MSCC_PHY_CSR_CNTL_20_TARGET(target >> 2));
-
-	/* Trigger CSR Action - Read into the CSR's */
-	phy_base_write(phydev, MSCC_EXT_PAGE_CSR_CNTL_19,
-		       MSCC_PHY_CSR_CNTL_19_CMD | MSCC_PHY_CSR_CNTL_19_READ |
-		       MSCC_PHY_CSR_CNTL_19_REG_ADDR(reg) |
-		       MSCC_PHY_CSR_CNTL_19_TARGET(target & 0x3));
-
-	/* Wait for register access*/
-	deadline = jiffies + msecs_to_jiffies(PROC_CMD_NCOMPLETED_TIMEOUT_MS);
-	do {
-		usleep_range(500, 1000);
-		val = phy_base_read(phydev, MSCC_EXT_PAGE_CSR_CNTL_19);
-	} while (time_before(jiffies, deadline) &&
-		!(val & MSCC_PHY_CSR_CNTL_19_CMD));
-
-	if (!(val & MSCC_PHY_CSR_CNTL_19_CMD))
-		return 0xffffffff;
-
-	/* Read the Least Significant Word (LSW) (17) */
-	val_l = phy_base_read(phydev, MSCC_EXT_PAGE_CSR_CNTL_17);
-
-	/* Read the Most Significant Word (MSW) (18) */
-	val_h = phy_base_read(phydev, MSCC_EXT_PAGE_CSR_CNTL_18);
-
-	phy_base_write(phydev, MSCC_EXT_PAGE_ACCESS,
-		       MSCC_PHY_PAGE_STANDARD);
-
-	return (val_h << 16) | val_l;
-}
-
-static int vsc85xx_csr_ctrl_phy_write(struct phy_device *phydev,
-				      u32 target, u32 reg, u32 val)
-{
-	unsigned long deadline;
-
-	phy_base_write(phydev, MSCC_EXT_PAGE_ACCESS, MSCC_PHY_PAGE_CSR_CNTL);
-
-	/* CSR registers are grouped under different Target IDs.
-	 * 6-bit Target_ID is split between MSCC_EXT_PAGE_CSR_CNTL_20 and
-	 * MSCC_EXT_PAGE_CSR_CNTL_19 registers.
-	 * Target_ID[5:2] maps to bits[3:0] of MSCC_EXT_PAGE_CSR_CNTL_20
-	 * and Target_ID[1:0] maps to bits[13:12] of MSCC_EXT_PAGE_CSR_CNTL_19.
-	 */
-
-	/* Setup the Target ID */
-	phy_base_write(phydev, MSCC_EXT_PAGE_CSR_CNTL_20,
-		       MSCC_PHY_CSR_CNTL_20_TARGET(target >> 2));
-
-	/* Write the Least Significant Word (LSW) (17) */
-	phy_base_write(phydev, MSCC_EXT_PAGE_CSR_CNTL_17, (u16)val);
-
-	/* Write the Most Significant Word (MSW) (18) */
-	phy_base_write(phydev, MSCC_EXT_PAGE_CSR_CNTL_18, (u16)(val >> 16));
-
-	/* Trigger CSR Action - Write into the CSR's */
-	phy_base_write(phydev, MSCC_EXT_PAGE_CSR_CNTL_19,
-		       MSCC_PHY_CSR_CNTL_19_CMD |
-		       MSCC_PHY_CSR_CNTL_19_REG_ADDR(reg) |
-		       MSCC_PHY_CSR_CNTL_19_TARGET(target & 0x3));
-
-	/* Wait for register access */
-	deadline = jiffies + msecs_to_jiffies(PROC_CMD_NCOMPLETED_TIMEOUT_MS);
-	do {
-		usleep_range(500, 1000);
-		val = phy_base_read(phydev, MSCC_EXT_PAGE_CSR_CNTL_19);
-	} while (time_before(jiffies, deadline) &&
-		 !(val & MSCC_PHY_CSR_CNTL_19_CMD));
-
-	if (!(val & MSCC_PHY_CSR_CNTL_19_CMD))
-		return -ETIMEDOUT;
-
-	phy_base_write(phydev, MSCC_EXT_PAGE_ACCESS,
-		       MSCC_PHY_PAGE_STANDARD);
-
-	return 0;
-}
-
 static int __phy_write_mcb_s6g(struct phy_device *phydev, u32 reg, u8 mcb,
 			       u32 op)
 {
@@ -1707,15 +1813,15 @@ static int __phy_write_mcb_s6g(struct phy_device *phydev, u32 reg, u8 mcb,
 	u32 val;
 	int ret;
 
-	ret = vsc85xx_csr_ctrl_phy_write(phydev, PHY_MCB_TARGET, reg,
-					 op | (1 << mcb));
+	ret = vsc85xx_csr_write(phydev, PHY_MCB_TARGET, reg,
+				op | (1 << mcb));
 	if (ret)
 		return -EINVAL;
 
 	deadline = jiffies + msecs_to_jiffies(PROC_CMD_NCOMPLETED_TIMEOUT_MS);
 	do {
 		usleep_range(500, 1000);
-		val = vsc85xx_csr_ctrl_phy_read(phydev, PHY_MCB_TARGET, reg);
+		val = vsc85xx_csr_read(phydev, PHY_MCB_TARGET, reg);
 
 		if (val == 0xffffffff)
 			return -EIO;
@@ -1796,41 +1902,41 @@ static int vsc8514_config_init(struct phy_device *phydev)
 	/* lcpll mcb */
 	phy_update_mcb_s6g(phydev, PHY_S6G_LCPLL_CFG, 0);
 	/* pll5gcfg0 */
-	ret = vsc85xx_csr_ctrl_phy_write(phydev, PHY_MCB_TARGET,
-					 PHY_S6G_PLL5G_CFG0, 0x7036f145);
+	ret = vsc85xx_csr_write(phydev, PHY_MCB_TARGET,
+				PHY_S6G_PLL5G_CFG0, 0x7036f145);
 	if (ret)
 		goto err;
 
 	phy_commit_mcb_s6g(phydev, PHY_S6G_LCPLL_CFG, 0);
 	/* pllcfg */
-	ret = vsc85xx_csr_ctrl_phy_write(phydev, PHY_MCB_TARGET,
-					 PHY_S6G_PLL_CFG,
-					 (3 << PHY_S6G_PLL_ENA_OFFS_POS) |
-					 (120 << PHY_S6G_PLL_FSM_CTRL_DATA_POS)
-					 | (0 << PHY_S6G_PLL_FSM_ENA_POS));
+	ret = vsc85xx_csr_write(phydev, PHY_MCB_TARGET,
+				PHY_S6G_PLL_CFG,
+				(3 << PHY_S6G_PLL_ENA_OFFS_POS) |
+				(120 << PHY_S6G_PLL_FSM_CTRL_DATA_POS)
+				| (0 << PHY_S6G_PLL_FSM_ENA_POS));
 	if (ret)
 		goto err;
 
 	/* commoncfg */
-	ret = vsc85xx_csr_ctrl_phy_write(phydev, PHY_MCB_TARGET,
-					 PHY_S6G_COMMON_CFG,
-					 (0 << PHY_S6G_SYS_RST_POS) |
-					 (0 << PHY_S6G_ENA_LANE_POS) |
-					 (0 << PHY_S6G_ENA_LOOP_POS) |
-					 (0 << PHY_S6G_QRATE_POS) |
-					 (3 << PHY_S6G_IF_MODE_POS));
+	ret = vsc85xx_csr_write(phydev, PHY_MCB_TARGET,
+				PHY_S6G_COMMON_CFG,
+				(0 << PHY_S6G_SYS_RST_POS) |
+				(0 << PHY_S6G_ENA_LANE_POS) |
+				(0 << PHY_S6G_ENA_LOOP_POS) |
+				(0 << PHY_S6G_QRATE_POS) |
+				(3 << PHY_S6G_IF_MODE_POS));
 	if (ret)
 		goto err;
 
 	/* misccfg */
-	ret = vsc85xx_csr_ctrl_phy_write(phydev, PHY_MCB_TARGET,
-					 PHY_S6G_MISC_CFG, 1);
+	ret = vsc85xx_csr_write(phydev, PHY_MCB_TARGET,
+				PHY_S6G_MISC_CFG, 1);
 	if (ret)
 		goto err;
 
 	/* gpcfg */
-	ret = vsc85xx_csr_ctrl_phy_write(phydev, PHY_MCB_TARGET,
-					 PHY_S6G_GPC_CFG, 768);
+	ret = vsc85xx_csr_write(phydev, PHY_MCB_TARGET,
+				PHY_S6G_GPC_CFG, 768);
 	if (ret)
 		goto err;
 
@@ -1841,8 +1947,8 @@ static int vsc8514_config_init(struct phy_device *phydev)
 		usleep_range(500, 1000);
 		phy_update_mcb_s6g(phydev, PHY_MCB_S6G_CFG,
 				   0); /* read 6G MCB into CSRs */
-		reg = vsc85xx_csr_ctrl_phy_read(phydev, PHY_MCB_TARGET,
-						PHY_S6G_PLL_STATUS);
+		reg = vsc85xx_csr_read(phydev, PHY_MCB_TARGET,
+				       PHY_S6G_PLL_STATUS);
 		if (reg == 0xffffffff) {
 			phy_unlock_mdio_bus(phydev);
 			return -EIO;
@@ -1856,8 +1962,8 @@ static int vsc8514_config_init(struct phy_device *phydev)
 	}
 
 	/* misccfg */
-	ret = vsc85xx_csr_ctrl_phy_write(phydev, PHY_MCB_TARGET,
-					 PHY_S6G_MISC_CFG, 0);
+	ret = vsc85xx_csr_write(phydev, PHY_MCB_TARGET,
+				PHY_S6G_MISC_CFG, 0);
 	if (ret)
 		goto err;
 
@@ -1868,8 +1974,8 @@ static int vsc8514_config_init(struct phy_device *phydev)
 		usleep_range(500, 1000);
 		phy_update_mcb_s6g(phydev, PHY_MCB_S6G_CFG,
 				   0); /* read 6G MCB into CSRs */
-		reg = vsc85xx_csr_ctrl_phy_read(phydev, PHY_MCB_TARGET,
-						PHY_S6G_IB_STATUS0);
+		reg = vsc85xx_csr_read(phydev, PHY_MCB_TARGET,
+				       PHY_S6G_IB_STATUS0);
 		if (reg == 0xffffffff) {
 			phy_unlock_mdio_bus(phydev);
 			return -EIO;
-- 
2.27.0



