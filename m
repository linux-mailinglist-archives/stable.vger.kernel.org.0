Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CE54313C38
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 19:04:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235234AbhBHSDg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 13:03:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:46610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235083AbhBHSAV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 13:00:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7A6BC64EB1;
        Mon,  8 Feb 2021 17:58:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612807115;
        bh=EBpvZxpRURzDPzWXZ1DQiaM8j4w4EjhTdJ0SgzLhDzA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WXeWiJej4x1RgTj7BiY/g+rLb4ww3L+GrMac/b3ynL6qPAzWqxTTKW1ka2W3axX5Z
         JiYNQ/UD7RIwCAlVFy7mQUrAFoNcM0MoTziG6dUvyNTxguTRuNFMMBI4rhvGSo4ASl
         5GATTKIEAH3OgcYsxK7qMBaa37EFOmiF0D7DEa3HhGIEP9m06ZWQD0lxh4QIEKDgb+
         X5LMH6dmuyfQjg4gTWUnEaOLX8iyrg1pbqW2dA0BO93i1ku6IdJSCtNqXdNwVFA7uC
         AUGMVofRR5LcAfJ6+XSbWW3SrbVfdNPtYrntT1aUdYN0gYaa+DKuLRrV/V2Zin6Jsw
         pxJNwYrMA+O3A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sung Lee <sung.lee@amd.com>, Tony Cheng <Tony.Cheng@amd.com>,
        Anson Jacob <Anson.Jacob@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.10 21/36] drm/amd/display: Add more Clock Sources to DCN2.1
Date:   Mon,  8 Feb 2021 12:57:51 -0500
Message-Id: <20210208175806.2091668-21-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210208175806.2091668-1-sashal@kernel.org>
References: <20210208175806.2091668-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sung Lee <sung.lee@amd.com>

[ Upstream commit 1622711beebe887e4f0f8237fea1f09bb48e9a51 ]

[WHY]
When enabling HDMI on ComboPHY, there are not
enough clock sources to complete display detection.

[HOW]
Initialize more clock sources.

Signed-off-by: Sung Lee <sung.lee@amd.com>
Reviewed-by: Tony Cheng <Tony.Cheng@amd.com>
Acked-by: Anson Jacob <Anson.Jacob@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dcn21/dcn21_resource.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_resource.c b/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_resource.c
index 20441127783ba..c993854404124 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_resource.c
@@ -902,6 +902,8 @@ enum dcn20_clk_src_array_id {
 	DCN20_CLK_SRC_PLL0,
 	DCN20_CLK_SRC_PLL1,
 	DCN20_CLK_SRC_PLL2,
+	DCN20_CLK_SRC_PLL3,
+	DCN20_CLK_SRC_PLL4,
 	DCN20_CLK_SRC_TOTAL_DCN21
 };
 
@@ -1880,6 +1882,14 @@ static bool dcn21_resource_construct(
 			dcn21_clock_source_create(ctx, ctx->dc_bios,
 				CLOCK_SOURCE_COMBO_PHY_PLL2,
 				&clk_src_regs[2], false);
+	pool->base.clock_sources[DCN20_CLK_SRC_PLL3] =
+			dcn21_clock_source_create(ctx, ctx->dc_bios,
+				CLOCK_SOURCE_COMBO_PHY_PLL3,
+				&clk_src_regs[3], false);
+	pool->base.clock_sources[DCN20_CLK_SRC_PLL4] =
+			dcn21_clock_source_create(ctx, ctx->dc_bios,
+				CLOCK_SOURCE_COMBO_PHY_PLL4,
+				&clk_src_regs[4], false);
 
 	pool->base.clk_src_count = DCN20_CLK_SRC_TOTAL_DCN21;
 
-- 
2.27.0

