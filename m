Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F351B1BB980
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 11:08:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726958AbgD1JIT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 05:08:19 -0400
Received: from mail.fireflyinternet.com ([109.228.58.192]:55345 "EHLO
        fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726957AbgD1JIT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Apr 2020 05:08:19 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from build.alporthouse.com (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP id 21043033-1500050 
        for multiple; Tue, 28 Apr 2020 10:08:17 +0100
From:   Chris Wilson <chris@chris-wilson.co.uk>
To:     intel-gfx@lists.freedesktop.org
Cc:     Chris Wilson <chris@chris-wilson.co.uk>,
        Mika Kuoppala <mika.kuoppala@linux.intel.com>,
        stable@vger.kernel.org
Subject: [PATCH 2/3] drm/i915/execlists: Track inflight CCID
Date:   Tue, 28 Apr 2020 10:08:13 +0100
Message-Id: <20200428090814.19352-2-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200428090814.19352-1-chris@chris-wilson.co.uk>
References: <20200428090814.19352-1-chris@chris-wilson.co.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The presumption is that by using a circular counter that is twice as
large as the maximum ELSP submission, we would never reuse the same CCID
for two inflight contexts.

However, if we continually preempt an active context such that it always
remains inflight, it can be resubmitted with an arbitrary number of
paired contexts. As each of its paired contexts will use a new CCID,
eventually it will wrap and submit two ELSP with the same CCID.

Rather than use a simple circular counter, switch over to a small bitmap
of inflight ids so we can avoid reusing one that is still potentially
active.

Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/1796
Fixes: 2935ed5339c4 ("drm/i915: Remove logical HW ID")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Mika Kuoppala <mika.kuoppala@linux.intel.com>
Cc: <stable@vger.kernel.org> # v5.5+
---
 drivers/gpu/drm/i915/gt/intel_engine_types.h |  3 +--
 drivers/gpu/drm/i915/gt/intel_lrc.c          | 26 ++++++++++++++------
 drivers/gpu/drm/i915/i915_perf.c             |  3 +--
 drivers/gpu/drm/i915/selftests/i915_vma.c    |  2 +-
 4 files changed, 22 insertions(+), 12 deletions(-)

diff --git a/drivers/gpu/drm/i915/gt/intel_engine_types.h b/drivers/gpu/drm/i915/gt/intel_engine_types.h
index 470bdc73220a..cfe4feaee982 100644
--- a/drivers/gpu/drm/i915/gt/intel_engine_types.h
+++ b/drivers/gpu/drm/i915/gt/intel_engine_types.h
@@ -309,8 +309,7 @@ struct intel_engine_cs {
 	u32 context_size;
 	u32 mmio_base;
 
-	unsigned int context_tag;
-#define NUM_CONTEXT_TAG roundup_pow_of_two(2 * EXECLIST_MAX_PORTS)
+	unsigned long context_tag;
 
 	struct rb_node uabi_node;
 
diff --git a/drivers/gpu/drm/i915/gt/intel_lrc.c b/drivers/gpu/drm/i915/gt/intel_lrc.c
index 7d56207276d5..24daacb52411 100644
--- a/drivers/gpu/drm/i915/gt/intel_lrc.c
+++ b/drivers/gpu/drm/i915/gt/intel_lrc.c
@@ -1389,13 +1389,17 @@ __execlists_schedule_in(struct i915_request *rq)
 
 	if (ce->tag) {
 		/* Use a fixed tag for OA and friends */
+		GEM_BUG_ON(ce->tag <= BITS_PER_TYPE(engine->context_tag));
 		ce->lrc.ccid = ce->tag;
 	} else {
 		/* We don't need a strict matching tag, just different values */
-		ce->lrc.ccid =
-			(++engine->context_tag % NUM_CONTEXT_TAG) <<
-			(GEN11_SW_CTX_ID_SHIFT - 32);
-		BUILD_BUG_ON(NUM_CONTEXT_TAG > GEN12_MAX_CONTEXT_HW_ID);
+		unsigned int tag = ffs(engine->context_tag);
+
+		GEM_BUG_ON(tag == 0 || tag >= BITS_PER_LONG);
+		clear_bit(tag - 1, &engine->context_tag);
+		ce->lrc.ccid = tag << (GEN11_SW_CTX_ID_SHIFT - 32);
+
+		BUILD_BUG_ON(BITS_PER_TYPE(engine->context_tag) > GEN12_MAX_CONTEXT_HW_ID);
 	}
 
 	ce->lrc.ccid |= engine->execlists.ccid;
@@ -1439,7 +1443,8 @@ static void kick_siblings(struct i915_request *rq, struct intel_context *ce)
 
 static inline void
 __execlists_schedule_out(struct i915_request *rq,
-			 struct intel_engine_cs * const engine)
+			 struct intel_engine_cs * const engine,
+			 unsigned int ccid)
 {
 	struct intel_context * const ce = rq->context;
 
@@ -1457,6 +1462,11 @@ __execlists_schedule_out(struct i915_request *rq,
 	    i915_request_completed(rq))
 		intel_engine_add_retire(engine, ce->timeline);
 
+	ccid >>= GEN11_SW_CTX_ID_SHIFT - 32;
+	ccid &= GEN12_MAX_CONTEXT_HW_ID;
+	if (ccid < BITS_PER_TYPE(engine->context_tag))
+		set_bit(ccid - 1, &engine->context_tag);
+
 	intel_context_update_runtime(ce);
 	intel_engine_context_out(engine);
 	execlists_context_status_change(rq, INTEL_CONTEXT_SCHEDULE_OUT);
@@ -1482,15 +1492,17 @@ execlists_schedule_out(struct i915_request *rq)
 {
 	struct intel_context * const ce = rq->context;
 	struct intel_engine_cs *cur, *old;
+	u32 ccid;
 
 	trace_i915_request_out(rq);
 
+	ccid = rq->context->lrc.ccid;
 	old = READ_ONCE(ce->inflight);
 	do
 		cur = ptr_unmask_bits(old, 2) ? ptr_dec(old) : NULL;
 	while (!try_cmpxchg(&ce->inflight, &old, cur));
 	if (!cur)
-		__execlists_schedule_out(rq, old);
+		__execlists_schedule_out(rq, old, ccid);
 
 	i915_request_put(rq);
 }
@@ -3990,7 +4002,7 @@ static void enable_execlists(struct intel_engine_cs *engine)
 
 	enable_error_interrupt(engine);
 
-	engine->context_tag = 0;
+	engine->context_tag = GENMASK(BITS_PER_LONG - 2, 0);
 }
 
 static bool unexpected_starting_state(struct intel_engine_cs *engine)
diff --git a/drivers/gpu/drm/i915/i915_perf.c b/drivers/gpu/drm/i915/i915_perf.c
index 04ad21960688..c533f569dd42 100644
--- a/drivers/gpu/drm/i915/i915_perf.c
+++ b/drivers/gpu/drm/i915/i915_perf.c
@@ -1280,11 +1280,10 @@ static int oa_get_render_ctx_id(struct i915_perf_stream *stream)
 			((1U << GEN11_SW_CTX_ID_WIDTH) - 1) << (GEN11_SW_CTX_ID_SHIFT - 32);
 		/*
 		 * Pick an unused context id
-		 * 0 - (NUM_CONTEXT_TAG - 1) are used by other contexts
+		 * 0 - BITS_PER_LONG are used by other contexts
 		 * GEN12_MAX_CONTEXT_HW_ID (0x7ff) is used by idle context
 		 */
 		stream->specific_ctx_id = (GEN12_MAX_CONTEXT_HW_ID - 1) << (GEN11_SW_CTX_ID_SHIFT - 32);
-		BUILD_BUG_ON((GEN12_MAX_CONTEXT_HW_ID - 1) < NUM_CONTEXT_TAG);
 		break;
 	}
 
diff --git a/drivers/gpu/drm/i915/selftests/i915_vma.c b/drivers/gpu/drm/i915/selftests/i915_vma.c
index 58b5f40a07dd..af89c7fc8f59 100644
--- a/drivers/gpu/drm/i915/selftests/i915_vma.c
+++ b/drivers/gpu/drm/i915/selftests/i915_vma.c
@@ -173,7 +173,7 @@ static int igt_vma_create(void *arg)
 		}
 
 		nc = 0;
-		for_each_prime_number(num_ctx, 2 * NUM_CONTEXT_TAG) {
+		for_each_prime_number(num_ctx, 2 * BITS_PER_LONG) {
 			for (; nc < num_ctx; nc++) {
 				ctx = mock_context(i915, "mock");
 				if (!ctx)
-- 
2.20.1

