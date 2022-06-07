Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EED34541939
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:21:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359269AbiFGVTq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:19:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380801AbiFGVQ7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:16:59 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2FE8BCD;
        Tue,  7 Jun 2022 11:57:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 6ADA8CE244E;
        Tue,  7 Jun 2022 18:57:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A2FAC385A2;
        Tue,  7 Jun 2022 18:57:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654628256;
        bh=Zw30yPjlTPlfaapa3+ihpAdMgrOzSK6fcOqIb0v/d4M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XHTTnFE5jpg/xR+R3/o4aWG+Zfpha53uTMiVIvwPFSldSLj9FumRlUwZhSmhtEdlW
         UlL/8UscHMBK5NPT2sgiJFq/gkYO7L5B6a+DZEcPwddY9huaLMObLeCiVKssP8/UhQ
         BdOhKMBEbaWz0I9JQyiwf8fk45kR20BYb56icDOM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        Javier Martinez Canillas <javierm@redhat.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 263/879] drm/format-helper: Fix XRGB888 to monochrome conversion
Date:   Tue,  7 Jun 2022 18:56:21 +0200
Message-Id: <20220607165010.484832015@linuxfoundation.org>
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

[ Upstream commit 7392f2459eefcdab1d998af002d2b8b16fe4a2fd ]

The conversion functions drm_fb_xrgb8888_to_mono() and
drm_fb_gray8_to_mono_line() do not behave correctly when the
horizontal boundaries of the clip rectangle are not multiples of 8:
  a. When x1 % 8 != 0, the calculated pitch is not correct,
  b. When x2 % 8 != 0, the pixel data for the last byte is wrong.

Simplify the code and fix (a) by:
  1. Removing start_offset, and always storing the first pixel in the
     first bit of the monochrome destination buffer.
     Drivers that require the first pixel in a byte to be located at an
     x-coordinate that is a multiple of 8 can always align the clip
     rectangle before calling drm_fb_xrgb8888_to_mono().
     Note that:
       - The ssd130x driver does not need the alignment, as the
	 monochrome buffer is a temporary format,
       - The repaper driver always updates the full screen, so the clip
	 rectangle is always aligned.
  2. Passing the number of pixels to drm_fb_gray8_to_mono_line(),
     instead of the number of bytes, and the number of pixels in the
     last byte.

Fix (b) by explicitly setting the target bit, instead of always setting
bit 7 and shifting the value in each loop iteration.

Remove the bogus pitch check, which operates on bytes instead of pixels,
and triggers when e.g. flashing the cursor on a text console with a font
that is 8 pixels wide.

Drop the confusing comment about scanlines, as a pitch in bytes always
contains a multiple of 8 pixels.

While at it, use the drm_rect_height() helper instead of open-coding the
same operation.

Update the comments accordingly.

Fixes: bcf8b616deb87941 ("drm/format-helper: Add drm_fb_xrgb8888_to_mono_reversed()")
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Acked-by: Javier Martinez Canillas <javierm@redhat.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Javier Martinez Canillas <javierm@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220317081830.1211400-3-geert@linux-m68k.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_format_helper.c | 55 ++++++++++-------------------
 1 file changed, 18 insertions(+), 37 deletions(-)

diff --git a/drivers/gpu/drm/drm_format_helper.c b/drivers/gpu/drm/drm_format_helper.c
index 5d9d0c695845..e085f855a199 100644
--- a/drivers/gpu/drm/drm_format_helper.c
+++ b/drivers/gpu/drm/drm_format_helper.c
@@ -594,27 +594,16 @@ int drm_fb_blit_toio(void __iomem *dst, unsigned int dst_pitch, uint32_t dst_for
 }
 EXPORT_SYMBOL(drm_fb_blit_toio);
 
-static void drm_fb_gray8_to_mono_line(u8 *dst, const u8 *src, unsigned int pixels,
-				      unsigned int start_offset, unsigned int end_len)
-{
-	unsigned int xb, i;
-
-	for (xb = 0; xb < pixels; xb++) {
-		unsigned int start = 0, end = 8;
-		u8 byte = 0x00;
-
-		if (xb == 0 && start_offset)
-			start = start_offset;
 
-		if (xb == pixels - 1 && end_len)
-			end = end_len;
-
-		for (i = start; i < end; i++) {
-			unsigned int x = xb * 8 + i;
+static void drm_fb_gray8_to_mono_line(u8 *dst, const u8 *src, unsigned int pixels)
+{
+	while (pixels) {
+		unsigned int i, bits = min(pixels, 8U);
+		u8 byte = 0;
 
-			byte >>= 1;
-			if (src[x] >> 7)
-				byte |= BIT(7);
+		for (i = 0; i < bits; i++, pixels--) {
+			if (*src++ >= 128)
+				byte |= BIT(i);
 		}
 		*dst++ = byte;
 	}
@@ -634,16 +623,22 @@ static void drm_fb_gray8_to_mono_line(u8 *dst, const u8 *src, unsigned int pixel
  *
  * This function uses drm_fb_xrgb8888_to_gray8() to convert to grayscale and
  * then the result is converted from grayscale to monochrome.
+ *
+ * The first pixel (upper left corner of the clip rectangle) will be converted
+ * and copied to the first bit (LSB) in the first byte of the monochrome
+ * destination buffer.
+ * If the caller requires that the first pixel in a byte must be located at an
+ * x-coordinate that is a multiple of 8, then the caller must take care itself
+ * of supplying a suitable clip rectangle.
  */
 void drm_fb_xrgb8888_to_mono(void *dst, unsigned int dst_pitch, const void *vaddr,
 			     const struct drm_framebuffer *fb, const struct drm_rect *clip)
 {
 	unsigned int linepixels = drm_rect_width(clip);
-	unsigned int lines = clip->y2 - clip->y1;
+	unsigned int lines = drm_rect_height(clip);
 	unsigned int cpp = fb->format->cpp[0];
 	unsigned int len_src32 = linepixels * cpp;
 	struct drm_device *dev = fb->dev;
-	unsigned int start_offset, end_len;
 	unsigned int y;
 	u8 *mono = dst, *gray8;
 	u32 *src32;
@@ -652,14 +647,11 @@ void drm_fb_xrgb8888_to_mono(void *dst, unsigned int dst_pitch, const void *vadd
 		return;
 
 	/*
-	 * The mono destination buffer contains 1 bit per pixel and
-	 * destination scanlines have to be in multiple of 8 pixels.
+	 * The mono destination buffer contains 1 bit per pixel
 	 */
 	if (!dst_pitch)
 		dst_pitch = DIV_ROUND_UP(linepixels, 8);
 
-	drm_WARN_ONCE(dev, dst_pitch % 8 != 0, "dst_pitch is not a multiple of 8\n");
-
 	/*
 	 * The cma memory is write-combined so reads are uncached.
 	 * Speed up by fetching one line at a time.
@@ -677,22 +669,11 @@ void drm_fb_xrgb8888_to_mono(void *dst, unsigned int dst_pitch, const void *vadd
 
 	gray8 = (u8 *)src32 + len_src32;
 
-	/*
-	 * For damage handling, it is possible that only parts of the source
-	 * buffer is copied and this could lead to start and end pixels that
-	 * are not aligned to multiple of 8.
-	 *
-	 * Calculate if the start and end pixels are not aligned and set the
-	 * offsets for the mono line conversion function to adjust.
-	 */
-	start_offset = clip->x1 % 8;
-	end_len = clip->x2 % 8;
-
 	vaddr += clip_offset(clip, fb->pitches[0], cpp);
 	for (y = 0; y < lines; y++) {
 		src32 = memcpy(src32, vaddr, len_src32);
 		drm_fb_xrgb8888_to_gray8_line(gray8, src32, linepixels);
-		drm_fb_gray8_to_mono_line(mono, gray8, dst_pitch, start_offset, end_len);
+		drm_fb_gray8_to_mono_line(mono, gray8, linepixels);
 		vaddr += fb->pitches[0];
 		mono += dst_pitch;
 	}
-- 
2.35.1



