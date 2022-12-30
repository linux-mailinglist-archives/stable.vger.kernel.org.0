Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6235A65792A
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 15:58:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233303AbiL1O6v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 09:58:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233326AbiL1O6R (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 09:58:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F14FD12ADA
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 06:58:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 82454B81717
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 14:58:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC184C433EF;
        Wed, 28 Dec 2022 14:58:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672239485;
        bh=dx0tDFaUwUGuJB7D5FsydpyTi6l1neLiMkhKApUeB5A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0z979gUgRrRzPWb9UPb6uIZl4GDYSJvQNk/8Qm51kS+qhHgKPNR8U/Vinuprkr28X
         VSMxlo5ezUR+JuGqRFBjpkbPJ5WF9eufgF7WmkN7BXzZxSHfGyqmxBO4aJ3PEZXoCX
         FrEvk6bqxoXwX/q214SMVO83XUeovv5vQQfIvJ9A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Dario Binacchi <dario.binacchi@amarulasolutions.com>,
        Marco Felsch <m.felsch@pengutronix.de>,
        Abel Vesa <abel.vesa@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 233/731] clk: imx8mn: rename vpu_pll to m7_alt_pll
Date:   Wed, 28 Dec 2022 15:35:40 +0100
Message-Id: <20221228144303.316503755@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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

From: Dario Binacchi <dario.binacchi@amarulasolutions.com>

[ Upstream commit a429c60baefd95ab43a2ce7f25d5b2d7a2e431df ]

The IMX8MN platform does not have any video processing unit (VPU), and
indeed in the reference manual (document IMX8MNRM Rev 2, 07/2022) there
is no occurrence of its pll. From an analysis of the code and the RM
itself, I think vpu pll is used instead of m7 alternate pll, probably
for copy and paste of code taken from modules of similar architectures.

As an example for all, if we consider the second row of the "Clock Root"
table of chapter 5 (Clocks and Power Management) of the RM:

     Clock Root     offset     Source Select (CCM_TARGET_ROOTn[MUX])
        ...          ...                    ...
  ARM_M7_CLK_ROOT   0x8080            000 - 24M_REF_CLK
                                      001 - SYSTEM_PLL2_DIV5
				      010 - SYSTEM_PLL2_DIV4
				      011 - M7_ALT_PLL_CLK
				      100 - SYSTEM_PLL1_CLK
				      101 - AUDIO_PLL1_CLK
				      110 - VIDEO_PLL_CLK
				      111 - SYSTEM_PLL3_CLK
        ...          ...                    ...

but in the source code, the imx8mn_m7_sels clocks list contains vpu_pll
for the source select bits 011b.

So, let's rename "vpu_pll" to "m7_alt_pll" to be consistent with the RM.

The IMX8MN_VPU_* constants have not been removed to ensure backward
compatibility of the patch.

No functional changes intended.

Fixes: 96d6392b54dbb ("clk: imx: Add support for i.MX8MN clock driver")
Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>
Acked-by: Marco Felsch <m.felsch@pengutronix.de>
Reviewed-by: Abel Vesa <abel.vesa@linaro.org>
Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
Link: https://lore.kernel.org/r/20221117113637.1978703-2-dario.binacchi@amarulasolutions.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/imx/clk-imx8mn.c             | 16 ++++++++--------
 include/dt-bindings/clock/imx8mn-clock.h | 12 ++++++++----
 2 files changed, 16 insertions(+), 12 deletions(-)

diff --git a/drivers/clk/imx/clk-imx8mn.c b/drivers/clk/imx/clk-imx8mn.c
index 021355a24708..4f5f368ef25b 100644
--- a/drivers/clk/imx/clk-imx8mn.c
+++ b/drivers/clk/imx/clk-imx8mn.c
@@ -30,7 +30,7 @@ static const char * const audio_pll2_bypass_sels[] = {"audio_pll2", "audio_pll2_
 static const char * const video_pll1_bypass_sels[] = {"video_pll1", "video_pll1_ref_sel", };
 static const char * const dram_pll_bypass_sels[] = {"dram_pll", "dram_pll_ref_sel", };
 static const char * const gpu_pll_bypass_sels[] = {"gpu_pll", "gpu_pll_ref_sel", };
-static const char * const vpu_pll_bypass_sels[] = {"vpu_pll", "vpu_pll_ref_sel", };
+static const char * const m7_alt_pll_bypass_sels[] = {"m7_alt_pll", "m7_alt_pll_ref_sel", };
 static const char * const arm_pll_bypass_sels[] = {"arm_pll", "arm_pll_ref_sel", };
 static const char * const sys_pll3_bypass_sels[] = {"sys_pll3", "sys_pll3_ref_sel", };
 
@@ -40,7 +40,7 @@ static const char * const imx8mn_a53_sels[] = {"osc_24m", "arm_pll_out", "sys_pl
 
 static const char * const imx8mn_a53_core_sels[] = {"arm_a53_div", "arm_pll_out", };
 
-static const char * const imx8mn_m7_sels[] = {"osc_24m", "sys_pll2_200m", "sys_pll2_250m", "vpu_pll_out",
+static const char * const imx8mn_m7_sels[] = {"osc_24m", "sys_pll2_200m", "sys_pll2_250m", "m7_alt_pll_out",
 				       "sys_pll1_800m", "audio_pll1_out", "video_pll1_out", "sys_pll3_out", };
 
 static const char * const imx8mn_gpu_core_sels[] = {"osc_24m", "gpu_pll_out", "sys_pll1_800m",
@@ -228,10 +228,10 @@ static const char * const imx8mn_pwm4_sels[] = {"osc_24m", "sys_pll2_100m", "sys
 						"sys_pll1_80m", "video_pll1_out", };
 
 static const char * const imx8mn_wdog_sels[] = {"osc_24m", "sys_pll1_133m", "sys_pll1_160m",
-						"vpu_pll_out", "sys_pll2_125m", "sys_pll3_out",
+						"m7_alt_pll_out", "sys_pll2_125m", "sys_pll3_out",
 						"sys_pll1_80m", "sys_pll2_166m", };
 
-static const char * const imx8mn_wrclk_sels[] = {"osc_24m", "sys_pll1_40m", "vpu_pll_out",
+static const char * const imx8mn_wrclk_sels[] = {"osc_24m", "sys_pll1_40m", "m7_alt_pll_out",
 						 "sys_pll3_out", "sys_pll2_200m", "sys_pll1_266m",
 						 "sys_pll2_500m", "sys_pll1_100m", };
 
@@ -328,7 +328,7 @@ static int imx8mn_clocks_probe(struct platform_device *pdev)
 	hws[IMX8MN_VIDEO_PLL1_REF_SEL] = imx_clk_hw_mux("video_pll1_ref_sel", base + 0x28, 0, 2, pll_ref_sels, ARRAY_SIZE(pll_ref_sels));
 	hws[IMX8MN_DRAM_PLL_REF_SEL] = imx_clk_hw_mux("dram_pll_ref_sel", base + 0x50, 0, 2, pll_ref_sels, ARRAY_SIZE(pll_ref_sels));
 	hws[IMX8MN_GPU_PLL_REF_SEL] = imx_clk_hw_mux("gpu_pll_ref_sel", base + 0x64, 0, 2, pll_ref_sels, ARRAY_SIZE(pll_ref_sels));
-	hws[IMX8MN_VPU_PLL_REF_SEL] = imx_clk_hw_mux("vpu_pll_ref_sel", base + 0x74, 0, 2, pll_ref_sels, ARRAY_SIZE(pll_ref_sels));
+	hws[IMX8MN_M7_ALT_PLL_REF_SEL] = imx_clk_hw_mux("m7_alt_pll_ref_sel", base + 0x74, 0, 2, pll_ref_sels, ARRAY_SIZE(pll_ref_sels));
 	hws[IMX8MN_ARM_PLL_REF_SEL] = imx_clk_hw_mux("arm_pll_ref_sel", base + 0x84, 0, 2, pll_ref_sels, ARRAY_SIZE(pll_ref_sels));
 	hws[IMX8MN_SYS_PLL3_REF_SEL] = imx_clk_hw_mux("sys_pll3_ref_sel", base + 0x114, 0, 2, pll_ref_sels, ARRAY_SIZE(pll_ref_sels));
 
@@ -337,7 +337,7 @@ static int imx8mn_clocks_probe(struct platform_device *pdev)
 	hws[IMX8MN_VIDEO_PLL1] = imx_clk_hw_pll14xx("video_pll1", "video_pll1_ref_sel", base + 0x28, &imx_1443x_pll);
 	hws[IMX8MN_DRAM_PLL] = imx_clk_hw_pll14xx("dram_pll", "dram_pll_ref_sel", base + 0x50, &imx_1443x_dram_pll);
 	hws[IMX8MN_GPU_PLL] = imx_clk_hw_pll14xx("gpu_pll", "gpu_pll_ref_sel", base + 0x64, &imx_1416x_pll);
-	hws[IMX8MN_VPU_PLL] = imx_clk_hw_pll14xx("vpu_pll", "vpu_pll_ref_sel", base + 0x74, &imx_1416x_pll);
+	hws[IMX8MN_M7_ALT_PLL] = imx_clk_hw_pll14xx("m7_alt_pll", "m7_alt_pll_ref_sel", base + 0x74, &imx_1416x_pll);
 	hws[IMX8MN_ARM_PLL] = imx_clk_hw_pll14xx("arm_pll", "arm_pll_ref_sel", base + 0x84, &imx_1416x_pll);
 	hws[IMX8MN_SYS_PLL1] = imx_clk_hw_fixed("sys_pll1", 800000000);
 	hws[IMX8MN_SYS_PLL2] = imx_clk_hw_fixed("sys_pll2", 1000000000);
@@ -349,7 +349,7 @@ static int imx8mn_clocks_probe(struct platform_device *pdev)
 	hws[IMX8MN_VIDEO_PLL1_BYPASS] = imx_clk_hw_mux_flags("video_pll1_bypass", base + 0x28, 16, 1, video_pll1_bypass_sels, ARRAY_SIZE(video_pll1_bypass_sels), CLK_SET_RATE_PARENT);
 	hws[IMX8MN_DRAM_PLL_BYPASS] = imx_clk_hw_mux_flags("dram_pll_bypass", base + 0x50, 16, 1, dram_pll_bypass_sels, ARRAY_SIZE(dram_pll_bypass_sels), CLK_SET_RATE_PARENT);
 	hws[IMX8MN_GPU_PLL_BYPASS] = imx_clk_hw_mux_flags("gpu_pll_bypass", base + 0x64, 28, 1, gpu_pll_bypass_sels, ARRAY_SIZE(gpu_pll_bypass_sels), CLK_SET_RATE_PARENT);
-	hws[IMX8MN_VPU_PLL_BYPASS] = imx_clk_hw_mux_flags("vpu_pll_bypass", base + 0x74, 28, 1, vpu_pll_bypass_sels, ARRAY_SIZE(vpu_pll_bypass_sels), CLK_SET_RATE_PARENT);
+	hws[IMX8MN_M7_ALT_PLL_BYPASS] = imx_clk_hw_mux_flags("m7_alt_pll_bypass", base + 0x74, 28, 1, m7_alt_pll_bypass_sels, ARRAY_SIZE(m7_alt_pll_bypass_sels), CLK_SET_RATE_PARENT);
 	hws[IMX8MN_ARM_PLL_BYPASS] = imx_clk_hw_mux_flags("arm_pll_bypass", base + 0x84, 28, 1, arm_pll_bypass_sels, ARRAY_SIZE(arm_pll_bypass_sels), CLK_SET_RATE_PARENT);
 	hws[IMX8MN_SYS_PLL3_BYPASS] = imx_clk_hw_mux_flags("sys_pll3_bypass", base + 0x114, 28, 1, sys_pll3_bypass_sels, ARRAY_SIZE(sys_pll3_bypass_sels), CLK_SET_RATE_PARENT);
 
@@ -359,7 +359,7 @@ static int imx8mn_clocks_probe(struct platform_device *pdev)
 	hws[IMX8MN_VIDEO_PLL1_OUT] = imx_clk_hw_gate("video_pll1_out", "video_pll1_bypass", base + 0x28, 13);
 	hws[IMX8MN_DRAM_PLL_OUT] = imx_clk_hw_gate("dram_pll_out", "dram_pll_bypass", base + 0x50, 13);
 	hws[IMX8MN_GPU_PLL_OUT] = imx_clk_hw_gate("gpu_pll_out", "gpu_pll_bypass", base + 0x64, 11);
-	hws[IMX8MN_VPU_PLL_OUT] = imx_clk_hw_gate("vpu_pll_out", "vpu_pll_bypass", base + 0x74, 11);
+	hws[IMX8MN_M7_ALT_PLL_OUT] = imx_clk_hw_gate("m7_alt_pll_out", "m7_alt_pll_bypass", base + 0x74, 11);
 	hws[IMX8MN_ARM_PLL_OUT] = imx_clk_hw_gate("arm_pll_out", "arm_pll_bypass", base + 0x84, 11);
 	hws[IMX8MN_SYS_PLL3_OUT] = imx_clk_hw_gate("sys_pll3_out", "sys_pll3_bypass", base + 0x114, 11);
 
diff --git a/include/dt-bindings/clock/imx8mn-clock.h b/include/dt-bindings/clock/imx8mn-clock.h
index 01e8bab1d767..1aa462e5cafd 100644
--- a/include/dt-bindings/clock/imx8mn-clock.h
+++ b/include/dt-bindings/clock/imx8mn-clock.h
@@ -19,7 +19,8 @@
 #define IMX8MN_VIDEO_PLL1_REF_SEL		10
 #define IMX8MN_DRAM_PLL_REF_SEL			11
 #define IMX8MN_GPU_PLL_REF_SEL			12
-#define IMX8MN_VPU_PLL_REF_SEL			13
+#define IMX8MN_M7_ALT_PLL_REF_SEL		13
+#define IMX8MN_VPU_PLL_REF_SEL			IMX8MN_M7_ALT_PLL_REF_SEL
 #define IMX8MN_ARM_PLL_REF_SEL			14
 #define IMX8MN_SYS_PLL1_REF_SEL			15
 #define IMX8MN_SYS_PLL2_REF_SEL			16
@@ -29,7 +30,8 @@
 #define IMX8MN_VIDEO_PLL1			20
 #define IMX8MN_DRAM_PLL				21
 #define IMX8MN_GPU_PLL				22
-#define IMX8MN_VPU_PLL				23
+#define IMX8MN_M7_ALT_PLL			23
+#define IMX8MN_VPU_PLL				IMX8MN_M7_ALT_PLL
 #define IMX8MN_ARM_PLL				24
 #define IMX8MN_SYS_PLL1				25
 #define IMX8MN_SYS_PLL2				26
@@ -39,7 +41,8 @@
 #define IMX8MN_VIDEO_PLL1_BYPASS		30
 #define IMX8MN_DRAM_PLL_BYPASS			31
 #define IMX8MN_GPU_PLL_BYPASS			32
-#define IMX8MN_VPU_PLL_BYPASS			33
+#define IMX8MN_M7_ALT_PLL_BYPASS		33
+#define IMX8MN_VPU_PLL_BYPASS			IMX8MN_M7_ALT_PLL_BYPASS
 #define IMX8MN_ARM_PLL_BYPASS			34
 #define IMX8MN_SYS_PLL1_BYPASS			35
 #define IMX8MN_SYS_PLL2_BYPASS			36
@@ -49,7 +52,8 @@
 #define IMX8MN_VIDEO_PLL1_OUT			40
 #define IMX8MN_DRAM_PLL_OUT			41
 #define IMX8MN_GPU_PLL_OUT			42
-#define IMX8MN_VPU_PLL_OUT			43
+#define IMX8MN_M7_ALT_PLL_OUT			43
+#define IMX8MN_VPU_PLL_OUT			IMX8MN_M7_ALT_PLL_OUT
 #define IMX8MN_ARM_PLL_OUT			44
 #define IMX8MN_SYS_PLL1_OUT			45
 #define IMX8MN_SYS_PLL2_OUT			46
-- 
2.35.1



