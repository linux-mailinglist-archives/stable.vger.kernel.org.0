Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C76D3ED5F3
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:17:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238991AbhHPNQB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:16:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:37394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237184AbhHPNNR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:13:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EDC2B63295;
        Mon, 16 Aug 2021 13:10:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119454;
        bh=ccgBKWn/XTFeEMxpKmRbE+OvGO6cm4k9PWtpogWzpuI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=amjj1IltAk8mjLLzKpSzWSHwrIzC/H4uR//yuHuzkzz7z/z62MAp3A5aNu1XuFltT
         gKue8EPC3Ap/tjYzCKLkfwVL5zdW13yOiJ/mNUiCl1M+QsOxnjcvluv+enTQ8mnQCM
         E7iw+24R/9Ju3+keovKa/EjIchTAAJvCKptd2k/g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        intel-gfx@lists.freedesktop.org,
        Ankit Nautiyal <ankit.k.nautiyal@intel.com>,
        Uma Shankar <uma.shankar@intel.com>,
        Paulo Zanoni <paulo.r.zanoni@intel.com>
Subject: [PATCH 5.13 033/151] drm/i915/display: Fix the 12 BPC bits for PIPE_MISC reg
Date:   Mon, 16 Aug 2021 15:01:03 +0200
Message-Id: <20210816125445.166212202@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210816125444.082226187@linuxfoundation.org>
References: <20210816125444.082226187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ankit Nautiyal <ankit.k.nautiyal@intel.com>

commit abd9d66a055722393d33685214c08386694871d7 upstream.

Till DISPLAY12 the PIPE_MISC bits 5-7 are used to set the
Dithering BPC, with valid values of 6, 8, 10 BPC.
For ADLP+ these bits are used to set the PORT OUTPUT BPC, with valid
values of: 6, 8, 10, 12 BPC, and need to be programmed whether
dithering is enabled or not.

This patch:
-corrects the bits 5-7 for PIPE MISC register for 12 BPC.
-renames the bits and mask to have generic names for these bits for
dithering bpc and port output bpc.

v3: Added a note for MIPI DSI which uses the PIPE_MISC for readout
for pipe_bpp. (Uma Shankar)

v2: Added 'display' to the subject and fixes tag. (Uma Shankar)

Fixes: 756f85cffef2 ("drm/i915/bdw: Broadwell has PIPEMISC")
Cc: Paulo Zanoni <paulo.r.zanoni@intel.com> (v1)
Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: intel-gfx@lists.freedesktop.org
Cc: <stable@vger.kernel.org> # v3.13+

Signed-off-by: Ankit Nautiyal <ankit.k.nautiyal@intel.com>
Reviewed-by: Uma Shankar <uma.shankar@intel.com>
Signed-off-by: Uma Shankar <uma.shankar@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210811051857.109723-1-ankit.k.nautiyal@intel.com
(cherry picked from commit 70418a68713c13da3f36c388087d0220b456a430)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_display.c |   34 +++++++++++++++++++--------
 drivers/gpu/drm/i915/i915_reg.h              |   16 ++++++++----
 2 files changed, 35 insertions(+), 15 deletions(-)

--- a/drivers/gpu/drm/i915/display/intel_display.c
+++ b/drivers/gpu/drm/i915/display/intel_display.c
@@ -5424,16 +5424,18 @@ static void bdw_set_pipemisc(const struc
 
 	switch (crtc_state->pipe_bpp) {
 	case 18:
-		val |= PIPEMISC_DITHER_6_BPC;
+		val |= PIPEMISC_6_BPC;
 		break;
 	case 24:
-		val |= PIPEMISC_DITHER_8_BPC;
+		val |= PIPEMISC_8_BPC;
 		break;
 	case 30:
-		val |= PIPEMISC_DITHER_10_BPC;
+		val |= PIPEMISC_10_BPC;
 		break;
 	case 36:
-		val |= PIPEMISC_DITHER_12_BPC;
+		/* Port output 12BPC defined for ADLP+ */
+		if (DISPLAY_VER(dev_priv) > 12)
+			val |= PIPEMISC_12_BPC_ADLP;
 		break;
 	default:
 		MISSING_CASE(crtc_state->pipe_bpp);
@@ -5469,15 +5471,27 @@ int bdw_get_pipemisc_bpp(struct intel_cr
 
 	tmp = intel_de_read(dev_priv, PIPEMISC(crtc->pipe));
 
-	switch (tmp & PIPEMISC_DITHER_BPC_MASK) {
-	case PIPEMISC_DITHER_6_BPC:
+	switch (tmp & PIPEMISC_BPC_MASK) {
+	case PIPEMISC_6_BPC:
 		return 18;
-	case PIPEMISC_DITHER_8_BPC:
+	case PIPEMISC_8_BPC:
 		return 24;
-	case PIPEMISC_DITHER_10_BPC:
+	case PIPEMISC_10_BPC:
 		return 30;
-	case PIPEMISC_DITHER_12_BPC:
-		return 36;
+	/*
+	 * PORT OUTPUT 12 BPC defined for ADLP+.
+	 *
+	 * TODO:
+	 * For previous platforms with DSI interface, bits 5:7
+	 * are used for storing pipe_bpp irrespective of dithering.
+	 * Since the value of 12 BPC is not defined for these bits
+	 * on older platforms, need to find a workaround for 12 BPC
+	 * MIPI DSI HW readout.
+	 */
+	case PIPEMISC_12_BPC_ADLP:
+		if (DISPLAY_VER(dev_priv) > 12)
+			return 36;
+		fallthrough;
 	default:
 		MISSING_CASE(tmp);
 		return 0;
--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -6134,11 +6134,17 @@ enum {
 #define   PIPEMISC_HDR_MODE_PRECISION	(1 << 23) /* icl+ */
 #define   PIPEMISC_OUTPUT_COLORSPACE_YUV  (1 << 11)
 #define   PIPEMISC_PIXEL_ROUNDING_TRUNC	REG_BIT(8) /* tgl+ */
-#define   PIPEMISC_DITHER_BPC_MASK	(7 << 5)
-#define   PIPEMISC_DITHER_8_BPC		(0 << 5)
-#define   PIPEMISC_DITHER_10_BPC	(1 << 5)
-#define   PIPEMISC_DITHER_6_BPC		(2 << 5)
-#define   PIPEMISC_DITHER_12_BPC	(3 << 5)
+/*
+ * For Display < 13, Bits 5-7 of PIPE MISC represent DITHER BPC with
+ * valid values of: 6, 8, 10 BPC.
+ * ADLP+, the bits 5-7 represent PORT OUTPUT BPC with valid values of:
+ * 6, 8, 10, 12 BPC.
+ */
+#define   PIPEMISC_BPC_MASK		(7 << 5)
+#define   PIPEMISC_8_BPC		(0 << 5)
+#define   PIPEMISC_10_BPC		(1 << 5)
+#define   PIPEMISC_6_BPC		(2 << 5)
+#define   PIPEMISC_12_BPC_ADLP		(4 << 5) /* adlp+ */
 #define   PIPEMISC_DITHER_ENABLE	(1 << 4)
 #define   PIPEMISC_DITHER_TYPE_MASK	(3 << 2)
 #define   PIPEMISC_DITHER_TYPE_SP	(0 << 2)


