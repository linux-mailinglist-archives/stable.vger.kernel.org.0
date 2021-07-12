Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 815473C5109
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:47:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345120AbhGLHgM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:36:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:57120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243388AbhGLHdl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:33:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5DAE1613EF;
        Mon, 12 Jul 2021 07:30:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626075052;
        bh=cCaHq6CVgc2+qPYkCFeNf+SGf9cFkSQ4IsxZvgXUYTY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K1s3lT1zRCGhdkD8WW/4DyKWFJordcbw/KRnha5IZtFDU9BuzQiC8iJFSk327mIhN
         aC17wkVvoMP/L5F6106AtLTyZkshkMFPVaZbLdN36beeQmusnlcdTcw/uU8AlZeJye
         Fp+kkfiPc2QgXsEofTWvCJJ+v6/I0zWWm8rZRVco=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinh Nguyen <dinguyen@kernel.org>,
        Stephen Boyd <sboyd@kernel.org>
Subject: [PATCH 5.13 089/800] clk: agilex/stratix10: add support for the 2nd bypass
Date:   Mon, 12 Jul 2021 08:01:52 +0200
Message-Id: <20210712060925.564180537@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dinh Nguyen <dinguyen@kernel.org>

commit c2c9c5661a48bf2e67dcb4e989003144304acd6a upstream.

The EMAC clocks on Stratix10/Agilex/N5X have an additional bypass that
was not being accounted for. The bypass selects between
emaca_clk/emacb_clk and boot_clk.

Because the bypass register offset is different between Stratix10 and
Agilex/N5X, it's best to create a new function to calculate the bypass.

Fixes: 80c6b7a0894f ("clk: socfpga: agilex: add clock driver for the Agilex platform")
Cc: stable@vger.kernel.org
Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
Link: https://lore.kernel.org/r/20210611025201.118799-3-dinguyen@kernel.org
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/clk/socfpga/clk-agilex.c    |    4 -
 drivers/clk/socfpga/clk-gate-s10.c  |  119 +++++++++++++++++++++++++++++++++++-
 drivers/clk/socfpga/stratix10-clk.h |    2 
 3 files changed, 123 insertions(+), 2 deletions(-)

--- a/drivers/clk/socfpga/clk-agilex.c
+++ b/drivers/clk/socfpga/clk-agilex.c
@@ -177,6 +177,8 @@ static const struct clk_parent_data emac
 	  .name = "emaca_free_clk", },
 	{ .fw_name = "emacb_free_clk",
 	  .name = "emacb_free_clk", },
+	{ .fw_name = "boot_clk",
+	  .name = "boot_clk", },
 };
 
 static const struct clk_parent_data noc_mux[] = {
@@ -399,7 +401,7 @@ static int agilex_clk_register_gate(cons
 	int i;
 
 	for (i = 0; i < nums; i++) {
-		hw_clk = s10_register_gate(&clks[i], base);
+		hw_clk = agilex_register_gate(&clks[i], base);
 		if (IS_ERR(hw_clk)) {
 			pr_err("%s: failed to register clock %s\n",
 			       __func__, clks[i].name);
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
@@ -44,14 +51,61 @@ static unsigned long socfpga_dbg_clk_rec
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
@@ -106,6 +165,64 @@ struct clk_hw *s10_register_gate(const s
 
 	init.name = clks->name;
 	init.flags = clks->flags;
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
 
 	init.num_parents = clks->num_parents;
 	init.parent_names = parent_name ? &parent_name : NULL;
--- a/drivers/clk/socfpga/stratix10-clk.h
+++ b/drivers/clk/socfpga/stratix10-clk.h
@@ -85,4 +85,6 @@ struct clk_hw *s10_register_cnt_periph(c
 				    void __iomem *reg);
 struct clk_hw *s10_register_gate(const struct stratix10_gate_clock *clks,
 			      void __iomem *reg);
+struct clk_hw *agilex_register_gate(const struct stratix10_gate_clock *clks,
+			      void __iomem *reg);
 #endif	/* __STRATIX10_CLK_H */


