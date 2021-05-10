Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4627937862F
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:30:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234489AbhEJLEl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:04:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:53006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235023AbhEJK53 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:57:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4795E619D5;
        Mon, 10 May 2021 10:51:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620643860;
        bh=H7ulAp85c03BcRxDPFfrXzC1sbyDKWoUNz+YQOt1LAc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xPRociHToFA7t+DaA3e7SVkIK42Q69BfdjYke/SB/9I2n+7wk2r1epdQqOTyom0xH
         eD59W+LRPu+Tusx/LZOAULlJo45RJUvzLvEPRAI4EoMc6Px8MuJldTyiGrZGe4BJP9
         ZKzqVQwskyvWq5moa3+9nz6TXNTFpitVhIvFn514=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Wheeler <daniel.wheeler@amd.com>,
        Aric Cyr <aric.cyr@amd.com>,
        Solomon Chiu <solomon.chiu@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 172/342] drm/amd/display: DCHUB underflow counter increasing in some scenarios
Date:   Mon, 10 May 2021 12:19:22 +0200
Message-Id: <20210510102015.795905627@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102010.096403571@linuxfoundation.org>
References: <20210510102010.096403571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



