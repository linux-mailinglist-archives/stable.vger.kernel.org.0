Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FD315F2F64
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 13:16:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229646AbiJCLQA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 07:16:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbiJCLP6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 07:15:58 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5E0232EE2
        for <stable@vger.kernel.org>; Mon,  3 Oct 2022 04:15:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664795757; x=1696331757;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=li8uA9smJX/p1Kbj9xmvCp5pQDaUi8u/BVYwbJVzt60=;
  b=nNIjCiijF9pomIEqVPhJoyncRi5qDr/5y0aSVWJfq8fDPZeRJw//TGVV
   4LJXSTq8JlcNVqBfPlvtSrNWjJhm5eP+mId5msqh8rh0ddCei58vJJKVI
   9VKzfMoecY8kUj/qqmSZqBNCvGukTiBzZBlnTw9dE0E6aCfVrdioFP+6K
   O1YrW02/EuOf5jT9JvKvUkEJWRNFw5fjffx0YEo41ZQPkNTEhG3n3ygUQ
   6r0IAVTk2pwGS+EMLa1kRX6cTde2zhVbFS/H8mO83vG2bUhvjUg6wEpgw
   QxAtspPS3tIf/3MJrgbYbvux8nU3efPGcRe/jAULrS7hWvLy5fh+a0pUi
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10488"; a="388896869"
X-IronPort-AV: E=Sophos;i="5.93,365,1654585200"; 
   d="scan'208";a="388896869"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2022 04:15:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10488"; a="618696702"
X-IronPort-AV: E=Sophos;i="5.93,365,1654585200"; 
   d="scan'208";a="618696702"
Received: from stinkpipe.fi.intel.com (HELO stinkbox) ([10.237.72.191])
  by orsmga007.jf.intel.com with SMTP; 03 Oct 2022 04:15:55 -0700
Received: by stinkbox (sSMTP sendmail emulation); Mon, 03 Oct 2022 14:15:54 +0300
From:   Ville Syrjala <ville.syrjala@linux.intel.com>
To:     intel-gfx@lists.freedesktop.org
Cc:     stable@vger.kernel.org,
        Juha-Pekka Heikkila <juhapekka.heikkila@gmail.com>
Subject: [PATCH v2 3/6] drm/i915: Fix watermark calculations for gen12+ CCS+CC modifier
Date:   Mon,  3 Oct 2022 14:15:41 +0300
Message-Id: <20221003111544.8007-4-ville.syrjala@linux.intel.com>
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

Take the gen12+ CCS+CC modifier into account when calculating the
watermarks. Othwerwise we'll calculate the watermarks thinking this
Y-tiled modifier is linear.

The rc_surface part is actually a nop since that is not used
for any glk+ platform.

Cc: stable@vger.kernel.org
Fixes: d1e2775e9b96 ("drm/i915/tgl: Add Clear Color support for TGL Render Decompression")
Reviewed-by: Juha-Pekka Heikkila <juhapekka.heikkila@gmail.com>
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
---
 drivers/gpu/drm/i915/display/skl_watermark.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/skl_watermark.c b/drivers/gpu/drm/i915/display/skl_watermark.c
index 1b8f5970cbf7..0ff3ece166fe 100644
--- a/drivers/gpu/drm/i915/display/skl_watermark.c
+++ b/drivers/gpu/drm/i915/display/skl_watermark.c
@@ -1712,12 +1712,14 @@ skl_compute_wm_params(const struct intel_crtc_state *crtc_state,
 		      modifier == I915_FORMAT_MOD_Y_TILED_CCS ||
 		      modifier == I915_FORMAT_MOD_Yf_TILED_CCS ||
 		      modifier == I915_FORMAT_MOD_Y_TILED_GEN12_RC_CCS ||
-		      modifier == I915_FORMAT_MOD_Y_TILED_GEN12_MC_CCS;
+		      modifier == I915_FORMAT_MOD_Y_TILED_GEN12_MC_CCS ||
+		      modifier == I915_FORMAT_MOD_Y_TILED_GEN12_RC_CCS_CC;
 	wp->x_tiled = modifier == I915_FORMAT_MOD_X_TILED;
 	wp->rc_surface = modifier == I915_FORMAT_MOD_Y_TILED_CCS ||
 			 modifier == I915_FORMAT_MOD_Yf_TILED_CCS ||
 			 modifier == I915_FORMAT_MOD_Y_TILED_GEN12_RC_CCS ||
-			 modifier == I915_FORMAT_MOD_Y_TILED_GEN12_MC_CCS;
+			 modifier == I915_FORMAT_MOD_Y_TILED_GEN12_MC_CCS ||
+			 modifier == I915_FORMAT_MOD_Y_TILED_GEN12_RC_CCS_CC;
 	wp->is_planar = intel_format_info_is_yuv_semiplanar(format, modifier);
 
 	wp->width = width;
-- 
2.35.1

