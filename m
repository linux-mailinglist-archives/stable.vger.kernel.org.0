Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFFB9205E18
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 22:21:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389583AbgFWUTw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:19:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:36958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388689AbgFWUTv (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:19:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2DE5920E65;
        Tue, 23 Jun 2020 20:19:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592943590;
        bh=psH7cci59HLuz1YQJzScwCcn+DVBDzMbDRTwUpov0P8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qM3nYXnKjISA8Zra+kg0FG2i4CLvWz2q+vN9OzoMpOzZi/hXlfTRu6U6KWY7ehVM4
         c8XkUsO/2t/d4X4KbEZFq34OBpwv9sEpz/+TztgaGy8Z4WqJd2+cKYni0PtyS8mF4z
         ZqMe8r0h5RYchbIuY0Mj+gGkDB5nkuZRfKhmDaks=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>,
        Mika Kuoppala <mika.kuoppala@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Subject: [PATCH 5.7 452/477] drm/i915/gt: Move hsw GT workarounds from init_clock_gating to workarounds
Date:   Tue, 23 Jun 2020 21:57:29 +0200
Message-Id: <20200623195428.906522840@linuxfoundation.org>
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

commit ef50fa9bd17d13d0611e39e13b37bbd3e1ea50bf upstream.

Rescue the GT workarounds from being buried inside init_clock_gating so
that we remember to apply them after a GT reset, and that they are
included in our verification that the workarounds are applied.

v2: Leave HSW_SCRATCH to set an explicit value, not or in our disable
bit.

Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/2011
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Mika Kuoppala <mika.kuoppala@linux.intel.com>
Reviewed-by: Mika Kuoppala <mika.kuoppala@linux.intel.com>
Cc: stable@vger.kernel.org
Link: https://patchwork.freedesktop.org/patch/msgid/20200611093015.11370-1-chris@chris-wilson.co.uk
(cherry picked from commit f93ec5fb563779bda4501890b1854526de58e0f1)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/gt/intel_workarounds.c |   48 ++++++++++++++++++++++++++++
 drivers/gpu/drm/i915/intel_pm.c             |   39 +---------------------
 2 files changed, 50 insertions(+), 37 deletions(-)

--- a/drivers/gpu/drm/i915/gt/intel_workarounds.c
+++ b/drivers/gpu/drm/i915/gt/intel_workarounds.c
@@ -179,6 +179,12 @@ wa_write_or(struct i915_wa_list *wal, i9
 }
 
 static void
+wa_write_clr(struct i915_wa_list *wal, i915_reg_t reg, u32 clr)
+{
+	wa_write_masked_or(wal, reg, clr, 0);
+}
+
+static void
 wa_masked_en(struct i915_wa_list *wal, i915_reg_t reg, u32 val)
 {
 	wa_add(wal, reg, 0, _MASKED_BIT_ENABLE(val), val);
@@ -698,6 +704,46 @@ int intel_engine_emit_ctx_wa(struct i915
 }
 
 static void
+hsw_gt_workarounds_init(struct drm_i915_private *i915, struct i915_wa_list *wal)
+{
+	/* L3 caching of data atomics doesn't work -- disable it. */
+	wa_write(wal, HSW_SCRATCH1, HSW_SCRATCH1_L3_DATA_ATOMICS_DISABLE);
+
+	wa_add(wal,
+	       HSW_ROW_CHICKEN3, 0,
+	       _MASKED_BIT_ENABLE(HSW_ROW_CHICKEN3_L3_GLOBAL_ATOMICS_DISABLE),
+		0 /* XXX does this reg exist? */);
+
+	/* WaVSRefCountFullforceMissDisable:hsw */
+	wa_write_clr(wal, GEN7_FF_THREAD_MODE, GEN7_FF_VS_REF_CNT_FFME);
+
+	wa_masked_dis(wal,
+		      CACHE_MODE_0_GEN7,
+		      /* WaDisable_RenderCache_OperationalFlush:hsw */
+		      RC_OP_FLUSH_ENABLE |
+		      /* enable HiZ Raw Stall Optimization */
+		      HIZ_RAW_STALL_OPT_DISABLE);
+
+	/* WaDisable4x2SubspanOptimization:hsw */
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
+	/* WaSampleCChickenBitEnable:hsw */
+	wa_masked_en(wal, HALF_SLICE_CHICKEN3, HSW_SAMPLE_C_PERFORMANCE);
+}
+
+static void
 gen9_gt_workarounds_init(struct drm_i915_private *i915, struct i915_wa_list *wal)
 {
 	/* WaDisableKillLogic:bxt,skl,kbl */
@@ -974,6 +1020,8 @@ gt_init_workarounds(struct drm_i915_priv
 		bxt_gt_workarounds_init(i915, wal);
 	else if (IS_SKYLAKE(i915))
 		skl_gt_workarounds_init(i915, wal);
+	else if (IS_HASWELL(i915))
+		hsw_gt_workarounds_init(i915, wal);
 	else if (INTEL_GEN(i915) <= 8)
 		return;
 	else
--- a/drivers/gpu/drm/i915/intel_pm.c
+++ b/drivers/gpu/drm/i915/intel_pm.c
@@ -6992,45 +6992,10 @@ static void bdw_init_clock_gating(struct
 
 static void hsw_init_clock_gating(struct drm_i915_private *dev_priv)
 {
-	/* L3 caching of data atomics doesn't work -- disable it. */
-	I915_WRITE(HSW_SCRATCH1, HSW_SCRATCH1_L3_DATA_ATOMICS_DISABLE);
-	I915_WRITE(HSW_ROW_CHICKEN3,
-		   _MASKED_BIT_ENABLE(HSW_ROW_CHICKEN3_L3_GLOBAL_ATOMICS_DISABLE));
-
 	/* This is required by WaCatErrorRejectionIssue:hsw */
 	I915_WRITE(GEN7_SQ_CHICKEN_MBCUNIT_CONFIG,
-			I915_READ(GEN7_SQ_CHICKEN_MBCUNIT_CONFIG) |
-			GEN7_SQ_CHICKEN_MBCUNIT_SQINTMOB);
-
-	/* WaVSRefCountFullforceMissDisable:hsw */
-	I915_WRITE(GEN7_FF_THREAD_MODE,
-		   I915_READ(GEN7_FF_THREAD_MODE) & ~GEN7_FF_VS_REF_CNT_FFME);
-
-	/* WaDisable_RenderCache_OperationalFlush:hsw */
-	I915_WRITE(CACHE_MODE_0_GEN7, _MASKED_BIT_DISABLE(RC_OP_FLUSH_ENABLE));
-
-	/* enable HiZ Raw Stall Optimization */
-	I915_WRITE(CACHE_MODE_0_GEN7,
-		   _MASKED_BIT_DISABLE(HIZ_RAW_STALL_OPT_DISABLE));
-
-	/* WaDisable4x2SubspanOptimization:hsw */
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
-	/* WaSampleCChickenBitEnable:hsw */
-	I915_WRITE(HALF_SLICE_CHICKEN3,
-		   _MASKED_BIT_ENABLE(HSW_SAMPLE_C_PERFORMANCE));
+		   I915_READ(GEN7_SQ_CHICKEN_MBCUNIT_CONFIG) |
+		   GEN7_SQ_CHICKEN_MBCUNIT_SQINTMOB);
 
 	/* WaSwitchSolVfFArbitrationPriority:hsw */
 	I915_WRITE(GAM_ECOCHK, I915_READ(GAM_ECOCHK) | HSW_ECOCHK_ARB_PRIO_SOL);


