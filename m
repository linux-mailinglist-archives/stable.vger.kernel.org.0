Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8FBF22E6AF
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 09:37:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726323AbgG0HhQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 03:37:16 -0400
Received: from mx2.suse.de ([195.135.220.15]:59384 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726270AbgG0HhQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 03:37:16 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id A79D6B01E;
        Mon, 27 Jul 2020 07:37:24 +0000 (UTC)
From:   Thomas Zimmermann <tzimmermann@suse.de>
To:     airlied@redhat.com, daniel@ffwll.ch, sam@ravnborg.org,
        kraxel@redhat.com, emil.l.velikov@gmail.com
Cc:     dri-devel@lists.freedesktop.org,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        "Y.C. Chen" <yc_chen@aspeedtech.com>, stable@vger.kernel.org
Subject: [PATCH 2/3] drm/ast: Store image size in HW cursor info
Date:   Mon, 27 Jul 2020 09:37:06 +0200
Message-Id: <20200727073707.21097-3-tzimmermann@suse.de>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200727073707.21097-1-tzimmermann@suse.de>
References: <20200727073707.21097-1-tzimmermann@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Store the image size as part of the HW cursor info, so that the
cursor show function doesn't require the information from the
caller. No functional changes.

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
 drivers/gpu/drm/ast/ast_cursor.c | 13 +++++++++++--
 drivers/gpu/drm/ast/ast_drv.h    |  7 +++++--
 drivers/gpu/drm/ast/ast_mode.c   |  8 +-------
 3 files changed, 17 insertions(+), 11 deletions(-)

diff --git a/drivers/gpu/drm/ast/ast_cursor.c b/drivers/gpu/drm/ast/ast_cursor.c
index acf0d23514e8..8642a0ce9da6 100644
--- a/drivers/gpu/drm/ast/ast_cursor.c
+++ b/drivers/gpu/drm/ast/ast_cursor.c
@@ -87,6 +87,8 @@ int ast_cursor_init(struct ast_private *ast)
 
 		ast->cursor.gbo[i] = gbo;
 		ast->cursor.vaddr[i] = vaddr;
+		ast->cursor.size[i].width = 0;
+		ast->cursor.size[i].height = 0;
 	}
 
 	return drmm_add_action_or_reset(dev, ast_cursor_release, NULL);
@@ -194,6 +196,9 @@ int ast_cursor_blit(struct ast_private *ast, struct drm_framebuffer *fb)
 	/* do data transfer to cursor BO */
 	update_cursor_image(dst, src, fb->width, fb->height);
 
+	ast->cursor.size[ast->cursor.next_index].width = fb->width;
+	ast->cursor.size[ast->cursor.next_index].height = fb->height;
+
 	drm_gem_vram_vunmap(gbo, src);
 	drm_gem_vram_unpin(gbo);
 
@@ -249,14 +254,18 @@ static void ast_cursor_set_location(struct ast_private *ast, u16 x, u16 y,
 	ast_set_index_reg(ast, AST_IO_CRTC_PORT, 0xc7, y1);
 }
 
-void ast_cursor_show(struct ast_private *ast, int x, int y,
-		     unsigned int offset_x, unsigned int offset_y)
+void ast_cursor_show(struct ast_private *ast, int x, int y)
 {
+	unsigned int offset_x, offset_y;
 	u8 x_offset, y_offset;
 	u8 __iomem *dst, __iomem *sig;
 	u8 jreg;
 
 	dst = ast->cursor.vaddr[ast->cursor.next_index];
+	offset_x = AST_MAX_HWC_WIDTH -
+		   ast->cursor.size[ast->cursor.next_index].width;
+	offset_y = AST_MAX_HWC_HEIGHT -
+		   ast->cursor.size[ast->cursor.next_index].height;
 
 	sig = dst + AST_HWC_SIZE;
 	writel(x, sig + AST_HWC_SIGNATURE_X);
diff --git a/drivers/gpu/drm/ast/ast_drv.h b/drivers/gpu/drm/ast/ast_drv.h
index e3a264ac7ee2..57414b429db3 100644
--- a/drivers/gpu/drm/ast/ast_drv.h
+++ b/drivers/gpu/drm/ast/ast_drv.h
@@ -116,6 +116,10 @@ struct ast_private {
 	struct {
 		struct drm_gem_vram_object *gbo[AST_DEFAULT_HWC_NUM];
 		void __iomem *vaddr[AST_DEFAULT_HWC_NUM];
+		struct {
+			unsigned int width;
+			unsigned int height;
+		} size[AST_DEFAULT_HWC_NUM];
 		unsigned int next_index;
 	} cursor;
 
@@ -311,8 +315,7 @@ void ast_release_firmware(struct drm_device *dev);
 int ast_cursor_init(struct ast_private *ast);
 int ast_cursor_blit(struct ast_private *ast, struct drm_framebuffer *fb);
 void ast_cursor_page_flip(struct ast_private *ast);
-void ast_cursor_show(struct ast_private *ast, int x, int y,
-		     unsigned int offset_x, unsigned int offset_y);
+void ast_cursor_show(struct ast_private *ast, int x, int y);
 void ast_cursor_hide(struct ast_private *ast);
 
 #endif
diff --git a/drivers/gpu/drm/ast/ast_mode.c b/drivers/gpu/drm/ast/ast_mode.c
index 3680a000b812..5b2b39c93033 100644
--- a/drivers/gpu/drm/ast/ast_mode.c
+++ b/drivers/gpu/drm/ast/ast_mode.c
@@ -671,20 +671,14 @@ ast_cursor_plane_helper_atomic_update(struct drm_plane *plane,
 				      struct drm_plane_state *old_state)
 {
 	struct drm_plane_state *state = plane->state;
-	struct drm_framebuffer *fb = state->fb;
 	struct ast_private *ast = plane->dev->dev_private;
-	unsigned int offset_x, offset_y;
-
-	offset_x = AST_MAX_HWC_WIDTH - fb->width;
-	offset_y = AST_MAX_HWC_WIDTH - fb->height;
 
 	if (state->fb != old_state->fb) {
 		/* A new cursor image was installed. */
 		ast_cursor_page_flip(ast);
 	}
 
-	ast_cursor_show(ast, state->crtc_x, state->crtc_y,
-			offset_x, offset_y);
+	ast_cursor_show(ast, state->crtc_x, state->crtc_y);
 }
 
 static void
-- 
2.27.0

