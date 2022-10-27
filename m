Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01A5960F4EB
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 12:26:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233598AbiJ0K0k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 06:26:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233264AbiJ0K0j (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 06:26:39 -0400
Received: from mail.marcansoft.com (marcansoft.com [212.63.210.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BFF01DF11;
        Thu, 27 Oct 2022 03:26:38 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: hector@marcansoft.com)
        by mail.marcansoft.com (Postfix) with ESMTPSA id B08D43FA55;
        Thu, 27 Oct 2022 10:26:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=marcan.st; s=default;
        t=1666866396; bh=KKrxP2gQfugnbdgrFfsdnmfgpdRdNRhYEj4LkB4xA3c=;
        h=From:To:Cc:Subject:Date;
        b=R3WNOOr5ZcSvaDxSk9IpeLlVjRQk2xLV/qR1/fVX1IDmzJsGbyIJ72u8P6E97GyfN
         14G2BKbUuoEYiZbWCyadCMv80/yD18SzSZbPtsXTxE6JrtWAAPZp1/NiO43vVIFv55
         Gbpp2ep1pAB1z9YgYnr016WN8zvTJDWSi5SZDM9LWmqGsRX/7TpkYAmdT4fk43NUj/
         4QM3J7RygdtpeTVuzWphXklNqfd2TZI3iZt16cNUYptT9gf5as5rxdcy5DKSNQRc9S
         htZa2G9kQDuAy7CWHK+F6kGGX5wR7mQc8JA1Q2p8PoEvwkPGLJj8ix6vITzPXb/kRC
         pGGVUHdwofEeQ==
From:   Hector Martin <marcan@marcan.st>
To:     Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        David Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Javier Martinez Canillas <javierm@redhat.com>
Cc:     Pekka Paalanen <pekka.paalanen@collabora.com>,
        dri-devel@lists.freedesktop.org, asahi@lists.linux.dev,
        linux-kernel@vger.kernel.org, Hector Martin <marcan@marcan.st>,
        stable@vger.kernel.org
Subject: [PATCH] drm/simpledrm: Only advertise formats that are supported
Date:   Thu, 27 Oct 2022 19:13:27 +0900
Message-Id: <20221027101327.16678-1-marcan@marcan.st>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Until now, simpledrm unconditionally advertised all formats that can be
supported natively as conversions. However, we don't actually have a
full conversion matrix of helpers. Although the list is arguably
provided to userspace in precedence order, userspace can pick something
out-of-order (and thus break when it shouldn't), or simply only support
a format that is unsupported (and thus think it can work, which results
in the appearance of a hang as FB blits fail later on, instead of the
initialization error you'd expect in this case).

Split up the format table into separate ones for each required subset,
and then pick one based on the native format. Also remove the
native<->conversion overlap check from the helper (which doesn't make
sense any more, since the native format is advertised anyway and this
way RGB565/RGB888 can share a format table), and instead print the same
message in simpledrm when the native format is not one for which we have
conversions at all.

This fixes a real user regression where the ?RGB2101010 support commit
started advertising it unconditionally where not supported, and KWin
decided to start to use it over the native format, but also the fixes
the spurious RGB565/RGB888 formats which have been wrongly
unconditionally advertised since the dawn of simpledrm.

Note: this patch is merged because splitting it into two patches, one
for the helper and one for simpledrm, would regress at the midpoint
regardless of the order. If simpledrm is changed first, that would break
working conversions to RGB565/RGB888 (since those share a table that
does not include the native formats). If the helper is changed first, it
would start spuriously advertising all conversion formats when the
native format doesn't have any supported conversions at all.

Acked-by: Pekka Paalanen <pekka.paalanen@collabora.com>
Fixes: 6ea966fca084 ("drm/simpledrm: Add [AX]RGB2101010 formats")
Fixes: 11e8f5fd223b ("drm: Add simpledrm driver")
Cc: stable@vger.kernel.org
Signed-off-by: Hector Martin <marcan@marcan.st>
---
 drivers/gpu/drm/drm_format_helper.c | 15 -------
 drivers/gpu/drm/tiny/simpledrm.c    | 62 +++++++++++++++++++++++++----
 2 files changed, 55 insertions(+), 22 deletions(-)

diff --git a/drivers/gpu/drm/drm_format_helper.c b/drivers/gpu/drm/drm_format_helper.c
index e2f76621453c..c60c13f3a872 100644
--- a/drivers/gpu/drm/drm_format_helper.c
+++ b/drivers/gpu/drm/drm_format_helper.c
@@ -864,20 +864,6 @@ size_t drm_fb_build_fourcc_list(struct drm_device *dev,
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
@@ -898,7 +884,6 @@ size_t drm_fb_build_fourcc_list(struct drm_device *dev,
 		++fourccs;
 	}
 
-out:
 	return fourccs - fourccs_out;
 }
 EXPORT_SYMBOL(drm_fb_build_fourcc_list);
diff --git a/drivers/gpu/drm/tiny/simpledrm.c b/drivers/gpu/drm/tiny/simpledrm.c
index 18489779fb8a..1257411f3d44 100644
--- a/drivers/gpu/drm/tiny/simpledrm.c
+++ b/drivers/gpu/drm/tiny/simpledrm.c
@@ -446,22 +446,48 @@ static int simpledrm_device_init_regulators(struct simpledrm_device *sdev)
  */
 
 /*
- * Support all formats of simplefb and maybe more; in order
- * of preference. The display's update function will do any
+ * Support the subset of formats that we have conversion helpers for,
+ * in order of preference. The display's update function will do any
  * conversion necessary.
  *
  * TODO: Add blit helpers for remaining formats and uncomment
  *       constants.
  */
-static const uint32_t simpledrm_primary_plane_formats[] = {
+
+/*
+ * Supported conversions to RGB565 and RGB888:
+ *   from [AX]RGB8888
+ */
+static const uint32_t simpledrm_primary_plane_formats_base[] = {
+	DRM_FORMAT_XRGB8888,
+	DRM_FORMAT_ARGB8888,
+};
+
+/*
+ * Supported conversions to [AX]RGB8888:
+ *   A/X variants (no-op)
+ *   from RGB565
+ *   from RGB888
+ */
+static const uint32_t simpledrm_primary_plane_formats_xrgb8888[] = {
 	DRM_FORMAT_XRGB8888,
 	DRM_FORMAT_ARGB8888,
+	DRM_FORMAT_RGB888,
 	DRM_FORMAT_RGB565,
 	//DRM_FORMAT_XRGB1555,
 	//DRM_FORMAT_ARGB1555,
-	DRM_FORMAT_RGB888,
+};
+
+/*
+ * Supported conversions to [AX]RGB2101010:
+ *   A/X variants (no-op)
+ *   from [AX]RGB8888
+ */
+static const uint32_t simpledrm_primary_plane_formats_xrgb2101010[] = {
 	DRM_FORMAT_XRGB2101010,
 	DRM_FORMAT_ARGB2101010,
+	DRM_FORMAT_XRGB8888,
+	DRM_FORMAT_ARGB8888,
 };
 
 static const uint64_t simpledrm_primary_plane_format_modifiers[] = {
@@ -642,7 +668,8 @@ static struct simpledrm_device *simpledrm_device_create(struct drm_driver *drv,
 	struct drm_encoder *encoder;
 	struct drm_connector *connector;
 	unsigned long max_width, max_height;
-	size_t nformats;
+	const uint32_t *conv_formats;
+	size_t conv_nformats, nformats;
 	int ret;
 
 	sdev = devm_drm_dev_alloc(&pdev->dev, drv, struct simpledrm_device, dev);
@@ -755,10 +782,31 @@ static struct simpledrm_device *simpledrm_device_create(struct drm_driver *drv,
 	dev->mode_config.funcs = &simpledrm_mode_config_funcs;
 
 	/* Primary plane */
+	switch (format->format) {
+	case DRM_FORMAT_RGB565:
+	case DRM_FORMAT_RGB888:
+		conv_formats = simpledrm_primary_plane_formats_base;
+		conv_nformats = ARRAY_SIZE(simpledrm_primary_plane_formats_base);
+		break;
+	case DRM_FORMAT_XRGB8888:
+	case DRM_FORMAT_ARGB8888:
+		conv_formats = simpledrm_primary_plane_formats_xrgb8888;
+		conv_nformats = ARRAY_SIZE(simpledrm_primary_plane_formats_xrgb8888);
+		break;
+	case DRM_FORMAT_XRGB2101010:
+	case DRM_FORMAT_ARGB2101010:
+		conv_formats = simpledrm_primary_plane_formats_xrgb2101010;
+		conv_nformats = ARRAY_SIZE(simpledrm_primary_plane_formats_xrgb2101010);
+		break;
+	default:
+		conv_formats = NULL;
+		conv_nformats = 0;
+		drm_warn(dev, "Format conversion helpers required to add extra formats.\n");
+		break;
+	}
 
 	nformats = drm_fb_build_fourcc_list(dev, &format->format, 1,
-					    simpledrm_primary_plane_formats,
-					    ARRAY_SIZE(simpledrm_primary_plane_formats),
+					    conv_formats, conv_nformats,
 					    sdev->formats, ARRAY_SIZE(sdev->formats));
 
 	primary_plane = &sdev->primary_plane;
-- 
2.35.1

