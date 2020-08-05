Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2083C23D1DE
	for <lists+stable@lfdr.de>; Wed,  5 Aug 2020 22:07:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727951AbgHEUHF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Aug 2020 16:07:05 -0400
Received: from mx2.suse.de ([195.135.220.15]:57636 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726660AbgHEQeG (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 Aug 2020 12:34:06 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id F2A3DB694;
        Wed,  5 Aug 2020 10:54:48 +0000 (UTC)
From:   Thomas Zimmermann <tzimmermann@suse.de>
To:     airlied@redhat.com, daniel@ffwll.ch, sam@ravnborg.org,
        kraxel@redhat.com, emil.l.velikov@gmail.com
Cc:     dri-devel@lists.freedesktop.org,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        "Y.C. Chen" <yc_chen@aspeedtech.com>, stable@vger.kernel.org
Subject: [PATCH v1 1/4] drm/ast: Only set format registers if primary plane's format changes
Date:   Wed,  5 Aug 2020 12:54:25 +0200
Message-Id: <20200805105428.2590-2-tzimmermann@suse.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200805105428.2590-1-tzimmermann@suse.de>
References: <20200805105428.2590-1-tzimmermann@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The atomic modesetting code tried to distinguish format changes from
full modesetting operations. But the implementation was buggy and the
format registers were often updated even for simple pageflips.

Fix this problem by distinguishing between format and mode changes; and
handle each in it's own branch.

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
 drivers/gpu/drm/ast/ast_mode.c | 52 ++++++++++++++++------------------
 1 file changed, 25 insertions(+), 27 deletions(-)

diff --git a/drivers/gpu/drm/ast/ast_mode.c b/drivers/gpu/drm/ast/ast_mode.c
index 62fe682a7de6..b129833c0821 100644
--- a/drivers/gpu/drm/ast/ast_mode.c
+++ b/drivers/gpu/drm/ast/ast_mode.c
@@ -768,34 +768,32 @@ static void ast_crtc_helper_atomic_flush(struct drm_crtc *crtc,
 {
 	struct drm_device *dev = crtc->dev;
 	struct ast_private *ast = to_ast_private(dev);
-	struct ast_crtc_state *ast_state;
-	const struct drm_format_info *format;
-	struct ast_vbios_mode_info *vbios_mode_info;
-	struct drm_display_mode *adjusted_mode;
-
-	ast_state = to_ast_crtc_state(crtc->state);
-
-	format = ast_state->format;
-	if (!format)
-		return;
-
-	vbios_mode_info = &ast_state->vbios_mode_info;
-
-	ast_set_color_reg(ast, format);
-	ast_set_vbios_color_reg(ast, format, vbios_mode_info);
-
-	if (!crtc->state->mode_changed)
-		return;
-
-	adjusted_mode = &crtc->state->adjusted_mode;
+	struct drm_crtc_state *crtc_state = crtc->state;
+	struct ast_crtc_state *ast_crtc_state = to_ast_crtc_state(crtc_state);
+	struct ast_crtc_state *old_ast_crtc_state =
+		to_ast_crtc_state(old_crtc_state);
+	const struct drm_format_info *format = ast_crtc_state->format;
+	struct ast_vbios_mode_info *vbios_mode_info =
+		&ast_crtc_state->vbios_mode_info;
+	struct drm_display_mode *adjusted_mode = &crtc_state->adjusted_mode;
+
+	if (drm_WARN_ON_ONCE(dev, !format))
+		return; /* BUG: We didn't set format in primary check(). */
+
+	if (format != old_ast_crtc_state->format) {
+		ast_set_color_reg(ast, format);
+		ast_set_vbios_color_reg(ast, format, vbios_mode_info);
+	}
 
-	ast_set_vbios_mode_reg(ast, adjusted_mode, vbios_mode_info);
-	ast_set_index_reg(ast, AST_IO_CRTC_PORT, 0xa1, 0x06);
-	ast_set_std_reg(ast, adjusted_mode, vbios_mode_info);
-	ast_set_crtc_reg(ast, adjusted_mode, vbios_mode_info);
-	ast_set_dclk_reg(ast, adjusted_mode, vbios_mode_info);
-	ast_set_crtthd_reg(ast);
-	ast_set_sync_reg(ast, adjusted_mode, vbios_mode_info);
+	if (drm_atomic_crtc_needs_modeset(crtc_state)) {
+		ast_set_vbios_mode_reg(ast, adjusted_mode, vbios_mode_info);
+		ast_set_index_reg(ast, AST_IO_CRTC_PORT, 0xa1, 0x06);
+		ast_set_std_reg(ast, adjusted_mode, vbios_mode_info);
+		ast_set_crtc_reg(ast, adjusted_mode, vbios_mode_info);
+		ast_set_dclk_reg(ast, adjusted_mode, vbios_mode_info);
+		ast_set_crtthd_reg(ast);
+		ast_set_sync_reg(ast, adjusted_mode, vbios_mode_info);
+	}
 }
 
 static void
-- 
2.28.0

