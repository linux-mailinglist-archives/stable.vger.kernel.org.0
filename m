Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B41E2205E1C
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 22:21:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389873AbgFWUUB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:20:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:37130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388899AbgFWUT4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:19:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F18DA207E8;
        Tue, 23 Jun 2020 20:19:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592943595;
        bh=Ztpv0ZpSpd/FSMjoSc3KoFgEmo4FhH78xDmVFyhln8s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hGD1rKoS00YY605OlgCe0dFJFawnpudwbR0qqTZSyzxi/tyyCYZtmdPmwmI5F9YSQ
         KbuRsWlMAyzERpXHsYcYjiqMUcPI0G/tVLU7ZnJy36h+4qIfGF3lnF8L95JbbxYGz5
         JVGjQWw1qdb4sZgkMg7QJU3K1sKHGWXM0ACceCBY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>,
        Mika Kuoppala <mika.kuoppala@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Subject: [PATCH 5.7 453/477] drm/i915/gt: Move ivb GT workarounds from init_clock_gating to workarounds
Date:   Tue, 23 Jun 2020 21:57:30 +0200
Message-Id: <20200623195428.953928674@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Wilson <chris@chris-wilson.co.uk>

commit 7237b190add0794bd95979018a23eda698f2705d upstream.

Rescue the GT workarounds from being buried inside init_clock_gating so
that we remember to apply them after a GT reset, and that they are
included in our verification that the workarounds are applied.

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Reviewed-by: Mika Kuoppala <mika.kuoppala@linux.intel.com>
Cc: stable@vger.kernel.org
Link: https://patchwork.freedesktop.org/patch/msgid/20200611080140.30228-2-chris@chris-wilson.co.uk
(cherry picked from commit 19f1f627b33385a2f0855cbc7d33d86d7f4a1e78)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/gt/intel_workarounds.c |   62 ++++++++++++++++++++++++++++
 drivers/gpu/drm/i915/i915_reg.h             |    2 
 drivers/gpu/drm/i915/intel_pm.c             |   48 ---------------------
 3 files changed, 63 insertions(+), 49 deletions(-)

--- a/drivers/gpu/drm/i915/gt/intel_workarounds.c
+++ b/drivers/gpu/drm/i915/gt/intel_workarounds.c
@@ -704,6 +704,66 @@ int intel_engine_emit_ctx_wa(struct i915
 }
 
 static void
+ivb_gt_workarounds_init(struct drm_i915_private *i915, struct i915_wa_list *wal)
+{
+	/* WaDisableEarlyCull:ivb */
+	wa_masked_en(wal, _3D_CHICKEN3, _3D_CHICKEN_SF_DISABLE_OBJEND_CULL);
+
+	/* WaDisablePSDDualDispatchEnable:ivb */
+	if (IS_IVB_GT1(i915))
+		wa_masked_en(wal,
+			     GEN7_HALF_SLICE_CHICKEN1,
+			     GEN7_PSD_SINGLE_PORT_DISPATCH_ENABLE);
+
+	/* WaDisable_RenderCache_OperationalFlush:ivb */
+	wa_masked_dis(wal, CACHE_MODE_0_GEN7, RC_OP_FLUSH_ENABLE);
+
+	/* Apply the WaDisableRHWOOptimizationForRenderHang:ivb workaround. */
+	wa_masked_dis(wal,
+		      GEN7_COMMON_SLICE_CHICKEN1,
+		      GEN7_CSC1_RHWO_OPT_DISABLE_IN_RCC);
+
+	/* WaApplyL3ControlAndL3ChickenMode:ivb */
+	wa_write(wal, GEN7_L3CNTLREG1, GEN7_WA_FOR_GEN7_L3_CONTROL);
+	wa_write(wal, GEN7_L3_CHICKEN_MODE_REGISTER, GEN7_WA_L3_CHICKEN_MODE);
+
+	/* WaForceL3Serialization:ivb */
+	wa_write_clr(wal, GEN7_L3SQCREG4, L3SQ_URB_READ_CAM_MATCH_DISABLE);
+
+	/*
+	 * WaVSThreadDispatchOverride:ivb,vlv
+	 *
+	 * This actually overrides the dispatch
+	 * mode for all thread types.
+	 */
+	wa_write_masked_or(wal, GEN7_FF_THREAD_MODE,
+			   GEN7_FF_SCHED_MASK,
+			   GEN7_FF_TS_SCHED_HW |
+			   GEN7_FF_VS_SCHED_HW |
+			   GEN7_FF_DS_SCHED_HW);
+
+	if (0) { /* causes HiZ corruption on ivb:gt1 */
+		/* enable HiZ Raw Stall Optimization */
+		wa_masked_dis(wal, CACHE_MODE_0_GEN7, HIZ_RAW_STALL_OPT_DISABLE);
+	}
+
+	/* WaDisable4x2SubspanOptimization:ivb */
+	wa_masked_en(wal, CACHE_MODE_1, PIXEL_SUBSPAN_COLLECT_OPT_DISABLE);
+
+	/*
+	 * BSpec recommends 8x4 when MSAA is used,
+	 * however in practice 16x4 seems fastest.
+	 *
+	 * Note that PS/WM thread counts depend on the WIZ hashing
+	 * disable bit, which we don't touch here, but it's good
+	 * to keep in mind (see 3DSTATE_PS and 3DSTATE_WM).
+	 */
+	wa_add(wal, GEN7_GT_MODE, 0,
+	       _MASKED_FIELD(GEN6_WIZ_HASHING_MASK, GEN6_WIZ_HASHING_16x4),
+	       GEN6_WIZ_HASHING_16x4);
+}
+
+static void
 hsw_gt_workarounds_init(struct drm_i915_private *i915, struct i915_wa_list *wal)
 {
 	/* L3 caching of data atomics doesn't work -- disable it. */
@@ -1022,6 +1082,8 @@ gt_init_workarounds(struct drm_i915_priv
 		skl_gt_workarounds_init(i915, wal);
 	else if (IS_HASWELL(i915))
 		hsw_gt_workarounds_init(i915, wal);
+	else if (IS_IVYBRIDGE(i915))
+		ivb_gt_workarounds_init(i915, wal);
 	else if (INTEL_GEN(i915) <= 8)
 		return;
 	else
--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -7819,7 +7819,7 @@ enum {
 
 /* GEN7 chicken */
 #define GEN7_COMMON_SLICE_CHICKEN1		_MMIO(0x7010)
-  #define GEN7_CSC1_RHWO_OPT_DISABLE_IN_RCC	((1 << 10) | (1 << 26))
+  #define GEN7_CSC1_RHWO_OPT_DISABLE_IN_RCC	(1 << 10)
   #define GEN9_RHWO_OPTIMIZATION_DISABLE	(1 << 14)
 
 #define COMMON_SLICE_CHICKEN2					_MMIO(0x7014)
--- a/drivers/gpu/drm/i915/intel_pm.c
+++ b/drivers/gpu/drm/i915/intel_pm.c
@@ -7009,32 +7009,11 @@ static void ivb_init_clock_gating(struct
 
 	I915_WRITE(ILK_DSPCLK_GATE_D, ILK_VRHUNIT_CLOCK_GATE_DISABLE);
 
-	/* WaDisableEarlyCull:ivb */
-	I915_WRITE(_3D_CHICKEN3,
-		   _MASKED_BIT_ENABLE(_3D_CHICKEN_SF_DISABLE_OBJEND_CULL));
-
 	/* WaDisableBackToBackFlipFix:ivb */
 	I915_WRITE(IVB_CHICKEN3,
 		   CHICKEN3_DGMG_REQ_OUT_FIX_DISABLE |
 		   CHICKEN3_DGMG_DONE_FIX_DISABLE);
 
-	/* WaDisablePSDDualDispatchEnable:ivb */
-	if (IS_IVB_GT1(dev_priv))
-		I915_WRITE(GEN7_HALF_SLICE_CHICKEN1,
-			   _MASKED_BIT_ENABLE(GEN7_PSD_SINGLE_PORT_DISPATCH_ENABLE));
-
-	/* WaDisable_RenderCache_OperationalFlush:ivb */
-	I915_WRITE(CACHE_MODE_0_GEN7, _MASKED_BIT_DISABLE(RC_OP_FLUSH_ENABLE));
-
-	/* Apply the WaDisableRHWOOptimizationForRenderHang:ivb workaround. */
-	I915_WRITE(GEN7_COMMON_SLICE_CHICKEN1,
-		   GEN7_CSC1_RHWO_OPT_DISABLE_IN_RCC);
-
-	/* WaApplyL3ControlAndL3ChickenMode:ivb */
-	I915_WRITE(GEN7_L3CNTLREG1,
-			GEN7_WA_FOR_GEN7_L3_CONTROL);
-	I915_WRITE(GEN7_L3_CHICKEN_MODE_REGISTER,
-		   GEN7_WA_L3_CHICKEN_MODE);
 	if (IS_IVB_GT1(dev_priv))
 		I915_WRITE(GEN7_ROW_CHICKEN2,
 			   _MASKED_BIT_ENABLE(DOP_CLOCK_GATING_DISABLE));
@@ -7046,10 +7025,6 @@ static void ivb_init_clock_gating(struct
 			   _MASKED_BIT_ENABLE(DOP_CLOCK_GATING_DISABLE));
 	}
 
-	/* WaForceL3Serialization:ivb */
-	I915_WRITE(GEN7_L3SQCREG4, I915_READ(GEN7_L3SQCREG4) &
-		   ~L3SQ_URB_READ_CAM_MATCH_DISABLE);
-
 	/*
 	 * According to the spec, bit 13 (RCZUNIT) must be set on IVB.
 	 * This implements the WaDisableRCZUnitClockGating:ivb workaround.
@@ -7064,29 +7039,6 @@ static void ivb_init_clock_gating(struct
 
 	g4x_disable_trickle_feed(dev_priv);
 
-	gen7_setup_fixed_func_scheduler(dev_priv);
-
-	if (0) { /* causes HiZ corruption on ivb:gt1 */
-		/* enable HiZ Raw Stall Optimization */
-		I915_WRITE(CACHE_MODE_0_GEN7,
-			   _MASKED_BIT_DISABLE(HIZ_RAW_STALL_OPT_DISABLE));
-	}
-
-	/* WaDisable4x2SubspanOptimization:ivb */
-	I915_WRITE(CACHE_MODE_1,
-		   _MASKED_BIT_ENABLE(PIXEL_SUBSPAN_COLLECT_OPT_DISABLE));
-
-	/*
-	 * BSpec recommends 8x4 when MSAA is used,
-	 * however in practice 16x4 seems fastest.
-	 *
-	 * Note that PS/WM thread counts depend on the WIZ hashing
-	 * disable bit, which we don't touch here, but it's good
-	 * to keep in mind (see 3DSTATE_PS and 3DSTATE_WM).
-	 */
-	I915_WRITE(GEN7_GT_MODE,
-		   _MASKED_FIELD(GEN6_WIZ_HASHING_MASK, GEN6_WIZ_HASHING_16x4));
-
 	snpcr = I915_READ(GEN6_MBCUNIT_SNPCR);
 	snpcr &= ~GEN6_MBC_SNPCR_MASK;
 	snpcr |= GEN6_MBC_SNPCR_MED;


