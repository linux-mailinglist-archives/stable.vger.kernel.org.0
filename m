Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB0DF404F53
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 14:20:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350896AbhIIMSM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 08:18:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:53658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352736AbhIIMPH (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 08:15:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E1B1261A2C;
        Thu,  9 Sep 2021 11:49:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188164;
        bh=lOgdxNF0FXJUom5Aw1wbYJCzE2eRXwY51fXUVtgzgBg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vp5oZA6SoxvaGdhjbfjWHHnTEG+e8513EO7BOyNobP+ytRg+mXLkNvMdxZkwmSftl
         vEvMDoxVYcVnqkL30p7F78wskj27nEbGBpRUJ6oESvK+JTy65Wow7d2zpg1Cj1Gpu5
         47TJa56W5gMgRix3+zUWc3wrcVZgdChCaQ4g9VQhPQborYvb0tMpF9qSBpamniYvAk
         B0RL6RTzu8BDESa6SpVwhhev6l9DJCROJg34ijFqkKFbSSZWZOazEJWn0FFJ2HySmD
         ImThRVE/TQJqt2mC3Ec+ppIYwkGxocPbYr/QDlipMByGjr+PKpA+vQf0+B60URir+Q
         P59mYAHYl1tSw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tuo Li <islituo@gmail.com>, TOTE Robot <oslab@tsinghua.edu.cn>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.13 130/219] drm/display: fix possible null-pointer dereference in dcn10_set_clock()
Date:   Thu,  9 Sep 2021 07:45:06 -0400
Message-Id: <20210909114635.143983-130-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114635.143983-1-sashal@kernel.org>
References: <20210909114635.143983-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tuo Li <islituo@gmail.com>

[ Upstream commit 554594567b1fa3da74f88ec7b2dc83d000c58e98 ]

The variable dc->clk_mgr is checked in:
  if (dc->clk_mgr && dc->clk_mgr->funcs->get_clock)

This indicates dc->clk_mgr can be NULL.
However, it is dereferenced in:
    if (!dc->clk_mgr->funcs->get_clock)

To fix this null-pointer dereference, check dc->clk_mgr and the function
pointer dc->clk_mgr->funcs->get_clock earlier, and return if one of them
is NULL.

Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
Signed-off-by: Tuo Li <islituo@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c
index 7c939c0a977b..29f61a8d3e29 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c
@@ -3938,13 +3938,12 @@ enum dc_status dcn10_set_clock(struct dc *dc,
 	struct dc_clock_config clock_cfg = {0};
 	struct dc_clocks *current_clocks = &context->bw_ctx.bw.dcn.clk;
 
-	if (dc->clk_mgr && dc->clk_mgr->funcs->get_clock)
-				dc->clk_mgr->funcs->get_clock(dc->clk_mgr,
-						context, clock_type, &clock_cfg);
-
-	if (!dc->clk_mgr->funcs->get_clock)
+	if (!dc->clk_mgr || !dc->clk_mgr->funcs->get_clock)
 		return DC_FAIL_UNSUPPORTED_1;
 
+	dc->clk_mgr->funcs->get_clock(dc->clk_mgr,
+		context, clock_type, &clock_cfg);
+
 	if (clk_khz > clock_cfg.max_clock_khz)
 		return DC_FAIL_CLK_EXCEED_MAX;
 
@@ -3962,7 +3961,7 @@ enum dc_status dcn10_set_clock(struct dc *dc,
 	else
 		return DC_ERROR_UNEXPECTED;
 
-	if (dc->clk_mgr && dc->clk_mgr->funcs->update_clocks)
+	if (dc->clk_mgr->funcs->update_clocks)
 				dc->clk_mgr->funcs->update_clocks(dc->clk_mgr,
 				context, true);
 	return DC_OK;
-- 
2.30.2

