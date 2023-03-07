Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AD976AEBE3
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:50:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231270AbjCGRt7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:49:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232244AbjCGRta (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:49:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FDB29F073
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:44:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 018E6B81851
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:44:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C292C433D2;
        Tue,  7 Mar 2023 17:44:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678211060;
        bh=NFFJXp3s4WBX/KfIdWNIzALXqQfXwngcB8lNQx3nDL8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KNkXUya40xEY3fbmWhYChllvxrVL+5h/lVQgP1hRpvpdhmVHz6/Djl7ie15E0uYdC
         DeXbQKpx0Km4BTasCiltxQS8a1n25Ril7JBPzsot+Js2CsC+pwTobhXMLU1QleIezr
         YVGEadtUiYP3j25fapra43CjQfpuaKpdmD87tiRg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Gustavo Sousa <gustavo.sousa@intel.com>,
        Matt Roper <matthew.d.roper@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0741/1001] drm/i915/mtl: Correct implementation of Wa_18018781329
Date:   Tue,  7 Mar 2023 17:58:33 +0100
Message-Id: <20230307170053.897471137@linuxfoundation.org>
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

[ Upstream commit eda94a6e6a4f2d3d1574ff4f2bd4b9f844504f71 ]

Workaround Wa_18018781329 has applied to several recent Xe_HP-based
platforms.  However there are some extra gotchas to implementing this
properly for MTL that we need to take into account:

 * Due to the separation of media and render/compute into separate GTs,
   this workaround needs to be implemented on each GT, not just the
   primary GT.  Since each class of register only exists on one of the
   two GTs, we should program the appropriate registers on each GT.

 * As with past Xe_HP platforms, the registers on the primary GT (Xe_LPG
   IP) are multicast/replicated registers and should be handled with the
   MCR-aware functions.  However the registers on the media GT (Xe_LPM+
   IP) are regular singleton registers and should _not_ use MCR
   handling.  We need to create separate register definitions for the
   Xe_HP multicast form and the Xe_LPM+ singleton form and use each in
   the appropriate place.

 * Starting with MTL, workarounds documented by the hardware teams are
   technically associated with IP versions/steppings rather than
   top-level platforms.  That means we should take care to check the
   media IP version rather than the graphics IP version when deciding
   whether the workaround is needed on the Xe_LPM+ media GT (in this
   case the workaround applies to both IPs and the stepping bounds are
   identical, but we should still write the code appropriately to set a
   proper precedent for future workaround implementations).

 * It's worth noting that the GSC register and the CCS register are
   defined with the same MMIO offset (0xCF30).  Since the CCS is only
   relevant to the primary GT and the GSC is only relevant to the media
   GT there isn't actually a clash here (the media GT automatically adds
   the additional 0x380000 GSI offset).  However there's currently a
   glitch in the bspec where the CCS register doesn't show up at all and
   the GSC register is listed as existing on both GTs.  That's a known
   documentation problem for several registers with shared GSC/CCS
   offsets; rest assured that the CCS register really does still exist.

Cc: Gustavo Sousa <gustavo.sousa@intel.com>
Signed-off-by: Matt Roper <matthew.d.roper@intel.com>
Fixes: 41bb543f5598 ("drm/i915/mtl: Add initial gt workarounds")
Reviewed-by: Gustavo Sousa <gustavo.sousa@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230125234159.3015385-2-matthew.d.roper@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/gt/intel_gt_regs.h     |  7 +++++--
 drivers/gpu/drm/i915/gt/intel_workarounds.c | 22 ++++++++++++++-------
 drivers/gpu/drm/i915/i915_drv.h             |  4 ++++
 3 files changed, 24 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/i915/gt/intel_gt_regs.h b/drivers/gpu/drm/i915/gt/intel_gt_regs.h
index 3b6ef0eb47e76..9758b0b635601 100644
--- a/drivers/gpu/drm/i915/gt/intel_gt_regs.h
+++ b/drivers/gpu/drm/i915/gt/intel_gt_regs.h
@@ -1087,8 +1087,11 @@
 #define XEHP_MERT_MOD_CTRL			MCR_REG(0xcf28)
 #define RENDER_MOD_CTRL				MCR_REG(0xcf2c)
 #define COMP_MOD_CTRL				MCR_REG(0xcf30)
-#define VDBX_MOD_CTRL				MCR_REG(0xcf34)
-#define VEBX_MOD_CTRL				MCR_REG(0xcf38)
+#define XELPMP_GSC_MOD_CTRL			_MMIO(0xcf30)	/* media GT only */
+#define XEHP_VDBX_MOD_CTRL			MCR_REG(0xcf34)
+#define XELPMP_VDBX_MOD_CTRL			_MMIO(0xcf34)
+#define XEHP_VEBX_MOD_CTRL			MCR_REG(0xcf38)
+#define XELPMP_VEBX_MOD_CTRL			_MMIO(0xcf38)
 #define   FORCE_MISS_FTLB			REG_BIT(3)
 
 #define XEHP_GAMSTLB_CTRL			MCR_REG(0xcf4c)
diff --git a/drivers/gpu/drm/i915/gt/intel_workarounds.c b/drivers/gpu/drm/i915/gt/intel_workarounds.c
index d92b006d4cd2e..e13052c5dae19 100644
--- a/drivers/gpu/drm/i915/gt/intel_workarounds.c
+++ b/drivers/gpu/drm/i915/gt/intel_workarounds.c
@@ -1678,8 +1678,8 @@ dg2_gt_workarounds_init(struct intel_gt *gt, struct i915_wa_list *wal)
 	/* Wa_18018781329 */
 	wa_mcr_write_or(wal, RENDER_MOD_CTRL, FORCE_MISS_FTLB);
 	wa_mcr_write_or(wal, COMP_MOD_CTRL, FORCE_MISS_FTLB);
-	wa_mcr_write_or(wal, VDBX_MOD_CTRL, FORCE_MISS_FTLB);
-	wa_mcr_write_or(wal, VEBX_MOD_CTRL, FORCE_MISS_FTLB);
+	wa_mcr_write_or(wal, XEHP_VDBX_MOD_CTRL, FORCE_MISS_FTLB);
+	wa_mcr_write_or(wal, XEHP_VEBX_MOD_CTRL, FORCE_MISS_FTLB);
 
 	/* Wa_1509235366:dg2 */
 	wa_mcr_write_or(wal, XEHP_GAMCNTRL_CTRL,
@@ -1697,8 +1697,8 @@ pvc_gt_workarounds_init(struct intel_gt *gt, struct i915_wa_list *wal)
 	/* Wa_18018781329 */
 	wa_mcr_write_or(wal, RENDER_MOD_CTRL, FORCE_MISS_FTLB);
 	wa_mcr_write_or(wal, COMP_MOD_CTRL, FORCE_MISS_FTLB);
-	wa_mcr_write_or(wal, VDBX_MOD_CTRL, FORCE_MISS_FTLB);
-	wa_mcr_write_or(wal, VEBX_MOD_CTRL, FORCE_MISS_FTLB);
+	wa_mcr_write_or(wal, XEHP_VDBX_MOD_CTRL, FORCE_MISS_FTLB);
+	wa_mcr_write_or(wal, XEHP_VEBX_MOD_CTRL, FORCE_MISS_FTLB);
 }
 
 static void
@@ -1712,8 +1712,6 @@ xelpg_gt_workarounds_init(struct intel_gt *gt, struct i915_wa_list *wal)
 		/* Wa_18018781329 */
 		wa_mcr_write_or(wal, RENDER_MOD_CTRL, FORCE_MISS_FTLB);
 		wa_mcr_write_or(wal, COMP_MOD_CTRL, FORCE_MISS_FTLB);
-		wa_mcr_write_or(wal, VDBX_MOD_CTRL, FORCE_MISS_FTLB);
-		wa_mcr_write_or(wal, VEBX_MOD_CTRL, FORCE_MISS_FTLB);
 	}
 
 	/*
@@ -1726,7 +1724,17 @@ xelpg_gt_workarounds_init(struct intel_gt *gt, struct i915_wa_list *wal)
 static void
 xelpmp_gt_workarounds_init(struct intel_gt *gt, struct i915_wa_list *wal)
 {
-	/* FIXME: Actual workarounds will be added in future patch(es) */
+	if (IS_MTL_MEDIA_STEP(gt->i915, STEP_A0, STEP_B0)) {
+		/*
+		 * Wa_18018781329
+		 *
+		 * Note that although these registers are MCR on the primary
+		 * GT, the media GT's versions are regular singleton registers.
+		 */
+		wa_write_or(wal, XELPMP_GSC_MOD_CTRL, FORCE_MISS_FTLB);
+		wa_write_or(wal, XELPMP_VDBX_MOD_CTRL, FORCE_MISS_FTLB);
+		wa_write_or(wal, XELPMP_VEBX_MOD_CTRL, FORCE_MISS_FTLB);
+	}
 
 	debug_dump_steering(gt);
 }
diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_drv.h
index a380db36d52c4..03c3a59d0939b 100644
--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -726,6 +726,10 @@ IS_SUBPLATFORM(const struct drm_i915_private *i915,
 	(IS_SUBPLATFORM(__i915, INTEL_METEORLAKE, INTEL_SUBPLATFORM_##variant) && \
 	 IS_GRAPHICS_STEP(__i915, since, until))
 
+#define IS_MTL_MEDIA_STEP(__i915, since, until) \
+	(IS_METEORLAKE(__i915) && \
+	 IS_MEDIA_STEP(__i915, since, until))
+
 /*
  * DG2 hardware steppings are a bit unusual.  The hardware design was forked to
  * create three variants (G10, G11, and G12) which each have distinct
-- 
2.39.2



