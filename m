Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D247C1AC46D
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 15:59:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392585AbgDPN7f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 09:59:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:46514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2898874AbgDPN7a (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:59:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A5F072223D;
        Thu, 16 Apr 2020 13:59:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587045569;
        bh=bdSAx6aYzNsELWFGcYGhzgSpwLK7PjSAoIDJugtAde0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hbd/HDGRaztpeZBmt1xnDIuB7G5BJE1UpD5qJ3PXjupqwcGMry79TqZqzJccjyvg0
         VWZGrwrtk5XnJnvR5Bon89emLNuxciWPQjymW6qGqVcFKIiozIL0tbY0XpeqkW+ztE
         X1b8/iC7MBqP2CBIeF/oLieG5uhA+Ye1Ku2hbDxo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Michal Mrozek <michal.mrozek@intel.com>,
        Michal Mrozek <Michal.mrozek@intel.com>
Subject: [PATCH 5.6 147/254] drm/i915/gen12: Disable preemption timeout
Date:   Thu, 16 Apr 2020 15:23:56 +0200
Message-Id: <20200416131344.929475014@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131325.804095985@linuxfoundation.org>
References: <20200416131325.804095985@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tvrtko Ursulin <tvrtko.ursulin@intel.com>

commit 07bcfd1291de77ffa9b627b4442783aba1335229 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/Kconfig.profile      |    4 ++++
 drivers/gpu/drm/i915/gt/intel_engine_cs.c |   13 +++++++++----
 2 files changed, 13 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/i915/Kconfig.profile
+++ b/drivers/gpu/drm/i915/Kconfig.profile
@@ -35,6 +35,10 @@ config DRM_I915_PREEMPT_TIMEOUT
 
 	  May be 0 to disable the timeout.
 
+	  The compiled in default may get overridden at driver probe time on
+	  certain platforms and certain engines which will be reflected in the
+	  sysfs control.
+
 config DRM_I915_SPIN_REQUEST
 	int "Busywait for request completion (us)"
 	default 5 # microseconds
--- a/drivers/gpu/drm/i915/gt/intel_engine_cs.c
+++ b/drivers/gpu/drm/i915/gt/intel_engine_cs.c
@@ -274,6 +274,7 @@ static void intel_engine_sanitize_mmio(s
 static int intel_engine_setup(struct intel_gt *gt, enum intel_engine_id id)
 {
 	const struct engine_info *info = &intel_engines[id];
+	struct drm_i915_private *i915 = gt->i915;
 	struct intel_engine_cs *engine;
 
 	BUILD_BUG_ON(MAX_ENGINE_CLASS >= BIT(GEN11_ENGINE_CLASS_WIDTH));
@@ -300,11 +301,11 @@ static int intel_engine_setup(struct int
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
@@ -319,11 +320,15 @@ static int intel_engine_setup(struct int
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
@@ -339,7 +344,7 @@ static int intel_engine_setup(struct int
 	gt->engine_class[info->class][info->instance] = engine;
 	gt->engine[id] = engine;
 
-	gt->i915->engine[id] = engine;
+	i915->engine[id] = engine;
 
 	return 0;
 }


