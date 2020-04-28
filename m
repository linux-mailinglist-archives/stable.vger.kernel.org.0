Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE75A1BB939
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 10:53:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726402AbgD1Ixn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 04:53:43 -0400
Received: from mail.fireflyinternet.com ([109.228.58.192]:54764 "EHLO
        fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726346AbgD1Ixm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Apr 2020 04:53:42 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from build.alporthouse.com (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP id 21042592-1500050 
        for multiple; Tue, 28 Apr 2020 09:53:38 +0100
From:   Chris Wilson <chris@chris-wilson.co.uk>
To:     intel-gfx@lists.freedesktop.org
Cc:     Chris Wilson <chris@chris-wilson.co.uk>,
        Mika Kuoppala <mika.kuoppala@linux.intel.com>,
        stable@vger.kernel.org
Subject: [PATCH 1/2] drm/i915/execlists: Avoid reusing the same logical CCID
Date:   Tue, 28 Apr 2020 09:53:35 +0100
Message-Id: <20200428085336.9580-1-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The bspec is confusing on the nature of the upper 32bits of the LRC
descriptor. Once upon a time, it said that it uses the upper 32b to
decide if it should perform a lite-restore, and so we must ensure that
each unique context submitted to HW is given a unique CCID [for the
duration of it being on the HW]. Currently, this is achieved by using
a small circular tag, and assigning every context submitted to HW a
new id. However, this tag is being cleared on repinning an inflight
context such that we end up re-using the 0 tag for multiple contexts.

To avoid accidentally clearing the CCID in the upper 32bits of the LRC
descriptor, split the descriptor into two dwords so we can update the
GGTT address separately from the CCID.

Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/1796
Fixes: 2935ed5339c4 ("drm/i915: Remove logical HW ID")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Mika Kuoppala <mika.kuoppala@linux.intel.com>
Cc: <stable@vger.kernel.org> # v5.5+
---
 drivers/gpu/drm/i915/gt/intel_context_types.h |  8 ++-
 drivers/gpu/drm/i915/gt/intel_engine_cs.c     |  4 +-
 drivers/gpu/drm/i915/gt/intel_engine_types.h  |  5 ++
 drivers/gpu/drm/i915/gt/intel_lrc.c           | 57 ++++++++-----------
 .../gpu/drm/i915/gt/uc/intel_guc_submission.c |  2 +-
 drivers/gpu/drm/i915/gvt/scheduler.c          |  4 +-
 drivers/gpu/drm/i915/i915_perf.c              |  3 +-
 7 files changed, 43 insertions(+), 40 deletions(-)

diff --git a/drivers/gpu/drm/i915/gt/intel_context_types.h b/drivers/gpu/drm/i915/gt/intel_context_types.h
index e0da7bdcbf01..4954b0df4864 100644
--- a/drivers/gpu/drm/i915/gt/intel_context_types.h
+++ b/drivers/gpu/drm/i915/gt/intel_context_types.h
@@ -69,7 +69,13 @@ struct intel_context {
 #define CONTEXT_NOPREEMPT		7
 
 	u32 *lrc_reg_state;
-	u64 lrc_desc;
+	union {
+		struct {
+			u32 lrca;
+			u32 ccid;
+		};
+		u64 desc;
+	} lrc;
 	u32 tag; /* cookie passed to HW to track this context on submission */
 
 	/* Time on GPU as tracked by the hw. */
diff --git a/drivers/gpu/drm/i915/gt/intel_engine_cs.c b/drivers/gpu/drm/i915/gt/intel_engine_cs.c
index b1f8527f02c8..7c3cb5aedfdf 100644
--- a/drivers/gpu/drm/i915/gt/intel_engine_cs.c
+++ b/drivers/gpu/drm/i915/gt/intel_engine_cs.c
@@ -1425,7 +1425,7 @@ static void intel_engine_print_registers(struct intel_engine_cs *engine,
 			len = scnprintf(hdr, sizeof(hdr),
 					"\t\tActive[%d]:  ccid:%08x, ",
 					(int)(port - execlists->active),
-					upper_32_bits(rq->context->lrc_desc));
+					rq->context->lrc.ccid);
 			len += print_ring(hdr + len, sizeof(hdr) - len, rq);
 			scnprintf(hdr + len, sizeof(hdr) - len, "rq: ");
 			print_request(m, rq, hdr);
@@ -1437,7 +1437,7 @@ static void intel_engine_print_registers(struct intel_engine_cs *engine,
 			len = scnprintf(hdr, sizeof(hdr),
 					"\t\tPending[%d]: ccid:%08x, ",
 					(int)(port - execlists->pending),
-					upper_32_bits(rq->context->lrc_desc));
+					rq->context->lrc.ccid);
 			len += print_ring(hdr + len, sizeof(hdr) - len, rq);
 			scnprintf(hdr + len, sizeof(hdr) - len, "rq: ");
 			print_request(m, rq, hdr);
diff --git a/drivers/gpu/drm/i915/gt/intel_engine_types.h b/drivers/gpu/drm/i915/gt/intel_engine_types.h
index bf395227c99f..470bdc73220a 100644
--- a/drivers/gpu/drm/i915/gt/intel_engine_types.h
+++ b/drivers/gpu/drm/i915/gt/intel_engine_types.h
@@ -156,6 +156,11 @@ struct intel_engine_execlists {
 	 */
 	struct i915_priolist default_priolist;
 
+	/**
+	 * @ccid: identifier for contexts submitted to this engine
+	 */
+	u32 ccid;
+
 	/**
 	 * @yield: CCID at the time of the last semaphore-wait interrupt.
 	 *
diff --git a/drivers/gpu/drm/i915/gt/intel_lrc.c b/drivers/gpu/drm/i915/gt/intel_lrc.c
index 93a1b73ad96b..7d56207276d5 100644
--- a/drivers/gpu/drm/i915/gt/intel_lrc.c
+++ b/drivers/gpu/drm/i915/gt/intel_lrc.c
@@ -573,10 +573,10 @@ assert_priority_queue(const struct i915_request *prev,
  * engine info, SW context ID and SW counter need to form a unique number
  * (Context ID) per lrc.
  */
-static u64
+static u32
 lrc_descriptor(struct intel_context *ce, struct intel_engine_cs *engine)
 {
-	u64 desc;
+	u32 desc;
 
 	desc = INTEL_LEGACY_32B_CONTEXT;
 	if (i915_vm_is_4lvl(ce->vm))
@@ -587,21 +587,7 @@ lrc_descriptor(struct intel_context *ce, struct intel_engine_cs *engine)
 	if (IS_GEN(engine->i915, 8))
 		desc |= GEN8_CTX_L3LLC_COHERENT;
 
-	desc |= i915_ggtt_offset(ce->state); /* bits 12-31 */
-	/*
-	 * The following 32bits are copied into the OA reports (dword 2).
-	 * Consider updating oa_get_render_ctx_id in i915_perf.c when changing
-	 * anything below.
-	 */
-	if (INTEL_GEN(engine->i915) >= 11) {
-		desc |= (u64)engine->instance << GEN11_ENGINE_INSTANCE_SHIFT;
-								/* bits 48-53 */
-
-		desc |= (u64)engine->class << GEN11_ENGINE_CLASS_SHIFT;
-								/* bits 61-63 */
-	}
-
-	return desc;
+	return i915_ggtt_offset(ce->state) | desc;
 }
 
 static inline unsigned int dword_in_page(void *addr)
@@ -1353,7 +1339,7 @@ static void reset_active(struct i915_request *rq,
 	__execlists_update_reg_state(ce, engine, head);
 
 	/* We've switched away, so this should be a no-op, but intent matters */
-	ce->lrc_desc |= CTX_DESC_FORCE_RESTORE;
+	ce->lrc.desc |= CTX_DESC_FORCE_RESTORE;
 }
 
 static void st_update_runtime_underflow(struct intel_context *ce, s32 dt)
@@ -1401,18 +1387,19 @@ __execlists_schedule_in(struct i915_request *rq)
 	if (IS_ENABLED(CONFIG_DRM_I915_DEBUG_GEM))
 		execlists_check_context(ce, engine);
 
-	ce->lrc_desc &= ~GENMASK_ULL(47, 37);
 	if (ce->tag) {
 		/* Use a fixed tag for OA and friends */
-		ce->lrc_desc |= (u64)ce->tag << 32;
+		ce->lrc.ccid = ce->tag;
 	} else {
 		/* We don't need a strict matching tag, just different values */
-		ce->lrc_desc |=
-			(u64)(++engine->context_tag % NUM_CONTEXT_TAG) <<
-			GEN11_SW_CTX_ID_SHIFT;
+		ce->lrc.ccid =
+			(++engine->context_tag % NUM_CONTEXT_TAG) <<
+			(GEN11_SW_CTX_ID_SHIFT - 32);
 		BUILD_BUG_ON(NUM_CONTEXT_TAG > GEN12_MAX_CONTEXT_HW_ID);
 	}
 
+	ce->lrc.ccid |= engine->execlists.ccid;
+
 	__intel_gt_pm_get(engine->gt);
 	execlists_context_status_change(rq, INTEL_CONTEXT_SCHEDULE_IN);
 	intel_engine_context_in(engine);
@@ -1511,7 +1498,7 @@ execlists_schedule_out(struct i915_request *rq)
 static u64 execlists_update_context(struct i915_request *rq)
 {
 	struct intel_context *ce = rq->context;
-	u64 desc = ce->lrc_desc;
+	u64 desc = ce->lrc.desc;
 	u32 tail, prev;
 
 	/*
@@ -1550,7 +1537,7 @@ static u64 execlists_update_context(struct i915_request *rq)
 	 */
 	wmb();
 
-	ce->lrc_desc &= ~CTX_DESC_FORCE_RESTORE;
+	ce->lrc.desc &= ~CTX_DESC_FORCE_RESTORE;
 	return desc;
 }
 
@@ -1571,8 +1558,9 @@ dump_port(char *buf, int buflen, const char *prefix, struct i915_request *rq)
 	if (!rq)
 		return "";
 
-	snprintf(buf, buflen, "%s%llx:%lld%s prio %d",
+	snprintf(buf, buflen, "%sccid:%x %llx:%lld%s prio %d",
 		 prefix,
+		 rq->context->lrc.ccid,
 		 rq->fence.context, rq->fence.seqno,
 		 i915_request_completed(rq) ? "!" :
 		 i915_request_started(rq) ? "*" :
@@ -1948,7 +1936,7 @@ timeslice_yield(const struct intel_engine_execlists *el,
 	 * safe, yield if it might be stuck -- it will be given a fresh
 	 * timeslice in the near future.
 	 */
-	return upper_32_bits(rq->context->lrc_desc) == READ_ONCE(el->yield);
+	return rq->context->lrc.ccid == READ_ONCE(el->yield);
 }
 
 static bool
@@ -2975,7 +2963,7 @@ active_context(struct intel_engine_cs *engine, u32 ccid)
 	 */
 
 	for (port = el->active; (rq = *port); port++) {
-		if (upper_32_bits(rq->context->lrc_desc) == ccid) {
+		if (rq->context->lrc.ccid == ccid) {
 			ENGINE_TRACE(engine,
 				     "ccid found at active:%zd\n",
 				     port - el->active);
@@ -2984,7 +2972,7 @@ active_context(struct intel_engine_cs *engine, u32 ccid)
 	}
 
 	for (port = el->pending; (rq = *port); port++) {
-		if (upper_32_bits(rq->context->lrc_desc) == ccid) {
+		if (rq->context->lrc.ccid == ccid) {
 			ENGINE_TRACE(engine,
 				     "ccid found at pending:%zd\n",
 				     port - el->pending);
@@ -3444,7 +3432,7 @@ __execlists_context_pin(struct intel_context *ce,
 	if (IS_ERR(vaddr))
 		return PTR_ERR(vaddr);
 
-	ce->lrc_desc = lrc_descriptor(ce, engine) | CTX_DESC_FORCE_RESTORE;
+	ce->lrc.lrca = lrc_descriptor(ce, engine) | CTX_DESC_FORCE_RESTORE;
 	ce->lrc_reg_state = vaddr + LRC_STATE_OFFSET;
 	__execlists_update_reg_state(ce, engine, ce->ring->tail);
 
@@ -3473,7 +3461,7 @@ static void execlists_context_reset(struct intel_context *ce)
 				 ce, ce->engine, ce->ring, true);
 	__execlists_update_reg_state(ce, ce->engine, ce->ring->tail);
 
-	ce->lrc_desc |= CTX_DESC_FORCE_RESTORE;
+	ce->lrc.desc |= CTX_DESC_FORCE_RESTORE;
 }
 
 static const struct intel_context_ops execlists_context_ops = {
@@ -4184,7 +4172,7 @@ static void __execlists_reset(struct intel_engine_cs *engine, bool stalled)
 		     head, ce->ring->tail);
 	__execlists_reset_reg_state(ce, engine);
 	__execlists_update_reg_state(ce, engine, head);
-	ce->lrc_desc |= CTX_DESC_FORCE_RESTORE; /* paranoid: GPU was reset! */
+	ce->lrc.desc |= CTX_DESC_FORCE_RESTORE; /* paranoid: GPU was reset! */
 
 unwind:
 	/* Push back any incomplete requests for replay after the reset. */
@@ -4950,6 +4938,11 @@ int intel_execlists_submission_setup(struct intel_engine_cs *engine)
 	else
 		execlists->csb_size = GEN11_CSB_ENTRIES;
 
+	if (INTEL_GEN(engine->i915) >= 11) {
+		execlists->ccid |= engine->instance << (GEN11_ENGINE_INSTANCE_SHIFT - 32);
+		execlists->ccid |= engine->class << (GEN11_ENGINE_CLASS_SHIFT - 32);
+	}
+
 	/* Finally, take ownership and responsibility for cleanup! */
 	engine->sanitize = execlists_sanitize;
 	engine->release = execlists_release;
diff --git a/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c b/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c
index fe7778c28d2d..aa6d56e25a10 100644
--- a/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c
+++ b/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c
@@ -217,7 +217,7 @@ static void guc_wq_item_append(struct intel_guc *guc,
 static void guc_add_request(struct intel_guc *guc, struct i915_request *rq)
 {
 	struct intel_engine_cs *engine = rq->engine;
-	u32 ctx_desc = lower_32_bits(rq->context->lrc_desc);
+	u32 ctx_desc = rq->context->lrc.ccid;
 	u32 ring_tail = intel_ring_set_tail(rq->ring, rq->tail) / sizeof(u64);
 
 	guc_wq_item_append(guc, engine->guc_id, ctx_desc,
diff --git a/drivers/gpu/drm/i915/gvt/scheduler.c b/drivers/gpu/drm/i915/gvt/scheduler.c
index 2f5c59111821..38234073e0fc 100644
--- a/drivers/gpu/drm/i915/gvt/scheduler.c
+++ b/drivers/gpu/drm/i915/gvt/scheduler.c
@@ -290,7 +290,7 @@ static void
 shadow_context_descriptor_update(struct intel_context *ce,
 				 struct intel_vgpu_workload *workload)
 {
-	u64 desc = ce->lrc_desc;
+	u64 desc = ce->lrc.desc;
 
 	/*
 	 * Update bits 0-11 of the context descriptor which includes flags
@@ -300,7 +300,7 @@ shadow_context_descriptor_update(struct intel_context *ce,
 	desc |= (u64)workload->ctx_desc.addressing_mode <<
 		GEN8_CTX_ADDRESSING_MODE_SHIFT;
 
-	ce->lrc_desc = desc;
+	ce->lrc.desc = desc;
 }
 
 static int copy_workload_to_ring_buffer(struct intel_vgpu_workload *workload)
diff --git a/drivers/gpu/drm/i915/i915_perf.c b/drivers/gpu/drm/i915/i915_perf.c
index dec1b33e4da8..04ad21960688 100644
--- a/drivers/gpu/drm/i915/i915_perf.c
+++ b/drivers/gpu/drm/i915/i915_perf.c
@@ -1263,8 +1263,7 @@ static int oa_get_render_ctx_id(struct i915_perf_stream *stream)
 			 * dropped by GuC. They won't be part of the context
 			 * ID in the OA reports, so squash those lower bits.
 			 */
-			stream->specific_ctx_id =
-				lower_32_bits(ce->lrc_desc) >> 12;
+			stream->specific_ctx_id = ce->lrc.lrca >> 12;
 
 			/*
 			 * GuC uses the top bit to signal proxy submission, so
-- 
2.20.1

