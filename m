Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 068D25F2F68
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 13:16:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229468AbiJCLQH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 07:16:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbiJCLQG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 07:16:06 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D9083FA0D
        for <stable@vger.kernel.org>; Mon,  3 Oct 2022 04:16:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664795765; x=1696331765;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9ROaFCrior9de9OnSVdMo1DwT4Q3eTeyBABuE1+1Yj8=;
  b=ZQ9X6KTb03yU2nuZdaNw6tUMj2XhH6rO6OCiTIm1UJ1xkNobXot8Bwb5
   aj1yVilKWeMelZzlmRHktGhmmHJ/1d6s/Ijlo0ZUNXP/b0ktgqjKPVnYD
   Jilv76QCx2XzG5I2qW3rtTeYUOjgL0LyQTBkgz5OZG7VPCSCZxGegyJos
   XslMU9ABoB/YmiK4FMSSIV7KkTCFUw5ox+kf50ozzvlfrOF5RFU2Jqc8E
   gTFqFVBwIOZPxZT/w4E0YEchlOu8Fv7Tw985K+jNDpjblqqydV85h6DWk
   kEf5sD0Ddh5VgdWpAggx6f35MwlEZJI+FNhjEnvOl4fz/WQBEUx7/+CWd
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10488"; a="388896901"
X-IronPort-AV: E=Sophos;i="5.93,365,1654585200"; 
   d="scan'208";a="388896901"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2022 04:16:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10488"; a="618696709"
X-IronPort-AV: E=Sophos;i="5.93,365,1654585200"; 
   d="scan'208";a="618696709"
Received: from stinkpipe.fi.intel.com (HELO stinkbox) ([10.237.72.191])
  by orsmga007.jf.intel.com with SMTP; 03 Oct 2022 04:16:01 -0700
Received: by stinkbox (sSMTP sendmail emulation); Mon, 03 Oct 2022 14:16:01 +0300
From:   Ville Syrjala <ville.syrjala@linux.intel.com>
To:     intel-gfx@lists.freedesktop.org
Cc:     stable@vger.kernel.org,
        Juha-Pekka Heikkila <juhapekka.heikkila@gmail.com>
Subject: [PATCH v2 5/6] drm/i915: Fix watermark calculations for DG2 CCS+CC modifier
Date:   Mon,  3 Oct 2022 14:15:43 +0300
Message-Id: <20221003111544.8007-6-ville.syrjala@linux.intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221003111544.8007-1-ville.syrjala@linux.intel.com>
References: <20221003111544.8007-1-ville.syrjala@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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
Reviewed-by: Juha-Pekka Heikkila <juhapekka.heikkila@gmail.com>
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
---
 drivers/gpu/drm/i915/display/skl_watermark.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/skl_watermark.c b/drivers/gpu/drm/i915/display/skl_watermark.c
index 070357da40e4..aac0980a0c9d 100644
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

