Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E83C4051D4
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 14:46:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353481AbhIIMi5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 08:38:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:39608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351172AbhIIMeO (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 08:34:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0AA2B6135F;
        Thu,  9 Sep 2021 11:53:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188415;
        bh=f/x94BKXVtLCgWGdN4LWr4PMGYpzsb3r3DjsQl4NM0o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hhgbdqD695At9Payr/bCTCL1NZNbHAGjjnrBvKkhxyndKjUZ4yAy84SJhLi4MG5sm
         LiDmqbeTm6tQVjAUTN7u5AHE3Xu3T7dBUEAAkDqR6jmm6tgQGlBg3+7HZex2blaZ42
         27dK5HdC7fVU380QVVYPMLbanmB01KLHpVDo/7rP5ixOrmXo3qi3TM1fJiRXJbLgke
         E2QFGoLqKKt1tSLm0ymvKukK5C3TQ5LJ8bplUa5iu079CM2yNo21wHpFJgzU1fqhLt
         Yk0pwXUBOtN1sFki+WRjq9Og5pDSsBaspWEYXblJ+ytvAxeulJYCSUjgs+kjhtp6OY
         nbZL3c3TX6O5w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tuo Li <islituo@gmail.com>, TOTE Robot <oslab@tsinghua.edu.cn>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.10 106/176] drm/display: fix possible null-pointer dereference in dcn10_set_clock()
Date:   Thu,  9 Sep 2021 07:50:08 -0400
Message-Id: <20210909115118.146181-106-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909115118.146181-1-sashal@kernel.org>
References: <20210909115118.146181-1-sashal@kernel.org>
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
index 0d1e7b56fb39..532f6a1145b5 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c
@@ -3740,13 +3740,12 @@ enum dc_status dcn10_set_clock(struct dc *dc,
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
 
@@ -3764,7 +3763,7 @@ enum dc_status dcn10_set_clock(struct dc *dc,
 	else
 		return DC_ERROR_UNEXPECTED;
 
-	if (dc->clk_mgr && dc->clk_mgr->funcs->update_clocks)
+	if (dc->clk_mgr->funcs->update_clocks)
 				dc->clk_mgr->funcs->update_clocks(dc->clk_mgr,
 				context, true);
 	return DC_OK;
-- 
2.30.2

