Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8AFEDCD6D5
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 19:51:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730740AbfJFRjP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 13:39:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:38718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730741AbfJFRjP (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Oct 2019 13:39:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D9DE420700;
        Sun,  6 Oct 2019 17:39:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570383554;
        bh=UFgLiUOs6x9PlG4jSctQ9LRTyjHREDnXiqnZJRJ+uuk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qDlwC+IMwUBGeC3H1L6qIw65i0CqOOOQb7+bfLdU/o+C0KywlvmOVGFYMxB8kFnu0
         pE5d5o002KTYTWKfzLBpmmtzhp8M/qUAA1Qyqy7u/3uFqqhBWl62M5/5MuMZha9qZS
         +nJx6KMlXWm01I6SdJ5aR3qFn30I7uYklcTbWXjw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        Hersen Wu <hersen.wu@amd.com>, Leo Li <sunpeng.li@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 010/166] drm/amd/display: Copy GSL groups when committing a new context
Date:   Sun,  6 Oct 2019 19:19:36 +0200
Message-Id: <20191006171213.491744259@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191006171212.850660298@linuxfoundation.org>
References: <20191006171212.850660298@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



