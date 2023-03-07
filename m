Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD6CC6AEA30
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:31:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229527AbjCGRbb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:31:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231562AbjCGRbR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:31:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09EA698870
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:26:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 72A88614FF
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:26:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68C91C433D2;
        Tue,  7 Mar 2023 17:26:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678209991;
        bh=7vb08dHt6veTE+xOw1fLVppmtl4lbJMFY7dLQR2TgXI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VS9/TslsR4fqxNi0Vj7qhRZw6IjDX3SbMb8Syhipwd8Mo6FSPLjTTpLKMIv2s5eZf
         TPWOnGYXRniGCAzZYVF2qSWLgEmdbn3xVSkplHyezy69E73LHBOeVIZVhpGGZSouUH
         TvEtaFSviFuYCmIOyY46DcakaRnPend1NRINyMxM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Gustavo Sousa <gustavo.sousa@intel.com>,
        Matt Roper <matthew.d.roper@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0390/1001] drm/i915/xehp: GAM registers dont need to be re-applied on engine resets
Date:   Tue,  7 Mar 2023 17:52:42 +0100
Message-Id: <20230307170038.282986692@linuxfoundation.org>
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

[ Upstream commit 49cbda6386efc5f023f396dca087aaba5d4f885e ]

Register reset characteristics (i.e., whether the register maintains or
loses its value on engine reset) is an important factor that determines
which wa_list we want to add workarounds to.  We recently found out that
the bspec documentation for the Xe_HP's "GAM" registers in the 0xC800 -
0xCFFF range was misleading; these registers do not actually lose their
value on engine resets as the documentation implied.  This means there's
no need to re-apply workarounds touching these registers after a reset,
and the corresponding workarounds should be moved from the 'engine'
lists back to the 'gt' list.

v2:
 - Don't add Wa_18018781329 to xehpsdv; the original condition didn't
   include that platform.  (Gustavo)
 - Move the MTL code to the GT function as-is for now; we'll take care
   of the additional fixes needed in a follow-up patch.

Cc: Gustavo Sousa <gustavo.sousa@intel.com>
Fixes: edf176f48d87 ("drm/i915/dg2: Move misplaced 'ctx' & 'gt' wa's to engine wa list")
Fixes: b2006061ae28 ("drm/i915/xehpsdv: Move render/compute engine reset domains related workarounds")
Fixes: 41bb543f5598 ("drm/i915/mtl: Add initial gt workarounds")
Signed-off-by: Matt Roper <matthew.d.roper@intel.com>
Reviewed-by: Gustavo Sousa <gustavo.sousa@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230125234159.3015385-1-matthew.d.roper@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/gt/intel_workarounds.c | 77 ++++++++++++---------
 1 file changed, 44 insertions(+), 33 deletions(-)

diff --git a/drivers/gpu/drm/i915/gt/intel_workarounds.c b/drivers/gpu/drm/i915/gt/intel_workarounds.c
index 09d533f6b962c..9932d748b9d7b 100644
--- a/drivers/gpu/drm/i915/gt/intel_workarounds.c
+++ b/drivers/gpu/drm/i915/gt/intel_workarounds.c
@@ -1550,6 +1550,13 @@ xehpsdv_gt_workarounds_init(struct intel_gt *gt, struct i915_wa_list *wal)
 
 	/* Wa_14011060649:xehpsdv */
 	wa_14011060649(gt, wal);
+
+	/* Wa_14012362059:xehpsdv */
+	wa_mcr_write_or(wal, XEHP_MERT_MOD_CTRL, FORCE_MISS_FTLB);
+
+	/* Wa_14014368820:xehpsdv */
+	wa_write_or(wal, GEN12_GAMCNTRL_CTRL,
+		    INVALIDATION_BROADCAST_MODE_DIS | GLOBAL_INVALIDATION_MODE);
 }
 
 static void
@@ -1590,6 +1597,12 @@ dg2_gt_workarounds_init(struct intel_gt *gt, struct i915_wa_list *wal)
 				DSS_ROUTER_CLKGATE_DIS);
 	}
 
+	if (IS_DG2_GRAPHICS_STEP(gt->i915, G10, STEP_A0, STEP_B0) ||
+	    IS_DG2_GRAPHICS_STEP(gt->i915, G11, STEP_A0, STEP_B0)) {
+		/* Wa_14012362059:dg2 */
+		wa_mcr_write_or(wal, XEHP_MERT_MOD_CTRL, FORCE_MISS_FTLB);
+	}
+
 	if (IS_DG2_GRAPHICS_STEP(gt->i915, G10, STEP_A0, STEP_B0)) {
 		/* Wa_14010948348:dg2_g10 */
 		wa_write_or(wal, UNSLCGCTL9430, MSQDUNIT_CLKGATE_DIS);
@@ -1635,6 +1648,12 @@ dg2_gt_workarounds_init(struct intel_gt *gt, struct i915_wa_list *wal)
 
 		/* Wa_14011028019:dg2_g10 */
 		wa_mcr_write_or(wal, SSMCGCTL9530, RTFUNIT_CLKGATE_DIS);
+
+		/* Wa_14010680813:dg2_g10 */
+		wa_write_or(wal, GEN12_GAMSTLB_CTRL,
+			    CONTROL_BLOCK_CLKGATE_DIS |
+			    EGRESS_BLOCK_CLKGATE_DIS |
+			    TAG_BLOCK_CLKGATE_DIS);
 	}
 
 	/* Wa_14014830051:dg2 */
@@ -1649,6 +1668,16 @@ dg2_gt_workarounds_init(struct intel_gt *gt, struct i915_wa_list *wal)
 
 	/* Wa_14015795083 */
 	wa_mcr_write_clr(wal, GEN8_MISCCPCTL, GEN12_DOP_CLOCK_GATE_RENDER_ENABLE);
+
+	/* Wa_18018781329 */
+	wa_mcr_write_or(wal, RENDER_MOD_CTRL, FORCE_MISS_FTLB);
+	wa_mcr_write_or(wal, COMP_MOD_CTRL, FORCE_MISS_FTLB);
+	wa_mcr_write_or(wal, VDBX_MOD_CTRL, FORCE_MISS_FTLB);
+	wa_mcr_write_or(wal, VEBX_MOD_CTRL, FORCE_MISS_FTLB);
+
+	/* Wa_1509235366:dg2 */
+	wa_write_or(wal, GEN12_GAMCNTRL_CTRL,
+		    INVALIDATION_BROADCAST_MODE_DIS | GLOBAL_INVALIDATION_MODE);
 }
 
 static void
@@ -1658,16 +1687,29 @@ pvc_gt_workarounds_init(struct intel_gt *gt, struct i915_wa_list *wal)
 
 	/* Wa_14015795083 */
 	wa_mcr_write_clr(wal, GEN8_MISCCPCTL, GEN12_DOP_CLOCK_GATE_RENDER_ENABLE);
+
+	/* Wa_18018781329 */
+	wa_mcr_write_or(wal, RENDER_MOD_CTRL, FORCE_MISS_FTLB);
+	wa_mcr_write_or(wal, COMP_MOD_CTRL, FORCE_MISS_FTLB);
+	wa_mcr_write_or(wal, VDBX_MOD_CTRL, FORCE_MISS_FTLB);
+	wa_mcr_write_or(wal, VEBX_MOD_CTRL, FORCE_MISS_FTLB);
 }
 
 static void
 xelpg_gt_workarounds_init(struct intel_gt *gt, struct i915_wa_list *wal)
 {
-	/* Wa_14014830051 */
 	if (IS_MTL_GRAPHICS_STEP(gt->i915, M, STEP_A0, STEP_B0) ||
-	    IS_MTL_GRAPHICS_STEP(gt->i915, P, STEP_A0, STEP_B0))
+	    IS_MTL_GRAPHICS_STEP(gt->i915, P, STEP_A0, STEP_B0)) {
+		/* Wa_14014830051 */
 		wa_mcr_write_clr(wal, SARB_CHICKEN1, COMP_CKN_IN);
 
+		/* Wa_18018781329 */
+		wa_mcr_write_or(wal, RENDER_MOD_CTRL, FORCE_MISS_FTLB);
+		wa_mcr_write_or(wal, COMP_MOD_CTRL, FORCE_MISS_FTLB);
+		wa_mcr_write_or(wal, VDBX_MOD_CTRL, FORCE_MISS_FTLB);
+		wa_mcr_write_or(wal, VEBX_MOD_CTRL, FORCE_MISS_FTLB);
+	}
+
 	/*
 	 * Unlike older platforms, we no longer setup implicit steering here;
 	 * all MCR accesses are explicitly steered.
@@ -2342,12 +2384,6 @@ rcs_engine_wa_init(struct intel_engine_cs *engine, struct i915_wa_list *wal)
 				 GEN12_DISABLE_READ_SUPPRESSION);
 	}
 
-	if (IS_DG2(i915)) {
-		/* Wa_1509235366:dg2 */
-		wa_write_or(wal, GEN12_GAMCNTRL_CTRL, INVALIDATION_BROADCAST_MODE_DIS |
-			    GLOBAL_INVALIDATION_MODE);
-	}
-
 	if (IS_DG2_GRAPHICS_STEP(i915, G11, STEP_A0, STEP_B0)) {
 		/* Wa_14013392000:dg2_g11 */
 		wa_mcr_masked_en(wal, GEN8_ROW_CHICKEN2, GEN12_ENABLE_LARGE_GRF_MODE);
@@ -2432,18 +2468,6 @@ rcs_engine_wa_init(struct intel_engine_cs *engine, struct i915_wa_list *wal)
 		wa_mcr_masked_en(wal, GEN9_HALF_SLICE_CHICKEN7,
 				 DG2_DISABLE_ROUND_ENABLE_ALLOW_FOR_SSLA);
 
-	if (IS_DG2_GRAPHICS_STEP(engine->i915, G10, STEP_A0, STEP_B0)) {
-		/* Wa_14010680813:dg2_g10 */
-		wa_write_or(wal, GEN12_GAMSTLB_CTRL, CONTROL_BLOCK_CLKGATE_DIS |
-			    EGRESS_BLOCK_CLKGATE_DIS | TAG_BLOCK_CLKGATE_DIS);
-	}
-
-	if (IS_DG2_GRAPHICS_STEP(engine->i915, G10, STEP_A0, STEP_B0) ||
-	    IS_DG2_GRAPHICS_STEP(engine->i915, G11, STEP_A0, STEP_B0)) {
-		/* Wa_14012362059:dg2 */
-		wa_mcr_write_or(wal, XEHP_MERT_MOD_CTRL, FORCE_MISS_FTLB);
-	}
-
 	if (IS_DG2_GRAPHICS_STEP(i915, G11, STEP_B0, STEP_FOREVER) ||
 	    IS_DG2_G10(i915)) {
 		/* Wa_22014600077:dg2 */
@@ -3000,12 +3024,6 @@ general_render_compute_wa_init(struct intel_engine_cs *engine, struct i915_wa_li
 	    IS_MTL_GRAPHICS_STEP(i915, P, STEP_A0, STEP_B0) ||
 	    IS_PONTEVECCHIO(i915) ||
 	    IS_DG2(i915)) {
-		/* Wa_18018781329 */
-		wa_mcr_write_or(wal, RENDER_MOD_CTRL, FORCE_MISS_FTLB);
-		wa_mcr_write_or(wal, COMP_MOD_CTRL, FORCE_MISS_FTLB);
-		wa_mcr_write_or(wal, VDBX_MOD_CTRL, FORCE_MISS_FTLB);
-		wa_mcr_write_or(wal, VEBX_MOD_CTRL, FORCE_MISS_FTLB);
-
 		/* Wa_22014226127 */
 		wa_mcr_write_or(wal, LSC_CHICKEN_BIT_0, DISABLE_D8_D16_COASLESCE);
 	}
@@ -3045,13 +3063,6 @@ general_render_compute_wa_init(struct intel_engine_cs *engine, struct i915_wa_li
 			wa_mcr_masked_dis(wal, MLTICTXCTL, TDONRENDER);
 			wa_mcr_write_or(wal, L3SQCREG1_CCS0, FLUSHALLNONCOH);
 		}
-
-		/* Wa_14012362059:xehpsdv */
-		wa_mcr_write_or(wal, XEHP_MERT_MOD_CTRL, FORCE_MISS_FTLB);
-
-		/* Wa_14014368820:xehpsdv */
-		wa_write_or(wal, GEN12_GAMCNTRL_CTRL, INVALIDATION_BROADCAST_MODE_DIS |
-				GLOBAL_INVALIDATION_MODE);
 	}
 
 	if (IS_DG2(i915) || IS_PONTEVECCHIO(i915)) {
-- 
2.39.2



