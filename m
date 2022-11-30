Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B923163E0BF
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 20:27:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229727AbiK3T1F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 14:27:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229688AbiK3T1B (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 14:27:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5C2A900C0
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 11:26:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 751D3B81B46
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 19:26:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2F421C43470;
        Wed, 30 Nov 2022 19:26:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669836417;
        bh=VT6S6Uogfk7RNUiwZ9Q97/o2HT2hd6rFuUpz2QmHG8s=;
        h=From:Date:Subject:References:In-Reply-To:To:Reply-To:From;
        b=AAdYVt/Iif4U/+K6daJIfMTAR7d0xC/Txb/O6g4ZPepikLC3sbWLe2ZyPwzJHc8DI
         U28odBcIBY1wPoZBsbGhTh8GmdIwoIEd0YlyNnuuEAcy0hFBmTjr5ZifFVHwLVoCxj
         1/YlasRa4M4Itm2x38VHschmBEFO1hXyBbS7vJ62Hkd648GSNRF2NGhGBQ6plB3Scb
         v0QPEYRyNgiRO/sB13wqYtfg3trzJ8pd+pvKFHKSs4ZpToP8DcU+KXhm0c8qzlijlo
         d/rJ8V2+GoUq60KwR8o3TEvvlg8qss4qjWlt9JHG6qUfzkHpu7TciRj7Sm00fyEs/q
         /I31e26ZcJqow==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.lore.kernel.org (Postfix) with ESMTP id 17181C4708D;
        Wed, 30 Nov 2022 19:26:57 +0000 (UTC)
From:   Noralf =?utf-8?q?Tr=C3=B8nnes?= via B4 Submission Endpoint 
        <devnull+noralf.tronnes.org@kernel.org>
Date:   Wed, 30 Nov 2022 20:26:52 +0100
Subject: [PATCH v2 4/6] drm/gud: Prepare buffer for CPU access in gud_flush_work()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20221122-gud-shadow-plane-v2-4-435037990a83@tronnes.org>
References: <20221122-gud-shadow-plane-v2-0-435037990a83@tronnes.org>
In-Reply-To: <20221122-gud-shadow-plane-v2-0-435037990a83@tronnes.org>
To:     Thomas Zimmermann <tzimmermann@suse.de>,
        Javier Martinez Canillas <javierm@redhat.com>,
        dri-devel@lists.freedesktop.org,
        Maxime Ripard <mripard@kernel.org>, stable@kernel.org,
        Noralf =?unknown-8bit?q?Tr=C3=B8nnes?= <noralf@tronnes.org>
X-Mailer: b4 0.11.0-dev-cc6f6
X-Developer-Signature: v=1; a=ed25519-sha256; t=1669836415; l=6541;
 i=noralf@tronnes.org; s=20221122; h=from:subject:message-id;
 bh=7SR2RwZ9rOUZS8XzmXQ/m4YPEgzaHqtijAD+lUqFhPA=; =?utf-8?q?b=3DhxQus1xtft5b?=
 =?utf-8?q?87Fu328Z3xlaV1HqaU7hYD/HqegA26Md0F0RqMC4Xp5/MUFSwXgKOE9QlhpQRfuf?=
 Lhox5hTHDrriRQ2WHWJ1F365fv/L8IPqZ2pkGkXKzI0CTdNdMvrD
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

In preparation for moving to the shadow plane helper prepare the
framebuffer for CPU access as early as possible.

v2:
- Use src as variable name for iosys_map (Thomas)

Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Signed-off-by: Noralf Trønnes <noralf@tronnes.org>
---
 drivers/gpu/drm/gud/gud_pipe.c | 67 +++++++++++++++++++++---------------------
 1 file changed, 33 insertions(+), 34 deletions(-)

diff --git a/drivers/gpu/drm/gud/gud_pipe.c b/drivers/gpu/drm/gud/gud_pipe.c
index d2af9947494f..98fe8efda4a9 100644
--- a/drivers/gpu/drm/gud/gud_pipe.c
+++ b/drivers/gpu/drm/gud/gud_pipe.c
@@ -15,6 +15,7 @@
 #include <drm/drm_fourcc.h>
 #include <drm/drm_framebuffer.h>
 #include <drm/drm_gem.h>
+#include <drm/drm_gem_atomic_helper.h>
 #include <drm/drm_gem_framebuffer_helper.h>
 #include <drm/drm_print.h>
 #include <drm/drm_rect.h>
@@ -152,32 +153,21 @@ static size_t gud_xrgb8888_to_color(u8 *dst, const struct drm_format_info *forma
 }
 
 static int gud_prep_flush(struct gud_device *gdrm, struct drm_framebuffer *fb,
+			  const struct iosys_map *src, bool cached_reads,
 			  const struct drm_format_info *format, struct drm_rect *rect,
 			  struct gud_set_buffer_req *req)
 {
-	struct dma_buf_attachment *import_attach = fb->obj[0]->import_attach;
 	u8 compression = gdrm->compression;
-	struct iosys_map map[DRM_FORMAT_MAX_PLANES] = { };
-	struct iosys_map map_data[DRM_FORMAT_MAX_PLANES] = { };
 	struct iosys_map dst;
 	void *vaddr, *buf;
 	size_t pitch, len;
-	int ret = 0;
 
 	pitch = drm_format_info_min_pitch(format, 0, drm_rect_width(rect));
 	len = pitch * drm_rect_height(rect);
 	if (len > gdrm->bulk_len)
 		return -E2BIG;
 
-	ret = drm_gem_fb_vmap(fb, map, map_data);
-	if (ret)
-		return ret;
-
-	vaddr = map_data[0].vaddr;
-
-	ret = drm_gem_fb_begin_cpu_access(fb, DMA_FROM_DEVICE);
-	if (ret)
-		goto vunmap;
+	vaddr = src[0].vaddr;
 retry:
 	if (compression)
 		buf = gdrm->compress_buf;
@@ -192,29 +182,27 @@ static int gud_prep_flush(struct gud_device *gdrm, struct drm_framebuffer *fb,
 	if (format != fb->format) {
 		if (format->format == GUD_DRM_FORMAT_R1) {
 			len = gud_xrgb8888_to_r124(buf, format, vaddr, fb, rect);
-			if (!len) {
-				ret = -ENOMEM;
-				goto end_cpu_access;
-			}
+			if (!len)
+				return -ENOMEM;
 		} else if (format->format == DRM_FORMAT_R8) {
-			drm_fb_xrgb8888_to_gray8(&dst, NULL, map_data, fb, rect);
+			drm_fb_xrgb8888_to_gray8(&dst, NULL, src, fb, rect);
 		} else if (format->format == DRM_FORMAT_RGB332) {
-			drm_fb_xrgb8888_to_rgb332(&dst, NULL, map_data, fb, rect);
+			drm_fb_xrgb8888_to_rgb332(&dst, NULL, src, fb, rect);
 		} else if (format->format == DRM_FORMAT_RGB565) {
-			drm_fb_xrgb8888_to_rgb565(&dst, NULL, map_data, fb, rect,
+			drm_fb_xrgb8888_to_rgb565(&dst, NULL, src, fb, rect,
 						  gud_is_big_endian());
 		} else if (format->format == DRM_FORMAT_RGB888) {
-			drm_fb_xrgb8888_to_rgb888(&dst, NULL, map_data, fb, rect);
+			drm_fb_xrgb8888_to_rgb888(&dst, NULL, src, fb, rect);
 		} else {
 			len = gud_xrgb8888_to_color(buf, format, vaddr, fb, rect);
 		}
 	} else if (gud_is_big_endian() && format->cpp[0] > 1) {
-		drm_fb_swab(&dst, NULL, map_data, fb, rect, !import_attach);
-	} else if (compression && !import_attach && pitch == fb->pitches[0]) {
+		drm_fb_swab(&dst, NULL, src, fb, rect, cached_reads);
+	} else if (compression && cached_reads && pitch == fb->pitches[0]) {
 		/* can compress directly from the framebuffer */
 		buf = vaddr + rect->y1 * pitch;
 	} else {
-		drm_fb_memcpy(&dst, NULL, map_data, fb, rect);
+		drm_fb_memcpy(&dst, NULL, src, fb, rect);
 	}
 
 	memset(req, 0, sizeof(*req));
@@ -237,12 +225,7 @@ static int gud_prep_flush(struct gud_device *gdrm, struct drm_framebuffer *fb,
 		req->compressed_length = cpu_to_le32(complen);
 	}
 
-end_cpu_access:
-	drm_gem_fb_end_cpu_access(fb, DMA_FROM_DEVICE);
-vunmap:
-	drm_gem_fb_vunmap(fb, map);
-
-	return ret;
+	return 0;
 }
 
 struct gud_usb_bulk_context {
@@ -285,6 +268,7 @@ static int gud_usb_bulk(struct gud_device *gdrm, size_t len)
 }
 
 static int gud_flush_rect(struct gud_device *gdrm, struct drm_framebuffer *fb,
+			  const struct iosys_map *src, bool cached_reads,
 			  const struct drm_format_info *format, struct drm_rect *rect)
 {
 	struct gud_set_buffer_req req;
@@ -293,7 +277,7 @@ static int gud_flush_rect(struct gud_device *gdrm, struct drm_framebuffer *fb,
 
 	drm_dbg(&gdrm->drm, "Flushing [FB:%d] " DRM_RECT_FMT "\n", fb->base.id, DRM_RECT_ARG(rect));
 
-	ret = gud_prep_flush(gdrm, fb, format, rect, &req);
+	ret = gud_prep_flush(gdrm, fb, src, cached_reads, format, rect, &req);
 	if (ret)
 		return ret;
 
@@ -334,6 +318,7 @@ void gud_clear_damage(struct gud_device *gdrm)
 }
 
 static void gud_flush_damage(struct gud_device *gdrm, struct drm_framebuffer *fb,
+			     const struct iosys_map *src, bool cached_reads,
 			     struct drm_rect *damage)
 {
 	const struct drm_format_info *format;
@@ -358,7 +343,7 @@ static void gud_flush_damage(struct gud_device *gdrm, struct drm_framebuffer *fb
 		rect.y1 += i * lines;
 		rect.y2 = min_t(u32, rect.y1 + lines, damage->y2);
 
-		ret = gud_flush_rect(gdrm, fb, format, &rect);
+		ret = gud_flush_rect(gdrm, fb, src, cached_reads, format, &rect);
 		if (ret) {
 			if (ret != -ENODEV && ret != -ECONNRESET &&
 			    ret != -ESHUTDOWN && ret != -EPROTO)
@@ -373,9 +358,10 @@ static void gud_flush_damage(struct gud_device *gdrm, struct drm_framebuffer *fb
 void gud_flush_work(struct work_struct *work)
 {
 	struct gud_device *gdrm = container_of(work, struct gud_device, work);
+	struct iosys_map gem_map = { }, fb_map = { };
 	struct drm_framebuffer *fb;
 	struct drm_rect damage;
-	int idx;
+	int idx, ret;
 
 	if (!drm_dev_enter(&gdrm->drm, &idx))
 		return;
@@ -390,8 +376,21 @@ void gud_flush_work(struct work_struct *work)
 	if (!fb)
 		goto out;
 
-	gud_flush_damage(gdrm, fb, &damage);
+	ret = drm_gem_fb_vmap(fb, &gem_map, &fb_map);
+	if (ret)
+		goto fb_put;
 
+	ret = drm_gem_fb_begin_cpu_access(fb, DMA_FROM_DEVICE);
+	if (ret)
+		goto vunmap;
+
+	/* Imported buffers are assumed to be WriteCombined with uncached reads */
+	gud_flush_damage(gdrm, fb, &fb_map, !fb->obj[0]->import_attach, &damage);
+
+	drm_gem_fb_end_cpu_access(fb, DMA_FROM_DEVICE);
+vunmap:
+	drm_gem_fb_vunmap(fb, &gem_map);
+fb_put:
 	drm_framebuffer_put(fb);
 out:
 	drm_dev_exit(idx);

-- 
2.34.1
