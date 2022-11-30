Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 669F063E0BE
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 20:27:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229685AbiK3T1E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 14:27:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229683AbiK3T1B (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 14:27:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAC268BD2E
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 11:26:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 81367B81CBB
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 19:26:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 23F40C43144;
        Wed, 30 Nov 2022 19:26:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669836417;
        bh=3nS4dre5mlIMeo+HJ3h8onuozCTP+nRaZHyqekOhLg4=;
        h=From:Date:Subject:References:In-Reply-To:To:Reply-To:From;
        b=AeHFIGsjoaSO1IlqBzOi8QKXI5zyRYek70jfOCB0mTZbOCAYNZW5Fg7XW5/q5RNhw
         xGdpXggqx50pb1xgghVChwg1HXV7QUjqHNe5Cj/cic9AmoK3q2NLPqjdkdPQrNFpld
         QERBLimRMtf+oVk4x+OXL/jrpID7n3akDgkqRNv99c7CGyO5G0VAub7ZsdxmqZfqt8
         E8USSbt5z4Q+/dJnpYxVyyUt1rB/OkdamArUPwQ6qBiSwOGkBI8HLAxL/zTf2DPARp
         RxQqQavl81S5EGEyX4kxfVIOOy1mWX1F1A50l7IOK7rhTSZZ3rsOq2xTbVLMbTDjdQ
         n47JKHzbtxzUA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.lore.kernel.org (Postfix) with ESMTP id 00D3AC352A1;
        Wed, 30 Nov 2022 19:26:57 +0000 (UTC)
From:   Noralf =?utf-8?q?Tr=C3=B8nnes?= via B4 Submission Endpoint 
        <devnull+noralf.tronnes.org@kernel.org>
Date:   Wed, 30 Nov 2022 20:26:51 +0100
Subject: [PATCH v2 3/6] drm/gud: Split up gud_flush_work()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20221122-gud-shadow-plane-v2-3-435037990a83@tronnes.org>
References: <20221122-gud-shadow-plane-v2-0-435037990a83@tronnes.org>
In-Reply-To: <20221122-gud-shadow-plane-v2-0-435037990a83@tronnes.org>
To:     Thomas Zimmermann <tzimmermann@suse.de>,
        Javier Martinez Canillas <javierm@redhat.com>,
        dri-devel@lists.freedesktop.org,
        Maxime Ripard <mripard@kernel.org>, stable@kernel.org,
        Noralf =?unknown-8bit?q?Tr=C3=B8nnes?= <noralf@tronnes.org>
X-Mailer: b4 0.11.0-dev-cc6f6
X-Developer-Signature: v=1; a=ed25519-sha256; t=1669836415; l=3363;
 i=noralf@tronnes.org; s=20221122; h=from:subject:message-id;
 bh=lCjGzAZ7bxM1S7qLvHQeXQGVjd0Bi+R8x1irdlf9+K4=; =?utf-8?q?b=3DnluNP2lX6N1D?=
 =?utf-8?q?8IYrI+Ot2A8Jv5nz5hR4qkTIatQN1EQj8cV3TpAztjUfYW1VPRyiCOVBXeqbTpQ5?=
 +b/9xNdVB/FTHfFAUsG5iFUN1wKeImtf/y6Y2AQhpBodcDtgmdmC
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

In preparation for inlining synchronous flushing split out the part of
gud_flush_work() that can be shared by the sync and async code paths.

Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Noralf Trønnes <noralf@tronnes.org>
---
 drivers/gpu/drm/gud/gud_pipe.c | 72 +++++++++++++++++++++++-------------------
 1 file changed, 39 insertions(+), 33 deletions(-)

diff --git a/drivers/gpu/drm/gud/gud_pipe.c b/drivers/gpu/drm/gud/gud_pipe.c
index ff1358815af5..d2af9947494f 100644
--- a/drivers/gpu/drm/gud/gud_pipe.c
+++ b/drivers/gpu/drm/gud/gud_pipe.c
@@ -333,15 +333,49 @@ void gud_clear_damage(struct gud_device *gdrm)
 	gdrm->damage.y2 = 0;
 }
 
+static void gud_flush_damage(struct gud_device *gdrm, struct drm_framebuffer *fb,
+			     struct drm_rect *damage)
+{
+	const struct drm_format_info *format;
+	unsigned int i, lines;
+	size_t pitch;
+	int ret;
+
+	format = fb->format;
+	if (format->format == DRM_FORMAT_XRGB8888 && gdrm->xrgb8888_emulation_format)
+		format = gdrm->xrgb8888_emulation_format;
+
+	/* Split update if it's too big */
+	pitch = drm_format_info_min_pitch(format, 0, drm_rect_width(damage));
+	lines = drm_rect_height(damage);
+
+	if (gdrm->bulk_len < lines * pitch)
+		lines = gdrm->bulk_len / pitch;
+
+	for (i = 0; i < DIV_ROUND_UP(drm_rect_height(damage), lines); i++) {
+		struct drm_rect rect = *damage;
+
+		rect.y1 += i * lines;
+		rect.y2 = min_t(u32, rect.y1 + lines, damage->y2);
+
+		ret = gud_flush_rect(gdrm, fb, format, &rect);
+		if (ret) {
+			if (ret != -ENODEV && ret != -ECONNRESET &&
+			    ret != -ESHUTDOWN && ret != -EPROTO)
+				dev_err_ratelimited(fb->dev->dev,
+						    "Failed to flush framebuffer: error=%d\n", ret);
+			gdrm->prev_flush_failed = true;
+			break;
+		}
+	}
+}
+
 void gud_flush_work(struct work_struct *work)
 {
 	struct gud_device *gdrm = container_of(work, struct gud_device, work);
-	const struct drm_format_info *format;
 	struct drm_framebuffer *fb;
 	struct drm_rect damage;
-	unsigned int i, lines;
-	int idx, ret = 0;
-	size_t pitch;
+	int idx;
 
 	if (!drm_dev_enter(&gdrm->drm, &idx))
 		return;
@@ -356,35 +390,7 @@ void gud_flush_work(struct work_struct *work)
 	if (!fb)
 		goto out;
 
-	format = fb->format;
-	if (format->format == DRM_FORMAT_XRGB8888 && gdrm->xrgb8888_emulation_format)
-		format = gdrm->xrgb8888_emulation_format;
-
-	/* Split update if it's too big */
-	pitch = drm_format_info_min_pitch(format, 0, drm_rect_width(&damage));
-	lines = drm_rect_height(&damage);
-
-	if (gdrm->bulk_len < lines * pitch)
-		lines = gdrm->bulk_len / pitch;
-
-	for (i = 0; i < DIV_ROUND_UP(drm_rect_height(&damage), lines); i++) {
-		struct drm_rect rect = damage;
-
-		rect.y1 += i * lines;
-		rect.y2 = min_t(u32, rect.y1 + lines, damage.y2);
-
-		ret = gud_flush_rect(gdrm, fb, format, &rect);
-		if (ret) {
-			if (ret != -ENODEV && ret != -ECONNRESET &&
-			    ret != -ESHUTDOWN && ret != -EPROTO)
-				dev_err_ratelimited(fb->dev->dev,
-						    "Failed to flush framebuffer: error=%d\n", ret);
-			gdrm->prev_flush_failed = true;
-			break;
-		}
-
-		gdrm->prev_flush_failed = false;
-	}
+	gud_flush_damage(gdrm, fb, &damage);
 
 	drm_framebuffer_put(fb);
 out:

-- 
2.34.1
