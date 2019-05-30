Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90D1F2F5A5
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:49:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728460AbfE3Esz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:48:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:49964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728443AbfE3DLP (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:11:15 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0FDC9244D2;
        Thu, 30 May 2019 03:11:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185875;
        bh=qRHnp9nqTswN4JVSMHBDW2hFGYgk1GdYEVio7lq2UaM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RgIoub8s0oGZxe/BOFPjFgraqrdLMsq0tWC3YzLk+7P1Jf7mhMNGYbxyCUY2RwAi9
         SrltfJpSuIXEXETsZIXAbf7dRx3vDkPGFFyEuxnSSjTHNBT+kp291iXO5z0/VFWNVz
         hSM93ffKWWanJUdw04F6EUBM9v7uMX6pbsXVOfJQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wenjing Liu <Wenjing.Liu@amd.com>,
        Jun Lei <Jun.Lei@amd.com>, Leo Li <sunpeng.li@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 220/405] drm/amd/display: use proper formula to calculate bandwidth from timing
Date:   Wed, 29 May 2019 20:03:38 -0700
Message-Id: <20190530030552.200039222@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.291644921@linuxfoundation.org>
References: <20190530030540.291644921@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit e49f69363adf8920883fff7e8ffecb802d897c6b ]

[why]
The existing calculation uses a wrong formula to
calculate bandwidth from timing.

[how]
Expose the existing proper function that calculates the bandwidth,
so dc_link can use it to calculate timing bandwidth correctly.

Signed-off-by: Wenjing Liu <Wenjing.Liu@amd.com>
Reviewed-by: Jun Lei <Jun.Lei@amd.com>
Acked-by: Leo Li <sunpeng.li@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc_link.c | 48 ++++++++++++++++-
 .../gpu/drm/amd/display/dc/core/dc_link_dp.c  | 51 +------------------
 drivers/gpu/drm/amd/display/dc/dc_link.h      |  2 +
 3 files changed, 51 insertions(+), 50 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_link.c b/drivers/gpu/drm/amd/display/dc/core/dc_link.c
index ea18e9c2d8cea..ea2f271e234bd 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_link.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_link.c
@@ -2316,7 +2316,7 @@ static struct fixed31_32 get_pbn_from_timing(struct pipe_ctx *pipe_ctx)
 	uint32_t denominator;
 
 	bpc = get_color_depth(pipe_ctx->stream_res.pix_clk_params.color_depth);
-	kbps = pipe_ctx->stream_res.pix_clk_params.requested_pix_clk_100hz / 10 * bpc * 3;
+	kbps = dc_bandwidth_in_kbps_from_timing(&pipe_ctx->stream->timing);
 
 	/*
 	 * margin 5300ppm + 300ppm ~ 0.6% as per spec, factor is 1.006
@@ -2736,3 +2736,49 @@ void dc_link_enable_hpd_filter(struct dc_link *link, bool enable)
 	}
 }
 
+uint32_t dc_bandwidth_in_kbps_from_timing(
+	const struct dc_crtc_timing *timing)
+{
+	uint32_t bits_per_channel = 0;
+	uint32_t kbps;
+
+	switch (timing->display_color_depth) {
+	case COLOR_DEPTH_666:
+		bits_per_channel = 6;
+		break;
+	case COLOR_DEPTH_888:
+		bits_per_channel = 8;
+		break;
+	case COLOR_DEPTH_101010:
+		bits_per_channel = 10;
+		break;
+	case COLOR_DEPTH_121212:
+		bits_per_channel = 12;
+		break;
+	case COLOR_DEPTH_141414:
+		bits_per_channel = 14;
+		break;
+	case COLOR_DEPTH_161616:
+		bits_per_channel = 16;
+		break;
+	default:
+		break;
+	}
+
+	ASSERT(bits_per_channel != 0);
+
+	kbps = timing->pix_clk_100hz / 10;
+	kbps *= bits_per_channel;
+
+	if (timing->flags.Y_ONLY != 1) {
+		/*Only YOnly make reduce bandwidth by 1/3 compares to RGB*/
+		kbps *= 3;
+		if (timing->pixel_encoding == PIXEL_ENCODING_YCBCR420)
+			kbps /= 2;
+		else if (timing->pixel_encoding == PIXEL_ENCODING_YCBCR422)
+			kbps = kbps * 2 / 3;
+	}
+
+	return kbps;
+
+}
diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c b/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
index 09d3012160763..6809932e80bec 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
@@ -1520,53 +1520,6 @@ static bool decide_fallback_link_setting(
 	return true;
 }
 
-static uint32_t bandwidth_in_kbps_from_timing(
-	const struct dc_crtc_timing *timing)
-{
-	uint32_t bits_per_channel = 0;
-	uint32_t kbps;
-
-	switch (timing->display_color_depth) {
-	case COLOR_DEPTH_666:
-		bits_per_channel = 6;
-		break;
-	case COLOR_DEPTH_888:
-		bits_per_channel = 8;
-		break;
-	case COLOR_DEPTH_101010:
-		bits_per_channel = 10;
-		break;
-	case COLOR_DEPTH_121212:
-		bits_per_channel = 12;
-		break;
-	case COLOR_DEPTH_141414:
-		bits_per_channel = 14;
-		break;
-	case COLOR_DEPTH_161616:
-		bits_per_channel = 16;
-		break;
-	default:
-		break;
-	}
-
-	ASSERT(bits_per_channel != 0);
-
-	kbps = timing->pix_clk_100hz / 10;
-	kbps *= bits_per_channel;
-
-	if (timing->flags.Y_ONLY != 1) {
-		/*Only YOnly make reduce bandwidth by 1/3 compares to RGB*/
-		kbps *= 3;
-		if (timing->pixel_encoding == PIXEL_ENCODING_YCBCR420)
-			kbps /= 2;
-		else if (timing->pixel_encoding == PIXEL_ENCODING_YCBCR422)
-			kbps = kbps * 2 / 3;
-	}
-
-	return kbps;
-
-}
-
 static uint32_t bandwidth_in_kbps_from_link_settings(
 	const struct dc_link_settings *link_setting)
 {
@@ -1607,7 +1560,7 @@ bool dp_validate_mode_timing(
 		link_setting = &link->verified_link_cap;
 	*/
 
-	req_bw = bandwidth_in_kbps_from_timing(timing);
+	req_bw = dc_bandwidth_in_kbps_from_timing(timing);
 	max_bw = bandwidth_in_kbps_from_link_settings(link_setting);
 
 	if (req_bw <= max_bw) {
@@ -1641,7 +1594,7 @@ void decide_link_settings(struct dc_stream_state *stream,
 	uint32_t req_bw;
 	uint32_t link_bw;
 
-	req_bw = bandwidth_in_kbps_from_timing(&stream->timing);
+	req_bw = dc_bandwidth_in_kbps_from_timing(&stream->timing);
 
 	link = stream->link;
 
diff --git a/drivers/gpu/drm/amd/display/dc/dc_link.h b/drivers/gpu/drm/amd/display/dc/dc_link.h
index 8fc223defed4a..a83e1c60f9db2 100644
--- a/drivers/gpu/drm/amd/display/dc/dc_link.h
+++ b/drivers/gpu/drm/amd/display/dc/dc_link.h
@@ -252,4 +252,6 @@ bool dc_submit_i2c(
 		uint32_t link_index,
 		struct i2c_command *cmd);
 
+uint32_t dc_bandwidth_in_kbps_from_timing(
+	const struct dc_crtc_timing *timing);
 #endif /* DC_LINK_H_ */
-- 
2.20.1



