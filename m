Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F4B45F0984
	for <lists+stable@lfdr.de>; Fri, 30 Sep 2022 13:08:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231509AbiI3LIH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Sep 2022 07:08:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231547AbiI3LHs (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Sep 2022 07:07:48 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1A6C1BE795
        for <stable@vger.kernel.org>; Fri, 30 Sep 2022 03:44:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664534647; x=1696070647;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=F8hWaC73oX1yS8jXelp6A8nDbiqix1cqQiQB2VmQGfE=;
  b=R6yUxJMNjQcBV1qa0x9d9zMyFEl5QrC1CKM0hjQLkmZeKG4Cb0w63lK1
   Js0vQUIzTKOs2cxEPoVd70Gd+B5/wC6IFkg+BvmPOWGHrriw/deluLRrn
   R0TDiA9444ozUgOOoLQNY6+fb93SorgsSs064eKDqHriHyscIM6qGyncY
   n38JGHUVYfpFTdWqwkxWE+BpFDI6ic+Hdj8Na6Arqe4gpHm1J1kGuEiAF
   u3oiiwtRDEAvUMP9cn/5ZefUk5Jca1pQDrR4ErfxWEcHb6UVfi7jGbAo9
   zjtwo0BN+f38ydeCAvNR/n86xDhF3kwCUf/D8Rj0dCLKKSRUFrFTj6aDX
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10485"; a="328544074"
X-IronPort-AV: E=Sophos;i="5.93,358,1654585200"; 
   d="scan'208";a="328544074"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2022 03:43:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10485"; a="765092080"
X-IronPort-AV: E=Sophos;i="5.93,358,1654585200"; 
   d="scan'208";a="765092080"
Received: from stinkpipe.fi.intel.com (HELO stinkbox) ([10.237.72.191])
  by fmsmga001.fm.intel.com with SMTP; 30 Sep 2022 03:43:15 -0700
Received: by stinkbox (sSMTP sendmail emulation); Fri, 30 Sep 2022 13:43:14 +0300
From:   Ville Syrjala <ville.syrjala@linux.intel.com>
To:     intel-gfx@lists.freedesktop.org
Cc:     stable@vger.kernel.org
Subject: [PATCH 4/5] drm/i915: Fix watermark calculations for DG2 CCS+CC modifier
Date:   Fri, 30 Sep 2022 13:43:01 +0300
Message-Id: <20220930104302.25836-5-ville.syrjala@linux.intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220930104302.25836-1-ville.syrjala@linux.intel.com>
References: <20220930104302.25836-1-ville.syrjala@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

Take the DG2 CCS+CC modifier into account when calculating the
watermarks. Othwerwise we'll calculate the watermarks thinking this
tile-4 modifier is linear.

The rc_surface part is actually a nop since that is not used
for any glk+ platform.

Cc: stable@vger.kernel.org
Fixes: 680025dcc400 ("drm/i915/dg2: Add support for DG2 clear color compression")
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
---
 drivers/gpu/drm/i915/display/skl_watermark.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/skl_watermark.c b/drivers/gpu/drm/i915/display/skl_watermark.c
index a120d49b95ca..18178b01375e 100644
--- a/drivers/gpu/drm/i915/display/skl_watermark.c
+++ b/drivers/gpu/drm/i915/display/skl_watermark.c
@@ -1715,7 +1715,8 @@ skl_compute_wm_params(const struct intel_crtc_state *crtc_state,
 		      modifier == I915_FORMAT_MOD_Y_TILED_GEN12_MC_CCS ||
 		      modifier == I915_FORMAT_MOD_Y_TILED_GEN12_RC_CCS_CC ||
 		      modifier == I915_FORMAT_MOD_4_TILED_DG2_RC_CCS ||
-		      modifier == I915_FORMAT_MOD_4_TILED_DG2_MC_CCS;
+		      modifier == I915_FORMAT_MOD_4_TILED_DG2_MC_CCS ||
+		      modifier == I915_FORMAT_MOD_4_TILED_DG2_RC_CCS_CC;
 	wp->x_tiled = modifier == I915_FORMAT_MOD_X_TILED;
 	wp->rc_surface = modifier == I915_FORMAT_MOD_Y_TILED_CCS ||
 			 modifier == I915_FORMAT_MOD_Yf_TILED_CCS ||
@@ -1723,7 +1724,8 @@ skl_compute_wm_params(const struct intel_crtc_state *crtc_state,
 			 modifier == I915_FORMAT_MOD_Y_TILED_GEN12_MC_CCS ||
 			 modifier == I915_FORMAT_MOD_Y_TILED_GEN12_RC_CCS_CC ||
 			 modifier == I915_FORMAT_MOD_4_TILED_DG2_RC_CCS ||
-			 modifier == I915_FORMAT_MOD_4_TILED_DG2_MC_CCS;
+			 modifier == I915_FORMAT_MOD_4_TILED_DG2_MC_CCS ||
+			 modifier == I915_FORMAT_MOD_4_TILED_DG2_RC_CCS_CC;
 	wp->is_planar = intel_format_info_is_yuv_semiplanar(format, modifier);
 
 	wp->width = width;
-- 
2.35.1

