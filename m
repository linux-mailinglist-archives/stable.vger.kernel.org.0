Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D3185F0983
	for <lists+stable@lfdr.de>; Fri, 30 Sep 2022 13:08:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231408AbiI3LIG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Sep 2022 07:08:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231532AbiI3LHr (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Sep 2022 07:07:47 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81DB41BE787
        for <stable@vger.kernel.org>; Fri, 30 Sep 2022 03:44:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664534646; x=1696070646;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=YC4+D8M8vuyBCaoL8v+cF7Kg8NQaxJI1Ati6sZltkl4=;
  b=YHeiGhMNSXhhYWdarWPNroPd/DH3POqamCu5f/fEUV4EDW69Go3qMLFr
   2+TejLP2884ZOi2423oo+5c4TYRpG0F84k9Gtp7fl8Wn8HAcy1fgCSzq8
   3WHJ3Jg7pkxWFQasizF0O+8IkuXz6XxzQ7ix4vBnr3OSZvIO+G2WF8qUL
   ozYHZiHiyjYSIRqWVbVZ5sCAuOXQAbnZt/oBzq0Sbqb+m6GlwMrRU2qah
   JmWGGx/Wskirtm1FImGWbCRStI6KFFGJ1+fT+OF9IdbfcOYnGBc0jUsL/
   XnrFtRxYX+g7/GuhHQUfiSOPWXvQ0rs3XmUhNMKghReY8hbPGpBCLk3X4
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10485"; a="328544062"
X-IronPort-AV: E=Sophos;i="5.93,358,1654585200"; 
   d="scan'208";a="328544062"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2022 03:43:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10485"; a="765092050"
X-IronPort-AV: E=Sophos;i="5.93,358,1654585200"; 
   d="scan'208";a="765092050"
Received: from stinkpipe.fi.intel.com (HELO stinkbox) ([10.237.72.191])
  by fmsmga001.fm.intel.com with SMTP; 30 Sep 2022 03:43:12 -0700
Received: by stinkbox (sSMTP sendmail emulation); Fri, 30 Sep 2022 13:43:11 +0300
From:   Ville Syrjala <ville.syrjala@linux.intel.com>
To:     intel-gfx@lists.freedesktop.org
Cc:     stable@vger.kernel.org
Subject: [PATCH 3/5] drm/i915: Fix watermark calculations for DG2 CCS modifiers
Date:   Fri, 30 Sep 2022 13:43:00 +0300
Message-Id: <20220930104302.25836-4-ville.syrjala@linux.intel.com>
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

Take the DG2 CCS modifiers into account when calculating the
watermarks. Othwerwise we'll calculate the watermarks thinking these
tile-4 modifiers are linear.

The rc_surface part is actually a nop since that is not used
for any glk+ platform.

Cc: stable@vger.kernel.org
Fixes: 4c3afa72138c ("drm/i915/dg2: Add support for DG2 render and media compression")
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
---
 drivers/gpu/drm/i915/display/skl_watermark.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/skl_watermark.c b/drivers/gpu/drm/i915/display/skl_watermark.c
index 3676662897e7..a120d49b95ca 100644
--- a/drivers/gpu/drm/i915/display/skl_watermark.c
+++ b/drivers/gpu/drm/i915/display/skl_watermark.c
@@ -1713,13 +1713,17 @@ skl_compute_wm_params(const struct intel_crtc_state *crtc_state,
 		      modifier == I915_FORMAT_MOD_Yf_TILED_CCS ||
 		      modifier == I915_FORMAT_MOD_Y_TILED_GEN12_RC_CCS ||
 		      modifier == I915_FORMAT_MOD_Y_TILED_GEN12_MC_CCS ||
-		      modifier == I915_FORMAT_MOD_Y_TILED_GEN12_RC_CCS_CC;
+		      modifier == I915_FORMAT_MOD_Y_TILED_GEN12_RC_CCS_CC ||
+		      modifier == I915_FORMAT_MOD_4_TILED_DG2_RC_CCS ||
+		      modifier == I915_FORMAT_MOD_4_TILED_DG2_MC_CCS;
 	wp->x_tiled = modifier == I915_FORMAT_MOD_X_TILED;
 	wp->rc_surface = modifier == I915_FORMAT_MOD_Y_TILED_CCS ||
 			 modifier == I915_FORMAT_MOD_Yf_TILED_CCS ||
 			 modifier == I915_FORMAT_MOD_Y_TILED_GEN12_RC_CCS ||
 			 modifier == I915_FORMAT_MOD_Y_TILED_GEN12_MC_CCS ||
-			 modifier == I915_FORMAT_MOD_Y_TILED_GEN12_RC_CCS_CC;
+			 modifier == I915_FORMAT_MOD_Y_TILED_GEN12_RC_CCS_CC ||
+			 modifier == I915_FORMAT_MOD_4_TILED_DG2_RC_CCS ||
+			 modifier == I915_FORMAT_MOD_4_TILED_DG2_MC_CCS;
 	wp->is_planar = intel_format_info_is_yuv_semiplanar(format, modifier);
 
 	wp->width = width;
-- 
2.35.1

