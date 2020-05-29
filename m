Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A2911E7822
	for <lists+stable@lfdr.de>; Fri, 29 May 2020 10:20:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726393AbgE2IUn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 May 2020 04:20:43 -0400
Received: from mga18.intel.com ([134.134.136.126]:10357 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725821AbgE2IUm (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 29 May 2020 04:20:42 -0400
IronPort-SDR: gAnRgBTujV2UZWKMH+R8KaD/rFQsDNjXlDGpExWz2MW7S3YGVlvk1GmByWZmKT7uIF/RL7ggvj
 239PkWEkVOpg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2020 01:20:41 -0700
IronPort-SDR: WeLuzR9vjP6Jrn4wEIL9DNgz/Z9njFO9C5RT7qVoMIlekaxco1zyp582SEa+VMAdBxMcXSnsQ1
 RjP75Sz5XsRw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,447,1583222400"; 
   d="scan'208";a="376641847"
Received: from vtt.iind.intel.com ([10.145.162.194])
  by fmsmga001.fm.intel.com with ESMTP; 29 May 2020 01:20:38 -0700
From:   Prasad Nallani <prasad.nallani@intel.com>
To:     gfx-internal-devel@eclists.intel.com
Cc:     andi.shyti@intel.com, Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Michal Mrozek <michal.mrozek@intel.com>,
        stable@vger.kernel.org, Michal Mrozek <Michal.mrozek@intel.com>
Subject: [PATCH 11/23] drm/i915/gen12: Disable preemption timeout
Date:   Fri, 29 May 2020 13:47:58 +0530
Message-Id: <20200529081810.10747-12-prasad.nallani@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200529081810.10747-1-prasad.nallani@intel.com>
References: <20200529081810.10747-1-prasad.nallani@intel.com>
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
Cc: <stable@vger.kernel.org> # v5.6+
Acked-by: Chris Wilson <chris@chris-wilson.co.uk>
Acked-by: Michal Mrozek <Michal.mrozek@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200312115748.29970-1-tvrtko.ursulin@linux.intel.com
(cherry picked from commit 07bcfd1291de77ffa9b627b4442783aba1335229)
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
index 8bab5767f30c..b42001f937dd 100644
--- a/drivers/gpu/drm/i915/gt/intel_engine_cs.c
+++ b/drivers/gpu/drm/i915/gt/intel_engine_cs.c
@@ -274,6 +274,7 @@ static void intel_engine_sanitize_mmio(struct intel_engine_cs *engine)
 static int intel_engine_setup(struct intel_gt *gt, enum intel_engine_id id)
 {
 	const struct engine_info *info = &intel_engines[id];
+	struct drm_i915_private *i915 = gt->i915;
 	struct intel_engine_cs *engine;
 
 	BUILD_BUG_ON(MAX_ENGINE_CLASS >= BIT(GEN11_ENGINE_CLASS_WIDTH));
@@ -300,11 +301,11 @@ static int intel_engine_setup(struct intel_gt *gt, enum intel_engine_id id)
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
@@ -321,11 +322,15 @@ static int intel_engine_setup(struct intel_gt *gt, enum intel_engine_id id)
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
@@ -341,7 +346,7 @@ static int intel_engine_setup(struct intel_gt *gt, enum intel_engine_id id)
 	gt->engine_class[info->class][info->instance] = engine;
 	gt->engine[id] = engine;
 
-	gt->i915->engine[id] = engine;
+	i915->engine[id] = engine;
 
 	return 0;
 }
