Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 681CC5F2F60
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 13:15:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229521AbiJCLPz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 07:15:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbiJCLPy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 07:15:54 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE3382CE39
        for <stable@vger.kernel.org>; Mon,  3 Oct 2022 04:15:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664795751; x=1696331751;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=h+g50rP7L6IpScu5vnmpPTgDesIgArQ1FdXdgG99ylQ=;
  b=EZejWQ1chLG1Tyt0fOsTlkRi+r5G/p8OB+5XhvOh86veqLDAQBgDnTp4
   m9FK235GBDEhD48s35aM5PuKMEjB44eNtG3ylBklsjYieg0Y9pFE34y9q
   P/eXWDrzr55t3D+86bgKJSg4kL/tu6S8JwtSC2bPXp3Sinf1oXqoSzRTY
   /P/UG9BeZ3BZ2W9/+3KS1vx0UUoG7ljgJtr5qoKqDCfpjWzxir+YEOi7s
   lRyHdwIWOEpCePbIMJFll61BAE7SQc5ovAS96S/aDQcEglsVlObR6+vwl
   ZZRf1iljZPuXOP17QVqj7O7HSEQPkXIRaETGK48X7CUofSn7geTCz5qUg
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10488"; a="388896856"
X-IronPort-AV: E=Sophos;i="5.93,365,1654585200"; 
   d="scan'208";a="388896856"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2022 04:15:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10488"; a="618696695"
X-IronPort-AV: E=Sophos;i="5.93,365,1654585200"; 
   d="scan'208";a="618696695"
Received: from stinkpipe.fi.intel.com (HELO stinkbox) ([10.237.72.191])
  by orsmga007.jf.intel.com with SMTP; 03 Oct 2022 04:15:48 -0700
Received: by stinkbox (sSMTP sendmail emulation); Mon, 03 Oct 2022 14:15:47 +0300
From:   Ville Syrjala <ville.syrjala@linux.intel.com>
To:     intel-gfx@lists.freedesktop.org
Cc:     stable@vger.kernel.org,
        Juha-Pekka Heikkila <juhapekka.heikkila@gmail.com>
Subject: [PATCH v2 1/6] drm/i915: Fix watermark calculations for gen12+ RC CCS modifier
Date:   Mon,  3 Oct 2022 14:15:39 +0300
Message-Id: <20221003111544.8007-2-ville.syrjala@linux.intel.com>
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

Take the gen12+ RC CCS modifier into account when calculating the
watermarks. Othwerwise we'll calculate the watermarks thinking this
Y-tiled modifier is linear.

The rc_surface part is actually a nop since that is not used
for any glk+ platform.

v2: Split RC CCS vs. MC CCS to separate patches

Cc: stable@vger.kernel.org
Fixes: b3e57bccd68a ("drm/i915/tgl: Gen-12 render decompression")
Reviewed-by: Juha-Pekka Heikkila <juhapekka.heikkila@gmail.com>
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
---
 drivers/gpu/drm/i915/display/skl_watermark.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/skl_watermark.c b/drivers/gpu/drm/i915/display/skl_watermark.c
index 59e4fc6191f1..6ce1213c18b3 100644
--- a/drivers/gpu/drm/i915/display/skl_watermark.c
+++ b/drivers/gpu/drm/i915/display/skl_watermark.c
@@ -1710,10 +1710,12 @@ skl_compute_wm_params(const struct intel_crtc_state *crtc_state,
 		      modifier == I915_FORMAT_MOD_4_TILED ||
 		      modifier == I915_FORMAT_MOD_Yf_TILED ||
 		      modifier == I915_FORMAT_MOD_Y_TILED_CCS ||
-		      modifier == I915_FORMAT_MOD_Yf_TILED_CCS;
+		      modifier == I915_FORMAT_MOD_Yf_TILED_CCS ||
+		      modifier == I915_FORMAT_MOD_Y_TILED_GEN12_RC_CCS;
 	wp->x_tiled = modifier == I915_FORMAT_MOD_X_TILED;
 	wp->rc_surface = modifier == I915_FORMAT_MOD_Y_TILED_CCS ||
-			 modifier == I915_FORMAT_MOD_Yf_TILED_CCS;
+			 modifier == I915_FORMAT_MOD_Yf_TILED_CCS ||
+			 modifier == I915_FORMAT_MOD_Y_TILED_GEN12_RC_CCS;
 	wp->is_planar = intel_format_info_is_yuv_semiplanar(format, modifier);
 
 	wp->width = width;
-- 
2.35.1

