Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E9B423D1E9
	for <lists+stable@lfdr.de>; Wed,  5 Aug 2020 22:07:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728137AbgHEUHW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Aug 2020 16:07:22 -0400
Received: from mx2.suse.de ([195.135.220.15]:57640 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726238AbgHEQeG (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 Aug 2020 12:34:06 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id F28D6B684;
        Wed,  5 Aug 2020 10:54:48 +0000 (UTC)
From:   Thomas Zimmermann <tzimmermann@suse.de>
To:     airlied@redhat.com, daniel@ffwll.ch, sam@ravnborg.org,
        kraxel@redhat.com, emil.l.velikov@gmail.com
Cc:     dri-devel@lists.freedesktop.org,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        "Y.C. Chen" <yc_chen@aspeedtech.com>, stable@vger.kernel.org
Subject: [PATCH v1 2/4] drm/ast: Set display mode in atomic_begin()
Date:   Wed,  5 Aug 2020 12:54:26 +0200
Message-Id: <20200805105428.2590-3-tzimmermann@suse.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200805105428.2590-1-tzimmermann@suse.de>
References: <20200805105428.2590-1-tzimmermann@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Move the mode-setting code from atomic_flush() to atomic_begin(), and
thus before the plane update. With the CRTC update before the plane
updates, the cursor can be disabled while the mode is being changed.

The patch removes the call ast_open_key() from atomic_begin(), The
function unlocks ast's extended display registers; something that has
been done at this point already.

The now-empty implementation of atomic_flush() is also being removed.

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
 drivers/gpu/drm/ast/ast_mode.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/gpu/drm/ast/ast_mode.c b/drivers/gpu/drm/ast/ast_mode.c
index b129833c0821..0ea8a68ac2d9 100644
--- a/drivers/gpu/drm/ast/ast_mode.c
+++ b/drivers/gpu/drm/ast/ast_mode.c
@@ -757,14 +757,6 @@ static int ast_crtc_helper_atomic_check(struct drm_crtc *crtc,
 
 static void ast_crtc_helper_atomic_begin(struct drm_crtc *crtc,
 					 struct drm_crtc_state *old_crtc_state)
-{
-	struct ast_private *ast = to_ast_private(crtc->dev);
-
-	ast_open_key(ast);
-}
-
-static void ast_crtc_helper_atomic_flush(struct drm_crtc *crtc,
-					 struct drm_crtc_state *old_crtc_state)
 {
 	struct drm_device *dev = crtc->dev;
 	struct ast_private *ast = to_ast_private(dev);
@@ -813,7 +805,6 @@ ast_crtc_helper_atomic_disable(struct drm_crtc *crtc,
 static const struct drm_crtc_helper_funcs ast_crtc_helper_funcs = {
 	.atomic_check = ast_crtc_helper_atomic_check,
 	.atomic_begin = ast_crtc_helper_atomic_begin,
-	.atomic_flush = ast_crtc_helper_atomic_flush,
 	.atomic_enable = ast_crtc_helper_atomic_enable,
 	.atomic_disable = ast_crtc_helper_atomic_disable,
 };
-- 
2.28.0

