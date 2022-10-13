Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B931C5FE0DA
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 20:15:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231688AbiJMSPX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Oct 2022 14:15:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231909AbiJMSNl (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Oct 2022 14:13:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEF24A449;
        Thu, 13 Oct 2022 11:09:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C1A80B82026;
        Thu, 13 Oct 2022 17:55:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05212C433D6;
        Thu, 13 Oct 2022 17:55:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665683743;
        bh=qLSpSTo7stjUP2AWiV/nKZhAwOsRrUE+988dXdNhIvM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YBa7SiB6IDFzZ5NTUPgWa4P27zIAOlOeqD6F6rQPJ9w8TRU/NWiQuW6fJVw2Qt5LI
         ZpWVwVbkVnWzkTnCuGAV247Ek4YkN7BXjAvEd8lqZML/1gUFtuiSB7CygC/vKg6X1n
         VrUzKsRCwxA1sH/fEOLCDFql66ie6oHsDIwyiq7c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 34/54] Revert "clk: ti: Stop using legacy clkctrl names for omap4 and 5"
Date:   Thu, 13 Oct 2022 19:52:28 +0200
Message-Id: <20221013175148.177615409@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221013175147.337501757@linuxfoundation.org>
References: <20221013175147.337501757@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit 67c830a6de835a36b4e19fe4d968dbaf8dc4e9c6.

Which was upstream commit 255584b138343d4a28c6d25bd82d04b09460d672.

Reported as causing boot failures.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/ti/clk-44xx.c |  210 +++++++++++++++++++++++-----------------------
 drivers/clk/ti/clk-54xx.c |  160 +++++++++++++++++------------------
 drivers/clk/ti/clkctrl.c  |    4 
 3 files changed, 189 insertions(+), 185 deletions(-)

--- a/drivers/clk/ti/clk-44xx.c
+++ b/drivers/clk/ti/clk-44xx.c
@@ -56,7 +56,7 @@ static const struct omap_clkctrl_bit_dat
 };
 
 static const char * const omap4_func_dmic_abe_gfclk_parents[] __initconst = {
-	"abe-clkctrl:0018:26",
+	"abe_cm:clk:0018:26",
 	"pad_clks_ck",
 	"slimbus_clk",
 	NULL,
@@ -76,7 +76,7 @@ static const struct omap_clkctrl_bit_dat
 };
 
 static const char * const omap4_func_mcasp_abe_gfclk_parents[] __initconst = {
-	"abe-clkctrl:0020:26",
+	"abe_cm:clk:0020:26",
 	"pad_clks_ck",
 	"slimbus_clk",
 	NULL,
@@ -89,7 +89,7 @@ static const struct omap_clkctrl_bit_dat
 };
 
 static const char * const omap4_func_mcbsp1_gfclk_parents[] __initconst = {
-	"abe-clkctrl:0028:26",
+	"abe_cm:clk:0028:26",
 	"pad_clks_ck",
 	"slimbus_clk",
 	NULL,
@@ -102,7 +102,7 @@ static const struct omap_clkctrl_bit_dat
 };
 
 static const char * const omap4_func_mcbsp2_gfclk_parents[] __initconst = {
-	"abe-clkctrl:0030:26",
+	"abe_cm:clk:0030:26",
 	"pad_clks_ck",
 	"slimbus_clk",
 	NULL,
@@ -115,7 +115,7 @@ static const struct omap_clkctrl_bit_dat
 };
 
 static const char * const omap4_func_mcbsp3_gfclk_parents[] __initconst = {
-	"abe-clkctrl:0038:26",
+	"abe_cm:clk:0038:26",
 	"pad_clks_ck",
 	"slimbus_clk",
 	NULL,
@@ -183,18 +183,18 @@ static const struct omap_clkctrl_bit_dat
 
 static const struct omap_clkctrl_reg_data omap4_abe_clkctrl_regs[] __initconst = {
 	{ OMAP4_L4_ABE_CLKCTRL, NULL, 0, "ocp_abe_iclk" },
-	{ OMAP4_AESS_CLKCTRL, omap4_aess_bit_data, CLKF_SW_SUP, "abe-clkctrl:0008:24" },
+	{ OMAP4_AESS_CLKCTRL, omap4_aess_bit_data, CLKF_SW_SUP, "abe_cm:clk:0008:24" },
 	{ OMAP4_MCPDM_CLKCTRL, NULL, CLKF_SW_SUP, "pad_clks_ck" },
-	{ OMAP4_DMIC_CLKCTRL, omap4_dmic_bit_data, CLKF_SW_SUP, "abe-clkctrl:0018:24" },
-	{ OMAP4_MCASP_CLKCTRL, omap4_mcasp_bit_data, CLKF_SW_SUP, "abe-clkctrl:0020:24" },
-	{ OMAP4_MCBSP1_CLKCTRL, omap4_mcbsp1_bit_data, CLKF_SW_SUP, "abe-clkctrl:0028:24" },
-	{ OMAP4_MCBSP2_CLKCTRL, omap4_mcbsp2_bit_data, CLKF_SW_SUP, "abe-clkctrl:0030:24" },
-	{ OMAP4_MCBSP3_CLKCTRL, omap4_mcbsp3_bit_data, CLKF_SW_SUP, "abe-clkctrl:0038:24" },
-	{ OMAP4_SLIMBUS1_CLKCTRL, omap4_slimbus1_bit_data, CLKF_SW_SUP, "abe-clkctrl:0040:8" },
-	{ OMAP4_TIMER5_CLKCTRL, omap4_timer5_bit_data, CLKF_SW_SUP, "abe-clkctrl:0048:24" },
-	{ OMAP4_TIMER6_CLKCTRL, omap4_timer6_bit_data, CLKF_SW_SUP, "abe-clkctrl:0050:24" },
-	{ OMAP4_TIMER7_CLKCTRL, omap4_timer7_bit_data, CLKF_SW_SUP, "abe-clkctrl:0058:24" },
-	{ OMAP4_TIMER8_CLKCTRL, omap4_timer8_bit_data, CLKF_SW_SUP, "abe-clkctrl:0060:24" },
+	{ OMAP4_DMIC_CLKCTRL, omap4_dmic_bit_data, CLKF_SW_SUP, "abe_cm:clk:0018:24" },
+	{ OMAP4_MCASP_CLKCTRL, omap4_mcasp_bit_data, CLKF_SW_SUP, "abe_cm:clk:0020:24" },
+	{ OMAP4_MCBSP1_CLKCTRL, omap4_mcbsp1_bit_data, CLKF_SW_SUP, "abe_cm:clk:0028:24" },
+	{ OMAP4_MCBSP2_CLKCTRL, omap4_mcbsp2_bit_data, CLKF_SW_SUP, "abe_cm:clk:0030:24" },
+	{ OMAP4_MCBSP3_CLKCTRL, omap4_mcbsp3_bit_data, CLKF_SW_SUP, "abe_cm:clk:0038:24" },
+	{ OMAP4_SLIMBUS1_CLKCTRL, omap4_slimbus1_bit_data, CLKF_SW_SUP, "abe_cm:clk:0040:8" },
+	{ OMAP4_TIMER5_CLKCTRL, omap4_timer5_bit_data, CLKF_SW_SUP, "abe_cm:clk:0048:24" },
+	{ OMAP4_TIMER6_CLKCTRL, omap4_timer6_bit_data, CLKF_SW_SUP, "abe_cm:clk:0050:24" },
+	{ OMAP4_TIMER7_CLKCTRL, omap4_timer7_bit_data, CLKF_SW_SUP, "abe_cm:clk:0058:24" },
+	{ OMAP4_TIMER8_CLKCTRL, omap4_timer8_bit_data, CLKF_SW_SUP, "abe_cm:clk:0060:24" },
 	{ OMAP4_WD_TIMER3_CLKCTRL, NULL, CLKF_SW_SUP, "sys_32k_ck" },
 	{ 0 },
 };
@@ -287,7 +287,7 @@ static const struct omap_clkctrl_bit_dat
 
 static const struct omap_clkctrl_reg_data omap4_iss_clkctrl_regs[] __initconst = {
 	{ OMAP4_ISS_CLKCTRL, omap4_iss_bit_data, CLKF_SW_SUP, "ducati_clk_mux_ck" },
-	{ OMAP4_FDIF_CLKCTRL, omap4_fdif_bit_data, CLKF_SW_SUP, "iss-clkctrl:0008:24" },
+	{ OMAP4_FDIF_CLKCTRL, omap4_fdif_bit_data, CLKF_SW_SUP, "iss_cm:clk:0008:24" },
 	{ 0 },
 };
 
@@ -320,7 +320,7 @@ static const struct omap_clkctrl_bit_dat
 };
 
 static const struct omap_clkctrl_reg_data omap4_l3_dss_clkctrl_regs[] __initconst = {
-	{ OMAP4_DSS_CORE_CLKCTRL, omap4_dss_core_bit_data, CLKF_SW_SUP, "l3-dss-clkctrl:0000:8" },
+	{ OMAP4_DSS_CORE_CLKCTRL, omap4_dss_core_bit_data, CLKF_SW_SUP, "l3_dss_cm:clk:0000:8" },
 	{ 0 },
 };
 
@@ -336,7 +336,7 @@ static const struct omap_clkctrl_bit_dat
 };
 
 static const struct omap_clkctrl_reg_data omap4_l3_gfx_clkctrl_regs[] __initconst = {
-	{ OMAP4_GPU_CLKCTRL, omap4_gpu_bit_data, CLKF_SW_SUP, "l3-gfx-clkctrl:0000:24" },
+	{ OMAP4_GPU_CLKCTRL, omap4_gpu_bit_data, CLKF_SW_SUP, "l3_gfx_cm:clk:0000:24" },
 	{ 0 },
 };
 
@@ -372,12 +372,12 @@ static const struct omap_clkctrl_bit_dat
 };
 
 static const char * const omap4_usb_host_hs_utmi_p1_clk_parents[] __initconst = {
-	"l3-init-clkctrl:0038:24",
+	"l3_init_cm:clk:0038:24",
 	NULL,
 };
 
 static const char * const omap4_usb_host_hs_utmi_p2_clk_parents[] __initconst = {
-	"l3-init-clkctrl:0038:25",
+	"l3_init_cm:clk:0038:25",
 	NULL,
 };
 
@@ -418,7 +418,7 @@ static const struct omap_clkctrl_bit_dat
 };
 
 static const char * const omap4_usb_otg_hs_xclk_parents[] __initconst = {
-	"l3-init-clkctrl:0040:24",
+	"l3_init_cm:clk:0040:24",
 	NULL,
 };
 
@@ -452,14 +452,14 @@ static const struct omap_clkctrl_bit_dat
 };
 
 static const struct omap_clkctrl_reg_data omap4_l3_init_clkctrl_regs[] __initconst = {
-	{ OMAP4_MMC1_CLKCTRL, omap4_mmc1_bit_data, CLKF_SW_SUP, "l3-init-clkctrl:0008:24" },
-	{ OMAP4_MMC2_CLKCTRL, omap4_mmc2_bit_data, CLKF_SW_SUP, "l3-init-clkctrl:0010:24" },
-	{ OMAP4_HSI_CLKCTRL, omap4_hsi_bit_data, CLKF_HW_SUP, "l3-init-clkctrl:0018:24" },
+	{ OMAP4_MMC1_CLKCTRL, omap4_mmc1_bit_data, CLKF_SW_SUP, "l3_init_cm:clk:0008:24" },
+	{ OMAP4_MMC2_CLKCTRL, omap4_mmc2_bit_data, CLKF_SW_SUP, "l3_init_cm:clk:0010:24" },
+	{ OMAP4_HSI_CLKCTRL, omap4_hsi_bit_data, CLKF_HW_SUP, "l3_init_cm:clk:0018:24" },
 	{ OMAP4_USB_HOST_HS_CLKCTRL, omap4_usb_host_hs_bit_data, CLKF_SW_SUP, "init_60m_fclk" },
 	{ OMAP4_USB_OTG_HS_CLKCTRL, omap4_usb_otg_hs_bit_data, CLKF_HW_SUP, "l3_div_ck" },
 	{ OMAP4_USB_TLL_HS_CLKCTRL, omap4_usb_tll_hs_bit_data, CLKF_HW_SUP, "l4_div_ck" },
 	{ OMAP4_USB_HOST_FS_CLKCTRL, NULL, CLKF_SW_SUP, "func_48mc_fclk" },
-	{ OMAP4_OCP2SCP_USB_PHY_CLKCTRL, omap4_ocp2scp_usb_phy_bit_data, CLKF_HW_SUP, "l3-init-clkctrl:00c0:8" },
+	{ OMAP4_OCP2SCP_USB_PHY_CLKCTRL, omap4_ocp2scp_usb_phy_bit_data, CLKF_HW_SUP, "l3_init_cm:clk:00c0:8" },
 	{ 0 },
 };
 
@@ -530,7 +530,7 @@ static const struct omap_clkctrl_bit_dat
 };
 
 static const char * const omap4_per_mcbsp4_gfclk_parents[] __initconst = {
-	"l4-per-clkctrl:00c0:26",
+	"l4_per_cm:clk:00c0:26",
 	"pad_clks_ck",
 	NULL,
 };
@@ -570,12 +570,12 @@ static const struct omap_clkctrl_bit_dat
 };
 
 static const struct omap_clkctrl_reg_data omap4_l4_per_clkctrl_regs[] __initconst = {
-	{ OMAP4_TIMER10_CLKCTRL, omap4_timer10_bit_data, CLKF_SW_SUP, "l4-per-clkctrl:0008:24" },
-	{ OMAP4_TIMER11_CLKCTRL, omap4_timer11_bit_data, CLKF_SW_SUP, "l4-per-clkctrl:0010:24" },
-	{ OMAP4_TIMER2_CLKCTRL, omap4_timer2_bit_data, CLKF_SW_SUP, "l4-per-clkctrl:0018:24" },
-	{ OMAP4_TIMER3_CLKCTRL, omap4_timer3_bit_data, CLKF_SW_SUP, "l4-per-clkctrl:0020:24" },
-	{ OMAP4_TIMER4_CLKCTRL, omap4_timer4_bit_data, CLKF_SW_SUP, "l4-per-clkctrl:0028:24" },
-	{ OMAP4_TIMER9_CLKCTRL, omap4_timer9_bit_data, CLKF_SW_SUP, "l4-per-clkctrl:0030:24" },
+	{ OMAP4_TIMER10_CLKCTRL, omap4_timer10_bit_data, CLKF_SW_SUP, "l4_per_cm:clk:0008:24" },
+	{ OMAP4_TIMER11_CLKCTRL, omap4_timer11_bit_data, CLKF_SW_SUP, "l4_per_cm:clk:0010:24" },
+	{ OMAP4_TIMER2_CLKCTRL, omap4_timer2_bit_data, CLKF_SW_SUP, "l4_per_cm:clk:0018:24" },
+	{ OMAP4_TIMER3_CLKCTRL, omap4_timer3_bit_data, CLKF_SW_SUP, "l4_per_cm:clk:0020:24" },
+	{ OMAP4_TIMER4_CLKCTRL, omap4_timer4_bit_data, CLKF_SW_SUP, "l4_per_cm:clk:0028:24" },
+	{ OMAP4_TIMER9_CLKCTRL, omap4_timer9_bit_data, CLKF_SW_SUP, "l4_per_cm:clk:0030:24" },
 	{ OMAP4_ELM_CLKCTRL, NULL, 0, "l4_div_ck" },
 	{ OMAP4_GPIO2_CLKCTRL, omap4_gpio2_bit_data, CLKF_HW_SUP, "l4_div_ck" },
 	{ OMAP4_GPIO3_CLKCTRL, omap4_gpio3_bit_data, CLKF_HW_SUP, "l4_div_ck" },
@@ -588,14 +588,14 @@ static const struct omap_clkctrl_reg_dat
 	{ OMAP4_I2C3_CLKCTRL, NULL, CLKF_SW_SUP, "func_96m_fclk" },
 	{ OMAP4_I2C4_CLKCTRL, NULL, CLKF_SW_SUP, "func_96m_fclk" },
 	{ OMAP4_L4_PER_CLKCTRL, NULL, 0, "l4_div_ck" },
-	{ OMAP4_MCBSP4_CLKCTRL, omap4_mcbsp4_bit_data, CLKF_SW_SUP, "l4-per-clkctrl:00c0:24" },
+	{ OMAP4_MCBSP4_CLKCTRL, omap4_mcbsp4_bit_data, CLKF_SW_SUP, "l4_per_cm:clk:00c0:24" },
 	{ OMAP4_MCSPI1_CLKCTRL, NULL, CLKF_SW_SUP, "func_48m_fclk" },
 	{ OMAP4_MCSPI2_CLKCTRL, NULL, CLKF_SW_SUP, "func_48m_fclk" },
 	{ OMAP4_MCSPI3_CLKCTRL, NULL, CLKF_SW_SUP, "func_48m_fclk" },
 	{ OMAP4_MCSPI4_CLKCTRL, NULL, CLKF_SW_SUP, "func_48m_fclk" },
 	{ OMAP4_MMC3_CLKCTRL, NULL, CLKF_SW_SUP, "func_48m_fclk" },
 	{ OMAP4_MMC4_CLKCTRL, NULL, CLKF_SW_SUP, "func_48m_fclk" },
-	{ OMAP4_SLIMBUS2_CLKCTRL, omap4_slimbus2_bit_data, CLKF_SW_SUP, "l4-per-clkctrl:0118:8" },
+	{ OMAP4_SLIMBUS2_CLKCTRL, omap4_slimbus2_bit_data, CLKF_SW_SUP, "l4_per_cm:clk:0118:8" },
 	{ OMAP4_UART1_CLKCTRL, NULL, CLKF_SW_SUP, "func_48m_fclk" },
 	{ OMAP4_UART2_CLKCTRL, NULL, CLKF_SW_SUP, "func_48m_fclk" },
 	{ OMAP4_UART3_CLKCTRL, NULL, CLKF_SW_SUP, "func_48m_fclk" },
@@ -630,7 +630,7 @@ static const struct omap_clkctrl_reg_dat
 	{ OMAP4_L4_WKUP_CLKCTRL, NULL, 0, "l4_wkup_clk_mux_ck" },
 	{ OMAP4_WD_TIMER2_CLKCTRL, NULL, CLKF_SW_SUP, "sys_32k_ck" },
 	{ OMAP4_GPIO1_CLKCTRL, omap4_gpio1_bit_data, CLKF_HW_SUP, "l4_wkup_clk_mux_ck" },
-	{ OMAP4_TIMER1_CLKCTRL, omap4_timer1_bit_data, CLKF_SW_SUP, "l4-wkup-clkctrl:0020:24" },
+	{ OMAP4_TIMER1_CLKCTRL, omap4_timer1_bit_data, CLKF_SW_SUP, "l4_wkup_cm:clk:0020:24" },
 	{ OMAP4_COUNTER_32K_CLKCTRL, NULL, 0, "sys_32k_ck" },
 	{ OMAP4_KBD_CLKCTRL, NULL, CLKF_SW_SUP, "sys_32k_ck" },
 	{ 0 },
@@ -644,7 +644,7 @@ static const char * const omap4_pmd_stm_
 };
 
 static const char * const omap4_trace_clk_div_div_ck_parents[] __initconst = {
-	"emu-sys-clkctrl:0000:22",
+	"emu_sys_cm:clk:0000:22",
 	NULL,
 };
 
@@ -662,7 +662,7 @@ static const struct omap_clkctrl_div_dat
 };
 
 static const char * const omap4_stm_clk_div_ck_parents[] __initconst = {
-	"emu-sys-clkctrl:0000:20",
+	"emu_sys_cm:clk:0000:20",
 	NULL,
 };
 
@@ -716,73 +716,73 @@ static struct ti_dt_clk omap44xx_clks[]
 	 * hwmod support. Once hwmod is removed, these can be removed
 	 * also.
 	 */
-	DT_CLK(NULL, "aess_fclk", "abe-clkctrl:0008:24"),
-	DT_CLK(NULL, "cm2_dm10_mux", "l4-per-clkctrl:0008:24"),
-	DT_CLK(NULL, "cm2_dm11_mux", "l4-per-clkctrl:0010:24"),
-	DT_CLK(NULL, "cm2_dm2_mux", "l4-per-clkctrl:0018:24"),
-	DT_CLK(NULL, "cm2_dm3_mux", "l4-per-clkctrl:0020:24"),
-	DT_CLK(NULL, "cm2_dm4_mux", "l4-per-clkctrl:0028:24"),
-	DT_CLK(NULL, "cm2_dm9_mux", "l4-per-clkctrl:0030:24"),
-	DT_CLK(NULL, "dmic_sync_mux_ck", "abe-clkctrl:0018:26"),
-	DT_CLK(NULL, "dmt1_clk_mux", "l4-wkup-clkctrl:0020:24"),
-	DT_CLK(NULL, "dss_48mhz_clk", "l3-dss-clkctrl:0000:9"),
-	DT_CLK(NULL, "dss_dss_clk", "l3-dss-clkctrl:0000:8"),
-	DT_CLK(NULL, "dss_sys_clk", "l3-dss-clkctrl:0000:10"),
-	DT_CLK(NULL, "dss_tv_clk", "l3-dss-clkctrl:0000:11"),
-	DT_CLK(NULL, "fdif_fck", "iss-clkctrl:0008:24"),
-	DT_CLK(NULL, "func_dmic_abe_gfclk", "abe-clkctrl:0018:24"),
-	DT_CLK(NULL, "func_mcasp_abe_gfclk", "abe-clkctrl:0020:24"),
-	DT_CLK(NULL, "func_mcbsp1_gfclk", "abe-clkctrl:0028:24"),
-	DT_CLK(NULL, "func_mcbsp2_gfclk", "abe-clkctrl:0030:24"),
-	DT_CLK(NULL, "func_mcbsp3_gfclk", "abe-clkctrl:0038:24"),
-	DT_CLK(NULL, "gpio1_dbclk", "l4-wkup-clkctrl:0018:8"),
-	DT_CLK(NULL, "gpio2_dbclk", "l4-per-clkctrl:0040:8"),
-	DT_CLK(NULL, "gpio3_dbclk", "l4-per-clkctrl:0048:8"),
-	DT_CLK(NULL, "gpio4_dbclk", "l4-per-clkctrl:0050:8"),
-	DT_CLK(NULL, "gpio5_dbclk", "l4-per-clkctrl:0058:8"),
-	DT_CLK(NULL, "gpio6_dbclk", "l4-per-clkctrl:0060:8"),
-	DT_CLK(NULL, "hsi_fck", "l3-init-clkctrl:0018:24"),
-	DT_CLK(NULL, "hsmmc1_fclk", "l3-init-clkctrl:0008:24"),
-	DT_CLK(NULL, "hsmmc2_fclk", "l3-init-clkctrl:0010:24"),
-	DT_CLK(NULL, "iss_ctrlclk", "iss-clkctrl:0000:8"),
-	DT_CLK(NULL, "mcasp_sync_mux_ck", "abe-clkctrl:0020:26"),
-	DT_CLK(NULL, "mcbsp1_sync_mux_ck", "abe-clkctrl:0028:26"),
-	DT_CLK(NULL, "mcbsp2_sync_mux_ck", "abe-clkctrl:0030:26"),
-	DT_CLK(NULL, "mcbsp3_sync_mux_ck", "abe-clkctrl:0038:26"),
-	DT_CLK(NULL, "mcbsp4_sync_mux_ck", "l4-per-clkctrl:00c0:26"),
-	DT_CLK(NULL, "ocp2scp_usb_phy_phy_48m", "l3-init-clkctrl:00c0:8"),
-	DT_CLK(NULL, "otg_60m_gfclk", "l3-init-clkctrl:0040:24"),
-	DT_CLK(NULL, "per_mcbsp4_gfclk", "l4-per-clkctrl:00c0:24"),
-	DT_CLK(NULL, "pmd_stm_clock_mux_ck", "emu-sys-clkctrl:0000:20"),
-	DT_CLK(NULL, "pmd_trace_clk_mux_ck", "emu-sys-clkctrl:0000:22"),
-	DT_CLK(NULL, "sgx_clk_mux", "l3-gfx-clkctrl:0000:24"),
-	DT_CLK(NULL, "slimbus1_fclk_0", "abe-clkctrl:0040:8"),
-	DT_CLK(NULL, "slimbus1_fclk_1", "abe-clkctrl:0040:9"),
-	DT_CLK(NULL, "slimbus1_fclk_2", "abe-clkctrl:0040:10"),
-	DT_CLK(NULL, "slimbus1_slimbus_clk", "abe-clkctrl:0040:11"),
-	DT_CLK(NULL, "slimbus2_fclk_0", "l4-per-clkctrl:0118:8"),
-	DT_CLK(NULL, "slimbus2_fclk_1", "l4-per-clkctrl:0118:9"),
-	DT_CLK(NULL, "slimbus2_slimbus_clk", "l4-per-clkctrl:0118:10"),
-	DT_CLK(NULL, "stm_clk_div_ck", "emu-sys-clkctrl:0000:27"),
-	DT_CLK(NULL, "timer5_sync_mux", "abe-clkctrl:0048:24"),
-	DT_CLK(NULL, "timer6_sync_mux", "abe-clkctrl:0050:24"),
-	DT_CLK(NULL, "timer7_sync_mux", "abe-clkctrl:0058:24"),
-	DT_CLK(NULL, "timer8_sync_mux", "abe-clkctrl:0060:24"),
-	DT_CLK(NULL, "trace_clk_div_div_ck", "emu-sys-clkctrl:0000:24"),
-	DT_CLK(NULL, "usb_host_hs_func48mclk", "l3-init-clkctrl:0038:15"),
-	DT_CLK(NULL, "usb_host_hs_hsic480m_p1_clk", "l3-init-clkctrl:0038:13"),
-	DT_CLK(NULL, "usb_host_hs_hsic480m_p2_clk", "l3-init-clkctrl:0038:14"),
-	DT_CLK(NULL, "usb_host_hs_hsic60m_p1_clk", "l3-init-clkctrl:0038:11"),
-	DT_CLK(NULL, "usb_host_hs_hsic60m_p2_clk", "l3-init-clkctrl:0038:12"),
-	DT_CLK(NULL, "usb_host_hs_utmi_p1_clk", "l3-init-clkctrl:0038:8"),
-	DT_CLK(NULL, "usb_host_hs_utmi_p2_clk", "l3-init-clkctrl:0038:9"),
-	DT_CLK(NULL, "usb_host_hs_utmi_p3_clk", "l3_init-clkctrl:0038:10"),
-	DT_CLK(NULL, "usb_otg_hs_xclk", "l3-init-clkctrl:0040:8"),
-	DT_CLK(NULL, "usb_tll_hs_usb_ch0_clk", "l3-init-clkctrl:0048:8"),
-	DT_CLK(NULL, "usb_tll_hs_usb_ch1_clk", "l3-init-clkctrl:0048:9"),
-	DT_CLK(NULL, "usb_tll_hs_usb_ch2_clk", "l3-init-clkctrl:0048:10"),
-	DT_CLK(NULL, "utmi_p1_gfclk", "l3-init-clkctrl:0038:24"),
-	DT_CLK(NULL, "utmi_p2_gfclk", "l3-init-clkctrl:0038:25"),
+	DT_CLK(NULL, "aess_fclk", "abe_cm:0008:24"),
+	DT_CLK(NULL, "cm2_dm10_mux", "l4_per_cm:0008:24"),
+	DT_CLK(NULL, "cm2_dm11_mux", "l4_per_cm:0010:24"),
+	DT_CLK(NULL, "cm2_dm2_mux", "l4_per_cm:0018:24"),
+	DT_CLK(NULL, "cm2_dm3_mux", "l4_per_cm:0020:24"),
+	DT_CLK(NULL, "cm2_dm4_mux", "l4_per_cm:0028:24"),
+	DT_CLK(NULL, "cm2_dm9_mux", "l4_per_cm:0030:24"),
+	DT_CLK(NULL, "dmic_sync_mux_ck", "abe_cm:0018:26"),
+	DT_CLK(NULL, "dmt1_clk_mux", "l4_wkup_cm:0020:24"),
+	DT_CLK(NULL, "dss_48mhz_clk", "l3_dss_cm:0000:9"),
+	DT_CLK(NULL, "dss_dss_clk", "l3_dss_cm:0000:8"),
+	DT_CLK(NULL, "dss_sys_clk", "l3_dss_cm:0000:10"),
+	DT_CLK(NULL, "dss_tv_clk", "l3_dss_cm:0000:11"),
+	DT_CLK(NULL, "fdif_fck", "iss_cm:0008:24"),
+	DT_CLK(NULL, "func_dmic_abe_gfclk", "abe_cm:0018:24"),
+	DT_CLK(NULL, "func_mcasp_abe_gfclk", "abe_cm:0020:24"),
+	DT_CLK(NULL, "func_mcbsp1_gfclk", "abe_cm:0028:24"),
+	DT_CLK(NULL, "func_mcbsp2_gfclk", "abe_cm:0030:24"),
+	DT_CLK(NULL, "func_mcbsp3_gfclk", "abe_cm:0038:24"),
+	DT_CLK(NULL, "gpio1_dbclk", "l4_wkup_cm:0018:8"),
+	DT_CLK(NULL, "gpio2_dbclk", "l4_per_cm:0040:8"),
+	DT_CLK(NULL, "gpio3_dbclk", "l4_per_cm:0048:8"),
+	DT_CLK(NULL, "gpio4_dbclk", "l4_per_cm:0050:8"),
+	DT_CLK(NULL, "gpio5_dbclk", "l4_per_cm:0058:8"),
+	DT_CLK(NULL, "gpio6_dbclk", "l4_per_cm:0060:8"),
+	DT_CLK(NULL, "hsi_fck", "l3_init_cm:0018:24"),
+	DT_CLK(NULL, "hsmmc1_fclk", "l3_init_cm:0008:24"),
+	DT_CLK(NULL, "hsmmc2_fclk", "l3_init_cm:0010:24"),
+	DT_CLK(NULL, "iss_ctrlclk", "iss_cm:0000:8"),
+	DT_CLK(NULL, "mcasp_sync_mux_ck", "abe_cm:0020:26"),
+	DT_CLK(NULL, "mcbsp1_sync_mux_ck", "abe_cm:0028:26"),
+	DT_CLK(NULL, "mcbsp2_sync_mux_ck", "abe_cm:0030:26"),
+	DT_CLK(NULL, "mcbsp3_sync_mux_ck", "abe_cm:0038:26"),
+	DT_CLK(NULL, "mcbsp4_sync_mux_ck", "l4_per_cm:00c0:26"),
+	DT_CLK(NULL, "ocp2scp_usb_phy_phy_48m", "l3_init_cm:00c0:8"),
+	DT_CLK(NULL, "otg_60m_gfclk", "l3_init_cm:0040:24"),
+	DT_CLK(NULL, "per_mcbsp4_gfclk", "l4_per_cm:00c0:24"),
+	DT_CLK(NULL, "pmd_stm_clock_mux_ck", "emu_sys_cm:0000:20"),
+	DT_CLK(NULL, "pmd_trace_clk_mux_ck", "emu_sys_cm:0000:22"),
+	DT_CLK(NULL, "sgx_clk_mux", "l3_gfx_cm:0000:24"),
+	DT_CLK(NULL, "slimbus1_fclk_0", "abe_cm:0040:8"),
+	DT_CLK(NULL, "slimbus1_fclk_1", "abe_cm:0040:9"),
+	DT_CLK(NULL, "slimbus1_fclk_2", "abe_cm:0040:10"),
+	DT_CLK(NULL, "slimbus1_slimbus_clk", "abe_cm:0040:11"),
+	DT_CLK(NULL, "slimbus2_fclk_0", "l4_per_cm:0118:8"),
+	DT_CLK(NULL, "slimbus2_fclk_1", "l4_per_cm:0118:9"),
+	DT_CLK(NULL, "slimbus2_slimbus_clk", "l4_per_cm:0118:10"),
+	DT_CLK(NULL, "stm_clk_div_ck", "emu_sys_cm:0000:27"),
+	DT_CLK(NULL, "timer5_sync_mux", "abe_cm:0048:24"),
+	DT_CLK(NULL, "timer6_sync_mux", "abe_cm:0050:24"),
+	DT_CLK(NULL, "timer7_sync_mux", "abe_cm:0058:24"),
+	DT_CLK(NULL, "timer8_sync_mux", "abe_cm:0060:24"),
+	DT_CLK(NULL, "trace_clk_div_div_ck", "emu_sys_cm:0000:24"),
+	DT_CLK(NULL, "usb_host_hs_func48mclk", "l3_init_cm:0038:15"),
+	DT_CLK(NULL, "usb_host_hs_hsic480m_p1_clk", "l3_init_cm:0038:13"),
+	DT_CLK(NULL, "usb_host_hs_hsic480m_p2_clk", "l3_init_cm:0038:14"),
+	DT_CLK(NULL, "usb_host_hs_hsic60m_p1_clk", "l3_init_cm:0038:11"),
+	DT_CLK(NULL, "usb_host_hs_hsic60m_p2_clk", "l3_init_cm:0038:12"),
+	DT_CLK(NULL, "usb_host_hs_utmi_p1_clk", "l3_init_cm:0038:8"),
+	DT_CLK(NULL, "usb_host_hs_utmi_p2_clk", "l3_init_cm:0038:9"),
+	DT_CLK(NULL, "usb_host_hs_utmi_p3_clk", "l3_init_cm:0038:10"),
+	DT_CLK(NULL, "usb_otg_hs_xclk", "l3_init_cm:0040:8"),
+	DT_CLK(NULL, "usb_tll_hs_usb_ch0_clk", "l3_init_cm:0048:8"),
+	DT_CLK(NULL, "usb_tll_hs_usb_ch1_clk", "l3_init_cm:0048:9"),
+	DT_CLK(NULL, "usb_tll_hs_usb_ch2_clk", "l3_init_cm:0048:10"),
+	DT_CLK(NULL, "utmi_p1_gfclk", "l3_init_cm:0038:24"),
+	DT_CLK(NULL, "utmi_p2_gfclk", "l3_init_cm:0038:25"),
 	{ .node_name = NULL },
 };
 
--- a/drivers/clk/ti/clk-54xx.c
+++ b/drivers/clk/ti/clk-54xx.c
@@ -50,7 +50,7 @@ static const struct omap_clkctrl_bit_dat
 };
 
 static const char * const omap5_dmic_gfclk_parents[] __initconst = {
-	"abe-clkctrl:0018:26",
+	"abe_cm:clk:0018:26",
 	"pad_clks_ck",
 	"slimbus_clk",
 	NULL,
@@ -70,7 +70,7 @@ static const struct omap_clkctrl_bit_dat
 };
 
 static const char * const omap5_mcbsp1_gfclk_parents[] __initconst = {
-	"abe-clkctrl:0028:26",
+	"abe_cm:clk:0028:26",
 	"pad_clks_ck",
 	"slimbus_clk",
 	NULL,
@@ -83,7 +83,7 @@ static const struct omap_clkctrl_bit_dat
 };
 
 static const char * const omap5_mcbsp2_gfclk_parents[] __initconst = {
-	"abe-clkctrl:0030:26",
+	"abe_cm:clk:0030:26",
 	"pad_clks_ck",
 	"slimbus_clk",
 	NULL,
@@ -96,7 +96,7 @@ static const struct omap_clkctrl_bit_dat
 };
 
 static const char * const omap5_mcbsp3_gfclk_parents[] __initconst = {
-	"abe-clkctrl:0038:26",
+	"abe_cm:clk:0038:26",
 	"pad_clks_ck",
 	"slimbus_clk",
 	NULL,
@@ -136,16 +136,16 @@ static const struct omap_clkctrl_bit_dat
 
 static const struct omap_clkctrl_reg_data omap5_abe_clkctrl_regs[] __initconst = {
 	{ OMAP5_L4_ABE_CLKCTRL, NULL, 0, "abe_iclk" },
-	{ OMAP5_AESS_CLKCTRL, omap5_aess_bit_data, CLKF_SW_SUP, "abe-clkctrl:0008:24" },
+	{ OMAP5_AESS_CLKCTRL, omap5_aess_bit_data, CLKF_SW_SUP, "abe_cm:clk:0008:24" },
 	{ OMAP5_MCPDM_CLKCTRL, NULL, CLKF_SW_SUP, "pad_clks_ck" },
-	{ OMAP5_DMIC_CLKCTRL, omap5_dmic_bit_data, CLKF_SW_SUP, "abe-clkctrl:0018:24" },
-	{ OMAP5_MCBSP1_CLKCTRL, omap5_mcbsp1_bit_data, CLKF_SW_SUP, "abe-clkctrl:0028:24" },
-	{ OMAP5_MCBSP2_CLKCTRL, omap5_mcbsp2_bit_data, CLKF_SW_SUP, "abe-clkctrl:0030:24" },
-	{ OMAP5_MCBSP3_CLKCTRL, omap5_mcbsp3_bit_data, CLKF_SW_SUP, "abe-clkctrl:0038:24" },
-	{ OMAP5_TIMER5_CLKCTRL, omap5_timer5_bit_data, CLKF_SW_SUP, "abe-clkctrl:0048:24" },
-	{ OMAP5_TIMER6_CLKCTRL, omap5_timer6_bit_data, CLKF_SW_SUP, "abe-clkctrl:0050:24" },
-	{ OMAP5_TIMER7_CLKCTRL, omap5_timer7_bit_data, CLKF_SW_SUP, "abe-clkctrl:0058:24" },
-	{ OMAP5_TIMER8_CLKCTRL, omap5_timer8_bit_data, CLKF_SW_SUP, "abe-clkctrl:0060:24" },
+	{ OMAP5_DMIC_CLKCTRL, omap5_dmic_bit_data, CLKF_SW_SUP, "abe_cm:clk:0018:24" },
+	{ OMAP5_MCBSP1_CLKCTRL, omap5_mcbsp1_bit_data, CLKF_SW_SUP, "abe_cm:clk:0028:24" },
+	{ OMAP5_MCBSP2_CLKCTRL, omap5_mcbsp2_bit_data, CLKF_SW_SUP, "abe_cm:clk:0030:24" },
+	{ OMAP5_MCBSP3_CLKCTRL, omap5_mcbsp3_bit_data, CLKF_SW_SUP, "abe_cm:clk:0038:24" },
+	{ OMAP5_TIMER5_CLKCTRL, omap5_timer5_bit_data, CLKF_SW_SUP, "abe_cm:clk:0048:24" },
+	{ OMAP5_TIMER6_CLKCTRL, omap5_timer6_bit_data, CLKF_SW_SUP, "abe_cm:clk:0050:24" },
+	{ OMAP5_TIMER7_CLKCTRL, omap5_timer7_bit_data, CLKF_SW_SUP, "abe_cm:clk:0058:24" },
+	{ OMAP5_TIMER8_CLKCTRL, omap5_timer8_bit_data, CLKF_SW_SUP, "abe_cm:clk:0060:24" },
 	{ 0 },
 };
 
@@ -266,12 +266,12 @@ static const struct omap_clkctrl_bit_dat
 };
 
 static const struct omap_clkctrl_reg_data omap5_l4per_clkctrl_regs[] __initconst = {
-	{ OMAP5_TIMER10_CLKCTRL, omap5_timer10_bit_data, CLKF_SW_SUP, "l4per-clkctrl:0008:24" },
-	{ OMAP5_TIMER11_CLKCTRL, omap5_timer11_bit_data, CLKF_SW_SUP, "l4per-clkctrl:0010:24" },
-	{ OMAP5_TIMER2_CLKCTRL, omap5_timer2_bit_data, CLKF_SW_SUP, "l4per-clkctrl:0018:24" },
-	{ OMAP5_TIMER3_CLKCTRL, omap5_timer3_bit_data, CLKF_SW_SUP, "l4per-clkctrl:0020:24" },
-	{ OMAP5_TIMER4_CLKCTRL, omap5_timer4_bit_data, CLKF_SW_SUP, "l4per-clkctrl:0028:24" },
-	{ OMAP5_TIMER9_CLKCTRL, omap5_timer9_bit_data, CLKF_SW_SUP, "l4per-clkctrl:0030:24" },
+	{ OMAP5_TIMER10_CLKCTRL, omap5_timer10_bit_data, CLKF_SW_SUP, "l4per_cm:clk:0008:24" },
+	{ OMAP5_TIMER11_CLKCTRL, omap5_timer11_bit_data, CLKF_SW_SUP, "l4per_cm:clk:0010:24" },
+	{ OMAP5_TIMER2_CLKCTRL, omap5_timer2_bit_data, CLKF_SW_SUP, "l4per_cm:clk:0018:24" },
+	{ OMAP5_TIMER3_CLKCTRL, omap5_timer3_bit_data, CLKF_SW_SUP, "l4per_cm:clk:0020:24" },
+	{ OMAP5_TIMER4_CLKCTRL, omap5_timer4_bit_data, CLKF_SW_SUP, "l4per_cm:clk:0028:24" },
+	{ OMAP5_TIMER9_CLKCTRL, omap5_timer9_bit_data, CLKF_SW_SUP, "l4per_cm:clk:0030:24" },
 	{ OMAP5_GPIO2_CLKCTRL, omap5_gpio2_bit_data, CLKF_HW_SUP, "l4_root_clk_div" },
 	{ OMAP5_GPIO3_CLKCTRL, omap5_gpio3_bit_data, CLKF_HW_SUP, "l4_root_clk_div" },
 	{ OMAP5_GPIO4_CLKCTRL, omap5_gpio4_bit_data, CLKF_HW_SUP, "l4_root_clk_div" },
@@ -343,7 +343,7 @@ static const struct omap_clkctrl_bit_dat
 };
 
 static const struct omap_clkctrl_reg_data omap5_dss_clkctrl_regs[] __initconst = {
-	{ OMAP5_DSS_CORE_CLKCTRL, omap5_dss_core_bit_data, CLKF_SW_SUP, "dss-clkctrl:0000:8" },
+	{ OMAP5_DSS_CORE_CLKCTRL, omap5_dss_core_bit_data, CLKF_SW_SUP, "dss_cm:clk:0000:8" },
 	{ 0 },
 };
 
@@ -376,7 +376,7 @@ static const struct omap_clkctrl_bit_dat
 };
 
 static const struct omap_clkctrl_reg_data omap5_gpu_clkctrl_regs[] __initconst = {
-	{ OMAP5_GPU_CLKCTRL, omap5_gpu_core_bit_data, CLKF_SW_SUP, "gpu-clkctrl:0000:24" },
+	{ OMAP5_GPU_CLKCTRL, omap5_gpu_core_bit_data, CLKF_SW_SUP, "gpu_cm:clk:0000:24" },
 	{ 0 },
 };
 
@@ -387,7 +387,7 @@ static const char * const omap5_mmc1_fcl
 };
 
 static const char * const omap5_mmc1_fclk_parents[] __initconst = {
-	"l3init-clkctrl:0008:24",
+	"l3init_cm:clk:0008:24",
 	NULL,
 };
 
@@ -403,7 +403,7 @@ static const struct omap_clkctrl_bit_dat
 };
 
 static const char * const omap5_mmc2_fclk_parents[] __initconst = {
-	"l3init-clkctrl:0010:24",
+	"l3init_cm:clk:0010:24",
 	NULL,
 };
 
@@ -428,12 +428,12 @@ static const char * const omap5_usb_host
 };
 
 static const char * const omap5_usb_host_hs_utmi_p1_clk_parents[] __initconst = {
-	"l3init-clkctrl:0038:24",
+	"l3init_cm:clk:0038:24",
 	NULL,
 };
 
 static const char * const omap5_usb_host_hs_utmi_p2_clk_parents[] __initconst = {
-	"l3init-clkctrl:0038:25",
+	"l3init_cm:clk:0038:25",
 	NULL,
 };
 
@@ -492,8 +492,8 @@ static const struct omap_clkctrl_bit_dat
 };
 
 static const struct omap_clkctrl_reg_data omap5_l3init_clkctrl_regs[] __initconst = {
-	{ OMAP5_MMC1_CLKCTRL, omap5_mmc1_bit_data, CLKF_SW_SUP, "l3init-clkctrl:0008:25" },
-	{ OMAP5_MMC2_CLKCTRL, omap5_mmc2_bit_data, CLKF_SW_SUP, "l3init-clkctrl:0010:25" },
+	{ OMAP5_MMC1_CLKCTRL, omap5_mmc1_bit_data, CLKF_SW_SUP, "l3init_cm:clk:0008:25" },
+	{ OMAP5_MMC2_CLKCTRL, omap5_mmc2_bit_data, CLKF_SW_SUP, "l3init_cm:clk:0010:25" },
 	{ OMAP5_USB_HOST_HS_CLKCTRL, omap5_usb_host_hs_bit_data, CLKF_SW_SUP, "l3init_60m_fclk" },
 	{ OMAP5_USB_TLL_HS_CLKCTRL, omap5_usb_tll_hs_bit_data, CLKF_HW_SUP, "l4_root_clk_div" },
 	{ OMAP5_SATA_CLKCTRL, omap5_sata_bit_data, CLKF_SW_SUP, "func_48m_fclk" },
@@ -517,7 +517,7 @@ static const struct omap_clkctrl_reg_dat
 	{ OMAP5_L4_WKUP_CLKCTRL, NULL, 0, "wkupaon_iclk_mux" },
 	{ OMAP5_WD_TIMER2_CLKCTRL, NULL, CLKF_SW_SUP, "sys_32k_ck" },
 	{ OMAP5_GPIO1_CLKCTRL, omap5_gpio1_bit_data, CLKF_HW_SUP, "wkupaon_iclk_mux" },
-	{ OMAP5_TIMER1_CLKCTRL, omap5_timer1_bit_data, CLKF_SW_SUP, "wkupaon-clkctrl:0020:24" },
+	{ OMAP5_TIMER1_CLKCTRL, omap5_timer1_bit_data, CLKF_SW_SUP, "wkupaon_cm:clk:0020:24" },
 	{ OMAP5_COUNTER_32K_CLKCTRL, NULL, 0, "wkupaon_iclk_mux" },
 	{ OMAP5_KBD_CLKCTRL, NULL, CLKF_SW_SUP, "sys_32k_ck" },
 	{ 0 },
@@ -547,58 +547,58 @@ const struct omap_clkctrl_data omap5_clk
 static struct ti_dt_clk omap54xx_clks[] = {
 	DT_CLK(NULL, "timer_32k_ck", "sys_32k_ck"),
 	DT_CLK(NULL, "sys_clkin_ck", "sys_clkin"),
-	DT_CLK(NULL, "dmic_gfclk", "abe-clkctrl:0018:24"),
-	DT_CLK(NULL, "dmic_sync_mux_ck", "abe-clkctrl:0018:26"),
-	DT_CLK(NULL, "dss_32khz_clk", "dss-clkctrl:0000:11"),
-	DT_CLK(NULL, "dss_48mhz_clk", "dss-clkctrl:0000:9"),
-	DT_CLK(NULL, "dss_dss_clk", "dss-clkctrl:0000:8"),
-	DT_CLK(NULL, "dss_sys_clk", "dss-clkctrl:0000:10"),
-	DT_CLK(NULL, "gpio1_dbclk", "wkupaon-clkctrl:0018:8"),
-	DT_CLK(NULL, "gpio2_dbclk", "l4per-clkctrl:0040:8"),
-	DT_CLK(NULL, "gpio3_dbclk", "l4per-clkctrl:0048:8"),
-	DT_CLK(NULL, "gpio4_dbclk", "l4per-clkctrl:0050:8"),
-	DT_CLK(NULL, "gpio5_dbclk", "l4per-clkctrl:0058:8"),
-	DT_CLK(NULL, "gpio6_dbclk", "l4per-clkctrl:0060:8"),
-	DT_CLK(NULL, "gpio7_dbclk", "l4per-clkctrl:00f0:8"),
-	DT_CLK(NULL, "gpio8_dbclk", "l4per-clkctrl:00f8:8"),
-	DT_CLK(NULL, "mcbsp1_gfclk", "abe-clkctrl:0028:24"),
-	DT_CLK(NULL, "mcbsp1_sync_mux_ck", "abe-clkctrl:0028:26"),
-	DT_CLK(NULL, "mcbsp2_gfclk", "abe-clkctrl:0030:24"),
-	DT_CLK(NULL, "mcbsp2_sync_mux_ck", "abe-clkctrl:0030:26"),
-	DT_CLK(NULL, "mcbsp3_gfclk", "abe-clkctrl:0038:24"),
-	DT_CLK(NULL, "mcbsp3_sync_mux_ck", "abe-clkctrl:0038:26"),
-	DT_CLK(NULL, "mmc1_32khz_clk", "l3init-clkctrl:0008:8"),
-	DT_CLK(NULL, "mmc1_fclk", "l3init-clkctrl:0008:25"),
-	DT_CLK(NULL, "mmc1_fclk_mux", "l3init-clkctrl:0008:24"),
-	DT_CLK(NULL, "mmc2_fclk", "l3init-clkctrl:0010:25"),
-	DT_CLK(NULL, "mmc2_fclk_mux", "l3init-clkctrl:0010:24"),
-	DT_CLK(NULL, "sata_ref_clk", "l3init-clkctrl:0068:8"),
-	DT_CLK(NULL, "timer10_gfclk_mux", "l4per-clkctrl:0008:24"),
-	DT_CLK(NULL, "timer11_gfclk_mux", "l4per-clkctrl:0010:24"),
-	DT_CLK(NULL, "timer1_gfclk_mux", "wkupaon-clkctrl:0020:24"),
-	DT_CLK(NULL, "timer2_gfclk_mux", "l4per-clkctrl:0018:24"),
-	DT_CLK(NULL, "timer3_gfclk_mux", "l4per-clkctrl:0020:24"),
-	DT_CLK(NULL, "timer4_gfclk_mux", "l4per-clkctrl:0028:24"),
-	DT_CLK(NULL, "timer5_gfclk_mux", "abe-clkctrl:0048:24"),
-	DT_CLK(NULL, "timer6_gfclk_mux", "abe-clkctrl:0050:24"),
-	DT_CLK(NULL, "timer7_gfclk_mux", "abe-clkctrl:0058:24"),
-	DT_CLK(NULL, "timer8_gfclk_mux", "abe-clkctrl:0060:24"),
-	DT_CLK(NULL, "timer9_gfclk_mux", "l4per-clkctrl:0030:24"),
-	DT_CLK(NULL, "usb_host_hs_hsic480m_p1_clk", "l3init-clkctrl:0038:13"),
-	DT_CLK(NULL, "usb_host_hs_hsic480m_p2_clk", "l3init-clkctrl:0038:14"),
-	DT_CLK(NULL, "usb_host_hs_hsic480m_p3_clk", "l3init-clkctrl:0038:7"),
-	DT_CLK(NULL, "usb_host_hs_hsic60m_p1_clk", "l3init-clkctrl:0038:11"),
-	DT_CLK(NULL, "usb_host_hs_hsic60m_p2_clk", "l3init-clkctrl:0038:12"),
-	DT_CLK(NULL, "usb_host_hs_hsic60m_p3_clk", "l3init-clkctrl:0038:6"),
-	DT_CLK(NULL, "usb_host_hs_utmi_p1_clk", "l3init-clkctrl:0038:8"),
-	DT_CLK(NULL, "usb_host_hs_utmi_p2_clk", "l3init-clkctrl:0038:9"),
-	DT_CLK(NULL, "usb_host_hs_utmi_p3_clk", "l3init-clkctrl:0038:10"),
-	DT_CLK(NULL, "usb_otg_ss_refclk960m", "l3init-clkctrl:00d0:8"),
-	DT_CLK(NULL, "usb_tll_hs_usb_ch0_clk", "l3init-clkctrl:0048:8"),
-	DT_CLK(NULL, "usb_tll_hs_usb_ch1_clk", "l3init-clkctrl:0048:9"),
-	DT_CLK(NULL, "usb_tll_hs_usb_ch2_clk", "l3init-clkctrl:0048:10"),
-	DT_CLK(NULL, "utmi_p1_gfclk", "l3init-clkctrl:0038:24"),
-	DT_CLK(NULL, "utmi_p2_gfclk", "l3init-clkctrl:0038:25"),
+	DT_CLK(NULL, "dmic_gfclk", "abe_cm:0018:24"),
+	DT_CLK(NULL, "dmic_sync_mux_ck", "abe_cm:0018:26"),
+	DT_CLK(NULL, "dss_32khz_clk", "dss_cm:0000:11"),
+	DT_CLK(NULL, "dss_48mhz_clk", "dss_cm:0000:9"),
+	DT_CLK(NULL, "dss_dss_clk", "dss_cm:0000:8"),
+	DT_CLK(NULL, "dss_sys_clk", "dss_cm:0000:10"),
+	DT_CLK(NULL, "gpio1_dbclk", "wkupaon_cm:0018:8"),
+	DT_CLK(NULL, "gpio2_dbclk", "l4per_cm:0040:8"),
+	DT_CLK(NULL, "gpio3_dbclk", "l4per_cm:0048:8"),
+	DT_CLK(NULL, "gpio4_dbclk", "l4per_cm:0050:8"),
+	DT_CLK(NULL, "gpio5_dbclk", "l4per_cm:0058:8"),
+	DT_CLK(NULL, "gpio6_dbclk", "l4per_cm:0060:8"),
+	DT_CLK(NULL, "gpio7_dbclk", "l4per_cm:00f0:8"),
+	DT_CLK(NULL, "gpio8_dbclk", "l4per_cm:00f8:8"),
+	DT_CLK(NULL, "mcbsp1_gfclk", "abe_cm:0028:24"),
+	DT_CLK(NULL, "mcbsp1_sync_mux_ck", "abe_cm:0028:26"),
+	DT_CLK(NULL, "mcbsp2_gfclk", "abe_cm:0030:24"),
+	DT_CLK(NULL, "mcbsp2_sync_mux_ck", "abe_cm:0030:26"),
+	DT_CLK(NULL, "mcbsp3_gfclk", "abe_cm:0038:24"),
+	DT_CLK(NULL, "mcbsp3_sync_mux_ck", "abe_cm:0038:26"),
+	DT_CLK(NULL, "mmc1_32khz_clk", "l3init_cm:0008:8"),
+	DT_CLK(NULL, "mmc1_fclk", "l3init_cm:0008:25"),
+	DT_CLK(NULL, "mmc1_fclk_mux", "l3init_cm:0008:24"),
+	DT_CLK(NULL, "mmc2_fclk", "l3init_cm:0010:25"),
+	DT_CLK(NULL, "mmc2_fclk_mux", "l3init_cm:0010:24"),
+	DT_CLK(NULL, "sata_ref_clk", "l3init_cm:0068:8"),
+	DT_CLK(NULL, "timer10_gfclk_mux", "l4per_cm:0008:24"),
+	DT_CLK(NULL, "timer11_gfclk_mux", "l4per_cm:0010:24"),
+	DT_CLK(NULL, "timer1_gfclk_mux", "wkupaon_cm:0020:24"),
+	DT_CLK(NULL, "timer2_gfclk_mux", "l4per_cm:0018:24"),
+	DT_CLK(NULL, "timer3_gfclk_mux", "l4per_cm:0020:24"),
+	DT_CLK(NULL, "timer4_gfclk_mux", "l4per_cm:0028:24"),
+	DT_CLK(NULL, "timer5_gfclk_mux", "abe_cm:0048:24"),
+	DT_CLK(NULL, "timer6_gfclk_mux", "abe_cm:0050:24"),
+	DT_CLK(NULL, "timer7_gfclk_mux", "abe_cm:0058:24"),
+	DT_CLK(NULL, "timer8_gfclk_mux", "abe_cm:0060:24"),
+	DT_CLK(NULL, "timer9_gfclk_mux", "l4per_cm:0030:24"),
+	DT_CLK(NULL, "usb_host_hs_hsic480m_p1_clk", "l3init_cm:0038:13"),
+	DT_CLK(NULL, "usb_host_hs_hsic480m_p2_clk", "l3init_cm:0038:14"),
+	DT_CLK(NULL, "usb_host_hs_hsic480m_p3_clk", "l3init_cm:0038:7"),
+	DT_CLK(NULL, "usb_host_hs_hsic60m_p1_clk", "l3init_cm:0038:11"),
+	DT_CLK(NULL, "usb_host_hs_hsic60m_p2_clk", "l3init_cm:0038:12"),
+	DT_CLK(NULL, "usb_host_hs_hsic60m_p3_clk", "l3init_cm:0038:6"),
+	DT_CLK(NULL, "usb_host_hs_utmi_p1_clk", "l3init_cm:0038:8"),
+	DT_CLK(NULL, "usb_host_hs_utmi_p2_clk", "l3init_cm:0038:9"),
+	DT_CLK(NULL, "usb_host_hs_utmi_p3_clk", "l3init_cm:0038:10"),
+	DT_CLK(NULL, "usb_otg_ss_refclk960m", "l3init_cm:00d0:8"),
+	DT_CLK(NULL, "usb_tll_hs_usb_ch0_clk", "l3init_cm:0048:8"),
+	DT_CLK(NULL, "usb_tll_hs_usb_ch1_clk", "l3init_cm:0048:9"),
+	DT_CLK(NULL, "usb_tll_hs_usb_ch2_clk", "l3init_cm:0048:10"),
+	DT_CLK(NULL, "utmi_p1_gfclk", "l3init_cm:0038:24"),
+	DT_CLK(NULL, "utmi_p2_gfclk", "l3init_cm:0038:25"),
 	{ .node_name = NULL },
 };
 
--- a/drivers/clk/ti/clkctrl.c
+++ b/drivers/clk/ti/clkctrl.c
@@ -511,6 +511,10 @@ static void __init _ti_omap4_clkctrl_set
 	char *c;
 	u16 soc_mask = 0;
 
+	if (!(ti_clk_get_features()->flags & TI_CLK_CLKCTRL_COMPAT) &&
+	    of_node_name_eq(node, "clk"))
+		ti_clk_features.flags |= TI_CLK_CLKCTRL_COMPAT;
+
 	addrp = of_get_address(node, 0, NULL, NULL);
 	addr = (u32)of_translate_address(node, addrp);
 


