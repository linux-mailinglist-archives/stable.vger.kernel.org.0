Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47C5D2A593F
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 23:06:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730443AbgKCUl4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:41:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:53848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730422AbgKCUlz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:41:55 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 31C9C2224E;
        Tue,  3 Nov 2020 20:41:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436114;
        bh=aWPaqndB2ANZJ+BGDAmAW3r6pTbR0CgZuWZ1iG+Zm3k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OEya00iMN8UUn9OH+XUK37Y9aJ7KLaMHoBEiWXsHDhvyqTirlgIHW9PPnR/bhog0L
         rXtJF4+Py1HNfTmuRxcF2YtKs/ILlDvbgZOEqbVDqx7NE1hJ1Rgq1DCc91R406uOcw
         /dOCesdPB7s+crMFbkjGtiehX31hWBl3d9j6jlsU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        Aurabindo Pillai <aurabindo.pillai@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 110/391] drm/amd/display: Check clock table return
Date:   Tue,  3 Nov 2020 21:32:41 +0100
Message-Id: <20201103203354.242986885@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 21a3073c8929e..2f8fee05547ac 100644
--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn21/rn_clk_mgr.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn21/rn_clk_mgr.c
@@ -761,6 +761,7 @@ void rn_clk_mgr_construct(
 {
 	struct dc_debug_options *debug = &ctx->dc->debug;
 	struct dpm_clocks clock_table = { 0 };
+	enum pp_smu_status status = 0;
 
 	clk_mgr->base.ctx = ctx;
 	clk_mgr->base.funcs = &dcn21_funcs;
@@ -817,8 +818,10 @@ void rn_clk_mgr_construct(
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
2.27.0



