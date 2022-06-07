Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF2E8540651
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 19:34:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347282AbiFGRef (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 13:34:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347203AbiFGRaO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 13:30:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 542D010EA4C;
        Tue,  7 Jun 2022 10:26:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DAA7A60BC6;
        Tue,  7 Jun 2022 17:26:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9ACDC385A5;
        Tue,  7 Jun 2022 17:25:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654622760;
        bh=d47ap0PNr2I+PiCDmbwMkgn3x71S85CHq6IPTIaFqY4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mZfdEQZbWN7s1KQfbzwKwiV0OBZvqL0AJh9GmtSc1H5G65s1fD0WpYGzqrB1dcfZ/
         VXsrAUriaLbI7UHpkwI1AM9uELAl0Ba2P12dvqlhM5vnidW+YfYkxg4ANguZUwfzCG
         1nZOlWj/5ZfI9Cwcmt/Bw0mw/DPBfutlJc6gvPcY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuogee Hsieh <quic_khsieh@quicinc.com>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 174/452] drm/msm/dp: stop event kernel thread when DP unbind
Date:   Tue,  7 Jun 2022 19:00:31 +0200
Message-Id: <20220607164913.746608555@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164908.521895282@linuxfoundation.org>
References: <20220607164908.521895282@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kuogee Hsieh <quic_khsieh@quicinc.com>

[ Upstream commit 570d3e5d28db7a94557fa179167a9fb8642fb8a1 ]

Current DP driver implementation, event thread is kept running
after DP display is unbind. This patch fix this problem by disabling
DP irq and stop event thread to exit gracefully at dp_display_unbind().

Changes in v2:
-- start event thread at dp_display_bind()

Changes in v3:
-- disable all HDP interrupts at unbind
-- replace dp_hpd_event_setup() with dp_hpd_event_thread_start()
-- replace dp_hpd_event_stop() with dp_hpd_event_thread_stop()
-- move init_waitqueue_head(&dp->event_q) to probe()
-- move spin_lock_init(&dp->event_lock) to probe()

Changes in v4:
-- relocate both dp_display_bind() and dp_display_unbind() to bottom of file

Changes in v5:
-- cancel relocation of both dp_display_bind() and dp_display_unbind()

Changes in v6:
-- move empty event q to dp_event_thread_start()

Changes in v7:
-- call ktheread_stop() directly instead of dp_hpd_event_thread_stop() function

Changes in v8:
-- return error immediately if audio registration failed.

Changes in v9:
-- return error immediately if event thread create failed.

Changes in v10:
-- delete extra  DRM_ERROR("failed to create DP event thread\n");

Fixes: 8ede2ecc3e5e ("drm/msm/dp: Add DP compliance tests on Snapdragon Chipsets")
Signed-off-by: Kuogee Hsieh <quic_khsieh@quicinc.com>
Reported-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Patchwork: https://patchwork.freedesktop.org/patch/482399/
Link: https://lore.kernel.org/r/1650318988-17580-1-git-send-email-quic_khsieh@quicinc.com
[DB: fixed Fixes tag]
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dp/dp_display.c | 39 +++++++++++++++++++++++------
 1 file changed, 31 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/msm/dp/dp_display.c b/drivers/gpu/drm/msm/dp/dp_display.c
index 6cd6934c8c9f..36caf3d5a9f9 100644
--- a/drivers/gpu/drm/msm/dp/dp_display.c
+++ b/drivers/gpu/drm/msm/dp/dp_display.c
@@ -111,6 +111,7 @@ struct dp_display_private {
 	u32 hpd_state;
 	u32 event_pndx;
 	u32 event_gndx;
+	struct task_struct *ev_tsk;
 	struct dp_event event_list[DP_EVENT_Q_MAX];
 	spinlock_t event_lock;
 
@@ -194,6 +195,8 @@ void dp_display_signal_audio_complete(struct msm_dp *dp_display)
 	complete_all(&dp->audio_comp);
 }
 
+static int dp_hpd_event_thread_start(struct dp_display_private *dp_priv);
+
 static int dp_display_bind(struct device *dev, struct device *master,
 			   void *data)
 {
@@ -234,9 +237,18 @@ static int dp_display_bind(struct device *dev, struct device *master,
 	}
 
 	rc = dp_register_audio_driver(dev, dp->audio);
-	if (rc)
+	if (rc) {
 		DRM_ERROR("Audio registration Dp failed\n");
+		goto end;
+	}
 
+	rc = dp_hpd_event_thread_start(dp);
+	if (rc) {
+		DRM_ERROR("Event thread create failed\n");
+		goto end;
+	}
+
+	return 0;
 end:
 	return rc;
 }
@@ -255,6 +267,11 @@ static void dp_display_unbind(struct device *dev, struct device *master,
 		return;
 	}
 
+	/* disable all HPD interrupts */
+	dp_catalog_hpd_config_intr(dp->catalog, DP_DP_HPD_INT_MASK, false);
+
+	kthread_stop(dp->ev_tsk);
+
 	dp_power_client_deinit(dp->power);
 	dp_aux_unregister(dp->aux);
 	priv->dp = NULL;
@@ -981,7 +998,7 @@ static int hpd_event_thread(void *data)
 
 	dp_priv = (struct dp_display_private *)data;
 
-	while (1) {
+	while (!kthread_should_stop()) {
 		if (timeout_mode) {
 			wait_event_timeout(dp_priv->event_q,
 				(dp_priv->event_pndx == dp_priv->event_gndx),
@@ -1062,12 +1079,17 @@ static int hpd_event_thread(void *data)
 	return 0;
 }
 
-static void dp_hpd_event_setup(struct dp_display_private *dp_priv)
+static int dp_hpd_event_thread_start(struct dp_display_private *dp_priv)
 {
-	init_waitqueue_head(&dp_priv->event_q);
-	spin_lock_init(&dp_priv->event_lock);
+	/* set event q to empty */
+	dp_priv->event_gndx = 0;
+	dp_priv->event_pndx = 0;
 
-	kthread_run(hpd_event_thread, dp_priv, "dp_hpd_handler");
+	dp_priv->ev_tsk = kthread_run(hpd_event_thread, dp_priv, "dp_hpd_handler");
+	if (IS_ERR(dp_priv->ev_tsk))
+		return PTR_ERR(dp_priv->ev_tsk);
+
+	return 0;
 }
 
 static irqreturn_t dp_display_irq_handler(int irq, void *dev_id)
@@ -1167,8 +1189,11 @@ static int dp_display_probe(struct platform_device *pdev)
 		return -EPROBE_DEFER;
 	}
 
+	/* setup event q */
 	mutex_init(&dp->event_mutex);
 	g_dp_display = &dp->dp_display;
+	init_waitqueue_head(&dp->event_q);
+	spin_lock_init(&dp->event_lock);
 
 	/* Store DP audio handle inside DP display */
 	g_dp_display->dp_audio = dp->audio;
@@ -1308,8 +1333,6 @@ void msm_dp_irq_postinstall(struct msm_dp *dp_display)
 
 	dp = container_of(dp_display, struct dp_display_private, dp_display);
 
-	dp_hpd_event_setup(dp);
-
 	dp_add_event(dp, EV_HPD_INIT_SETUP, 0, 100);
 }
 
-- 
2.35.1



