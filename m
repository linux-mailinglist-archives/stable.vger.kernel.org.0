Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0751F610B8D
	for <lists+stable@lfdr.de>; Fri, 28 Oct 2022 09:49:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230229AbiJ1HtR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Oct 2022 03:49:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229962AbiJ1HtQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Oct 2022 03:49:16 -0400
Received: from relay5-d.mail.gandi.net (relay5-d.mail.gandi.net [217.70.183.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E78419ABE7;
        Fri, 28 Oct 2022 00:49:15 -0700 (PDT)
Received: from booty.fritz.box (unknown [77.244.183.192])
        (Authenticated sender: luca.ceresoli@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPA id E92141C0002;
        Fri, 28 Oct 2022 07:49:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1666943353;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=m0oOZ7l6RvS8VTaNyT1SmYC8MhtuXGooOBg79bTfEm4=;
        b=mdVRAKjAmqXAEtpaIwhfCi/rf7DHOZx/gC3jDRriH1FZY0O/hDmwlu+bQux9smX7b6AUm+
        gOrFrbQPsVr0f5uwEPDH7ic7XQfK1SOJENmxclMb3XRhSs4Ngtj1ekQxQWp1p+RgjmDZMF
        t/5t7V9yhHbfKGUViZnGmgQ+WsDvoiUDTswTdvnMSneIY5A9QaKoqIzBCAP0ZMKMDtEI3E
        Cc66hEsNGMEwu7UHh49EEGNrroWaynC2/B2f+eFiXUrG7rIlEPD8H7lhXILaL4gW52z7O0
        DDH5V5UoXFxKM3+oR7hryFXUVczlWTBXYAAFX4IsOHyeJBpuvNyZobLh0ik1Vg==
From:   luca.ceresoli@bootlin.com
To:     linux-tegra@vger.kernel.org
Cc:     Luca Ceresoli <luca.ceresoli@bootlin.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        linux-clk@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        stable@vger.kernel.org
Subject: [PATCH] clk: tegra: fix HOST1X clock divider on Tegra20 and Tegra30
Date:   Fri, 28 Oct 2022 09:48:26 +0200
Message-Id: <20221028074826.2317640-1-luca.ceresoli@bootlin.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luca Ceresoli <luca.ceresoli@bootlin.com>

On Tegra20 and Tegra30 the HOST1X clock is a fractional clock divider with
7 integer bits + 1 decimal bit. This has been verified on both
documentation and real hardware for Tegra20 an on the documentation I was
able to find for Tegra30.

However in the kernel code this clock is declared as an integer divider. A
consequence of this is that requesting 144 MHz for HOST1X which is fed by
pll_p running at 216 MHz would result in 108 MHz (216 / 2) instead of 144
MHz (216 / 1.5).

Fix by replacing the INT() macro with the MUX() macro which, despite the
name, defines a fractional divider. The only difference between the two
macros is the former does not have the TEGRA_DIVIDER_INT flag.

Also move the line together with the other MUX*() ones to keep the existing
file organization.

Fixes: 76ebc134d45d ("clk: tegra: move periph clocks to common file")
Cc: stable@vger.kernel.org
Cc: Peter De Schrijver <pdeschrijver@nvidia.com>
Signed-off-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
---
 drivers/clk/tegra/clk-tegra-periph.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/tegra/clk-tegra-periph.c b/drivers/clk/tegra/clk-tegra-periph.c
index 4dcf7f7cb8a0..806d835ca0d2 100644
--- a/drivers/clk/tegra/clk-tegra-periph.c
+++ b/drivers/clk/tegra/clk-tegra-periph.c
@@ -615,7 +615,6 @@ static struct tegra_periph_init_data periph_clks[] = {
 	INT("vde", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_VDE, 61, 0, tegra_clk_vde),
 	INT("vi", mux_pllm_pllc_pllp_plla, CLK_SOURCE_VI, 20, 0, tegra_clk_vi),
 	INT("epp", mux_pllm_pllc_pllp_plla, CLK_SOURCE_EPP, 19, 0, tegra_clk_epp),
-	INT("host1x", mux_pllm_pllc_pllp_plla, CLK_SOURCE_HOST1X, 28, 0, tegra_clk_host1x),
 	INT("mpe", mux_pllm_pllc_pllp_plla, CLK_SOURCE_MPE, 60, 0, tegra_clk_mpe),
 	INT("2d", mux_pllm_pllc_pllp_plla, CLK_SOURCE_2D, 21, 0, tegra_clk_gr2d),
 	INT("3d", mux_pllm_pllc_pllp_plla, CLK_SOURCE_3D, 24, 0, tegra_clk_gr3d),
@@ -664,6 +663,7 @@ static struct tegra_periph_init_data periph_clks[] = {
 	MUX("owr", mux_pllp_pllc_clkm, CLK_SOURCE_OWR, 71, TEGRA_PERIPH_ON_APB, tegra_clk_owr_8),
 	MUX("nor", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_NOR, 42, 0, tegra_clk_nor),
 	MUX("mipi", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_MIPI, 50, TEGRA_PERIPH_ON_APB, tegra_clk_mipi),
+	MUX("host1x", mux_pllm_pllc_pllp_plla, CLK_SOURCE_HOST1X, 28, 0, tegra_clk_host1x),
 	MUX("vi_sensor", mux_pllm_pllc_pllp_plla, CLK_SOURCE_VI_SENSOR, 20, TEGRA_PERIPH_NO_RESET, tegra_clk_vi_sensor),
 	MUX("vi_sensor", mux_pllc_pllp_plla, CLK_SOURCE_VI_SENSOR, 20, TEGRA_PERIPH_NO_RESET, tegra_clk_vi_sensor_9),
 	MUX("cilab", mux_pllp_pllc_clkm, CLK_SOURCE_CILAB, 144, 0, tegra_clk_cilab),
-- 
2.34.1

