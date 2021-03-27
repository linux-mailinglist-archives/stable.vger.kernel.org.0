Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84FB334B6F2
	for <lists+stable@lfdr.de>; Sat, 27 Mar 2021 12:58:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230322AbhC0L6V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 27 Mar 2021 07:58:21 -0400
Received: from aposti.net ([89.234.176.197]:58596 "EHLO aposti.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231601AbhC0L6V (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 27 Mar 2021 07:58:21 -0400
From:   Paul Cercueil <paul@crapouillou.net>
To:     Andrzej Hajda <a.hajda@samsung.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Robert Foss <robert.foss@linaro.org>,
        Laurent Pinchart <Laurent.pinchart@ideasonboard.com>
Cc:     Sam Ravnborg <sam@ravnborg.org>, David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>, od@zcrc.me,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org, Paul Cercueil <paul@crapouillou.net>,
        stable@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [PATCH v4 3/3] drm/ingenic: Register devm action to cleanup encoders
Date:   Sat, 27 Mar 2021 11:57:42 +0000
Message-Id: <20210327115742.18986-4-paul@crapouillou.net>
In-Reply-To: <20210327115742.18986-1-paul@crapouillou.net>
References: <20210327115742.18986-1-paul@crapouillou.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Since the encoders have been devm-allocated, they will be freed way
before drm_mode_config_cleanup() is called. To avoid use-after-free
conditions, we then must ensure that drm_encoder_cleanup() is called
before the encoders are freed.

v2: Use the new __drmm_simple_encoder_alloc() function

v3: Use the new drmm_plain_simple_encoder_alloc() macro

v4: Use drmm_plain_encoder_alloc() macro

Fixes: c369cb27c267 ("drm/ingenic: Support multiple panels/bridges")
Cc: <stable@vger.kernel.org> # 5.8+
Signed-off-by: Paul Cercueil <paul@crapouillou.net>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/gpu/drm/ingenic/ingenic-drm-drv.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/drivers/gpu/drm/ingenic/ingenic-drm-drv.c b/drivers/gpu/drm/ingenic/ingenic-drm-drv.c
index d60e1eefc9d1..29742ec5ab95 100644
--- a/drivers/gpu/drm/ingenic/ingenic-drm-drv.c
+++ b/drivers/gpu/drm/ingenic/ingenic-drm-drv.c
@@ -24,6 +24,7 @@
 #include <drm/drm_crtc.h>
 #include <drm/drm_crtc_helper.h>
 #include <drm/drm_drv.h>
+#include <drm/drm_encoder.h>
 #include <drm/drm_gem_cma_helper.h>
 #include <drm/drm_fb_cma_helper.h>
 #include <drm/drm_fb_helper.h>
@@ -37,7 +38,6 @@
 #include <drm/drm_plane.h>
 #include <drm/drm_plane_helper.h>
 #include <drm/drm_probe_helper.h>
-#include <drm/drm_simple_kms_helper.h>
 #include <drm/drm_vblank.h>
 
 struct ingenic_dma_hwdesc {
@@ -1024,20 +1024,17 @@ static int ingenic_drm_bind(struct device *dev, bool has_components)
 			bridge = devm_drm_panel_bridge_add_typed(dev, panel,
 								 DRM_MODE_CONNECTOR_DPI);
 
-		encoder = devm_kzalloc(dev, sizeof(*encoder), GFP_KERNEL);
-		if (!encoder)
-			return -ENOMEM;
+		encoder = drmm_plain_encoder_alloc(drm, NULL, DRM_MODE_ENCODER_DPI, NULL);
+		if (IS_ERR(encoder)) {
+			ret = PTR_ERR(encoder);
+			dev_err(dev, "Failed to init encoder: %d\n", ret);
+			return ret;
+		}
 
 		encoder->possible_crtcs = 1;
 
 		drm_encoder_helper_add(encoder, &ingenic_drm_encoder_helper_funcs);
 
-		ret = drm_simple_encoder_init(drm, encoder, DRM_MODE_ENCODER_DPI);
-		if (ret) {
-			dev_err(dev, "Failed to init encoder: %d\n", ret);
-			return ret;
-		}
-
 		ret = drm_bridge_attach(encoder, bridge, NULL, 0);
 		if (ret) {
 			dev_err(dev, "Unable to attach bridge\n");
-- 
2.30.2

