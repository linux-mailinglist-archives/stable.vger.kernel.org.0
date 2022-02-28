Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF6E14C7663
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 19:04:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235128AbiB1SEw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 13:04:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240763AbiB1SEA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 13:04:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31CF725EA3;
        Mon, 28 Feb 2022 09:47:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1E31860BAC;
        Mon, 28 Feb 2022 17:47:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D7B2C340E7;
        Mon, 28 Feb 2022 17:47:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646070426;
        bh=TaSq0yeK+b33MBxYUt2Y0AuI9BSRYo5QSHye+JRBEL0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=evQTNWcsCwzfB45JRYKkoh+ClsE6wPywI/HpBxAWbdVnKmbjQY9qgdkN5oly42Dor
         gK/CBYNWh5lK1pHJKKZ9eyrLgBiHjYe90VXIZYaYpniqRHMOe8oXuFvd8rgqYKiYRd
         M3sqTG625wA7B/9Ymbb9QY6AFUA7pakntcr7/4FY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Stephen Boyd <sboyd@kernel.org>
Subject: [PATCH 5.16 065/164] clk: qcom: gcc-msm8994: Remove NoC clocks
Date:   Mon, 28 Feb 2022 18:23:47 +0100
Message-Id: <20220228172406.070279719@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172359.567256961@linuxfoundation.org>
References: <20220228172359.567256961@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Konrad Dybcio <konrad.dybcio@somainline.org>

commit 3494894afff4ad11f25d8342cc99699be496d082 upstream.

Just like in commit 05cf3ec00d46 ("clk: qcom: gcc-msm8996: Drop (again)
gcc_aggre1_pnoc_ahb_clk") adding NoC clocks turned out to be a huge
mistake, as they cause a lot of issues at little benefit (basically
letting Linux know about their children's frequencies), especially when
mishandled or misconfigured.

Adding these ones broke SDCC approx 99 out of 100 times, but that somehow
went unnoticed. To prevent further issues like this one, remove them.

This commit is effectively a revert of 74a33fac3aab ("clk: qcom:
gcc-msm8994: Add missing NoC clocks") with ABI preservation.

Fixes: 74a33fac3aab ("clk: qcom: gcc-msm8994: Add missing NoC clocks")
Signed-off-by: Konrad Dybcio <konrad.dybcio@somainline.org>
Link: https://lore.kernel.org/r/20220217232408.78932-1-konrad.dybcio@somainline.org
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/qcom/gcc-msm8994.c |  106 +++--------------------------------------
 1 file changed, 9 insertions(+), 97 deletions(-)

--- a/drivers/clk/qcom/gcc-msm8994.c
+++ b/drivers/clk/qcom/gcc-msm8994.c
@@ -107,42 +107,6 @@ static const struct clk_parent_data gcc_
 	{ .hw = &gpll4.clkr.hw },
 };
 
-static struct clk_rcg2 system_noc_clk_src = {
-	.cmd_rcgr = 0x0120,
-	.hid_width = 5,
-	.parent_map = gcc_xo_gpll0_map,
-	.clkr.hw.init = &(struct clk_init_data){
-		.name = "system_noc_clk_src",
-		.parent_data = gcc_xo_gpll0,
-		.num_parents = ARRAY_SIZE(gcc_xo_gpll0),
-		.ops = &clk_rcg2_ops,
-	},
-};
-
-static struct clk_rcg2 config_noc_clk_src = {
-	.cmd_rcgr = 0x0150,
-	.hid_width = 5,
-	.parent_map = gcc_xo_gpll0_map,
-	.clkr.hw.init = &(struct clk_init_data){
-		.name = "config_noc_clk_src",
-		.parent_data = gcc_xo_gpll0,
-		.num_parents = ARRAY_SIZE(gcc_xo_gpll0),
-		.ops = &clk_rcg2_ops,
-	},
-};
-
-static struct clk_rcg2 periph_noc_clk_src = {
-	.cmd_rcgr = 0x0190,
-	.hid_width = 5,
-	.parent_map = gcc_xo_gpll0_map,
-	.clkr.hw.init = &(struct clk_init_data){
-		.name = "periph_noc_clk_src",
-		.parent_data = gcc_xo_gpll0,
-		.num_parents = ARRAY_SIZE(gcc_xo_gpll0),
-		.ops = &clk_rcg2_ops,
-	},
-};
-
 static struct freq_tbl ftbl_ufs_axi_clk_src[] = {
 	F(50000000, P_GPLL0, 12, 0, 0),
 	F(100000000, P_GPLL0, 6, 0, 0),
@@ -1149,8 +1113,6 @@ static struct clk_branch gcc_blsp1_ahb_c
 		.enable_mask = BIT(17),
 		.hw.init = &(struct clk_init_data){
 			.name = "gcc_blsp1_ahb_clk",
-			.parent_hws = (const struct clk_hw *[]){ &periph_noc_clk_src.clkr.hw },
-			.num_parents = 1,
 			.ops = &clk_branch2_ops,
 		},
 	},
@@ -1434,8 +1396,6 @@ static struct clk_branch gcc_blsp2_ahb_c
 		.enable_mask = BIT(15),
 		.hw.init = &(struct clk_init_data){
 			.name = "gcc_blsp2_ahb_clk",
-			.parent_hws = (const struct clk_hw *[]){ &periph_noc_clk_src.clkr.hw },
-			.num_parents = 1,
 			.ops = &clk_branch2_ops,
 		},
 	},
@@ -1763,8 +1723,6 @@ static struct clk_branch gcc_lpass_q6_ax
 		.enable_mask = BIT(0),
 		.hw.init = &(struct clk_init_data){
 			.name = "gcc_lpass_q6_axi_clk",
-			.parent_hws = (const struct clk_hw *[]){ &system_noc_clk_src.clkr.hw },
-			.num_parents = 1,
 			.ops = &clk_branch2_ops,
 		},
 	},
@@ -1777,8 +1735,6 @@ static struct clk_branch gcc_mss_q6_bimc
 		.enable_mask = BIT(0),
 		.hw.init = &(struct clk_init_data){
 			.name = "gcc_mss_q6_bimc_axi_clk",
-			.parent_hws = (const struct clk_hw *[]){ &system_noc_clk_src.clkr.hw },
-			.num_parents = 1,
 			.ops = &clk_branch2_ops,
 		},
 	},
@@ -1806,9 +1762,6 @@ static struct clk_branch gcc_pcie_0_cfg_
 		.enable_mask = BIT(0),
 		.hw.init = &(struct clk_init_data){
 			.name = "gcc_pcie_0_cfg_ahb_clk",
-			.parent_hws = (const struct clk_hw *[]){ &config_noc_clk_src.clkr.hw },
-			.num_parents = 1,
-			.flags = CLK_SET_RATE_PARENT,
 			.ops = &clk_branch2_ops,
 		},
 	},
@@ -1821,9 +1774,6 @@ static struct clk_branch gcc_pcie_0_mstr
 		.enable_mask = BIT(0),
 		.hw.init = &(struct clk_init_data){
 			.name = "gcc_pcie_0_mstr_axi_clk",
-			.parent_hws = (const struct clk_hw *[]){ &system_noc_clk_src.clkr.hw },
-			.num_parents = 1,
-			.flags = CLK_SET_RATE_PARENT,
 			.ops = &clk_branch2_ops,
 		},
 	},
@@ -1853,9 +1803,6 @@ static struct clk_branch gcc_pcie_0_slv_
 		.enable_mask = BIT(0),
 		.hw.init = &(struct clk_init_data){
 			.name = "gcc_pcie_0_slv_axi_clk",
-			.parent_hws = (const struct clk_hw *[]){ &system_noc_clk_src.clkr.hw },
-			.num_parents = 1,
-			.flags = CLK_SET_RATE_PARENT,
 			.ops = &clk_branch2_ops,
 		},
 	},
@@ -1883,9 +1830,6 @@ static struct clk_branch gcc_pcie_1_cfg_
 		.enable_mask = BIT(0),
 		.hw.init = &(struct clk_init_data){
 			.name = "gcc_pcie_1_cfg_ahb_clk",
-			.parent_hws = (const struct clk_hw *[]){ &config_noc_clk_src.clkr.hw },
-			.num_parents = 1,
-			.flags = CLK_SET_RATE_PARENT,
 			.ops = &clk_branch2_ops,
 		},
 	},
@@ -1898,9 +1842,6 @@ static struct clk_branch gcc_pcie_1_mstr
 		.enable_mask = BIT(0),
 		.hw.init = &(struct clk_init_data){
 			.name = "gcc_pcie_1_mstr_axi_clk",
-			.parent_hws = (const struct clk_hw *[]){ &system_noc_clk_src.clkr.hw },
-			.num_parents = 1,
-			.flags = CLK_SET_RATE_PARENT,
 			.ops = &clk_branch2_ops,
 		},
 	},
@@ -1929,9 +1870,6 @@ static struct clk_branch gcc_pcie_1_slv_
 		.enable_mask = BIT(0),
 		.hw.init = &(struct clk_init_data){
 			.name = "gcc_pcie_1_slv_axi_clk",
-			.parent_hws = (const struct clk_hw *[]){ &system_noc_clk_src.clkr.hw },
-			.num_parents = 1,
-			.flags = CLK_SET_RATE_PARENT,
 			.ops = &clk_branch2_ops,
 		},
 	},
@@ -1959,8 +1897,6 @@ static struct clk_branch gcc_pdm_ahb_clk
 		.enable_mask = BIT(0),
 		.hw.init = &(struct clk_init_data){
 			.name = "gcc_pdm_ahb_clk",
-			.parent_hws = (const struct clk_hw *[]){ &periph_noc_clk_src.clkr.hw },
-			.num_parents = 1,
 			.ops = &clk_branch2_ops,
 		},
 	},
@@ -1988,9 +1924,6 @@ static struct clk_branch gcc_sdcc1_ahb_c
 		.enable_mask = BIT(0),
 		.hw.init = &(struct clk_init_data){
 			.name = "gcc_sdcc1_ahb_clk",
-			.parent_hws = (const struct clk_hw *[]){ &periph_noc_clk_src.clkr.hw },
-			.num_parents = 1,
-			.flags = CLK_SET_RATE_PARENT,
 			.ops = &clk_branch2_ops,
 		},
 	},
@@ -2003,9 +1936,6 @@ static struct clk_branch gcc_sdcc2_ahb_c
 		.enable_mask = BIT(0),
 		.hw.init = &(struct clk_init_data){
 			.name = "gcc_sdcc2_ahb_clk",
-			.parent_hws = (const struct clk_hw *[]){ &periph_noc_clk_src.clkr.hw },
-			.num_parents = 1,
-			.flags = CLK_SET_RATE_PARENT,
 			.ops = &clk_branch2_ops,
 		},
 	},
@@ -2033,9 +1963,6 @@ static struct clk_branch gcc_sdcc3_ahb_c
 		.enable_mask = BIT(0),
 		.hw.init = &(struct clk_init_data){
 			.name = "gcc_sdcc3_ahb_clk",
-			.parent_hws = (const struct clk_hw *[]){ &periph_noc_clk_src.clkr.hw },
-			.num_parents = 1,
-			.flags = CLK_SET_RATE_PARENT,
 			.ops = &clk_branch2_ops,
 		},
 	},
@@ -2063,9 +1990,6 @@ static struct clk_branch gcc_sdcc4_ahb_c
 		.enable_mask = BIT(0),
 		.hw.init = &(struct clk_init_data){
 			.name = "gcc_sdcc4_ahb_clk",
-			.parent_hws = (const struct clk_hw *[]){ &periph_noc_clk_src.clkr.hw },
-			.num_parents = 1,
-			.flags = CLK_SET_RATE_PARENT,
 			.ops = &clk_branch2_ops,
 		},
 	},
@@ -2123,8 +2047,6 @@ static struct clk_branch gcc_tsif_ahb_cl
 		.enable_mask = BIT(0),
 		.hw.init = &(struct clk_init_data){
 			.name = "gcc_tsif_ahb_clk",
-			.parent_hws = (const struct clk_hw *[]){ &periph_noc_clk_src.clkr.hw },
-			.num_parents = 1,
 			.ops = &clk_branch2_ops,
 		},
 	},
@@ -2152,8 +2074,6 @@ static struct clk_branch gcc_ufs_ahb_clk
 		.enable_mask = BIT(0),
 		.hw.init = &(struct clk_init_data){
 			.name = "gcc_ufs_ahb_clk",
-			.parent_hws = (const struct clk_hw *[]){ &config_noc_clk_src.clkr.hw },
-			.num_parents = 1,
 			.ops = &clk_branch2_ops,
 		},
 	},
@@ -2197,8 +2117,6 @@ static struct clk_branch gcc_ufs_rx_symb
 		.enable_mask = BIT(0),
 		.hw.init = &(struct clk_init_data){
 			.name = "gcc_ufs_rx_symbol_0_clk",
-			.parent_hws = (const struct clk_hw *[]){ &system_noc_clk_src.clkr.hw },
-			.num_parents = 1,
 			.ops = &clk_branch2_ops,
 		},
 	},
@@ -2212,8 +2130,6 @@ static struct clk_branch gcc_ufs_rx_symb
 		.enable_mask = BIT(0),
 		.hw.init = &(struct clk_init_data){
 			.name = "gcc_ufs_rx_symbol_1_clk",
-			.parent_hws = (const struct clk_hw *[]){ &system_noc_clk_src.clkr.hw },
-			.num_parents = 1,
 			.ops = &clk_branch2_ops,
 		},
 	},
@@ -2242,8 +2158,6 @@ static struct clk_branch gcc_ufs_tx_symb
 		.enable_mask = BIT(0),
 		.hw.init = &(struct clk_init_data){
 			.name = "gcc_ufs_tx_symbol_0_clk",
-			.parent_hws = (const struct clk_hw *[]){ &system_noc_clk_src.clkr.hw },
-			.num_parents = 1,
 			.ops = &clk_branch2_ops,
 		},
 	},
@@ -2257,8 +2171,6 @@ static struct clk_branch gcc_ufs_tx_symb
 		.enable_mask = BIT(0),
 		.hw.init = &(struct clk_init_data){
 			.name = "gcc_ufs_tx_symbol_1_clk",
-			.parent_hws = (const struct clk_hw *[]){ &system_noc_clk_src.clkr.hw },
-			.num_parents = 1,
 			.ops = &clk_branch2_ops,
 		},
 	},
@@ -2363,8 +2275,6 @@ static struct clk_branch gcc_usb_hs_ahb_
 		.enable_mask = BIT(0),
 		.hw.init = &(struct clk_init_data){
 			.name = "gcc_usb_hs_ahb_clk",
-			.parent_hws = (const struct clk_hw *[]){ &periph_noc_clk_src.clkr.hw },
-			.num_parents = 1,
 			.ops = &clk_branch2_ops,
 		},
 	},
@@ -2487,8 +2397,6 @@ static struct clk_branch gcc_boot_rom_ah
 		.enable_mask = BIT(10),
 		.hw.init = &(struct clk_init_data){
 			.name = "gcc_boot_rom_ahb_clk",
-			.parent_hws = (const struct clk_hw *[]){ &config_noc_clk_src.clkr.hw },
-			.num_parents = 1,
 			.ops = &clk_branch2_ops,
 		},
 	},
@@ -2502,8 +2410,6 @@ static struct clk_branch gcc_prng_ahb_cl
 		.enable_mask = BIT(13),
 		.hw.init = &(struct clk_init_data){
 			.name = "gcc_prng_ahb_clk",
-			.parent_hws = (const struct clk_hw *[]){ &periph_noc_clk_src.clkr.hw },
-			.num_parents = 1,
 			.ops = &clk_branch2_ops,
 		},
 	},
@@ -2546,9 +2452,6 @@ static struct clk_regmap *gcc_msm8994_cl
 	[GPLL0] = &gpll0.clkr,
 	[GPLL4_EARLY] = &gpll4_early.clkr,
 	[GPLL4] = &gpll4.clkr,
-	[CONFIG_NOC_CLK_SRC] = &config_noc_clk_src.clkr,
-	[PERIPH_NOC_CLK_SRC] = &periph_noc_clk_src.clkr,
-	[SYSTEM_NOC_CLK_SRC] = &system_noc_clk_src.clkr,
 	[UFS_AXI_CLK_SRC] = &ufs_axi_clk_src.clkr,
 	[USB30_MASTER_CLK_SRC] = &usb30_master_clk_src.clkr,
 	[BLSP1_QUP1_I2C_APPS_CLK_SRC] = &blsp1_qup1_i2c_apps_clk_src.clkr,
@@ -2695,6 +2598,15 @@ static struct clk_regmap *gcc_msm8994_cl
 	[USB_SS_PHY_LDO] = &usb_ss_phy_ldo.clkr,
 	[GCC_BOOT_ROM_AHB_CLK] = &gcc_boot_rom_ahb_clk.clkr,
 	[GCC_PRNG_AHB_CLK] = &gcc_prng_ahb_clk.clkr,
+
+	/*
+	 * The following clocks should NOT be managed by this driver, but they once were
+	 * mistakengly added. Now they are only here to indicate that they are not defined
+	 * on purpose, even though the names will stay in the header file (for ABI sanity).
+	 */
+	[CONFIG_NOC_CLK_SRC] = NULL,
+	[PERIPH_NOC_CLK_SRC] = NULL,
+	[SYSTEM_NOC_CLK_SRC] = NULL,
 };
 
 static struct gdsc *gcc_msm8994_gdscs[] = {


