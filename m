Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3C0D328B78
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:37:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239980AbhCASfM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:35:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:43174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240002AbhCAS2S (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:28:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 957A5652FE;
        Mon,  1 Mar 2021 17:41:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620494;
        bh=eoAtjGF7pJNMzPVW4rJxiiKI1VjinCxn8hd8TmjdIr4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=umZY6+mjbIm1BFBMwaBqWO7p65LbNnGthRUgmib3cT4AMn0LkSg/9eOoVh86p/3Vc
         yA4I8wsHfzwltlkKSU8hGYMs3Xou+6Z1ont6VDkU3JVan5uIxq61TGwYQHHBdJPq37
         An7buUEnTtpM1OzBJiVpNQ04NF083cvI8MwHJUVc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Steen Hegelund <steen.hegelund@microchip.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 166/775] net: phy: mscc: improved serdes calibration applied to VSC8514
Date:   Mon,  1 Mar 2021 17:05:34 +0100
Message-Id: <20210301161209.843826527@linuxfoundation.org>
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

[ Upstream commit 85e97f0b984eb36cba0ecaf87c66a9f7445d73dc ]

The current IB serdes calibration algorithm (performed by the onboard 8051)
has proven to be unstable for the VSC8514 QSGMII phy.
A new algorithm has been developed based on
'Frequency-offset Jittered-Injection' or 'FoJi' method which solves
all known issues.  This patch disables the 8051 algorithm and
replaces it with the new FoJi algorithm.
The calibration is now performed in a new file (mscc_serdes.c),
which can act as an placeholder for future serdes configurations.

Fixes: e4f9ba642f0b ("net: phy: mscc: add support for VSC8514 PHY.")
Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
Signed-off-by: Bjarni Jonasson <bjarni.jonasson@microchip.com>
Tested-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/mscc/Makefile      |   1 +
 drivers/net/phy/mscc/mscc.h        |  16 +
 drivers/net/phy/mscc/mscc_main.c   | 308 +++++++-------
 drivers/net/phy/mscc/mscc_serdes.c | 650 +++++++++++++++++++++++++++++
 drivers/net/phy/mscc/mscc_serdes.h |  31 ++
 5 files changed, 840 insertions(+), 166 deletions(-)
 create mode 100644 drivers/net/phy/mscc/mscc_serdes.c
 create mode 100644 drivers/net/phy/mscc/mscc_serdes.h

diff --git a/drivers/net/phy/mscc/Makefile b/drivers/net/phy/mscc/Makefile
index d8e22a4eeeffa..78d84194f79ae 100644
--- a/drivers/net/phy/mscc/Makefile
+++ b/drivers/net/phy/mscc/Makefile
@@ -4,6 +4,7 @@
 
 obj-$(CONFIG_MICROSEMI_PHY) := mscc.o
 mscc-objs := mscc_main.o
+mscc-objs += mscc_serdes.o
 
 ifdef CONFIG_MACSEC
 mscc-objs += mscc_macsec.o
diff --git a/drivers/net/phy/mscc/mscc.h b/drivers/net/phy/mscc/mscc.h
index c2023f93c0b24..2028c319f14dd 100644
--- a/drivers/net/phy/mscc/mscc.h
+++ b/drivers/net/phy/mscc/mscc.h
@@ -339,6 +339,10 @@ enum rgmii_clock_delay {
 #define VSC8584_REVB				0x0001
 #define MSCC_DEV_REV_MASK			GENMASK(3, 0)
 
+#define MSCC_ROM_TRAP_SERDES_6G_CFG		0x1E48
+#define MSCC_RAM_TRAP_SERDES_6G_CFG		0x1E4F
+#define PATCH_VEC_ZERO_EN			0x0100
+
 struct reg_val {
 	u16	reg;
 	u32	val;
@@ -420,6 +424,18 @@ enum csr_target {
 	MACRO_CTRL  = 0x07,
 };
 
+u32 vsc85xx_csr_read(struct phy_device *phydev,
+		     enum csr_target target, u32 reg);
+
+int vsc85xx_csr_write(struct phy_device *phydev,
+		      enum csr_target target, u32 reg, u32 val);
+
+int phy_base_write(struct phy_device *phydev, u32 regnum, u16 val);
+int phy_base_read(struct phy_device *phydev, u32 regnum);
+int phy_update_mcb_s6g(struct phy_device *phydev, u32 reg, u8 mcb);
+int phy_commit_mcb_s6g(struct phy_device *phydev, u32 reg, u8 mcb);
+int vsc8584_cmd(struct phy_device *phydev, u16 val);
+
 #if IS_ENABLED(CONFIG_MACSEC)
 int vsc8584_macsec_init(struct phy_device *phydev);
 void vsc8584_handle_macsec_interrupt(struct phy_device *phydev);
diff --git a/drivers/net/phy/mscc/mscc_main.c b/drivers/net/phy/mscc/mscc_main.c
index 7830340b9cdc8..0e6e7076a740e 100644
--- a/drivers/net/phy/mscc/mscc_main.c
+++ b/drivers/net/phy/mscc/mscc_main.c
@@ -17,7 +17,7 @@
 #include <linux/of.h>
 #include <linux/netdevice.h>
 #include <dt-bindings/net/mscc-phy-vsc8531.h>
-
+#include "mscc_serdes.h"
 #include "mscc.h"
 
 static const struct vsc85xx_hw_stat vsc85xx_hw_stats[] = {
@@ -689,7 +689,7 @@ out_unlock:
 }
 
 /* phydev->bus->mdio_lock should be locked when using this function */
-static int phy_base_write(struct phy_device *phydev, u32 regnum, u16 val)
+int phy_base_write(struct phy_device *phydev, u32 regnum, u16 val)
 {
 	if (unlikely(!mutex_is_locked(&phydev->mdio.bus->mdio_lock))) {
 		dev_err(&phydev->mdio.dev, "MDIO bus lock not held!\n");
@@ -700,7 +700,7 @@ static int phy_base_write(struct phy_device *phydev, u32 regnum, u16 val)
 }
 
 /* phydev->bus->mdio_lock should be locked when using this function */
-static int phy_base_read(struct phy_device *phydev, u32 regnum)
+int phy_base_read(struct phy_device *phydev, u32 regnum)
 {
 	if (unlikely(!mutex_is_locked(&phydev->mdio.bus->mdio_lock))) {
 		dev_err(&phydev->mdio.dev, "MDIO bus lock not held!\n");
@@ -710,8 +710,8 @@ static int phy_base_read(struct phy_device *phydev, u32 regnum)
 	return __phy_package_read(phydev, regnum);
 }
 
-static u32 vsc85xx_csr_read(struct phy_device *phydev,
-			    enum csr_target target, u32 reg)
+u32 vsc85xx_csr_read(struct phy_device *phydev,
+		     enum csr_target target, u32 reg)
 {
 	unsigned long deadline;
 	u32 val, val_l, val_h;
@@ -764,8 +764,8 @@ static u32 vsc85xx_csr_read(struct phy_device *phydev,
 	return (val_h << 16) | val_l;
 }
 
-static int vsc85xx_csr_write(struct phy_device *phydev,
-			     enum csr_target target, u32 reg, u32 val)
+int vsc85xx_csr_write(struct phy_device *phydev,
+		      enum csr_target target, u32 reg, u32 val)
 {
 	unsigned long deadline;
 
@@ -826,7 +826,7 @@ static void vsc8584_csr_write(struct phy_device *phydev, u16 addr, u32 val)
 }
 
 /* bus->mdio_lock should be locked when using this function */
-static int vsc8584_cmd(struct phy_device *phydev, u16 val)
+int vsc8584_cmd(struct phy_device *phydev, u16 val)
 {
 	unsigned long deadline;
 	u16 reg_val;
@@ -1734,6 +1734,100 @@ static int vsc85xx_config_init(struct phy_device *phydev)
 	return 0;
 }
 
+static int __phy_write_mcb_s6g(struct phy_device *phydev, u32 reg, u8 mcb,
+			       u32 op)
+{
+	unsigned long deadline;
+	u32 val;
+	int ret;
+
+	ret = vsc85xx_csr_write(phydev, PHY_MCB_TARGET, reg,
+				op | (1 << mcb));
+	if (ret)
+		return -EINVAL;
+
+	deadline = jiffies + msecs_to_jiffies(PROC_CMD_NCOMPLETED_TIMEOUT_MS);
+	do {
+		usleep_range(500, 1000);
+		val = vsc85xx_csr_read(phydev, PHY_MCB_TARGET, reg);
+
+		if (val == 0xffffffff)
+			return -EIO;
+
+	} while (time_before(jiffies, deadline) && (val & op));
+
+	if (val & op)
+		return -ETIMEDOUT;
+
+	return 0;
+}
+
+/* Trigger a read to the specified MCB */
+int phy_update_mcb_s6g(struct phy_device *phydev, u32 reg, u8 mcb)
+{
+	return __phy_write_mcb_s6g(phydev, reg, mcb, PHY_MCB_S6G_READ);
+}
+
+/* Trigger a write to the specified MCB */
+int phy_commit_mcb_s6g(struct phy_device *phydev, u32 reg, u8 mcb)
+{
+	return __phy_write_mcb_s6g(phydev, reg, mcb, PHY_MCB_S6G_WRITE);
+}
+
+static int vsc8514_config_host_serdes(struct phy_device *phydev)
+{
+	int ret;
+	u16 val;
+
+	ret = phy_base_write(phydev, MSCC_EXT_PAGE_ACCESS,
+			     MSCC_PHY_PAGE_EXTENDED_GPIO);
+	if (ret)
+		return ret;
+
+	val = phy_base_read(phydev, MSCC_PHY_MAC_CFG_FASTLINK);
+	val &= ~MAC_CFG_MASK;
+	val |= MAC_CFG_QSGMII;
+	ret = phy_base_write(phydev, MSCC_PHY_MAC_CFG_FASTLINK, val);
+	if (ret)
+		return ret;
+
+	ret = phy_base_write(phydev, MSCC_EXT_PAGE_ACCESS,
+			     MSCC_PHY_PAGE_STANDARD);
+	if (ret)
+		return ret;
+
+	ret = vsc8584_cmd(phydev, PROC_CMD_NOP);
+	if (ret)
+		return ret;
+
+	ret = vsc8584_cmd(phydev,
+			  PROC_CMD_MCB_ACCESS_MAC_CONF |
+			  PROC_CMD_RST_CONF_PORT |
+			  PROC_CMD_READ_MOD_WRITE_PORT | PROC_CMD_QSGMII_MAC);
+	if (ret) {
+		dev_err(&phydev->mdio.dev, "%s: QSGMII error: %d\n",
+			__func__, ret);
+		return ret;
+	}
+
+	/* Apply 6G SerDes FOJI Algorithm
+	 *  Initial condition requirement:
+	 *  1. hold 8051 in reset
+	 *  2. disable patch vector 0, in order to allow IB cal poll during FoJi
+	 *  3. deassert 8051 reset after change patch vector status
+	 *  4. proceed with FoJi (vsc85xx_sd6g_config_v2)
+	 */
+	vsc8584_micro_assert_reset(phydev);
+	val = phy_base_read(phydev, MSCC_INT_MEM_CNTL);
+	/* clear bit 8, to disable patch vector 0 */
+	val &= ~PATCH_VEC_ZERO_EN;
+	ret = phy_base_write(phydev, MSCC_INT_MEM_CNTL, val);
+	/* Enable 8051 clock, don't set patch present, disable PRAM clock override */
+	vsc8584_micro_deassert_reset(phydev, false);
+
+	return vsc85xx_sd6g_config_v2(phydev);
+}
+
 static int vsc8514_config_pre_init(struct phy_device *phydev)
 {
 	/* These are the settings to override the silicon default
@@ -1803,56 +1897,48 @@ static int vsc8514_config_pre_init(struct phy_device *phydev)
 	reg &= ~SMI_BROADCAST_WR_EN;
 	phy_base_write(phydev, MSCC_PHY_EXT_CNTL_STATUS, reg);
 
-	return 0;
-}
-
-static int __phy_write_mcb_s6g(struct phy_device *phydev, u32 reg, u8 mcb,
-			       u32 op)
-{
-	unsigned long deadline;
-	u32 val;
-	int ret;
+	/* Add pre-patching commands to:
+	 * 1. enable 8051 clock, operate 8051 clock at 125 MHz
+	 * instead of HW default 62.5MHz
+	 * 2. write patch vector 0, to skip IB cal polling executed
+	 * as part of the 0x80E0 ROM command
+	 */
+	vsc8584_micro_deassert_reset(phydev, false);
 
-	ret = vsc85xx_csr_write(phydev, PHY_MCB_TARGET, reg,
-				op | (1 << mcb));
+	vsc8584_micro_assert_reset(phydev);
+	phy_base_write(phydev, MSCC_EXT_PAGE_ACCESS,
+		       MSCC_PHY_PAGE_EXTENDED_GPIO);
+	/* ROM address to trap, for patch vector 0 */
+	reg = MSCC_ROM_TRAP_SERDES_6G_CFG;
+	ret = phy_base_write(phydev, MSCC_TRAP_ROM_ADDR(1), reg);
 	if (ret)
-		return -EINVAL;
-
-	deadline = jiffies + msecs_to_jiffies(PROC_CMD_NCOMPLETED_TIMEOUT_MS);
-	do {
-		usleep_range(500, 1000);
-		val = vsc85xx_csr_read(phydev, PHY_MCB_TARGET, reg);
-
-		if (val == 0xffffffff)
-			return -EIO;
-
-	} while (time_before(jiffies, deadline) && (val & op));
-
-	if (val & op)
-		return -ETIMEDOUT;
-
-	return 0;
-}
-
-/* Trigger a read to the specified MCB */
-static int phy_update_mcb_s6g(struct phy_device *phydev, u32 reg, u8 mcb)
-{
-	return __phy_write_mcb_s6g(phydev, reg, mcb, PHY_MCB_S6G_READ);
-}
+		goto err;
+	/* RAM address to jump to, when patch vector 0 enabled */
+	reg = MSCC_RAM_TRAP_SERDES_6G_CFG;
+	ret = phy_base_write(phydev, MSCC_PATCH_RAM_ADDR(1), reg);
+	if (ret)
+		goto err;
+	reg = phy_base_read(phydev, MSCC_INT_MEM_CNTL);
+	reg |= PATCH_VEC_ZERO_EN; /* bit 8, enable patch vector 0 */
+	ret = phy_base_write(phydev, MSCC_INT_MEM_CNTL, reg);
+	if (ret)
+		goto err;
 
-/* Trigger a write to the specified MCB */
-static int phy_commit_mcb_s6g(struct phy_device *phydev, u32 reg, u8 mcb)
-{
-	return __phy_write_mcb_s6g(phydev, reg, mcb, PHY_MCB_S6G_WRITE);
+	/* Enable 8051 clock, don't set patch present
+	 * yet, disable PRAM clock override
+	 */
+	vsc8584_micro_deassert_reset(phydev, false);
+	return ret;
+ err:
+	/* restore 8051 and bail w error */
+	vsc8584_micro_deassert_reset(phydev, false);
+	return ret;
 }
 
 static int vsc8514_config_init(struct phy_device *phydev)
 {
 	struct vsc8531_private *vsc8531 = phydev->priv;
-	unsigned long deadline;
 	int ret, i;
-	u16 val;
-	u32 reg;
 
 	phydev->mdix_ctrl = ETH_TP_MDI_AUTO;
 
@@ -1869,123 +1955,13 @@ static int vsc8514_config_init(struct phy_device *phydev)
 	 * do the correct init sequence for all PHYs that are package-critical
 	 * in this pre-init function.
 	 */
-	if (phy_package_init_once(phydev))
-		vsc8514_config_pre_init(phydev);
-
-	ret = phy_base_write(phydev, MSCC_EXT_PAGE_ACCESS,
-			     MSCC_PHY_PAGE_EXTENDED_GPIO);
-	if (ret)
-		goto err;
-
-	val = phy_base_read(phydev, MSCC_PHY_MAC_CFG_FASTLINK);
-
-	val &= ~MAC_CFG_MASK;
-	val |= MAC_CFG_QSGMII;
-	ret = phy_base_write(phydev, MSCC_PHY_MAC_CFG_FASTLINK, val);
-	if (ret)
-		goto err;
-
-	ret = phy_base_write(phydev, MSCC_EXT_PAGE_ACCESS,
-			     MSCC_PHY_PAGE_STANDARD);
-	if (ret)
-		goto err;
-
-	ret = vsc8584_cmd(phydev,
-			  PROC_CMD_MCB_ACCESS_MAC_CONF |
-			  PROC_CMD_RST_CONF_PORT |
-			  PROC_CMD_READ_MOD_WRITE_PORT | PROC_CMD_QSGMII_MAC);
-	if (ret)
-		goto err;
-
-	/* 6g mcb */
-	phy_update_mcb_s6g(phydev, PHY_MCB_S6G_CFG, 0);
-	/* lcpll mcb */
-	phy_update_mcb_s6g(phydev, PHY_S6G_LCPLL_CFG, 0);
-	/* pll5gcfg0 */
-	ret = vsc85xx_csr_write(phydev, PHY_MCB_TARGET,
-				PHY_S6G_PLL5G_CFG0, 0x7036f145);
-	if (ret)
-		goto err;
-
-	phy_commit_mcb_s6g(phydev, PHY_S6G_LCPLL_CFG, 0);
-	/* pllcfg */
-	ret = vsc85xx_csr_write(phydev, PHY_MCB_TARGET,
-				PHY_S6G_PLL_CFG,
-				(3 << PHY_S6G_PLL_ENA_OFFS_POS) |
-				(120 << PHY_S6G_PLL_FSM_CTRL_DATA_POS)
-				| (0 << PHY_S6G_PLL_FSM_ENA_POS));
-	if (ret)
-		goto err;
-
-	/* commoncfg */
-	ret = vsc85xx_csr_write(phydev, PHY_MCB_TARGET,
-				PHY_S6G_COMMON_CFG,
-				(0 << PHY_S6G_SYS_RST_POS) |
-				(0 << PHY_S6G_ENA_LANE_POS) |
-				(0 << PHY_S6G_ENA_LOOP_POS) |
-				(0 << PHY_S6G_QRATE_POS) |
-				(3 << PHY_S6G_IF_MODE_POS));
-	if (ret)
-		goto err;
-
-	/* misccfg */
-	ret = vsc85xx_csr_write(phydev, PHY_MCB_TARGET,
-				PHY_S6G_MISC_CFG, 1);
-	if (ret)
-		goto err;
-
-	/* gpcfg */
-	ret = vsc85xx_csr_write(phydev, PHY_MCB_TARGET,
-				PHY_S6G_GPC_CFG, 768);
-	if (ret)
-		goto err;
-
-	phy_commit_mcb_s6g(phydev, PHY_S6G_DFT_CFG2, 0);
-
-	deadline = jiffies + msecs_to_jiffies(PROC_CMD_NCOMPLETED_TIMEOUT_MS);
-	do {
-		usleep_range(500, 1000);
-		phy_update_mcb_s6g(phydev, PHY_MCB_S6G_CFG,
-				   0); /* read 6G MCB into CSRs */
-		reg = vsc85xx_csr_read(phydev, PHY_MCB_TARGET,
-				       PHY_S6G_PLL_STATUS);
-		if (reg == 0xffffffff) {
-			phy_unlock_mdio_bus(phydev);
-			return -EIO;
-		}
-
-	} while (time_before(jiffies, deadline) && (reg & BIT(12)));
-
-	if (reg & BIT(12)) {
-		phy_unlock_mdio_bus(phydev);
-		return -ETIMEDOUT;
-	}
-
-	/* misccfg */
-	ret = vsc85xx_csr_write(phydev, PHY_MCB_TARGET,
-				PHY_S6G_MISC_CFG, 0);
-	if (ret)
-		goto err;
-
-	phy_commit_mcb_s6g(phydev, PHY_MCB_S6G_CFG, 0);
-
-	deadline = jiffies + msecs_to_jiffies(PROC_CMD_NCOMPLETED_TIMEOUT_MS);
-	do {
-		usleep_range(500, 1000);
-		phy_update_mcb_s6g(phydev, PHY_MCB_S6G_CFG,
-				   0); /* read 6G MCB into CSRs */
-		reg = vsc85xx_csr_read(phydev, PHY_MCB_TARGET,
-				       PHY_S6G_IB_STATUS0);
-		if (reg == 0xffffffff) {
-			phy_unlock_mdio_bus(phydev);
-			return -EIO;
-		}
-
-	} while (time_before(jiffies, deadline) && !(reg & BIT(8)));
-
-	if (!(reg & BIT(8))) {
-		phy_unlock_mdio_bus(phydev);
-		return -ETIMEDOUT;
+	if (phy_package_init_once(phydev)) {
+		ret = vsc8514_config_pre_init(phydev);
+		if (ret)
+			goto err;
+		ret = vsc8514_config_host_serdes(phydev);
+		if (ret)
+			goto err;
 	}
 
 	phy_unlock_mdio_bus(phydev);
diff --git a/drivers/net/phy/mscc/mscc_serdes.c b/drivers/net/phy/mscc/mscc_serdes.c
new file mode 100644
index 0000000000000..b3e854f53d675
--- /dev/null
+++ b/drivers/net/phy/mscc/mscc_serdes.c
@@ -0,0 +1,650 @@
+// SPDX-License-Identifier: (GPL-2.0 OR MIT)
+/*
+ * Driver for Microsemi VSC85xx PHYs
+ *
+ * Author: Bjarni Jonasson <bjarni.jonassoni@microchip.com>
+ * License: Dual MIT/GPL
+ * Copyright (c) 2021 Microsemi Corporation
+ */
+
+#include <linux/phy.h>
+#include "mscc_serdes.h"
+#include "mscc.h"
+
+static int pll5g_detune(struct phy_device *phydev)
+{
+	u32 rd_dat;
+	int ret;
+
+	rd_dat = vsc85xx_csr_read(phydev, MACRO_CTRL, PHY_S6G_PLL5G_CFG2);
+	rd_dat &= ~PHY_S6G_PLL5G_CFG2_GAIN_MASK;
+	rd_dat |= PHY_S6G_PLL5G_CFG2_ENA_GAIN;
+	ret = vsc85xx_csr_write(phydev, MACRO_CTRL,
+				PHY_S6G_PLL5G_CFG2, rd_dat);
+	if (ret)
+		dev_err(&phydev->mdio.dev, "%s: write error\n", __func__);
+	return ret;
+}
+
+static int pll5g_tune(struct phy_device *phydev)
+{
+	u32 rd_dat;
+	int ret;
+
+	rd_dat = vsc85xx_csr_read(phydev, MACRO_CTRL, PHY_S6G_PLL5G_CFG2);
+	rd_dat &= ~PHY_S6G_PLL5G_CFG2_ENA_GAIN;
+	ret = vsc85xx_csr_write(phydev, MACRO_CTRL,
+				PHY_S6G_PLL5G_CFG2, rd_dat);
+	if (ret)
+		dev_err(&phydev->mdio.dev, "%s: write error\n", __func__);
+	return ret;
+}
+
+static int vsc85xx_sd6g_pll_cfg_wr(struct phy_device *phydev,
+				   const u32 pll_ena_offs,
+				   const u32 pll_fsm_ctrl_data,
+				   const u32 pll_fsm_ena)
+{
+	int ret;
+
+	ret = vsc85xx_csr_write(phydev, MACRO_CTRL,
+				PHY_S6G_PLL_CFG,
+				(pll_fsm_ena << PHY_S6G_PLL_ENA_OFFS_POS) |
+				(pll_fsm_ctrl_data << PHY_S6G_PLL_FSM_CTRL_DATA_POS) |
+				(pll_ena_offs << PHY_S6G_PLL_FSM_ENA_POS));
+	if (ret)
+		dev_err(&phydev->mdio.dev, "%s: write error\n", __func__);
+	return ret;
+}
+
+static int vsc85xx_sd6g_common_cfg_wr(struct phy_device *phydev,
+				      const u32 sys_rst,
+				      const u32 ena_lane,
+				      const u32 ena_loop,
+				      const u32 qrate,
+				      const u32 if_mode,
+				      const u32 pwd_tx)
+{
+	/* ena_loop = 8 for eloop */
+	/*          = 4 for floop */
+	/*          = 2 for iloop */
+	/*          = 1 for ploop */
+	/* qrate    = 1 for SGMII, 0 for QSGMII */
+	/* if_mode  = 1 for SGMII, 3 for QSGMII */
+
+	int ret;
+
+	ret = vsc85xx_csr_write(phydev, MACRO_CTRL,
+				PHY_S6G_COMMON_CFG,
+				(sys_rst << PHY_S6G_SYS_RST_POS) |
+				(ena_lane << PHY_S6G_ENA_LANE_POS) |
+				(ena_loop << PHY_S6G_ENA_LOOP_POS) |
+				(qrate << PHY_S6G_QRATE_POS) |
+				(if_mode << PHY_S6G_IF_MODE_POS));
+	if (ret)
+		dev_err(&phydev->mdio.dev, "%s: write error\n", __func__);
+	return ret;
+}
+
+static int vsc85xx_sd6g_des_cfg_wr(struct phy_device *phydev,
+				   const u32 des_phy_ctrl,
+				   const u32 des_mbtr_ctrl,
+				   const u32 des_bw_hyst,
+				   const u32 des_bw_ana,
+				   const u32 des_cpmd_sel)
+{
+	u32 reg_val;
+	int ret;
+
+	/* configurable terms */
+	reg_val = (des_phy_ctrl << PHY_S6G_DES_PHY_CTRL_POS) |
+		  (des_mbtr_ctrl << PHY_S6G_DES_MBTR_CTRL_POS) |
+		  (des_cpmd_sel << PHY_S6G_DES_CPMD_SEL_POS) |
+		  (des_bw_hyst << PHY_S6G_DES_BW_HYST_POS) |
+		  (des_bw_ana << PHY_S6G_DES_BW_ANA_POS);
+	ret = vsc85xx_csr_write(phydev, MACRO_CTRL,
+				PHY_S6G_DES_CFG,
+				reg_val);
+	if (ret)
+		dev_err(&phydev->mdio.dev, "%s: write error\n", __func__);
+	return ret;
+}
+
+static int vsc85xx_sd6g_ib_cfg0_wr(struct phy_device *phydev,
+				   const u32 ib_rtrm_adj,
+				   const u32 ib_sig_det_clk_sel,
+				   const u32 ib_reg_pat_sel_offset,
+				   const u32 ib_cal_ena)
+{
+	u32 base_val;
+	u32 reg_val;
+	int ret;
+
+	/* constant terms */
+	base_val = 0x60a85837;
+	/* configurable terms */
+	reg_val = base_val | (ib_rtrm_adj << 25) |
+		  (ib_sig_det_clk_sel << 16) |
+		  (ib_reg_pat_sel_offset << 8) |
+		  (ib_cal_ena << 3);
+	ret = vsc85xx_csr_write(phydev, MACRO_CTRL,
+				PHY_S6G_IB_CFG0,
+				reg_val);
+	if (ret)
+		dev_err(&phydev->mdio.dev, "%s: write error\n", __func__);
+	return ret;
+}
+
+static int vsc85xx_sd6g_ib_cfg1_wr(struct phy_device *phydev,
+				   const u32 ib_tjtag,
+				   const u32 ib_tsdet,
+				   const u32 ib_scaly,
+				   const u32 ib_frc_offset,
+				   const u32 ib_filt_offset)
+{
+	u32 ib_filt_val;
+	u32 reg_val = 0;
+	int ret;
+
+	/* constant terms */
+	ib_filt_val = 0xe0;
+	/* configurable terms */
+	reg_val  = (ib_tjtag << 17) + (ib_tsdet << 12) + (ib_scaly << 8) +
+		   ib_filt_val + (ib_filt_offset << 4) + (ib_frc_offset << 0);
+	ret = vsc85xx_csr_write(phydev, MACRO_CTRL,
+				PHY_S6G_IB_CFG1,
+				reg_val);
+	if (ret)
+		dev_err(&phydev->mdio.dev, "%s: write error\n", __func__);
+	return ret;
+}
+
+static int vsc85xx_sd6g_ib_cfg2_wr(struct phy_device *phydev,
+				   const u32 ib_tinfv,
+				   const u32 ib_tcalv,
+				   const u32 ib_ureg)
+{
+	u32 ib_cfg2_val;
+	u32 base_val;
+	int ret;
+
+	/* constant terms */
+	base_val = 0x0f878010;
+	/* configurable terms */
+	ib_cfg2_val = base_val | ((ib_tinfv) << 28) | ((ib_tcalv) << 5) |
+		      (ib_ureg << 0);
+	ret = vsc85xx_csr_write(phydev, MACRO_CTRL,
+				PHY_S6G_IB_CFG2,
+				ib_cfg2_val);
+	if (ret)
+		dev_err(&phydev->mdio.dev, "%s: write error\n", __func__);
+	return ret;
+}
+
+static int vsc85xx_sd6g_ib_cfg3_wr(struct phy_device *phydev,
+				   const u32 ib_ini_hp,
+				   const u32 ib_ini_mid,
+				   const u32 ib_ini_lp,
+				   const u32 ib_ini_offset)
+{
+	u32 reg_val;
+	int ret;
+
+	reg_val  = (ib_ini_hp << 24) + (ib_ini_mid << 16) +
+		   (ib_ini_lp << 8) + (ib_ini_offset << 0);
+	ret = vsc85xx_csr_write(phydev, MACRO_CTRL,
+				PHY_S6G_IB_CFG3,
+				reg_val);
+	if (ret)
+		dev_err(&phydev->mdio.dev, "%s: write error\n", __func__);
+	return ret;
+}
+
+static int vsc85xx_sd6g_ib_cfg4_wr(struct phy_device *phydev,
+				   const u32 ib_max_hp,
+				   const u32 ib_max_mid,
+				   const u32 ib_max_lp,
+				   const u32 ib_max_offset)
+{
+	u32 reg_val;
+	int ret;
+
+	reg_val  = (ib_max_hp << 24) + (ib_max_mid << 16) +
+		   (ib_max_lp << 8) + (ib_max_offset << 0);
+	ret = vsc85xx_csr_write(phydev, MACRO_CTRL,
+				PHY_S6G_IB_CFG4,
+				reg_val);
+	if (ret)
+		dev_err(&phydev->mdio.dev, "%s: write error\n", __func__);
+	return ret;
+}
+
+static int vsc85xx_sd6g_misc_cfg_wr(struct phy_device *phydev,
+				    const u32 lane_rst)
+{
+	int ret;
+
+	ret = vsc85xx_csr_write(phydev, MACRO_CTRL,
+				PHY_S6G_MISC_CFG,
+				lane_rst);
+	if (ret)
+		dev_err(&phydev->mdio.dev, "%s: write error\n", __func__);
+	return ret;
+}
+
+static int vsc85xx_sd6g_gp_cfg_wr(struct phy_device *phydev, const u32 gp_cfg_val)
+{
+	int ret;
+
+	ret = vsc85xx_csr_write(phydev, MACRO_CTRL,
+				PHY_S6G_GP_CFG,
+				gp_cfg_val);
+	if (ret)
+		dev_err(&phydev->mdio.dev, "%s: write error\n", __func__);
+	return ret;
+}
+
+static int vsc85xx_sd6g_dft_cfg2_wr(struct phy_device *phydev,
+				    const u32 rx_ji_ampl,
+				    const u32 rx_step_freq,
+				    const u32 rx_ji_ena,
+				    const u32 rx_waveform_sel,
+				    const u32 rx_freqoff_dir,
+				    const u32 rx_freqoff_ena)
+{
+	u32 reg_val;
+	int ret;
+
+	/* configurable terms */
+	reg_val = (rx_ji_ampl << 8) | (rx_step_freq << 4) |
+		  (rx_ji_ena << 3) | (rx_waveform_sel << 2) |
+		  (rx_freqoff_dir << 1) | rx_freqoff_ena;
+	ret = vsc85xx_csr_write(phydev, MACRO_CTRL,
+				PHY_S6G_IB_DFT_CFG2,
+				reg_val);
+	if (ret)
+		dev_err(&phydev->mdio.dev, "%s: write error\n", __func__);
+	return ret;
+}
+
+static int vsc85xx_sd6g_dft_cfg0_wr(struct phy_device *phydev,
+				    const u32 prbs_sel,
+				    const u32 test_mode,
+				    const u32 rx_dft_ena)
+{
+	u32 reg_val;
+	int ret;
+
+	/* configurable terms */
+	reg_val = (prbs_sel << 20) | (test_mode << 16) | (rx_dft_ena << 2);
+	ret = vsc85xx_csr_write(phydev, MACRO_CTRL,
+				PHY_S6G_DFT_CFG0,
+				reg_val);
+	if (ret)
+		dev_err(&phydev->mdio.dev, "%s: write error\n", __func__);
+	return ret;
+}
+
+/* Access LCPLL Cfg_0 */
+static int vsc85xx_pll5g_cfg0_wr(struct phy_device *phydev,
+				 const u32 selbgv820)
+{
+	u32 base_val;
+	u32 reg_val;
+	int ret;
+
+	/* constant terms */
+	base_val = 0x7036f145;
+	/* configurable terms */
+	reg_val = base_val | (selbgv820 << 23);
+	ret = vsc85xx_csr_write(phydev, MACRO_CTRL,
+				PHY_S6G_PLL5G_CFG0, reg_val);
+	if (ret)
+		dev_err(&phydev->mdio.dev, "%s: write error\n", __func__);
+	return ret;
+}
+
+int vsc85xx_sd6g_config_v2(struct phy_device *phydev)
+{
+	u32 ib_sig_det_clk_sel_cal = 0;
+	u32 ib_sig_det_clk_sel_mm  = 7;
+	u32 pll_fsm_ctrl_data = 60;
+	unsigned long deadline;
+	u32 des_bw_ana_val = 3;
+	u32 ib_tsdet_cal = 16;
+	u32 ib_tsdet_mm  = 5;
+	u32 ib_rtrm_adj;
+	u32 if_mode = 1;
+	u32 gp_iter = 5;
+	u32 val32 = 0;
+	u32 qrate = 1;
+	u32 iter;
+	int val = 0;
+	int ret;
+
+	phy_base_write(phydev, MSCC_EXT_PAGE_ACCESS, MSCC_PHY_PAGE_STANDARD);
+
+	/* Detune/Unlock LCPLL */
+	ret = pll5g_detune(phydev);
+	if (ret)
+		return ret;
+
+	/* 0. Reset RCPLL */
+	ret = vsc85xx_sd6g_pll_cfg_wr(phydev, 3, pll_fsm_ctrl_data, 0);
+	if (ret)
+		return ret;
+	ret = vsc85xx_sd6g_common_cfg_wr(phydev, 0, 0, 0, qrate, if_mode, 0);
+	if (ret)
+		return ret;
+	ret = phy_commit_mcb_s6g(phydev, PHY_MCB_S6G_CFG, 0);
+	if (ret)
+		return ret;
+	ret = vsc85xx_sd6g_des_cfg_wr(phydev, 6, 2, 5, des_bw_ana_val, 0);
+	if (ret)
+		return ret;
+
+	/* 1. Configure sd6g for SGMII prior to sd6g_IB_CAL */
+	ib_rtrm_adj = 13;
+	ret = vsc85xx_sd6g_ib_cfg0_wr(phydev, ib_rtrm_adj, ib_sig_det_clk_sel_mm, 0, 0);
+	if (ret)
+		return ret;
+	ret = vsc85xx_sd6g_ib_cfg1_wr(phydev, 8, ib_tsdet_mm, 15, 0, 1);
+	if (ret)
+		return ret;
+	ret = vsc85xx_sd6g_ib_cfg2_wr(phydev, 3, 13, 5);
+	if (ret)
+		return ret;
+	ret = vsc85xx_sd6g_ib_cfg3_wr(phydev,  0, 31, 1, 31);
+	if (ret)
+		return ret;
+	ret = vsc85xx_sd6g_ib_cfg4_wr(phydev, 63, 63, 2, 63);
+	if (ret)
+		return ret;
+	ret = vsc85xx_sd6g_common_cfg_wr(phydev, 1, 1, 0, qrate, if_mode, 0);
+	if (ret)
+		return ret;
+	ret = vsc85xx_sd6g_misc_cfg_wr(phydev, 1);
+	if (ret)
+		return ret;
+	ret = phy_commit_mcb_s6g(phydev, PHY_MCB_S6G_CFG, 0);
+	if (ret)
+		return ret;
+
+	/* 2. Start rcpll_fsm */
+	ret = vsc85xx_sd6g_pll_cfg_wr(phydev, 3, pll_fsm_ctrl_data, 1);
+	if (ret)
+		return ret;
+	ret = phy_commit_mcb_s6g(phydev, PHY_MCB_S6G_CFG, 0);
+	if (ret)
+		return ret;
+
+	deadline = jiffies + msecs_to_jiffies(PROC_CMD_NCOMPLETED_TIMEOUT_MS);
+	do {
+		usleep_range(500, 1000);
+		ret = phy_update_mcb_s6g(phydev, PHY_MCB_S6G_CFG, 0);
+		if (ret)
+			return ret;
+		val32 = vsc85xx_csr_read(phydev, MACRO_CTRL,
+					 PHY_S6G_PLL_STATUS);
+		/* wait for bit 12 to clear */
+	} while (time_before(jiffies, deadline) && (val32 & BIT(12)));
+
+	if (val32 & BIT(12))
+		return -ETIMEDOUT;
+
+	/* 4. Release digital reset and disable transmitter */
+	ret = vsc85xx_sd6g_misc_cfg_wr(phydev, 0);
+	if (ret)
+		return ret;
+	ret = vsc85xx_sd6g_common_cfg_wr(phydev, 1, 1, 0, qrate, if_mode, 1);
+	if (ret)
+		return ret;
+	ret = phy_commit_mcb_s6g(phydev, PHY_MCB_S6G_CFG, 0);
+	if (ret)
+		return ret;
+
+	/* 5. Apply a frequency offset on RX-side (using internal FoJi logic) */
+	ret = vsc85xx_sd6g_gp_cfg_wr(phydev, 768);
+	if (ret)
+		return ret;
+	ret = vsc85xx_sd6g_dft_cfg2_wr(phydev, 0, 2, 0, 0, 0, 1);
+	if (ret)
+		return ret;
+	ret = vsc85xx_sd6g_dft_cfg0_wr(phydev, 0, 0, 1);
+	if (ret)
+		return ret;
+	ret = vsc85xx_sd6g_des_cfg_wr(phydev, 6, 2, 5, des_bw_ana_val, 2);
+	if (ret)
+		return ret;
+	ret = phy_commit_mcb_s6g(phydev, PHY_MCB_S6G_CFG, 0);
+	if (ret)
+		return ret;
+
+	/* 6. Prepare required settings for IBCAL */
+	ret = vsc85xx_sd6g_ib_cfg1_wr(phydev, 8, ib_tsdet_cal, 15, 1, 0);
+	if (ret)
+		return ret;
+	ret = vsc85xx_sd6g_ib_cfg0_wr(phydev, ib_rtrm_adj, ib_sig_det_clk_sel_cal, 0, 0);
+	if (ret)
+		return ret;
+	ret = phy_commit_mcb_s6g(phydev, PHY_MCB_S6G_CFG, 0);
+	if (ret)
+		return ret;
+
+	/* 7. Start IB_CAL */
+	ret = vsc85xx_sd6g_ib_cfg0_wr(phydev, ib_rtrm_adj,
+				      ib_sig_det_clk_sel_cal, 0, 1);
+	if (ret)
+		return ret;
+	ret = phy_commit_mcb_s6g(phydev, PHY_MCB_S6G_CFG, 0);
+	if (ret)
+		return ret;
+	/* 11 cycles (for ViperA) or 5 cycles (for ViperB & Elise) w/ SW clock */
+	for (iter = 0; iter < gp_iter; iter++) {
+		/* set gp(0) */
+		ret = vsc85xx_sd6g_gp_cfg_wr(phydev, 769);
+		if (ret)
+			return ret;
+		ret = phy_commit_mcb_s6g(phydev, PHY_MCB_S6G_CFG, 0);
+		if (ret)
+			return ret;
+		/* clear gp(0) */
+		ret = vsc85xx_sd6g_gp_cfg_wr(phydev, 768);
+		if (ret)
+			return ret;
+		ret = phy_commit_mcb_s6g(phydev, PHY_MCB_S6G_CFG, 0);
+		if (ret)
+			return ret;
+	}
+
+	ret = vsc85xx_sd6g_ib_cfg1_wr(phydev, 8, ib_tsdet_cal, 15, 1, 1);
+	if (ret)
+		return ret;
+	ret = phy_commit_mcb_s6g(phydev, PHY_MCB_S6G_CFG, 0);
+	if (ret)
+		return ret;
+	ret = vsc85xx_sd6g_ib_cfg1_wr(phydev, 8, ib_tsdet_cal, 15, 0, 1);
+	if (ret)
+		return ret;
+	ret = phy_commit_mcb_s6g(phydev, PHY_MCB_S6G_CFG, 0);
+	if (ret)
+		return ret;
+
+	/* 8. Wait for IB cal to complete */
+	deadline = jiffies + msecs_to_jiffies(PROC_CMD_NCOMPLETED_TIMEOUT_MS);
+	do {
+		usleep_range(500, 1000);
+		ret = phy_update_mcb_s6g(phydev, PHY_MCB_S6G_CFG, 0);
+		if (ret)
+			return ret;
+		val32 = vsc85xx_csr_read(phydev, MACRO_CTRL,
+					 PHY_S6G_IB_STATUS0);
+		/* wait for bit 8 to set */
+	} while (time_before(jiffies, deadline) && (~val32 & BIT(8)));
+
+	if (~val32 & BIT(8))
+		return -ETIMEDOUT;
+
+	/* 9. Restore cfg values for mission mode */
+	ret = vsc85xx_sd6g_ib_cfg0_wr(phydev, ib_rtrm_adj, ib_sig_det_clk_sel_mm, 0, 1);
+	if (ret)
+		return ret;
+	ret = vsc85xx_sd6g_ib_cfg1_wr(phydev, 8, ib_tsdet_mm, 15, 0, 1);
+	if (ret)
+		return ret;
+	ret = phy_commit_mcb_s6g(phydev, PHY_MCB_S6G_CFG, 0);
+	if (ret)
+		return ret;
+
+	/* 10. Re-enable transmitter */
+	ret = vsc85xx_sd6g_common_cfg_wr(phydev, 1, 1, 0, qrate, if_mode, 0);
+	if (ret)
+		return ret;
+	ret = phy_commit_mcb_s6g(phydev, PHY_MCB_S6G_CFG, 0);
+	if (ret)
+		return ret;
+
+	/* 11. Disable frequency offset generation (using internal FoJi logic) */
+	ret = vsc85xx_sd6g_dft_cfg2_wr(phydev, 0, 0, 0, 0, 0, 0);
+	if (ret)
+		return ret;
+	ret = vsc85xx_sd6g_dft_cfg0_wr(phydev, 0, 0, 0);
+	if (ret)
+		return ret;
+	ret = vsc85xx_sd6g_des_cfg_wr(phydev, 6, 2, 5, des_bw_ana_val, 0);
+	if (ret)
+		return ret;
+	ret = phy_commit_mcb_s6g(phydev, PHY_MCB_S6G_CFG, 0);
+	if (ret)
+		return ret;
+
+	/* Tune/Re-lock LCPLL */
+	ret = pll5g_tune(phydev);
+	if (ret)
+		return ret;
+
+	/* 12. Configure for Final Configuration and Settings */
+	/* a. Reset RCPLL */
+	ret = vsc85xx_sd6g_pll_cfg_wr(phydev, 3, pll_fsm_ctrl_data, 0);
+	if (ret)
+		return ret;
+	ret = vsc85xx_sd6g_common_cfg_wr(phydev, 0, 1, 0, qrate, if_mode, 0);
+	if (ret)
+		return ret;
+	ret = phy_commit_mcb_s6g(phydev, PHY_MCB_S6G_CFG, 0);
+	if (ret)
+		return ret;
+
+	/* b. Configure sd6g for desired operating mode */
+	phy_base_write(phydev, MSCC_EXT_PAGE_ACCESS, MSCC_PHY_PAGE_EXTENDED_GPIO);
+	ret = phy_base_read(phydev, MSCC_PHY_MAC_CFG_FASTLINK);
+	if ((ret & MAC_CFG_MASK) == MAC_CFG_QSGMII) {
+		/* QSGMII */
+		pll_fsm_ctrl_data = 120;
+		qrate   = 0;
+		if_mode = 3;
+		des_bw_ana_val = 5;
+		val = PROC_CMD_MCB_ACCESS_MAC_CONF | PROC_CMD_RST_CONF_PORT |
+			PROC_CMD_READ_MOD_WRITE_PORT | PROC_CMD_QSGMII_MAC;
+
+		ret = vsc8584_cmd(phydev, val);
+		if (ret) {
+			dev_err(&phydev->mdio.dev, "%s: QSGMII error: %d\n",
+				__func__, ret);
+			return ret;
+		}
+
+		phy_base_write(phydev, MSCC_EXT_PAGE_ACCESS, MSCC_PHY_PAGE_STANDARD);
+	} else if ((ret & MAC_CFG_MASK) == MAC_CFG_SGMII) {
+		/* SGMII */
+		pll_fsm_ctrl_data = 60;
+		qrate   = 1;
+		if_mode = 1;
+		des_bw_ana_val = 3;
+
+		val = PROC_CMD_MCB_ACCESS_MAC_CONF | PROC_CMD_RST_CONF_PORT |
+			PROC_CMD_READ_MOD_WRITE_PORT | PROC_CMD_SGMII_MAC;
+
+		ret = vsc8584_cmd(phydev, val);
+		if (ret) {
+			dev_err(&phydev->mdio.dev, "%s: SGMII error: %d\n",
+				__func__, ret);
+			return ret;
+		}
+
+		phy_base_write(phydev, MSCC_EXT_PAGE_ACCESS, MSCC_PHY_PAGE_STANDARD);
+	} else {
+		dev_err(&phydev->mdio.dev, "%s: invalid mac_if: %x\n",
+			__func__, ret);
+	}
+
+	ret = phy_update_mcb_s6g(phydev, PHY_S6G_LCPLL_CFG, 0);
+	if (ret)
+		return ret;
+	ret = phy_update_mcb_s6g(phydev, PHY_MCB_S6G_CFG, 0);
+	if (ret)
+		return ret;
+	ret = vsc85xx_pll5g_cfg0_wr(phydev, 4);
+	if (ret)
+		return ret;
+	ret = phy_commit_mcb_s6g(phydev, PHY_S6G_LCPLL_CFG, 0);
+	if (ret)
+		return ret;
+	ret = vsc85xx_sd6g_des_cfg_wr(phydev, 6, 2, 5, des_bw_ana_val, 0);
+	if (ret)
+		return ret;
+	ret = vsc85xx_sd6g_ib_cfg0_wr(phydev, ib_rtrm_adj, ib_sig_det_clk_sel_mm, 0, 1);
+	if (ret)
+		return ret;
+	ret = vsc85xx_sd6g_ib_cfg1_wr(phydev, 8, ib_tsdet_mm, 15, 0, 1);
+	if (ret)
+		return ret;
+	ret = vsc85xx_sd6g_common_cfg_wr(phydev, 1, 1, 0, qrate, if_mode, 0);
+	if (ret)
+		return ret;
+	ret = vsc85xx_sd6g_ib_cfg2_wr(phydev, 3, 13, 5);
+	if (ret)
+		return ret;
+	ret = vsc85xx_sd6g_ib_cfg3_wr(phydev,  0, 31, 1, 31);
+	if (ret)
+		return ret;
+	ret = vsc85xx_sd6g_ib_cfg4_wr(phydev, 63, 63, 2, 63);
+	if (ret)
+		return ret;
+	ret = vsc85xx_sd6g_misc_cfg_wr(phydev, 1);
+	if (ret)
+		return ret;
+	ret = phy_commit_mcb_s6g(phydev, PHY_MCB_S6G_CFG, 0);
+	if (ret)
+		return ret;
+
+	/* 13. Start rcpll_fsm */
+	ret = vsc85xx_sd6g_pll_cfg_wr(phydev, 3, pll_fsm_ctrl_data, 1);
+	if (ret)
+		return ret;
+	ret = phy_commit_mcb_s6g(phydev, PHY_MCB_S6G_CFG, 0);
+	if (ret)
+		return ret;
+
+	/* 14. Wait for PLL cal to complete */
+	deadline = jiffies + msecs_to_jiffies(PROC_CMD_NCOMPLETED_TIMEOUT_MS);
+	do {
+		usleep_range(500, 1000);
+		ret = phy_update_mcb_s6g(phydev, PHY_MCB_S6G_CFG, 0);
+		if (ret)
+			return ret;
+		val32 = vsc85xx_csr_read(phydev, MACRO_CTRL,
+					 PHY_S6G_PLL_STATUS);
+		/* wait for bit 12 to clear */
+	} while (time_before(jiffies, deadline) && (val32 & BIT(12)));
+
+	if (val32 & BIT(12))
+		return -ETIMEDOUT;
+
+	/* release lane reset */
+	ret = vsc85xx_sd6g_misc_cfg_wr(phydev, 0);
+	if (ret)
+		return ret;
+
+	return phy_commit_mcb_s6g(phydev, PHY_MCB_S6G_CFG, 0);
+}
diff --git a/drivers/net/phy/mscc/mscc_serdes.h b/drivers/net/phy/mscc/mscc_serdes.h
new file mode 100644
index 0000000000000..2a6371322af91
--- /dev/null
+++ b/drivers/net/phy/mscc/mscc_serdes.h
@@ -0,0 +1,31 @@
+/* SPDX-License-Identifier: (GPL-2.0 OR MIT) */
+/*
+ * Driver for Microsemi VSC85xx PHYs
+ *
+ * Copyright (c) 2021 Microsemi Corporation
+ */
+
+#ifndef _MSCC_SERDES_PHY_H_
+#define _MSCC_SERDES_PHY_H_
+
+#define PHY_S6G_PLL5G_CFG2_GAIN_MASK      GENMASK(9, 5)
+#define PHY_S6G_PLL5G_CFG2_ENA_GAIN       1
+
+#define PHY_S6G_DES_PHY_CTRL_POS	  13
+#define PHY_S6G_DES_MBTR_CTRL_POS	  10
+#define PHY_S6G_DES_CPMD_SEL_POS	  8
+#define PHY_S6G_DES_BW_HYST_POS		  5
+#define PHY_S6G_DES_BW_ANA_POS		  1
+#define PHY_S6G_DES_CFG			  0x21
+#define PHY_S6G_IB_CFG0			  0x22
+#define PHY_S6G_IB_CFG1			  0x23
+#define PHY_S6G_IB_CFG2			  0x24
+#define PHY_S6G_IB_CFG3			  0x25
+#define PHY_S6G_IB_CFG4			  0x26
+#define PHY_S6G_GP_CFG			  0x2E
+#define PHY_S6G_DFT_CFG0		  0x35
+#define PHY_S6G_IB_DFT_CFG2		  0x37
+
+int vsc85xx_sd6g_config_v2(struct phy_device *phydev);
+
+#endif /* _MSCC_PHY_SERDES_H_ */
-- 
2.27.0



