Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FCB620649A
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:31:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390723AbgFWVYT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 17:24:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:37270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389846AbgFWUUE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:20:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E383C2073E;
        Tue, 23 Jun 2020 20:20:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592943603;
        bh=HMg1QS1/JVY9SN7dd5Y7ZZMcBaJuDjGJVu7uqsilqDs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hlzGrdD0QgM/q3Za83wHIOEbH05rESW1IBbwP5QSiFmYepaZYU9ksba9wcl5eOqXm
         3eKf/aVX5X5xm6Zkfk8QsBgV4+/oo7OVyc9Nopot+frDAYcvkoZnYenowrkTEefrxF
         lDY0+5VpCn5LfXUTyw1dqdgJrQQxIbi/ytr+3gfk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>,
        Mika Kuoppala <mika.kuoppala@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Subject: [PATCH 5.7 456/477] drm/i915/gt: Move vlv GT workarounds from init_clock_gating to workarounds
Date:   Tue, 23 Jun 2020 21:57:33 +0200
Message-Id: <20200623195429.105001888@linuxfoundation.org>
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

commit 695a2b11649e99bbf15d278042247042c42b8728 upstream.

Rescue the GT workarounds from being buried inside init_clock_gating so
that we remember to apply them after a GT reset, and that they are
included in our verification that the workarounds are applied.

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Reviewed-by: Mika Kuoppala <mika.kuoppala@linux.intel.com>
Cc: stable@vger.kernel.org
Link: https://patchwork.freedesktop.org/patch/msgid/20200611080140.30228-3-chris@chris-wilson.co.uk
(cherry picked from commit 7331c356b6d2d8a01422cacab27478a1dba9fa2a)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/gt/intel_workarounds.c |   59 +++++++++++++++++++++++++++
 drivers/gpu/drm/i915/intel_pm.c             |   61 ----------------------------
 2 files changed, 59 insertions(+), 61 deletions(-)

--- a/drivers/gpu/drm/i915/gt/intel_workarounds.c
+++ b/drivers/gpu/drm/i915/gt/intel_workarounds.c
@@ -815,6 +815,63 @@ ivb_gt_workarounds_init(struct drm_i915_
 }
 
 static void
+vlv_gt_workarounds_init(struct drm_i915_private *i915, struct i915_wa_list *wal)
+{
+	/* WaDisableEarlyCull:vlv */
+	wa_masked_en(wal, _3D_CHICKEN3, _3D_CHICKEN_SF_DISABLE_OBJEND_CULL);
+
+	/* WaPsdDispatchEnable:vlv */
+	/* WaDisablePSDDualDispatchEnable:vlv */
+	wa_masked_en(wal,
+		     GEN7_HALF_SLICE_CHICKEN1,
+		     GEN7_MAX_PS_THREAD_DEP |
+		     GEN7_PSD_SINGLE_PORT_DISPATCH_ENABLE);
+
+	/* WaDisable_RenderCache_OperationalFlush:vlv */
+	wa_masked_dis(wal, CACHE_MODE_0_GEN7, RC_OP_FLUSH_ENABLE);
+
+	/* WaForceL3Serialization:vlv */
+	wa_write_clr(wal, GEN7_L3SQCREG4, L3SQ_URB_READ_CAM_MATCH_DISABLE);
+
+	/*
+	 * WaVSThreadDispatchOverride:ivb,vlv
+	 *
+	 * This actually overrides the dispatch
+	 * mode for all thread types.
+	 */
+	wa_write_masked_or(wal,
+			   GEN7_FF_THREAD_MODE,
+			   GEN7_FF_SCHED_MASK,
+			   GEN7_FF_TS_SCHED_HW |
+			   GEN7_FF_VS_SCHED_HW |
+			   GEN7_FF_DS_SCHED_HW);
+
+	/*
+	 * BSpec says this must be set, even though
+	 * WaDisable4x2SubspanOptimization isn't listed for VLV.
+	 */
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
+
+	/*
+	 * WaIncreaseL3CreditsForVLVB0:vlv
+	 * This is the hardware default actually.
+	 */
+	wa_write(wal, GEN7_L3SQCREG1, VLV_B0_WA_L3SQCREG1_VALUE);
+}
+
+static void
 hsw_gt_workarounds_init(struct drm_i915_private *i915, struct i915_wa_list *wal)
 {
 	/* L3 caching of data atomics doesn't work -- disable it. */
@@ -1133,6 +1190,8 @@ gt_init_workarounds(struct drm_i915_priv
 		skl_gt_workarounds_init(i915, wal);
 	else if (IS_HASWELL(i915))
 		hsw_gt_workarounds_init(i915, wal);
+	else if (IS_VALLEYVIEW(i915))
+		vlv_gt_workarounds_init(i915, wal);
 	else if (IS_IVYBRIDGE(i915))
 		ivb_gt_workarounds_init(i915, wal);
 	else if (IS_GEN(i915, 6))
--- a/drivers/gpu/drm/i915/intel_pm.c
+++ b/drivers/gpu/drm/i915/intel_pm.c
@@ -6706,24 +6706,6 @@ static void gen6_init_clock_gating(struc
 	gen6_check_mch_setup(dev_priv);
 }
 
-static void gen7_setup_fixed_func_scheduler(struct drm_i915_private *dev_priv)
-{
-	u32 reg = I915_READ(GEN7_FF_THREAD_MODE);
-
-	/*
-	 * WaVSThreadDispatchOverride:ivb,vlv
-	 *
-	 * This actually overrides the dispatch
-	 * mode for all thread types.
-	 */
-	reg &= ~GEN7_FF_SCHED_MASK;
-	reg |= GEN7_FF_TS_SCHED_HW;
-	reg |= GEN7_FF_VS_SCHED_HW;
-	reg |= GEN7_FF_DS_SCHED_HW;
-
-	I915_WRITE(GEN7_FF_THREAD_MODE, reg);
-}
-
 static void lpt_init_clock_gating(struct drm_i915_private *dev_priv)
 {
 	/*
@@ -7009,28 +6991,11 @@ static void ivb_init_clock_gating(struct
 
 static void vlv_init_clock_gating(struct drm_i915_private *dev_priv)
 {
-	/* WaDisableEarlyCull:vlv */
-	I915_WRITE(_3D_CHICKEN3,
-		   _MASKED_BIT_ENABLE(_3D_CHICKEN_SF_DISABLE_OBJEND_CULL));
-
 	/* WaDisableBackToBackFlipFix:vlv */
 	I915_WRITE(IVB_CHICKEN3,
 		   CHICKEN3_DGMG_REQ_OUT_FIX_DISABLE |
 		   CHICKEN3_DGMG_DONE_FIX_DISABLE);
 
-	/* WaPsdDispatchEnable:vlv */
-	/* WaDisablePSDDualDispatchEnable:vlv */
-	I915_WRITE(GEN7_HALF_SLICE_CHICKEN1,
-		   _MASKED_BIT_ENABLE(GEN7_MAX_PS_THREAD_DEP |
-				      GEN7_PSD_SINGLE_PORT_DISPATCH_ENABLE));
-
-	/* WaDisable_RenderCache_OperationalFlush:vlv */
-	I915_WRITE(CACHE_MODE_0_GEN7, _MASKED_BIT_DISABLE(RC_OP_FLUSH_ENABLE));
-
-	/* WaForceL3Serialization:vlv */
-	I915_WRITE(GEN7_L3SQCREG4, I915_READ(GEN7_L3SQCREG4) &
-		   ~L3SQ_URB_READ_CAM_MATCH_DISABLE);
-
 	/* WaDisableDopClockGating:vlv */
 	I915_WRITE(GEN7_ROW_CHICKEN2,
 		   _MASKED_BIT_ENABLE(DOP_CLOCK_GATING_DISABLE));
@@ -7040,8 +7005,6 @@ static void vlv_init_clock_gating(struct
 		   I915_READ(GEN7_SQ_CHICKEN_MBCUNIT_CONFIG) |
 		   GEN7_SQ_CHICKEN_MBCUNIT_SQINTMOB);
 
-	gen7_setup_fixed_func_scheduler(dev_priv);
-
 	/*
 	 * According to the spec, bit 13 (RCZUNIT) must be set on IVB.
 	 * This implements the WaDisableRCZUnitClockGating:vlv workaround.
@@ -7056,30 +7019,6 @@ static void vlv_init_clock_gating(struct
 		   I915_READ(GEN7_UCGCTL4) | GEN7_L3BANK2X_CLOCK_GATE_DISABLE);
 
 	/*
-	 * BSpec says this must be set, even though
-	 * WaDisable4x2SubspanOptimization isn't listed for VLV.
-	 */
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
-	/*
-	 * WaIncreaseL3CreditsForVLVB0:vlv
-	 * This is the hardware default actually.
-	 */
-	I915_WRITE(GEN7_L3SQCREG1, VLV_B0_WA_L3SQCREG1_VALUE);
-
-	/*
 	 * WaDisableVLVClockGating_VBIIssue:vlv
 	 * Disable clock gating on th GCFG unit to prevent a delay
 	 * in the reporting of vblank events.


