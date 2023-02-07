Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D1AC68D7B0
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 14:02:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232008AbjBGNC2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 08:02:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232060AbjBGNCC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 08:02:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A54F9010
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 05:01:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DFBFD61358
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 13:01:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1CE7C433EF;
        Tue,  7 Feb 2023 13:01:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675774908;
        bh=xgSewL35C2I/PyvjWSied37MucZbMuQEdibNqVePo4c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1V3k+8fBm6JB+5kdOo71fK496t2TurIfMm7YIxh2iBpa+3atrgvmHvs2pVCw1dV+9
         OgMMiIxGRMYdPKdIJuTDEkbtohsrlRqfDU3HTmHj6jSFLqhxoi+UIJj9qtHZOHlgoL
         FT5kYMhcxewErQ2pm13jlUH85y2vK16Ih+nATajM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        yangcong <yangcong5@huaqin.corp-partner.google.com>,
        Douglas Anderson <dianders@chromium.org>,
        Jitao Shi <jitao.shi@mediatek.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        Rob Clark <robdclark@chromium.org>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 073/208] drm/panel: boe-tv101wum-nl6: Ensure DSI writes succeed during disable
Date:   Tue,  7 Feb 2023 13:55:27 +0100
Message-Id: <20230207125637.632929517@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephen Boyd <swboyd@chromium.org>

[ Upstream commit a3ee9e0b57f8ecca02d1c16fad4941e09bfe2941 ]

The unprepare sequence has started to fail after moving to panel bridge
code in the msm drm driver (commit 007ac0262b0d ("drm/msm/dsi: switch to
DRM_PANEL_BRIDGE")). You'll see messages like this in the kernel logs:

   panel-boe-tv101wum-nl6 ae94000.dsi.0: failed to set panel off: -22

This is because boe_panel_enter_sleep_mode() needs an operating DSI link
to set the panel into sleep mode. Performing those writes in the
unprepare phase of bridge ops is too late, because the link has already
been torn down by the DSI controller in post_disable, i.e. the PHY has
been disabled, etc. See dsi_mgr_bridge_post_disable() for more details
on the DSI .

Split the unprepare function into a disable part and an unprepare part.
For now, just the DSI writes to enter sleep mode are put in the disable
function. This fixes the panel off routine and keeps the panel happy.

My Wormdingler has an integrated touchscreen that stops responding to
touch if the panel is only half disabled too. This patch fixes it. And
finally, this saves power when the screen is off because without this
fix the regulators for the panel are left enabled when nothing is being
displayed on the screen.

Fixes: 007ac0262b0d ("drm/msm/dsi: switch to DRM_PANEL_BRIDGE")
Fixes: a869b9db7adf ("drm/panel: support for boe tv101wum-nl6 wuxga dsi video mode panel")
Cc: yangcong <yangcong5@huaqin.corp-partner.google.com>
Cc: Douglas Anderson <dianders@chromium.org>
Cc: Jitao Shi <jitao.shi@mediatek.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Rob Clark <robdclark@chromium.org>
Cc: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20230106030108.2542081-1-swboyd@chromium.org
(cherry picked from commit c913cd5489930abbb557ef144a333846286754c3)
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-boe-tv101wum-nl6.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/panel/panel-boe-tv101wum-nl6.c b/drivers/gpu/drm/panel/panel-boe-tv101wum-nl6.c
index 857a2f0420d7..c924f1124ebc 100644
--- a/drivers/gpu/drm/panel/panel-boe-tv101wum-nl6.c
+++ b/drivers/gpu/drm/panel/panel-boe-tv101wum-nl6.c
@@ -1193,14 +1193,11 @@ static int boe_panel_enter_sleep_mode(struct boe_panel *boe)
 	return 0;
 }
 
-static int boe_panel_unprepare(struct drm_panel *panel)
+static int boe_panel_disable(struct drm_panel *panel)
 {
 	struct boe_panel *boe = to_boe_panel(panel);
 	int ret;
 
-	if (!boe->prepared)
-		return 0;
-
 	ret = boe_panel_enter_sleep_mode(boe);
 	if (ret < 0) {
 		dev_err(panel->dev, "failed to set panel off: %d\n", ret);
@@ -1209,6 +1206,16 @@ static int boe_panel_unprepare(struct drm_panel *panel)
 
 	msleep(150);
 
+	return 0;
+}
+
+static int boe_panel_unprepare(struct drm_panel *panel)
+{
+	struct boe_panel *boe = to_boe_panel(panel);
+
+	if (!boe->prepared)
+		return 0;
+
 	if (boe->desc->discharge_on_disable) {
 		regulator_disable(boe->avee);
 		regulator_disable(boe->avdd);
@@ -1528,6 +1535,7 @@ static enum drm_panel_orientation boe_panel_get_orientation(struct drm_panel *pa
 }
 
 static const struct drm_panel_funcs boe_panel_funcs = {
+	.disable = boe_panel_disable,
 	.unprepare = boe_panel_unprepare,
 	.prepare = boe_panel_prepare,
 	.enable = boe_panel_enable,
-- 
2.39.0



