Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7C4022E6AD
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 09:37:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726513AbgG0HhP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 03:37:15 -0400
Received: from mx2.suse.de ([195.135.220.15]:59398 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726323AbgG0HhP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 03:37:15 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id A7D26B01F;
        Mon, 27 Jul 2020 07:37:24 +0000 (UTC)
From:   Thomas Zimmermann <tzimmermann@suse.de>
To:     airlied@redhat.com, daniel@ffwll.ch, sam@ravnborg.org,
        kraxel@redhat.com, emil.l.velikov@gmail.com
Cc:     dri-devel@lists.freedesktop.org,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        "Y.C. Chen" <yc_chen@aspeedtech.com>, stable@vger.kernel.org
Subject: [PATCH 1/3] drm/ast: Do full modeset if the primary plane's format changes
Date:   Mon, 27 Jul 2020 09:37:05 +0200
Message-Id: <20200727073707.21097-2-tzimmermann@suse.de>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200727073707.21097-1-tzimmermann@suse.de>
References: <20200727073707.21097-1-tzimmermann@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The atomic modesetting code tried to distinguish format changes from
full modesetting operations. In practice, this was buggy and the format
registers were often updated even for simple pageflips.

Instead do a full modeset if the primary plane changes formats. It's
just as rare as an actual mode change, so there will be no performance
penalty.

The patch also replaces a reference to drm_crtc_state.allow_modeset with
the correct call to drm_atomic_crtc_needs_modeset().

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Fixes: 4961eb60f145 ("drm/ast: Enable atomic modesetting")
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Gerd Hoffmann <kraxel@redhat.com>
Cc: Dave Airlie <airlied@redhat.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Emil Velikov <emil.l.velikov@gmail.com>
Cc: "Y.C. Chen" <yc_chen@aspeedtech.com>
Cc: <stable@vger.kernel.org> # v5.6+
---
 drivers/gpu/drm/ast/ast_mode.c | 23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/ast/ast_mode.c b/drivers/gpu/drm/ast/ast_mode.c
index 154cd877d9d1..3680a000b812 100644
--- a/drivers/gpu/drm/ast/ast_mode.c
+++ b/drivers/gpu/drm/ast/ast_mode.c
@@ -527,8 +527,8 @@ static const uint32_t ast_primary_plane_formats[] = {
 static int ast_primary_plane_helper_atomic_check(struct drm_plane *plane,
 						 struct drm_plane_state *state)
 {
-	struct drm_crtc_state *crtc_state;
-	struct ast_crtc_state *ast_crtc_state;
+	struct drm_crtc_state *crtc_state, *old_crtc_state;
+	struct ast_crtc_state *ast_crtc_state, *old_ast_crtc_state;
 	int ret;
 
 	if (!state->crtc)
@@ -550,6 +550,15 @@ static int ast_primary_plane_helper_atomic_check(struct drm_plane *plane,
 
 	ast_crtc_state->format = state->fb->format;
 
+	old_crtc_state = drm_atomic_get_old_crtc_state(state->state, state->crtc);
+	if (!old_crtc_state)
+		return 0;
+	old_ast_crtc_state = to_ast_crtc_state(old_crtc_state);
+	if (!old_ast_crtc_state)
+		return 0;
+	if (ast_crtc_state->format != old_ast_crtc_state->format)
+		crtc_state->mode_changed = true;
+
 	return 0;
 }
 
@@ -775,18 +784,18 @@ static void ast_crtc_helper_atomic_flush(struct drm_crtc *crtc,
 
 	ast_state = to_ast_crtc_state(crtc->state);
 
-	format = ast_state->format;
-	if (!format)
+	if (!drm_atomic_crtc_needs_modeset(crtc->state))
 		return;
 
+	format = ast_state->format;
+	if (drm_WARN_ON_ONCE(dev, !format))
+		return; /* BUG: We didn't set format in primary check(). */
+
 	vbios_mode_info = &ast_state->vbios_mode_info;
 
 	ast_set_color_reg(ast, format);
 	ast_set_vbios_color_reg(ast, format, vbios_mode_info);
 
-	if (!crtc->state->mode_changed)
-		return;
-
 	adjusted_mode = &crtc->state->adjusted_mode;
 
 	ast_set_vbios_mode_reg(ast, adjusted_mode, vbios_mode_info);
-- 
2.27.0

