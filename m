Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E18C6AEA63
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:33:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231667AbjCGRdS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:33:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231596AbjCGRcx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:32:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DB378483A
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:28:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E5E0B614FF
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:28:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9AA5C433EF;
        Tue,  7 Mar 2023 17:28:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678210118;
        bh=j8yBHNYn3z9QPYoGCZqt9HojnIh4dA+1zd+u+aduuGM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NWEcH+1RvWy7L4XMCO4XeZWPZoQk6oCf/yJTG5L28vvdQaDyXcPkw+SP1l0Zfs9yL
         G40yERS9xjLVpMGuUU4iJ+RLFk7mOwQ/uX0kz/FxYlQ3uypumUUnPaspl+lVUq4P9z
         7U3QL+Nl6w1wUhGT1/dVfwXxkht99KJXxHHtn+1w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Matt Roper <matthew.d.roper@intel.com>,
        Gustavo Sousa <gustavo.sousa@intel.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0439/1001] drm/i915/pvc: Annotate two more workaround/tuning registers as MCR
Date:   Tue,  7 Mar 2023 17:53:31 +0100
Message-Id: <20230307170040.402405615@linuxfoundation.org>
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

[ Upstream commit effc0905d741b4138806747407baf8de98390c72 ]

XEHPC_LNCFMISCCFGREG0 and XEHPC_L3SCRUB are both in MCR register ranges
on PVC (with HALFBSLICE and L3BANK replication respectively), so they
should be explicitly declared as MCR registers and use MCR-aware
workaround handlers.

The workarounds/tuning settings should still be applied properly on PVC
even without the MCR annotation, but readback verification on
CONFIG_DRM_I915_DEBUG_GEM builds could potentitally give false positive
"workaround lost on load" warnings on parts fused such that a unicast
read targets a terminated register instance.

Fixes: a9e69428b1b4 ("drm/i915: Define MCR registers explicitly")
Signed-off-by: Matt Roper <matthew.d.roper@intel.com>
Reviewed-by: Gustavo Sousa <gustavo.sousa@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230201222831.608281-1-matthew.d.roper@intel.com
(cherry picked from commit 4039e44237e8ebb06f0e4af549fbedf7c41df9db)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/gt/intel_gt_regs.h     |  4 ++--
 drivers/gpu/drm/i915/gt/intel_workarounds.c | 14 ++++++++++----
 2 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/i915/gt/intel_gt_regs.h b/drivers/gpu/drm/i915/gt/intel_gt_regs.h
index 838f73165ebbc..0d47c930956e0 100644
--- a/drivers/gpu/drm/i915/gt/intel_gt_regs.h
+++ b/drivers/gpu/drm/i915/gt/intel_gt_regs.h
@@ -969,7 +969,7 @@
 #define   GEN7_WA_FOR_GEN7_L3_CONTROL		0x3C47FF8C
 #define   GEN7_L3AGDIS				(1 << 19)
 
-#define XEHPC_LNCFMISCCFGREG0			_MMIO(0xb01c)
+#define XEHPC_LNCFMISCCFGREG0			MCR_REG(0xb01c)
 #define   XEHPC_HOSTCACHEEN			REG_BIT(1)
 #define   XEHPC_OVRLSCCC			REG_BIT(0)
 
@@ -1032,7 +1032,7 @@
 #define XEHP_L3SCQREG7				MCR_REG(0xb188)
 #define   BLEND_FILL_CACHING_OPT_DIS		REG_BIT(3)
 
-#define XEHPC_L3SCRUB				_MMIO(0xb18c)
+#define XEHPC_L3SCRUB				MCR_REG(0xb18c)
 #define   SCRUB_CL_DWNGRADE_SHARED		REG_BIT(12)
 #define   SCRUB_RATE_PER_BANK_MASK		REG_GENMASK(2, 0)
 #define   SCRUB_RATE_4B_PER_CLK			REG_FIELD_PREP(SCRUB_RATE_PER_BANK_MASK, 0x6)
diff --git a/drivers/gpu/drm/i915/gt/intel_workarounds.c b/drivers/gpu/drm/i915/gt/intel_workarounds.c
index c2d9d07af7ee9..80b0e9a56330c 100644
--- a/drivers/gpu/drm/i915/gt/intel_workarounds.c
+++ b/drivers/gpu/drm/i915/gt/intel_workarounds.c
@@ -224,6 +224,12 @@ wa_write(struct i915_wa_list *wal, i915_reg_t reg, u32 set)
 	wa_write_clr_set(wal, reg, ~0, set);
 }
 
+static void
+wa_mcr_write(struct i915_wa_list *wal, i915_mcr_reg_t reg, u32 set)
+{
+	wa_mcr_write_clr_set(wal, reg, ~0, set);
+}
+
 static void
 wa_write_or(struct i915_wa_list *wal, i915_reg_t reg, u32 set)
 {
@@ -2971,9 +2977,9 @@ add_render_compute_tuning_settings(struct drm_i915_private *i915,
 				   struct i915_wa_list *wal)
 {
 	if (IS_PONTEVECCHIO(i915)) {
-		wa_write(wal, XEHPC_L3SCRUB,
-			 SCRUB_CL_DWNGRADE_SHARED | SCRUB_RATE_4B_PER_CLK);
-		wa_masked_en(wal, XEHPC_LNCFMISCCFGREG0, XEHPC_HOSTCACHEEN);
+		wa_mcr_write(wal, XEHPC_L3SCRUB,
+			     SCRUB_CL_DWNGRADE_SHARED | SCRUB_RATE_4B_PER_CLK);
+		wa_mcr_masked_en(wal, XEHPC_LNCFMISCCFGREG0, XEHPC_HOSTCACHEEN);
 	}
 
 	if (IS_DG2(i915)) {
@@ -3038,7 +3044,7 @@ general_render_compute_wa_init(struct intel_engine_cs *engine, struct i915_wa_li
 
 	if (IS_PONTEVECCHIO(i915)) {
 		/* Wa_16016694945 */
-		wa_masked_en(wal, XEHPC_LNCFMISCCFGREG0, XEHPC_OVRLSCCC);
+		wa_mcr_masked_en(wal, XEHPC_LNCFMISCCFGREG0, XEHPC_OVRLSCCC);
 	}
 
 	if (IS_XEHPSDV(i915)) {
-- 
2.39.2



