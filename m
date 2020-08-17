Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D06A246AFD
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 17:46:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387590AbgHQPqd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 11:46:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:58190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730363AbgHQPqZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:46:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 768182075B;
        Mon, 17 Aug 2020 15:46:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597679184;
        bh=4WTP4Ogj32dlekRkN0sF2w84Av0Agk7t6IC5sMNZfM8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kZkCoAhdm5f8CoZNy/WeSpNjgFWu0A8ukXYKg3KxSn3W4hidlK+gGzrNqbSj73dc0
         7Vp6pR7V8mIdWpX8RQwP2naIlHUPZTtopM5QHEzhTYii9PTNS70Zv/1mtmaPzPnezO
         J1ue9wtkU8nOt/OLmMHSDqnfL4WEbnms/HQ9SokI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aric Cyr <aric.cyr@amd.com>,
        Wenjing Liu <Wenjing.Liu@amd.com>,
        Qingqing Zhuo <qingqing.zhuo@amd.com>,
        Tony Cheng <Tony.Cheng@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 094/393] drm/amd/display: Improve DisplayPort monitor interop
Date:   Mon, 17 Aug 2020 17:12:24 +0200
Message-Id: <20200817143824.187072938@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143819.579311991@linuxfoundation.org>
References: <20200817143819.579311991@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aric Cyr <aric.cyr@amd.com>

[ Upstream commit eec3303de3378cdfaa0bb86f43546dbbd88f94e2 ]

[Why]
DC is very fast at link training and stream enablement
which causes issues such as blackscreens for non-compliant
monitors.

[How]
After debugging with scaler vendors we implement the
minimum delays at the necessary locations to ensure
the monitor does not hang.  Delays are generic due to
lack of IEEE OUI information on the failing displays.

Signed-off-by: Aric Cyr <aric.cyr@amd.com>
Reviewed-by: Wenjing Liu <Wenjing.Liu@amd.com>
Acked-by: Qingqing Zhuo <qingqing.zhuo@amd.com>
Acked-by: Tony Cheng <Tony.Cheng@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc_link.c    |  4 +++-
 drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c | 16 ++++++++++------
 .../amd/display/dc/dce110/dce110_hw_sequencer.c  | 11 ++++++++++-
 3 files changed, 23 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_link.c b/drivers/gpu/drm/amd/display/dc/core/dc_link.c
index 67cfff1586e9f..3f157bcc174b9 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_link.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_link.c
@@ -3146,9 +3146,11 @@ void core_link_disable_stream(struct pipe_ctx *pipe_ctx)
 			write_i2c_redriver_setting(pipe_ctx, false);
 		}
 	}
-	dc->hwss.disable_stream(pipe_ctx);
 
 	disable_link(pipe_ctx->stream->link, pipe_ctx->stream->signal);
+
+	dc->hwss.disable_stream(pipe_ctx);
+
 	if (pipe_ctx->stream->timing.flags.DSC) {
 		if (dc_is_dp_signal(pipe_ctx->stream->signal))
 			dp_set_dsc_enable(pipe_ctx, false);
diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c b/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
index caa090d0b6acc..1ada01322cd2c 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
@@ -1103,6 +1103,10 @@ static inline enum link_training_result perform_link_training_int(
 	dpcd_pattern.v1_4.TRAINING_PATTERN_SET = DPCD_TRAINING_PATTERN_VIDEOIDLE;
 	dpcd_set_training_pattern(link, dpcd_pattern);
 
+	/* delay 5ms after notifying sink of idle pattern before switching output */
+	if (link->connector_signal != SIGNAL_TYPE_EDP)
+		msleep(5);
+
 	/* 4. mainlink output idle pattern*/
 	dp_set_hw_test_pattern(link, DP_TEST_PATTERN_VIDEO_MODE, NULL, 0);
 
@@ -1552,6 +1556,12 @@ bool perform_link_training_with_retries(
 	struct dc_link *link = stream->link;
 	enum dp_panel_mode panel_mode = dp_get_panel_mode(link);
 
+	/* We need to do this before the link training to ensure the idle pattern in SST
+	 * mode will be sent right after the link training
+	 */
+	link->link_enc->funcs->connect_dig_be_to_fe(link->link_enc,
+							pipe_ctx->stream_res.stream_enc->id, true);
+
 	for (j = 0; j < attempts; ++j) {
 
 		dp_enable_link_phy(
@@ -1568,12 +1578,6 @@ bool perform_link_training_with_retries(
 
 		dp_set_panel_mode(link, panel_mode);
 
-		/* We need to do this before the link training to ensure the idle pattern in SST
-		 * mode will be sent right after the link training
-		 */
-		link->link_enc->funcs->connect_dig_be_to_fe(link->link_enc,
-								pipe_ctx->stream_res.stream_enc->id, true);
-
 		if (link->aux_access_disabled) {
 			dc_link_dp_perform_link_training_skip_aux(link, link_setting);
 			return true;
diff --git a/drivers/gpu/drm/amd/display/dc/dce110/dce110_hw_sequencer.c b/drivers/gpu/drm/amd/display/dc/dce110/dce110_hw_sequencer.c
index 10527593868cc..24ca592c90df5 100644
--- a/drivers/gpu/drm/amd/display/dc/dce110/dce110_hw_sequencer.c
+++ b/drivers/gpu/drm/amd/display/dc/dce110/dce110_hw_sequencer.c
@@ -1090,8 +1090,17 @@ void dce110_blank_stream(struct pipe_ctx *pipe_ctx)
 		dc_link_set_abm_disable(link);
 	}
 
-	if (dc_is_dp_signal(pipe_ctx->stream->signal))
+	if (dc_is_dp_signal(pipe_ctx->stream->signal)) {
 		pipe_ctx->stream_res.stream_enc->funcs->dp_blank(pipe_ctx->stream_res.stream_enc);
+
+		/*
+		 * After output is idle pattern some sinks need time to recognize the stream
+		 * has changed or they enter protection state and hang.
+		 */
+		if (!dc_is_embedded_signal(pipe_ctx->stream->signal))
+			msleep(60);
+	}
+
 }
 
 
-- 
2.25.1



