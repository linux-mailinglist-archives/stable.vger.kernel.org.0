Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 622A4FF366
	for <lists+stable@lfdr.de>; Sat, 16 Nov 2019 17:25:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728147AbfKPPmF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Nov 2019 10:42:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:45522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728142AbfKPPmF (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 16 Nov 2019 10:42:05 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 228082084B;
        Sat, 16 Nov 2019 15:42:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573918924;
        bh=E4lEx/M3dpUWK1f5P4pR88zODDCCQts5gWFfasn091I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aE302id1U8tTECaRS7EwrMQCGFXuD0XaTS1smPL64MD2jtcU+qF4IKREAhBEbJIuP
         btOcBGt3xq5Pz21imxUowLrHWgUXf6Rj68yD6RHp1j1JgtcC6n2AnOY/au/gznsTx2
         4uyQUs9JJrTLr1MOdCTOWb74504vldYDzYZ4oEek=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Joseph Lo <josephl@nvidia.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Jon Hunter <jonathanh@nvidia.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-clk@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 050/237] clk: tegra: Fixes for MBIST work around
Date:   Sat, 16 Nov 2019 10:38:05 -0500
Message-Id: <20191116154113.7417-50-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116154113.7417-1-sashal@kernel.org>
References: <20191116154113.7417-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joseph Lo <josephl@nvidia.com>

[ Upstream commit a4dbbceeee3e0ba670875a147237d6566de78840 ]

Fix some incorrect data in LVL2 offset and bit mask.

Fixes: e403d0057343 ("clk: tegra: MBIST work around for Tegra210")
Signed-off-by: Joseph Lo <josephl@nvidia.com>
Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
Acked-by: Jon Hunter <jonathanh@nvidia.com>
Acked-by: Peter De Schrijver <pdeschrijver@nvidia.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/tegra/clk-tegra210.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/clk/tegra/clk-tegra210.c b/drivers/clk/tegra/clk-tegra210.c
index 080bfa24863ee..7264e97310348 100644
--- a/drivers/clk/tegra/clk-tegra210.c
+++ b/drivers/clk/tegra/clk-tegra210.c
@@ -2603,7 +2603,7 @@ static struct tegra210_domain_mbist_war tegra210_pg_mbist_war[] = {
 	[TEGRA_POWERGATE_MPE] = {
 		.handle_lvl2_ovr = tegra210_generic_mbist_war,
 		.lvl2_offset = LVL2_CLK_GATE_OVRE,
-		.lvl2_mask = BIT(2),
+		.lvl2_mask = BIT(29),
 	},
 	[TEGRA_POWERGATE_SOR] = {
 		.handle_lvl2_ovr = tegra210_generic_mbist_war,
@@ -2654,14 +2654,14 @@ static struct tegra210_domain_mbist_war tegra210_pg_mbist_war[] = {
 		.num_clks = ARRAY_SIZE(nvdec_slcg_clkids),
 		.clk_init_data = nvdec_slcg_clkids,
 		.handle_lvl2_ovr = tegra210_generic_mbist_war,
-		.lvl2_offset = LVL2_CLK_GATE_OVRC,
+		.lvl2_offset = LVL2_CLK_GATE_OVRE,
 		.lvl2_mask = BIT(9) | BIT(31),
 	},
 	[TEGRA_POWERGATE_NVJPG] = {
 		.num_clks = ARRAY_SIZE(nvjpg_slcg_clkids),
 		.clk_init_data = nvjpg_slcg_clkids,
 		.handle_lvl2_ovr = tegra210_generic_mbist_war,
-		.lvl2_offset = LVL2_CLK_GATE_OVRC,
+		.lvl2_offset = LVL2_CLK_GATE_OVRE,
 		.lvl2_mask = BIT(9) | BIT(31),
 	},
 	[TEGRA_POWERGATE_AUD] = {
-- 
2.20.1

