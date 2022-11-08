Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C13A6210BD
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 13:31:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233333AbiKHMbc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 07:31:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233528AbiKHMbb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 07:31:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7D0B12631
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 04:31:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4CD9FB81AAC
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 12:31:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95ED8C433B5;
        Tue,  8 Nov 2022 12:31:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667910686;
        bh=A/1wu0afObW5EgIGTquPdzsY3rFsfxO9+ZTiOednxRc=;
        h=Subject:To:Cc:From:Date:From;
        b=L9kfiln2kITYLsgj9Nu0u5EjMep0/3BbIsrUrCkG+GSRi/wMtPuguweSITEVU+erL
         OT47cmjYghIEJmnsk8KUGiKjByAiUxsHV6hsoBFvnXuAwc0S/bAGH70xFsMR3VziAL
         NH8OXfZ17zf1nZDpksepRcNnUrA0tuUroOA2yuU8=
Subject: FAILED: patch "[PATCH] drm/format-helper: Only advertise supported formats for" failed to apply to 6.0-stable tree
To:     marcan@marcan.st, pekka.paalanen@collabora.com, tzimmermann@suse.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 08 Nov 2022 13:31:23 +0100
Message-ID: <16679106837255@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 6.0-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

6fdaed8c7988 ("drm/format-helper: Only advertise supported formats for conversion")
4a85b0b51e21 ("drm/format-helper: Add drm_fb_build_fourcc_list() helper")
71bf55872cbe ("drm/format-helper: Provide drm_fb_blit()")
de40c281fe0b ("drm/simpledrm: Convert to atomic helpers")
c25b69604fc4 ("drm/simpledrm: Inline device-init helpers")
03d38605cee7 ("drm/simpledrm: Remove mem field from device structure")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 6fdaed8c79887680bc46cb0a51775bd7c8645528 Mon Sep 17 00:00:00 2001
From: Hector Martin <marcan@marcan.st>
Date: Thu, 27 Oct 2022 22:57:11 +0900
Subject: [PATCH] drm/format-helper: Only advertise supported formats for
 conversion

drm_fb_build_fourcc_list() currently returns all emulated formats
unconditionally as long as the native format is among them, even though
not all combinations have conversion helpers. Although the list is
arguably provided to userspace in precedence order, userspace can pick
something out-of-order (and thus break when it shouldn't), or simply
only support a format that is unsupported (and thus think it can work,
which results in the appearance of a hang as FB blits fail later on,
instead of the initialization error you'd expect in this case).

Add checks to filter the list of emulated formats to only those
supported for conversion to the native format. This presumes that there
is a single native format (only the first is checked, if there are
multiple). Refactoring this API to drop the native list or support it
properly (by returning the appropriate emulated->native mapping table)
is left for a future patch.

The simpledrm driver is left as-is with a full table of emulated
formats. This keeps all currently working conversions available and
drops all the broken ones (i.e. this a strict bugfix patch, adding no
new supported formats nor removing any actually working ones). In order
to avoid proliferation of emulated formats, future drivers should
advertise only XRGB8888 as the sole emulated format (since some
userspace assumes its presence).

This fixes a real user regression where the ?RGB2101010 support commit
started advertising it unconditionally where not supported, and KWin
decided to start to use it over the native format and broke, but also
the fixes the spurious RGB565/RGB888 formats which have been wrongly
unconditionally advertised since the dawn of simpledrm.

Fixes: 6ea966fca084 ("drm/simpledrm: Add [AX]RGB2101010 formats")
Fixes: 11e8f5fd223b ("drm: Add simpledrm driver")
Cc: stable@vger.kernel.org
Signed-off-by: Hector Martin <marcan@marcan.st>
Acked-by: Pekka Paalanen <pekka.paalanen@collabora.com>
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20221027135711.24425-1-marcan@marcan.st

diff --git a/drivers/gpu/drm/drm_format_helper.c b/drivers/gpu/drm/drm_format_helper.c
index e2f76621453c..3ee59bae9d2f 100644
--- a/drivers/gpu/drm/drm_format_helper.c
+++ b/drivers/gpu/drm/drm_format_helper.c
@@ -807,6 +807,38 @@ static bool is_listed_fourcc(const uint32_t *fourccs, size_t nfourccs, uint32_t
 	return false;
 }
 
+static const uint32_t conv_from_xrgb8888[] = {
+	DRM_FORMAT_XRGB8888,
+	DRM_FORMAT_ARGB8888,
+	DRM_FORMAT_XRGB2101010,
+	DRM_FORMAT_ARGB2101010,
+	DRM_FORMAT_RGB565,
+	DRM_FORMAT_RGB888,
+};
+
+static const uint32_t conv_from_rgb565_888[] = {
+	DRM_FORMAT_XRGB8888,
+	DRM_FORMAT_ARGB8888,
+};
+
+static bool is_conversion_supported(uint32_t from, uint32_t to)
+{
+	switch (from) {
+	case DRM_FORMAT_XRGB8888:
+	case DRM_FORMAT_ARGB8888:
+		return is_listed_fourcc(conv_from_xrgb8888, ARRAY_SIZE(conv_from_xrgb8888), to);
+	case DRM_FORMAT_RGB565:
+	case DRM_FORMAT_RGB888:
+		return is_listed_fourcc(conv_from_rgb565_888, ARRAY_SIZE(conv_from_rgb565_888), to);
+	case DRM_FORMAT_XRGB2101010:
+		return to == DRM_FORMAT_ARGB2101010;
+	case DRM_FORMAT_ARGB2101010:
+		return to == DRM_FORMAT_XRGB2101010;
+	default:
+		return false;
+	}
+}
+
 /**
  * drm_fb_build_fourcc_list - Filters a list of supported color formats against
  *                            the device's native formats
@@ -827,7 +859,9 @@ static bool is_listed_fourcc(const uint32_t *fourccs, size_t nfourccs, uint32_t
  * be handed over to drm_universal_plane_init() et al. Native formats
  * will go before emulated formats. Other heuristics might be applied
  * to optimize the order. Formats near the beginning of the list are
- * usually preferred over formats near the end of the list.
+ * usually preferred over formats near the end of the list. Formats
+ * without conversion helpers will be skipped. New drivers should only
+ * pass in XRGB8888 and avoid exposing additional emulated formats.
  *
  * Returns:
  * The number of color-formats 4CC codes returned in @fourccs_out.
@@ -839,7 +873,7 @@ size_t drm_fb_build_fourcc_list(struct drm_device *dev,
 {
 	u32 *fourccs = fourccs_out;
 	const u32 *fourccs_end = fourccs_out + nfourccs_out;
-	bool found_native = false;
+	uint32_t native_format = 0;
 	size_t i;
 
 	/*
@@ -858,26 +892,18 @@ size_t drm_fb_build_fourcc_list(struct drm_device *dev,
 
 		drm_dbg_kms(dev, "adding native format %p4cc\n", &fourcc);
 
-		if (!found_native)
-			found_native = is_listed_fourcc(driver_fourccs, driver_nfourccs, fourcc);
+		/*
+		 * There should only be one native format with the current API.
+		 * This API needs to be refactored to correctly support arbitrary
+		 * sets of native formats, since it needs to report which native
+		 * format to use for each emulated format.
+		 */
+		if (!native_format)
+			native_format = fourcc;
 		*fourccs = fourcc;
 		++fourccs;
 	}
 
-	/*
-	 * The plane's atomic_update helper converts the framebuffer's color format
-	 * to a native format when copying to device memory.
-	 *
-	 * If there is not a single format supported by both, device and
-	 * driver, the native formats are likely not supported by the conversion
-	 * helpers. Therefore *only* support the native formats and add a
-	 * conversion helper ASAP.
-	 */
-	if (!found_native) {
-		drm_warn(dev, "Format conversion helpers required to add extra formats.\n");
-		goto out;
-	}
-
 	/*
 	 * The extra formats, emulated by the driver, go second.
 	 */
@@ -890,6 +916,9 @@ size_t drm_fb_build_fourcc_list(struct drm_device *dev,
 		} else if (fourccs == fourccs_end) {
 			drm_warn(dev, "Ignoring emulated format %p4cc\n", &fourcc);
 			continue; /* end of available output buffer */
+		} else if (!is_conversion_supported(fourcc, native_format)) {
+			drm_dbg_kms(dev, "Unsupported emulated format %p4cc\n", &fourcc);
+			continue; /* format is not supported for conversion */
 		}
 
 		drm_dbg_kms(dev, "adding emulated format %p4cc\n", &fourcc);
@@ -898,7 +927,6 @@ size_t drm_fb_build_fourcc_list(struct drm_device *dev,
 		++fourccs;
 	}
 
-out:
 	return fourccs - fourccs_out;
 }
 EXPORT_SYMBOL(drm_fb_build_fourcc_list);

