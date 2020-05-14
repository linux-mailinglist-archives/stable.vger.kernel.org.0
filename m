Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C08331D39E8
	for <lists+stable@lfdr.de>; Thu, 14 May 2020 20:53:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728467AbgENSwt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 May 2020 14:52:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:51232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728451AbgENSwq (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 May 2020 14:52:46 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3B524206DC;
        Thu, 14 May 2020 18:52:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589482366;
        bh=cvoD8Qxudo0h98aKEW9NlNSH6GhsR3nh//6Euzu4X2Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wKkQ5yI0PPD3b89pNQ7tXiXyfknqUtODN4jFKotj5q7bAIDD3IWEzJDMHxzXyRVq3
         jfzUahiTVegjrP6TjNC2u0lVYGoldzeXgfZgi0S1dk9Sdl2IOAdSDIc+odtsV+iRfI
         lKedt4CQzNzlgXA9lKONAgOI2wPiLN8NynqjvALk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Roman Li <roman.li@amd.com>, Zhan Liu <Zhan.Liu@amd.com>,
        Aurabindo Pillai <aurabindo.pillai@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.6 45/62] drm/amd/display: fix counter in wait_for_no_pipes_pending
Date:   Thu, 14 May 2020 14:51:30 -0400
Message-Id: <20200514185147.19716-45-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200514185147.19716-1-sashal@kernel.org>
References: <20200514185147.19716-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roman Li <roman.li@amd.com>

[ Upstream commit 80797dd6f1a525d1160c463d6a9f9d29af182cbb ]

[Why]
Wait counter is not being reset for each pipe.

[How]
Move counter reset into pipe loop scope.

Signed-off-by: Roman Li <roman.li@amd.com>
Reviewed-by: Zhan Liu <Zhan.Liu@amd.com>
Acked-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc.c b/drivers/gpu/drm/amd/display/dc/core/dc.c
index 188e51600070b..b3987124183a7 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -803,11 +803,10 @@ static void disable_dangling_plane(struct dc *dc, struct dc_state *context)
 static void wait_for_no_pipes_pending(struct dc *dc, struct dc_state *context)
 {
 	int i;
-	int count = 0;
-	struct pipe_ctx *pipe;
 	PERF_TRACE();
 	for (i = 0; i < MAX_PIPES; i++) {
-		pipe = &context->res_ctx.pipe_ctx[i];
+		int count = 0;
+		struct pipe_ctx *pipe = &context->res_ctx.pipe_ctx[i];
 
 		if (!pipe->plane_state)
 			continue;
-- 
2.20.1

