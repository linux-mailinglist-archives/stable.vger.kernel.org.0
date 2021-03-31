Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 906AD34D64F
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 19:52:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230449AbhC2Rvf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 13:51:35 -0400
Received: from aposti.net ([89.234.176.197]:38890 "EHLO aposti.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230258AbhC2RvT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 13:51:19 -0400
From:   Paul Cercueil <paul@crapouillou.net>
To:     David Airlie <airlied@linux.ie>, Daniel Vetter <daniel@ffwll.ch>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Simon Ser <contact@emersion.fr>
Cc:     Sam Ravnborg <sam@ravnborg.org>, od@zcrc.me,
        linux-mips@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, Paul Cercueil <paul@crapouillou.net>,
        stable@vger.kernel.org
Subject: [PATCH 2/2] drm/ingenic: Don't request full modeset if property is not modified
Date:   Mon, 29 Mar 2021 18:50:46 +0100
Message-Id: <20210329175046.214629-3-paul@crapouillou.net>
In-Reply-To: <20210329175046.214629-1-paul@crapouillou.net>
References: <20210329175046.214629-1-paul@crapouillou.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Avoid requesting a full modeset if the sharpness property is not
modified, because then we don't actually need it.

Fixes: fc1acf317b01 ("drm/ingenic: Add support for the IPU")
Cc: <stable@vger.kernel.org> # 5.8+
Signed-off-by: Paul Cercueil <paul@crapouillou.net>
---
 drivers/gpu/drm/ingenic/ingenic-ipu.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/ingenic/ingenic-ipu.c b/drivers/gpu/drm/ingenic/ingenic-ipu.c
index 3b1091e7c0cd..95b665c4a7b0 100644
--- a/drivers/gpu/drm/ingenic/ingenic-ipu.c
+++ b/drivers/gpu/drm/ingenic/ingenic-ipu.c
@@ -640,10 +640,12 @@ ingenic_ipu_plane_atomic_set_property(struct drm_plane *plane,
 {
 	struct ingenic_ipu *ipu = plane_to_ingenic_ipu(plane);
 	struct drm_crtc_state *crtc_state;
+	bool mode_changed;
 
 	if (property != ipu->sharpness_prop)
 		return -EINVAL;
 
+	mode_changed = val != ipu->sharpness;
 	ipu->sharpness = val;
 
 	if (state->crtc) {
@@ -651,7 +653,7 @@ ingenic_ipu_plane_atomic_set_property(struct drm_plane *plane,
 		if (WARN_ON(!crtc_state))
 			return -EINVAL;
 
-		crtc_state->mode_changed = true;
+		crtc_state->mode_changed |= mode_changed;
 	}
 
 	return 0;
-- 
2.30.2

