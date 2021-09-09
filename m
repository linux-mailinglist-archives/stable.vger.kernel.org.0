Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF5BD404C36
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 13:55:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243073AbhIIL4K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 07:56:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:54738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237419AbhIILwV (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 07:52:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9094A61372;
        Thu,  9 Sep 2021 11:44:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631187860;
        bh=5LuBohqvQBhRmRYfLetL1XDC8lNwVpB96plU8EyjnMM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ufjZFbIDtH/Z1PlygCu0+XRxul0D4vk7yv330DCSH7D0qjWT7MftDcypZvJKwNu/G
         LEBudBfHomszFy8X3usc+kOHGWXySJ7muKT+rWjrlNmD9smJQr1zy9SJtPpnS9pJhF
         DiBGE51G25Ccq4W4ZR5YgTPtxYR2fS9kFN+C8KjP8EUM5A5RymQ3NqAjO4RKSx21bS
         bRFAKhAbJM6B5S+1X92aBa3nxRnqhS1gTlCraY4pQ4MELrCGIdtMsJ3fSXqfBB9KtM
         f53QIkvmAQVeq1Ha0b1ZroKWOkeRXNvoIYZFTtZmC2NZm4x4Y/E2pf2lrq6tnLcYif
         F0JD1UsdRJMRg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tuo Li <islituo@gmail.com>, TOTE Robot <oslab@tsinghua.edu.cn>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.14 148/252] drm/display: fix possible null-pointer dereference in dcn10_set_clock()
Date:   Thu,  9 Sep 2021 07:39:22 -0400
Message-Id: <20210909114106.141462-148-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114106.141462-1-sashal@kernel.org>
References: <20210909114106.141462-1-sashal@kernel.org>
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
index dee1ce5f9609..75fa4adcf5f4 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c
@@ -3628,13 +3628,12 @@ enum dc_status dcn10_set_clock(struct dc *dc,
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
 
@@ -3652,7 +3651,7 @@ enum dc_status dcn10_set_clock(struct dc *dc,
 	else
 		return DC_ERROR_UNEXPECTED;
 
-	if (dc->clk_mgr && dc->clk_mgr->funcs->update_clocks)
+	if (dc->clk_mgr->funcs->update_clocks)
 				dc->clk_mgr->funcs->update_clocks(dc->clk_mgr,
 				context, true);
 	return DC_OK;
-- 
2.30.2

