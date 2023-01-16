Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2541F66C602
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:13:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232696AbjAPQNP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:13:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232770AbjAPQMn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:12:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E06152B0B8
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:07:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 380A6B81085
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:07:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85D93C433F0;
        Mon, 16 Jan 2023 16:07:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673885264;
        bh=ifHpNd3XK8MN5Lz6TtqIToAa6TI82pLX1kn7HNJ7/14=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K2C+n9MX8nw1wKH63aSsGIiO0D5LGpSJPDtvABCuuWhGT18GSeYsn/UKyOlzd/p0q
         /bMiiJSi9G3uTpFoO1tip/lhCcDZ6j6FeIWV2oE1VvTlGp6WnlQASskUTveuCceVxV
         csRxS4dAyJcLmK0M5YhJmmY/YKhYCM5rXrPhqpEs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Lucas Stach <l.stach@pengutronix.de>,
        Abel Vesa <abel.vesa@nxp.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 21/64] clk: imx8mp: add clkout1/2 support
Date:   Mon, 16 Jan 2023 16:51:28 +0100
Message-Id: <20230116154744.344026110@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154743.577276578@linuxfoundation.org>
References: <20230116154743.577276578@linuxfoundation.org>
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

From: Lucas Stach <l.stach@pengutronix.de>

[ Upstream commit 43896f56b59eeaf08687fa976257ae7083d01b41 ]

clkout1 and clkout2 allow to supply clocks from the SoC to the board,
which is used by some board designs to provide reference clocks.

Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
Reviewed-by: Abel Vesa <abel.vesa@nxp.com>
Link: https://lore.kernel.org/r/20220427162131.3127303-1-l.stach@pengutronix.de
Signed-off-by: Abel Vesa <abel.vesa@nxp.com>
Stable-dep-of: 5c1f7f109094 ("dt-bindings: clocks: imx8mp: Add ID for usb suspend clock")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/imx/clk-imx8mp.c             | 14 ++++++++++++++
 include/dt-bindings/clock/imx8mp-clock.h |  9 +++++++--
 2 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/imx/clk-imx8mp.c b/drivers/clk/imx/clk-imx8mp.c
index 2af39c8240fa..187044b98bde 100644
--- a/drivers/clk/imx/clk-imx8mp.c
+++ b/drivers/clk/imx/clk-imx8mp.c
@@ -411,6 +411,11 @@ static const char * const imx8mp_sai7_sels[] = {"osc_24m", "audio_pll1_out", "au
 
 static const char * const imx8mp_dram_core_sels[] = {"dram_pll_out", "dram_alt_root", };
 
+static const char * const imx8mp_clkout_sels[] = {"audio_pll1_out", "audio_pll2_out", "video_pll1_out",
+						  "dummy", "dummy", "gpu_pll_out", "vpu_pll_out",
+						  "arm_pll_out", "sys_pll1", "sys_pll2", "sys_pll3",
+						  "dummy", "dummy", "osc_24m", "dummy", "osc_32k"};
+
 static struct clk_hw **hws;
 static struct clk_hw_onecell_data *clk_hw_data;
 
@@ -532,6 +537,15 @@ static int imx8mp_clocks_probe(struct platform_device *pdev)
 	hws[IMX8MP_SYS_PLL2_500M] = imx_clk_hw_fixed_factor("sys_pll2_500m", "sys_pll2_500m_cg", 1, 2);
 	hws[IMX8MP_SYS_PLL2_1000M] = imx_clk_hw_fixed_factor("sys_pll2_1000m", "sys_pll2_out", 1, 1);
 
+	hws[IMX8MP_CLK_CLKOUT1_SEL] = imx_clk_hw_mux2("clkout1_sel", anatop_base + 0x128, 4, 4,
+						      imx8mp_clkout_sels, ARRAY_SIZE(imx8mp_clkout_sels));
+	hws[IMX8MP_CLK_CLKOUT1_DIV] = imx_clk_hw_divider("clkout1_div", "clkout1_sel", anatop_base + 0x128, 0, 4);
+	hws[IMX8MP_CLK_CLKOUT1] = imx_clk_hw_gate("clkout1", "clkout1_div", anatop_base + 0x128, 8);
+	hws[IMX8MP_CLK_CLKOUT2_SEL] = imx_clk_hw_mux2("clkout2_sel", anatop_base + 0x128, 20, 4,
+						      imx8mp_clkout_sels, ARRAY_SIZE(imx8mp_clkout_sels));
+	hws[IMX8MP_CLK_CLKOUT2_DIV] = imx_clk_hw_divider("clkout2_div", "clkout2_sel", anatop_base + 0x128, 16, 4);
+	hws[IMX8MP_CLK_CLKOUT2] = imx_clk_hw_gate("clkout2", "clkout2_div", anatop_base + 0x128, 24);
+
 	hws[IMX8MP_CLK_A53_DIV] = imx8m_clk_hw_composite_core("arm_a53_div", imx8mp_a53_sels, ccm_base + 0x8000);
 	hws[IMX8MP_CLK_A53_SRC] = hws[IMX8MP_CLK_A53_DIV];
 	hws[IMX8MP_CLK_A53_CG] = hws[IMX8MP_CLK_A53_DIV];
diff --git a/include/dt-bindings/clock/imx8mp-clock.h b/include/dt-bindings/clock/imx8mp-clock.h
index 4a621fddfcd3..0ba16b76eb2f 100644
--- a/include/dt-bindings/clock/imx8mp-clock.h
+++ b/include/dt-bindings/clock/imx8mp-clock.h
@@ -321,10 +321,15 @@
 #define IMX8MP_CLK_AUDIO_AXI			310
 #define IMX8MP_CLK_HSIO_AXI			311
 #define IMX8MP_CLK_MEDIA_ISP			312
-
 #define IMX8MP_CLK_MEDIA_DISP2_PIX		313
+#define IMX8MP_CLK_CLKOUT1_SEL			314
+#define IMX8MP_CLK_CLKOUT1_DIV			315
+#define IMX8MP_CLK_CLKOUT1			316
+#define IMX8MP_CLK_CLKOUT2_SEL			317
+#define IMX8MP_CLK_CLKOUT2_DIV			318
+#define IMX8MP_CLK_CLKOUT2			319
 
-#define IMX8MP_CLK_END				314
+#define IMX8MP_CLK_END				320
 
 #define IMX8MP_CLK_AUDIOMIX_SAI1_IPG		0
 #define IMX8MP_CLK_AUDIOMIX_SAI1_MCLK1		1
-- 
2.35.1



