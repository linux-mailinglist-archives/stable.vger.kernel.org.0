Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20B3854057E
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 19:26:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346174AbiFGR0A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 13:26:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346974AbiFGRZh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 13:25:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDC19111B80;
        Tue,  7 Jun 2022 10:23:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 15DE560BC6;
        Tue,  7 Jun 2022 17:23:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24F98C385A5;
        Tue,  7 Jun 2022 17:23:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654622633;
        bh=vfebubb+COFyqqRnxderfn9E5M8pqbYMbPh9j7G7l1Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GBO2cKZGiD/9IV+6nzBf5AWPq3hLR43jH2RcSxPI52tJtgkm2FX6+5kKz7sqlAdf3
         rh2+AxXm8vDnXi83wAfmV83WOMJ5l61AoZ6YhhGEPZtVKJ4WQARbTBbthHNZTtw89K
         dBYq5elSrcTFUTBs18eKJ3XmTYVQKrVChD/GfXA8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Cercueil <paul@crapouillou.net>,
        Sam Ravnborg <sam@ravnborg.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 130/452] drm/ingenic: Reset pixclock rate when parent clock rate changes
Date:   Tue,  7 Jun 2022 18:59:47 +0200
Message-Id: <20220607164912.433484819@linuxfoundation.org>
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

From: Paul Cercueil <paul@crapouillou.net>

[ Upstream commit 33700f6f7d9f6b4e1e6df933ef7fd388889c662c ]

Old Ingenic SoCs can overclock very well, up to +50% of their nominal
clock rate, whithout requiring overvolting or anything like that, just
by changing the rate of the main PLL. Unfortunately, all clocks on the
system are derived from that PLL, and when the PLL rate is updated, so
is our pixel clock.

To counter that issue, we make sure that the panel is in VBLANK before
the rate change happens, and we will then re-set the pixel clock rate
afterwards, once the PLL has been changed, to be as close as possible to
the pixel rate requested by the encoder.

v2: Add comment about mutex usage

Signed-off-by: Paul Cercueil <paul@crapouillou.net>
Reviewed-by: Sam Ravnborg <sam@ravnborg.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20200926170501.1109197-2-paul@crapouillou.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/ingenic/ingenic-drm-drv.c | 61 ++++++++++++++++++++++-
 1 file changed, 60 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/ingenic/ingenic-drm-drv.c b/drivers/gpu/drm/ingenic/ingenic-drm-drv.c
index b6bb5fc7d183..e34718cf5c2e 100644
--- a/drivers/gpu/drm/ingenic/ingenic-drm-drv.c
+++ b/drivers/gpu/drm/ingenic/ingenic-drm-drv.c
@@ -10,6 +10,7 @@
 #include <linux/clk.h>
 #include <linux/dma-mapping.h>
 #include <linux/module.h>
+#include <linux/mutex.h>
 #include <linux/of_device.h>
 #include <linux/platform_device.h>
 #include <linux/regmap.h>
@@ -68,6 +69,21 @@ struct ingenic_drm {
 
 	bool panel_is_sharp;
 	bool no_vblank;
+
+	/*
+	 * clk_mutex is used to synchronize the pixel clock rate update with
+	 * the VBLANK. When the pixel clock's parent clock needs to be updated,
+	 * clock_nb's notifier function will lock the mutex, then wait until the
+	 * next VBLANK. At that point, the parent clock's rate can be updated,
+	 * and the mutex is then unlocked. If an atomic commit happens in the
+	 * meantime, it will lock on the mutex, effectively waiting until the
+	 * clock update process finishes. Finally, the pixel clock's rate will
+	 * be recomputed when the mutex has been released, in the pending atomic
+	 * commit, or a future one.
+	 */
+	struct mutex clk_mutex;
+	bool update_clk_rate;
+	struct notifier_block clock_nb;
 };
 
 static const u32 ingenic_drm_primary_formats[] = {
@@ -111,6 +127,29 @@ static inline struct ingenic_drm *drm_crtc_get_priv(struct drm_crtc *crtc)
 	return container_of(crtc, struct ingenic_drm, crtc);
 }
 
+static inline struct ingenic_drm *drm_nb_get_priv(struct notifier_block *nb)
+{
+	return container_of(nb, struct ingenic_drm, clock_nb);
+}
+
+static int ingenic_drm_update_pixclk(struct notifier_block *nb,
+				     unsigned long action,
+				     void *data)
+{
+	struct ingenic_drm *priv = drm_nb_get_priv(nb);
+
+	switch (action) {
+	case PRE_RATE_CHANGE:
+		mutex_lock(&priv->clk_mutex);
+		priv->update_clk_rate = true;
+		drm_crtc_wait_one_vblank(&priv->crtc);
+		return NOTIFY_OK;
+	default:
+		mutex_unlock(&priv->clk_mutex);
+		return NOTIFY_OK;
+	}
+}
+
 static void ingenic_drm_crtc_atomic_enable(struct drm_crtc *crtc,
 					   struct drm_crtc_state *state)
 {
@@ -276,8 +315,14 @@ static void ingenic_drm_crtc_atomic_flush(struct drm_crtc *crtc,
 
 	if (drm_atomic_crtc_needs_modeset(state)) {
 		ingenic_drm_crtc_update_timings(priv, &state->mode);
+		priv->update_clk_rate = true;
+	}
 
+	if (priv->update_clk_rate) {
+		mutex_lock(&priv->clk_mutex);
 		clk_set_rate(priv->pix_clk, state->adjusted_mode.clock * 1000);
+		priv->update_clk_rate = false;
+		mutex_unlock(&priv->clk_mutex);
 	}
 
 	if (event) {
@@ -936,16 +981,28 @@ static int ingenic_drm_bind(struct device *dev, bool has_components)
 	if (soc_info->has_osd)
 		regmap_write(priv->map, JZ_REG_LCD_OSDC, JZ_LCD_OSDC_OSDEN);
 
+	mutex_init(&priv->clk_mutex);
+	priv->clock_nb.notifier_call = ingenic_drm_update_pixclk;
+
+	parent_clk = clk_get_parent(priv->pix_clk);
+	ret = clk_notifier_register(parent_clk, &priv->clock_nb);
+	if (ret) {
+		dev_err(dev, "Unable to register clock notifier\n");
+		goto err_devclk_disable;
+	}
+
 	ret = drm_dev_register(drm, 0);
 	if (ret) {
 		dev_err(dev, "Failed to register DRM driver\n");
-		goto err_devclk_disable;
+		goto err_clk_notifier_unregister;
 	}
 
 	drm_fbdev_generic_setup(drm, 32);
 
 	return 0;
 
+err_clk_notifier_unregister:
+	clk_notifier_unregister(parent_clk, &priv->clock_nb);
 err_devclk_disable:
 	if (priv->lcd_clk)
 		clk_disable_unprepare(priv->lcd_clk);
@@ -967,7 +1024,9 @@ static int compare_of(struct device *dev, void *data)
 static void ingenic_drm_unbind(struct device *dev)
 {
 	struct ingenic_drm *priv = dev_get_drvdata(dev);
+	struct clk *parent_clk = clk_get_parent(priv->pix_clk);
 
+	clk_notifier_unregister(parent_clk, &priv->clock_nb);
 	if (priv->lcd_clk)
 		clk_disable_unprepare(priv->lcd_clk);
 	clk_disable_unprepare(priv->pix_clk);
-- 
2.35.1



