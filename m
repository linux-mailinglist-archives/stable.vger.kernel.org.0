Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 463D059A07
	for <lists+stable@lfdr.de>; Fri, 28 Jun 2019 14:07:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726547AbfF1MH0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Jun 2019 08:07:26 -0400
Received: from mga01.intel.com ([192.55.52.88]:24669 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726524AbfF1MH0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 28 Jun 2019 08:07:26 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 28 Jun 2019 05:07:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,427,1557212400"; 
   d="scan'208";a="153354894"
Received: from akamins1-mobl.ger.corp.intel.com (HELO delly.ger.corp.intel.com) ([10.249.139.35])
  by orsmga007.jf.intel.com with ESMTP; 28 Jun 2019 05:07:24 -0700
From:   Lionel Landwerlin <lionel.g.landwerlin@intel.com>
To:     intel-gfx@lists.freedesktop.org
Cc:     Lionel Landwerlin <lionel.g.landwerlin@intel.com>,
        stable@vger.kernel.org
Subject: [PATCH v7 2/3] drm/i915: whitelist PS_(DEPTH|INVOCATION)_COUNT
Date:   Fri, 28 Jun 2019 15:07:19 +0300
Message-Id: <20190628120720.21682-3-lionel.g.landwerlin@intel.com>
X-Mailer: git-send-email 2.21.0.392.gf8f6787159e
In-Reply-To: <20190628120720.21682-1-lionel.g.landwerlin@intel.com>
References: <20190628120720.21682-1-lionel.g.landwerlin@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

CFL:C0+ changed the status of those registers which are now
blacklisted by default.

This is breaking a number of CTS tests on GL & Vulkan :

  KHR-GL45.pipeline_statistics_query_tests_ARB.functional_fragment_shader_invocations (GL)

  dEQP-VK.query_pool.statistics_query.fragment_shader_invocations.* (Vulkan)

v2: Only use one whitelist entry (Lionel)

Signed-off-by: Lionel Landwerlin <lionel.g.landwerlin@intel.com>
Cc: stable@vger.kernel.org
---
 drivers/gpu/drm/i915/gt/intel_workarounds.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/gt/intel_workarounds.c b/drivers/gpu/drm/i915/gt/intel_workarounds.c
index 993804d09517..b117583e38bb 100644
--- a/drivers/gpu/drm/i915/gt/intel_workarounds.c
+++ b/drivers/gpu/drm/i915/gt/intel_workarounds.c
@@ -1092,10 +1092,25 @@ static void glk_whitelist_build(struct intel_engine_cs *engine)
 
 static void cfl_whitelist_build(struct intel_engine_cs *engine)
 {
+	struct i915_wa_list *w = &engine->whitelist;
+
 	if (engine->class != RENDER_CLASS)
 		return;
 
-	gen9_whitelist_build(&engine->whitelist);
+	gen9_whitelist_build(w);
+
+	/*
+	 * WaAllowPMDepthAndInvocationCountAccessFromUMD:cfl,whl,cml,aml
+	 *
+	 * This covers 4 register which are next to one another :
+	 *   - PS_INVOCATION_COUNT
+	 *   - PS_INVOCATION_COUNT_UDW
+	 *   - PS_DEPTH_COUNT
+	 *   - PS_DEPTH_COUNT_UDW
+	 */
+	whitelist_reg_ext(w, PS_INVOCATION_COUNT,
+			  RING_FORCE_TO_NONPRIV_RD |
+			  RING_FORCE_TO_NONPRIV_RANGE_4);
 }
 
 static void cnl_whitelist_build(struct intel_engine_cs *engine)
-- 
2.21.0.392.gf8f6787159e

