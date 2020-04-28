Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7CE41BC7EE
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 20:28:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729103AbgD1S16 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:27:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:40332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729096AbgD1S14 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:27:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6151A20B80;
        Tue, 28 Apr 2020 18:27:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588098475;
        bh=K+Mwk65K/La2MVoY7m+jquMfV89IRWr8P72jJHI8WZ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cymiya41KNRl6bt6JyDD38V47N/rTsJH8ExtcXSbp+pIVGBQdcgutghckhWwAe/kF
         ARmZZjCF8DDH0td0LSmZyqvgirJwYOQcilgIRGx0MhADdFJGwaLVn6eufq6KbCM7/s
         c+AtF9MyEeVhHt3Wrmz6D5V34hMLilmnJ3nO2K2k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        Aric Cyr <Aric.Cyr@amd.com>,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 038/167] drm/amd/display: Calculate scaling ratios on every medium/full update
Date:   Tue, 28 Apr 2020 20:23:34 +0200
Message-Id: <20200428182229.943561352@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200428182225.451225420@linuxfoundation.org>
References: <20200428182225.451225420@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>

[ Upstream commit 3bae20137cae6c03f58f96c0bc9f3d46f0bc17d4 ]

[Why]
If a plane isn't being actively enabled or disabled then DC won't
always recalculate scaling rects and ratios for the primary plane.

This results in only a partial or corrupted rect being displayed on
the screen instead of scaling to fit the screen.

[How]
Add back the logic to recalculate the scaling rects into
dc_commit_updates_for_stream since this is the expected place to
do it in DC.

This was previously removed a few years ago to fix an underscan issue
but underscan is still functional now with this change - and it should
be, since this is only updating to the latest plane state getting passed
in.

Signed-off-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Reviewed-by: Aric Cyr <Aric.Cyr@amd.com>
Acked-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc.c b/drivers/gpu/drm/amd/display/dc/core/dc.c
index fc25600107050..188e51600070b 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -2349,7 +2349,7 @@ void dc_commit_updates_for_stream(struct dc *dc,
 	enum surface_update_type update_type;
 	struct dc_state *context;
 	struct dc_context *dc_ctx = dc->ctx;
-	int i;
+	int i, j;
 
 	stream_status = dc_stream_get_status(stream);
 	context = dc->current_state;
@@ -2387,6 +2387,17 @@ void dc_commit_updates_for_stream(struct dc *dc,
 
 		copy_surface_update_to_plane(surface, &srf_updates[i]);
 
+		if (update_type >= UPDATE_TYPE_MED) {
+			for (j = 0; j < dc->res_pool->pipe_count; j++) {
+				struct pipe_ctx *pipe_ctx =
+					&context->res_ctx.pipe_ctx[j];
+
+				if (pipe_ctx->plane_state != surface)
+					continue;
+
+				resource_build_scaling_params(pipe_ctx);
+			}
+		}
 	}
 
 	copy_stream_update_to_stream(dc, context, stream, stream_update);
-- 
2.20.1



