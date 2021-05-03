Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B250D371B52
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 18:45:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232041AbhECQpg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:45:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:50588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231879AbhECQmj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:42:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D72C66142C;
        Mon,  3 May 2021 16:38:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620059892;
        bh=H7ulAp85c03BcRxDPFfrXzC1sbyDKWoUNz+YQOt1LAc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tEZu5adlKWWGBKQmVYAkCe42jgsAkDeMKtpkVCmF6CTVrRtbo+DoTsLBOjP6WAy8f
         skWXIWdY+9bfIjNkB5RCiGNEmk7fVc52gGW6/5My6brT32tYiyYHzhg19qkBddzwmN
         /FVWxH4jbpVm6kp41VwPVKDD9sqE+7/hU92NYX54VjeTVSJBaX1v6TjWfB6gnko3wW
         r7c39egSWdj5nr8SbUipIYExDj+2kQPjKiyVGYWvWAapgJAAVlVYqyrur9qmg6wDU0
         LHHjtEjtgxibFqexlYsWZ6KWvLFD9P9SH2TwzcnepZ3Pm4icNjwcKUdlLNLPo5ZnOt
         vAi27T4tTQm3A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Aric Cyr <aric.cyr@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Solomon Chiu <solomon.chiu@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.11 047/115] drm/amd/display: DCHUB underflow counter increasing in some scenarios
Date:   Mon,  3 May 2021 12:35:51 -0400
Message-Id: <20210503163700.2852194-47-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210503163700.2852194-1-sashal@kernel.org>
References: <20210503163700.2852194-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aric Cyr <aric.cyr@amd.com>

[ Upstream commit 4710430a779e6077d81218ac768787545bff8c49 ]

[Why]
When unplugging a display, the underflow counter can be seen to
increase because PSTATE switch is allowed even when some planes are not
blanked.

[How]
Check that all planes are not active instead of all streams before
allowing PSTATE change.

Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Aric Cyr <aric.cyr@amd.com>
Acked-by: Solomon Chiu <solomon.chiu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/clk_mgr/dcn30/dcn30_clk_mgr.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn30/dcn30_clk_mgr.c b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn30/dcn30_clk_mgr.c
index ab98c259ef69..cbe94cf489c7 100644
--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn30/dcn30_clk_mgr.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn30/dcn30_clk_mgr.c
@@ -252,6 +252,7 @@ static void dcn3_update_clocks(struct clk_mgr *clk_mgr_base,
 	bool force_reset = false;
 	bool update_uclk = false;
 	bool p_state_change_support;
+	int total_plane_count;
 
 	if (dc->work_arounds.skip_clock_update || !clk_mgr->smu_present)
 		return;
@@ -292,7 +293,8 @@ static void dcn3_update_clocks(struct clk_mgr *clk_mgr_base,
 		clk_mgr_base->clks.socclk_khz = new_clocks->socclk_khz;
 
 	clk_mgr_base->clks.prev_p_state_change_support = clk_mgr_base->clks.p_state_change_support;
-	p_state_change_support = new_clocks->p_state_change_support || (display_count == 0);
+	total_plane_count = clk_mgr_helper_get_active_plane_cnt(dc, context);
+	p_state_change_support = new_clocks->p_state_change_support || (total_plane_count == 0);
 	if (should_update_pstate_support(safe_to_lower, p_state_change_support, clk_mgr_base->clks.p_state_change_support)) {
 		clk_mgr_base->clks.p_state_change_support = p_state_change_support;
 
-- 
2.30.2

