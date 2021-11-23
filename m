Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51CED45A109
	for <lists+stable@lfdr.de>; Tue, 23 Nov 2021 12:10:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234666AbhKWLNO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Nov 2021 06:13:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:54278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235897AbhKWLNL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Nov 2021 06:13:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5A52660F58;
        Tue, 23 Nov 2021 11:10:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637665803;
        bh=f6fiUPMZv1L89M80N5eebmWW4gaNrE9hagAuM+J5qS8=;
        h=Subject:To:Cc:From:Date:From;
        b=J/0m8K91Vh439/92rsY6KqsOoCKO4NjqI8wTZhMEWOCHK6Wxty3FX+JDnlJPsxCrA
         XA/stHh3YxFMjL8bvfDEsYrZRVDeCYEy0XvyeLQnxDfxUR2WVzwekumldJqJodTG9F
         Yb0ftu4GvxjGj9BILUZE+SO4ngZvROTM02mla2wE=
Subject: FAILED: patch "[PATCH] drm/i915/display: Fix the 12 BPC bits for PIPE_MISC reg" failed to apply to 4.14-stable tree
To:     ankit.k.nautiyal@intel.com, daniel.vetter@ffwll.ch,
        jani.nikula@linux.intel.com, joonas.lahtinen@linux.intel.com,
        paulo.r.zanoni@intel.com, rodrigo.vivi@intel.com,
        stable@vger.kernel.org, uma.shankar@intel.com,
        ville.syrjala@linux.intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 23 Nov 2021 12:09:59 +0100
Message-ID: <163766579951223@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 70418a68713c13da3f36c388087d0220b456a430 Mon Sep 17 00:00:00 2001
From: Ankit Nautiyal <ankit.k.nautiyal@intel.com>
Date: Wed, 11 Aug 2021 10:48:57 +0530
Subject: [PATCH] drm/i915/display: Fix the 12 BPC bits for PIPE_MISC reg
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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

diff --git a/drivers/gpu/drm/i915/display/intel_display.c b/drivers/gpu/drm/i915/display/intel_display.c
index 122f091e0a1e..58f51854bb79 100644
--- a/drivers/gpu/drm/i915/display/intel_display.c
+++ b/drivers/gpu/drm/i915/display/intel_display.c
@@ -5835,16 +5835,18 @@ static void bdw_set_pipemisc(const struct intel_crtc_state *crtc_state)
 
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
@@ -5897,15 +5899,27 @@ int bdw_get_pipemisc_bpp(struct intel_crtc *crtc)
 
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
diff --git a/drivers/gpu/drm/i915/i915_reg.h b/drivers/gpu/drm/i915/i915_reg.h
index 680acccef26b..c9a62a248e49 100644
--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -6163,11 +6163,17 @@ enum {
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

