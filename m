Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F52C311412
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 23:00:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232878AbhBEV6N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 16:58:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:44982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232882AbhBEO71 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Feb 2021 09:59:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3B4186501C;
        Fri,  5 Feb 2021 14:11:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612534261;
        bh=hvCJgtiskHqwsFaSnJ8nJEeTGp3QERMQ4m5jFCX8rKw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jTy5cbxwOxNQJGBqcx64vLwGRwNv/55Yj1UVRhKEOXmQLcoXjTq16/ifRKhi+ENON
         riW9WzOJ7O3Vz4COcc1Hfd1LFW5Rm+rkk8Et7sOhwcwfXbgbn0ii+o5Xx4+2w2mBav
         BP4iop5qu5kFUVpjuVRZpHFE8n2SejqbREDM64Uw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Wheeler <daniel.wheeler@amd.com>,
        Aric Cyr <aric.cyr@amd.com>, Jun Lei <Jun.Lei@amd.com>,
        Anson Jacob <anson.jacob@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 47/57] drm/amd/display: Allow PSTATE chnage when no displays are enabled
Date:   Fri,  5 Feb 2021 15:07:13 +0100
Message-Id: <20210205140657.994940469@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210205140655.982616732@linuxfoundation.org>
References: <20210205140655.982616732@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aric Cyr <aric.cyr@amd.com>

[ Upstream commit 8bc3d461d0a95bbcc2a0a908bbadc87e198a86a8 ]

[Why]
When no displays are currently enabled, display driver should not
disallow PSTATE switching.

[How]
Allow PSTATE switching if either the active configuration supports it,
or there are no active displays.

Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Aric Cyr <aric.cyr@amd.com>
Reviewed-by: Jun Lei <Jun.Lei@amd.com>
Acked-by: Anson Jacob <anson.jacob@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/dc/clk_mgr/dcn30/dcn30_clk_mgr.c    | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn30/dcn30_clk_mgr.c b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn30/dcn30_clk_mgr.c
index b0e9b0509568c..95d883482227e 100644
--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn30/dcn30_clk_mgr.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn30/dcn30_clk_mgr.c
@@ -239,6 +239,7 @@ static void dcn3_update_clocks(struct clk_mgr *clk_mgr_base,
 	struct dmcu *dmcu = clk_mgr_base->ctx->dc->res_pool->dmcu;
 	bool force_reset = false;
 	bool update_uclk = false;
+	bool p_state_change_support;
 
 	if (dc->work_arounds.skip_clock_update || !clk_mgr->smu_present)
 		return;
@@ -279,8 +280,9 @@ static void dcn3_update_clocks(struct clk_mgr *clk_mgr_base,
 		clk_mgr_base->clks.socclk_khz = new_clocks->socclk_khz;
 
 	clk_mgr_base->clks.prev_p_state_change_support = clk_mgr_base->clks.p_state_change_support;
-	if (should_update_pstate_support(safe_to_lower, new_clocks->p_state_change_support, clk_mgr_base->clks.p_state_change_support)) {
-		clk_mgr_base->clks.p_state_change_support = new_clocks->p_state_change_support;
+	p_state_change_support = new_clocks->p_state_change_support || (display_count == 0);
+	if (should_update_pstate_support(safe_to_lower, p_state_change_support, clk_mgr_base->clks.p_state_change_support)) {
+		clk_mgr_base->clks.p_state_change_support = p_state_change_support;
 
 		/* to disable P-State switching, set UCLK min = max */
 		if (!clk_mgr_base->clks.p_state_change_support)
-- 
2.27.0



