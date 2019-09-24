Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 382CBBCCDA
	for <lists+stable@lfdr.de>; Tue, 24 Sep 2019 18:43:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406800AbfIXQm2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Sep 2019 12:42:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:58778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404380AbfIXQm0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Sep 2019 12:42:26 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D8DE6217D9;
        Tue, 24 Sep 2019 16:42:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569343345;
        bh=UFgLiUOs6x9PlG4jSctQ9LRTyjHREDnXiqnZJRJ+uuk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HJN/2VYmYHECtsXrFb06hzevjrAkQVh+NV8cPJIztGTrkqWsa65m/9PxUqB0pO4pP
         2qUjP5/dyE7SQCZlq/9tyuKxx1S4Lz+AHyp4wGxqS0bt0OgXBKTiLXFpMh++A1wGIi
         TjDHktelThWnk4O2znVHqWLIND2cXJ4N72FKdNd0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        Hersen Wu <hersen.wu@amd.com>, Leo Li <sunpeng.li@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.3 12/87] drm/amd/display: Copy GSL groups when committing a new context
Date:   Tue, 24 Sep 2019 12:40:28 -0400
Message-Id: <20190924164144.25591-12-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190924164144.25591-1-sashal@kernel.org>
References: <20190924164144.25591-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>

[ Upstream commit 21ffcc94d5b3dc024fedac700f1e7f9dacf4ab4f ]

[Why]
DC configures the GSL group for the pipe when pipe_split is enabled
and we're switching flip types (buffered <-> immediate flip) on DCN2.

In order to record what GSL group the pipe is using DC stores it in
the pipe's stream_res. DM is not aware of this internal grouping, nor
is DC resource.

So when DM creates a dc_state context and passes it to DC the current
GSL group is lost - DM never knew about it in the first place.

After 3 immediate flips we run out of GSL groups and we're no longer
able to correctly perform *any* flip for multi-pipe scenarios.

[How]
The gsl_group needs to be copied to the new context.

DM has no insight into GSL grouping and could even potentially create
a brand new context without referencing current hardware state. So this
makes the most sense to have happen in DC.

There are two places where DC can apply a new context:
- dc_commit_state
- dc_commit_updates_for_stream

But what's shared between both of these is apply_ctx_for_surface.

This logic only matters for DCN2, so it can be placed in
dcn20_apply_ctx_for_surface. Before doing any locking (where the GSL
group is setup) we can copy over the GSL groups before committing the
new context.

Signed-off-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Reviewed-by: Hersen Wu <hersen.wu@amd.com>
Acked-by: Leo Li <sunpeng.li@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
index 2627e0a98a96a..f8abe98a576be 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
@@ -1319,6 +1319,18 @@ static void dcn20_apply_ctx_for_surface(
 	if (!top_pipe_to_program)
 		return;
 
+	/* Carry over GSL groups in case the context is changing. */
+	for (i = 0; i < dc->res_pool->pipe_count; i++) {
+		struct pipe_ctx *pipe_ctx = &context->res_ctx.pipe_ctx[i];
+		struct pipe_ctx *old_pipe_ctx =
+			&dc->current_state->res_ctx.pipe_ctx[i];
+
+		if (pipe_ctx->stream == stream &&
+		    pipe_ctx->stream == old_pipe_ctx->stream)
+			pipe_ctx->stream_res.gsl_group =
+				old_pipe_ctx->stream_res.gsl_group;
+	}
+
 	tg = top_pipe_to_program->stream_res.tg;
 
 	interdependent_update = top_pipe_to_program->plane_state &&
-- 
2.20.1

