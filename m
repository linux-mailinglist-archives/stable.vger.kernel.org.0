Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6ED61BAB7D
	for <lists+stable@lfdr.de>; Mon, 27 Apr 2020 19:41:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726228AbgD0Rla (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Apr 2020 13:41:30 -0400
Received: from mail.fireflyinternet.com ([109.228.58.192]:49478 "EHLO
        fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726226AbgD0Rla (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Apr 2020 13:41:30 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from build.alporthouse.com (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP id 21038359-1500050 
        for multiple; Mon, 27 Apr 2020 18:41:23 +0100
From:   Chris Wilson <chris@chris-wilson.co.uk>
To:     intel-gfx@lists.freedesktop.org
Cc:     Chris Wilson <chris@chris-wilson.co.uk>,
        Mika Kuoppala <mika.kuoppala@linux.intel.com>,
        stable@vger.kernel.org
Subject: [PATCH] drm/i915/execlists: Avoid reusing the same logical CC_ID
Date:   Mon, 27 Apr 2020 18:41:22 +0100
Message-Id: <20200427174122.13415-1-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200427170513.24019-1-chris@chris-wilson.co.uk>
References: <20200427170513.24019-1-chris@chris-wilson.co.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Fixes: 2935ed5339c4 ("drm/i915: Remove logical HW ID")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Mika Kuoppala <mika.kuoppala@linux.intel.com>
Cc: <stable@vger.kernel.org> # v5.5+
---
 drivers/gpu/drm/i915/gt/intel_engine_types.h |  3 +--
 drivers/gpu/drm/i915/gt/intel_lrc.c          | 25 ++++++++++++++------
 drivers/gpu/drm/i915/i915_perf.c             |  3 +--
 drivers/gpu/drm/i915/selftests/i915_vma.c    |  2 +-
 4 files changed, 21 insertions(+), 12 deletions(-)

diff --git a/drivers/gpu/drm/i915/gt/intel_engine_types.h b/drivers/gpu/drm/i915/gt/intel_engine_types.h
index bf395227c99f..a9fc3fbbe482 100644
--- a/drivers/gpu/drm/i915/gt/intel_engine_types.h
+++ b/drivers/gpu/drm/i915/gt/intel_engine_types.h
@@ -304,8 +304,7 @@ struct intel_engine_cs {
 	u32 context_size;
 	u32 mmio_base;
 
-	unsigned int context_tag;
-#define NUM_CONTEXT_TAG roundup_pow_of_two(2 * EXECLIST_MAX_PORTS)
+	unsigned long context_tag;
 
 	struct rb_node uabi_node;
 
diff --git a/drivers/gpu/drm/i915/gt/intel_lrc.c b/drivers/gpu/drm/i915/gt/intel_lrc.c
index 93a1b73ad96b..3a9d3ebf3e5b 100644
--- a/drivers/gpu/drm/i915/gt/intel_lrc.c
+++ b/drivers/gpu/drm/i915/gt/intel_lrc.c
@@ -1404,13 +1404,17 @@ __execlists_schedule_in(struct i915_request *rq)
 	ce->lrc_desc &= ~GENMASK_ULL(47, 37);
 	if (ce->tag) {
 		/* Use a fixed tag for OA and friends */
+		GEM_BUG_ON(ce->tag <= BITS_PER_TYPE(engine->context_tag));
 		ce->lrc_desc |= (u64)ce->tag << 32;
 	} else {
 		/* We don't need a strict matching tag, just different values */
-		ce->lrc_desc |=
-			(u64)(++engine->context_tag % NUM_CONTEXT_TAG) <<
-			GEN11_SW_CTX_ID_SHIFT;
-		BUILD_BUG_ON(NUM_CONTEXT_TAG > GEN12_MAX_CONTEXT_HW_ID);
+		unsigned int tag = ffs(engine->context_tag);
+
+		GEM_BUG_ON(tag >= BITS_PER_LONG);
+		clear_bit(tag - 1, &engine->context_tag);
+		ce->lrc_desc |= (u64)tag << GEN11_SW_CTX_ID_SHIFT;
+
+		BUILD_BUG_ON(BITS_PER_TYPE(engine->context_tag) > GEN12_MAX_CONTEXT_HW_ID);
 	}
 
 	__intel_gt_pm_get(engine->gt);
@@ -1452,7 +1456,8 @@ static void kick_siblings(struct i915_request *rq, struct intel_context *ce)
 
 static inline void
 __execlists_schedule_out(struct i915_request *rq,
-			 struct intel_engine_cs * const engine)
+			 struct intel_engine_cs * const engine,
+			 unsigned int ccid)
 {
 	struct intel_context * const ce = rq->context;
 
@@ -1470,6 +1475,10 @@ __execlists_schedule_out(struct i915_request *rq,
 	    i915_request_completed(rq))
 		intel_engine_add_retire(engine, ce->timeline);
 
+	ccid >>= (GEN11_SW_CTX_ID_SHIFT - 32);
+	if (ccid < BITS_PER_TYPE(engine->context_tag))
+		set_bit(ccid - 1, &engine->context_tag);
+
 	intel_context_update_runtime(ce);
 	intel_engine_context_out(engine);
 	execlists_context_status_change(rq, INTEL_CONTEXT_SCHEDULE_OUT);
@@ -1495,15 +1504,17 @@ execlists_schedule_out(struct i915_request *rq)
 {
 	struct intel_context * const ce = rq->context;
 	struct intel_engine_cs *cur, *old;
+	unsigned int ccid;
 
 	trace_i915_request_out(rq);
 
+	ccid = upper_32_bits(rq->context->lrc_desc);
 	old = READ_ONCE(ce->inflight);
 	do
 		cur = ptr_unmask_bits(old, 2) ? ptr_dec(old) : NULL;
 	while (!try_cmpxchg(&ce->inflight, &old, cur));
 	if (!cur)
-		__execlists_schedule_out(rq, old);
+		__execlists_schedule_out(rq, old, ccid);
 
 	i915_request_put(rq);
 }
@@ -4002,7 +4013,7 @@ static void enable_execlists(struct intel_engine_cs *engine)
 
 	enable_error_interrupt(engine);
 
-	engine->context_tag = 0;
+	engine->context_tag = GENMASK(BITS_PER_LONG - 2, 0);
 }
 
 static bool unexpected_starting_state(struct intel_engine_cs *engine)
diff --git a/drivers/gpu/drm/i915/i915_perf.c b/drivers/gpu/drm/i915/i915_perf.c
index dec1b33e4da8..1863a5c4778d 100644
--- a/drivers/gpu/drm/i915/i915_perf.c
+++ b/drivers/gpu/drm/i915/i915_perf.c
@@ -1281,11 +1281,10 @@ static int oa_get_render_ctx_id(struct i915_perf_stream *stream)
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

