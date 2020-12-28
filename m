Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0D6E2E6566
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:01:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391016AbgL1QAj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 11:00:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:32824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387706AbgL1NcO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:32:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id ACE5422583;
        Mon, 28 Dec 2020 13:31:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609162293;
        bh=d7K6FNTltxYmF8YpQVlnYX/McXKMHfiFPXfzg2Spm9M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QdPGRXzeKYdLSfbnG8z4UQ+6LjJaUP/AZhzLao2skgylgyLHl92qys4cdwHv/ZOyz
         SBpAxhlcO2IrnKpOAvqYyYfsSVjyREju+m0SH6HZ3YEWFBpqhw/g4KEtvznfLwDJYO
         nk+6giXdHP0+6VTxCXqFrd8EenwWTKLb7MuCm1js=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmitry Osipenko <digetx@gmail.com>,
        Thierry Reding <treding@nvidia.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 223/346] clk: tegra: Fix duplicated SE clock entry
Date:   Mon, 28 Dec 2020 13:49:02 +0100
Message-Id: <20201228124930.552569712@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124919.745526410@linuxfoundation.org>
References: <20201228124919.745526410@linuxfoundation.org>
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
index de466b4446da9..0efcb200dde5a 100644
--- a/drivers/clk/tegra/clk-id.h
+++ b/drivers/clk/tegra/clk-id.h
@@ -233,6 +233,7 @@ enum clk_id {
 	tegra_clk_sdmmc4,
 	tegra_clk_sdmmc4_8,
 	tegra_clk_se,
+	tegra_clk_se_10,
 	tegra_clk_soc_therm,
 	tegra_clk_soc_therm_8,
 	tegra_clk_sor0,
diff --git a/drivers/clk/tegra/clk-tegra-periph.c b/drivers/clk/tegra/clk-tegra-periph.c
index b137c5d34eec4..9d05fb48686db 100644
--- a/drivers/clk/tegra/clk-tegra-periph.c
+++ b/drivers/clk/tegra/clk-tegra-periph.c
@@ -650,7 +650,7 @@ static struct tegra_periph_init_data periph_clks[] = {
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



