Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 467E7541B71
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:47:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381460AbiFGVrS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:47:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382041AbiFGVqK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:46:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01F34235B04;
        Tue,  7 Jun 2022 12:07:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9B57DB823AF;
        Tue,  7 Jun 2022 19:07:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01950C385A2;
        Tue,  7 Jun 2022 19:07:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654628863;
        bh=CZ/vaZHm91i3CNrD5PGY++BahAhBDENwnCQ7zpnuHDE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YRAi32sJWZi96KFGoCpnAUvSloR6GyILZ82Yph0vXRJZCfI0woYuoeakRS1fg3Wzh
         MFMTTty5cTs6Yx24CH6fP67KskuooV7FxFgNHw9BhhKn5RVzZD3+Aupy6hpo7xFOad
         ZES2HaGfT+Sxkk/linYMYJz7/c7DWAVUCQwzC1Ss=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rob Clark <robdclark@gmail.com>,
        Douglas Anderson <dianders@chromium.org>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Abhinav Kumar <quic_abhinavk@quicinc.com>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 483/879] drm/msm/dsi: dont powerup at modeset time for parade-ps8640
Date:   Tue,  7 Jun 2022 19:00:01 +0200
Message-Id: <20220607165016.893812695@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
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

From: Douglas Anderson <dianders@chromium.org>

[ Upstream commit ec7981e6c614254937b37ce0af9eac09901c05c5 ]

Commit 7d8e9a90509f ("drm/msm/dsi: move DSI host powerup to modeset
time") caused sc7180 Chromebooks that use the parade-ps8640 bridge
chip to fail to turn the display back on after it turns off.

Unfortunately, it doesn't look easy to fix the parade-ps8640 driver to
handle the new power sequence. The Linux driver has almost nothing in
it and most of the logic for this bridge chip is in black-box firmware
that the bridge chip uses.

Also unfortunately, reverting the patch will break "tc358762".

The long term solution here is probably Dave Stevenson's series [1]
that would give more flexibility. However, that is likely not a quick
fix.

For the short term, we'll look at the compatible of the next bridge in
the chain and go back to the old way for the Parade PS8640 bridge
chip. If it's found that other bridge chips also need this workaround
then we can add them to the list or consider inverting the
condition. However, the hope is that the framework will not take too
much longer to land and we won't have to add anything other than
ps8640 here.

[1] https://lore.kernel.org/r/cover.1646406653.git.dave.stevenson@raspberrypi.com

Fixes: 7d8e9a90509f ("drm/msm/dsi: move DSI host powerup to modeset time")
Suggested-by: Rob Clark <robdclark@gmail.com>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Link: https://lore.kernel.org/r/20220513131504.v5.1.Ia196e35ad985059e77b038a41662faae9e26f411@changeid
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dsi/dsi_manager.c | 32 ++++++++++++++++++++++++++-
 1 file changed, 31 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/dsi/dsi_manager.c b/drivers/gpu/drm/msm/dsi/dsi_manager.c
index 1db93e562fe6..84f3b2ebf1b8 100644
--- a/drivers/gpu/drm/msm/dsi/dsi_manager.c
+++ b/drivers/gpu/drm/msm/dsi/dsi_manager.c
@@ -34,6 +34,32 @@ static struct msm_dsi_manager msm_dsim_glb;
 #define IS_SYNC_NEEDED()	(msm_dsim_glb.is_sync_needed)
 #define IS_MASTER_DSI_LINK(id)	(msm_dsim_glb.master_dsi_link_id == id)
 
+#ifdef CONFIG_OF
+static bool dsi_mgr_power_on_early(struct drm_bridge *bridge)
+{
+	struct drm_bridge *next_bridge = drm_bridge_get_next_bridge(bridge);
+
+	/*
+	 * If the next bridge in the chain is the Parade ps8640 bridge chip
+	 * then don't power on early since it seems to violate the expectations
+	 * of the firmware that the bridge chip is running.
+	 *
+	 * NOTE: this is expected to be a temporary special case. It's expected
+	 * that we'll eventually have a framework that allows the next level
+	 * bridge to indicate whether it needs us to power on before it or
+	 * after it. When that framework is in place then we'll use it and
+	 * remove this special case.
+	 */
+	return !(next_bridge && next_bridge->of_node &&
+		 of_device_is_compatible(next_bridge->of_node, "parade,ps8640"));
+}
+#else
+static inline bool dsi_mgr_power_on_early(struct drm_bridge *bridge)
+{
+	return true;
+}
+#endif
+
 static inline struct msm_dsi *dsi_mgr_get_dsi(int id)
 {
 	return msm_dsim_glb.dsi[id];
@@ -389,6 +415,9 @@ static void dsi_mgr_bridge_pre_enable(struct drm_bridge *bridge)
 	if (is_bonded_dsi && !IS_MASTER_DSI_LINK(id))
 		return;
 
+	if (!dsi_mgr_power_on_early(bridge))
+		dsi_mgr_bridge_power_on(bridge);
+
 	/* Always call panel functions once, because even for dual panels,
 	 * there is only one drm_panel instance.
 	 */
@@ -570,7 +599,8 @@ static void dsi_mgr_bridge_mode_set(struct drm_bridge *bridge,
 	if (is_bonded_dsi && other_dsi)
 		msm_dsi_host_set_display_mode(other_dsi->host, adjusted_mode);
 
-	dsi_mgr_bridge_power_on(bridge);
+	if (dsi_mgr_power_on_early(bridge))
+		dsi_mgr_bridge_power_on(bridge);
 }
 
 static const struct drm_connector_funcs dsi_mgr_connector_funcs = {
-- 
2.35.1



