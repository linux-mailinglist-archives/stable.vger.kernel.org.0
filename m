Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19E356AEA4B
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:32:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231697AbjCGRcb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:32:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231654AbjCGRcM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:32:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6923295BF6
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:27:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1D825B819AB
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:27:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67C02C433EF;
        Tue,  7 Mar 2023 17:27:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678210059;
        bh=iuBnDX04y2ZbW1Y3ZZan0C7qmHGUT/JTlMlSYQdxTHU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xXPxhSw8LuBhXqrvkTHxecXqnIDhOZYd5gY2VJWRElESf2IBCSv2DsoAMdXwQg4dD
         SqQ+Lyb7LWKv5MlZ9ZjzfaH5eObbDaGM1fojbwFdLnedHpJ4U2yG3JOTFkLFqAv8ls
         5qahKkIQMFBsp9FBK1msrrK9vwknnUv1odEQogtE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Gustavo Sousa <gustavo.sousa@intel.com>,
        Matt Roper <matthew.d.roper@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0392/1001] drm/i915/xehp: Annotate a couple more workaround registers as MCR
Date:   Tue,  7 Mar 2023 17:52:44 +0100
Message-Id: <20230307170038.362178535@linuxfoundation.org>
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

From: Matt Roper <matthew.d.roper@intel.com>

[ Upstream commit 7649a5d1f263b8cc5c2827ef0443ead9bee9ae0e ]

GAMSTLB_CTRL and GAMCNTRL_CTRL became multicast/replicated registers on
Xe_HP.  They should be defined accordingly and use MCR-aware operations.

These registers have only been used for some dg2/xehpsdv workarounds, so
this fix is mostly just for consistency/future-proofing; even lacking
the MCR annotation, workarounds will always be properly applied in a
multicast manner on these platforms.

Cc: Gustavo Sousa <gustavo.sousa@intel.com>
Fixes: 58bc2453ab8a ("drm/i915: Define multicast registers as a new type")
Signed-off-by: Matt Roper <matthew.d.roper@intel.com>
Reviewed-by: Gustavo Sousa <gustavo.sousa@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230125234159.3015385-3-matthew.d.roper@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/gt/intel_gt_regs.h     |  4 ++--
 drivers/gpu/drm/i915/gt/intel_workarounds.c | 16 ++++++++--------
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/gpu/drm/i915/gt/intel_gt_regs.h b/drivers/gpu/drm/i915/gt/intel_gt_regs.h
index c525fc07a9bcb..0c7e7972cc1c4 100644
--- a/drivers/gpu/drm/i915/gt/intel_gt_regs.h
+++ b/drivers/gpu/drm/i915/gt/intel_gt_regs.h
@@ -1093,12 +1093,12 @@
 #define VEBX_MOD_CTRL				MCR_REG(0xcf38)
 #define   FORCE_MISS_FTLB			REG_BIT(3)
 
-#define GEN12_GAMSTLB_CTRL			_MMIO(0xcf4c)
+#define XEHP_GAMSTLB_CTRL			MCR_REG(0xcf4c)
 #define   CONTROL_BLOCK_CLKGATE_DIS		REG_BIT(12)
 #define   EGRESS_BLOCK_CLKGATE_DIS		REG_BIT(11)
 #define   TAG_BLOCK_CLKGATE_DIS			REG_BIT(7)
 
-#define GEN12_GAMCNTRL_CTRL			_MMIO(0xcf54)
+#define XEHP_GAMCNTRL_CTRL			MCR_REG(0xcf54)
 #define   INVALIDATION_BROADCAST_MODE_DIS	REG_BIT(12)
 #define   GLOBAL_INVALIDATION_MODE		REG_BIT(2)
 
diff --git a/drivers/gpu/drm/i915/gt/intel_workarounds.c b/drivers/gpu/drm/i915/gt/intel_workarounds.c
index 9932d748b9d7b..dcc694b8bc8c7 100644
--- a/drivers/gpu/drm/i915/gt/intel_workarounds.c
+++ b/drivers/gpu/drm/i915/gt/intel_workarounds.c
@@ -1555,8 +1555,8 @@ xehpsdv_gt_workarounds_init(struct intel_gt *gt, struct i915_wa_list *wal)
 	wa_mcr_write_or(wal, XEHP_MERT_MOD_CTRL, FORCE_MISS_FTLB);
 
 	/* Wa_14014368820:xehpsdv */
-	wa_write_or(wal, GEN12_GAMCNTRL_CTRL,
-		    INVALIDATION_BROADCAST_MODE_DIS | GLOBAL_INVALIDATION_MODE);
+	wa_mcr_write_or(wal, XEHP_GAMCNTRL_CTRL,
+			INVALIDATION_BROADCAST_MODE_DIS | GLOBAL_INVALIDATION_MODE);
 }
 
 static void
@@ -1650,10 +1650,10 @@ dg2_gt_workarounds_init(struct intel_gt *gt, struct i915_wa_list *wal)
 		wa_mcr_write_or(wal, SSMCGCTL9530, RTFUNIT_CLKGATE_DIS);
 
 		/* Wa_14010680813:dg2_g10 */
-		wa_write_or(wal, GEN12_GAMSTLB_CTRL,
-			    CONTROL_BLOCK_CLKGATE_DIS |
-			    EGRESS_BLOCK_CLKGATE_DIS |
-			    TAG_BLOCK_CLKGATE_DIS);
+		wa_mcr_write_or(wal, XEHP_GAMSTLB_CTRL,
+				CONTROL_BLOCK_CLKGATE_DIS |
+				EGRESS_BLOCK_CLKGATE_DIS |
+				TAG_BLOCK_CLKGATE_DIS);
 	}
 
 	/* Wa_14014830051:dg2 */
@@ -1676,8 +1676,8 @@ dg2_gt_workarounds_init(struct intel_gt *gt, struct i915_wa_list *wal)
 	wa_mcr_write_or(wal, VEBX_MOD_CTRL, FORCE_MISS_FTLB);
 
 	/* Wa_1509235366:dg2 */
-	wa_write_or(wal, GEN12_GAMCNTRL_CTRL,
-		    INVALIDATION_BROADCAST_MODE_DIS | GLOBAL_INVALIDATION_MODE);
+	wa_mcr_write_or(wal, XEHP_GAMCNTRL_CTRL,
+			INVALIDATION_BROADCAST_MODE_DIS | GLOBAL_INVALIDATION_MODE);
 }
 
 static void
-- 
2.39.2



