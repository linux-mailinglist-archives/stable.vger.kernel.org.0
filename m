Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00528767E2
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 15:40:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387558AbfGZNkn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 09:40:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:46838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387507AbfGZNkn (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jul 2019 09:40:43 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5441A2238C;
        Fri, 26 Jul 2019 13:40:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564148442;
        bh=E8IlDIJ9+XEjMrH8K88c+5bFS1t26lVNbrD9vGmUlJs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vAwO19bESO2XpLJU851hixnCqDt4z0apzWqhl3XtRhTWhP3FVQpCQFsQ9L3HzHSzb
         75uw87Yb1mZFU3tIpCXi4tZWUTaA1JFDYDRI9Vqe4knqeabbjZH7AD25GRxU9gguuq
         yvaguENCew3sBHKVHT5bMK8L7ItrmylyZ4RI7Cmk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        Leo Li <sunpeng.li@amd.com>,
        Harry Wentland <harry.wentland@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.2 40/85] drm/amd/display: Expose audio inst from DC to DM
Date:   Fri, 26 Jul 2019 09:38:50 -0400
Message-Id: <20190726133936.11177-40-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190726133936.11177-1-sashal@kernel.org>
References: <20190726133936.11177-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>

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
index eac7186e4f08..12142d13f22f 100644
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
index 189bdab929a5..c20803b71fa5 100644
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

