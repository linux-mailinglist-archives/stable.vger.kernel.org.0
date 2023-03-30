Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B8B36D101C
	for <lists+stable@lfdr.de>; Thu, 30 Mar 2023 22:42:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229685AbjC3Umi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Mar 2023 16:42:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbjC3Umh (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Mar 2023 16:42:37 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE593DBEC
        for <stable@vger.kernel.org>; Thu, 30 Mar 2023 13:42:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680208956; x=1711744956;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kvIhKyy6W8z/dZrDc3TkjegbjVAYDxBLkXKDJsqEkes=;
  b=GEfYjvJXcRTS/i8UCx8qW4Dm6r59tEW0Crp6FghG1GVSSgw4iY4Sqr+s
   MeUUP6ykY7T4JggVhtswKv8pKnFCiR6rGUnQW4gi1h0RpuXUvh107//NJ
   nDRBC0MBSu2v+brzGxVIpD5hHOK1ShiKQFf4h2vMlEoFVblY0ZVZl7D4b
   ScPf0csKmZQeJViyQFnDoD17U+nqKKpXr0kdDKyu17FFL+DmcQx9pmo3E
   KIrrWTYmKdpE1SYxOC9SgJ9g0vuQJEkbRxqPJiIS+vlq49s4bmWOPndBC
   iqo4F4STUrSNRxKzrwBzPRM2xqwEkOX9b51JxeSxjsZK+Z6if+Wh+dZwG
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10665"; a="329803791"
X-IronPort-AV: E=Sophos;i="5.98,305,1673942400"; 
   d="scan'208";a="329803791"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2023 13:42:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10665"; a="795812643"
X-IronPort-AV: E=Sophos;i="5.98,305,1673942400"; 
   d="scan'208";a="795812643"
Received: from dgroene-mobl1.ger.corp.intel.com (HELO uxy.intel.com) ([10.252.41.50])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2023 13:42:32 -0700
From:   Lionel Landwerlin <lionel.g.landwerlin@intel.com>
To:     intel-gfx@lists.freedesktop.org
Cc:     Lionel Landwerlin <lionel.g.landwerlin@intel.com>,
        stable@vger.kernel.org
Subject: [v3] drm/i915: disable sampler indirect state in bindless heap
Date:   Thu, 30 Mar 2023 23:42:28 +0300
Message-Id: <20230330204228.2781676-1-lionel.g.landwerlin@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230309152611.1788656-1-lionel.g.landwerlin@intel.com>
References: <20230309152611.1788656-1-lionel.g.landwerlin@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
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

BSpec: 46052

Signed-off-by: Lionel Landwerlin <lionel.g.landwerlin@intel.com>
Cc: stable@vger.kernel.org
---
 drivers/gpu/drm/i915/gt/intel_gt_regs.h     |  1 +
 drivers/gpu/drm/i915/gt/intel_workarounds.c | 19 +++++++++++++++++++
 2 files changed, 20 insertions(+)

diff --git a/drivers/gpu/drm/i915/gt/intel_gt_regs.h b/drivers/gpu/drm/i915/gt/intel_gt_regs.h
index 4aecb5a7b6318..f298dc461a72f 100644
--- a/drivers/gpu/drm/i915/gt/intel_gt_regs.h
+++ b/drivers/gpu/drm/i915/gt/intel_gt_regs.h
@@ -1144,6 +1144,7 @@
 #define   ENABLE_SMALLPL			REG_BIT(15)
 #define   SC_DISABLE_POWER_OPTIMIZATION_EBB	REG_BIT(9)
 #define   GEN11_SAMPLER_ENABLE_HEADLESS_MSG	REG_BIT(5)
+#define   GEN11_INDIRECT_STATE_BASE_ADDR_OVERRIDE	REG_BIT(0)
 
 #define GEN9_HALF_SLICE_CHICKEN7		MCR_REG(0xe194)
 #define   DG2_DISABLE_ROUND_ENABLE_ALLOW_FOR_SSLA	REG_BIT(15)
diff --git a/drivers/gpu/drm/i915/gt/intel_workarounds.c b/drivers/gpu/drm/i915/gt/intel_workarounds.c
index e7ee24bcad893..5bfc864d5fcc0 100644
--- a/drivers/gpu/drm/i915/gt/intel_workarounds.c
+++ b/drivers/gpu/drm/i915/gt/intel_workarounds.c
@@ -2971,6 +2971,25 @@ general_render_compute_wa_init(struct intel_engine_cs *engine, struct i915_wa_li
 
 	add_render_compute_tuning_settings(i915, wal);
 
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
+		 *
+		 * BSpec: 46052
+		 */
+		wa_mcr_masked_en(wal,
+				 GEN10_SAMPLER_MODE,
+				 GEN11_INDIRECT_STATE_BASE_ADDR_OVERRIDE);
+	}
+
 	if (IS_MTL_GRAPHICS_STEP(i915, M, STEP_A0, STEP_B0) ||
 	    IS_MTL_GRAPHICS_STEP(i915, P, STEP_A0, STEP_B0) ||
 	    IS_DG2_GRAPHICS_STEP(i915, G10, STEP_B0, STEP_FOREVER) ||
-- 
2.34.1

