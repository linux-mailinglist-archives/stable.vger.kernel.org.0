Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6471755D358
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:12:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234406AbiF0LKn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:10:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234378AbiF0LKm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:10:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC1ED64D6
        for <stable@vger.kernel.org>; Mon, 27 Jun 2022 04:10:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8AAFA613F8
        for <stable@vger.kernel.org>; Mon, 27 Jun 2022 11:10:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 809E9C3411D;
        Mon, 27 Jun 2022 11:10:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656328241;
        bh=RuRw0IDAQ6BcmtZNHtt+/Oi/20GRjqNSKY4HFCGvQL0=;
        h=Subject:To:Cc:From:Date:From;
        b=KoEOWd6/jyWcWAtD56FGrP6dETffpmDfb/R0xJDf7CnwTFSE2hoiEsqSUOkggPJwV
         dLkQFph3haLtO7SnESTajvbe1eNgvT4aWT13vvRSdOv050tFPDiaKeBjs2HqQ30HyP
         Aa/oEdiVwubfSwNk3gLr4fMq3HIvQI9wYXAfFH2g=
Subject: FAILED: patch "[PATCH] drm/msm/dp: force link training for display resolution change" failed to apply to 5.10-stable tree
To:     quic_khsieh@quicinc.com, robdclark@chromium.org,
        swboyd@chromium.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 27 Jun 2022 13:10:38 +0200
Message-ID: <165632823813035@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From a6e2af64a79afa7f1b29375b5231e840a84bb845 Mon Sep 17 00:00:00 2001
From: Kuogee Hsieh <quic_khsieh@quicinc.com>
Date: Thu, 16 Jun 2022 13:26:40 -0700
Subject: [PATCH] drm/msm/dp: force link training for display resolution change

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

diff --git a/drivers/gpu/drm/msm/dp/dp_ctrl.c b/drivers/gpu/drm/msm/dp/dp_ctrl.c
index f3e333eff32d..f18588aecea2 100644
--- a/drivers/gpu/drm/msm/dp/dp_ctrl.c
+++ b/drivers/gpu/drm/msm/dp/dp_ctrl.c
@@ -1533,6 +1533,8 @@ static int dp_ctrl_link_maintenance(struct dp_ctrl_private *ctrl)
 	return ret;
 }
 
+static int dp_ctrl_on_stream_phy_test_report(struct dp_ctrl *dp_ctrl);
+
 static int dp_ctrl_process_phy_test_request(struct dp_ctrl_private *ctrl)
 {
 	int ret = 0;
@@ -1556,7 +1558,7 @@ static int dp_ctrl_process_phy_test_request(struct dp_ctrl_private *ctrl)
 
 	ret = dp_ctrl_on_link(&ctrl->dp_ctrl);
 	if (!ret)
-		ret = dp_ctrl_on_stream(&ctrl->dp_ctrl);
+		ret = dp_ctrl_on_stream_phy_test_report(&ctrl->dp_ctrl);
 	else
 		DRM_ERROR("failed to enable DP link controller\n");
 
@@ -1812,7 +1814,27 @@ static int dp_ctrl_link_retrain(struct dp_ctrl_private *ctrl)
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
@@ -1848,12 +1870,7 @@ int dp_ctrl_on_stream(struct dp_ctrl *dp_ctrl)
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
index 0745fde01b45..b563e2e3bfe5 100644
--- a/drivers/gpu/drm/msm/dp/dp_ctrl.h
+++ b/drivers/gpu/drm/msm/dp/dp_ctrl.h
@@ -21,7 +21,7 @@ struct dp_ctrl {
 };
 
 int dp_ctrl_on_link(struct dp_ctrl *dp_ctrl);
-int dp_ctrl_on_stream(struct dp_ctrl *dp_ctrl);
+int dp_ctrl_on_stream(struct dp_ctrl *dp_ctrl, bool force_link_train);
 int dp_ctrl_off_link_stream(struct dp_ctrl *dp_ctrl);
 int dp_ctrl_off_link(struct dp_ctrl *dp_ctrl);
 int dp_ctrl_off(struct dp_ctrl *dp_ctrl);
diff --git a/drivers/gpu/drm/msm/dp/dp_display.c b/drivers/gpu/drm/msm/dp/dp_display.c
index 2b7263976740..a6117926a274 100644
--- a/drivers/gpu/drm/msm/dp/dp_display.c
+++ b/drivers/gpu/drm/msm/dp/dp_display.c
@@ -873,7 +873,7 @@ static int dp_display_enable(struct dp_display_private *dp, u32 data)
 		return 0;
 	}
 
-	rc = dp_ctrl_on_stream(dp->ctrl);
+	rc = dp_ctrl_on_stream(dp->ctrl, data);
 	if (!rc)
 		dp_display->power_on = true;
 
@@ -1660,6 +1660,7 @@ void dp_bridge_enable(struct drm_bridge *drm_bridge)
 	int rc = 0;
 	struct dp_display_private *dp_display;
 	u32 state;
+	bool force_link_train = false;
 
 	dp_display = container_of(dp, struct dp_display_private, dp_display);
 	if (!dp_display->dp_mode.drm_mode.clock) {
@@ -1694,10 +1695,12 @@ void dp_bridge_enable(struct drm_bridge *drm_bridge)
 
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
@@ -1706,10 +1709,6 @@ void dp_bridge_enable(struct drm_bridge *drm_bridge)
 		dp_display_unprepare(dp);
 	}
 
-	/* manual kick off plug event to train link */
-	if (state == ST_DISPLAY_OFF)
-		dp_add_event(dp_display, EV_IRQ_HPD_INT, 0, 0);
-
 	/* completed connection */
 	dp_display->hpd_state = ST_CONNECTED;
 

