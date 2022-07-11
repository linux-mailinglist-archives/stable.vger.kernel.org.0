Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5E4556FC3E
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:41:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233291AbiGKJlL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:41:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232941AbiGKJkh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:40:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AE11528A8;
        Mon, 11 Jul 2022 02:20:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D82DCB80E74;
        Mon, 11 Jul 2022 09:20:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44AADC34115;
        Mon, 11 Jul 2022 09:20:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531239;
        bh=AgvTkU3k01QLw4fOSHfl7ozN/LT6Ac3EchRzAxpIE7Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1Dr1mH8Hu1/UYMdnwgOGjRri1u0mOTLnuCZRJzCg1e4A5NXubupoL3bXQZrCtzolb
         rll66tIEoU8BoBJdkg3MgxWbnyY68fp62eW9PDzXCFect2yAdbFpUBLIHn7l+colj2
         Sq2XMqPKMQ+6BZbC227W5ZAyblzQgdP4g1tB4tec=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        Matthew Auld <matthew.auld@intel.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Brost Matthew <matthew.brost@intel.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        =?UTF-8?q?Thomas=20Hellstr=C3=B6m?= 
        <thomas.hellstrom@linux.intel.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 032/230] drm/i915/gt: Register the migrate contexts with their engines
Date:   Mon, 11 Jul 2022 11:04:48 +0200
Message-Id: <20220711090604.991162181@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090604.055883544@linuxfoundation.org>
References: <20220711090604.055883544@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Hellström <thomas.hellstrom@linux.intel.com>

[ Upstream commit 3e42cc61275f95fd7f022b6380b95428efe134d3 ]

Pinned contexts, like the migrate contexts need reset after resume
since their context image may have been lost. Also the GuC needs to
register pinned contexts.

Add a list to struct intel_engine_cs where we add all pinned contexts on
creation, and traverse that list at resume time to reset the pinned
contexts.

This fixes the kms_pipe_crc_basic@suspend-read-crc-pipe-a selftest for now,
but proper LMEM backup / restore is needed for full suspend functionality.
However, note that even with full LMEM backup / restore it may be
desirable to keep the reset since backing up the migrate context images
must happen using memcpy() after the migrate context has become inactive,
and for performance- and other reasons we want to avoid memcpy() from
LMEM.

Also traverse the list at guc_init_lrc_mapping() calling
guc_kernel_context_pin() for the pinned contexts, like is already done
for the kernel context.

v2:
- Don't reset the contexts on each __engine_unpark() but rather at
  resume time (Chris Wilson).
v3:
- Reset contexts in the engine sanitize callback. (Chris Wilson)

Cc: Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
Cc: Matthew Auld <matthew.auld@intel.com>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Brost Matthew <matthew.brost@intel.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Reviewed-by: Matthew Auld <matthew.auld@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210922062527.865433-6-thomas.hellstrom@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/gt/intel_context_types.h |  8 +++++++
 drivers/gpu/drm/i915/gt/intel_engine_cs.c     |  4 ++++
 drivers/gpu/drm/i915/gt/intel_engine_pm.c     | 23 +++++++++++++++++++
 drivers/gpu/drm/i915/gt/intel_engine_pm.h     |  2 ++
 drivers/gpu/drm/i915/gt/intel_engine_types.h  |  7 ++++++
 .../drm/i915/gt/intel_execlists_submission.c  |  2 ++
 .../gpu/drm/i915/gt/intel_ring_submission.c   |  3 +++
 drivers/gpu/drm/i915/gt/mock_engine.c         |  2 ++
 .../gpu/drm/i915/gt/uc/intel_guc_submission.c | 12 +++++++---
 9 files changed, 60 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/i915/gt/intel_context_types.h b/drivers/gpu/drm/i915/gt/intel_context_types.h
index e54351a170e2..a63631ea0ec4 100644
--- a/drivers/gpu/drm/i915/gt/intel_context_types.h
+++ b/drivers/gpu/drm/i915/gt/intel_context_types.h
@@ -152,6 +152,14 @@ struct intel_context {
 	/** sseu: Control eu/slice partitioning */
 	struct intel_sseu sseu;
 
+	/**
+	 * pinned_contexts_link: List link for the engine's pinned contexts.
+	 * This is only used if this is a perma-pinned kernel context and
+	 * the list is assumed to only be manipulated during driver load
+	 * or unload time so no mutex protection currently.
+	 */
+	struct list_head pinned_contexts_link;
+
 	u8 wa_bb_page; /* if set, page num reserved for context workarounds */
 
 	struct {
diff --git a/drivers/gpu/drm/i915/gt/intel_engine_cs.c b/drivers/gpu/drm/i915/gt/intel_engine_cs.c
index 0d9105a31d84..eb99441e0ada 100644
--- a/drivers/gpu/drm/i915/gt/intel_engine_cs.c
+++ b/drivers/gpu/drm/i915/gt/intel_engine_cs.c
@@ -320,6 +320,7 @@ static int intel_engine_setup(struct intel_gt *gt, enum intel_engine_id id)
 
 	BUILD_BUG_ON(BITS_PER_TYPE(engine->mask) < I915_NUM_ENGINES);
 
+	INIT_LIST_HEAD(&engine->pinned_contexts_list);
 	engine->id = id;
 	engine->legacy_idx = INVALID_ENGINE;
 	engine->mask = BIT(id);
@@ -875,6 +876,8 @@ intel_engine_create_pinned_context(struct intel_engine_cs *engine,
 		return ERR_PTR(err);
 	}
 
+	list_add_tail(&ce->pinned_contexts_link, &engine->pinned_contexts_list);
+
 	/*
 	 * Give our perma-pinned kernel timelines a separate lockdep class,
 	 * so that we can use them from within the normal user timelines
@@ -897,6 +900,7 @@ void intel_engine_destroy_pinned_context(struct intel_context *ce)
 	list_del(&ce->timeline->engine_link);
 	mutex_unlock(&hwsp->vm->mutex);
 
+	list_del(&ce->pinned_contexts_link);
 	intel_context_unpin(ce);
 	intel_context_put(ce);
 }
diff --git a/drivers/gpu/drm/i915/gt/intel_engine_pm.c b/drivers/gpu/drm/i915/gt/intel_engine_pm.c
index 1f07ac4e0672..dacd62773735 100644
--- a/drivers/gpu/drm/i915/gt/intel_engine_pm.c
+++ b/drivers/gpu/drm/i915/gt/intel_engine_pm.c
@@ -298,6 +298,29 @@ void intel_engine_init__pm(struct intel_engine_cs *engine)
 	intel_engine_init_heartbeat(engine);
 }
 
+/**
+ * intel_engine_reset_pinned_contexts - Reset the pinned contexts of
+ * an engine.
+ * @engine: The engine whose pinned contexts we want to reset.
+ *
+ * Typically the pinned context LMEM images lose or get their content
+ * corrupted on suspend. This function resets their images.
+ */
+void intel_engine_reset_pinned_contexts(struct intel_engine_cs *engine)
+{
+	struct intel_context *ce;
+
+	list_for_each_entry(ce, &engine->pinned_contexts_list,
+			    pinned_contexts_link) {
+		/* kernel context gets reset at __engine_unpark() */
+		if (ce == engine->kernel_context)
+			continue;
+
+		dbg_poison_ce(ce);
+		ce->ops->reset(ce);
+	}
+}
+
 #if IS_ENABLED(CONFIG_DRM_I915_SELFTEST)
 #include "selftest_engine_pm.c"
 #endif
diff --git a/drivers/gpu/drm/i915/gt/intel_engine_pm.h b/drivers/gpu/drm/i915/gt/intel_engine_pm.h
index 70ea46d6cfb0..8520c595f5e1 100644
--- a/drivers/gpu/drm/i915/gt/intel_engine_pm.h
+++ b/drivers/gpu/drm/i915/gt/intel_engine_pm.h
@@ -69,4 +69,6 @@ intel_engine_create_kernel_request(struct intel_engine_cs *engine)
 
 void intel_engine_init__pm(struct intel_engine_cs *engine);
 
+void intel_engine_reset_pinned_contexts(struct intel_engine_cs *engine);
+
 #endif /* INTEL_ENGINE_PM_H */
diff --git a/drivers/gpu/drm/i915/gt/intel_engine_types.h b/drivers/gpu/drm/i915/gt/intel_engine_types.h
index ed91bcff20eb..adc44c9fac6d 100644
--- a/drivers/gpu/drm/i915/gt/intel_engine_types.h
+++ b/drivers/gpu/drm/i915/gt/intel_engine_types.h
@@ -304,6 +304,13 @@ struct intel_engine_cs {
 
 	struct intel_context *kernel_context; /* pinned */
 
+	/**
+	 * pinned_contexts_list: List of pinned contexts. This list is only
+	 * assumed to be manipulated during driver load- or unload time and
+	 * does therefore not have any additional protection.
+	 */
+	struct list_head pinned_contexts_list;
+
 	intel_engine_mask_t saturated; /* submitting semaphores too late? */
 
 	struct {
diff --git a/drivers/gpu/drm/i915/gt/intel_execlists_submission.c b/drivers/gpu/drm/i915/gt/intel_execlists_submission.c
index cafb0608ffb4..416f5e0657f0 100644
--- a/drivers/gpu/drm/i915/gt/intel_execlists_submission.c
+++ b/drivers/gpu/drm/i915/gt/intel_execlists_submission.c
@@ -2787,6 +2787,8 @@ static void execlists_sanitize(struct intel_engine_cs *engine)
 
 	/* And scrub the dirty cachelines for the HWSP */
 	clflush_cache_range(engine->status_page.addr, PAGE_SIZE);
+
+	intel_engine_reset_pinned_contexts(engine);
 }
 
 static void enable_error_interrupt(struct intel_engine_cs *engine)
diff --git a/drivers/gpu/drm/i915/gt/intel_ring_submission.c b/drivers/gpu/drm/i915/gt/intel_ring_submission.c
index 2958e2fae380..6f2f6ba87397 100644
--- a/drivers/gpu/drm/i915/gt/intel_ring_submission.c
+++ b/drivers/gpu/drm/i915/gt/intel_ring_submission.c
@@ -17,6 +17,7 @@
 #include "intel_ring.h"
 #include "shmem_utils.h"
 #include "intel_engine_heartbeat.h"
+#include "intel_engine_pm.h"
 
 /* Rough estimate of the typical request size, performing a flush,
  * set-context and then emitting the batch.
@@ -292,6 +293,8 @@ static void xcs_sanitize(struct intel_engine_cs *engine)
 
 	/* And scrub the dirty cachelines for the HWSP */
 	clflush_cache_range(engine->status_page.addr, PAGE_SIZE);
+
+	intel_engine_reset_pinned_contexts(engine);
 }
 
 static void reset_prepare(struct intel_engine_cs *engine)
diff --git a/drivers/gpu/drm/i915/gt/mock_engine.c b/drivers/gpu/drm/i915/gt/mock_engine.c
index 2c1af030310c..8b89215afe46 100644
--- a/drivers/gpu/drm/i915/gt/mock_engine.c
+++ b/drivers/gpu/drm/i915/gt/mock_engine.c
@@ -376,6 +376,8 @@ int mock_engine_init(struct intel_engine_cs *engine)
 {
 	struct intel_context *ce;
 
+	INIT_LIST_HEAD(&engine->pinned_contexts_list);
+
 	engine->sched_engine = i915_sched_engine_create(ENGINE_MOCK);
 	if (!engine->sched_engine)
 		return -ENOMEM;
diff --git a/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c b/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c
index 93c9de8f43e8..6e09a1cca37b 100644
--- a/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c
+++ b/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c
@@ -2347,6 +2347,8 @@ static void guc_sanitize(struct intel_engine_cs *engine)
 
 	/* And scrub the dirty cachelines for the HWSP */
 	clflush_cache_range(engine->status_page.addr, PAGE_SIZE);
+
+	intel_engine_reset_pinned_contexts(engine);
 }
 
 static void setup_hwsp(struct intel_engine_cs *engine)
@@ -2422,9 +2424,13 @@ static inline void guc_init_lrc_mapping(struct intel_guc *guc)
 	 * and even it did this code would be run again.
 	 */
 
-	for_each_engine(engine, gt, id)
-		if (engine->kernel_context)
-			guc_kernel_context_pin(guc, engine->kernel_context);
+	for_each_engine(engine, gt, id) {
+		struct intel_context *ce;
+
+		list_for_each_entry(ce, &engine->pinned_contexts_list,
+				    pinned_contexts_link)
+			guc_kernel_context_pin(guc, ce);
+	}
 }
 
 static void guc_release(struct intel_engine_cs *engine)
-- 
2.35.1



