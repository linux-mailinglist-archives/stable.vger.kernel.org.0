Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7C9E428FDA
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 16:01:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238682AbhJKOBo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 10:01:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:50398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237958AbhJKN7l (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 09:59:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2AC3461076;
        Mon, 11 Oct 2021 13:56:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633960595;
        bh=pPyrAjWmUpOgYEbbvKtC7abN4HUJ+cYqsvZkp0igBoA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TyjwsB6yr6lOfZvRm909N4iE8Vfow4haTRwukjvRoWoohe9rs8iRFQSzJWgRiqmv2
         VAGavhJI/XyydeRvvdeM4+XMTU9QzC4Y3IWSpFzRI1bwAm3FJs/+AyP5fk4bwRlKIs
         erTgPss1HUznL7JL7/wO8uQmnBSZdNlG/aO85r6M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Karthik B S <karthik.b.s@intel.com>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Matt Roper <matthew.d.roper@intel.com>,
        Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 5.14 019/151] drm/i915: Extend the async flip VT-d w/a to skl/bxt
Date:   Mon, 11 Oct 2021 15:44:51 +0200
Message-Id: <20211011134518.473974159@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134517.833565002@linuxfoundation.org>
References: <20211011134517.833565002@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

commit b2d73debfdc16b742e64948dc4461876af3f8c10 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/i915_reg.h |    5 +++++
 drivers/gpu/drm/i915/intel_pm.c |   12 ++++++++++++
 2 files changed, 17 insertions(+)

--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -8150,6 +8150,11 @@ enum {
 #define  HSW_SPR_STRETCH_MAX_X1		REG_FIELD_PREP(HSW_SPR_STRETCH_MAX_MASK, 3)
 #define  HSW_FBCQ_DIS			(1 << 22)
 #define  BDW_DPRS_MASK_VBLANK_SRD	(1 << 0)
+#define  SKL_PLANE1_STRETCH_MAX_MASK	REG_GENMASK(1, 0)
+#define  SKL_PLANE1_STRETCH_MAX_X8	REG_FIELD_PREP(SKL_PLANE1_STRETCH_MAX_MASK, 0)
+#define  SKL_PLANE1_STRETCH_MAX_X4	REG_FIELD_PREP(SKL_PLANE1_STRETCH_MAX_MASK, 1)
+#define  SKL_PLANE1_STRETCH_MAX_X2	REG_FIELD_PREP(SKL_PLANE1_STRETCH_MAX_MASK, 2)
+#define  SKL_PLANE1_STRETCH_MAX_X1	REG_FIELD_PREP(SKL_PLANE1_STRETCH_MAX_MASK, 3)
 #define CHICKEN_PIPESL_1(pipe) _MMIO_PIPE(pipe, _CHICKEN_PIPESL_1_A, _CHICKEN_PIPESL_1_B)
 
 #define _CHICKEN_TRANS_A	0x420c0
--- a/drivers/gpu/drm/i915/intel_pm.c
+++ b/drivers/gpu/drm/i915/intel_pm.c
@@ -76,6 +76,8 @@ struct intel_wm_config {
 
 static void gen9_init_clock_gating(struct drm_i915_private *dev_priv)
 {
+	enum pipe pipe;
+
 	if (HAS_LLC(dev_priv)) {
 		/*
 		 * WaCompressedResourceDisplayNewHashMode:skl,kbl
@@ -89,6 +91,16 @@ static void gen9_init_clock_gating(struc
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


