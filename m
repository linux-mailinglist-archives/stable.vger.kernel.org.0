Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9944D55CF0D
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:05:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237967AbiF0Lta (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:49:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238372AbiF0LsW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:48:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41C52FD1A;
        Mon, 27 Jun 2022 04:40:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EDA24B81126;
        Mon, 27 Jun 2022 11:40:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52CAFC341C8;
        Mon, 27 Jun 2022 11:40:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656330054;
        bh=ZsL1VgM0jfdDxU8UfBSdjwW5Nvhb3WaZ+2QVkoudGQU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mC/OOD3dYmQUiOd+Nw4We42Pz99Jjysmcuq7pEvK6aioSyQF6MssXF2bWKz7msUfi
         8yJgKi59Gbc4mhNtHUA78bv1kn93VuRkADjLxhK2we9GDkOcijAWBmIa+3JsxbkPQ+
         LXCHVjnaVyH9bZchKdlwWrQrTML7mRgO45umISv0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuogee Hsieh <quic_khsieh@quicinc.com>,
        Stephen Boyd <swboyd@chromium.org>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 068/181] drm/msm/dp: force link training for display resolution change
Date:   Mon, 27 Jun 2022 13:20:41 +0200
Message-Id: <20220627111946.536485301@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111944.553492442@linuxfoundation.org>
References: <20220627111944.553492442@linuxfoundation.org>
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

From: Kuogee Hsieh <quic_khsieh@quicinc.com>

[ Upstream commit a6e2af64a79afa7f1b29375b5231e840a84bb845 ]

Display resolution change is implemented through drm modeset. Older
modeset (resolution) has to be disabled first before newer modeset
(resolution) can be enabled. Display disable will turn off both
pixel clock and main link clock so that main link have to be
re-trained during display enable to have new video stream flow
again. At current implementation, display enable function manually
kicks up irq_hpd_handle which will read panel link status and start
link training if link status is not in sync state.

However, there is rare case that a particular panel links status keep
staying in sync for some period of time after main link had been shut
down previously at display disabled. In this case, main link retraining
will not be executed by irq_hdp_handle(). Hence video stream of newer
display resolution will fail to be transmitted to panel due to main
link is not in sync between host and panel.

This patch will bypass irq_hpd_handle() in favor of directly call
dp_ctrl_on_stream() to always perform link training in regardless of
main link status. So that no unexpected exception resolution change
failure cases will happen. Also this implementation are more efficient
than manual kicking off irq_hpd_handle function.

Changes in v2:
-- set force_link_train flag on DP only (is_edp == false)

Changes in v3:
-- revise commit  text
-- add Fixes tag

Changes in v4:
-- revise commit  text

Changes in v5:
-- fix spelling at commit text

Changes in v6:
-- split dp_ctrl_on_stream() for phy test case
-- revise commit text for modeset

Changes in v7:
-- drop 0 assignment at local variable (ret = 0)

Changes in v8:
-- add patch to remove pixel_rate from dp_ctrl

Changes in v9:
-- forward declare dp_ctrl_on_stream_phy_test_report()

Fixes: 62671d2ef24b ("drm/msm/dp: fixes wrong connection state caused by failure of link train")
Signed-off-by: Kuogee Hsieh <quic_khsieh@quicinc.com>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Patchwork: https://patchwork.freedesktop.org/patch/489895/
Link: https://lore.kernel.org/r/1655411200-7255-1-git-send-email-quic_khsieh@quicinc.com
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dp/dp_ctrl.c    | 33 ++++++++++++++++++++++-------
 drivers/gpu/drm/msm/dp/dp_ctrl.h    |  2 +-
 drivers/gpu/drm/msm/dp/dp_display.c | 13 ++++++------
 3 files changed, 32 insertions(+), 16 deletions(-)

diff --git a/drivers/gpu/drm/msm/dp/dp_ctrl.c b/drivers/gpu/drm/msm/dp/dp_ctrl.c
index de1974916ad2..499d0bbc442c 100644
--- a/drivers/gpu/drm/msm/dp/dp_ctrl.c
+++ b/drivers/gpu/drm/msm/dp/dp_ctrl.c
@@ -1523,6 +1523,8 @@ static int dp_ctrl_link_maintenance(struct dp_ctrl_private *ctrl)
 	return ret;
 }
 
+static int dp_ctrl_on_stream_phy_test_report(struct dp_ctrl *dp_ctrl);
+
 static int dp_ctrl_process_phy_test_request(struct dp_ctrl_private *ctrl)
 {
 	int ret = 0;
@@ -1545,7 +1547,7 @@ static int dp_ctrl_process_phy_test_request(struct dp_ctrl_private *ctrl)
 
 	ret = dp_ctrl_on_link(&ctrl->dp_ctrl);
 	if (!ret)
-		ret = dp_ctrl_on_stream(&ctrl->dp_ctrl);
+		ret = dp_ctrl_on_stream_phy_test_report(&ctrl->dp_ctrl);
 	else
 		DRM_ERROR("failed to enable DP link controller\n");
 
@@ -1800,7 +1802,27 @@ static int dp_ctrl_link_retrain(struct dp_ctrl_private *ctrl)
 	return dp_ctrl_setup_main_link(ctrl, &training_step);
 }
 
-int dp_ctrl_on_stream(struct dp_ctrl *dp_ctrl)
+static int dp_ctrl_on_stream_phy_test_report(struct dp_ctrl *dp_ctrl)
+{
+	int ret;
+	struct dp_ctrl_private *ctrl;
+
+	ctrl = container_of(dp_ctrl, struct dp_ctrl_private, dp_ctrl);
+
+	ctrl->dp_ctrl.pixel_rate = ctrl->panel->dp_mode.drm_mode.clock;
+
+	ret = dp_ctrl_enable_stream_clocks(ctrl);
+	if (ret) {
+		DRM_ERROR("Failed to start pixel clocks. ret=%d\n", ret);
+		return ret;
+	}
+
+	dp_ctrl_send_phy_test_pattern(ctrl);
+
+	return 0;
+}
+
+int dp_ctrl_on_stream(struct dp_ctrl *dp_ctrl, bool force_link_train)
 {
 	int ret = 0;
 	bool mainlink_ready = false;
@@ -1831,12 +1853,7 @@ int dp_ctrl_on_stream(struct dp_ctrl *dp_ctrl)
 		goto end;
 	}
 
-	if (ctrl->link->sink_request & DP_TEST_LINK_PHY_TEST_PATTERN) {
-		dp_ctrl_send_phy_test_pattern(ctrl);
-		return 0;
-	}
-
-	if (!dp_ctrl_channel_eq_ok(ctrl))
+	if (force_link_train || !dp_ctrl_channel_eq_ok(ctrl))
 		dp_ctrl_link_retrain(ctrl);
 
 	/* stop txing train pattern to end link training */
diff --git a/drivers/gpu/drm/msm/dp/dp_ctrl.h b/drivers/gpu/drm/msm/dp/dp_ctrl.h
index 2433edbc70a6..dcc7af21a5f0 100644
--- a/drivers/gpu/drm/msm/dp/dp_ctrl.h
+++ b/drivers/gpu/drm/msm/dp/dp_ctrl.h
@@ -20,7 +20,7 @@ struct dp_ctrl {
 };
 
 int dp_ctrl_on_link(struct dp_ctrl *dp_ctrl);
-int dp_ctrl_on_stream(struct dp_ctrl *dp_ctrl);
+int dp_ctrl_on_stream(struct dp_ctrl *dp_ctrl, bool force_link_train);
 int dp_ctrl_off_link_stream(struct dp_ctrl *dp_ctrl);
 int dp_ctrl_off(struct dp_ctrl *dp_ctrl);
 void dp_ctrl_push_idle(struct dp_ctrl *dp_ctrl);
diff --git a/drivers/gpu/drm/msm/dp/dp_display.c b/drivers/gpu/drm/msm/dp/dp_display.c
index d11c81d8a5db..12270bd3cff9 100644
--- a/drivers/gpu/drm/msm/dp/dp_display.c
+++ b/drivers/gpu/drm/msm/dp/dp_display.c
@@ -903,7 +903,7 @@ static int dp_display_enable(struct dp_display_private *dp, u32 data)
 		return 0;
 	}
 
-	rc = dp_ctrl_on_stream(dp->ctrl);
+	rc = dp_ctrl_on_stream(dp->ctrl, data);
 	if (!rc)
 		dp_display->power_on = true;
 
@@ -1590,6 +1590,7 @@ int msm_dp_display_enable(struct msm_dp *dp, struct drm_encoder *encoder)
 	int rc = 0;
 	struct dp_display_private *dp_display;
 	u32 state;
+	bool force_link_train = false;
 
 	dp_display = container_of(dp, struct dp_display_private, dp_display);
 	if (!dp_display->dp_mode.drm_mode.clock) {
@@ -1618,10 +1619,12 @@ int msm_dp_display_enable(struct msm_dp *dp, struct drm_encoder *encoder)
 
 	state =  dp_display->hpd_state;
 
-	if (state == ST_DISPLAY_OFF)
+	if (state == ST_DISPLAY_OFF) {
 		dp_display_host_phy_init(dp_display);
+		force_link_train = true;
+	}
 
-	dp_display_enable(dp_display, 0);
+	dp_display_enable(dp_display, force_link_train);
 
 	rc = dp_display_post_enable(dp);
 	if (rc) {
@@ -1630,10 +1633,6 @@ int msm_dp_display_enable(struct msm_dp *dp, struct drm_encoder *encoder)
 		dp_display_unprepare(dp);
 	}
 
-	/* manual kick off plug event to train link */
-	if (state == ST_DISPLAY_OFF)
-		dp_add_event(dp_display, EV_IRQ_HPD_INT, 0, 0);
-
 	/* completed connection */
 	dp_display->hpd_state = ST_CONNECTED;
 
-- 
2.35.1



