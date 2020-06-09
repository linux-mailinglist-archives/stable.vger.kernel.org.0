Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BD181F4052
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 18:11:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730999AbgFIQLd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 12:11:33 -0400
Received: from mga14.intel.com ([192.55.52.115]:35944 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730652AbgFIQLc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Jun 2020 12:11:32 -0400
IronPort-SDR: 0UIkOTylFp/0G0O274xlKn3hZDi7Sv3f8TruPPfOajfg5K2SLoe5HIwYa6hE+DoiAsUjDzz0xn
 dFPb4EnYY3aw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2020 09:11:31 -0700
IronPort-SDR: GAfnDrRGE1Md0hrKFlhMgXy37uLG3q0BFS2GNnD7wYZPUeuGmxSHY6sCHDwQeF9jntDdbDUuDv
 gNIUscWD5s7w==
X-IronPort-AV: E=Sophos;i="5.73,492,1583222400"; 
   d="scan'208";a="306306737"
Received: from gem-build.fi.intel.com (HELO localhost) ([10.237.72.180])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2020 09:11:30 -0700
From:   Chris Wilson <chris@chris-wilson.co.uk>
To:     gfx-internal-devel@eclists.intel.com
Cc:     Chris Wilson <chris@chris-wilson.co.uk>,
        Mika Kuoppala <mika.kuoppala@linux.intel.com>,
        stable@vger.kernel.org
Subject: [PATCH 059/185] drm/i915/execlists: Avoid reusing the same logical CCID
Date:   Tue,  9 Jun 2020 16:05:24 +0000
Message-Id: <20200609160731.287073-60-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200609160731.287073-1-chris@chris-wilson.co.uk>
References: <20200609160731.287073-1-chris@chris-wilson.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
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
Reviewed-by: Mika Kuoppala <mika.kuoppala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200428184751.11257-1-chris@chris-wilson.co.uk
(cherry picked from commit 2632f174a2e1a5fd40a70404fa8ccfd0b1f79ebd)
---
 drivers/gpu/drm/i915/gt/intel_context_types.h |  8 ++-
 drivers/gpu/drm/i915/gt/intel_engine_cs.c     |  6 +-
 drivers/gpu/drm/i915/gt/intel_engine_types.h  |  5 ++
 drivers/gpu/drm/i915/gt/intel_lrc.c           | 57 ++++++++-----------
 .../gpu/drm/i915/gt/uc/intel_guc_submission.c |  2 +-
 drivers/gpu/drm/i915/gvt/scheduler.c          |  4 +-
 drivers/gpu/drm/i915/i915_perf.c              |  3 +-
 7 files changed, 44 insertions(+), 41 deletions(-)

diff --git a/drivers/gpu/drm/i915/gt/intel_context_types.h b/drivers/gpu/drm/i915/gt/intel_context_types.h
index e887a2ff28c50..45d257be44308 100644
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
index 1a2887fac48d6..a1bd3e3302774 100644
--- a/drivers/gpu/drm/i915/gt/intel_engine_cs.c
+++ b/drivers/gpu/drm/i915/gt/intel_engine_cs.c
@@ -1411,9 +1411,9 @@ static void intel_engine_print_registers(struct intel_engine_cs *engine,
 			int len;
 
 			len = scnprintf(hdr, sizeof(hdr),
-					"\t\tActive[%d]: ccid:%08x, ",
+					"\t\tActive[%d]:  ccid:%08x, ",
 					(int)(port - execlists->active),
-					upper_32_bits(rq->context->lrc_desc));
+					rq->context->lrc.ccid);
 			len += print_ring(hdr + len, sizeof(hdr) - len, rq);
 			scnprintf(hdr + len, sizeof(hdr) - len, "rq: ");
 			print_request(m, rq, hdr);
@@ -1425,7 +1425,7 @@ static void intel_engine_print_registers(struct intel_engine_cs *engine,
 			len = scnprintf(hdr, sizeof(hdr),
 					"\t\tPending[%d]: ccid:%08x, ",
 					(int)(port - execlists->pending),
-					upper_32_bits(rq->context->lrc_desc));
+					rq->context->lrc.ccid);
 			len += print_ring(hdr + len, sizeof(hdr) - len, rq);
 			scnprintf(hdr + len, sizeof(hdr) - len, "rq: ");
 			print_request(m, rq, hdr);
diff --git a/drivers/gpu/drm/i915/gt/intel_engine_types.h b/drivers/gpu/drm/i915/gt/intel_engine_types.h
index 26ba9f6ab0c7a..e0de4af9a3481 100644
--- a/drivers/gpu/drm/i915/gt/intel_engine_types.h
+++ b/drivers/gpu/drm/i915/gt/intel_engine_types.h
@@ -155,6 +155,11 @@ struct intel_engine_execlists {
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
index 59569bc5b6a48..dfcc44171df1c 100644
--- a/drivers/gpu/drm/i915/gt/intel_lrc.c
+++ b/drivers/gpu/drm/i915/gt/intel_lrc.c
@@ -560,10 +560,10 @@ assert_priority_queue(const struct i915_request *prev,
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
@@ -574,21 +574,7 @@ lrc_descriptor(struct intel_context *ce, struct intel_engine_cs *engine)
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
@@ -1285,7 +1271,7 @@ static void reset_active(struct i915_request *rq,
 	__execlists_update_reg_state(ce, engine, head);
 
 	/* We've switched away, so this should be a no-op, but intent matters */
-	ce->lrc_desc |= CTX_DESC_FORCE_RESTORE;
+	ce->lrc.desc |= CTX_DESC_FORCE_RESTORE;
 }
 
 static void st_update_runtime_underflow(struct intel_context *ce, s32 dt)
@@ -1333,18 +1319,19 @@ __execlists_schedule_in(struct i915_request *rq)
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
@@ -1443,7 +1430,7 @@ execlists_schedule_out(struct i915_request *rq)
 static u64 execlists_update_context(struct i915_request *rq)
 {
 	struct intel_context *ce = rq->context;
-	u64 desc = ce->lrc_desc;
+	u64 desc = ce->lrc.desc;
 	u32 tail, prev;
 
 	/*
@@ -1482,7 +1469,7 @@ static u64 execlists_update_context(struct i915_request *rq)
 	 */
 	wmb();
 
-	ce->lrc_desc &= ~CTX_DESC_FORCE_RESTORE;
+	ce->lrc.desc &= ~CTX_DESC_FORCE_RESTORE;
 	return desc;
 }
 
@@ -1503,8 +1490,9 @@ dump_port(char *buf, int buflen, const char *prefix, struct i915_request *rq)
 	if (!rq)
 		return "";
 
-	snprintf(buf, buflen, "%s%llx:%lld%s prio %d",
+	snprintf(buf, buflen, "%sccid:%x %llx:%lld%s prio %d",
 		 prefix,
+		 rq->context->lrc.ccid,
 		 rq->fence.context, rq->fence.seqno,
 		 i915_request_completed(rq) ? "!" :
 		 i915_request_started(rq) ? "*" :
@@ -1880,7 +1868,7 @@ timeslice_yield(const struct intel_engine_execlists *el,
 	 * safe, yield if it might be stuck -- it will be given a fresh
 	 * timeslice in the near future.
 	 */
-	return upper_32_bits(rq->context->lrc_desc) == READ_ONCE(el->yield);
+	return rq->context->lrc.ccid == READ_ONCE(el->yield);
 }
 
 static bool
@@ -2907,7 +2895,7 @@ active_context(struct intel_engine_cs *engine, u32 ccid)
 	 */
 
 	for (port = el->active; (rq = *port); port++) {
-		if (upper_32_bits(rq->context->lrc_desc) == ccid) {
+		if (rq->context->lrc.ccid == ccid) {
 			ENGINE_TRACE(engine,
 				     "ccid found at active:%zd\n",
 				     port - el->active);
@@ -2916,7 +2904,7 @@ active_context(struct intel_engine_cs *engine, u32 ccid)
 	}
 
 	for (port = el->pending; (rq = *port); port++) {
-		if (upper_32_bits(rq->context->lrc_desc) == ccid) {
+		if (rq->context->lrc.ccid == ccid) {
 			ENGINE_TRACE(engine,
 				     "ccid found at pending:%zd\n",
 				     port - el->pending);
@@ -3337,7 +3325,7 @@ __execlists_context_pin(struct intel_context *ce,
 	if (IS_ERR(vaddr))
 		return PTR_ERR(vaddr);
 
-	ce->lrc_desc = lrc_descriptor(ce, engine) | CTX_DESC_FORCE_RESTORE;
+	ce->lrc.lrca = lrc_descriptor(ce, engine) | CTX_DESC_FORCE_RESTORE;
 	ce->lrc_reg_state = vaddr + LRC_STATE_OFFSET;
 	__execlists_update_reg_state(ce, engine, ce->ring->tail);
 
@@ -3366,7 +3354,7 @@ static void execlists_context_reset(struct intel_context *ce)
 				 ce, ce->engine, ce->ring, true);
 	__execlists_update_reg_state(ce, ce->engine, ce->ring->tail);
 
-	ce->lrc_desc |= CTX_DESC_FORCE_RESTORE;
+	ce->lrc.desc |= CTX_DESC_FORCE_RESTORE;
 }
 
 static const struct intel_context_ops execlists_context_ops = {
@@ -4077,7 +4065,7 @@ static void __execlists_reset(struct intel_engine_cs *engine, bool stalled)
 		     head, ce->ring->tail);
 	__execlists_reset_reg_state(ce, engine);
 	__execlists_update_reg_state(ce, engine, head);
-	ce->lrc_desc |= CTX_DESC_FORCE_RESTORE; /* paranoid: GPU was reset! */
+	ce->lrc.desc |= CTX_DESC_FORCE_RESTORE; /* paranoid: GPU was reset! */
 
 unwind:
 	/* Push back any incomplete requests for replay after the reset. */
@@ -4880,6 +4868,11 @@ int intel_execlists_submission_setup(struct intel_engine_cs *engine)
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
index fe7778c28d2d7..aa6d56e25a10a 100644
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
index 68932b33c0577..9be89b8d952c1 100644
--- a/drivers/gpu/drm/i915/gvt/scheduler.c
+++ b/drivers/gpu/drm/i915/gvt/scheduler.c
@@ -286,7 +286,7 @@ static void
 shadow_context_descriptor_update(struct intel_context *ce,
 				 struct intel_vgpu_workload *workload)
 {
-	u64 desc = ce->lrc_desc;
+	u64 desc = ce->lrc.desc;
 
 	/*
 	 * Update bits 0-11 of the context descriptor which includes flags
@@ -296,7 +296,7 @@ shadow_context_descriptor_update(struct intel_context *ce,
 	desc |= workload->ctx_desc.addressing_mode <<
 		GEN8_CTX_ADDRESSING_MODE_SHIFT;
 
-	ce->lrc_desc = desc;
+	ce->lrc.desc = desc;
 }
 
 static int copy_workload_to_ring_buffer(struct intel_vgpu_workload *workload)
diff --git a/drivers/gpu/drm/i915/i915_perf.c b/drivers/gpu/drm/i915/i915_perf.c
index a5bddcc5bb334..6e3d378ebbbd6 100644
--- a/drivers/gpu/drm/i915/i915_perf.c
+++ b/drivers/gpu/drm/i915/i915_perf.c
@@ -1309,8 +1309,7 @@ static int oa_get_render_ctx_id(struct i915_perf_stream *stream)
 			 * dropped by GuC. They won't be part of the context
 			 * ID in the OA reports, so squash those lower bits.
 			 */
-			stream->specific_ctx_id =
-				lower_32_bits(ce->lrc_desc) >> 12;
+			stream->specific_ctx_id = ce->lrc.lrca >> 12;
 
 			/*
 			 * GuC uses the top bit to signal proxy submission, so
---------------------------------------------------------------------
Intel Corporation (UK) Limited
Registered No. 1134945 (England)
Registered Office: Pipers Way, Swindon SN3 1RJ
VAT No: 860 2173 47

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

