Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EDD21F2D79
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 02:34:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731373AbgFIAdt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 20:33:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:35260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729903AbgFHXOp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:14:45 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BC51B2158C;
        Mon,  8 Jun 2020 23:14:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658085;
        bh=mRhGw7qR37r16r1P8tKnMThQNVCj3v9b08mSdxj9QVw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G5Ur+A9Ck0zyRNmmAIThPUlLHiLun/te3bWu0SqKiUbeabmqLs8vdyOoeC6VRGFFf
         0dhwjViWWQEkw8V+ar+tPDpDysLHz38mmJX0BbQziHkHU2PSE1yVOCUkaOpWsOYG1y
         XEiT7+crIzhA4ahm5GlMWA7NHa0gUkHkXEoAcIBU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Roman Li <roman.li@amd.com>, Zhan Liu <Zhan.Liu@amd.com>,
        Aurabindo Pillai <aurabindo.pillai@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.6 129/606] drm/amd/display: fix counter in wait_for_no_pipes_pending
Date:   Mon,  8 Jun 2020 19:04:14 -0400
Message-Id: <20200608231211.3363633-129-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231211.3363633-1-sashal@kernel.org>
References: <20200608231211.3363633-1-sashal@kernel.org>
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
index 188e51600070..b3987124183a 100644
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
2.25.1

