Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4508B75FEF
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 09:36:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726023AbfGZHgM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 03:36:12 -0400
Received: from mga14.intel.com ([192.55.52.115]:41199 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725869AbfGZHgM (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jul 2019 03:36:12 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Jul 2019 00:36:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,310,1559545200"; 
   d="scan'208";a="369967767"
Received: from jlahtine-desk.ger.corp.intel.com ([10.252.2.51])
  by fmsmga006.fm.intel.com with ESMTP; 26 Jul 2019 00:36:11 -0700
From:   Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
To:     stable@vger.kernel.org
Subject: [PATCH 7/8] drm/i915/icl: whitelist PS_(DEPTH|INVOCATION)_COUNT
Date:   Fri, 26 Jul 2019 10:35:55 +0300
Message-Id: <20190726073556.9011-8-joonas.lahtinen@linux.intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190726073556.9011-1-joonas.lahtinen@linux.intel.com>
References: <20190726073556.9011-1-joonas.lahtinen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lionel Landwerlin <lionel.g.landwerlin@intel.com>

The same tests failing on CFL+ platforms are also failing on ICL.
Documentation doesn't list the
WaAllowPMDepthAndInvocationCountAccessFromUMD workaround for ICL but
applying it fixes the same tests as CFL.

v2: Use only one whitelist entry (Lionel)

Signed-off-by: Lionel Landwerlin <lionel.g.landwerlin@intel.com>
Tested-by: Anuj Phogat <anuj.phogat@gmail.com>
Cc: stable@vger.kernel.org
Acked-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Link: https://patchwork.freedesktop.org/patch/msgid/20190628120720.21682-4-lionel.g.landwerlin@intel.com
(cherry picked from commit 3fe0107e45ab396342497e06b8924cdd485cde3b)
Cc: stable@vger.kernel.org # 6883eab27481: drm/i915: Support flags in whitlist WAs
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
---
 drivers/gpu/drm/i915/intel_workarounds.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/gpu/drm/i915/intel_workarounds.c b/drivers/gpu/drm/i915/intel_workarounds.c
index bd964fbc667b..5e54de630ef1 100644
--- a/drivers/gpu/drm/i915/intel_workarounds.c
+++ b/drivers/gpu/drm/i915/intel_workarounds.c
@@ -1075,6 +1075,19 @@ static void icl_whitelist_build(struct i915_wa_list *w)
 
 	/* WaEnableStateCacheRedirectToCS:icl */
 	whitelist_reg(w, GEN9_SLICE_COMMON_ECO_CHICKEN1);
+
+	/*
+	 * WaAllowPMDepthAndInvocationCountAccessFromUMD:icl
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
 
 void intel_engine_init_whitelist(struct intel_engine_cs *engine)
-- 
2.20.1

