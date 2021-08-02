Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B16473DD708
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 15:25:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233849AbhHBNZO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 09:25:14 -0400
Received: from mga12.intel.com ([192.55.52.136]:53331 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233767AbhHBNZM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 09:25:12 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10063"; a="193048896"
X-IronPort-AV: E=Sophos;i="5.84,289,1620716400"; 
   d="scan'208";a="193048896"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Aug 2021 06:25:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,289,1620716400"; 
   d="scan'208";a="583962757"
Received: from akn-lab.iind.intel.com ([10.223.74.111])
  by fmsmga001.fm.intel.com with ESMTP; 02 Aug 2021 06:24:57 -0700
From:   "Nautiyal, Ankit K" <ankit.k.nautiyal@intel.com>
To:     intel-gfx@lists.freedesktop.org
Cc:     uma.shankar@intel.com, paulo.r.zanoni@intel.com,
        ville.syrjala@linux.intel.com, daniel.vetter@ffwll.ch,
        jani.nikula@linux.intel.com, joonas.lahtinen@linux.intel.com,
        rodrigo.vivi@intel.com, stable@vger.kernel.org
Subject: [PATCH v2] drm/i915/display: Fix the 12 BPC bits for PIPE_MISC reg
Date:   Mon,  2 Aug 2021 18:26:37 +0530
Message-Id: <1627908997-32236-1-git-send-email-ankit.k.nautiyal@intel.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ankit Nautiyal <ankit.k.nautiyal@intel.com>

Till DISPLAY12 the PIPE_MISC bits 5-7 are used to set the
Dithering BPC, with valid values of 6, 8, 10 BPC, with Dithering bit enabled.
Also, these bits are used in case of HW readout for pipe_bpp in case of
DSI.
For ADLP+ these bits are used to set the PORT OUTPUT BPC, with valid
values of: 6, 8, 10, 12 BPC, and need to be programmed whether
dithering is enabled or not.

This patch:
-corrects the bits 5-7 for PIPE MISC register for 12 BPC.
-renames the bits and mask to have generic names for these bits for
dithering bpc and port output bpc.

v2: Addressed the comments and suggestions from Uma Shankar:
-Add 'display' in subject
-Add Fixes tag in the commit message.
-Take care of DSI case which uses the bits for getting pipe_bpp.

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
---
 drivers/gpu/drm/i915/display/intel_display.c | 18 +++++++++---------
 drivers/gpu/drm/i915/i915_reg.h              | 15 ++++++++++-----
 2 files changed, 19 insertions(+), 14 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_display.c b/drivers/gpu/drm/i915/display/intel_display.c
index 65ddb6c..9766b36 100644
--- a/drivers/gpu/drm/i915/display/intel_display.c
+++ b/drivers/gpu/drm/i915/display/intel_display.c
@@ -5760,16 +5760,16 @@ static void bdw_set_pipemisc(const struct intel_crtc_state *crtc_state)
 
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
+		val |= PIPEMISC_12_BPC;
 		break;
 	default:
 		MISSING_CASE(crtc_state->pipe_bpp);
@@ -5822,14 +5822,14 @@ int bdw_get_pipemisc_bpp(struct intel_crtc *crtc)
 
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
+	case PIPEMISC_12_BPC:
 		return 36;
 	default:
 		MISSING_CASE(tmp);
diff --git a/drivers/gpu/drm/i915/i915_reg.h b/drivers/gpu/drm/i915/i915_reg.h
index 943fe48..bbfe4f4 100644
--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -6166,11 +6166,16 @@ enum {
 #define   PIPEMISC_HDR_MODE_PRECISION	(1 << 23) /* icl+ */
 #define   PIPEMISC_OUTPUT_COLORSPACE_YUV  (1 << 11)
 #define   PIPEMISC_PIXEL_ROUNDING_TRUNC	REG_BIT(8) /* tgl+ */
-#define   PIPEMISC_DITHER_BPC_MASK	(7 << 5)
-#define   PIPEMISC_DITHER_8_BPC		(0 << 5)
-#define   PIPEMISC_DITHER_10_BPC	(1 << 5)
-#define   PIPEMISC_DITHER_6_BPC		(2 << 5)
-#define   PIPEMISC_DITHER_12_BPC	(3 << 5)
+/*
+ * For Display < 13, Bits 5-7 of PIPE MISC represent DITHER BPC.
+ * ADLP+, the bits 5-7 represent PORT OUTPUT BPC with valid values of:
+ * 6, 8, 10, 12 BPC.
+ */
+#define   PIPEMISC_BPC_MASK		(7 << 5)
+#define   PIPEMISC_8_BPC		(0 << 5)
+#define   PIPEMISC_10_BPC		(1 << 5)
+#define   PIPEMISC_6_BPC		(2 << 5)
+#define   PIPEMISC_12_BPC		(4 << 5) /* adlp+ */
 #define   PIPEMISC_DITHER_ENABLE	(1 << 4)
 #define   PIPEMISC_DITHER_TYPE_MASK	(3 << 2)
 #define   PIPEMISC_DITHER_TYPE_SP	(0 << 2)
-- 
2.8.1

