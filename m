Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE2BE2E38C8
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:16:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732612AbgL1NPE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:15:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:43156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732583AbgL1NPD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:15:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B735121D94;
        Mon, 28 Dec 2020 13:14:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609161262;
        bh=MWHurgC4BsjA3NwXuu2el1M+mmAGPR9FK+lcdwXIh34=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aNCVI2gixB3QJGeKf8N6KzXJKSublqom63H+8ZgSX83kjQjaVp2t/w8BxR01i9LjS
         Jn4YEG/ZVgC575zF4O0B7iiFP8JDh4hAhHYgaPUnjSZ44YkECfuc2QmxFy9joBBY4p
         h/wlhFJ9hnyo+ylVJw9IUqJTmE57b03FJxSNEpao=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmitry Osipenko <digetx@gmail.com>,
        Thierry Reding <treding@nvidia.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 156/242] clk: tegra: Fix duplicated SE clock entry
Date:   Mon, 28 Dec 2020 13:49:21 +0100
Message-Id: <20201228124912.384579194@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124904.654293249@linuxfoundation.org>
References: <20201228124904.654293249@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Osipenko <digetx@gmail.com>

[ Upstream commit 5bf5861d6ea6c3f4b38fc8fda2062b2dc44ac63d ]

The periph_clks[] array contains duplicated entry for Security Engine
clock which was meant to be defined for T210, but it wasn't added
properly. This patch corrects the T210 SE entry and fixes the following
error message on T114/T124: "Tegra clk 127: register failed with -17".

Fixes: dc37fec48314 ("clk: tegra: periph: Add new periph clks and muxes for Tegra210")
Tested-by Nicolas Chauvet <kwizart@gmail.com>
Reported-by Nicolas Chauvet <kwizart@gmail.com>
Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
Link: https://lore.kernel.org/r/20201025224212.7790-1-digetx@gmail.com
Acked-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/tegra/clk-id.h           | 1 +
 drivers/clk/tegra/clk-tegra-periph.c | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/tegra/clk-id.h b/drivers/clk/tegra/clk-id.h
index 11ee5f9ce99e1..4374e4a6b5be5 100644
--- a/drivers/clk/tegra/clk-id.h
+++ b/drivers/clk/tegra/clk-id.h
@@ -234,6 +234,7 @@ enum clk_id {
 	tegra_clk_sdmmc4_8,
 	tegra_clk_sdmmc4_9,
 	tegra_clk_se,
+	tegra_clk_se_10,
 	tegra_clk_soc_therm,
 	tegra_clk_soc_therm_8,
 	tegra_clk_sor0,
diff --git a/drivers/clk/tegra/clk-tegra-periph.c b/drivers/clk/tegra/clk-tegra-periph.c
index d300a256fcacb..ca0735dc70ece 100644
--- a/drivers/clk/tegra/clk-tegra-periph.c
+++ b/drivers/clk/tegra/clk-tegra-periph.c
@@ -673,7 +673,7 @@ static struct tegra_periph_init_data periph_clks[] = {
 	INT8("host1x", mux_pllm_pllc2_c_c3_pllp_plla, CLK_SOURCE_HOST1X, 28, 0, tegra_clk_host1x_8),
 	INT8("host1x", mux_pllc4_out1_pllc_pllc4_out2_pllp_clkm_plla_pllc4_out0, CLK_SOURCE_HOST1X, 28, 0, tegra_clk_host1x_9),
 	INT8("se", mux_pllp_pllc2_c_c3_pllm_clkm, CLK_SOURCE_SE, 127, TEGRA_PERIPH_ON_APB, tegra_clk_se),
-	INT8("se", mux_pllp_pllc2_c_c3_clkm, CLK_SOURCE_SE, 127, TEGRA_PERIPH_ON_APB, tegra_clk_se),
+	INT8("se", mux_pllp_pllc2_c_c3_clkm, CLK_SOURCE_SE, 127, TEGRA_PERIPH_ON_APB, tegra_clk_se_10),
 	INT8("2d", mux_pllm_pllc2_c_c3_pllp_plla, CLK_SOURCE_2D, 21, 0, tegra_clk_gr2d_8),
 	INT8("3d", mux_pllm_pllc2_c_c3_pllp_plla, CLK_SOURCE_3D, 24, 0, tegra_clk_gr3d_8),
 	INT8("vic03", mux_pllm_pllc_pllp_plla_pllc2_c3_clkm, CLK_SOURCE_VIC03, 178, 0, tegra_clk_vic03),
-- 
2.27.0



