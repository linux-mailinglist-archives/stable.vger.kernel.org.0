Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7718265D614
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 15:40:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229582AbjADOkS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 09:40:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239708AbjADOjp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 09:39:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1796939F8C
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 06:39:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A93FE61763
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 14:39:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2A0FC433D2;
        Wed,  4 Jan 2023 14:39:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672843176;
        bh=PsUN0DPBzVanVstvdA2PQ18MM8lApJXTdqykd7u0hOI=;
        h=Subject:To:Cc:From:Date:From;
        b=yHT+FUulOfLdW3HRBjdvses8eM+eobK9sPOor70mVw0wtAXAAwe+TEcjuWGwdmXF1
         KW8KX3y3O6cjFBC8OByaa+flmc9PyMNmBF2qkVgprpmjj0jx3xO4reIalKzZU+/ezn
         92fJk6x0grNVbNGbrOE9SZXpG7T6FwDt/xPuNuWg=
Subject: FAILED: patch "[PATCH] drm/i915: Fix watermark calculations for gen12+ MC CCS" failed to apply to 6.1-stable tree
To:     ville.syrjala@linux.intel.com, juhapekka.heikkila@gmail.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 04 Jan 2023 15:39:25 +0100
Message-ID: <167284316596180@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 6.1-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

91c9651425fe ("drm/i915: Fix watermark calculations for gen12+ MC CCS modifier")
a89a96a58611 ("drm/i915: Fix watermark calculations for gen12+ RC CCS modifier")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 91c9651425fe955b1387f3637607dda005f3f710 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>
Date: Mon, 3 Oct 2022 14:15:40 +0300
Subject: [PATCH] drm/i915: Fix watermark calculations for gen12+ MC CCS
 modifier
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Take the gen12+ MC CCS modifier into account when calculating the
watermarks. Othwerwise we'll calculate the watermarks thinking this
Y-tiled modifier is linear.

The rc_surface part is actually a nop since that is not used
for any glk+ platform.

v2: Split RC CCS vs. MC CCS to separate patches

Cc: stable@vger.kernel.org
Fixes: 2dfbf9d2873a ("drm/i915/tgl: Gen-12 display can decompress surfaces compressed by the media engine")
Reviewed-by: Juha-Pekka Heikkila <juhapekka.heikkila@gmail.com>
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20221003111544.8007-3-ville.syrjala@linux.intel.com

diff --git a/drivers/gpu/drm/i915/display/skl_watermark.c b/drivers/gpu/drm/i915/display/skl_watermark.c
index 6ce1213c18b3..1b8f5970cbf7 100644
--- a/drivers/gpu/drm/i915/display/skl_watermark.c
+++ b/drivers/gpu/drm/i915/display/skl_watermark.c
@@ -1711,11 +1711,13 @@ skl_compute_wm_params(const struct intel_crtc_state *crtc_state,
 		      modifier == I915_FORMAT_MOD_Yf_TILED ||
 		      modifier == I915_FORMAT_MOD_Y_TILED_CCS ||
 		      modifier == I915_FORMAT_MOD_Yf_TILED_CCS ||
-		      modifier == I915_FORMAT_MOD_Y_TILED_GEN12_RC_CCS;
+		      modifier == I915_FORMAT_MOD_Y_TILED_GEN12_RC_CCS ||
+		      modifier == I915_FORMAT_MOD_Y_TILED_GEN12_MC_CCS;
 	wp->x_tiled = modifier == I915_FORMAT_MOD_X_TILED;
 	wp->rc_surface = modifier == I915_FORMAT_MOD_Y_TILED_CCS ||
 			 modifier == I915_FORMAT_MOD_Yf_TILED_CCS ||
-			 modifier == I915_FORMAT_MOD_Y_TILED_GEN12_RC_CCS;
+			 modifier == I915_FORMAT_MOD_Y_TILED_GEN12_RC_CCS ||
+			 modifier == I915_FORMAT_MOD_Y_TILED_GEN12_MC_CCS;
 	wp->is_planar = intel_format_info_is_yuv_semiplanar(format, modifier);
 
 	wp->width = width;

