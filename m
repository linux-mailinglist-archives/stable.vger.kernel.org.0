Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC1F054197E
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:22:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378708AbiFGVWX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:22:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380799AbiFGVQ7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:16:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A2192F01F;
        Tue,  7 Jun 2022 11:57:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 26B4DB8220B;
        Tue,  7 Jun 2022 18:57:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C495C385A2;
        Tue,  7 Jun 2022 18:57:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654628253;
        bh=CRQd8H8OiZSbsXXyPamobgycEaXOZlhITQlHQDMZtZw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CIkaZmAfHz/8Ia2J2wWrWz6yhFCDFZYG3NQVWVJ5bPBOYUPboC63vrEJzpSoWzkZl
         weSGscblg3+/LyOeILcjBw8P4swGjtnezDfmu4qPWb8yWo5v68L4nSE3CEMm+fthHh
         5DJTjnVVA/XvLSGpHzaxoy0K7lIAH8RjbpzJZYPo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        Javier Martinez Canillas <javierm@redhat.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 262/879] drm/format-helper: Rename drm_fb_xrgb8888_to_mono_reversed()
Date:   Tue,  7 Jun 2022 18:56:20 +0200
Message-Id: <20220607165010.455227491@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>

[ Upstream commit 9b13a3fcd35fc24045d2fd0f0e13ddd8d7985b4b ]

There is no "reversed" handling in drm_fb_xrgb8888_to_mono_reversed():
the function just converts from color to grayscale, and reduces the
number of grayscale levels from 256 to 2 (i.e. brightness 0-127 is
mapped to 0, 128-255 to 1).  All "reversed" handling is done in the
repaper driver, where this function originated.

Hence make this clear by renaming drm_fb_xrgb8888_to_mono_reversed() to
drm_fb_xrgb8888_to_mono(), and documenting the black/white pixel
mapping.

Fixes: bcf8b616deb87941 ("drm/format-helper: Add drm_fb_xrgb8888_to_mono_reversed()")
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Acked-by: Javier Martinez Canillas <javierm@redhat.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Javier Martinez Canillas <javierm@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220317081830.1211400-2-geert@linux-m68k.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_format_helper.c | 31 ++++++++++++++---------------
 drivers/gpu/drm/solomon/ssd130x.c   |  2 +-
 drivers/gpu/drm/tiny/repaper.c      |  2 +-
 include/drm/drm_format_helper.h     |  5 ++---
 4 files changed, 19 insertions(+), 21 deletions(-)

diff --git a/drivers/gpu/drm/drm_format_helper.c b/drivers/gpu/drm/drm_format_helper.c
index bc0f49773868..5d9d0c695845 100644
--- a/drivers/gpu/drm/drm_format_helper.c
+++ b/drivers/gpu/drm/drm_format_helper.c
@@ -594,8 +594,8 @@ int drm_fb_blit_toio(void __iomem *dst, unsigned int dst_pitch, uint32_t dst_for
 }
 EXPORT_SYMBOL(drm_fb_blit_toio);
 
-static void drm_fb_gray8_to_mono_reversed_line(u8 *dst, const u8 *src, unsigned int pixels,
-					       unsigned int start_offset, unsigned int end_len)
+static void drm_fb_gray8_to_mono_line(u8 *dst, const u8 *src, unsigned int pixels,
+				      unsigned int start_offset, unsigned int end_len)
 {
 	unsigned int xb, i;
 
@@ -621,8 +621,8 @@ static void drm_fb_gray8_to_mono_reversed_line(u8 *dst, const u8 *src, unsigned
 }
 
 /**
- * drm_fb_xrgb8888_to_mono_reversed - Convert XRGB8888 to reversed monochrome
- * @dst: reversed monochrome destination buffer
+ * drm_fb_xrgb8888_to_mono - Convert XRGB8888 to monochrome
+ * @dst: monochrome destination buffer (0=black, 1=white)
  * @dst_pitch: Number of bytes between two consecutive scanlines within dst
  * @src: XRGB8888 source buffer
  * @fb: DRM framebuffer
@@ -633,10 +633,10 @@ static void drm_fb_gray8_to_mono_reversed_line(u8 *dst, const u8 *src, unsigned
  * and use this function to convert to the native format.
  *
  * This function uses drm_fb_xrgb8888_to_gray8() to convert to grayscale and
- * then the result is converted from grayscale to reversed monohrome.
+ * then the result is converted from grayscale to monochrome.
  */
-void drm_fb_xrgb8888_to_mono_reversed(void *dst, unsigned int dst_pitch, const void *vaddr,
-				      const struct drm_framebuffer *fb, const struct drm_rect *clip)
+void drm_fb_xrgb8888_to_mono(void *dst, unsigned int dst_pitch, const void *vaddr,
+			     const struct drm_framebuffer *fb, const struct drm_rect *clip)
 {
 	unsigned int linepixels = drm_rect_width(clip);
 	unsigned int lines = clip->y2 - clip->y1;
@@ -652,8 +652,8 @@ void drm_fb_xrgb8888_to_mono_reversed(void *dst, unsigned int dst_pitch, const v
 		return;
 
 	/*
-	 * The reversed mono destination buffer contains 1 bit per pixel
-	 * and destination scanlines have to be in multiple of 8 pixels.
+	 * The mono destination buffer contains 1 bit per pixel and
+	 * destination scanlines have to be in multiple of 8 pixels.
 	 */
 	if (!dst_pitch)
 		dst_pitch = DIV_ROUND_UP(linepixels, 8);
@@ -664,9 +664,9 @@ void drm_fb_xrgb8888_to_mono_reversed(void *dst, unsigned int dst_pitch, const v
 	 * The cma memory is write-combined so reads are uncached.
 	 * Speed up by fetching one line at a time.
 	 *
-	 * Also, format conversion from XR24 to reversed monochrome
-	 * are done line-by-line but are converted to 8-bit grayscale
-	 * as an intermediate step.
+	 * Also, format conversion from XR24 to monochrome are done
+	 * line-by-line but are converted to 8-bit grayscale as an
+	 * intermediate step.
 	 *
 	 * Allocate a buffer to be used for both copying from the cma
 	 * memory and to store the intermediate grayscale line pixels.
@@ -683,7 +683,7 @@ void drm_fb_xrgb8888_to_mono_reversed(void *dst, unsigned int dst_pitch, const v
 	 * are not aligned to multiple of 8.
 	 *
 	 * Calculate if the start and end pixels are not aligned and set the
-	 * offsets for the reversed mono line conversion function to adjust.
+	 * offsets for the mono line conversion function to adjust.
 	 */
 	start_offset = clip->x1 % 8;
 	end_len = clip->x2 % 8;
@@ -692,12 +692,11 @@ void drm_fb_xrgb8888_to_mono_reversed(void *dst, unsigned int dst_pitch, const v
 	for (y = 0; y < lines; y++) {
 		src32 = memcpy(src32, vaddr, len_src32);
 		drm_fb_xrgb8888_to_gray8_line(gray8, src32, linepixels);
-		drm_fb_gray8_to_mono_reversed_line(mono, gray8, dst_pitch,
-						   start_offset, end_len);
+		drm_fb_gray8_to_mono_line(mono, gray8, dst_pitch, start_offset, end_len);
 		vaddr += fb->pitches[0];
 		mono += dst_pitch;
 	}
 
 	kfree(src32);
 }
-EXPORT_SYMBOL(drm_fb_xrgb8888_to_mono_reversed);
+EXPORT_SYMBOL(drm_fb_xrgb8888_to_mono);
diff --git a/drivers/gpu/drm/solomon/ssd130x.c b/drivers/gpu/drm/solomon/ssd130x.c
index d08d86ef07bc..caee851efd57 100644
--- a/drivers/gpu/drm/solomon/ssd130x.c
+++ b/drivers/gpu/drm/solomon/ssd130x.c
@@ -458,7 +458,7 @@ static int ssd130x_fb_blit_rect(struct drm_framebuffer *fb, const struct iosys_m
 	if (!buf)
 		return -ENOMEM;
 
-	drm_fb_xrgb8888_to_mono_reversed(buf, 0, vmap, fb, rect);
+	drm_fb_xrgb8888_to_mono(buf, 0, vmap, fb, rect);
 
 	ssd130x_update_rect(ssd130x, buf, rect);
 
diff --git a/drivers/gpu/drm/tiny/repaper.c b/drivers/gpu/drm/tiny/repaper.c
index 37b6bb90e46e..a096fb8b83e9 100644
--- a/drivers/gpu/drm/tiny/repaper.c
+++ b/drivers/gpu/drm/tiny/repaper.c
@@ -540,7 +540,7 @@ static int repaper_fb_dirty(struct drm_framebuffer *fb)
 	if (ret)
 		goto out_free;
 
-	drm_fb_xrgb8888_to_mono_reversed(buf, 0, cma_obj->vaddr, fb, &clip);
+	drm_fb_xrgb8888_to_mono(buf, 0, cma_obj->vaddr, fb, &clip);
 
 	drm_gem_fb_end_cpu_access(fb, DMA_FROM_DEVICE);
 
diff --git a/include/drm/drm_format_helper.h b/include/drm/drm_format_helper.h
index 0b0937c0b2f6..55145eca0782 100644
--- a/include/drm/drm_format_helper.h
+++ b/include/drm/drm_format_helper.h
@@ -43,8 +43,7 @@ int drm_fb_blit_toio(void __iomem *dst, unsigned int dst_pitch, uint32_t dst_for
 		     const void *vmap, const struct drm_framebuffer *fb,
 		     const struct drm_rect *rect);
 
-void drm_fb_xrgb8888_to_mono_reversed(void *dst, unsigned int dst_pitch, const void *src,
-				      const struct drm_framebuffer *fb,
-				      const struct drm_rect *clip);
+void drm_fb_xrgb8888_to_mono(void *dst, unsigned int dst_pitch, const void *src,
+			     const struct drm_framebuffer *fb, const struct drm_rect *clip);
 
 #endif /* __LINUX_DRM_FORMAT_HELPER_H */
-- 
2.35.1



