Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FBC36B28D1
	for <lists+stable@lfdr.de>; Thu,  9 Mar 2023 16:26:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230039AbjCIP0g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Mar 2023 10:26:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229852AbjCIP0d (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Mar 2023 10:26:33 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4049A46A5
        for <stable@vger.kernel.org>; Thu,  9 Mar 2023 07:26:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678375592; x=1709911592;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=BF09OE2Ns4C435KBXya+4O7w1PNbTHycdyIXYcgTb5Y=;
  b=a69fIPC5E0ESsp5XksJQG4qZZMzN9e/nKwN3nmfaV4ElB9ijnGUZjF3+
   uFvfN4gP8az3uwyfToYbvQ7/Bwe5SBQpZ+rX/EJBLc25LuNWB3oHWh30v
   WyT7KfPfD3/a8errDj6dheS6JyB7Ffiqr2/Cp5Yf1WD7sVXY2fRg8bzku
   K1RMvBxO+K9LvIZGNxT2auxKZJ1kLL9yOWyeT6gun7BnBjX2ytdZM91MT
   VS01nAp5mZQRmPuGdC9V0ozTKyrHF/GUt+oyZhnG0G+1FQC7MsiUFpCfU
   grFkjr5BYhpvCNKvkc4CSBOdKP3K9P/LvEhkHeg8vD0R76AbqYOJRJuPU
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10643"; a="335175150"
X-IronPort-AV: E=Sophos;i="5.98,246,1673942400"; 
   d="scan'208";a="335175150"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2023 07:26:28 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10643"; a="677405312"
X-IronPort-AV: E=Sophos;i="5.98,246,1673942400"; 
   d="scan'208";a="677405312"
Received: from rgcayeta-mobl3.ger.corp.intel.com (HELO uxy.intel.com) ([10.252.58.129])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2023 07:26:26 -0800
From:   Lionel Landwerlin <lionel.g.landwerlin@intel.com>
To:     intel-gfx@lists.freedesktop.org
Cc:     Lionel Landwerlin <lionel.g.landwerlin@intel.com>,
        stable@vger.kernel.org
Subject: [PATCH] drm/i915: disable sampler indirect state in bindless heap
Date:   Thu,  9 Mar 2023 17:26:11 +0200
Message-Id: <20230309152611.1788656-1-lionel.g.landwerlin@intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

By default the indirect state sampler data (border colors) are stored
in the same heap as the SAMPLER_STATE structure. For userspace drivers
that can be 2 different heaps (dynamic state heap & bindless sampler
state heap). This means that border colors have to copied in 2
different places so that the same SAMPLER_STATE structure find the
right data.

This change is forcing the indirect state sampler data to only be in
the dynamic state pool (more convinient for userspace drivers, they
only have to have one copy of the border colors). This is reproducing
the behavior of the Windows drivers.

Signed-off-by: Lionel Landwerlin <lionel.g.landwerlin@intel.com>
Cc: stable@vger.kernel.org
---
 drivers/gpu/drm/i915/gt/intel_gt_regs.h     |  1 +
 drivers/gpu/drm/i915/gt/intel_workarounds.c | 17 +++++++++++++++++
 2 files changed, 18 insertions(+)

diff --git a/drivers/gpu/drm/i915/gt/intel_gt_regs.h b/drivers/gpu/drm/i915/gt/intel_gt_regs.h
index 08d76aa06974c..1aaa471d08c56 100644
--- a/drivers/gpu/drm/i915/gt/intel_gt_regs.h
+++ b/drivers/gpu/drm/i915/gt/intel_gt_regs.h
@@ -1141,6 +1141,7 @@
 #define   ENABLE_SMALLPL			REG_BIT(15)
 #define   SC_DISABLE_POWER_OPTIMIZATION_EBB	REG_BIT(9)
 #define   GEN11_SAMPLER_ENABLE_HEADLESS_MSG	REG_BIT(5)
+#define   GEN11_INDIRECT_STATE_BASE_ADDR_OVERRIDE	REG_BIT(0)
 
 #define GEN9_HALF_SLICE_CHICKEN7		MCR_REG(0xe194)
 #define   DG2_DISABLE_ROUND_ENABLE_ALLOW_FOR_SSLA	REG_BIT(15)
diff --git a/drivers/gpu/drm/i915/gt/intel_workarounds.c b/drivers/gpu/drm/i915/gt/intel_workarounds.c
index 32aa1647721ae..734b64e714647 100644
--- a/drivers/gpu/drm/i915/gt/intel_workarounds.c
+++ b/drivers/gpu/drm/i915/gt/intel_workarounds.c
@@ -2542,6 +2542,23 @@ rcs_engine_wa_init(struct intel_engine_cs *engine, struct i915_wa_list *wal)
 				 ENABLE_SMALLPL);
 	}
 
+	if (GRAPHICS_VER(i915) >= 11) {
+		/* This is not a Wa (although referred to as
+		 * WaSetInidrectStateOverride in places), this allows
+		 * applications that reference sampler states through
+		 * the BindlessSamplerStateBaseAddress to have their
+		 * border color relative to DynamicStateBaseAddress
+		 * rather than BindlessSamplerStateBaseAddress.
+		 *
+		 * Otherwise SAMPLER_STATE border colors have to be
+		 * copied in multiple heaps (DynamicStateBaseAddress &
+		 * BindlessSamplerStateBaseAddress)
+		 */
+		wa_mcr_masked_en(wal,
+				 GEN10_SAMPLER_MODE,
+				 GEN11_INDIRECT_STATE_BASE_ADDR_OVERRIDE);
+	}
+
 	if (GRAPHICS_VER(i915) == 11) {
 		/* This is not an Wa. Enable for better image quality */
 		wa_masked_en(wal,
-- 
2.34.1

