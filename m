Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BE3910BABF
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:07:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732385AbfK0VGN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 16:06:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:60190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731815AbfK0VGM (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 16:06:12 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9A4B821770;
        Wed, 27 Nov 2019 21:06:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574888772;
        bh=uCtfQYjOEF+Ola4zzI7wHRjLy+CCdvWIVjXr1R9YjH8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AICqFzXOr2AowKUYBliO+Mg8TMBBv/p+xIkZx36JZUJ35ZdPLr4hi97ah0b80IxN5
         B7L4wv5PIuDvZCQeSsSfxAV8BPKcIrascDXRASC+ryBHrQUjPJJSBhv/eHwcfWy0W2
         Rhzl/Yn64BOttejghyKNexFrejkXilZkFK/T+ifY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmitry Osipenko <digetx@gmail.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 236/306] clk: tegra20: Turn EMC clock gate into divider
Date:   Wed, 27 Nov 2019 21:31:26 +0100
Message-Id: <20191127203132.244773773@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203114.766709977@linuxfoundation.org>
References: <20191127203114.766709977@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Osipenko <digetx@gmail.com>

[ Upstream commit 514fddba845ed3a1b17e01e99cb3a2a52256a88a ]

Kernel should never gate the EMC clock as it causes immediate lockup, so
removing clk-gate functionality doesn't affect anything. Turning EMC clk
gate into divider allows to implement glitch-less EMC scaling, avoiding
reparenting to a backup clock.

Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
Acked-by: Peter De Schrijver <pdeschrijver@nvidia.com>
Acked-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/tegra/clk-tegra20.c | 36 ++++++++++++++++++++++++---------
 1 file changed, 26 insertions(+), 10 deletions(-)

diff --git a/drivers/clk/tegra/clk-tegra20.c b/drivers/clk/tegra/clk-tegra20.c
index cc857d4d4a86e..68551effb5ca2 100644
--- a/drivers/clk/tegra/clk-tegra20.c
+++ b/drivers/clk/tegra/clk-tegra20.c
@@ -578,7 +578,6 @@ static struct tegra_clk tegra20_clks[tegra_clk_max] __initdata = {
 	[tegra_clk_afi] = { .dt_id = TEGRA20_CLK_AFI, .present = true },
 	[tegra_clk_fuse] = { .dt_id = TEGRA20_CLK_FUSE, .present = true },
 	[tegra_clk_kfuse] = { .dt_id = TEGRA20_CLK_KFUSE, .present = true },
-	[tegra_clk_emc] = { .dt_id = TEGRA20_CLK_EMC, .present = true },
 };
 
 static unsigned long tegra20_clk_measure_input_freq(void)
@@ -799,6 +798,31 @@ static struct tegra_periph_init_data tegra_periph_nodiv_clk_list[] = {
 	TEGRA_INIT_DATA_NODIV("disp2",	mux_pllpdc_clkm, CLK_SOURCE_DISP2, 30, 2, 26,  0, TEGRA20_CLK_DISP2),
 };
 
+static void __init tegra20_emc_clk_init(void)
+{
+	struct clk *clk;
+
+	clk = clk_register_mux(NULL, "emc_mux", mux_pllmcp_clkm,
+			       ARRAY_SIZE(mux_pllmcp_clkm),
+			       CLK_SET_RATE_NO_REPARENT,
+			       clk_base + CLK_SOURCE_EMC,
+			       30, 2, 0, &emc_lock);
+
+	clk = tegra_clk_register_mc("mc", "emc_mux", clk_base + CLK_SOURCE_EMC,
+				    &emc_lock);
+	clks[TEGRA20_CLK_MC] = clk;
+
+	/*
+	 * Note that 'emc_mux' source and 'emc' rate shouldn't be changed at
+	 * the same time due to a HW bug, this won't happen because we're
+	 * defining 'emc_mux' and 'emc' as distinct clocks.
+	 */
+	clk = tegra_clk_register_divider("emc", "emc_mux",
+				clk_base + CLK_SOURCE_EMC, CLK_IS_CRITICAL,
+				TEGRA_DIVIDER_INT, 0, 8, 1, &emc_lock);
+	clks[TEGRA20_CLK_EMC] = clk;
+}
+
 static void __init tegra20_periph_clk_init(void)
 {
 	struct tegra_periph_init_data *data;
@@ -812,15 +836,7 @@ static void __init tegra20_periph_clk_init(void)
 	clks[TEGRA20_CLK_AC97] = clk;
 
 	/* emc */
-	clk = clk_register_mux(NULL, "emc_mux", mux_pllmcp_clkm,
-			       ARRAY_SIZE(mux_pllmcp_clkm),
-			       CLK_SET_RATE_NO_REPARENT,
-			       clk_base + CLK_SOURCE_EMC,
-			       30, 2, 0, &emc_lock);
-
-	clk = tegra_clk_register_mc("mc", "emc_mux", clk_base + CLK_SOURCE_EMC,
-				    &emc_lock);
-	clks[TEGRA20_CLK_MC] = clk;
+	tegra20_emc_clk_init();
 
 	/* dsi */
 	clk = tegra_clk_register_periph_gate("dsi", "pll_d", 0, clk_base, 0,
-- 
2.20.1



