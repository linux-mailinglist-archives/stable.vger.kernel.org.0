Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2BA82919D3
	for <lists+stable@lfdr.de>; Sun, 18 Oct 2020 21:20:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728761AbgJRTUS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Oct 2020 15:20:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:59648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728747AbgJRTUR (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 18 Oct 2020 15:20:17 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 25973222E8;
        Sun, 18 Oct 2020 19:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603048816;
        bh=PIerFogCN3KjWeRdp/pZF5bPqZtgIpKAi25ssPmwOXo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TM5pLo0grl+K4ZL27lirHBv69jWnePb/8dO7/SbnVX8YWRy7QdIkkhWtl4XdixSA1
         zYRWH+LAnM2MQay7TShB52axC/XdARssfkRmr+k70rMw+W+qjP5NIPFL2VGDzCugR1
         uzVpsMnl6+8jPlTggdcY7gdTuMmUeNys8FGOQH/8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qingqing Zhuo <qingqing.zhuo@amd.com>,
        Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.9 105/111] drm/amd/display: Screen corruption on dual displays (DP+USB-C)
Date:   Sun, 18 Oct 2020 15:18:01 -0400
Message-Id: <20201018191807.4052726-105-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201018191807.4052726-1-sashal@kernel.org>
References: <20201018191807.4052726-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qingqing Zhuo <qingqing.zhuo@amd.com>

[ Upstream commit ce271b40a91f781af3dee985c39e841ac5148766 ]

[why]
Current pipe merge and split logic only supports cases where new
dc_state is allocated and relies on dc->current_state to gather
information from previous dc_state.

Calls to validate_bandwidth on UPDATE_TYPE_MED would cause an issue
because there is no new dc_state allocated, and data in
dc->current_state would be overwritten during pipe merge.

[how]
Only allow validate_bandwidth when new dc_state space is created.

Signed-off-by: Qingqing Zhuo <qingqing.zhuo@amd.com>
Reviewed-by: Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>
Acked-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc.c              | 2 +-
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c | 3 +++
 drivers/gpu/drm/amd/display/dc/dcn21/dcn21_resource.c | 3 +++
 3 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc.c b/drivers/gpu/drm/amd/display/dc/core/dc.c
index 92eb1ca1634fc..22cbfda6ab338 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -2621,7 +2621,7 @@ void dc_commit_updates_for_stream(struct dc *dc,
 
 	copy_stream_update_to_stream(dc, context, stream, stream_update);
 
-	if (update_type > UPDATE_TYPE_FAST) {
+	if (update_type >= UPDATE_TYPE_FULL) {
 		if (!dc->res_pool->funcs->validate_bandwidth(dc, context, false)) {
 			DC_ERROR("Mode validation failed for stream update!\n");
 			dc_release_state(context);
diff --git a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c
index f31f48dd0da29..aaf9a99f9f045 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c
@@ -3209,6 +3209,9 @@ static noinline bool dcn20_validate_bandwidth_fp(struct dc *dc,
 	context->bw_ctx.dml.soc.allow_dram_clock_one_display_vactive =
 		dc->debug.enable_dram_clock_change_one_display_vactive;
 
+	/*Unsafe due to current pipe merge and split logic*/
+	ASSERT(context != dc->current_state);
+
 	if (fast_validate) {
 		return dcn20_validate_bandwidth_internal(dc, context, true);
 	}
diff --git a/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_resource.c b/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_resource.c
index 88d41a385add8..a4f37d83d5cc9 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_resource.c
@@ -1184,6 +1184,9 @@ bool dcn21_validate_bandwidth(struct dc *dc, struct dc_state *context,
 
 	BW_VAL_TRACE_COUNT();
 
+	/*Unsafe due to current pipe merge and split logic*/
+	ASSERT(context != dc->current_state);
+
 	out = dcn20_fast_validate_bw(dc, context, pipes, &pipe_cnt, pipe_split_from, &vlevel);
 
 	if (pipe_cnt == 0)
-- 
2.25.1

