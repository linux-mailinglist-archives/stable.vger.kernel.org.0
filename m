Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F8DA45A1FB
	for <lists+stable@lfdr.de>; Tue, 23 Nov 2021 12:53:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235109AbhKWL4V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Nov 2021 06:56:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:41636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234172AbhKWL4U (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Nov 2021 06:56:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5C34961028;
        Tue, 23 Nov 2021 11:53:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637668392;
        bh=gTaqTexhK3zBhFCM2zo6lSnZlQDGkNxO8b6fTuhPhZA=;
        h=Subject:To:Cc:From:Date:From;
        b=PiYFovKfLq3XWBxgzdmgP3DrOGVj8I4PBpwtFlewqxK2LZ6wL5S1XIr8uSPgfK6v4
         2+bIUx2/TgwiUASaA8ZsfgVfxtn3AdR/XrVQ67ngE3w06NMPqd8NtIe/UC1oIw1oJ5
         UWclgXlQt/aV93wpFaR4bUGq/hjbzQ1SRJri9MaY=
Subject: FAILED: patch "[PATCH] drm/i915: Extend the async flip VT-d w/a to skl/bxt" failed to apply to 5.15-stable tree
To:     ville.syrjala@linux.intel.com, jani.nikula@intel.com,
        karthik.b.s@intel.com, matthew.d.roper@intel.com,
        rodrigo.vivi@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 23 Nov 2021 12:53:10 +0100
Message-ID: <163766839011952@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 99bac3063e8e0f437b04897a399b9394919d1a79 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>
Date: Thu, 30 Sep 2021 22:09:42 +0300
Subject: [PATCH] drm/i915: Extend the async flip VT-d w/a to skl/bxt
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Looks like skl/bxt/derivatives also need the plane stride
stretch w/a when using async flips and VT-d is enabled, or
else we get corruption on screen. To my surprise this was
even documented in bspec, but only as a note on the
CHICHKEN_PIPESL register description rather than on the
w/a list.

So very much the same thing as on HSW/BDW, except the bits
moved yet again.

Cc: stable@vger.kernel.org
Cc: Karthik B S <karthik.b.s@intel.com>
Fixes: 55ea1cb178ef ("drm/i915: Enable async flips in i915")
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210930190943.17547-1-ville.syrjala@linux.intel.com
Reviewed-by: Matt Roper <matthew.d.roper@intel.com>
(cherry picked from commit d08df3b0bdb25546e86dc9a6c4e3ec0c43832299)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
(cherry picked from commit b2d73debfdc16b742e64948dc4461876af3f8c10)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>

diff --git a/drivers/gpu/drm/i915/intel_pm.c b/drivers/gpu/drm/i915/intel_pm.c
index f90fe39cf8ca..ecbb3d141632 100644
--- a/drivers/gpu/drm/i915/intel_pm.c
+++ b/drivers/gpu/drm/i915/intel_pm.c
@@ -77,6 +77,8 @@ struct intel_wm_config {
 
 static void gen9_init_clock_gating(struct drm_i915_private *dev_priv)
 {
+	enum pipe pipe;
+
 	if (HAS_LLC(dev_priv)) {
 		/*
 		 * WaCompressedResourceDisplayNewHashMode:skl,kbl
@@ -90,6 +92,16 @@ static void gen9_init_clock_gating(struct drm_i915_private *dev_priv)
 			   SKL_DE_COMPRESSED_HASH_MODE);
 	}
 
+	for_each_pipe(dev_priv, pipe) {
+		/*
+		 * "Plane N strech max must be programmed to 11b (x1)
+		 *  when Async flips are enabled on that plane."
+		 */
+		if (!IS_GEMINILAKE(dev_priv) && intel_vtd_active())
+			intel_uncore_rmw(&dev_priv->uncore, CHICKEN_PIPESL_1(pipe),
+					 SKL_PLANE1_STRETCH_MAX_MASK, SKL_PLANE1_STRETCH_MAX_X1);
+	}
+
 	/* See Bspec note for PSR2_CTL bit 31, Wa#828:skl,bxt,kbl,cfl */
 	intel_uncore_write(&dev_priv->uncore, CHICKEN_PAR1_1,
 		   intel_uncore_read(&dev_priv->uncore, CHICKEN_PAR1_1) | SKL_EDP_PSR_FIX_RDWRAP);

