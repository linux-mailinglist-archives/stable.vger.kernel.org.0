Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4C2281D18
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 15:29:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730574AbfHENVm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 09:21:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:57922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730547AbfHENVl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Aug 2019 09:21:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 449F62067D;
        Mon,  5 Aug 2019 13:21:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565011300;
        bh=9FAzbJoUQS+la40ce0o+lCyjJxXmYPjJ45lLJeD6ijs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eXFq69hi8Dsrnabxc1RhngGUq1DhyKnmYkewo92ZyvN70LTA6wInt6GYdj/2xQZ0/
         cwge/+ejVnctBLOBdIpBlk6T1MtdAOQAwhYi2an3DZdn2ftjBCV+c7zUcHUlBHrNI+
         7kSX3xrX+f/PvMzPebW4n4Fh1JyI5ivjIcvqvDhE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leo Li <sunpeng.li@amd.com>,
        Harry Wentland <harry.wentland@amd.com>,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 039/131] drm/amd/display: Expose audio inst from DC to DM
Date:   Mon,  5 Aug 2019 15:02:06 +0200
Message-Id: <20190805124954.052766066@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190805124951.453337465@linuxfoundation.org>
References: <20190805124951.453337465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 5fdb7c4c7f2691efd760b0b0dc00da4a3699f1a6 ]

[Why]
In order to give pin notifications to the sound driver from DM we need
to know whether audio is enabled on a stream and what pin it's using
from DC.

[How]
Expose the instance via stream status if it's a mapped resource for
the stream. It will be -1 if there's no audio mapped.

Cc: Leo Li <sunpeng.li@amd.com>
Cc: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc_resource.c | 3 +++
 drivers/gpu/drm/amd/display/dc/dc_stream.h        | 1 +
 2 files changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_resource.c b/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
index eac7186e4f084..12142d13f22f2 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
@@ -2034,6 +2034,9 @@ enum dc_status resource_map_pool_resources(
 		if (context->streams[i] == stream) {
 			context->stream_status[i].primary_otg_inst = pipe_ctx->stream_res.tg->inst;
 			context->stream_status[i].stream_enc_inst = pipe_ctx->stream_res.stream_enc->id;
+			context->stream_status[i].audio_inst =
+				pipe_ctx->stream_res.audio ? pipe_ctx->stream_res.audio->inst : -1;
+
 			return DC_OK;
 		}
 
diff --git a/drivers/gpu/drm/amd/display/dc/dc_stream.h b/drivers/gpu/drm/amd/display/dc/dc_stream.h
index 189bdab929a55..c20803b71fa52 100644
--- a/drivers/gpu/drm/amd/display/dc/dc_stream.h
+++ b/drivers/gpu/drm/amd/display/dc/dc_stream.h
@@ -42,6 +42,7 @@ struct dc_stream_status {
 	int primary_otg_inst;
 	int stream_enc_inst;
 	int plane_count;
+	int audio_inst;
 	struct timing_sync_info timing_sync_info;
 	struct dc_plane_state *plane_states[MAX_SURFACE_NUM];
 };
-- 
2.20.1



