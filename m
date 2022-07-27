Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31CF0582684
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 14:30:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233016AbiG0MaF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 08:30:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232995AbiG0MaC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 08:30:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 803F51839B;
        Wed, 27 Jul 2022 05:30:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1DCED6108B;
        Wed, 27 Jul 2022 12:30:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A9BDC433B5;
        Wed, 27 Jul 2022 12:30:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658925000;
        bh=+RB6a52AG9Wuuej9xwxTPJsBVg63GQuYFqKk14nxsL8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kFS31LTGWtu6UsyHZFhoWgN+gAxEp6uDD8BAlgj113QA/7KmExjepcsOVktSS+Du4
         fT4I9aZU/g/TPNMUcpD89DD7h4M3ejCXieWgAGMUqKlt0TuOvSpCip8RRJcw/YhOMH
         3o8TKjS0W1K5vmOF7Utyn22jlfBZfUKapGw+AJKD2vMPw9j70vYOd09Y3U1Z4gUsw7
         LP93q7TDhe4KkSs7h+mBOBaCcq/96RgFxqRwm2J+0HKqPvyb+PlNkzIPBASXOiHIp+
         n3gi0Vsp3fqQqarQHLlbu0H7e9AB1JhvSim4CmR8LdR+gJuu/ZG1n+IKBtEoH1KWdD
         LXY6TuKwwibnA==
Received: from mchehab by mail.kernel.org with local (Exim 4.95)
        (envelope-from <mchehab@kernel.org>)
        id 1oGgAo-003xm9-6i;
        Wed, 27 Jul 2022 14:29:58 +0200
From:   Mauro Carvalho Chehab <mchehab@kernel.org>
Cc:     Chris Wilson <chris.p.wilson@intel.com>,
        =?UTF-8?q?Thomas=20Hellstr=C3=B6m?= 
        <thomas.hellstrom@linux.intel.com>,
        Andi Shyti <andi.shyti@linux.intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>,
        Dave Airlie <airlied@redhat.com>,
        David Airlie <airlied@linux.ie>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        John Harrison <John.C.Harrison@Intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Lucas De Marchi <lucas.demarchi@intel.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Matt Roper <matthew.d.roper@intel.com>,
        Matthew Auld <matthew.auld@intel.com>,
        Matthew Brost <matthew.brost@intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Fei Yang <fei.yang@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Subject: [PATCH v3 1/6] drm/i915/gt: Ignore TLB invalidations on idle engines
Date:   Wed, 27 Jul 2022 14:29:51 +0200
Message-Id: <278a57a672edac75683f0818b292e95da583a5fe.1658924372.git.mchehab@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1658924372.git.mchehab@kernel.org>
References: <cover.1658924372.git.mchehab@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Wilson <chris.p.wilson@intel.com>

Check if the device is powered down prior to any engine activity,
as, on such cases, all the TLBs were already invalidated, so an
explicit TLB invalidation is not needed, thus reducing the
performance regression impact due to it.

This becomes more significant with GuC, as it can only do so when
the connection to the GuC is awake.

Cc: stable@vger.kernel.org
Fixes: 7938d61591d3 ("drm/i915: Flush TLBs before releasing backing store")
Signed-off-by: Chris Wilson <chris.p.wilson@intel.com>
Cc: Fei Yang <fei.yang@intel.com>
Reviewed-by: Andi Shyti <andi.shyti@linux.intel.com>
Acked-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Acked-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
---

To avoid mailbombing on a large number of people, only mailing lists were C/C on the cover.
See [PATCH v3 0/6] at: https://lore.kernel.org/all/cover.1658924372.git.mchehab@kernel.org/

 drivers/gpu/drm/i915/gem/i915_gem_pages.c | 10 ++++++----
 drivers/gpu/drm/i915/gt/intel_gt.c        | 17 ++++++++++-------
 drivers/gpu/drm/i915/gt/intel_gt_pm.h     |  3 +++
 3 files changed, 19 insertions(+), 11 deletions(-)

diff --git a/drivers/gpu/drm/i915/gem/i915_gem_pages.c b/drivers/gpu/drm/i915/gem/i915_gem_pages.c
index 97c820eee115..6835279943df 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_pages.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_pages.c
@@ -6,14 +6,15 @@
 
 #include <drm/drm_cache.h>
 
+#include "gt/intel_gt.h"
+#include "gt/intel_gt_pm.h"
+
 #include "i915_drv.h"
 #include "i915_gem_object.h"
 #include "i915_scatterlist.h"
 #include "i915_gem_lmem.h"
 #include "i915_gem_mman.h"
 
-#include "gt/intel_gt.h"
-
 void __i915_gem_object_set_pages(struct drm_i915_gem_object *obj,
 				 struct sg_table *pages,
 				 unsigned int sg_page_sizes)
@@ -217,10 +218,11 @@ __i915_gem_object_unset_pages(struct drm_i915_gem_object *obj)
 
 	if (test_and_clear_bit(I915_BO_WAS_BOUND_BIT, &obj->flags)) {
 		struct drm_i915_private *i915 = to_i915(obj->base.dev);
+		struct intel_gt *gt = to_gt(i915);
 		intel_wakeref_t wakeref;
 
-		with_intel_runtime_pm_if_active(&i915->runtime_pm, wakeref)
-			intel_gt_invalidate_tlbs(to_gt(i915));
+		with_intel_gt_pm_if_awake(gt, wakeref)
+			intel_gt_invalidate_tlbs(gt);
 	}
 
 	return pages;
diff --git a/drivers/gpu/drm/i915/gt/intel_gt.c b/drivers/gpu/drm/i915/gt/intel_gt.c
index 68c2b0d8f187..c4d43da84d8e 100644
--- a/drivers/gpu/drm/i915/gt/intel_gt.c
+++ b/drivers/gpu/drm/i915/gt/intel_gt.c
@@ -12,6 +12,7 @@
 
 #include "i915_drv.h"
 #include "intel_context.h"
+#include "intel_engine_pm.h"
 #include "intel_engine_regs.h"
 #include "intel_ggtt_gmch.h"
 #include "intel_gt.h"
@@ -924,6 +925,7 @@ void intel_gt_invalidate_tlbs(struct intel_gt *gt)
 	struct drm_i915_private *i915 = gt->i915;
 	struct intel_uncore *uncore = gt->uncore;
 	struct intel_engine_cs *engine;
+	intel_engine_mask_t awake, tmp;
 	enum intel_engine_id id;
 	const i915_reg_t *regs;
 	unsigned int num = 0;
@@ -947,26 +949,31 @@ void intel_gt_invalidate_tlbs(struct intel_gt *gt)
 
 	GEM_TRACE("\n");
 
-	assert_rpm_wakelock_held(&i915->runtime_pm);
-
 	mutex_lock(&gt->tlb_invalidate_lock);
 	intel_uncore_forcewake_get(uncore, FORCEWAKE_ALL);
 
 	spin_lock_irq(&uncore->lock); /* serialise invalidate with GT reset */
 
+	awake = 0;
 	for_each_engine(engine, gt, id) {
 		struct reg_and_bit rb;
 
+		if (!intel_engine_pm_is_awake(engine))
+			continue;
+
 		rb = get_reg_and_bit(engine, regs == gen8_regs, regs, num);
 		if (!i915_mmio_reg_offset(rb.reg))
 			continue;
 
 		intel_uncore_write_fw(uncore, rb.reg, rb.bit);
+		awake |= engine->mask;
 	}
 
 	spin_unlock_irq(&uncore->lock);
 
-	for_each_engine(engine, gt, id) {
+	for_each_engine_masked(engine, gt, awake, tmp) {
+		struct reg_and_bit rb;
+
 		/*
 		 * HW architecture suggest typical invalidation time at 40us,
 		 * with pessimistic cases up to 100us and a recommendation to
@@ -974,12 +981,8 @@ void intel_gt_invalidate_tlbs(struct intel_gt *gt)
 		 */
 		const unsigned int timeout_us = 100;
 		const unsigned int timeout_ms = 4;
-		struct reg_and_bit rb;
 
 		rb = get_reg_and_bit(engine, regs == gen8_regs, regs, num);
-		if (!i915_mmio_reg_offset(rb.reg))
-			continue;
-
 		if (__intel_wait_for_register_fw(uncore,
 						 rb.reg, rb.bit, 0,
 						 timeout_us, timeout_ms,
diff --git a/drivers/gpu/drm/i915/gt/intel_gt_pm.h b/drivers/gpu/drm/i915/gt/intel_gt_pm.h
index bc898df7a48c..a334787a4939 100644
--- a/drivers/gpu/drm/i915/gt/intel_gt_pm.h
+++ b/drivers/gpu/drm/i915/gt/intel_gt_pm.h
@@ -55,6 +55,9 @@ static inline void intel_gt_pm_might_put(struct intel_gt *gt)
 	for (tmp = 1, intel_gt_pm_get(gt); tmp; \
 	     intel_gt_pm_put(gt), tmp = 0)
 
+#define with_intel_gt_pm_if_awake(gt, wf) \
+	for (wf = intel_gt_pm_get_if_awake(gt); wf; intel_gt_pm_put_async(gt), wf = 0)
+
 static inline int intel_gt_pm_wait_for_idle(struct intel_gt *gt)
 {
 	return intel_wakeref_wait_for_idle(&gt->wakeref);
-- 
2.36.1

