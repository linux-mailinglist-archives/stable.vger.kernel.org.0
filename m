Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BAC6259582
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 17:53:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726515AbgIAPwe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 11:52:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:38136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730652AbgIAPrV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:47:21 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C43BD206EB;
        Tue,  1 Sep 2020 15:47:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598975239;
        bh=cExe3YsQA9IAsmb6uOURiIgE5CLTYeac8d0aLHq5KtU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sb78S0LgZ74ePOI3A2vWKKui8gbtXlvnYIcr2w/QR6A4Wmz4QcUJyfLTN/o2ngY/r
         wSJzZv4aysujto0+16Bq91u8OkRC4RAQ/+Exu4i0TFfKWiPLNohXwOs6S3NJfpBmCt
         LeismCItVl0kL05KQb72auluep7+sheGZLkeVRj0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Maxime Ripard <mripard@kernel.org>,
        Boris Brezillon <boris.brezillon@collabora.com>,
        Liviu Dudau <liviu.dudau@arm.com>,
        Thierry Reding <treding@nvidia.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        syzbot+0871b14ca2e2fb64f6e3@syzkaller.appspotmail.com,
        "James (Qian) Wang" <james.qian.wang@arm.com>,
        Mihail Atanassov <mihail.atanassov@arm.com>,
        Brian Starkey <brian.starkey@arm.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        Boris Brezillon <bbrezillon@kernel.org>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Ludovic Desroches <ludovic.desroches@microchip.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Thierry Reding <thierry.reding@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Jyri Sarha <jsarha@ti.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Rob Clark <robdclark@gmail.com>,
        Sean Paul <seanpaul@chromium.org>,
        Brian Masney <masneyb@onstation.org>,
        Emil Velikov <emil.velikov@collabora.com>,
        zhengbin <zhengbin13@huawei.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-tegra@vger.kernel.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-renesas-soc@vger.kernel.org,
        Daniel Vetter <daniel.vetter@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 246/255] drm/atomic-helper: reset vblank on crtc reset
Date:   Tue,  1 Sep 2020 17:11:42 +0200
Message-Id: <20200901151012.545771312@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901151000.800754757@linuxfoundation.org>
References: <20200901151000.800754757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Vetter <daniel.vetter@ffwll.ch>

[ Upstream commit 51f644b40b4b794b28b982fdd5d0dd8ee63f9272 ]

Only when vblanks are supported ofc.

Some drivers do this already, but most unfortunately missed it. This
opens up bugs after driver load, before the crtc is enabled for the
first time. syzbot spotted this when loading vkms as a secondary
output. Given how many drivers are buggy it's best to solve this once
and for all in shared helper code.

Aside from moving the few existing calls to drm_crtc_vblank_reset into
helpers (i915 doesn't use helpers, so keeps its own) I think the
regression risk is minimal: atomic helpers already rely on drivers
calling drm_crtc_vblank_on/off correctly in their hooks when they
support vblanks. And driver that's failing to handle vblanks after
this is missing those calls already, and vblanks could only work by
accident when enabling a CRTC for the first time right after boot.

Big thanks to Tetsuo for helping track down what's going wrong here.

There's only a few drivers which already had the necessary call and
needed some updating:
- komeda, atmel and tidss also needed to be changed to call
  __drm_atomic_helper_crtc_reset() intead of open coding it
- tegra and msm even had it in the same place already, just code
  motion, and malidp already uses __drm_atomic_helper_crtc_reset().
- Laurent noticed that rcar-du and omap open-code their crtc reset and
  hence would actually be broken by this patch now. So fix them up by
  reusing the helpers, which brings the drm_crtc_vblank_reset() back.

Only call left is in i915, which doesn't use drm_mode_config_reset,
but has its own fastboot infrastructure. So that's the only case where
we actually want this in the driver still.

I've also reviewed all other drivers which set up vblank support with
drm_vblank_init. After the previous patch fixing mxsfb all atomic
drivers do call drm_crtc_vblank_on/off as they should, the remaining
drivers are either legacy kms or legacy dri1 drivers, so not affected
by this change to atomic helpers.

v2: Use the drm_dev_has_vblank() helper.

v3: Laurent pointed out that omap and rcar-du used drm_crtc_vblank_off
instead of drm_crtc_vblank_reset. Adjust them too.

v4: Laurent noticed that rcar-du and omap open-code their crtc reset
and hence would actually be broken by this patch now. So fix them up
by reusing the helpers, which brings the drm_crtc_vblank_reset() back.

v5: also mention rcar-du and ompadrm in the proper commit message
above (Laurent).

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Acked-by: Maxime Ripard <mripard@kernel.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
Acked-by: Liviu Dudau <liviu.dudau@arm.com>
Acked-by: Thierry Reding <treding@nvidia.com>
Link: https://syzkaller.appspot.com/bug?id=0ba17d70d062b2595e1f061231474800f076c7cb
Reported-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Reported-by: syzbot+0871b14ca2e2fb64f6e3@syzkaller.appspotmail.com
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: "James (Qian) Wang" <james.qian.wang@arm.com>
Cc: Liviu Dudau <liviu.dudau@arm.com>
Cc: Mihail Atanassov <mihail.atanassov@arm.com>
Cc: Brian Starkey <brian.starkey@arm.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Boris Brezillon <bbrezillon@kernel.org>
Cc: Nicolas Ferre <nicolas.ferre@microchip.com>
Cc: Alexandre Belloni <alexandre.belloni@bootlin.com>
Cc: Ludovic Desroches <ludovic.desroches@microchip.com>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: David Airlie <airlied@linux.ie>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: Thierry Reding <thierry.reding@gmail.com>
Cc: Jonathan Hunter <jonathanh@nvidia.com>
Cc: Jyri Sarha <jsarha@ti.com>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Rob Clark <robdclark@gmail.com>
Cc: Sean Paul <seanpaul@chromium.org>
Cc: Brian Masney <masneyb@onstation.org>
Cc: Emil Velikov <emil.velikov@collabora.com>
Cc: zhengbin <zhengbin13@huawei.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-tegra@vger.kernel.org
Cc: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-renesas-soc@vger.kernel.org
Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200612160056.2082681-1-daniel.vetter@ffwll.ch
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/arm/display/komeda/komeda_crtc.c | 7 ++-----
 drivers/gpu/drm/arm/malidp_drv.c                 | 1 -
 drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_crtc.c   | 7 ++-----
 drivers/gpu/drm/drm_atomic_state_helper.c        | 4 ++++
 drivers/gpu/drm/msm/disp/mdp5/mdp5_crtc.c        | 2 --
 drivers/gpu/drm/omapdrm/omap_crtc.c              | 8 +++++---
 drivers/gpu/drm/omapdrm/omap_drv.c               | 4 ----
 drivers/gpu/drm/rcar-du/rcar_du_crtc.c           | 6 +-----
 drivers/gpu/drm/tegra/dc.c                       | 1 -
 drivers/gpu/drm/tidss/tidss_crtc.c               | 3 +--
 drivers/gpu/drm/tidss/tidss_kms.c                | 5 -----
 11 files changed, 15 insertions(+), 33 deletions(-)

diff --git a/drivers/gpu/drm/arm/display/komeda/komeda_crtc.c b/drivers/gpu/drm/arm/display/komeda/komeda_crtc.c
index 56bd938961eee..f33418d6e1a08 100644
--- a/drivers/gpu/drm/arm/display/komeda/komeda_crtc.c
+++ b/drivers/gpu/drm/arm/display/komeda/komeda_crtc.c
@@ -492,10 +492,8 @@ static void komeda_crtc_reset(struct drm_crtc *crtc)
 	crtc->state = NULL;
 
 	state = kzalloc(sizeof(*state), GFP_KERNEL);
-	if (state) {
-		crtc->state = &state->base;
-		crtc->state->crtc = crtc;
-	}
+	if (state)
+		__drm_atomic_helper_crtc_reset(crtc, &state->base);
 }
 
 static struct drm_crtc_state *
@@ -616,7 +614,6 @@ static int komeda_crtc_add(struct komeda_kms_dev *kms,
 		return err;
 
 	drm_crtc_helper_add(crtc, &komeda_crtc_helper_funcs);
-	drm_crtc_vblank_reset(crtc);
 
 	crtc->port = kcrtc->master->of_output_port;
 
diff --git a/drivers/gpu/drm/arm/malidp_drv.c b/drivers/gpu/drm/arm/malidp_drv.c
index def8c9ffafcaf..a2a10bfbccac4 100644
--- a/drivers/gpu/drm/arm/malidp_drv.c
+++ b/drivers/gpu/drm/arm/malidp_drv.c
@@ -870,7 +870,6 @@ static int malidp_bind(struct device *dev)
 	drm->irq_enabled = true;
 
 	ret = drm_vblank_init(drm, drm->mode_config.num_crtc);
-	drm_crtc_vblank_reset(&malidp->crtc);
 	if (ret < 0) {
 		DRM_ERROR("failed to initialise vblank\n");
 		goto vblank_fail;
diff --git a/drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_crtc.c b/drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_crtc.c
index 10985134ce0ba..ce246b96330b7 100644
--- a/drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_crtc.c
+++ b/drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_crtc.c
@@ -411,10 +411,8 @@ static void atmel_hlcdc_crtc_reset(struct drm_crtc *crtc)
 	}
 
 	state = kzalloc(sizeof(*state), GFP_KERNEL);
-	if (state) {
-		crtc->state = &state->base;
-		crtc->state->crtc = crtc;
-	}
+	if (state)
+		__drm_atomic_helper_crtc_reset(crtc, &state->base);
 }
 
 static struct drm_crtc_state *
@@ -528,7 +526,6 @@ int atmel_hlcdc_crtc_create(struct drm_device *dev)
 	}
 
 	drm_crtc_helper_add(&crtc->base, &lcdc_crtc_helper_funcs);
-	drm_crtc_vblank_reset(&crtc->base);
 
 	drm_mode_crtc_set_gamma_size(&crtc->base, ATMEL_HLCDC_CLUT_SIZE);
 	drm_crtc_enable_color_mgmt(&crtc->base, 0, false,
diff --git a/drivers/gpu/drm/drm_atomic_state_helper.c b/drivers/gpu/drm/drm_atomic_state_helper.c
index 8fce6a115dfe3..9ad74045158ec 100644
--- a/drivers/gpu/drm/drm_atomic_state_helper.c
+++ b/drivers/gpu/drm/drm_atomic_state_helper.c
@@ -32,6 +32,7 @@
 #include <drm/drm_device.h>
 #include <drm/drm_plane.h>
 #include <drm/drm_print.h>
+#include <drm/drm_vblank.h>
 #include <drm/drm_writeback.h>
 
 #include <linux/slab.h>
@@ -93,6 +94,9 @@ __drm_atomic_helper_crtc_reset(struct drm_crtc *crtc,
 	if (crtc_state)
 		__drm_atomic_helper_crtc_state_reset(crtc_state, crtc);
 
+	if (drm_dev_has_vblank(crtc->dev))
+		drm_crtc_vblank_reset(crtc);
+
 	crtc->state = crtc_state;
 }
 EXPORT_SYMBOL(__drm_atomic_helper_crtc_reset);
diff --git a/drivers/gpu/drm/msm/disp/mdp5/mdp5_crtc.c b/drivers/gpu/drm/msm/disp/mdp5/mdp5_crtc.c
index b5fed67c4651f..0c54b7bc19010 100644
--- a/drivers/gpu/drm/msm/disp/mdp5/mdp5_crtc.c
+++ b/drivers/gpu/drm/msm/disp/mdp5/mdp5_crtc.c
@@ -1117,8 +1117,6 @@ static void mdp5_crtc_reset(struct drm_crtc *crtc)
 		mdp5_crtc_destroy_state(crtc, crtc->state);
 
 	__drm_atomic_helper_crtc_reset(crtc, &mdp5_cstate->base);
-
-	drm_crtc_vblank_reset(crtc);
 }
 
 static const struct drm_crtc_funcs mdp5_crtc_funcs = {
diff --git a/drivers/gpu/drm/omapdrm/omap_crtc.c b/drivers/gpu/drm/omapdrm/omap_crtc.c
index fce7e944a280b..6d40914675dad 100644
--- a/drivers/gpu/drm/omapdrm/omap_crtc.c
+++ b/drivers/gpu/drm/omapdrm/omap_crtc.c
@@ -697,14 +697,16 @@ static int omap_crtc_atomic_get_property(struct drm_crtc *crtc,
 
 static void omap_crtc_reset(struct drm_crtc *crtc)
 {
+	struct omap_crtc_state *state;
+
 	if (crtc->state)
 		__drm_atomic_helper_crtc_destroy_state(crtc->state);
 
 	kfree(crtc->state);
-	crtc->state = kzalloc(sizeof(struct omap_crtc_state), GFP_KERNEL);
 
-	if (crtc->state)
-		crtc->state->crtc = crtc;
+	state = kzalloc(sizeof(*state), GFP_KERNEL);
+	if (state)
+		__drm_atomic_helper_crtc_reset(crtc, &state->base);
 }
 
 static struct drm_crtc_state *
diff --git a/drivers/gpu/drm/omapdrm/omap_drv.c b/drivers/gpu/drm/omapdrm/omap_drv.c
index cdafd7ef1c320..cc4d754ff8c02 100644
--- a/drivers/gpu/drm/omapdrm/omap_drv.c
+++ b/drivers/gpu/drm/omapdrm/omap_drv.c
@@ -595,7 +595,6 @@ static int omapdrm_init(struct omap_drm_private *priv, struct device *dev)
 {
 	const struct soc_device_attribute *soc;
 	struct drm_device *ddev;
-	unsigned int i;
 	int ret;
 
 	DBG("%s", dev_name(dev));
@@ -642,9 +641,6 @@ static int omapdrm_init(struct omap_drm_private *priv, struct device *dev)
 		goto err_cleanup_modeset;
 	}
 
-	for (i = 0; i < priv->num_pipes; i++)
-		drm_crtc_vblank_off(priv->pipes[i].crtc);
-
 	omap_fbdev_init(ddev);
 
 	drm_kms_helper_poll_init(ddev);
diff --git a/drivers/gpu/drm/rcar-du/rcar_du_crtc.c b/drivers/gpu/drm/rcar-du/rcar_du_crtc.c
index d73e88ddecd0f..fe86a3e677571 100644
--- a/drivers/gpu/drm/rcar-du/rcar_du_crtc.c
+++ b/drivers/gpu/drm/rcar-du/rcar_du_crtc.c
@@ -975,8 +975,7 @@ static void rcar_du_crtc_reset(struct drm_crtc *crtc)
 	state->crc.source = VSP1_DU_CRC_NONE;
 	state->crc.index = 0;
 
-	crtc->state = &state->state;
-	crtc->state->crtc = crtc;
+	__drm_atomic_helper_crtc_reset(crtc, &state->state);
 }
 
 static int rcar_du_crtc_enable_vblank(struct drm_crtc *crtc)
@@ -1271,9 +1270,6 @@ int rcar_du_crtc_create(struct rcar_du_group *rgrp, unsigned int swindex,
 
 	drm_crtc_helper_add(crtc, &crtc_helper_funcs);
 
-	/* Start with vertical blanking interrupt reporting disabled. */
-	drm_crtc_vblank_off(crtc);
-
 	/* Register the interrupt handler. */
 	if (rcar_du_has(rcdu, RCAR_DU_FEATURE_CRTC_IRQ_CLOCK)) {
 		/* The IRQ's are associated with the CRTC (sw)index. */
diff --git a/drivers/gpu/drm/tegra/dc.c b/drivers/gpu/drm/tegra/dc.c
index 04d6848d19fcf..da8b9983b7de0 100644
--- a/drivers/gpu/drm/tegra/dc.c
+++ b/drivers/gpu/drm/tegra/dc.c
@@ -1169,7 +1169,6 @@ static void tegra_crtc_reset(struct drm_crtc *crtc)
 		tegra_crtc_atomic_destroy_state(crtc, crtc->state);
 
 	__drm_atomic_helper_crtc_reset(crtc, &state->base);
-	drm_crtc_vblank_reset(crtc);
 }
 
 static struct drm_crtc_state *
diff --git a/drivers/gpu/drm/tidss/tidss_crtc.c b/drivers/gpu/drm/tidss/tidss_crtc.c
index 89a226912de85..4d01c4af61cd0 100644
--- a/drivers/gpu/drm/tidss/tidss_crtc.c
+++ b/drivers/gpu/drm/tidss/tidss_crtc.c
@@ -352,8 +352,7 @@ static void tidss_crtc_reset(struct drm_crtc *crtc)
 		return;
 	}
 
-	crtc->state = &tcrtc->base;
-	crtc->state->crtc = crtc;
+	__drm_atomic_helper_crtc_reset(crtc, &tcrtc->base);
 }
 
 static struct drm_crtc_state *tidss_crtc_duplicate_state(struct drm_crtc *crtc)
diff --git a/drivers/gpu/drm/tidss/tidss_kms.c b/drivers/gpu/drm/tidss/tidss_kms.c
index c0240f7e0b198..eec359f61a06d 100644
--- a/drivers/gpu/drm/tidss/tidss_kms.c
+++ b/drivers/gpu/drm/tidss/tidss_kms.c
@@ -253,7 +253,6 @@ static int tidss_dispc_modeset_init(struct tidss_device *tidss)
 int tidss_modeset_init(struct tidss_device *tidss)
 {
 	struct drm_device *ddev = &tidss->ddev;
-	unsigned int i;
 	int ret;
 
 	dev_dbg(tidss->dev, "%s\n", __func__);
@@ -278,10 +277,6 @@ int tidss_modeset_init(struct tidss_device *tidss)
 	if (ret)
 		return ret;
 
-	/* Start with vertical blanking interrupt reporting disabled. */
-	for (i = 0; i < tidss->num_crtcs; ++i)
-		drm_crtc_vblank_reset(tidss->crtcs[i]);
-
 	drm_mode_config_reset(ddev);
 
 	dev_dbg(tidss->dev, "%s done\n", __func__);
-- 
2.25.1



