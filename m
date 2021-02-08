Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FD743137CB
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:32:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233759AbhBHPbW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:31:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:36416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233658AbhBHP1S (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:27:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1057364F01;
        Mon,  8 Feb 2021 15:15:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612797360;
        bh=GFssSyUN2PvJjkH4ur0OOxZiYVHD8lAWusw3x1KwDYU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XquB/Qjuyc+9NPNb0/XMvtQElv0nc3Tdk2GkFF0wXJ4FfFXkpLfedlg1RSiGxU44j
         GTbzsIfHWI+1bfiQpRlA586yrzNOhO7NtzJ0HGn/dc39tmQ8i4KJfI376T2rz1aA2u
         MSCVfJcfNgJuU1SfvtinNRnoJkv1fpdMwTPxgMDg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andres Calderon Jaramillo <andrescj@chromium.org>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 5.10 082/120] drm/i915/display: Prevent double YUV range correction on HDR planes
Date:   Mon,  8 Feb 2021 16:01:09 +0100
Message-Id: <20210208145821.665996514@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210208145818.395353822@linuxfoundation.org>
References: <20210208145818.395353822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andres Calderon Jaramillo <andrescj@chromium.org>

commit 00f9a08fbc3c703b71842a5425c1eb82053c8a70 upstream.

Prevent the ICL HDR plane pipeline from performing YUV color range
correction twice when the input is in limited range. This is done by
removing the limited-range code from icl_program_input_csc().

Before this patch the following could happen: user space gives us a YUV
buffer in limited range; per the pipeline in [1], the plane would first
go through a "YUV Range correct" stage that expands the range; the plane
would then go through the "Input CSC" stage which would also expand the
range because icl_program_input_csc() would use a matrix and an offset
that assume limited-range input; this would ultimately cause dark and
light colors to appear darker and lighter than they should respectively.

This is an issue because if a buffer switches between being scanned out
and being composited with the GPU, the user will see a color difference.
If this switching happens quickly and frequently, the user will perceive
this as a flickering.

[1] https://01.org/sites/default/files/documentation/intel-gfx-prm-osrc-icllp-vol12-displayengine_0.pdf#page=281

Cc: stable@vger.kernel.org
Signed-off-by: Andres Calderon Jaramillo <andrescj@chromium.org>
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20201215224219.3896256-1-andrescj@google.com
(cherry picked from commit fed387572040e84ead53852a7820e30a30e515d0)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210202084553.30691-1-ville.syrjala@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_display.c |    2 
 drivers/gpu/drm/i915/display/intel_sprite.c  |   65 ++++-----------------------
 2 files changed, 12 insertions(+), 55 deletions(-)

--- a/drivers/gpu/drm/i915/display/intel_display.c
+++ b/drivers/gpu/drm/i915/display/intel_display.c
@@ -4880,6 +4880,8 @@ u32 glk_plane_color_ctl(const struct int
 			plane_color_ctl |= PLANE_COLOR_YUV_RANGE_CORRECTION_DISABLE;
 	} else if (fb->format->is_yuv) {
 		plane_color_ctl |= PLANE_COLOR_INPUT_CSC_ENABLE;
+		if (plane_state->hw.color_range == DRM_COLOR_YCBCR_FULL_RANGE)
+			plane_color_ctl |= PLANE_COLOR_YUV_RANGE_CORRECTION_DISABLE;
 	}
 
 	return plane_color_ctl;
--- a/drivers/gpu/drm/i915/display/intel_sprite.c
+++ b/drivers/gpu/drm/i915/display/intel_sprite.c
@@ -469,13 +469,19 @@ skl_program_scaler(struct intel_plane *p
 
 /* Preoffset values for YUV to RGB Conversion */
 #define PREOFF_YUV_TO_RGB_HI		0x1800
-#define PREOFF_YUV_TO_RGB_ME		0x1F00
+#define PREOFF_YUV_TO_RGB_ME		0x0000
 #define PREOFF_YUV_TO_RGB_LO		0x1800
 
 #define  ROFF(x)          (((x) & 0xffff) << 16)
 #define  GOFF(x)          (((x) & 0xffff) << 0)
 #define  BOFF(x)          (((x) & 0xffff) << 16)
 
+/*
+ * Programs the input color space conversion stage for ICL HDR planes.
+ * Note that it is assumed that this stage always happens after YUV
+ * range correction. Thus, the input to this stage is assumed to be
+ * in full-range YCbCr.
+ */
 static void
 icl_program_input_csc(struct intel_plane *plane,
 		      const struct intel_crtc_state *crtc_state,
@@ -523,52 +529,7 @@ icl_program_input_csc(struct intel_plane
 			0x0, 0x7800, 0x7F10,
 		},
 	};
-
-	/* Matrix for Limited Range to Full Range Conversion */
-	static const u16 input_csc_matrix_lr[][9] = {
-		/*
-		 * BT.601 Limted range YCbCr -> full range RGB
-		 * The matrix required is :
-		 * [1.164384, 0.000, 1.596027,
-		 *  1.164384, -0.39175, -0.812813,
-		 *  1.164384, 2.017232, 0.0000]
-		 */
-		[DRM_COLOR_YCBCR_BT601] = {
-			0x7CC8, 0x7950, 0x0,
-			0x8D00, 0x7950, 0x9C88,
-			0x0, 0x7950, 0x6810,
-		},
-		/*
-		 * BT.709 Limited range YCbCr -> full range RGB
-		 * The matrix required is :
-		 * [1.164384, 0.000, 1.792741,
-		 *  1.164384, -0.213249, -0.532909,
-		 *  1.164384, 2.112402, 0.0000]
-		 */
-		[DRM_COLOR_YCBCR_BT709] = {
-			0x7E58, 0x7950, 0x0,
-			0x8888, 0x7950, 0xADA8,
-			0x0, 0x7950,  0x6870,
-		},
-		/*
-		 * BT.2020 Limited range YCbCr -> full range RGB
-		 * The matrix required is :
-		 * [1.164, 0.000, 1.678,
-		 *  1.164, -0.1873, -0.6504,
-		 *  1.164, 2.1417, 0.0000]
-		 */
-		[DRM_COLOR_YCBCR_BT2020] = {
-			0x7D70, 0x7950, 0x0,
-			0x8A68, 0x7950, 0xAC00,
-			0x0, 0x7950, 0x6890,
-		},
-	};
-	const u16 *csc;
-
-	if (plane_state->hw.color_range == DRM_COLOR_YCBCR_FULL_RANGE)
-		csc = input_csc_matrix[plane_state->hw.color_encoding];
-	else
-		csc = input_csc_matrix_lr[plane_state->hw.color_encoding];
+	const u16 *csc = input_csc_matrix[plane_state->hw.color_encoding];
 
 	intel_de_write_fw(dev_priv, PLANE_INPUT_CSC_COEFF(pipe, plane_id, 0),
 			  ROFF(csc[0]) | GOFF(csc[1]));
@@ -585,14 +546,8 @@ icl_program_input_csc(struct intel_plane
 
 	intel_de_write_fw(dev_priv, PLANE_INPUT_CSC_PREOFF(pipe, plane_id, 0),
 			  PREOFF_YUV_TO_RGB_HI);
-	if (plane_state->hw.color_range == DRM_COLOR_YCBCR_FULL_RANGE)
-		intel_de_write_fw(dev_priv,
-				  PLANE_INPUT_CSC_PREOFF(pipe, plane_id, 1),
-				  0);
-	else
-		intel_de_write_fw(dev_priv,
-				  PLANE_INPUT_CSC_PREOFF(pipe, plane_id, 1),
-				  PREOFF_YUV_TO_RGB_ME);
+	intel_de_write_fw(dev_priv, PLANE_INPUT_CSC_PREOFF(pipe, plane_id, 1),
+			  PREOFF_YUV_TO_RGB_ME);
 	intel_de_write_fw(dev_priv, PLANE_INPUT_CSC_PREOFF(pipe, plane_id, 2),
 			  PREOFF_YUV_TO_RGB_LO);
 	intel_de_write_fw(dev_priv,


