Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50BA122E6AE
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 09:37:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726270AbgG0HhQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 03:37:16 -0400
Received: from mx2.suse.de ([195.135.220.15]:59412 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726451AbgG0HhQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 03:37:16 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id BD07CB020;
        Mon, 27 Jul 2020 07:37:24 +0000 (UTC)
From:   Thomas Zimmermann <tzimmermann@suse.de>
To:     airlied@redhat.com, daniel@ffwll.ch, sam@ravnborg.org,
        kraxel@redhat.com, emil.l.velikov@gmail.com
Cc:     dri-devel@lists.freedesktop.org,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        "Y.C. Chen" <yc_chen@aspeedtech.com>, stable@vger.kernel.org
Subject: [PATCH 3/3] drm/ast: Disable cursor while switching display modes
Date:   Mon, 27 Jul 2020 09:37:07 +0200
Message-Id: <20200727073707.21097-4-tzimmermann@suse.de>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200727073707.21097-1-tzimmermann@suse.de>
References: <20200727073707.21097-1-tzimmermann@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The ast's HW cursor requires the primary plane and CRTC to display
at a correct mode and format. This is not the case while switching
display modes, which can lead to the screen turing permanently dark.

As a workaround, the ast driver now disables active HW cursors while
the mode switch takes place. It also synchronizes with the vertical
refresh to give HW cursor and primary plane some time to catch up on
each other.

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
 drivers/gpu/drm/ast/ast_drv.h  |  2 ++
 drivers/gpu/drm/ast/ast_mode.c | 53 +++++++++++++++++++++++++++++++++-
 2 files changed, 54 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/ast/ast_drv.h b/drivers/gpu/drm/ast/ast_drv.h
index 57414b429db3..564670b5d2ee 100644
--- a/drivers/gpu/drm/ast/ast_drv.h
+++ b/drivers/gpu/drm/ast/ast_drv.h
@@ -162,6 +162,8 @@ void ast_driver_unload(struct drm_device *dev);
 
 #define AST_IO_MM_OFFSET		(0x380)
 
+#define AST_IO_VGAIR1_VREFRESH		BIT(3)
+
 #define __ast_read(x) \
 static inline u##x ast_read##x(struct ast_private *ast, u32 reg) { \
 u##x val = 0;\
diff --git a/drivers/gpu/drm/ast/ast_mode.c b/drivers/gpu/drm/ast/ast_mode.c
index 5b2b39c93033..e18365bbc08c 100644
--- a/drivers/gpu/drm/ast/ast_mode.c
+++ b/drivers/gpu/drm/ast/ast_mode.c
@@ -514,6 +514,17 @@ static void ast_set_start_address_crt1(struct ast_private *ast,
 
 }
 
+static void ast_wait_for_vretrace(struct ast_private *ast)
+{
+	unsigned long timeout = jiffies + HZ;
+	u8 vgair1;
+
+	do {
+		vgair1 = ast_io_read8(ast, AST_IO_INPUT_STATUS1_READ);
+	} while (!(vgair1 & AST_IO_VGAIR1_VREFRESH) &&
+		 time_before(jiffies, timeout));
+}
+
 /*
  * Primary plane
  */
@@ -666,6 +677,14 @@ static int ast_cursor_plane_helper_atomic_check(struct drm_plane *plane,
 	return 0;
 }
 
+static bool ast_disable_cursor_during_modeset(struct drm_plane *cursor_plane)
+{
+	const struct drm_plane_state *cursor_state = cursor_plane->state;
+
+	return cursor_state && cursor_state->visible && cursor_state->crtc &&
+	       drm_atomic_crtc_needs_modeset(cursor_state->crtc->state);
+}
+
 static void
 ast_cursor_plane_helper_atomic_update(struct drm_plane *plane,
 				      struct drm_plane_state *old_state)
@@ -678,7 +697,12 @@ ast_cursor_plane_helper_atomic_update(struct drm_plane *plane,
 		ast_cursor_page_flip(ast);
 	}
 
-	ast_cursor_show(ast, state->crtc_x, state->crtc_y);
+	/*
+	 * For modesets, delay show() until end of atomic_flush(). See the
+	 * atomic_begin() helper for more information.
+	 */
+	if (!ast_disable_cursor_during_modeset(plane))
+		ast_cursor_show(ast, state->crtc_x, state->crtc_y);
 }
 
 static void
@@ -764,6 +788,22 @@ static void ast_crtc_helper_atomic_begin(struct drm_crtc *crtc,
 	struct ast_private *ast = to_ast_private(crtc->dev);
 
 	ast_open_key(ast);
+
+	/*
+	 * HW cursors require the underlying primary plane and CRTC to
+	 * display a valid mode and image. This is not the case during
+	 * full modeset operations. So we temporarily disable any active
+	 * HW cursor and re-enable it at the end of the atomic_flush()
+	 * helper. The busy waiting allows the code to sync with the
+	 * vertical refresh.
+	 *
+	 * We only do this during *full* modesets. It does not affect
+	 * simple pageflips on the planes.
+	 */
+	if (ast_disable_cursor_during_modeset(&ast->cursor_plane)) {
+		ast_cursor_hide(ast);
+		ast_wait_for_vretrace(ast);
+	}
 }
 
 static void ast_crtc_helper_atomic_flush(struct drm_crtc *crtc,
@@ -771,6 +811,7 @@ static void ast_crtc_helper_atomic_flush(struct drm_crtc *crtc,
 {
 	struct drm_device *dev = crtc->dev;
 	struct ast_private *ast = to_ast_private(dev);
+	struct drm_plane_state *cursor_state = ast->cursor_plane.state;
 	struct ast_crtc_state *ast_state;
 	const struct drm_format_info *format;
 	struct ast_vbios_mode_info *vbios_mode_info;
@@ -799,6 +840,16 @@ static void ast_crtc_helper_atomic_flush(struct drm_crtc *crtc,
 	ast_set_dclk_reg(ast, adjusted_mode, vbios_mode_info);
 	ast_set_crtthd_reg(ast);
 	ast_set_sync_reg(ast, adjusted_mode, vbios_mode_info);
+
+	/*
+	 * Re-enabling the HW cursor; if any. See the atomic_begin() helper
+	 * for more information.
+	 */
+	if (ast_disable_cursor_during_modeset(&ast->cursor_plane)) {
+		ast_wait_for_vretrace(ast);
+		ast_cursor_show(ast, cursor_state->crtc_x,
+				cursor_state->crtc_y);
+	}
 }
 
 static void
-- 
2.27.0

