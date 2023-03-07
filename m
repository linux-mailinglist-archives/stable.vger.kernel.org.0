Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CAE16AEA64
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:33:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231612AbjCGRdS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:33:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231604AbjCGRcy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:32:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49FB985344
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:28:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DBC75614FF
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:28:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA361C4339C;
        Tue,  7 Mar 2023 17:28:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678210121;
        bh=hiAi7rAKPCo3vhcTyVvDLAXjvYrnPzRQdiEqCUUZDjA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DRxe3VWvMo3NMpa2nRBje78FngmEAnkoWt5zXppcmL8FlkjF0kPJ6Op7pQsVb2Hmt
         DtKv2g0Vq/5ixUjrRD9z8k7okY+x6SwuHS0aIEVbz3709CILsTs08vf7I3yzDc+Db0
         5OrNVNrWJbo2/jUrjZJmHCEfek3dYJx5GZKqT9NY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Balasubramani Vivekanandan <balasubramani.vivekanandan@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Gustavo Sousa <gustavo.sousa@intel.com>,
        Matt Atwood <matthew.s.atwood@intel.com>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>,
        Lucas De Marchi <lucas.demarchi@intel.com>,
        Matt Roper <matthew.d.roper@intel.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0440/1001] drm/i915: Fix GEN8_MISCCPCTL
Date:   Tue,  7 Mar 2023 17:53:32 +0100
Message-Id: <20230307170040.440477433@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lucas De Marchi <lucas.demarchi@intel.com>

[ Upstream commit 6a8b2e4984f73f8d00c8c16b87a8b115d34088e4 ]

Register 0x9424 is not replicated on any platform, so it shouldn't be
declared with REG_MCR(). Declaring it with _MMIO() is basically
duplicate of the GEN7 version, so just remove the GEN8 and change all
the callers to use the right functions.

Old versions of the gen8 bspec page used to contain a table with MCR
registers, apparently implying 0x9400 - 0x94ff registers were
replicated. However that table went away and there is no information
related to the ranges for gen8 anymore. Moreover the current behavior of
the driver wouldn't do anything special for 0x9424 since there is no
equivalent table in intel_gt_mcr.c: the driver would just fallback to
intel_uncore_{read,write}(). Therefore, do not care about the possible
special case for gen8 and just use the register as non-MCR for all the
platforms.

One place doing read + write is also converted to intel_uncore_rmw().

v2: Reword commit message adding the justification wrt gen8

Fixes: a9e69428b1b4 ("drm/i915: Define MCR registers explicitly")
Cc: Balasubramani Vivekanandan <balasubramani.vivekanandan@intel.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Gustavo Sousa <gustavo.sousa@intel.com>
Cc: Matt Atwood <matthew.s.atwood@intel.com>
Cc: Ashutosh Dixit <ashutosh.dixit@intel.com>
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Reviewed-by: Matt Roper <matthew.d.roper@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230206165410.3056073-1-lucas.demarchi@intel.com
(cherry picked from commit 869bace73ae2b4227e57ee3fd994bfa7d4808938)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/gt/intel_gt_regs.h     |  5 +----
 drivers/gpu/drm/i915/gt/intel_workarounds.c |  4 ++--
 drivers/gpu/drm/i915/gt/uc/intel_guc_fw.c   |  5 ++---
 drivers/gpu/drm/i915/intel_pm.c             | 10 +++++-----
 4 files changed, 10 insertions(+), 14 deletions(-)

diff --git a/drivers/gpu/drm/i915/gt/intel_gt_regs.h b/drivers/gpu/drm/i915/gt/intel_gt_regs.h
index 0d47c930956e0..3b6ef0eb47e76 100644
--- a/drivers/gpu/drm/i915/gt/intel_gt_regs.h
+++ b/drivers/gpu/drm/i915/gt/intel_gt_regs.h
@@ -681,10 +681,7 @@
 #define GEN6_RSTCTL				_MMIO(0x9420)
 
 #define GEN7_MISCCPCTL				_MMIO(0x9424)
-#define   GEN7_DOP_CLOCK_GATE_ENABLE		(1 << 0)
-
-#define GEN8_MISCCPCTL				MCR_REG(0x9424)
-#define   GEN8_DOP_CLOCK_GATE_ENABLE		REG_BIT(0)
+#define   GEN7_DOP_CLOCK_GATE_ENABLE		REG_BIT(0)
 #define   GEN12_DOP_CLOCK_GATE_RENDER_ENABLE	REG_BIT(1)
 #define   GEN8_DOP_CLOCK_GATE_CFCLK_ENABLE	(1 << 2)
 #define   GEN8_DOP_CLOCK_GATE_GUC_ENABLE	(1 << 4)
diff --git a/drivers/gpu/drm/i915/gt/intel_workarounds.c b/drivers/gpu/drm/i915/gt/intel_workarounds.c
index 80b0e9a56330c..d92b006d4cd2e 100644
--- a/drivers/gpu/drm/i915/gt/intel_workarounds.c
+++ b/drivers/gpu/drm/i915/gt/intel_workarounds.c
@@ -1673,7 +1673,7 @@ dg2_gt_workarounds_init(struct intel_gt *gt, struct i915_wa_list *wal)
 	wa_mcr_write_or(wal, XEHP_SQCM, EN_32B_ACCESS);
 
 	/* Wa_14015795083 */
-	wa_mcr_write_clr(wal, GEN8_MISCCPCTL, GEN12_DOP_CLOCK_GATE_RENDER_ENABLE);
+	wa_write_clr(wal, GEN7_MISCCPCTL, GEN12_DOP_CLOCK_GATE_RENDER_ENABLE);
 
 	/* Wa_18018781329 */
 	wa_mcr_write_or(wal, RENDER_MOD_CTRL, FORCE_MISS_FTLB);
@@ -1692,7 +1692,7 @@ pvc_gt_workarounds_init(struct intel_gt *gt, struct i915_wa_list *wal)
 	pvc_init_mcr(gt, wal);
 
 	/* Wa_14015795083 */
-	wa_mcr_write_clr(wal, GEN8_MISCCPCTL, GEN12_DOP_CLOCK_GATE_RENDER_ENABLE);
+	wa_write_clr(wal, GEN7_MISCCPCTL, GEN12_DOP_CLOCK_GATE_RENDER_ENABLE);
 
 	/* Wa_18018781329 */
 	wa_mcr_write_or(wal, RENDER_MOD_CTRL, FORCE_MISS_FTLB);
diff --git a/drivers/gpu/drm/i915/gt/uc/intel_guc_fw.c b/drivers/gpu/drm/i915/gt/uc/intel_guc_fw.c
index 5b86b2e286e07..42c5d9d2e2182 100644
--- a/drivers/gpu/drm/i915/gt/uc/intel_guc_fw.c
+++ b/drivers/gpu/drm/i915/gt/uc/intel_guc_fw.c
@@ -38,9 +38,8 @@ static void guc_prepare_xfer(struct intel_gt *gt)
 
 	if (GRAPHICS_VER(uncore->i915) == 9) {
 		/* DOP Clock Gating Enable for GuC clocks */
-		intel_gt_mcr_multicast_write(gt, GEN8_MISCCPCTL,
-					     GEN8_DOP_CLOCK_GATE_GUC_ENABLE |
-					     intel_gt_mcr_read_any(gt, GEN8_MISCCPCTL));
+		intel_uncore_rmw(uncore, GEN7_MISCCPCTL, 0,
+				 GEN8_DOP_CLOCK_GATE_GUC_ENABLE);
 
 		/* allows for 5us (in 10ns units) before GT can go to RC6 */
 		intel_uncore_write(uncore, GUC_ARAT_C6DIS, 0x1FF);
diff --git a/drivers/gpu/drm/i915/intel_pm.c b/drivers/gpu/drm/i915/intel_pm.c
index 73c88b1c9545c..ac61df46d02c5 100644
--- a/drivers/gpu/drm/i915/intel_pm.c
+++ b/drivers/gpu/drm/i915/intel_pm.c
@@ -4299,8 +4299,8 @@ static void gen8_set_l3sqc_credits(struct drm_i915_private *dev_priv,
 	u32 val;
 
 	/* WaTempDisableDOPClkGating:bdw */
-	misccpctl = intel_gt_mcr_multicast_rmw(to_gt(dev_priv), GEN8_MISCCPCTL,
-					       GEN8_DOP_CLOCK_GATE_ENABLE, 0);
+	misccpctl = intel_uncore_rmw(&dev_priv->uncore, GEN7_MISCCPCTL,
+				     GEN7_DOP_CLOCK_GATE_ENABLE, 0);
 
 	val = intel_gt_mcr_read_any(to_gt(dev_priv), GEN8_L3SQCREG1);
 	val &= ~L3_PRIO_CREDITS_MASK;
@@ -4314,7 +4314,7 @@ static void gen8_set_l3sqc_credits(struct drm_i915_private *dev_priv,
 	 */
 	intel_gt_mcr_read_any(to_gt(dev_priv), GEN8_L3SQCREG1);
 	udelay(1);
-	intel_gt_mcr_multicast_write(to_gt(dev_priv), GEN8_MISCCPCTL, misccpctl);
+	intel_uncore_write(&dev_priv->uncore, GEN7_MISCCPCTL, misccpctl);
 }
 
 static void icl_init_clock_gating(struct drm_i915_private *dev_priv)
@@ -4465,8 +4465,8 @@ static void skl_init_clock_gating(struct drm_i915_private *dev_priv)
 	gen9_init_clock_gating(dev_priv);
 
 	/* WaDisableDopClockGating:skl */
-	intel_gt_mcr_multicast_rmw(to_gt(dev_priv), GEN8_MISCCPCTL,
-				   GEN8_DOP_CLOCK_GATE_ENABLE, 0);
+	intel_uncore_rmw(&dev_priv->uncore, GEN7_MISCCPCTL,
+			 GEN7_DOP_CLOCK_GATE_ENABLE, 0);
 
 	/* WAC6entrylatency:skl */
 	intel_uncore_rmw(&dev_priv->uncore, FBC_LLC_READ_CTRL, 0, FBC_LLC_FULLY_OPEN);
-- 
2.39.2



