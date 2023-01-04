Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A46265D616
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 15:40:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234523AbjADOkT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 09:40:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239630AbjADOjs (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 09:39:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0E683E0D4
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 06:39:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8798AB81673
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 14:39:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4B29C433D2;
        Wed,  4 Jan 2023 14:39:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672843179;
        bh=WvKGvB0mR9Rxc9iDBqeEXth+heiSupHNyXMtInSWV9c=;
        h=Subject:To:Cc:From:Date:From;
        b=IAE2LafyXRmh6EAs7tt1uPq4sz4+gylBW99zEZoQTNxqXwgZOESDXwRF1jP5c6dnz
         iQT9MV/U3clDPZw6ygS2WeEszkWcND00ZXLwZBaSWs4wOweVmeOUjEKoym7QjywaEX
         W9jFxeGPmB3wDQop30R0Y39TdfgucGAAwBrUGi44=
Subject: FAILED: patch "[PATCH] drm/i915: Fix watermark calculations for gen12+ MC CCS" failed to apply to 5.15-stable tree
To:     ville.syrjala@linux.intel.com, juhapekka.heikkila@gmail.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 04 Jan 2023 15:39:26 +0100
Message-ID: <167284316679240@kroah.com>
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


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

91c9651425fe ("drm/i915: Fix watermark calculations for gen12+ MC CCS modifier")
a89a96a58611 ("drm/i915: Fix watermark calculations for gen12+ RC CCS modifier")
42a0d256496f ("drm/i915: Extract skl_watermark.c")
55544b2811a6 ("drm/i915: Split intel_read_wm_latency() into per-platform versions")
b7d1559038b6 ("drm/i915: move dbuf under display sub-struct")
90b87cf24304 ("drm/i915: move mipi_mmio_base to display.dsi")
d51309b4e9aa ("drm/i915: move and group cdclk under display.cdclk")
f0acaf9d6912 ("drm/i915: move and group max_bw and bw_obj under display.bw")
c3704f1938e7 ("drm/i915: move and group sagv under display.sagv")
a30a6fe9e56c ("drm/i915: move wm to display.wm")
b3d81dafdc48 ("drm/i915: move and group fbdev under display.fbdev")
36d225f365e7 ("drm/i915: move dpll under display.dpll")
4be1c12c880e ("drm/i915: move and split audio under display.audio and display.funcs")
6c77055aa674 ("drm/i915: move dmc to display.dmc")
12dc50823845 ("drm/i915: move and group pps members under display.pps")
203eb5a98edb ("drm/i915: move and group gmbus members under display.gmbus")
34dc3cc5017f ("drm/i915: move color_funcs to display.funcs")
06a50913d96e ("drm/i915: move fdi_funcs to display.funcs")
103472c13f0a ("drm/i915: move wm_disp funcs to display.funcs")
5a04eb5be8e4 ("drm/i915: move hotplug_funcs to display.funcs")

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

