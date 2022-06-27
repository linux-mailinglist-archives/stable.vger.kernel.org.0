Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA68D55C25E
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 14:46:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236470AbiF0Lie (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:38:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236495AbiF0Lhf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:37:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7F7C28F;
        Mon, 27 Jun 2022 04:33:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 44F85609D0;
        Mon, 27 Jun 2022 11:33:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB24FC341C7;
        Mon, 27 Jun 2022 11:33:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656329612;
        bh=d83IYfUoSCwlimeO40t3MmhOsYVKQ9De0jR/4Cmakr4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZdIKYUlyYu5IkcXzGRNnfMYZ1lO8rNJ5KJPp7V8PMzHuQ5XTmdbYpxnkJYmB4pRlP
         FAoAcUN4rjoHCib5C557nSir1hlgemUswW2BCArR2xWFTjysASoNPQjS7NoSE+BkDp
         76Jaba1jEBvhuOsMaX4xJqCnvNu0vsOIwRSNyqFk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 056/135] drm/msm/dp: Drop now unused hpd_high member
Date:   Mon, 27 Jun 2022 13:21:03 +0200
Message-Id: <20220627111939.784309520@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111938.151743692@linuxfoundation.org>
References: <20220627111938.151743692@linuxfoundation.org>
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

From: Bjorn Andersson <bjorn.andersson@linaro.org>

[ Upstream commit fabae667b1263216be53e0230cd3966a9a1963a4 ]

Since '8ede2ecc3e5e ("drm/msm/dp: Add DP compliance tests on Snapdragon
Chipsets")' the hpd_high member of struct dp_usbpd has been write-only.

Let's clean up the code a little bit by removing the writes as well.

Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Link: https://lore.kernel.org/r/20211106172246.2597431-1-bjorn.andersson@linaro.org
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dp/dp_display.c | 6 ------
 drivers/gpu/drm/msm/dp/dp_hpd.c     | 2 --
 drivers/gpu/drm/msm/dp/dp_hpd.h     | 2 --
 3 files changed, 10 deletions(-)

diff --git a/drivers/gpu/drm/msm/dp/dp_display.c b/drivers/gpu/drm/msm/dp/dp_display.c
index 8b51a5cc3eb8..a66ee63253a3 100644
--- a/drivers/gpu/drm/msm/dp/dp_display.c
+++ b/drivers/gpu/drm/msm/dp/dp_display.c
@@ -547,11 +547,8 @@ static int dp_hpd_plug_handle(struct dp_display_private *dp, u32 data)
 
 	dp->hpd_state = ST_CONNECT_PENDING;
 
-	hpd->hpd_high = 1;
-
 	ret = dp_display_usbpd_configure_cb(&dp->pdev->dev);
 	if (ret) {	/* link train failed */
-		hpd->hpd_high = 0;
 		dp->hpd_state = ST_DISCONNECTED;
 
 		if (ret == -ECONNRESET) { /* cable unplugged */
@@ -628,7 +625,6 @@ static int dp_hpd_unplug_handle(struct dp_display_private *dp, u32 data)
 		/* triggered by irq_hdp with sink_count = 0 */
 		if (dp->link->sink_count == 0) {
 			dp_ctrl_off_phy(dp->ctrl);
-			hpd->hpd_high = 0;
 			dp->core_initialized = false;
 		}
 		mutex_unlock(&dp->event_mutex);
@@ -652,8 +648,6 @@ static int dp_hpd_unplug_handle(struct dp_display_private *dp, u32 data)
 	/* disable HPD plug interrupts */
 	dp_catalog_hpd_config_intr(dp->catalog, DP_DP_HPD_PLUG_INT_MASK, false);
 
-	hpd->hpd_high = 0;
-
 	/*
 	 * We don't need separate work for disconnect as
 	 * connect/attention interrupts are disabled
diff --git a/drivers/gpu/drm/msm/dp/dp_hpd.c b/drivers/gpu/drm/msm/dp/dp_hpd.c
index e1c90fa47411..db98a1d431eb 100644
--- a/drivers/gpu/drm/msm/dp/dp_hpd.c
+++ b/drivers/gpu/drm/msm/dp/dp_hpd.c
@@ -32,8 +32,6 @@ int dp_hpd_connect(struct dp_usbpd *dp_usbpd, bool hpd)
 	hpd_priv = container_of(dp_usbpd, struct dp_hpd_private,
 					dp_usbpd);
 
-	dp_usbpd->hpd_high = hpd;
-
 	if (!hpd_priv->dp_cb || !hpd_priv->dp_cb->configure
 				|| !hpd_priv->dp_cb->disconnect) {
 		pr_err("hpd dp_cb not initialized\n");
diff --git a/drivers/gpu/drm/msm/dp/dp_hpd.h b/drivers/gpu/drm/msm/dp/dp_hpd.h
index 5bc5bb64680f..8feec5aa5027 100644
--- a/drivers/gpu/drm/msm/dp/dp_hpd.h
+++ b/drivers/gpu/drm/msm/dp/dp_hpd.h
@@ -26,7 +26,6 @@ enum plug_orientation {
  * @multi_func: multi-function preferred
  * @usb_config_req: request to switch to usb
  * @exit_dp_mode: request exit from displayport mode
- * @hpd_high: Hot Plug Detect signal is high.
  * @hpd_irq: Change in the status since last message
  * @alt_mode_cfg_done: bool to specify alt mode status
  * @debug_en: bool to specify debug mode
@@ -39,7 +38,6 @@ struct dp_usbpd {
 	bool multi_func;
 	bool usb_config_req;
 	bool exit_dp_mode;
-	bool hpd_high;
 	bool hpd_irq;
 	bool alt_mode_cfg_done;
 	bool debug_en;
-- 
2.35.1



