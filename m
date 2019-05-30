Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E07E02F497
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:42:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728993AbfE3DMY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:12:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:54704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728988AbfE3DMX (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:12:23 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DA44421BE2;
        Thu, 30 May 2019 03:12:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185942;
        bh=jbUgxzC1P1dcl4lQYxJurSTa42eGwoXCqACb1Nmkxjs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H0AhUGo7/xAojQxjSS3Q3xeAp89DZj0vzJ3D9IS5a8Sa5CfeyxkTIVWRu3JzIhpSm
         eTBJ+06L6VIxM6x9K3h7HJsBF2Bwi6utH8ftlNnAaJjC2Ynaa8NjlN1EHSo+24huVO
         O6yq0mnkMEbczywwnlRKCOS9JbWC8sLpU6DjIBAs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Martin Leung <martin.leung@amd.com>,
        Wenjing Liu <Wenjing.Liu@amd.com>,
        Aidan Wood <Aidan.Wood@amd.com>,
        Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 350/405] drm/amd/display: half bandwidth for YCbCr420 during validation
Date:   Wed, 29 May 2019 20:05:48 -0700
Message-Id: <20190530030558.378476809@linuxfoundation.org>
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

[ Upstream commit 162f807858d15bde60cf373a3ad46e03200ad9d8 ]

[Why]
used to be unable to run 4:2:0 if using a dongle because 4k60 bandwidth
exceeded dongle caps

[How]
half pixel clock during comparison to dongle cap. *Could get stuck on black
screen on monitor that don't support 420 but will be selecting 420 as
preferred mode*

Signed-off-by: Martin Leung <martin.leung@amd.com>
Reviewed-by: Wenjing Liu <Wenjing.Liu@amd.com>
Acked-by: Aidan Wood <Aidan.Wood@amd.com>
Acked-by: Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc_link.c | 33 +++++++++++--------
 1 file changed, 20 insertions(+), 13 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_link.c b/drivers/gpu/drm/amd/display/dc/core/dc_link.c
index ea2f271e234bd..419e8de8c0f48 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_link.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_link.c
@@ -2074,11 +2074,28 @@ static void disable_link(struct dc_link *link, enum signal_type signal)
 	}
 }
 
+static uint32_t get_timing_pixel_clock_100hz(const struct dc_crtc_timing *timing)
+{
+
+	uint32_t pxl_clk = timing->pix_clk_100hz;
+
+	if (timing->pixel_encoding == PIXEL_ENCODING_YCBCR420)
+		pxl_clk /= 2;
+	else if (timing->pixel_encoding == PIXEL_ENCODING_YCBCR422)
+		pxl_clk = pxl_clk * 2 / 3;
+
+	if (timing->display_color_depth == COLOR_DEPTH_101010)
+		pxl_clk = pxl_clk * 10 / 8;
+	else if (timing->display_color_depth == COLOR_DEPTH_121212)
+		pxl_clk = pxl_clk * 12 / 8;
+
+	return pxl_clk;
+}
+
 static bool dp_active_dongle_validate_timing(
 		const struct dc_crtc_timing *timing,
 		const struct dpcd_caps *dpcd_caps)
 {
-	unsigned int required_pix_clk_100hz = timing->pix_clk_100hz;
 	const struct dc_dongle_caps *dongle_caps = &dpcd_caps->dongle_caps;
 
 	switch (dpcd_caps->dongle_type) {
@@ -2115,13 +2132,6 @@ static bool dp_active_dongle_validate_timing(
 		return false;
 	}
 
-
-	/* Check Color Depth and Pixel Clock */
-	if (timing->pixel_encoding == PIXEL_ENCODING_YCBCR420)
-		required_pix_clk_100hz /= 2;
-	else if (timing->pixel_encoding == PIXEL_ENCODING_YCBCR422)
-		required_pix_clk_100hz = required_pix_clk_100hz * 2 / 3;
-
 	switch (timing->display_color_depth) {
 	case COLOR_DEPTH_666:
 	case COLOR_DEPTH_888:
@@ -2130,14 +2140,11 @@ static bool dp_active_dongle_validate_timing(
 	case COLOR_DEPTH_101010:
 		if (dongle_caps->dp_hdmi_max_bpc < 10)
 			return false;
-		required_pix_clk_100hz = required_pix_clk_100hz * 10 / 8;
 		break;
 	case COLOR_DEPTH_121212:
 		if (dongle_caps->dp_hdmi_max_bpc < 12)
 			return false;
-		required_pix_clk_100hz = required_pix_clk_100hz * 12 / 8;
 		break;
-
 	case COLOR_DEPTH_141414:
 	case COLOR_DEPTH_161616:
 	default:
@@ -2145,7 +2152,7 @@ static bool dp_active_dongle_validate_timing(
 		return false;
 	}
 
-	if (required_pix_clk_100hz > (dongle_caps->dp_hdmi_max_pixel_clk * 10))
+	if (get_timing_pixel_clock_100hz(timing) > (dongle_caps->dp_hdmi_max_pixel_clk * 10))
 		return false;
 
 	return true;
@@ -2166,7 +2173,7 @@ enum dc_status dc_link_validate_mode_timing(
 		return DC_OK;
 
 	/* Passive Dongle */
-	if (0 != max_pix_clk && timing->pix_clk_100hz > max_pix_clk)
+	if (max_pix_clk != 0 && get_timing_pixel_clock_100hz(timing) > max_pix_clk)
 		return DC_EXCEED_DONGLE_CAP;
 
 	/* Active Dongle*/
-- 
2.20.1



