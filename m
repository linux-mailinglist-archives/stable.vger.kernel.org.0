Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C97955E114
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:33:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234786AbiF0LYm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:24:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234728AbiF0LYc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:24:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9B02656A;
        Mon, 27 Jun 2022 04:24:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6B2856144F;
        Mon, 27 Jun 2022 11:24:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61C15C3411D;
        Mon, 27 Jun 2022 11:24:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656329070;
        bh=daUoYr+Eel55TsmrdMO7PyEEJ9lVj/hFlgPrNGdm/gc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2D8iMZoaB+UE08qVtCodcCQaXCerH9NPAtUjujlNMpphGAA2cNuF8nbWgeobUu1vx
         2wdnGzt5qJiutZEf/zzKtR8vi5pIpOn3T748/zzJX8bH5XbZMwI8TdAnclKWGRDvby
         lc/dlfHNU4lfgeH36if0Wp4VTe+YvVgkgGeAk7S8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuogee Hsieh <khsieh@codeaurora.org>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 039/102] drm/msm/dp: deinitialize mainlink if link training failed
Date:   Mon, 27 Jun 2022 13:20:50 +0200
Message-Id: <20220627111934.629138484@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111933.455024953@linuxfoundation.org>
References: <20220627111933.455024953@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kuogee Hsieh <khsieh@codeaurora.org>

[ Upstream commit 231a04fcc6cb5b0e5f72c015d36462a17355f925 ]

DP compo phy have to be enable to start link training. When
link training failed phy need to be disabled so that next
link traning can be proceed smoothly at next plug in. This
patch de-initialize mainlink to disable phy if link training
failed. This prevent system crash due to
disp_cc_mdss_dp_link_intf_clk stuck at "off" state.  This patch
also perform checking power_on flag at dp_display_enable() and
dp_display_disable() to avoid crashing when unplug cable while
display is off.

Signed-off-by: Kuogee Hsieh <khsieh@codeaurora.org>
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dp/dp_catalog.c |  2 +-
 drivers/gpu/drm/msm/dp/dp_catalog.h |  2 +-
 drivers/gpu/drm/msm/dp/dp_ctrl.c    | 40 +++++++++++++++++++++++++++--
 drivers/gpu/drm/msm/dp/dp_display.c | 15 ++++++++++-
 drivers/gpu/drm/msm/dp/dp_panel.c   |  2 +-
 5 files changed, 55 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/msm/dp/dp_catalog.c b/drivers/gpu/drm/msm/dp/dp_catalog.c
index aeca8b2ac5c6..2da6982efdbf 100644
--- a/drivers/gpu/drm/msm/dp/dp_catalog.c
+++ b/drivers/gpu/drm/msm/dp/dp_catalog.c
@@ -572,7 +572,7 @@ void dp_catalog_ctrl_hpd_config(struct dp_catalog *dp_catalog)
 	dp_write_aux(catalog, REG_DP_DP_HPD_CTRL, DP_DP_HPD_CTRL_HPD_EN);
 }
 
-u32 dp_catalog_hpd_get_state_status(struct dp_catalog *dp_catalog)
+u32 dp_catalog_link_is_connected(struct dp_catalog *dp_catalog)
 {
 	struct dp_catalog_private *catalog = container_of(dp_catalog,
 				struct dp_catalog_private, dp_catalog);
diff --git a/drivers/gpu/drm/msm/dp/dp_catalog.h b/drivers/gpu/drm/msm/dp/dp_catalog.h
index 6d257dbebf29..176a9020a520 100644
--- a/drivers/gpu/drm/msm/dp/dp_catalog.h
+++ b/drivers/gpu/drm/msm/dp/dp_catalog.h
@@ -97,7 +97,7 @@ void dp_catalog_ctrl_enable_irq(struct dp_catalog *dp_catalog, bool enable);
 void dp_catalog_hpd_config_intr(struct dp_catalog *dp_catalog,
 			u32 intr_mask, bool en);
 void dp_catalog_ctrl_hpd_config(struct dp_catalog *dp_catalog);
-u32 dp_catalog_hpd_get_state_status(struct dp_catalog *dp_catalog);
+u32 dp_catalog_link_is_connected(struct dp_catalog *dp_catalog);
 u32 dp_catalog_hpd_get_intr_status(struct dp_catalog *dp_catalog);
 void dp_catalog_ctrl_phy_reset(struct dp_catalog *dp_catalog);
 int dp_catalog_ctrl_update_vx_px(struct dp_catalog *dp_catalog, u8 v_level,
diff --git a/drivers/gpu/drm/msm/dp/dp_ctrl.c b/drivers/gpu/drm/msm/dp/dp_ctrl.c
index c83a1650437d..b9ca844ce2ad 100644
--- a/drivers/gpu/drm/msm/dp/dp_ctrl.c
+++ b/drivers/gpu/drm/msm/dp/dp_ctrl.c
@@ -1460,6 +1460,30 @@ static int dp_ctrl_reinitialize_mainlink(struct dp_ctrl_private *ctrl)
 	return ret;
 }
 
+static int dp_ctrl_deinitialize_mainlink(struct dp_ctrl_private *ctrl)
+{
+	struct dp_io *dp_io;
+	struct phy *phy;
+	int ret;
+
+	dp_io = &ctrl->parser->io;
+	phy = dp_io->phy;
+
+	dp_catalog_ctrl_mainlink_ctrl(ctrl->catalog, false);
+
+	dp_catalog_ctrl_reset(ctrl->catalog);
+
+	ret = dp_power_clk_enable(ctrl->power, DP_CTRL_PM, false);
+	if (ret) {
+		DRM_ERROR("Failed to disable link clocks. ret=%d\n", ret);
+	}
+
+	phy_power_off(phy);
+	phy_exit(phy);
+
+	return 0;
+}
+
 static int dp_ctrl_link_maintenance(struct dp_ctrl_private *ctrl)
 {
 	int ret = 0;
@@ -1640,8 +1664,7 @@ int dp_ctrl_on_link(struct dp_ctrl *dp_ctrl)
 	if (rc)
 		return rc;
 
-	while (--link_train_max_retries &&
-		!atomic_read(&ctrl->dp_ctrl.aborted)) {
+	while (--link_train_max_retries) {
 		rc = dp_ctrl_reinitialize_mainlink(ctrl);
 		if (rc) {
 			DRM_ERROR("Failed to reinitialize mainlink. rc=%d\n",
@@ -1656,6 +1679,10 @@ int dp_ctrl_on_link(struct dp_ctrl *dp_ctrl)
 			break;
 		} else if (training_step == DP_TRAINING_1) {
 			/* link train_1 failed */
+			if (!dp_catalog_link_is_connected(ctrl->catalog)) {
+				break;
+			}
+
 			rc = dp_ctrl_link_rate_down_shift(ctrl);
 			if (rc < 0) { /* already in RBR = 1.6G */
 				if (cr.lane_0_1 & DP_LANE0_1_CR_DONE) {
@@ -1675,6 +1702,10 @@ int dp_ctrl_on_link(struct dp_ctrl *dp_ctrl)
 			}
 		} else if (training_step == DP_TRAINING_2) {
 			/* link train_2 failed, lower lane rate */
+			if (!dp_catalog_link_is_connected(ctrl->catalog)) {
+				break;
+			}
+
 			rc = dp_ctrl_link_lane_down_shift(ctrl);
 			if (rc < 0) {
 				/* end with failure */
@@ -1695,6 +1726,11 @@ int dp_ctrl_on_link(struct dp_ctrl *dp_ctrl)
 	 */
 	if (rc == 0)  /* link train successfully */
 		dp_ctrl_push_idle(dp_ctrl);
+	else  {
+		/* link training failed */
+		dp_ctrl_deinitialize_mainlink(ctrl);
+		rc = -ECONNRESET;
+	}
 
 	return rc;
 }
diff --git a/drivers/gpu/drm/msm/dp/dp_display.c b/drivers/gpu/drm/msm/dp/dp_display.c
index 4b18ab71ae59..d504cf68283a 100644
--- a/drivers/gpu/drm/msm/dp/dp_display.c
+++ b/drivers/gpu/drm/msm/dp/dp_display.c
@@ -556,6 +556,11 @@ static int dp_hpd_plug_handle(struct dp_display_private *dp, u32 data)
 	if (ret) {	/* link train failed */
 		hpd->hpd_high = 0;
 		dp->hpd_state = ST_DISCONNECTED;
+
+		if (ret == -ECONNRESET) { /* cable unplugged */
+			dp->core_initialized = false;
+		}
+
 	} else {
 		/* start sentinel checking in case of missing uevent */
 		dp_add_event(dp, EV_CONNECT_PENDING_TIMEOUT, 0, tout);
@@ -827,6 +832,11 @@ static int dp_display_enable(struct dp_display_private *dp, u32 data)
 
 	dp_display = g_dp_display;
 
+	if (dp_display->power_on) {
+		DRM_DEBUG_DP("Link already setup, return\n");
+		return 0;
+	}
+
 	rc = dp_ctrl_on_stream(dp->ctrl);
 	if (!rc)
 		dp_display->power_on = true;
@@ -859,6 +869,9 @@ static int dp_display_disable(struct dp_display_private *dp, u32 data)
 
 	dp_display = g_dp_display;
 
+	if (!dp_display->power_on)
+		return 0;
+
 	/* wait only if audio was enabled */
 	if (dp_display->audio_enabled) {
 		/* signal the disconnect event */
@@ -1245,7 +1258,7 @@ static int dp_pm_resume(struct device *dev)
 
 	dp_catalog_ctrl_hpd_config(dp->catalog);
 
-	status = dp_catalog_hpd_get_state_status(dp->catalog);
+	status = dp_catalog_link_is_connected(dp->catalog);
 
 	if (status)
 		dp->dp_display.is_connected = true;
diff --git a/drivers/gpu/drm/msm/dp/dp_panel.c b/drivers/gpu/drm/msm/dp/dp_panel.c
index 550871ba6e5a..4e8a19114e87 100644
--- a/drivers/gpu/drm/msm/dp/dp_panel.c
+++ b/drivers/gpu/drm/msm/dp/dp_panel.c
@@ -197,7 +197,7 @@ int dp_panel_read_sink_caps(struct dp_panel *dp_panel,
 	if (!dp_panel->edid) {
 		DRM_ERROR("panel edid read failed\n");
 		/* check edid read fail is due to unplug */
-		if (!dp_catalog_hpd_get_state_status(panel->catalog)) {
+		if (!dp_catalog_link_is_connected(panel->catalog)) {
 			rc = -ETIMEDOUT;
 			goto end;
 		}
-- 
2.35.1



