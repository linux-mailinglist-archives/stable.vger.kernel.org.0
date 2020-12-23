Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B122F2E11C8
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 03:17:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726361AbgLWCRL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:17:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:44560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725300AbgLWCRL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:17:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6893D22202;
        Wed, 23 Dec 2020 02:16:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608689790;
        bh=H4fX8Jv2Oxuo+GyoGMn6H8Tb6++/vP4bLQ21Kywy0OI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fscbrdx9SlH6wVCrvt3am0BgMGbpLuaCwk36lKijvCchEqZUqIOijbuKc3uzsTgDC
         Svnz1NaqgefWsEc3ImExOtF8/Lxr+59YfcT4ADw8AEY8YO0uZHmM35gAiCQQopsmpV
         rX6V0ZEONOH5tgwV9AcIgbNxGIAXjNz6WCbfw5ZJZviaS0T9OaE1us1tpZMilxCAqH
         ZEMJjnUGd3kpOtJ1vEe26DCKpGPXScMRym2rRObARi6zDoafcG7/2SeTEG0kPFavLv
         Ls5SUvYXVJgl8tZCn4a87Hem5FdgE6amBrfLRkS9/CDEMNDPZyqpNfAq/eRKFbDPAp
         /DnXWhks7gEwg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Paul Cercueil <paul@crapouillou.net>,
        Sam Ravnborg <sam@ravnborg.org>,
        Sasha Levin <sashal@kernel.org>, linux-mips@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.10 002/217] drm/ingenic: Reset pixclock rate when parent clock rate changes
Date:   Tue, 22 Dec 2020 21:12:51 -0500
Message-Id: <20201223021626.2790791-2-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223021626.2790791-1-sashal@kernel.org>
References: <20201223021626.2790791-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
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
index a3d1617d7c67e..819744d7d5897 100644
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
@@ -934,16 +979,28 @@ static int ingenic_drm_bind(struct device *dev, bool has_components)
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
@@ -965,7 +1022,9 @@ static int compare_of(struct device *dev, void *data)
 static void ingenic_drm_unbind(struct device *dev)
 {
 	struct ingenic_drm *priv = dev_get_drvdata(dev);
+	struct clk *parent_clk = clk_get_parent(priv->pix_clk);
 
+	clk_notifier_unregister(parent_clk, &priv->clock_nb);
 	if (priv->lcd_clk)
 		clk_disable_unprepare(priv->lcd_clk);
 	clk_disable_unprepare(priv->pix_clk);
-- 
2.27.0

