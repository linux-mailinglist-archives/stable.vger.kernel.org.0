Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32A1810BD63
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:29:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731227AbfK0U5s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:57:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:48924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730652AbfK0U5s (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:57:48 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5F3222084D;
        Wed, 27 Nov 2019 20:57:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574888266;
        bh=E4lEx/M3dpUWK1f5P4pR88zODDCCQts5gWFfasn091I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LRpDjPBJ8VDpld5r7LgNReQwkH1WFjlQwQQHIaZqa74Zs2sfymGJNSFfiC8nDrcmm
         VmC5GMHIiy/X+APHzAcRyac1azpOkOZnZ7TFARXK2LARJ64nPzSA/hAdWhtcIBbrTm
         J9nB/teCZY1Dw8IDqRWrnMiSf9GqfZfPuUe3of38=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joseph Lo <josephl@nvidia.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Jon Hunter <jonathanh@nvidia.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 069/306] clk: tegra: Fixes for MBIST work around
Date:   Wed, 27 Nov 2019 21:28:39 +0100
Message-Id: <20191127203119.834344295@linuxfoundation.org>
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



