Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93FCD182FAB
	for <lists+stable@lfdr.de>; Thu, 12 Mar 2020 12:57:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727064AbgCLL5b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Mar 2020 07:57:31 -0400
Received: from mga12.intel.com ([192.55.52.136]:63387 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726302AbgCLL5b (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 12 Mar 2020 07:57:31 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Mar 2020 04:57:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,544,1574150400"; 
   d="scan'208";a="236807428"
Received: from pkosiack-mobl2.ger.corp.intel.com (HELO localhost.localdomain) ([10.252.21.27])
  by orsmga008.jf.intel.com with ESMTP; 12 Mar 2020 04:57:29 -0700
From:   Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
To:     Intel-gfx@lists.freedesktop.org
Cc:     Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Michal Mrozek <michal.mrozek@intel.com>,
        "Cc :" <stable@vger.kernel.org>
Subject: [PATCH v3] drm/i915/gen12: Disable preemption timeout
Date:   Thu, 12 Mar 2020 11:57:26 +0000
Message-Id: <20200312115726.29711-1-tvrtko.ursulin@linux.intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200310162428.4249-1-tvrtko.ursulin@linux.intel.com>
References: <20200310162428.4249-1-tvrtko.ursulin@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tvrtko Ursulin <tvrtko.ursulin@intel.com>

Allow super long OpenCL workloads which cannot be preempted within
the default timeout to run out of the box.

v2:
 * Make it stick out more and apply only to RCS. (Chris)

v3:
 * Mention platform override in kconfig. (Joonas)

Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: Michal Mrozek <michal.mrozek@intel.com>
Cc: Cc: <stable@vger.kernel.org> # v5.6+
Acked-by: Chris Wilson <chris@chris-wilson.co.uk>
---
 drivers/gpu/drm/i915/Kconfig.profile      |  4 ++++
 drivers/gpu/drm/i915/gt/intel_engine_cs.c | 13 +++++++++----
 2 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/i915/Kconfig.profile b/drivers/gpu/drm/i915/Kconfig.profile
index ba8767fc0d6e..0bfd276c19fe 100644
--- a/drivers/gpu/drm/i915/Kconfig.profile
+++ b/drivers/gpu/drm/i915/Kconfig.profile
@@ -41,6 +41,10 @@ config DRM_I915_PREEMPT_TIMEOUT
 
 	  May be 0 to disable the timeout.
 
+	  The compiled in default may get overridden at driver probe time on
+	  certain platforms and certain engines which will be reflected in the
+	  sysfs control.
+
 config DRM_I915_MAX_REQUEST_BUSYWAIT
 	int "Busywait for request completion limit (ns)"
 	default 8000 # nanoseconds
diff --git a/drivers/gpu/drm/i915/gt/intel_engine_cs.c b/drivers/gpu/drm/i915/gt/intel_engine_cs.c
index 8eeec87b7d72..3aa8a652c16d 100644
--- a/drivers/gpu/drm/i915/gt/intel_engine_cs.c
+++ b/drivers/gpu/drm/i915/gt/intel_engine_cs.c
@@ -275,6 +275,7 @@ static void intel_engine_sanitize_mmio(struct intel_engine_cs *engine)
 static int intel_engine_setup(struct intel_gt *gt, enum intel_engine_id id)
 {
 	const struct engine_info *info = &intel_engines[id];
+	struct drm_i915_private *i915 = gt->i915;
 	struct intel_engine_cs *engine;
 
 	BUILD_BUG_ON(MAX_ENGINE_CLASS >= BIT(GEN11_ENGINE_CLASS_WIDTH));
@@ -301,11 +302,11 @@ static int intel_engine_setup(struct intel_gt *gt, enum intel_engine_id id)
 	engine->id = id;
 	engine->legacy_idx = INVALID_ENGINE;
 	engine->mask = BIT(id);
-	engine->i915 = gt->i915;
+	engine->i915 = i915;
 	engine->gt = gt;
 	engine->uncore = gt->uncore;
 	engine->hw_id = engine->guc_id = info->hw_id;
-	engine->mmio_base = __engine_mmio_base(gt->i915, info->mmio_bases);
+	engine->mmio_base = __engine_mmio_base(i915, info->mmio_bases);
 
 	engine->class = info->class;
 	engine->instance = info->instance;
@@ -322,11 +323,15 @@ static int intel_engine_setup(struct intel_gt *gt, enum intel_engine_id id)
 	engine->props.timeslice_duration_ms =
 		CONFIG_DRM_I915_TIMESLICE_DURATION;
 
+	/* Override to uninterruptible for OpenCL workloads. */
+	if (INTEL_GEN(i915) == 12 && engine->class == RENDER_CLASS)
+		engine->props.preempt_timeout_ms = 0;
+
 	engine->context_size = intel_engine_context_size(gt, engine->class);
 	if (WARN_ON(engine->context_size > BIT(20)))
 		engine->context_size = 0;
 	if (engine->context_size)
-		DRIVER_CAPS(gt->i915)->has_logical_contexts = true;
+		DRIVER_CAPS(i915)->has_logical_contexts = true;
 
 	/* Nothing to do here, execute in order of dependencies */
 	engine->schedule = NULL;
@@ -342,7 +347,7 @@ static int intel_engine_setup(struct intel_gt *gt, enum intel_engine_id id)
 	gt->engine_class[info->class][info->instance] = engine;
 	gt->engine[id] = engine;
 
-	gt->i915->engine[id] = engine;
+	i915->engine[id] = engine;
 
 	return 0;
 }
-- 
2.20.1

