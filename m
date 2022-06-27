Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E01C555D774
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:18:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234844AbiF0LZR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:25:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234838AbiF0LY6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:24:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B107E658D;
        Mon, 27 Jun 2022 04:24:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4D04BB81122;
        Mon, 27 Jun 2022 11:24:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97AF0C3411D;
        Mon, 27 Jun 2022 11:24:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656329095;
        bh=NBzjfNLBjAb6DpyahI58MfyEpU2ijm9IrURcZdTKtlo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Aw7wrj3qXkcYYgCvkL6lJZkUoPCANuEGD8+Qo0eO14SwzkoEUUPXL9+LS6JqLVOta
         Td0Z7+3bBiqw9cc4ciehVoDOoVbOa6Ie8/psFQHaW1EI5sCTS9L36pUFX+hRIdFbgO
         HRMQWQ++4igxKwD7Wl6n1fIl5WlufMD7Ihp3JTvU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Stephen Boyd <swboyd@chromium.org>,
        Kuogee Hsieh <khsieh@codeaurora.org>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 041/102] drm/msm/dp: fix connect/disconnect handled at irq_hpd
Date:   Mon, 27 Jun 2022 13:20:52 +0200
Message-Id: <20220627111934.689852502@linuxfoundation.org>
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

[ Upstream commit c58eb1b54feefc3a47fab78addd14083bc941c44 ]

Some usb type-c dongle use irq_hpd request to perform device connection
and disconnection. This patch add handling of both connection and
disconnection are based on the state of hpd_state and sink_count.

Changes in V2:
-- add dp_display_handle_port_ststus_changed()
-- fix kernel test robot complaint

Changes in V3:
-- add encoder_mode_set into struct dp_display_private

Reported-by: kernel test robot <lkp@intel.com>
Fixes: 26b8d66a399e ("drm/msm/dp: promote irq_hpd handle to handle link training correctly")
Tested-by: Stephen Boyd <swboyd@chromium.org>
Signed-off-by: Kuogee Hsieh <khsieh@codeaurora.org>
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dp/dp_display.c | 92 +++++++++++++++++------------
 1 file changed, 55 insertions(+), 37 deletions(-)

diff --git a/drivers/gpu/drm/msm/dp/dp_display.c b/drivers/gpu/drm/msm/dp/dp_display.c
index f1f777baa2c4..a3de1d0523ea 100644
--- a/drivers/gpu/drm/msm/dp/dp_display.c
+++ b/drivers/gpu/drm/msm/dp/dp_display.c
@@ -102,6 +102,8 @@ struct dp_display_private {
 	struct dp_display_mode dp_mode;
 	struct msm_dp dp_display;
 
+	bool encoder_mode_set;
+
 	/* wait for audio signaling */
 	struct completion audio_comp;
 
@@ -306,13 +308,24 @@ static void dp_display_send_hpd_event(struct msm_dp *dp_display)
 	drm_helper_hpd_irq_event(connector->dev);
 }
 
-static int dp_display_send_hpd_notification(struct dp_display_private *dp,
-					    bool hpd)
+
+static void dp_display_set_encoder_mode(struct dp_display_private *dp)
 {
-	static bool encoder_mode_set;
 	struct msm_drm_private *priv = dp->dp_display.drm_dev->dev_private;
 	struct msm_kms *kms = priv->kms;
 
+	if (!dp->encoder_mode_set && dp->dp_display.encoder &&
+				kms->funcs->set_encoder_mode) {
+		kms->funcs->set_encoder_mode(kms,
+				dp->dp_display.encoder, false);
+
+		dp->encoder_mode_set = true;
+	}
+}
+
+static int dp_display_send_hpd_notification(struct dp_display_private *dp,
+					    bool hpd)
+{
 	if ((hpd && dp->dp_display.is_connected) ||
 			(!hpd && !dp->dp_display.is_connected)) {
 		DRM_DEBUG_DP("HPD already %s\n", (hpd ? "on" : "off"));
@@ -325,15 +338,6 @@ static int dp_display_send_hpd_notification(struct dp_display_private *dp,
 
 	dp->dp_display.is_connected = hpd;
 
-	if (dp->dp_display.is_connected && dp->dp_display.encoder
-				&& !encoder_mode_set
-				&& kms->funcs->set_encoder_mode) {
-		kms->funcs->set_encoder_mode(kms,
-				dp->dp_display.encoder, false);
-		DRM_DEBUG_DP("set_encoder_mode() Completed\n");
-		encoder_mode_set = true;
-	}
-
 	dp_display_send_hpd_event(&dp->dp_display);
 
 	return 0;
@@ -369,7 +373,6 @@ static int dp_display_process_hpd_high(struct dp_display_private *dp)
 
 	dp_add_event(dp, EV_USER_NOTIFICATION, true, 0);
 
-
 end:
 	return rc;
 }
@@ -386,6 +389,8 @@ static void dp_display_host_init(struct dp_display_private *dp)
 	if (dp->usbpd->orientation == ORIENTATION_CC2)
 		flip = true;
 
+	dp_display_set_encoder_mode(dp);
+
 	dp_power_init(dp->power, flip);
 	dp_ctrl_host_init(dp->ctrl, flip);
 	dp_aux_init(dp->aux);
@@ -469,24 +474,42 @@ static void dp_display_handle_video_request(struct dp_display_private *dp)
 	}
 }
 
-static int dp_display_handle_irq_hpd(struct dp_display_private *dp)
+static int dp_display_handle_port_ststus_changed(struct dp_display_private *dp)
 {
-	u32 sink_request;
-
-	sink_request = dp->link->sink_request;
+	int rc = 0;
 
-	if (sink_request & DS_PORT_STATUS_CHANGED) {
-		if (dp_display_is_sink_count_zero(dp)) {
-			DRM_DEBUG_DP("sink count is zero, nothing to do\n");
-			return -ENOTCONN;
+	if (dp_display_is_sink_count_zero(dp)) {
+		DRM_DEBUG_DP("sink count is zero, nothing to do\n");
+		if (dp->hpd_state != ST_DISCONNECTED) {
+			dp->hpd_state = ST_DISCONNECT_PENDING;
+			dp_add_event(dp, EV_USER_NOTIFICATION, false, 0);
+		}
+	} else {
+		if (dp->hpd_state == ST_DISCONNECTED) {
+			dp->hpd_state = ST_CONNECT_PENDING;
+			rc = dp_display_process_hpd_high(dp);
+			if (rc)
+				dp->hpd_state = ST_DISCONNECTED;
 		}
+	}
+
+	return rc;
+}
+
+static int dp_display_handle_irq_hpd(struct dp_display_private *dp)
+{
+	u32 sink_request = dp->link->sink_request;
 
-		return dp_display_process_hpd_high(dp);
+	if (dp->hpd_state == ST_DISCONNECTED) {
+		if (sink_request & DP_LINK_STATUS_UPDATED) {
+			DRM_ERROR("Disconnected, no DP_LINK_STATUS_UPDATED\n");
+			return -EINVAL;
+		}
 	}
 
 	dp_ctrl_handle_sink_request(dp->ctrl);
 
-	if (dp->link->sink_request & DP_TEST_LINK_VIDEO_PATTERN)
+	if (sink_request & DP_TEST_LINK_VIDEO_PATTERN)
 		dp_display_handle_video_request(dp);
 
 	return 0;
@@ -517,19 +540,10 @@ static int dp_display_usbpd_attention_cb(struct device *dev)
 	rc = dp_link_process_request(dp->link);
 	if (!rc) {
 		sink_request = dp->link->sink_request;
-		if (sink_request & DS_PORT_STATUS_CHANGED) {
-			/* same as unplugged */
-			hpd->hpd_high = 0;
-			dp->hpd_state = ST_DISCONNECT_PENDING;
-			dp_add_event(dp, EV_USER_NOTIFICATION, false, 0);
-		}
-
-		rc = dp_display_handle_irq_hpd(dp);
-
-		if (!rc && (sink_request & DS_PORT_STATUS_CHANGED)) {
-			hpd->hpd_high = 1;
-			dp->hpd_state = ST_CONNECT_PENDING;
-		}
+		if (sink_request & DS_PORT_STATUS_CHANGED)
+			rc = dp_display_handle_port_ststus_changed(dp);
+		else
+			rc = dp_display_handle_irq_hpd(dp);
 	}
 
 	return rc;
@@ -694,6 +708,7 @@ static int dp_disconnect_pending_timeout(struct dp_display_private *dp, u32 data
 static int dp_irq_hpd_handle(struct dp_display_private *dp, u32 data)
 {
 	u32 state;
+	int ret;
 
 	mutex_lock(&dp->event_mutex);
 
@@ -704,7 +719,10 @@ static int dp_irq_hpd_handle(struct dp_display_private *dp, u32 data)
 		return 0;
 	}
 
-	dp_display_usbpd_attention_cb(&dp->pdev->dev);
+	ret = dp_display_usbpd_attention_cb(&dp->pdev->dev);
+	if (ret == -ECONNRESET) { /* cable unplugged */
+		dp->core_initialized = false;
+	}
 
 	mutex_unlock(&dp->event_mutex);
 
-- 
2.35.1



