Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 222EF63E0C0
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 20:27:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229705AbiK3T1G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 14:27:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229701AbiK3T1B (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 14:27:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3969691C21
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 11:27:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E21D9B81CBF
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 19:26:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3E8EFC43147;
        Wed, 30 Nov 2022 19:26:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669836417;
        bh=OeKcz68qas5g3fX4AlmuImfSoAde1803uch8lxCHpvA=;
        h=From:Date:Subject:References:In-Reply-To:To:Reply-To:From;
        b=m3b27NfXwBm6ilXzzX9LmMoBzMEQXbGvqeXJKn2PYfdSmaiMofzF80xi/Nxk0WV4y
         GALClszz/dloaJJICNyFtEz+oZ5LTAdgJqblo1BVZYpf46MsyvJIWEVJwW6KmXr9ZO
         SHtOf+Ci7GhTsZjDora+xGQWukT6YCQe/svna3Qc3hfRXAUaXwNfwUAC77mtGCggYU
         H/8YCTK/dhyLlIq1gJIl7bnT+xd62z5EX0tPvnRnPkmYOnscYhkD1GdMHLVLCfk/uZ
         awtObOm7ihQ602B3QPSg8zhyQEsEHV7ZN9UZl8qdat9gnrWwojNDk+5p92yTH/1tPX
         BcJ6p8t1PSLjw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.lore.kernel.org (Postfix) with ESMTP id 2644CC4321E;
        Wed, 30 Nov 2022 19:26:57 +0000 (UTC)
From:   Noralf =?utf-8?q?Tr=C3=B8nnes?= via B4 Submission Endpoint 
        <devnull+noralf.tronnes.org@kernel.org>
Date:   Wed, 30 Nov 2022 20:26:53 +0100
Subject: [PATCH v2 5/6] drm/gud: Use the shadow plane helper
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20221122-gud-shadow-plane-v2-5-435037990a83@tronnes.org>
References: <20221122-gud-shadow-plane-v2-0-435037990a83@tronnes.org>
In-Reply-To: <20221122-gud-shadow-plane-v2-0-435037990a83@tronnes.org>
To:     Thomas Zimmermann <tzimmermann@suse.de>,
        Javier Martinez Canillas <javierm@redhat.com>,
        dri-devel@lists.freedesktop.org,
        Maxime Ripard <mripard@kernel.org>, stable@kernel.org,
        Noralf =?unknown-8bit?q?Tr=C3=B8nnes?= <noralf@tronnes.org>
X-Mailer: b4 0.11.0-dev-cc6f6
X-Developer-Signature: v=1; a=ed25519-sha256; t=1669836415; l=6659;
 i=noralf@tronnes.org; s=20221122; h=from:subject:message-id;
 bh=lVt1iqwa7vZHhFtyPrQ2KsC6nFe3faeUvS6nNBgko0I=; =?utf-8?q?b=3DBXjlvHySptSt?=
 =?utf-8?q?kO+YKe+Zsxcyk6jpQwNEpNlgiIhIcJz1pWBs2hLQxm+CO4aC7cUQam3QYLlamSjR?=
 0aBACmD7BIEbpkbmeE1HvqdOL7FUB+w0/6yt2xxUnEt+LIchf+V7
X-Developer-Key: i=noralf@tronnes.org; a=ed25519;
 pk=0o9is4iddvvlrY3yON5SVtAbgPnVs0LfQsjfqR2Hvz8=
X-Endpoint-Received: by B4 Submission Endpoint for noralf@tronnes.org/20221122 with auth_id=8
X-Original-From: Noralf =?utf-8?q?Tr=C3=B8nnes?= <noralf@tronnes.org>
Reply-To: <noralf@tronnes.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Noralf Trønnes <noralf@tronnes.org>

Use the shadow plane helper to take care of mapping the framebuffer for
CPU access. The synchronous flushing is now done inline without the use of
a worker. The async path now uses a shadow buffer to hold framebuffer
changes and it doesn't read the framebuffer behind userspace's back
anymore.

v2:
- Use src as variable name for iosys_map (Thomas)
- Prepare imported buffer for CPU access in the driver (Thomas)

Signed-off-by: Noralf Trønnes <noralf@tronnes.org>
---
 drivers/gpu/drm/gud/gud_drv.c      |  1 +
 drivers/gpu/drm/gud/gud_internal.h |  1 +
 drivers/gpu/drm/gud/gud_pipe.c     | 81 ++++++++++++++++++++++++++------------
 3 files changed, 57 insertions(+), 26 deletions(-)

diff --git a/drivers/gpu/drm/gud/gud_drv.c b/drivers/gpu/drm/gud/gud_drv.c
index d57dab104358..5aac7cda0505 100644
--- a/drivers/gpu/drm/gud/gud_drv.c
+++ b/drivers/gpu/drm/gud/gud_drv.c
@@ -365,6 +365,7 @@ static void gud_debugfs_init(struct drm_minor *minor)
 static const struct drm_simple_display_pipe_funcs gud_pipe_funcs = {
 	.check      = gud_pipe_check,
 	.update	    = gud_pipe_update,
+	DRM_GEM_SIMPLE_DISPLAY_PIPE_SHADOW_PLANE_FUNCS
 };
 
 static const struct drm_mode_config_funcs gud_mode_config_funcs = {
diff --git a/drivers/gpu/drm/gud/gud_internal.h b/drivers/gpu/drm/gud/gud_internal.h
index e351a1f1420d..0d148a6f27aa 100644
--- a/drivers/gpu/drm/gud/gud_internal.h
+++ b/drivers/gpu/drm/gud/gud_internal.h
@@ -43,6 +43,7 @@ struct gud_device {
 	struct drm_framebuffer *fb;
 	struct drm_rect damage;
 	bool prev_flush_failed;
+	void *shadow_buf;
 };
 
 static inline struct gud_device *to_gud_device(struct drm_device *drm)
diff --git a/drivers/gpu/drm/gud/gud_pipe.c b/drivers/gpu/drm/gud/gud_pipe.c
index 98fe8efda4a9..92189474a7ed 100644
--- a/drivers/gpu/drm/gud/gud_pipe.c
+++ b/drivers/gpu/drm/gud/gud_pipe.c
@@ -358,10 +358,10 @@ static void gud_flush_damage(struct gud_device *gdrm, struct drm_framebuffer *fb
 void gud_flush_work(struct work_struct *work)
 {
 	struct gud_device *gdrm = container_of(work, struct gud_device, work);
-	struct iosys_map gem_map = { }, fb_map = { };
+	struct iosys_map shadow_map;
 	struct drm_framebuffer *fb;
 	struct drm_rect damage;
-	int idx, ret;
+	int idx;
 
 	if (!drm_dev_enter(&gdrm->drm, &idx))
 		return;
@@ -369,6 +369,7 @@ void gud_flush_work(struct work_struct *work)
 	mutex_lock(&gdrm->damage_lock);
 	fb = gdrm->fb;
 	gdrm->fb = NULL;
+	iosys_map_set_vaddr(&shadow_map, gdrm->shadow_buf);
 	damage = gdrm->damage;
 	gud_clear_damage(gdrm);
 	mutex_unlock(&gdrm->damage_lock);
@@ -376,33 +377,33 @@ void gud_flush_work(struct work_struct *work)
 	if (!fb)
 		goto out;
 
-	ret = drm_gem_fb_vmap(fb, &gem_map, &fb_map);
-	if (ret)
-		goto fb_put;
+	gud_flush_damage(gdrm, fb, &shadow_map, true, &damage);
 
-	ret = drm_gem_fb_begin_cpu_access(fb, DMA_FROM_DEVICE);
-	if (ret)
-		goto vunmap;
-
-	/* Imported buffers are assumed to be WriteCombined with uncached reads */
-	gud_flush_damage(gdrm, fb, &fb_map, !fb->obj[0]->import_attach, &damage);
-
-	drm_gem_fb_end_cpu_access(fb, DMA_FROM_DEVICE);
-vunmap:
-	drm_gem_fb_vunmap(fb, &gem_map);
-fb_put:
 	drm_framebuffer_put(fb);
 out:
 	drm_dev_exit(idx);
 }
 
-static void gud_fb_queue_damage(struct gud_device *gdrm, struct drm_framebuffer *fb,
-				struct drm_rect *damage)
+static int gud_fb_queue_damage(struct gud_device *gdrm, struct drm_framebuffer *fb,
+			       const struct iosys_map *src, struct drm_rect *damage)
 {
 	struct drm_framebuffer *old_fb = NULL;
+	struct iosys_map shadow_map;
 
 	mutex_lock(&gdrm->damage_lock);
 
+	if (!gdrm->shadow_buf) {
+		gdrm->shadow_buf = vzalloc(fb->pitches[0] * fb->height);
+		if (!gdrm->shadow_buf) {
+			mutex_unlock(&gdrm->damage_lock);
+			return -ENOMEM;
+		}
+	}
+
+	iosys_map_set_vaddr(&shadow_map, gdrm->shadow_buf);
+	iosys_map_incr(&shadow_map, drm_fb_clip_offset(fb->pitches[0], fb->format, damage));
+	drm_fb_memcpy(&shadow_map, fb->pitches, src, fb, damage);
+
 	if (fb != gdrm->fb) {
 		old_fb = gdrm->fb;
 		drm_framebuffer_get(fb);
@@ -420,6 +421,26 @@ static void gud_fb_queue_damage(struct gud_device *gdrm, struct drm_framebuffer
 
 	if (old_fb)
 		drm_framebuffer_put(old_fb);
+
+	return 0;
+}
+
+static void gud_fb_handle_damage(struct gud_device *gdrm, struct drm_framebuffer *fb,
+				 const struct iosys_map *src, struct drm_rect *damage)
+{
+	int ret;
+
+	if (gdrm->flags & GUD_DISPLAY_FLAG_FULL_UPDATE)
+		drm_rect_init(damage, 0, 0, fb->width, fb->height);
+
+	if (gud_async_flush) {
+		ret = gud_fb_queue_damage(gdrm, fb, src, damage);
+		if (ret != -ENOMEM)
+			return;
+	}
+
+	/* Imported buffers are assumed to be WriteCombined with uncached reads */
+	gud_flush_damage(gdrm, fb, src, !fb->obj[0]->import_attach, damage);
 }
 
 int gud_pipe_check(struct drm_simple_display_pipe *pipe,
@@ -544,10 +565,11 @@ void gud_pipe_update(struct drm_simple_display_pipe *pipe,
 	struct drm_device *drm = pipe->crtc.dev;
 	struct gud_device *gdrm = to_gud_device(drm);
 	struct drm_plane_state *state = pipe->plane.state;
+	struct drm_shadow_plane_state *shadow_plane_state = to_drm_shadow_plane_state(state);
 	struct drm_framebuffer *fb = state->fb;
 	struct drm_crtc *crtc = &pipe->crtc;
 	struct drm_rect damage;
-	int idx;
+	int ret, idx;
 
 	if (crtc->state->mode_changed || !crtc->state->enable) {
 		cancel_work_sync(&gdrm->work);
@@ -557,6 +579,8 @@ void gud_pipe_update(struct drm_simple_display_pipe *pipe,
 			gdrm->fb = NULL;
 		}
 		gud_clear_damage(gdrm);
+		vfree(gdrm->shadow_buf);
+		gdrm->shadow_buf = NULL;
 		mutex_unlock(&gdrm->damage_lock);
 	}
 
@@ -572,14 +596,19 @@ void gud_pipe_update(struct drm_simple_display_pipe *pipe,
 	if (crtc->state->active_changed)
 		gud_usb_set_u8(gdrm, GUD_REQ_SET_DISPLAY_ENABLE, crtc->state->active);
 
-	if (drm_atomic_helper_damage_merged(old_state, state, &damage)) {
-		if (gdrm->flags & GUD_DISPLAY_FLAG_FULL_UPDATE)
-			drm_rect_init(&damage, 0, 0, fb->width, fb->height);
-		gud_fb_queue_damage(gdrm, fb, &damage);
-		if (!gud_async_flush)
-			flush_work(&gdrm->work);
-	}
+	if (!fb)
+		goto ctrl_disable;
 
+	ret = drm_gem_fb_begin_cpu_access(fb, DMA_FROM_DEVICE);
+	if (ret)
+		goto ctrl_disable;
+
+	if (drm_atomic_helper_damage_merged(old_state, state, &damage))
+		gud_fb_handle_damage(gdrm, fb, &shadow_plane_state->data[0], &damage);
+
+	drm_gem_fb_end_cpu_access(fb, DMA_FROM_DEVICE);
+
+ctrl_disable:
 	if (!crtc->state->enable)
 		gud_usb_set_u8(gdrm, GUD_REQ_SET_CONTROLLER_ENABLE, 0);
 

-- 
2.34.1
