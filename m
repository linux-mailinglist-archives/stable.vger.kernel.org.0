Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D32A299FBC
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 01:25:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410062AbgJZXxY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Oct 2020 19:53:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:57728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2410053AbgJZXxX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Oct 2020 19:53:23 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 487F42151B;
        Mon, 26 Oct 2020 23:53:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603756403;
        bh=0coM9A8x/YGE0BscLSA59VPascxQ21PgmSXSC7yGRpo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oSvbBZGcmJvAFU9QlL03B+4HgdmHsfJSTIeyfTjp/NP+XGllpslfIQ3PIQ9veBF7D
         OXfaPZqTZbzcyKSZgMkT2QgWCnTIwBBUaP1GxZIZhzPOHiWChHfqQtRJTJLpM0z1zL
         jyAoecTuzJNthbGnnXe7Y6DAhV2XXKjiGw5JFNbQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        Aurabindo Pillai <aurabindo.pillai@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.8 062/132] drm/amd/display: Check clock table return
Date:   Mon, 26 Oct 2020 19:50:54 -0400
Message-Id: <20201026235205.1023962-62-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201026235205.1023962-1-sashal@kernel.org>
References: <20201026235205.1023962-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>

[ Upstream commit 4b4f21ff7f5d11bb77e169b306dcbc5b216f5db5 ]

During the load processes for Renoir, our display code needs to retrieve
the SMU clock and voltage table, however, this operation can fail which
means that we have to check this scenario. Currently, we are not
handling this case properly and as a result, we have seen the following
dmesg log during the boot:

RIP: 0010:rn_clk_mgr_construct+0x129/0x3d0 [amdgpu]
...
Call Trace:
 dc_clk_mgr_create+0x16a/0x1b0 [amdgpu]
 dc_create+0x231/0x760 [amdgpu]

This commit fixes this issue by checking the return status retrieved
from the clock table before try to populate any bandwidth.

Signed-off-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Acked-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/clk_mgr/dcn21/rn_clk_mgr.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn21/rn_clk_mgr.c b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn21/rn_clk_mgr.c
index 24c5765890fa7..14f21a7307791 100644
--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn21/rn_clk_mgr.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn21/rn_clk_mgr.c
@@ -699,6 +699,7 @@ void rn_clk_mgr_construct(
 {
 	struct dc_debug_options *debug = &ctx->dc->debug;
 	struct dpm_clocks clock_table = { 0 };
+	enum pp_smu_status status = 0;
 
 	clk_mgr->base.ctx = ctx;
 	clk_mgr->base.funcs = &dcn21_funcs;
@@ -751,8 +752,10 @@ void rn_clk_mgr_construct(
 	clk_mgr->base.bw_params = &rn_bw_params;
 
 	if (pp_smu && pp_smu->rn_funcs.get_dpm_clock_table) {
-		pp_smu->rn_funcs.get_dpm_clock_table(&pp_smu->rn_funcs.pp_smu, &clock_table);
-		if (ctx->dc_bios && ctx->dc_bios->integrated_info) {
+		status = pp_smu->rn_funcs.get_dpm_clock_table(&pp_smu->rn_funcs.pp_smu, &clock_table);
+
+		if (status == PP_SMU_RESULT_OK &&
+		    ctx->dc_bios && ctx->dc_bios->integrated_info) {
 			rn_clk_mgr_helper_populate_bw_params (clk_mgr->base.bw_params, &clock_table, ctx->dc_bios->integrated_info);
 		}
 	}
-- 
2.25.1

