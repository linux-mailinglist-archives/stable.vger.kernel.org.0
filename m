Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F97C75FED
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 09:36:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725981AbfGZHgL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 03:36:11 -0400
Received: from mga14.intel.com ([192.55.52.115]:41199 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725869AbfGZHgK (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jul 2019 03:36:10 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Jul 2019 00:36:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,310,1559545200"; 
   d="scan'208";a="369967758"
Received: from jlahtine-desk.ger.corp.intel.com ([10.252.2.51])
  by fmsmga006.fm.intel.com with ESMTP; 26 Jul 2019 00:36:09 -0700
From:   Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
To:     stable@vger.kernel.org
Subject: [PATCH 5/8] drm/i915: Support flags in whitlist WAs
Date:   Fri, 26 Jul 2019 10:35:53 +0300
Message-Id: <20190726073556.9011-6-joonas.lahtinen@linux.intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190726073556.9011-1-joonas.lahtinen@linux.intel.com>
References: <20190726073556.9011-1-joonas.lahtinen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Harrison <John.C.Harrison@Intel.com>

Newer hardware adds flags to the whitelist work-around register. These
allow per access direction privileges and ranges.

Signed-off-by: John Harrison <John.C.Harrison@Intel.com>
Signed-off-by: Robert M. Fosha <robert.m.fosha@intel.com>
Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20190618010108.27499-2-John.C.Harrison@Intel.com
(cherry picked from commit 5380d0b781c491d94b4f4690ecf9762c1946c4ec)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
---
 drivers/gpu/drm/i915/i915_reg.h          | 7 +++++++
 drivers/gpu/drm/i915/intel_workarounds.c | 9 ++++++++-
 2 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/i915_reg.h b/drivers/gpu/drm/i915/i915_reg.h
index 13d6bd4e17b2..cf748b80e640 100644
--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -2510,6 +2510,13 @@ enum i915_power_well_id {
 #define   RING_WAIT_SEMAPHORE	(1 << 10) /* gen6+ */
 
 #define RING_FORCE_TO_NONPRIV(base, i) _MMIO(((base) + 0x4D0) + (i) * 4)
+#define   RING_FORCE_TO_NONPRIV_RW		(0 << 28)    /* CFL+ & Gen11+ */
+#define   RING_FORCE_TO_NONPRIV_RD		(1 << 28)
+#define   RING_FORCE_TO_NONPRIV_WR		(2 << 28)
+#define   RING_FORCE_TO_NONPRIV_RANGE_1		(0 << 0)     /* CFL+ & Gen11+ */
+#define   RING_FORCE_TO_NONPRIV_RANGE_4		(1 << 0)
+#define   RING_FORCE_TO_NONPRIV_RANGE_16	(2 << 0)
+#define   RING_FORCE_TO_NONPRIV_RANGE_64	(3 << 0)
 #define   RING_MAX_NONPRIV_SLOTS  12
 
 #define GEN7_TLB_RD_ADDR	_MMIO(0x4700)
diff --git a/drivers/gpu/drm/i915/intel_workarounds.c b/drivers/gpu/drm/i915/intel_workarounds.c
index 2fb70fab2d1c..1db826b12774 100644
--- a/drivers/gpu/drm/i915/intel_workarounds.c
+++ b/drivers/gpu/drm/i915/intel_workarounds.c
@@ -981,7 +981,7 @@ bool intel_gt_verify_workarounds(struct drm_i915_private *i915,
 }
 
 static void
-whitelist_reg(struct i915_wa_list *wal, i915_reg_t reg)
+whitelist_reg_ext(struct i915_wa_list *wal, i915_reg_t reg, u32 flags)
 {
 	struct i915_wa wa = {
 		.reg = reg
@@ -990,9 +990,16 @@ whitelist_reg(struct i915_wa_list *wal, i915_reg_t reg)
 	if (GEM_DEBUG_WARN_ON(wal->count >= RING_MAX_NONPRIV_SLOTS))
 		return;
 
+	wa.reg.reg |= flags;
 	_wa_add(wal, &wa);
 }
 
+static void
+whitelist_reg(struct i915_wa_list *wal, i915_reg_t reg)
+{
+	whitelist_reg_ext(wal, reg, RING_FORCE_TO_NONPRIV_RW);
+}
+
 static void gen9_whitelist_build(struct i915_wa_list *w)
 {
 	/* WaVFEStateAfterPipeControlwithMediaStateClear:skl,bxt,glk,cfl */
-- 
2.20.1

