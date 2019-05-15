Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F4C21F050
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:43:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732080AbfEOL1i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:27:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:38510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731887AbfEOL1h (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:27:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AC75E20818;
        Wed, 15 May 2019 11:27:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557919657;
        bh=33I4Aosfj8cjXEJXoooJJ3/McdDfAMrkDABR0Qe9Psk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kNIuTlGSqN9y3N2rcXagmUZvuoKMdo48bwl76XpZCKGTm+6rUJvkA0o++PM5OPYUa
         nNpmWZ6L1LBxxR2QHv2kgQniSI4pcf+8KvJebU6tyGGLhHfg9aM7U2pIE0+Q9UHDD1
         GHR/cftfcvejEPGdBkUDFCOPlVPe4Eu9y0zw8ScY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Francis <David.Francis@amd.com>,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        Roman Li <Roman.Li@amd.com>,
        Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>,
        Bhawanpreet Lakha <BhawanpreetLakha@amd.com>
Subject: [PATCH 5.0 045/137] drm/amd/display: If one stream full updates, full update all planes
Date:   Wed, 15 May 2019 12:55:26 +0200
Message-Id: <20190515090656.715043062@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090651.633556783@linuxfoundation.org>
References: <20190515090651.633556783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit c238bfe0be9ef7420f7669a69e27c8c8f4d8a568 ]

[Why]
On some compositors, with two monitors attached, VT terminal
switch can cause a graphical issue by the following means:

There are two streams, one for each monitor. Each stream has one
plane

current state:
	M1:S1->P1
	M2:S2->P2

The user calls for a terminal switch and a commit is made to
change both planes to linear swizzle mode. In atomic check,
a new dc_state is constructed with new planes on each stream

new state:
	M1:S1->P3
	M2:S2->P4

In commit tail, each stream is committed, one at a time. The first
stream (S1) updates properly, triggerring a full update and replacing
the state

current state:
	M1:S1->P3
	M2:S2->P4

The update for S2 comes in, but dc detects that there is no difference
between the stream and plane in the new and current states, and so
triggers a fast update. The fast update does not program swizzle,
so the second monitor is corrupted

[How]
Add a flag to dc_plane_state that forces full updates

When a stream undergoes a full update, set this flag on all changed
planes, then clear it on the current stream

Subsequent streams will get full updates as a result

Signed-off-by: David Francis <David.Francis@amd.com>
Signed-off-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Reviewed-by: Roman Li <Roman.Li@amd.com>
Acked-by: Bhawanpreet Lakha <Bhawanpreet Lakha@amd.com>
Acked-by: Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc.c | 19 +++++++++++++++++++
 drivers/gpu/drm/amd/display/dc/dc.h      |  3 +++
 2 files changed, 22 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc.c b/drivers/gpu/drm/amd/display/dc/core/dc.c
index 1f92e7e8e3d38..5af2ea1f201d3 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -1308,6 +1308,11 @@ static enum surface_update_type det_surface_update(const struct dc *dc,
 		return UPDATE_TYPE_FULL;
 	}
 
+	if (u->surface->force_full_update) {
+		update_flags->bits.full_update = 1;
+		return UPDATE_TYPE_FULL;
+	}
+
 	type = get_plane_info_update_type(u);
 	elevate_update_type(&overall_type, type);
 
@@ -1637,6 +1642,14 @@ void dc_commit_updates_for_stream(struct dc *dc,
 		}
 
 		dc_resource_state_copy_construct(state, context);
+
+		for (i = 0; i < dc->res_pool->pipe_count; i++) {
+			struct pipe_ctx *new_pipe = &context->res_ctx.pipe_ctx[i];
+			struct pipe_ctx *old_pipe = &dc->current_state->res_ctx.pipe_ctx[i];
+
+			if (new_pipe->plane_state && new_pipe->plane_state != old_pipe->plane_state)
+				new_pipe->plane_state->force_full_update = true;
+		}
 	}
 
 
@@ -1680,6 +1693,12 @@ void dc_commit_updates_for_stream(struct dc *dc,
 		dc->current_state = context;
 		dc_release_state(old);
 
+		for (i = 0; i < dc->res_pool->pipe_count; i++) {
+			struct pipe_ctx *pipe_ctx = &context->res_ctx.pipe_ctx[i];
+
+			if (pipe_ctx->plane_state && pipe_ctx->stream == stream)
+				pipe_ctx->plane_state->force_full_update = false;
+		}
 	}
 	/*let's use current_state to update watermark etc*/
 	if (update_type >= UPDATE_TYPE_FULL)
diff --git a/drivers/gpu/drm/amd/display/dc/dc.h b/drivers/gpu/drm/amd/display/dc/dc.h
index 4b5bbb13ce7fe..7d5656d7e460d 100644
--- a/drivers/gpu/drm/amd/display/dc/dc.h
+++ b/drivers/gpu/drm/amd/display/dc/dc.h
@@ -496,6 +496,9 @@ struct dc_plane_state {
 	struct dc_plane_status status;
 	struct dc_context *ctx;
 
+	/* HACK: Workaround for forcing full reprogramming under some conditions */
+	bool force_full_update;
+
 	/* private to dc_surface.c */
 	enum dc_irq_source irq_source;
 	struct kref refcount;
-- 
2.20.1



