Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80DF24998E8
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:39:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1453698AbiAXVal (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:30:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1450608AbiAXVVC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:21:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB643C0604CE;
        Mon, 24 Jan 2022 12:14:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A905CB8119E;
        Mon, 24 Jan 2022 20:14:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D37A1C340E5;
        Mon, 24 Jan 2022 20:14:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055258;
        bh=kIFTmGOqxmq1gqY/FA6XoEWymldT6h8yR+1fDhp7Wfg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yQqCazadumb/8KZzfO5y4ZR5WEeT5uT26DaaTnka/hn/lcTiYiYrrj7NKQuHYNEyU
         8m+bO9+zAMO4+mOKgR0AaFty8zB2P8HOgVWlNcz7UVRZLiDwfmhNCWi0XihdTNltH8
         s99tBhrM6xVDGvQHQMUR62X9i7MHuDLY5Kb3i9cc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dave Stevenson <dave.stevenson@raspberrypi.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 093/846] drm/vc4: hdmi: Rework the pre_crtc_configure error handling
Date:   Mon, 24 Jan 2022 19:33:30 +0100
Message-Id: <20220124184104.199473166@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxime Ripard <maxime@cerno.tech>

[ Upstream commit caa51a4c11f1cadba9bcf61ed9e0105711952ce7 ]

Since our pre_crtc_configure hook returned void, we didn't implement a
goto-based error path handling, leading to errors like failing to put
back the device in pm_runtime in all the error paths, but also failing
to disable the pixel clock if clk_set_min_rate on the HSM clock fails.

Move to a goto-based implementation to have an easier consitency.

Fixes: 4f6e3d66ac52 ("drm/vc4: Add runtime PM support to the HDMI encoder driver")
Link: https://patchwork.freedesktop.org/patch/msgid/20210819135931.895976-4-maxime@cerno.tech
Reviewed-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_hdmi.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/vc4/vc4_hdmi.c b/drivers/gpu/drm/vc4/vc4_hdmi.c
index 2087717f1cce9..49944644a9b36 100644
--- a/drivers/gpu/drm/vc4/vc4_hdmi.c
+++ b/drivers/gpu/drm/vc4/vc4_hdmi.c
@@ -933,15 +933,16 @@ static void vc4_hdmi_encoder_pre_crtc_configure(struct drm_encoder *encoder,
 	ret = clk_set_rate(vc4_hdmi->pixel_clock, pixel_rate);
 	if (ret) {
 		DRM_ERROR("Failed to set pixel clock rate: %d\n", ret);
-		return;
+		goto err_put_runtime_pm;
 	}
 
 	ret = clk_prepare_enable(vc4_hdmi->pixel_clock);
 	if (ret) {
 		DRM_ERROR("Failed to turn on pixel clock: %d\n", ret);
-		return;
+		goto err_put_runtime_pm;
 	}
 
+
 	vc4_hdmi_cec_update_clk_div(vc4_hdmi);
 
 	if (pixel_rate > 297000000)
@@ -954,15 +955,13 @@ static void vc4_hdmi_encoder_pre_crtc_configure(struct drm_encoder *encoder,
 	ret = clk_set_min_rate(vc4_hdmi->pixel_bvb_clock, bvb_rate);
 	if (ret) {
 		DRM_ERROR("Failed to set pixel bvb clock rate: %d\n", ret);
-		clk_disable_unprepare(vc4_hdmi->pixel_clock);
-		return;
+		goto err_disable_pixel_clock;
 	}
 
 	ret = clk_prepare_enable(vc4_hdmi->pixel_bvb_clock);
 	if (ret) {
 		DRM_ERROR("Failed to turn on pixel bvb clock: %d\n", ret);
-		clk_disable_unprepare(vc4_hdmi->pixel_clock);
-		return;
+		goto err_disable_pixel_clock;
 	}
 
 	if (vc4_hdmi->variant->phy_init)
@@ -975,6 +974,15 @@ static void vc4_hdmi_encoder_pre_crtc_configure(struct drm_encoder *encoder,
 
 	if (vc4_hdmi->variant->set_timings)
 		vc4_hdmi->variant->set_timings(vc4_hdmi, conn_state, mode);
+
+	return;
+
+err_disable_pixel_clock:
+	clk_disable_unprepare(vc4_hdmi->pixel_clock);
+err_put_runtime_pm:
+	pm_runtime_put(&vc4_hdmi->pdev->dev);
+
+	return;
 }
 
 static void vc4_hdmi_encoder_pre_crtc_enable(struct drm_encoder *encoder,
-- 
2.34.1



