Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 680403A39F0
	for <lists+stable@lfdr.de>; Fri, 11 Jun 2021 04:52:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230435AbhFKCyN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Jun 2021 22:54:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:60012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230385AbhFKCyL (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Jun 2021 22:54:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B41DA610A2;
        Fri, 11 Jun 2021 02:52:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623379934;
        bh=o5Lkdx8mDm48NWiHXJOmkWuT5EXZjoTPdnTh15gHldM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lYqXQflZsP1MNeOcTnOwY/Qv5xRk9ZCuTUgscxGgn036/4PgB1mDXIeW4UADsWL5W
         qCR+Vc4Y2TQYaHyVfzCbuOTAuWAsNCYqHC4vN/Ep+NfFRreZbyZgCRyg4CQNMzdB8R
         vgwCVj6oBkOPBNlY47FIJLf4m+o9phVSRrmLAxeM1x6z/We0qvEvAaFMhYAGwIaCI8
         wA+vxteG5/O/1TGn3FDuRcb19rj2P2qBoGobkXfFzSbpUJrK+ymAE4vxrqgPtWJLD6
         kTRCSIn0LisjUzERcp59EUH+x/7N9zArS3iJHvmfsoD3UQgzm8kMEIXxTs/HUvqDiy
         jEWQglU/YEglA==
From:   Dinh Nguyen <dinguyen@kernel.org>
To:     linux-clk@vger.kernel.org
Cc:     dinguyen@kernel.org, sboyd@kernel.org, mturquette@baylibre.com,
        stable@vger.kernel.org
Subject: [PATCHv3 3/4] clk: agilex/stratix10: add support for the 2nd bypass
Date:   Thu, 10 Jun 2021 21:52:00 -0500
Message-Id: <20210611025201.118799-3-dinguyen@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210611025201.118799-1-dinguyen@kernel.org>
References: <20210611025201.118799-1-dinguyen@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The EMAC clocks on Stratix10/Agilex/N5X have an additional bypass that
was not being accounted for. The bypass selects between
emaca_clk/emacb_clk and boot_clk.

Because the bypass register offset is different between Stratix10 and
Agilex/N5X, it's best to create a new function to calculate the bypass.

Fixes: 80c6b7a0894f ("clk: socfpga: agilex: add clock driver for the Agilex platform")
Cc: stable@vger.kernel.org
Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
---
v3: no change
v2: add linux-stable in cc
---
 drivers/clk/socfpga/clk-agilex.c    |   4 +-
 drivers/clk/socfpga/clk-gate-s10.c  | 119 +++++++++++++++++++++++++++-
 drivers/clk/socfpga/stratix10-clk.h |   2 +
 3 files changed, 123 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/socfpga/clk-agilex.c b/drivers/clk/socfpga/clk-agilex.c
index edfa87d0cd76..1cb21ea79c64 100644
--- a/drivers/clk/socfpga/clk-agilex.c
+++ b/drivers/clk/socfpga/clk-agilex.c
@@ -177,6 +177,8 @@ static const struct clk_parent_data emac_mux[] = {
 	  .name = "emaca_free_clk", },
 	{ .fw_name = "emacb_free_clk",
 	  .name = "emacb_free_clk", },
+	{ .fw_name = "boot_clk",
+	  .name = "boot_clk", },
 };
 
 static const struct clk_parent_data noc_mux[] = {
@@ -399,7 +401,7 @@ static int agilex_clk_register_gate(const struct stratix10_gate_clock *clks,
 	int i;
 
 	for (i = 0; i < nums; i++) {
-		hw_clk = s10_register_gate(&clks[i], base);
+		hw_clk = agilex_register_gate(&clks[i], base);
 		if (IS_ERR(hw_clk)) {
 			pr_err("%s: failed to register clock %s\n",
 			       __func__, clks[i].name);
diff --git a/drivers/clk/socfpga/clk-gate-s10.c b/drivers/clk/socfpga/clk-gate-s10.c
index b84f2627551e..32567795765f 100644
--- a/drivers/clk/socfpga/clk-gate-s10.c
+++ b/drivers/clk/socfpga/clk-gate-s10.c
@@ -11,6 +11,13 @@
 #define SOCFPGA_CS_PDBG_CLK	"cs_pdbg_clk"
 #define to_socfpga_gate_clk(p) container_of(p, struct socfpga_gate_clk, hw.hw)
 
+#define SOCFPGA_EMAC0_CLK		"emac0_clk"
+#define SOCFPGA_EMAC1_CLK		"emac1_clk"
+#define SOCFPGA_EMAC2_CLK		"emac2_clk"
+#define AGILEX_BYPASS_OFFSET		0xC
+#define STRATIX10_BYPASS_OFFSET		0x2C
+#define BOOTCLK_BYPASS			2
+
 static unsigned long socfpga_gate_clk_recalc_rate(struct clk_hw *hwclk,
 						  unsigned long parent_rate)
 {
@@ -44,14 +51,61 @@ static unsigned long socfpga_dbg_clk_recalc_rate(struct clk_hw *hwclk,
 static u8 socfpga_gate_get_parent(struct clk_hw *hwclk)
 {
 	struct socfpga_gate_clk *socfpgaclk = to_socfpga_gate_clk(hwclk);
-	u32 mask;
+	u32 mask, second_bypass;
+	u8 parent = 0;
+	const char *name = clk_hw_get_name(hwclk);
+
+	if (socfpgaclk->bypass_reg) {
+		mask = (0x1 << socfpgaclk->bypass_shift);
+		parent = ((readl(socfpgaclk->bypass_reg) & mask) >>
+			  socfpgaclk->bypass_shift);
+	}
+
+	if (streq(name, SOCFPGA_EMAC0_CLK) ||
+	    streq(name, SOCFPGA_EMAC1_CLK) ||
+	    streq(name, SOCFPGA_EMAC2_CLK)) {
+		second_bypass = readl(socfpgaclk->bypass_reg -
+				      STRATIX10_BYPASS_OFFSET);
+		/* EMACA bypass to bootclk @0xB0 offset */
+		if (second_bypass & 0x1)
+			if (parent == 0) /* only applicable if parent is maca */
+				parent = BOOTCLK_BYPASS;
+
+		if (second_bypass & 0x2)
+			if (parent == 1) /* only applicable if parent is macb */
+				parent = BOOTCLK_BYPASS;
+	}
+	return parent;
+}
+
+static u8 socfpga_agilex_gate_get_parent(struct clk_hw *hwclk)
+{
+	struct socfpga_gate_clk *socfpgaclk = to_socfpga_gate_clk(hwclk);
+	u32 mask, second_bypass;
 	u8 parent = 0;
+	const char *name = clk_hw_get_name(hwclk);
 
 	if (socfpgaclk->bypass_reg) {
 		mask = (0x1 << socfpgaclk->bypass_shift);
 		parent = ((readl(socfpgaclk->bypass_reg) & mask) >>
 			  socfpgaclk->bypass_shift);
 	}
+
+	if (streq(name, SOCFPGA_EMAC0_CLK) ||
+	    streq(name, SOCFPGA_EMAC1_CLK) ||
+	    streq(name, SOCFPGA_EMAC2_CLK)) {
+		second_bypass = readl(socfpgaclk->bypass_reg -
+				      AGILEX_BYPASS_OFFSET);
+		/* EMACA bypass to bootclk @0x88 offset */
+		if (second_bypass & 0x1)
+			if (parent == 0) /* only applicable if parent is maca */
+				parent = BOOTCLK_BYPASS;
+
+		if (second_bypass & 0x2)
+			if (parent == 1) /* only applicable if parent is macb */
+				parent = BOOTCLK_BYPASS;
+	}
+
 	return parent;
 }
 
@@ -60,6 +114,11 @@ static struct clk_ops gateclk_ops = {
 	.get_parent = socfpga_gate_get_parent,
 };
 
+static const struct clk_ops agilex_gateclk_ops = {
+	.recalc_rate = socfpga_gate_clk_recalc_rate,
+	.get_parent = socfpga_agilex_gate_get_parent,
+};
+
 static const struct clk_ops dbgclk_ops = {
 	.recalc_rate = socfpga_dbg_clk_recalc_rate,
 	.get_parent = socfpga_gate_get_parent,
@@ -122,3 +181,61 @@ struct clk_hw *s10_register_gate(const struct stratix10_gate_clock *clks, void _
 	}
 	return hw_clk;
 }
+
+struct clk_hw *agilex_register_gate(const struct stratix10_gate_clock *clks, void __iomem *regbase)
+{
+	struct clk_hw *hw_clk;
+	struct socfpga_gate_clk *socfpga_clk;
+	struct clk_init_data init;
+	const char *parent_name = clks->parent_name;
+	int ret;
+
+	socfpga_clk = kzalloc(sizeof(*socfpga_clk), GFP_KERNEL);
+	if (!socfpga_clk)
+		return NULL;
+
+	socfpga_clk->hw.reg = regbase + clks->gate_reg;
+	socfpga_clk->hw.bit_idx = clks->gate_idx;
+
+	gateclk_ops.enable = clk_gate_ops.enable;
+	gateclk_ops.disable = clk_gate_ops.disable;
+
+	socfpga_clk->fixed_div = clks->fixed_div;
+
+	if (clks->div_reg)
+		socfpga_clk->div_reg = regbase + clks->div_reg;
+	else
+		socfpga_clk->div_reg = NULL;
+
+	socfpga_clk->width = clks->div_width;
+	socfpga_clk->shift = clks->div_offset;
+
+	if (clks->bypass_reg)
+		socfpga_clk->bypass_reg = regbase + clks->bypass_reg;
+	else
+		socfpga_clk->bypass_reg = NULL;
+	socfpga_clk->bypass_shift = clks->bypass_shift;
+
+	if (streq(clks->name, "cs_pdbg_clk"))
+		init.ops = &dbgclk_ops;
+	else
+		init.ops = &agilex_gateclk_ops;
+
+	init.name = clks->name;
+	init.flags = clks->flags;
+
+	init.num_parents = clks->num_parents;
+	init.parent_names = parent_name ? &parent_name : NULL;
+	if (init.parent_names == NULL)
+		init.parent_data = clks->parent_data;
+	socfpga_clk->hw.hw.init = &init;
+
+	hw_clk = &socfpga_clk->hw.hw;
+
+	ret = clk_hw_register(NULL, &socfpga_clk->hw.hw);
+	if (ret) {
+		kfree(socfpga_clk);
+		return ERR_PTR(ret);
+	}
+	return hw_clk;
+}
diff --git a/drivers/clk/socfpga/stratix10-clk.h b/drivers/clk/socfpga/stratix10-clk.h
index 61eaf3a41fbb..75234e0783e1 100644
--- a/drivers/clk/socfpga/stratix10-clk.h
+++ b/drivers/clk/socfpga/stratix10-clk.h
@@ -85,4 +85,6 @@ struct clk_hw *s10_register_cnt_periph(const struct stratix10_perip_cnt_clock *c
 				    void __iomem *reg);
 struct clk_hw *s10_register_gate(const struct stratix10_gate_clock *clks,
 			      void __iomem *reg);
+struct clk_hw *agilex_register_gate(const struct stratix10_gate_clock *clks,
+			      void __iomem *reg);
 #endif	/* __STRATIX10_CLK_H */
-- 
2.25.1

