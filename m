Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFF9A6AEA59
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:33:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229842AbjCGRdK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:33:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231258AbjCGRcl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:32:41 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 733BB7EA26
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:28:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A79D3CE1C5F
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:28:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93A8EC433D2;
        Tue,  7 Mar 2023 17:28:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678210094;
        bh=houy6HVG7rMP6saeQJCeza3mg+jcsJPr14kB6mbro3A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WY0XaQ26+IzhbqMrXmUaWRFLVwDqAbte5maU5PZsqHt+2BEreBHP2ysm998a6uXHj
         Gyyoto3BAn/um4LVsqPtFOT+G8TDy3A8U7NKmTZjywlUEaiv1y/RJQtwiuD0W4vSxs
         eSIsd3nPCc4UdhanB3qxGK0s01xPFDkPfM6bXHxw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Matt Roper <matthew.d.roper@intel.com>,
        Matt Atwood <matthew.s.atwood@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Radhakrishna Sripada <radhakrishna.sripada@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0389/1001] drm/i915/mtl: Add initial gt workarounds
Date:   Tue,  7 Mar 2023 17:52:41 +0100
Message-Id: <20230307170038.241278069@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matt Roper <matthew.d.roper@intel.com>

[ Upstream commit 41bb543f5598fb44e0e8dbd723f5821be83b466b ]

This patch introduces initial gt workarounds for the MTL platform.

v2: drop redundant/stale comments specifying wa platforms affected
(Lucas).
v3: drop additional redundant stale comments (MattR)

Bspec: 66622

Signed-off-by: Matt Roper <matthew.d.roper@intel.com>
Signed-off-by: Matt Atwood <matthew.s.atwood@intel.com>
Reviewed-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Radhakrishna Sripada <radhakrishna.sripada@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230105234408.277750-1-matthew.s.atwood@intel.com
Stable-dep-of: 49cbda6386ef ("drm/i915/xehp: GAM registers don't need to be re-applied on engine resets")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/gt/intel_engine_cs.c     |   6 +-
 .../drm/i915/gt/intel_execlists_submission.c  |   6 +-
 drivers/gpu/drm/i915/gt/intel_gt_mcr.c        |  11 +-
 drivers/gpu/drm/i915/gt/intel_gt_regs.h       |   4 +
 drivers/gpu/drm/i915/gt/intel_workarounds.c   | 115 +++++++++++++-----
 drivers/gpu/drm/i915/gt/uc/intel_guc.c        |   9 +-
 .../gpu/drm/i915/gt/uc/intel_guc_submission.c |   8 +-
 drivers/gpu/drm/i915/intel_device_info.c      |   6 +
 8 files changed, 123 insertions(+), 42 deletions(-)

diff --git a/drivers/gpu/drm/i915/gt/intel_engine_cs.c b/drivers/gpu/drm/i915/gt/intel_engine_cs.c
index d37931e16fd9b..34b0a9dadce4f 100644
--- a/drivers/gpu/drm/i915/gt/intel_engine_cs.c
+++ b/drivers/gpu/drm/i915/gt/intel_engine_cs.c
@@ -1476,10 +1476,12 @@ static int __intel_engine_stop_cs(struct intel_engine_cs *engine,
 	intel_uncore_write_fw(uncore, mode, _MASKED_BIT_ENABLE(STOP_RING));
 
 	/*
-	 * Wa_22011802037 : gen11, gen12, Prior to doing a reset, ensure CS is
+	 * Wa_22011802037: Prior to doing a reset, ensure CS is
 	 * stopped, set ring stop bit and prefetch disable bit to halt CS
 	 */
-	if (IS_GRAPHICS_VER(engine->i915, 11, 12))
+	if (IS_MTL_GRAPHICS_STEP(engine->i915, M, STEP_A0, STEP_B0) ||
+	    (GRAPHICS_VER(engine->i915) >= 11 &&
+	    GRAPHICS_VER_FULL(engine->i915) < IP_VER(12, 70)))
 		intel_uncore_write_fw(uncore, RING_MODE_GEN7(engine->mmio_base),
 				      _MASKED_BIT_ENABLE(GEN12_GFX_PREFETCH_DISABLE));
 
diff --git a/drivers/gpu/drm/i915/gt/intel_execlists_submission.c b/drivers/gpu/drm/i915/gt/intel_execlists_submission.c
index 21cb5b69d82eb..3c573d41d4046 100644
--- a/drivers/gpu/drm/i915/gt/intel_execlists_submission.c
+++ b/drivers/gpu/drm/i915/gt/intel_execlists_submission.c
@@ -2989,10 +2989,12 @@ static void execlists_reset_prepare(struct intel_engine_cs *engine)
 	intel_engine_stop_cs(engine);
 
 	/*
-	 * Wa_22011802037:gen11/gen12: In addition to stopping the cs, we need
+	 * Wa_22011802037: In addition to stopping the cs, we need
 	 * to wait for any pending mi force wakeups
 	 */
-	if (IS_GRAPHICS_VER(engine->i915, 11, 12))
+	if (IS_MTL_GRAPHICS_STEP(engine->i915, M, STEP_A0, STEP_B0) ||
+	    (GRAPHICS_VER(engine->i915) >= 11 &&
+	    GRAPHICS_VER_FULL(engine->i915) < IP_VER(12, 70)))
 		intel_engine_wait_for_pending_mi_fw(engine);
 
 	engine->execlists.reset_ccid = active_ccid(engine);
diff --git a/drivers/gpu/drm/i915/gt/intel_gt_mcr.c b/drivers/gpu/drm/i915/gt/intel_gt_mcr.c
index ea86c1ab5dc56..58ea3325bbdaa 100644
--- a/drivers/gpu/drm/i915/gt/intel_gt_mcr.c
+++ b/drivers/gpu/drm/i915/gt/intel_gt_mcr.c
@@ -162,8 +162,15 @@ void intel_gt_mcr_init(struct intel_gt *gt)
 	if (MEDIA_VER(i915) >= 13 && gt->type == GT_MEDIA) {
 		gt->steering_table[OADDRM] = xelpmp_oaddrm_steering_table;
 	} else if (GRAPHICS_VER_FULL(i915) >= IP_VER(12, 70)) {
-		fuse = REG_FIELD_GET(GT_L3_EXC_MASK,
-				     intel_uncore_read(gt->uncore, XEHP_FUSE4));
+		/* Wa_14016747170 */
+		if (IS_MTL_GRAPHICS_STEP(i915, M, STEP_A0, STEP_B0) ||
+		    IS_MTL_GRAPHICS_STEP(i915, P, STEP_A0, STEP_B0))
+			fuse = REG_FIELD_GET(MTL_GT_L3_EXC_MASK,
+					     intel_uncore_read(gt->uncore,
+							       MTL_GT_ACTIVITY_FACTOR));
+		else
+			fuse = REG_FIELD_GET(GT_L3_EXC_MASK,
+					     intel_uncore_read(gt->uncore, XEHP_FUSE4));
 
 		/*
 		 * Despite the register field being named "exclude mask" the
diff --git a/drivers/gpu/drm/i915/gt/intel_gt_regs.h b/drivers/gpu/drm/i915/gt/intel_gt_regs.h
index a5454af2a9cfd..c525fc07a9bcb 100644
--- a/drivers/gpu/drm/i915/gt/intel_gt_regs.h
+++ b/drivers/gpu/drm/i915/gt/intel_gt_regs.h
@@ -413,6 +413,7 @@
 #define   TBIMR_FAST_CLIP			REG_BIT(5)
 
 #define VFLSKPD					MCR_REG(0x62a8)
+#define   VF_PREFETCH_TLB_DIS			REG_BIT(5)
 #define   DIS_OVER_FETCH_CACHE			REG_BIT(1)
 #define   DIS_MULT_MISS_RD_SQUASH		REG_BIT(0)
 
@@ -1528,6 +1529,9 @@
 
 #define MTL_MEDIA_MC6				_MMIO(0x138048)
 
+#define MTL_GT_ACTIVITY_FACTOR			_MMIO(0x138010)
+#define   MTL_GT_L3_EXC_MASK			REG_GENMASK(5, 3)
+
 #define GEN6_GT_THREAD_STATUS_REG		_MMIO(0x13805c)
 #define   GEN6_GT_THREAD_STATUS_CORE_MASK	0x7
 
diff --git a/drivers/gpu/drm/i915/gt/intel_workarounds.c b/drivers/gpu/drm/i915/gt/intel_workarounds.c
index a0740308555d8..09d533f6b962c 100644
--- a/drivers/gpu/drm/i915/gt/intel_workarounds.c
+++ b/drivers/gpu/drm/i915/gt/intel_workarounds.c
@@ -786,6 +786,32 @@ static void dg2_ctx_workarounds_init(struct intel_engine_cs *engine,
 	wa_masked_en(wal, CACHE_MODE_1, MSAA_OPTIMIZATION_REDUC_DISABLE);
 }
 
+static void mtl_ctx_workarounds_init(struct intel_engine_cs *engine,
+				     struct i915_wa_list *wal)
+{
+	struct drm_i915_private *i915 = engine->i915;
+
+	if (IS_MTL_GRAPHICS_STEP(i915, M, STEP_A0, STEP_B0) ||
+	    IS_MTL_GRAPHICS_STEP(i915, P, STEP_A0, STEP_B0)) {
+		/* Wa_14014947963 */
+		wa_masked_field_set(wal, VF_PREEMPTION,
+				    PREEMPTION_VERTEX_COUNT, 0x4000);
+
+		/* Wa_16013271637 */
+		wa_mcr_masked_en(wal, XEHP_SLICE_COMMON_ECO_CHICKEN1,
+				 MSC_MSAA_REODER_BUF_BYPASS_DISABLE);
+
+		/* Wa_18019627453 */
+		wa_mcr_masked_en(wal, VFLSKPD, VF_PREFETCH_TLB_DIS);
+
+		/* Wa_18018764978 */
+		wa_masked_en(wal, PSS_MODE2, SCOREBOARD_STALL_FLUSH_CONTROL);
+	}
+
+	/* Wa_18019271663 */
+	wa_masked_en(wal, CACHE_MODE_1, MSAA_OPTIMIZATION_REDUC_DISABLE);
+}
+
 static void fakewa_disable_nestedbb_mode(struct intel_engine_cs *engine,
 					 struct i915_wa_list *wal)
 {
@@ -872,7 +898,9 @@ __intel_engine_init_ctx_wa(struct intel_engine_cs *engine,
 	if (engine->class != RENDER_CLASS)
 		goto done;
 
-	if (IS_PONTEVECCHIO(i915))
+	if (IS_METEORLAKE(i915))
+		mtl_ctx_workarounds_init(engine, wal);
+	else if (IS_PONTEVECCHIO(i915))
 		; /* noop; none at this time */
 	else if (IS_DG2(i915))
 		dg2_ctx_workarounds_init(engine, wal);
@@ -1635,7 +1663,10 @@ pvc_gt_workarounds_init(struct intel_gt *gt, struct i915_wa_list *wal)
 static void
 xelpg_gt_workarounds_init(struct intel_gt *gt, struct i915_wa_list *wal)
 {
-	/* FIXME: Actual workarounds will be added in future patch(es) */
+	/* Wa_14014830051 */
+	if (IS_MTL_GRAPHICS_STEP(gt->i915, M, STEP_A0, STEP_B0) ||
+	    IS_MTL_GRAPHICS_STEP(gt->i915, P, STEP_A0, STEP_B0))
+		wa_mcr_write_clr(wal, SARB_CHICKEN1, COMP_CKN_IN);
 
 	/*
 	 * Unlike older platforms, we no longer setup implicit steering here;
@@ -2171,7 +2202,9 @@ void intel_engine_init_whitelist(struct intel_engine_cs *engine)
 
 	wa_init_start(w, engine->gt, "whitelist", engine->name);
 
-	if (IS_PONTEVECCHIO(i915))
+	if (IS_METEORLAKE(i915))
+		; /* noop; none at this time */
+	else if (IS_PONTEVECCHIO(i915))
 		pvc_whitelist_build(engine);
 	else if (IS_DG2(i915))
 		dg2_whitelist_build(engine);
@@ -2281,6 +2314,34 @@ rcs_engine_wa_init(struct intel_engine_cs *engine, struct i915_wa_list *wal)
 {
 	struct drm_i915_private *i915 = engine->i915;
 
+	if (IS_MTL_GRAPHICS_STEP(i915, M, STEP_A0, STEP_B0) ||
+	    IS_MTL_GRAPHICS_STEP(i915, P, STEP_A0, STEP_B0)) {
+		/* Wa_22014600077 */
+		wa_mcr_masked_en(wal, GEN10_CACHE_MODE_SS,
+				 ENABLE_EU_COUNT_FOR_TDL_FLUSH);
+	}
+
+	if (IS_MTL_GRAPHICS_STEP(i915, M, STEP_A0, STEP_B0) ||
+	    IS_MTL_GRAPHICS_STEP(i915, P, STEP_A0, STEP_B0) ||
+	    IS_DG2_GRAPHICS_STEP(i915, G10, STEP_B0, STEP_FOREVER) ||
+	    IS_DG2_G11(i915) || IS_DG2_G12(i915)) {
+		/* Wa_1509727124 */
+		wa_mcr_masked_en(wal, GEN10_SAMPLER_MODE,
+				 SC_DISABLE_POWER_OPTIMIZATION_EBB);
+
+		/* Wa_22013037850 */
+		wa_mcr_write_or(wal, LSC_CHICKEN_BIT_0_UDW,
+				DISABLE_128B_EVICTION_COMMAND_UDW);
+	}
+
+	if (IS_DG2_GRAPHICS_STEP(i915, G10, STEP_B0, STEP_FOREVER) ||
+	    IS_DG2_G11(i915) || IS_DG2_G12(i915) ||
+	    IS_MTL_GRAPHICS_STEP(i915, M, STEP_A0, STEP_B0)) {
+		/* Wa_22012856258 */
+		wa_mcr_masked_en(wal, GEN8_ROW_CHICKEN2,
+				 GEN12_DISABLE_READ_SUPPRESSION);
+	}
+
 	if (IS_DG2(i915)) {
 		/* Wa_1509235366:dg2 */
 		wa_write_or(wal, GEN12_GAMCNTRL_CTRL, INVALIDATION_BROADCAST_MODE_DIS |
@@ -2292,13 +2353,6 @@ rcs_engine_wa_init(struct intel_engine_cs *engine, struct i915_wa_list *wal)
 		wa_mcr_masked_en(wal, GEN8_ROW_CHICKEN2, GEN12_ENABLE_LARGE_GRF_MODE);
 	}
 
-	if (IS_DG2_GRAPHICS_STEP(i915, G10, STEP_B0, STEP_FOREVER) ||
-	    IS_DG2_G11(i915) || IS_DG2_G12(i915)) {
-		/* Wa_1509727124:dg2 */
-		wa_mcr_masked_en(wal, GEN10_SAMPLER_MODE,
-				 SC_DISABLE_POWER_OPTIMIZATION_EBB);
-	}
-
 	if (IS_DG2_GRAPHICS_STEP(i915, G10, STEP_A0, STEP_B0) ||
 	    IS_DG2_GRAPHICS_STEP(i915, G11, STEP_A0, STEP_B0)) {
 		/* Wa_14012419201:dg2 */
@@ -2330,14 +2384,6 @@ rcs_engine_wa_init(struct intel_engine_cs *engine, struct i915_wa_list *wal)
 
 	if (IS_DG2_GRAPHICS_STEP(i915, G10, STEP_B0, STEP_FOREVER) ||
 	    IS_DG2_G11(i915) || IS_DG2_G12(i915)) {
-		/* Wa_22013037850:dg2 */
-		wa_mcr_write_or(wal, LSC_CHICKEN_BIT_0_UDW,
-				DISABLE_128B_EVICTION_COMMAND_UDW);
-
-		/* Wa_22012856258:dg2 */
-		wa_mcr_masked_en(wal, GEN8_ROW_CHICKEN2,
-				 GEN12_DISABLE_READ_SUPPRESSION);
-
 		/*
 		 * Wa_22010960976:dg2
 		 * Wa_14013347512:dg2
@@ -2950,6 +2996,27 @@ general_render_compute_wa_init(struct intel_engine_cs *engine, struct i915_wa_li
 
 	add_render_compute_tuning_settings(i915, wal);
 
+	if (IS_MTL_GRAPHICS_STEP(i915, M, STEP_A0, STEP_B0) ||
+	    IS_MTL_GRAPHICS_STEP(i915, P, STEP_A0, STEP_B0) ||
+	    IS_PONTEVECCHIO(i915) ||
+	    IS_DG2(i915)) {
+		/* Wa_18018781329 */
+		wa_mcr_write_or(wal, RENDER_MOD_CTRL, FORCE_MISS_FTLB);
+		wa_mcr_write_or(wal, COMP_MOD_CTRL, FORCE_MISS_FTLB);
+		wa_mcr_write_or(wal, VDBX_MOD_CTRL, FORCE_MISS_FTLB);
+		wa_mcr_write_or(wal, VEBX_MOD_CTRL, FORCE_MISS_FTLB);
+
+		/* Wa_22014226127 */
+		wa_mcr_write_or(wal, LSC_CHICKEN_BIT_0, DISABLE_D8_D16_COASLESCE);
+	}
+
+	if (IS_MTL_GRAPHICS_STEP(i915, M, STEP_A0, STEP_B0) ||
+	    IS_MTL_GRAPHICS_STEP(i915, P, STEP_A0, STEP_B0) ||
+	    IS_DG2(i915)) {
+		/* Wa_18017747507 */
+		wa_masked_en(wal, VFG_PREEMPTION_CHICKEN, POLYGON_TRIFAN_LINELOOP_DISABLE);
+	}
+
 	if (IS_PONTEVECCHIO(i915)) {
 		/* Wa_16016694945 */
 		wa_masked_en(wal, XEHPC_LNCFMISCCFGREG0, XEHPC_OVRLSCCC);
@@ -2991,17 +3058,8 @@ general_render_compute_wa_init(struct intel_engine_cs *engine, struct i915_wa_li
 		/* Wa_14015227452:dg2,pvc */
 		wa_mcr_masked_en(wal, GEN9_ROW_CHICKEN4, XEHP_DIS_BBL_SYSPIPE);
 
-		/* Wa_22014226127:dg2,pvc */
-		wa_mcr_write_or(wal, LSC_CHICKEN_BIT_0, DISABLE_D8_D16_COASLESCE);
-
 		/* Wa_16015675438:dg2,pvc */
 		wa_masked_en(wal, FF_SLICE_CS_CHICKEN2, GEN12_PERF_FIX_BALANCING_CFE_DISABLE);
-
-		/* Wa_18018781329:dg2,pvc */
-		wa_mcr_write_or(wal, RENDER_MOD_CTRL, FORCE_MISS_FTLB);
-		wa_mcr_write_or(wal, COMP_MOD_CTRL, FORCE_MISS_FTLB);
-		wa_mcr_write_or(wal, VDBX_MOD_CTRL, FORCE_MISS_FTLB);
-		wa_mcr_write_or(wal, VEBX_MOD_CTRL, FORCE_MISS_FTLB);
 	}
 
 	if (IS_DG2(i915)) {
@@ -3010,9 +3068,6 @@ general_render_compute_wa_init(struct intel_engine_cs *engine, struct i915_wa_li
 		 * Wa_22015475538:dg2
 		 */
 		wa_mcr_write_or(wal, LSC_CHICKEN_BIT_0_UDW, DIS_CHAIN_2XSIMD8);
-
-		/* Wa_18017747507:dg2 */
-		wa_masked_en(wal, VFG_PREEMPTION_CHICKEN, POLYGON_TRIFAN_LINELOOP_DISABLE);
 	}
 }
 
diff --git a/drivers/gpu/drm/i915/gt/uc/intel_guc.c b/drivers/gpu/drm/i915/gt/uc/intel_guc.c
index 52aede324788e..ca940a00e84a3 100644
--- a/drivers/gpu/drm/i915/gt/uc/intel_guc.c
+++ b/drivers/gpu/drm/i915/gt/uc/intel_guc.c
@@ -274,8 +274,9 @@ static u32 guc_ctl_wa_flags(struct intel_guc *guc)
 	if (IS_DG2_GRAPHICS_STEP(gt->i915, G10, STEP_A0, STEP_B0))
 		flags |= GUC_WA_GAM_CREDITS;
 
-	/* Wa_14014475959:dg2 */
-	if (IS_DG2(gt->i915))
+	/* Wa_14014475959 */
+	if (IS_MTL_GRAPHICS_STEP(gt->i915, M, STEP_A0, STEP_B0) ||
+	    IS_DG2(gt->i915))
 		flags |= GUC_WA_HOLD_CCS_SWITCHOUT;
 
 	/*
@@ -289,7 +290,9 @@ static u32 guc_ctl_wa_flags(struct intel_guc *guc)
 		flags |= GUC_WA_DUAL_QUEUE;
 
 	/* Wa_22011802037: graphics version 11/12 */
-	if (IS_GRAPHICS_VER(gt->i915, 11, 12))
+	if (IS_MTL_GRAPHICS_STEP(gt->i915, M, STEP_A0, STEP_B0) ||
+	    (GRAPHICS_VER(gt->i915) >= 11 &&
+	    GRAPHICS_VER_FULL(gt->i915) < IP_VER(12, 70)))
 		flags |= GUC_WA_PRE_PARSER;
 
 	/* Wa_16011777198:dg2 */
diff --git a/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c b/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c
index c10977cb06b97..ddf071865adc5 100644
--- a/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c
+++ b/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c
@@ -1621,7 +1621,7 @@ static void guc_engine_reset_prepare(struct intel_engine_cs *engine)
 	intel_engine_stop_cs(engine);
 
 	/*
-	 * Wa_22011802037:gen11/gen12: In addition to stopping the cs, we need
+	 * Wa_22011802037: In addition to stopping the cs, we need
 	 * to wait for any pending mi force wakeups
 	 */
 	intel_engine_wait_for_pending_mi_fw(engine);
@@ -4203,8 +4203,10 @@ static void guc_default_vfuncs(struct intel_engine_cs *engine)
 	engine->flags |= I915_ENGINE_HAS_TIMESLICES;
 
 	/* Wa_14014475959:dg2 */
-	if (IS_DG2(engine->i915) && engine->class == COMPUTE_CLASS)
-		engine->flags |= I915_ENGINE_USES_WA_HOLD_CCS_SWITCHOUT;
+	if (engine->class == COMPUTE_CLASS)
+		if (IS_MTL_GRAPHICS_STEP(engine->i915, M, STEP_A0, STEP_B0) ||
+		    IS_DG2(engine->i915))
+			engine->flags |= I915_ENGINE_USES_WA_HOLD_CCS_SWITCHOUT;
 
 	/*
 	 * TODO: GuC supports timeslicing and semaphores as well, but they're
diff --git a/drivers/gpu/drm/i915/intel_device_info.c b/drivers/gpu/drm/i915/intel_device_info.c
index 849baf6c3b3c6..05e90d09b2081 100644
--- a/drivers/gpu/drm/i915/intel_device_info.c
+++ b/drivers/gpu/drm/i915/intel_device_info.c
@@ -343,6 +343,12 @@ static void intel_ipver_early_init(struct drm_i915_private *i915)
 
 	ip_ver_read(i915, i915_mmio_reg_offset(GMD_ID_GRAPHICS),
 		    &runtime->graphics.ip);
+	/* Wa_22012778468 */
+	if (runtime->graphics.ip.ver == 0x0 &&
+	    INTEL_INFO(i915)->platform == INTEL_METEORLAKE) {
+		RUNTIME_INFO(i915)->graphics.ip.ver = 12;
+		RUNTIME_INFO(i915)->graphics.ip.rel = 70;
+	}
 	ip_ver_read(i915, i915_mmio_reg_offset(GMD_ID_DISPLAY),
 		    &runtime->display.ip);
 	ip_ver_read(i915, i915_mmio_reg_offset(GMD_ID_MEDIA),
-- 
2.39.2



