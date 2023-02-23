Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C48B06A0A1A
	for <lists+stable@lfdr.de>; Thu, 23 Feb 2023 14:13:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234517AbjBWNNL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Feb 2023 08:13:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234518AbjBWNNG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Feb 2023 08:13:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 076F9570A9
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 05:12:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 25F79B81A25
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 13:12:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CEC4C433EF;
        Thu, 23 Feb 2023 13:12:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677157924;
        bh=Vdj7COWgsmffgml7LP3Sgxoo+HJuXuTalqEHCG9V6B0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GUp/OTZzTQF2HdrgXd0NlZhjrz6JWplDRQmVIhIJs7DlvI3xaIA04fSvhXX9kdnte
         m1rrD9CMk/bQgLQz3/F8G6/paX+JtOWUHOl/m7pjfOWpTqUQuHD+Ybe6CHaupjvulY
         2lHzOV8Z5CUmaLSHzl1bSKwVYGulSkiw6Gz+vVdI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yi xin Zhu <yzhu@maxlinear.com>,
        Rahul Tanwar <rtanwar@maxlinear.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 04/36] clk: mxl: Switch from direct readl/writel based IO to regmap based IO
Date:   Thu, 23 Feb 2023 14:06:40 +0100
Message-Id: <20230223130429.277358829@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230223130429.072633724@linuxfoundation.org>
References: <20230223130429.072633724@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rahul Tanwar <rtanwar@maxlinear.com>

[ Upstream commit 036177310bac5534de44ff6a7b60a4d2c0b6567c ]

Earlier version of driver used direct io remapped register read
writes using readl/writel. But we need secure boot access which
is only possible when registers are read & written using regmap.
This is because the security bus/hook is written & coupled only
with regmap layer.

Switch the driver from direct readl/writel based register accesses
to regmap based register accesses.

Additionally, update the license headers to latest status.

Reviewed-by: Yi xin Zhu <yzhu@maxlinear.com>
Signed-off-by: Rahul Tanwar <rtanwar@maxlinear.com>
Link: https://lore.kernel.org/r/2610331918206e0e3bd18babb39393a558fb34f9.1665642720.git.rtanwar@maxlinear.com
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Stable-dep-of: 106ef3bda210 ("clk: mxl: Fix a clk entry by adding relevant flags")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/x86/Kconfig       |  5 +++--
 drivers/clk/x86/clk-cgu-pll.c | 10 +++++----
 drivers/clk/x86/clk-cgu.c     |  5 +++--
 drivers/clk/x86/clk-cgu.h     | 38 +++++++++++++++++++----------------
 drivers/clk/x86/clk-lgm.c     | 13 ++++++++----
 5 files changed, 42 insertions(+), 29 deletions(-)

diff --git a/drivers/clk/x86/Kconfig b/drivers/clk/x86/Kconfig
index 69642e15fcc1f..ced99e082e3dd 100644
--- a/drivers/clk/x86/Kconfig
+++ b/drivers/clk/x86/Kconfig
@@ -1,8 +1,9 @@
 # SPDX-License-Identifier: GPL-2.0-only
 config CLK_LGM_CGU
 	depends on OF && HAS_IOMEM && (X86 || COMPILE_TEST)
+	select MFD_SYSCON
 	select OF_EARLY_FLATTREE
 	bool "Clock driver for Lightning Mountain(LGM) platform"
 	help
-	  Clock Generation Unit(CGU) driver for Intel Lightning Mountain(LGM)
-	  network processor SoC.
+	  Clock Generation Unit(CGU) driver for MaxLinear's x86 based
+	  Lightning Mountain(LGM) network processor SoC.
diff --git a/drivers/clk/x86/clk-cgu-pll.c b/drivers/clk/x86/clk-cgu-pll.c
index 3179557b5f784..c83083affe88e 100644
--- a/drivers/clk/x86/clk-cgu-pll.c
+++ b/drivers/clk/x86/clk-cgu-pll.c
@@ -1,8 +1,9 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
+ * Copyright (C) 2020-2022 MaxLinear, Inc.
  * Copyright (C) 2020 Intel Corporation.
- * Zhu YiXin <yixin.zhu@intel.com>
- * Rahul Tanwar <rahul.tanwar@intel.com>
+ * Zhu Yixin <yzhu@maxlinear.com>
+ * Rahul Tanwar <rtanwar@maxlinear.com>
  */
 
 #include <linux/clk-provider.h>
@@ -76,8 +77,9 @@ static int lgm_pll_enable(struct clk_hw *hw)
 
 	spin_lock_irqsave(&pll->lock, flags);
 	lgm_set_clk_val(pll->membase, pll->reg, 0, 1, 1);
-	ret = readl_poll_timeout_atomic(pll->membase + pll->reg,
-					val, (val & 0x1), 1, 100);
+	ret = regmap_read_poll_timeout_atomic(pll->membase, pll->reg,
+					      val, (val & 0x1), 1, 100);
+
 	spin_unlock_irqrestore(&pll->lock, flags);
 
 	return ret;
diff --git a/drivers/clk/x86/clk-cgu.c b/drivers/clk/x86/clk-cgu.c
index 33de600e0c38e..f5f30a18f4869 100644
--- a/drivers/clk/x86/clk-cgu.c
+++ b/drivers/clk/x86/clk-cgu.c
@@ -1,8 +1,9 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
+ * Copyright (C) 2020-2022 MaxLinear, Inc.
  * Copyright (C) 2020 Intel Corporation.
- * Zhu YiXin <yixin.zhu@intel.com>
- * Rahul Tanwar <rahul.tanwar@intel.com>
+ * Zhu Yixin <yzhu@maxlinear.com>
+ * Rahul Tanwar <rtanwar@maxlinear.com>
  */
 #include <linux/clk-provider.h>
 #include <linux/device.h>
diff --git a/drivers/clk/x86/clk-cgu.h b/drivers/clk/x86/clk-cgu.h
index 4e22bfb223128..dbcb664687975 100644
--- a/drivers/clk/x86/clk-cgu.h
+++ b/drivers/clk/x86/clk-cgu.h
@@ -1,18 +1,19 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 /*
- * Copyright(c) 2020 Intel Corporation.
- * Zhu YiXin <yixin.zhu@intel.com>
- * Rahul Tanwar <rahul.tanwar@intel.com>
+ * Copyright (C) 2020-2022 MaxLinear, Inc.
+ * Copyright (C) 2020 Intel Corporation.
+ * Zhu Yixin <yzhu@maxlinear.com>
+ * Rahul Tanwar <rtanwar@maxlinear.com>
  */
 
 #ifndef __CLK_CGU_H
 #define __CLK_CGU_H
 
-#include <linux/io.h>
+#include <linux/regmap.h>
 
 struct lgm_clk_mux {
 	struct clk_hw hw;
-	void __iomem *membase;
+	struct regmap *membase;
 	unsigned int reg;
 	u8 shift;
 	u8 width;
@@ -22,7 +23,7 @@ struct lgm_clk_mux {
 
 struct lgm_clk_divider {
 	struct clk_hw hw;
-	void __iomem *membase;
+	struct regmap *membase;
 	unsigned int reg;
 	u8 shift;
 	u8 width;
@@ -35,7 +36,7 @@ struct lgm_clk_divider {
 
 struct lgm_clk_ddiv {
 	struct clk_hw hw;
-	void __iomem *membase;
+	struct regmap *membase;
 	unsigned int reg;
 	u8 shift0;
 	u8 width0;
@@ -53,7 +54,7 @@ struct lgm_clk_ddiv {
 
 struct lgm_clk_gate {
 	struct clk_hw hw;
-	void __iomem *membase;
+	struct regmap *membase;
 	unsigned int reg;
 	u8 shift;
 	unsigned long flags;
@@ -77,7 +78,7 @@ enum lgm_clk_type {
  * @clk_data: array of hw clocks and clk number.
  */
 struct lgm_clk_provider {
-	void __iomem *membase;
+	struct regmap *membase;
 	struct device_node *np;
 	struct device *dev;
 	struct clk_hw_onecell_data clk_data;
@@ -92,7 +93,7 @@ enum pll_type {
 
 struct lgm_clk_pll {
 	struct clk_hw hw;
-	void __iomem *membase;
+	struct regmap *membase;
 	unsigned int reg;
 	unsigned long flags;
 	enum pll_type type;
@@ -300,29 +301,32 @@ struct lgm_clk_branch {
 		.div = _d,					\
 	}
 
-static inline void lgm_set_clk_val(void __iomem *membase, u32 reg,
+static inline void lgm_set_clk_val(struct regmap *membase, u32 reg,
 				   u8 shift, u8 width, u32 set_val)
 {
 	u32 mask = (GENMASK(width - 1, 0) << shift);
-	u32 regval;
 
-	regval = readl(membase + reg);
-	regval = (regval & ~mask) | ((set_val << shift) & mask);
-	writel(regval, membase + reg);
+	regmap_update_bits(membase, reg, mask, set_val << shift);
 }
 
-static inline u32 lgm_get_clk_val(void __iomem *membase, u32 reg,
+static inline u32 lgm_get_clk_val(struct regmap *membase, u32 reg,
 				  u8 shift, u8 width)
 {
 	u32 mask = (GENMASK(width - 1, 0) << shift);
 	u32 val;
 
-	val = readl(membase + reg);
+	if (regmap_read(membase, reg, &val)) {
+		WARN_ONCE(1, "Failed to read clk reg: 0x%x\n", reg);
+		return 0;
+	}
+
 	val = (val & mask) >> shift;
 
 	return val;
 }
 
+
+
 int lgm_clk_register_branches(struct lgm_clk_provider *ctx,
 			      const struct lgm_clk_branch *list,
 			      unsigned int nr_clk);
diff --git a/drivers/clk/x86/clk-lgm.c b/drivers/clk/x86/clk-lgm.c
index 020f4e83a5ccb..4fa2bcaf71c89 100644
--- a/drivers/clk/x86/clk-lgm.c
+++ b/drivers/clk/x86/clk-lgm.c
@@ -1,10 +1,12 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
+ * Copyright (C) 2020-2022 MaxLinear, Inc.
  * Copyright (C) 2020 Intel Corporation.
- * Zhu YiXin <yixin.zhu@intel.com>
- * Rahul Tanwar <rahul.tanwar@intel.com>
+ * Zhu Yixin <yzhu@maxlinear.com>
+ * Rahul Tanwar <rtanwar@maxlinear.com>
  */
 #include <linux/clk-provider.h>
+#include <linux/mfd/syscon.h>
 #include <linux/of.h>
 #include <linux/platform_device.h>
 #include <dt-bindings/clock/intel,lgm-clk.h>
@@ -433,9 +435,12 @@ static int lgm_cgu_probe(struct platform_device *pdev)
 
 	ctx->clk_data.num = CLK_NR_CLKS;
 
-	ctx->membase = devm_platform_ioremap_resource(pdev, 0);
-	if (IS_ERR(ctx->membase))
+	ctx->membase = syscon_node_to_regmap(np);
+	if (IS_ERR_OR_NULL(ctx->membase)) {
+		dev_err(dev, "Failed to get clk CGU iomem\n");
 		return PTR_ERR(ctx->membase);
+	}
+
 
 	ctx->np = np;
 	ctx->dev = dev;
-- 
2.39.0



