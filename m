Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C27C383137
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:35:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239153AbhEQOf6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:35:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:40556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238399AbhEQOcQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:32:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5EF906191A;
        Mon, 17 May 2021 14:16:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621260963;
        bh=0Q9sItVJADPaj0GEl4aT6bBiMfmmbTcjj3Sw0Kt/rNI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dUy2PNRskoy7A2p/H9WL6MRhvTRQ87sn3BKUN+h+sjvQ9JhD5d+iloyEmb3n93GZB
         FeNT+5sLEM7XYgZoj3X21Qn69Tv6PZzNHpcMGtaPVrVL66teifq/e8YvpyT7Io1yIs
         1Udu7XbtOV1yt0aKC6wOimglPTVKoCyFfm8FY8qE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuogee Hsieh <khsieh@codeaurora.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 276/363] drm/msm/dp: initialize audio_comp when audio starts
Date:   Mon, 17 May 2021 16:02:22 +0200
Message-Id: <20210517140311.952492245@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.508966430@linuxfoundation.org>
References: <20210517140302.508966430@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kuogee Hsieh <khsieh@codeaurora.org>

[ Upstream commit f2f46b878777e0d3f885c7ddad48f477b4dea247 ]

Initialize audio_comp when audio starts and wait for audio_comp at
dp_display_disable(). This will take care of both dongle unplugged
and display off (suspend) cases.

Changes in v2:
-- add dp_display_signal_audio_start()

Changes in v3:
-- restore dp_display_handle_plugged_change() at dp_hpd_unplug_handle().

Changes in v4:
-- none

Signed-off-by: Kuogee Hsieh <khsieh@codeaurora.org>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Tested-by: Stephen Boyd <swboyd@chromium.org>
Fixes: c703d5789590 ("drm/msm/dp: trigger unplug event in msm_dp_display_disable")
Link: https://lore.kernel.org/r/1619048258-8717-3-git-send-email-khsieh@codeaurora.org
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dp/dp_audio.c   |  1 +
 drivers/gpu/drm/msm/dp/dp_display.c | 11 +++++++++--
 drivers/gpu/drm/msm/dp/dp_display.h |  1 +
 3 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/msm/dp/dp_audio.c b/drivers/gpu/drm/msm/dp/dp_audio.c
index 82a8673ab8da..d7e4a39a904e 100644
--- a/drivers/gpu/drm/msm/dp/dp_audio.c
+++ b/drivers/gpu/drm/msm/dp/dp_audio.c
@@ -527,6 +527,7 @@ int dp_audio_hw_params(struct device *dev,
 	dp_audio_setup_acr(audio);
 	dp_audio_safe_to_exit_level(audio);
 	dp_audio_enable(audio, true);
+	dp_display_signal_audio_start(dp_display);
 	dp_display->audio_enabled = true;
 
 end:
diff --git a/drivers/gpu/drm/msm/dp/dp_display.c b/drivers/gpu/drm/msm/dp/dp_display.c
index 5a39da6e1eaf..f3d74f8f35fe 100644
--- a/drivers/gpu/drm/msm/dp/dp_display.c
+++ b/drivers/gpu/drm/msm/dp/dp_display.c
@@ -178,6 +178,15 @@ static int dp_del_event(struct dp_display_private *dp_priv, u32 event)
 	return 0;
 }
 
+void dp_display_signal_audio_start(struct msm_dp *dp_display)
+{
+	struct dp_display_private *dp;
+
+	dp = container_of(dp_display, struct dp_display_private, dp_display);
+
+	reinit_completion(&dp->audio_comp);
+}
+
 void dp_display_signal_audio_complete(struct msm_dp *dp_display)
 {
 	struct dp_display_private *dp;
@@ -651,7 +660,6 @@ static int dp_hpd_unplug_handle(struct dp_display_private *dp, u32 data)
 	dp_add_event(dp, EV_DISCONNECT_PENDING_TIMEOUT, 0, DP_TIMEOUT_5_SECOND);
 
 	/* signal the disconnect event early to ensure proper teardown */
-	reinit_completion(&dp->audio_comp);
 	dp_display_handle_plugged_change(g_dp_display, false);
 
 	dp_catalog_hpd_config_intr(dp->catalog, DP_DP_HPD_PLUG_INT_MASK |
@@ -898,7 +906,6 @@ static int dp_display_disable(struct dp_display_private *dp, u32 data)
 	/* wait only if audio was enabled */
 	if (dp_display->audio_enabled) {
 		/* signal the disconnect event */
-		reinit_completion(&dp->audio_comp);
 		dp_display_handle_plugged_change(dp_display, false);
 		if (!wait_for_completion_timeout(&dp->audio_comp,
 				HZ * 5))
diff --git a/drivers/gpu/drm/msm/dp/dp_display.h b/drivers/gpu/drm/msm/dp/dp_display.h
index 6092ba1ed85e..5173c89eedf7 100644
--- a/drivers/gpu/drm/msm/dp/dp_display.h
+++ b/drivers/gpu/drm/msm/dp/dp_display.h
@@ -34,6 +34,7 @@ int dp_display_get_modes(struct msm_dp *dp_display,
 int dp_display_request_irq(struct msm_dp *dp_display);
 bool dp_display_check_video_test(struct msm_dp *dp_display);
 int dp_display_get_test_bpp(struct msm_dp *dp_display);
+void dp_display_signal_audio_start(struct msm_dp *dp_display);
 void dp_display_signal_audio_complete(struct msm_dp *dp_display);
 
 #endif /* _DP_DISPLAY_H_ */
-- 
2.30.2



