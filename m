Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05B0F301AC6
	for <lists+stable@lfdr.de>; Sun, 24 Jan 2021 10:00:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726579AbhAXI7c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 24 Jan 2021 03:59:32 -0500
Received: from aposti.net ([89.234.176.197]:43710 "EHLO aposti.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726680AbhAXI7X (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 24 Jan 2021 03:59:23 -0500
From:   Paul Cercueil <paul@crapouillou.net>
To:     David Airlie <airlied@linux.ie>, Daniel Vetter <daniel@ffwll.ch>
Cc:     Sam Ravnborg <sam@ravnborg.org>,
        Laurent Pinchart <Laurent.pinchart@ideasonboard.com>,
        od@zcrc.me, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org,
        Paul Cercueil <paul@crapouillou.net>, stable@vger.kernel.org
Subject: [PATCH v3 3/4] drm/ingenic: Register devm action to cleanup encoders
Date:   Sun, 24 Jan 2021 08:55:51 +0000
Message-Id: <20210124085552.29146-4-paul@crapouillou.net>
In-Reply-To: <20210124085552.29146-1-paul@crapouillou.net>
References: <20210124085552.29146-1-paul@crapouillou.net>
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

Fixes: c369cb27c267 ("drm/ingenic: Support multiple panels/bridges")
Cc: <stable@vger.kernel.org> # 5.8+
Signed-off-by: Paul Cercueil <paul@crapouillou.net>
---

Notes:
    Use the V1 of this patch to fix v5.11 and older kernels. This V3 only
    applies on the current drm-misc-next branch.

 drivers/gpu/drm/ingenic/ingenic-drm-drv.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/ingenic/ingenic-drm-drv.c b/drivers/gpu/drm/ingenic/ingenic-drm-drv.c
index 7bb31fbee29d..b23011c1c5d9 100644
--- a/drivers/gpu/drm/ingenic/ingenic-drm-drv.c
+++ b/drivers/gpu/drm/ingenic/ingenic-drm-drv.c
@@ -1014,20 +1014,17 @@ static int ingenic_drm_bind(struct device *dev, bool has_components)
 			bridge = devm_drm_panel_bridge_add_typed(dev, panel,
 								 DRM_MODE_CONNECTOR_DPI);
 
-		encoder = devm_kzalloc(dev, sizeof(*encoder), GFP_KERNEL);
-		if (!encoder)
-			return -ENOMEM;
+		encoder = drmm_plain_simple_encoder_alloc(drm, DRM_MODE_ENCODER_DPI);
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

