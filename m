Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7418834B6CB
	for <lists+stable@lfdr.de>; Sat, 27 Mar 2021 12:22:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230388AbhC0LWj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 27 Mar 2021 07:22:39 -0400
Received: from aposti.net ([89.234.176.197]:55408 "EHLO aposti.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230288AbhC0LWi (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 27 Mar 2021 07:22:38 -0400
From:   Paul Cercueil <paul@crapouillou.net>
To:     Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Simon Ser <contact@emersion.fr>
Cc:     od@zcrc.me, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, Paul Cercueil <paul@crapouillou.net>,
        stable@vger.kernel.org
Subject: [PATCH] drm: DON'T require each CRTC to have a unique primary plane
Date:   Sat, 27 Mar 2021 11:22:14 +0000
Message-Id: <20210327112214.10252-1-paul@crapouillou.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The ingenic-drm driver has two mutually exclusive primary planes
already; so the fact that a CRTC must have one and only one primary
plane is an invalid assumption.

Fixes: 96962e3de725 ("drm: require each CRTC to have a unique primary plane")
Cc: <stable@vger.kernel.org> # 5.11
Signed-off-by: Paul Cercueil <paul@crapouillou.net>
---
 drivers/gpu/drm/drm_mode_config.c | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/drivers/gpu/drm/drm_mode_config.c b/drivers/gpu/drm/drm_mode_config.c
index 37b4b9f0e468..d86621c41047 100644
--- a/drivers/gpu/drm/drm_mode_config.c
+++ b/drivers/gpu/drm/drm_mode_config.c
@@ -626,9 +626,7 @@ void drm_mode_config_validate(struct drm_device *dev)
 {
 	struct drm_encoder *encoder;
 	struct drm_crtc *crtc;
-	struct drm_plane *plane;
 	u32 primary_with_crtc = 0, cursor_with_crtc = 0;
-	unsigned int num_primary = 0;
 
 	if (!drm_core_check_feature(dev, DRIVER_MODESET))
 		return;
@@ -676,13 +674,4 @@ void drm_mode_config_validate(struct drm_device *dev)
 			cursor_with_crtc |= drm_plane_mask(crtc->cursor);
 		}
 	}
-
-	drm_for_each_plane(plane, dev) {
-		if (plane->type == DRM_PLANE_TYPE_PRIMARY)
-			num_primary++;
-	}
-
-	WARN(num_primary != dev->mode_config.num_crtc,
-	     "Must have as many primary planes as there are CRTCs, but have %u primary planes and %u CRTCs",
-	     num_primary, dev->mode_config.num_crtc);
 }
-- 
2.30.2

