Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4662E1F3050
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 02:58:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728241AbgFHXIq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 19:08:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:54208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726992AbgFHXIp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:08:45 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 13A8C2085B;
        Mon,  8 Jun 2020 23:08:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591657725;
        bh=TT+8tMvqgygFxoAAc7BZuKJHREEz6edhkE6V6E4qA9c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=af7CblJ72Q4b5/8AjOe6ptfhTA2uhYvi5uJb841LlN4IvzfOkiIRs2LgTOWYYxAhX
         QJW4lms//2dBFCVDEw3ktK1hCYaAGc2pjYIghk9LlbXqp1a+gbWU+e+aimRkmWGL3I
         Fl2yHb0NU0HSPJvJXxZlwJgcRTkVsYCMyN4oNYkY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Paul Hsieh <paul.hsieh@amd.com>, Eric Yang <eric.yang2@amd.com>,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.7 117/274] drm/amd/display: dmcu wait loop calculation is incorrect in RV
Date:   Mon,  8 Jun 2020 19:03:30 -0400
Message-Id: <20200608230607.3361041-117-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608230607.3361041-1-sashal@kernel.org>
References: <20200608230607.3361041-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Hsieh <paul.hsieh@amd.com>

[ Upstream commit 7fc5c319efceaed1a23b7ef35c333553ce39fecf ]

[Why]
Driver already get display clock from SMU base on MHz, but driver read
again and mutiple 1000 cause wait loop value is overflow.

[How]
remove coding error

Signed-off-by: Paul Hsieh <paul.hsieh@amd.com>
Reviewed-by: Eric Yang <eric.yang2@amd.com>
Acked-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/amd/display/dc/clk_mgr/dcn10/rv1_clk_mgr_vbios_smu.c   | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn10/rv1_clk_mgr_vbios_smu.c b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn10/rv1_clk_mgr_vbios_smu.c
index 97b7f32294fd..c320b7af7d34 100644
--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn10/rv1_clk_mgr_vbios_smu.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn10/rv1_clk_mgr_vbios_smu.c
@@ -97,9 +97,6 @@ int rv1_vbios_smu_set_dispclk(struct clk_mgr_internal *clk_mgr, int requested_di
 			VBIOSSMC_MSG_SetDispclkFreq,
 			requested_dispclk_khz / 1000);
 
-	/* Actual dispclk set is returned in the parameter register */
-	actual_dispclk_set_mhz = REG_READ(MP1_SMN_C2PMSG_83) * 1000;
-
 	if (!IS_FPGA_MAXIMUS_DC(dc->ctx->dce_environment)) {
 		if (dmcu && dmcu->funcs->is_dmcu_initialized(dmcu)) {
 			if (clk_mgr->dfs_bypass_disp_clk != actual_dispclk_set_mhz)
-- 
2.25.1

