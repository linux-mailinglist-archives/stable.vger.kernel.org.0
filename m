Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FBF6657BA6
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:24:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233699AbiL1PYA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:24:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233702AbiL1PX7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:23:59 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F10F212747
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:23:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 135E4CE1368
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:23:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 002E0C433F0;
        Wed, 28 Dec 2022 15:23:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672241034;
        bh=bc9O+d84c7NHeZE6xjLUt6Re3l+Dg+FVboU1BjtuO30=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DGNc68WJUii6ga5RR8Qbk5zouDLEvEXnSxsMlB5iMh0xhHFR9H0736OpFA9GiARhi
         jkrH/8EDfFD7QuLAhSE+ntcS4j92H3BfEfO9qp72gWkAZHnFMPU0X8vm2AroB/piwn
         SDJr5rtFiCRm+elTy49Bh2qLas/AYIDtbx8PTaFY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, John Harrison <John.C.Harrison@Intel.com>,
        Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0232/1073] drm/i915/guc: Limit scheduling properties to avoid overflow
Date:   Wed, 28 Dec 2022 15:30:20 +0100
Message-Id: <20221228144334.327980224@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Harrison <John.C.Harrison@Intel.com>

[ Upstream commit 568944af44e7538ed5d1389dabf56e938afdaf4f ]

GuC converts the pre-emption timeout and timeslice quantum values into
clock ticks internally. That significantly reduces the point of 32bit
overflow. On current platforms, worst case scenario is approximately
110 seconds. Rather than allowing the user to set higher values and
then get confused by early timeouts, add limits when setting these
values.

v2: Add helper functions for clamping (review feedback from Tvrtko).
v3: Add a bunch of BUG_ON range checks in addition to the checks
already in the clamping functions (Tvrtko)

Signed-off-by: John Harrison <John.C.Harrison@Intel.com>
Reviewed-by: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
Acked-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20221006213813.1563435-2-John.C.Harrison@Intel.com
Stable-dep-of: c3bd49cd9a10 ("drm/i915: Fix compute pre-emption w/a to apply to compute engines")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/gt/intel_engine.h        |  6 ++
 drivers/gpu/drm/i915/gt/intel_engine_cs.c     | 69 +++++++++++++++++++
 drivers/gpu/drm/i915/gt/sysfs_engines.c       | 25 ++++---
 drivers/gpu/drm/i915/gt/uc/intel_guc_fwif.h   | 21 ++++++
 .../gpu/drm/i915/gt/uc/intel_guc_submission.c |  8 +++
 5 files changed, 119 insertions(+), 10 deletions(-)

diff --git a/drivers/gpu/drm/i915/gt/intel_engine.h b/drivers/gpu/drm/i915/gt/intel_engine.h
index 04e435bce79b..cbc8b857d5f7 100644
--- a/drivers/gpu/drm/i915/gt/intel_engine.h
+++ b/drivers/gpu/drm/i915/gt/intel_engine.h
@@ -348,4 +348,10 @@ intel_engine_get_hung_context(struct intel_engine_cs *engine)
 	return engine->hung_ce;
 }
 
+u64 intel_clamp_heartbeat_interval_ms(struct intel_engine_cs *engine, u64 value);
+u64 intel_clamp_max_busywait_duration_ns(struct intel_engine_cs *engine, u64 value);
+u64 intel_clamp_preempt_timeout_ms(struct intel_engine_cs *engine, u64 value);
+u64 intel_clamp_stop_timeout_ms(struct intel_engine_cs *engine, u64 value);
+u64 intel_clamp_timeslice_duration_ms(struct intel_engine_cs *engine, u64 value);
+
 #endif /* _INTEL_RINGBUFFER_H_ */
diff --git a/drivers/gpu/drm/i915/gt/intel_engine_cs.c b/drivers/gpu/drm/i915/gt/intel_engine_cs.c
index 37fa813af766..699308a1323d 100644
--- a/drivers/gpu/drm/i915/gt/intel_engine_cs.c
+++ b/drivers/gpu/drm/i915/gt/intel_engine_cs.c
@@ -512,6 +512,26 @@ static int intel_engine_setup(struct intel_gt *gt, enum intel_engine_id id,
 		engine->flags |= I915_ENGINE_HAS_EU_PRIORITY;
 	}
 
+	/* Cap properties according to any system limits */
+#define CLAMP_PROP(field) \
+	do { \
+		u64 clamp = intel_clamp_##field(engine, engine->props.field); \
+		if (clamp != engine->props.field) { \
+			drm_notice(&engine->i915->drm, \
+				   "Warning, clamping %s to %lld to prevent overflow\n", \
+				   #field, clamp); \
+			engine->props.field = clamp; \
+		} \
+	} while (0)
+
+	CLAMP_PROP(heartbeat_interval_ms);
+	CLAMP_PROP(max_busywait_duration_ns);
+	CLAMP_PROP(preempt_timeout_ms);
+	CLAMP_PROP(stop_timeout_ms);
+	CLAMP_PROP(timeslice_duration_ms);
+
+#undef CLAMP_PROP
+
 	engine->defaults = engine->props; /* never to change again */
 
 	engine->context_size = intel_engine_context_size(gt, engine->class);
@@ -534,6 +554,55 @@ static int intel_engine_setup(struct intel_gt *gt, enum intel_engine_id id,
 	return 0;
 }
 
+u64 intel_clamp_heartbeat_interval_ms(struct intel_engine_cs *engine, u64 value)
+{
+	value = min_t(u64, value, jiffies_to_msecs(MAX_SCHEDULE_TIMEOUT));
+
+	return value;
+}
+
+u64 intel_clamp_max_busywait_duration_ns(struct intel_engine_cs *engine, u64 value)
+{
+	value = min(value, jiffies_to_nsecs(2));
+
+	return value;
+}
+
+u64 intel_clamp_preempt_timeout_ms(struct intel_engine_cs *engine, u64 value)
+{
+	/*
+	 * NB: The GuC API only supports 32bit values. However, the limit is further
+	 * reduced due to internal calculations which would otherwise overflow.
+	 */
+	if (intel_guc_submission_is_wanted(&engine->gt->uc.guc))
+		value = min_t(u64, value, guc_policy_max_preempt_timeout_ms());
+
+	value = min_t(u64, value, jiffies_to_msecs(MAX_SCHEDULE_TIMEOUT));
+
+	return value;
+}
+
+u64 intel_clamp_stop_timeout_ms(struct intel_engine_cs *engine, u64 value)
+{
+	value = min_t(u64, value, jiffies_to_msecs(MAX_SCHEDULE_TIMEOUT));
+
+	return value;
+}
+
+u64 intel_clamp_timeslice_duration_ms(struct intel_engine_cs *engine, u64 value)
+{
+	/*
+	 * NB: The GuC API only supports 32bit values. However, the limit is further
+	 * reduced due to internal calculations which would otherwise overflow.
+	 */
+	if (intel_guc_submission_is_wanted(&engine->gt->uc.guc))
+		value = min_t(u64, value, guc_policy_max_exec_quantum_ms());
+
+	value = min_t(u64, value, jiffies_to_msecs(MAX_SCHEDULE_TIMEOUT));
+
+	return value;
+}
+
 static void __setup_engine_capabilities(struct intel_engine_cs *engine)
 {
 	struct drm_i915_private *i915 = engine->i915;
diff --git a/drivers/gpu/drm/i915/gt/sysfs_engines.c b/drivers/gpu/drm/i915/gt/sysfs_engines.c
index 967031056202..f2d9858d827c 100644
--- a/drivers/gpu/drm/i915/gt/sysfs_engines.c
+++ b/drivers/gpu/drm/i915/gt/sysfs_engines.c
@@ -144,7 +144,7 @@ max_spin_store(struct kobject *kobj, struct kobj_attribute *attr,
 	       const char *buf, size_t count)
 {
 	struct intel_engine_cs *engine = kobj_to_engine(kobj);
-	unsigned long long duration;
+	unsigned long long duration, clamped;
 	int err;
 
 	/*
@@ -168,7 +168,8 @@ max_spin_store(struct kobject *kobj, struct kobj_attribute *attr,
 	if (err)
 		return err;
 
-	if (duration > jiffies_to_nsecs(2))
+	clamped = intel_clamp_max_busywait_duration_ns(engine, duration);
+	if (duration != clamped)
 		return -EINVAL;
 
 	WRITE_ONCE(engine->props.max_busywait_duration_ns, duration);
@@ -203,7 +204,7 @@ timeslice_store(struct kobject *kobj, struct kobj_attribute *attr,
 		const char *buf, size_t count)
 {
 	struct intel_engine_cs *engine = kobj_to_engine(kobj);
-	unsigned long long duration;
+	unsigned long long duration, clamped;
 	int err;
 
 	/*
@@ -218,7 +219,8 @@ timeslice_store(struct kobject *kobj, struct kobj_attribute *attr,
 	if (err)
 		return err;
 
-	if (duration > jiffies_to_msecs(MAX_SCHEDULE_TIMEOUT))
+	clamped = intel_clamp_timeslice_duration_ms(engine, duration);
+	if (duration != clamped)
 		return -EINVAL;
 
 	WRITE_ONCE(engine->props.timeslice_duration_ms, duration);
@@ -256,7 +258,7 @@ stop_store(struct kobject *kobj, struct kobj_attribute *attr,
 	   const char *buf, size_t count)
 {
 	struct intel_engine_cs *engine = kobj_to_engine(kobj);
-	unsigned long long duration;
+	unsigned long long duration, clamped;
 	int err;
 
 	/*
@@ -272,7 +274,8 @@ stop_store(struct kobject *kobj, struct kobj_attribute *attr,
 	if (err)
 		return err;
 
-	if (duration > jiffies_to_msecs(MAX_SCHEDULE_TIMEOUT))
+	clamped = intel_clamp_stop_timeout_ms(engine, duration);
+	if (duration != clamped)
 		return -EINVAL;
 
 	WRITE_ONCE(engine->props.stop_timeout_ms, duration);
@@ -306,7 +309,7 @@ preempt_timeout_store(struct kobject *kobj, struct kobj_attribute *attr,
 		      const char *buf, size_t count)
 {
 	struct intel_engine_cs *engine = kobj_to_engine(kobj);
-	unsigned long long timeout;
+	unsigned long long timeout, clamped;
 	int err;
 
 	/*
@@ -322,7 +325,8 @@ preempt_timeout_store(struct kobject *kobj, struct kobj_attribute *attr,
 	if (err)
 		return err;
 
-	if (timeout > jiffies_to_msecs(MAX_SCHEDULE_TIMEOUT))
+	clamped = intel_clamp_preempt_timeout_ms(engine, timeout);
+	if (timeout != clamped)
 		return -EINVAL;
 
 	WRITE_ONCE(engine->props.preempt_timeout_ms, timeout);
@@ -362,7 +366,7 @@ heartbeat_store(struct kobject *kobj, struct kobj_attribute *attr,
 		const char *buf, size_t count)
 {
 	struct intel_engine_cs *engine = kobj_to_engine(kobj);
-	unsigned long long delay;
+	unsigned long long delay, clamped;
 	int err;
 
 	/*
@@ -379,7 +383,8 @@ heartbeat_store(struct kobject *kobj, struct kobj_attribute *attr,
 	if (err)
 		return err;
 
-	if (delay >= jiffies_to_msecs(MAX_SCHEDULE_TIMEOUT))
+	clamped = intel_clamp_heartbeat_interval_ms(engine, delay);
+	if (delay != clamped)
 		return -EINVAL;
 
 	err = intel_engine_set_heartbeat(engine, delay);
diff --git a/drivers/gpu/drm/i915/gt/uc/intel_guc_fwif.h b/drivers/gpu/drm/i915/gt/uc/intel_guc_fwif.h
index 323b055e5db9..502e7cb5a302 100644
--- a/drivers/gpu/drm/i915/gt/uc/intel_guc_fwif.h
+++ b/drivers/gpu/drm/i915/gt/uc/intel_guc_fwif.h
@@ -305,6 +305,27 @@ struct guc_update_context_policy {
 
 #define GLOBAL_POLICY_DEFAULT_DPC_PROMOTE_TIME_US 500000
 
+/*
+ * GuC converts the timeout to clock ticks internally. Different platforms have
+ * different GuC clocks. Thus, the maximum value before overflow is platform
+ * dependent. Current worst case scenario is about 110s. So, the spec says to
+ * limit to 100s to be safe.
+ */
+#define GUC_POLICY_MAX_EXEC_QUANTUM_US		(100 * 1000 * 1000UL)
+#define GUC_POLICY_MAX_PREEMPT_TIMEOUT_US	(100 * 1000 * 1000UL)
+
+static inline u32 guc_policy_max_exec_quantum_ms(void)
+{
+	BUILD_BUG_ON(GUC_POLICY_MAX_EXEC_QUANTUM_US >= UINT_MAX);
+	return GUC_POLICY_MAX_EXEC_QUANTUM_US / 1000;
+}
+
+static inline u32 guc_policy_max_preempt_timeout_ms(void)
+{
+	BUILD_BUG_ON(GUC_POLICY_MAX_PREEMPT_TIMEOUT_US >= UINT_MAX);
+	return GUC_POLICY_MAX_PREEMPT_TIMEOUT_US / 1000;
+}
+
 struct guc_policies {
 	u32 submission_queue_depth[GUC_MAX_ENGINE_CLASSES];
 	/* In micro seconds. How much time to allow before DPC processing is
diff --git a/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c b/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c
index fe179146d51b..cd0c5043863b 100644
--- a/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c
+++ b/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c
@@ -2430,6 +2430,10 @@ static int guc_context_policy_init_v70(struct intel_context *ce, bool loop)
 	int ret;
 
 	/* NB: For both of these, zero means disabled. */
+	GEM_BUG_ON(overflows_type(engine->props.timeslice_duration_ms * 1000,
+				  execution_quantum));
+	GEM_BUG_ON(overflows_type(engine->props.preempt_timeout_ms * 1000,
+				  preemption_timeout));
 	execution_quantum = engine->props.timeslice_duration_ms * 1000;
 	preemption_timeout = engine->props.preempt_timeout_ms * 1000;
 
@@ -2486,6 +2490,10 @@ static void guc_context_policy_init_v69(struct intel_engine_cs *engine,
 		desc->policy_flags |= CONTEXT_POLICY_FLAG_PREEMPT_TO_IDLE_V69;
 
 	/* NB: For both of these, zero means disabled. */
+	GEM_BUG_ON(overflows_type(engine->props.timeslice_duration_ms * 1000,
+				  desc->execution_quantum));
+	GEM_BUG_ON(overflows_type(engine->props.preempt_timeout_ms * 1000,
+				  desc->preemption_timeout));
 	desc->execution_quantum = engine->props.timeslice_duration_ms * 1000;
 	desc->preemption_timeout = engine->props.preempt_timeout_ms * 1000;
 }
-- 
2.35.1



