Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73C46DD3D2
	for <lists+stable@lfdr.de>; Sat, 19 Oct 2019 00:21:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394010AbfJRWUa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 18:20:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:38596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731836AbfJRWGj (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Oct 2019 18:06:39 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 78629222C2;
        Fri, 18 Oct 2019 22:06:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571436398;
        bh=sP7BL7tqYErBOvL8W0EM0ifrxBAL2ZwmaMUBXDKCsdQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=valtOsQvBzlvgw7jNJ5cyJgTEKRNy5EHCpL5VXtTx1yj7OG3/oIUs5K82jSFZd5j9
         wMe4aMOj0mK9yEgHYn6YnwiBle0tTBAVmUoUa0mxRxmOXRTQmcUCwrSJTQaYgnCp6Y
         lnM+e4HsvKf7Gc6zCEaZngFN4TgolzqoR9WcE+fI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dmytro Laktyushkin <Dmytro.Laktyushkin@amd.com>,
        Tony Cheng <Tony.Cheng@amd.com>,
        Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.19 048/100] drm/amd/display: fix odm combine pipe reset
Date:   Fri, 18 Oct 2019 18:04:33 -0400
Message-Id: <20191018220525.9042-48-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191018220525.9042-1-sashal@kernel.org>
References: <20191018220525.9042-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmytro Laktyushkin <Dmytro.Laktyushkin@amd.com>

[ Upstream commit f25f06b67ba237b76092a6fc522b1a94e84bfa85 ]

We fail to reset the second odm combine pipe. This change fixes
odm pointer management.

Signed-off-by: Dmytro Laktyushkin <Dmytro.Laktyushkin@amd.com>
Reviewed-by: Tony Cheng <Tony.Cheng@amd.com>
Acked-by: Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc_resource.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_resource.c b/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
index d440b28ee43fb..6896d69b8c240 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
@@ -1399,9 +1399,9 @@ bool dc_remove_plane_from_context(
 			 * For head pipe detach surfaces from pipe for tail
 			 * pipe just zero it out
 			 */
-			if (!pipe_ctx->top_pipe ||
-				(!pipe_ctx->top_pipe->top_pipe &&
+			if (!pipe_ctx->top_pipe || (!pipe_ctx->top_pipe->top_pipe &&
 					pipe_ctx->top_pipe->stream_res.opp != pipe_ctx->stream_res.opp)) {
+				pipe_ctx->top_pipe = NULL;
 				pipe_ctx->plane_state = NULL;
 				pipe_ctx->bottom_pipe = NULL;
 			} else {
@@ -1803,8 +1803,6 @@ enum dc_status dc_remove_stream_from_ctx(
 				dc->res_pool->funcs->remove_stream_from_ctx(dc, new_ctx, stream);
 
 			memset(del_pipe, 0, sizeof(*del_pipe));
-
-			break;
 		}
 	}
 
-- 
2.20.1

