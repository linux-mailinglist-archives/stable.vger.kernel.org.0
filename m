Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 721225AEA3B
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 15:43:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238371AbiIFNm5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 09:42:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233319AbiIFNlA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 09:41:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B32E7DF5F;
        Tue,  6 Sep 2022 06:37:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9AB576153B;
        Tue,  6 Sep 2022 13:37:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B9CFC433C1;
        Tue,  6 Sep 2022 13:37:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662471433;
        bh=yIYzjTZhdxrceP0eU5FoTXMh74huDAYBreEfFftF1IU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=15OJPPl/rNSiNLxUSLevPMjDgsvVlvNYqfbwwqbQ5MY+zbbZnCB9W9uemr4Rt3zGj
         XKMP2fdjjAIrmJxbYgR6I3E1WkgW8ayvUHgSADFKum8/mxGprAAHTfhnOrU729glhH
         /7yJZako1fWvPZ+I0sOoiKk3NmAJYfFD1ei460WA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Asmaa Mnebhi <asmaa@nvidia.com>,
        David Thompson <davthompson@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 024/107] mlxbf_gige: compute MDIO period based on i1clk
Date:   Tue,  6 Sep 2022 15:30:05 +0200
Message-Id: <20220906132822.796091406@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220906132821.713989422@linuxfoundation.org>
References: <20220906132821.713989422@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Thompson <davthompson@nvidia.com>

[ Upstream commit 3a1a274e933fca73fdc960cb1f60636cd285a265 ]

This patch adds logic to compute the MDIO period based on
the i1clk, and thereafter write the MDIO period into the YU
MDIO config register. The i1clk resource from the ACPI table
is used to provide addressing to YU bootrecord PLL registers.
The values in these registers are used to compute MDIO period.
If the i1clk resource is not present in the ACPI table, then
the current default hardcorded value of 430Mhz is used.
The i1clk clock value of 430MHz is only accurate for boards
with BF2 mid bin and main bin SoCs. The BF2 high bin SoCs
have i1clk = 500MHz, but can support a slower MDIO period.

Fixes: f92e1869d74e ("Add Mellanox BlueField Gigabit Ethernet driver")
Reviewed-by: Asmaa Mnebhi <asmaa@nvidia.com>
Signed-off-by: David Thompson <davthompson@nvidia.com>
Link: https://lore.kernel.org/r/20220826155916.12491-1-davthompson@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/mellanox/mlxbf_gige/mlxbf_gige.h |   4 +-
 .../mellanox/mlxbf_gige/mlxbf_gige_mdio.c     | 122 +++++++++++++++---
 .../mellanox/mlxbf_gige/mlxbf_gige_regs.h     |   2 +
 3 files changed, 110 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige.h b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige.h
index e3509e69ed1c6..3e8725b7f0b70 100644
--- a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige.h
+++ b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige.h
@@ -80,6 +80,7 @@ struct mlxbf_gige {
 	struct net_device *netdev;
 	struct platform_device *pdev;
 	void __iomem *mdio_io;
+	void __iomem *clk_io;
 	struct mii_bus *mdiobus;
 	void __iomem *gpio_io;
 	struct irq_domain *irqdomain;
@@ -149,7 +150,8 @@ enum mlxbf_gige_res {
 	MLXBF_GIGE_RES_MDIO9,
 	MLXBF_GIGE_RES_GPIO0,
 	MLXBF_GIGE_RES_LLU,
-	MLXBF_GIGE_RES_PLU
+	MLXBF_GIGE_RES_PLU,
+	MLXBF_GIGE_RES_CLK
 };
 
 /* Version of register data returned by mlxbf_gige_get_regs() */
diff --git a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_mdio.c b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_mdio.c
index 7905179a95753..f979ba7e5effc 100644
--- a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_mdio.c
+++ b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_mdio.c
@@ -22,10 +22,23 @@
 #include <linux/property.h>
 
 #include "mlxbf_gige.h"
+#include "mlxbf_gige_regs.h"
 
 #define MLXBF_GIGE_MDIO_GW_OFFSET	0x0
 #define MLXBF_GIGE_MDIO_CFG_OFFSET	0x4
 
+#define MLXBF_GIGE_MDIO_FREQ_REFERENCE 156250000ULL
+#define MLXBF_GIGE_MDIO_COREPLL_CONST  16384ULL
+#define MLXBF_GIGE_MDC_CLK_NS          400
+#define MLXBF_GIGE_MDIO_PLL_I1CLK_REG1 0x4
+#define MLXBF_GIGE_MDIO_PLL_I1CLK_REG2 0x8
+#define MLXBF_GIGE_MDIO_CORE_F_SHIFT   0
+#define MLXBF_GIGE_MDIO_CORE_F_MASK    GENMASK(25, 0)
+#define MLXBF_GIGE_MDIO_CORE_R_SHIFT   26
+#define MLXBF_GIGE_MDIO_CORE_R_MASK    GENMASK(31, 26)
+#define MLXBF_GIGE_MDIO_CORE_OD_SHIFT  0
+#define MLXBF_GIGE_MDIO_CORE_OD_MASK   GENMASK(3, 0)
+
 /* Support clause 22 */
 #define MLXBF_GIGE_MDIO_CL22_ST1	0x1
 #define MLXBF_GIGE_MDIO_CL22_WRITE	0x1
@@ -50,27 +63,76 @@
 #define MLXBF_GIGE_MDIO_CFG_MDIO_IN_SAMP_MASK		GENMASK(23, 16)
 #define MLXBF_GIGE_MDIO_CFG_MDIO_OUT_SAMP_MASK		GENMASK(31, 24)
 
+#define MLXBF_GIGE_MDIO_CFG_VAL (FIELD_PREP(MLXBF_GIGE_MDIO_CFG_MDIO_MODE_MASK, 1) | \
+				 FIELD_PREP(MLXBF_GIGE_MDIO_CFG_MDIO3_3_MASK, 1) | \
+				 FIELD_PREP(MLXBF_GIGE_MDIO_CFG_MDIO_FULL_DRIVE_MASK, 1) | \
+				 FIELD_PREP(MLXBF_GIGE_MDIO_CFG_MDIO_IN_SAMP_MASK, 6) | \
+				 FIELD_PREP(MLXBF_GIGE_MDIO_CFG_MDIO_OUT_SAMP_MASK, 13))
+
+#define MLXBF_GIGE_BF2_COREPLL_ADDR 0x02800c30
+#define MLXBF_GIGE_BF2_COREPLL_SIZE 0x0000000c
+
+static struct resource corepll_params[] = {
+	[MLXBF_GIGE_VERSION_BF2] = {
+		.start = MLXBF_GIGE_BF2_COREPLL_ADDR,
+		.end = MLXBF_GIGE_BF2_COREPLL_ADDR + MLXBF_GIGE_BF2_COREPLL_SIZE - 1,
+		.name = "COREPLL_RES"
+	},
+};
+
+/* Returns core clock i1clk in Hz */
+static u64 calculate_i1clk(struct mlxbf_gige *priv)
+{
+	u8 core_od, core_r;
+	u64 freq_output;
+	u32 reg1, reg2;
+	u32 core_f;
+
+	reg1 = readl(priv->clk_io + MLXBF_GIGE_MDIO_PLL_I1CLK_REG1);
+	reg2 = readl(priv->clk_io + MLXBF_GIGE_MDIO_PLL_I1CLK_REG2);
+
+	core_f = (reg1 & MLXBF_GIGE_MDIO_CORE_F_MASK) >>
+		MLXBF_GIGE_MDIO_CORE_F_SHIFT;
+	core_r = (reg1 & MLXBF_GIGE_MDIO_CORE_R_MASK) >>
+		MLXBF_GIGE_MDIO_CORE_R_SHIFT;
+	core_od = (reg2 & MLXBF_GIGE_MDIO_CORE_OD_MASK) >>
+		MLXBF_GIGE_MDIO_CORE_OD_SHIFT;
+
+	/* Compute PLL output frequency as follow:
+	 *
+	 *                                     CORE_F / 16384
+	 * freq_output = freq_reference * ----------------------------
+	 *                              (CORE_R + 1) * (CORE_OD + 1)
+	 */
+	freq_output = div_u64((MLXBF_GIGE_MDIO_FREQ_REFERENCE * core_f),
+			      MLXBF_GIGE_MDIO_COREPLL_CONST);
+	freq_output = div_u64(freq_output, (core_r + 1) * (core_od + 1));
+
+	return freq_output;
+}
+
 /* Formula for encoding the MDIO period. The encoded value is
  * passed to the MDIO config register.
  *
- * mdc_clk = 2*(val + 1)*i1clk
+ * mdc_clk = 2*(val + 1)*(core clock in sec)
  *
- * 400 ns = 2*(val + 1)*(((1/430)*1000) ns)
+ * i1clk is in Hz:
+ * 400 ns = 2*(val + 1)*(1/i1clk)
  *
- * val = (((400 * 430 / 1000) / 2) - 1)
+ * val = (((400/10^9) / (1/i1clk) / 2) - 1)
+ * val = (400/2 * i1clk)/10^9 - 1
  */
-#define MLXBF_GIGE_I1CLK_MHZ		430
-#define MLXBF_GIGE_MDC_CLK_NS		400
+static u8 mdio_period_map(struct mlxbf_gige *priv)
+{
+	u8 mdio_period;
+	u64 i1clk;
 
-#define MLXBF_GIGE_MDIO_PERIOD	(((MLXBF_GIGE_MDC_CLK_NS * MLXBF_GIGE_I1CLK_MHZ / 1000) / 2) - 1)
+	i1clk = calculate_i1clk(priv);
 
-#define MLXBF_GIGE_MDIO_CFG_VAL (FIELD_PREP(MLXBF_GIGE_MDIO_CFG_MDIO_MODE_MASK, 1) | \
-				 FIELD_PREP(MLXBF_GIGE_MDIO_CFG_MDIO3_3_MASK, 1) | \
-				 FIELD_PREP(MLXBF_GIGE_MDIO_CFG_MDIO_FULL_DRIVE_MASK, 1) | \
-				 FIELD_PREP(MLXBF_GIGE_MDIO_CFG_MDC_PERIOD_MASK, \
-					    MLXBF_GIGE_MDIO_PERIOD) | \
-				 FIELD_PREP(MLXBF_GIGE_MDIO_CFG_MDIO_IN_SAMP_MASK, 6) | \
-				 FIELD_PREP(MLXBF_GIGE_MDIO_CFG_MDIO_OUT_SAMP_MASK, 13))
+	mdio_period = div_u64((MLXBF_GIGE_MDC_CLK_NS >> 1) * i1clk, 1000000000) - 1;
+
+	return mdio_period;
+}
 
 static u32 mlxbf_gige_mdio_create_cmd(u16 data, int phy_add,
 				      int phy_reg, u32 opcode)
@@ -123,9 +185,9 @@ static int mlxbf_gige_mdio_write(struct mii_bus *bus, int phy_add,
 				 int phy_reg, u16 val)
 {
 	struct mlxbf_gige *priv = bus->priv;
+	u32 temp;
 	u32 cmd;
 	int ret;
-	u32 temp;
 
 	if (phy_reg & MII_ADDR_C45)
 		return -EOPNOTSUPP;
@@ -142,18 +204,44 @@ static int mlxbf_gige_mdio_write(struct mii_bus *bus, int phy_add,
 	return ret;
 }
 
+static void mlxbf_gige_mdio_cfg(struct mlxbf_gige *priv)
+{
+	u8 mdio_period;
+	u32 val;
+
+	mdio_period = mdio_period_map(priv);
+
+	val = MLXBF_GIGE_MDIO_CFG_VAL;
+	val |= FIELD_PREP(MLXBF_GIGE_MDIO_CFG_MDC_PERIOD_MASK, mdio_period);
+	writel(val, priv->mdio_io + MLXBF_GIGE_MDIO_CFG_OFFSET);
+}
+
 int mlxbf_gige_mdio_probe(struct platform_device *pdev, struct mlxbf_gige *priv)
 {
 	struct device *dev = &pdev->dev;
+	struct resource *res;
 	int ret;
 
 	priv->mdio_io = devm_platform_ioremap_resource(pdev, MLXBF_GIGE_RES_MDIO9);
 	if (IS_ERR(priv->mdio_io))
 		return PTR_ERR(priv->mdio_io);
 
-	/* Configure mdio parameters */
-	writel(MLXBF_GIGE_MDIO_CFG_VAL,
-	       priv->mdio_io + MLXBF_GIGE_MDIO_CFG_OFFSET);
+	/* clk resource shared with other drivers so cannot use
+	 * devm_platform_ioremap_resource
+	 */
+	res = platform_get_resource(pdev, IORESOURCE_MEM, MLXBF_GIGE_RES_CLK);
+	if (!res) {
+		/* For backward compatibility with older ACPI tables, also keep
+		 * CLK resource internal to the driver.
+		 */
+		res = &corepll_params[MLXBF_GIGE_VERSION_BF2];
+	}
+
+	priv->clk_io = devm_ioremap(dev, res->start, resource_size(res));
+	if (IS_ERR(priv->clk_io))
+		return PTR_ERR(priv->clk_io);
+
+	mlxbf_gige_mdio_cfg(priv);
 
 	priv->mdiobus = devm_mdiobus_alloc(dev);
 	if (!priv->mdiobus) {
diff --git a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_regs.h b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_regs.h
index 5fb33c9294bf9..7be3a793984d5 100644
--- a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_regs.h
+++ b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_regs.h
@@ -8,6 +8,8 @@
 #ifndef __MLXBF_GIGE_REGS_H__
 #define __MLXBF_GIGE_REGS_H__
 
+#define MLXBF_GIGE_VERSION                            0x0000
+#define MLXBF_GIGE_VERSION_BF2                        0x0
 #define MLXBF_GIGE_STATUS                             0x0010
 #define MLXBF_GIGE_STATUS_READY                       BIT(0)
 #define MLXBF_GIGE_INT_STATUS                         0x0028
-- 
2.35.1



