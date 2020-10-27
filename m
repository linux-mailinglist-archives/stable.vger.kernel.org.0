Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F7DE29B963
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:11:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1802436AbgJ0Psh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:48:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:54864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1796333AbgJ0PR1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:17:27 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EB02C2064B;
        Tue, 27 Oct 2020 15:17:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603811846;
        bh=9Tg+4chMTK8bm7A8vFRKU5re1bN2ZXXqKnAZdc/dvzo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eHQhqp2YkMOGbpTIdWn8fvP5IvDWe9SlDdb6GpBUn8RYECbDYBYrrsCimeiyHa0W+
         UDtjQz5DmpDvKPDevs2B9dqeH1gTGG6yFoRNQuFO4qU82bMPKhjx0BHhJtmG2nUvac
         ee57TkYTvt9QecbmUTWVYEFvvQ/vNOg3nMcOV0OY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qingqing Zhuo <qingqing.zhuo@amd.com>,
        Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 620/633] drm/amd/display: Screen corruption on dual displays (DP+USB-C)
Date:   Tue, 27 Oct 2020 14:56:03 +0100
Message-Id: <20201027135551.917984780@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index d016f50e187c8..d261f425b80ec 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -2538,7 +2538,7 @@ void dc_commit_updates_for_stream(struct dc *dc,
 
 	copy_stream_update_to_stream(dc, context, stream, stream_update);
 
-	if (update_type > UPDATE_TYPE_FAST) {
+	if (update_type >= UPDATE_TYPE_FULL) {
 		if (!dc->res_pool->funcs->validate_bandwidth(dc, context, false)) {
 			DC_ERROR("Mode validation failed for stream update!\n");
 			dc_release_state(context);
diff --git a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c
index 20bdabebbc434..76cd4f3de4eaf 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c
@@ -3165,6 +3165,9 @@ static noinline bool dcn20_validate_bandwidth_fp(struct dc *dc,
 	context->bw_ctx.dml.soc.allow_dram_clock_one_display_vactive =
 		dc->debug.enable_dram_clock_change_one_display_vactive;
 
+	/*Unsafe due to current pipe merge and split logic*/
+	ASSERT(context != dc->current_state);
+
 	if (fast_validate) {
 		return dcn20_validate_bandwidth_internal(dc, context, true);
 	}
diff --git a/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_resource.c b/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_resource.c
index f00a568350848..c6ab3dee4fd69 100644
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



