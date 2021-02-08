Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5161B313C89
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 19:08:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235309AbhBHSHj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 13:07:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:47384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235286AbhBHSDB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 13:03:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C2C8664ED5;
        Mon,  8 Feb 2021 17:59:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612807152;
        bh=YEGS8lk8azlNq7lt88NrazHPZNuQUIzIJP3/v+i7dUM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BuUYYwqQn4c4VtCFOLr98sHv2wLUBzXUjABDuGFu8s/iC2mQ4j0AOUQLcRn3ea0FG
         VBvglKUz59mk0zOWM9rIANfRicZMmVrAOS7hCBP4okaFy8bgubjyaDumBUFBc5IjCH
         ybWCQej0WWLmRRYyMGiUPMo//PHyq2ngc/pftVMtJt7VQ0oncQaZIM2IJjmW8I02fk
         Gmnx2XFV7r6+IKtb9Vjur6SOU29I9NxrwC6LQ1+0oYs1b3O7phpipS5NSE7dnb5pJD
         Fu+dZdjjIh30end1Qc6XFiR9oDW6J6Agh4jD1H5wGefLlVeG6Rs/V0Brt3tK1vF0nQ
         8qlG3CMj0dtIA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sung Lee <sung.lee@amd.com>, Tony Cheng <Tony.Cheng@amd.com>,
        Anson Jacob <Anson.Jacob@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 10/19] drm/amd/display: Add more Clock Sources to DCN2.1
Date:   Mon,  8 Feb 2021 12:58:49 -0500
Message-Id: <20210208175858.2092008-10-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210208175858.2092008-1-sashal@kernel.org>
References: <20210208175858.2092008-1-sashal@kernel.org>
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
index a6d5beada6634..f63cbbee7b337 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_resource.c
@@ -826,6 +826,8 @@ enum dcn20_clk_src_array_id {
 	DCN20_CLK_SRC_PLL0,
 	DCN20_CLK_SRC_PLL1,
 	DCN20_CLK_SRC_PLL2,
+	DCN20_CLK_SRC_PLL3,
+	DCN20_CLK_SRC_PLL4,
 	DCN20_CLK_SRC_TOTAL_DCN21
 };
 
@@ -1498,6 +1500,14 @@ static bool construct(
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

