Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C83D92FD1A4
	for <lists+stable@lfdr.de>; Wed, 20 Jan 2021 14:54:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727936AbhATNDl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Jan 2021 08:03:41 -0500
Received: from aposti.net ([89.234.176.197]:42546 "EHLO aposti.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388984AbhATMiz (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 20 Jan 2021 07:38:55 -0500
From:   Paul Cercueil <paul@crapouillou.net>
To:     David Airlie <airlied@linux.ie>, Daniel Vetter <daniel@ffwll.ch>
Cc:     Sam Ravnborg <sam@ravnborg.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        od@zcrc.me, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, Paul Cercueil <paul@crapouillou.net>,
        stable@vger.kernel.org
Subject: [PATCH v2 2/3] drm/ingenic: Register devm action to cleanup encoders
Date:   Wed, 20 Jan 2021 12:35:34 +0000
Message-Id: <20210120123535.40226-3-paul@crapouillou.net>
In-Reply-To: <20210120123535.40226-1-paul@crapouillou.net>
References: <20210120123535.40226-1-paul@crapouillou.net>
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

Fixes: c369cb27c267 ("drm/ingenic: Support multiple panels/bridges")
Cc: <stable@vger.kernel.org> # 5.8+
Signed-off-by: Paul Cercueil <paul@crapouillou.net>
---

Notes:
    Use the V1 of this patch to fix v5.11 and older kernels. This V2 only
    applies on the current drm-misc-next branch.

 drivers/gpu/drm/ingenic/ingenic-drm-drv.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/ingenic/ingenic-drm-drv.c b/drivers/gpu/drm/ingenic/ingenic-drm-drv.c
index 7bb31fbee29d..158433b4c084 100644
--- a/drivers/gpu/drm/ingenic/ingenic-drm-drv.c
+++ b/drivers/gpu/drm/ingenic/ingenic-drm-drv.c
@@ -1014,20 +1014,18 @@ static int ingenic_drm_bind(struct device *dev, bool has_components)
 			bridge = devm_drm_panel_bridge_add_typed(dev, panel,
 								 DRM_MODE_CONNECTOR_DPI);
 
-		encoder = devm_kzalloc(dev, sizeof(*encoder), GFP_KERNEL);
-		if (!encoder)
-			return -ENOMEM;
+		encoder = __drmm_simple_encoder_alloc(drm, sizeof(*encoder), 0,
+						      DRM_MODE_ENCODER_DPI);
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
2.29.2

