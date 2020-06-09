Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFEAA1F3F08
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 17:17:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730640AbgFIPR2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 11:17:28 -0400
Received: from mail.fireflyinternet.com ([109.228.58.192]:49869 "EHLO
        fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726395AbgFIPR2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Jun 2020 11:17:28 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from build.alporthouse.com (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP id 21444185-1500050 
        for multiple; Tue, 09 Jun 2020 16:17:23 +0100
From:   Chris Wilson <chris@chris-wilson.co.uk>
To:     intel-gfx@lists.freedesktop.org
Cc:     Chris Wilson <chris@chris-wilson.co.uk>,
        Mika Kuoppala <mika.kuoppala@linux.intel.com>,
        stable@vger.kernel.org
Subject: [PATCH] drm/i915/gt: Incrementally check for rewinding
Date:   Tue,  9 Jun 2020 16:17:23 +0100
Message-Id: <20200609151723.12971-1-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200609122856.10207-1-chris@chris-wilson.co.uk>
References: <20200609122856.10207-1-chris@chris-wilson.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In commit 5ba32c7be81e ("drm/i915/execlists: Always force a context
reload when rewinding RING_TAIL"), we placed the check for rewinding a
context on actually submitting the next request in that context. This
was so that we only had to check once, and could do so with precision
avoiding as many forced restores as possible. For example, to ensure
that we can resubmit the same request a couple of times, we include a
small wa_tail such that on the next submission, the ring->tail will
appear to move forwards when resubmitting the same request. This is very
common as it will happen for every lite-restore to fill the second port
after a context switch.

However, intel_ring_direction() is limited in precision to movements of
upto half the ring size. The consequence being that if we tried to
unwind many requests, we could exceed half the ring and flip the sense
of the direction, so missing a force restore. As no request can be
greater than half the ring (i.e. 2048 bytes in the smallest case), we
can check for rollback incrementally. As we check against the tail that
would be submitted, we do not lose any sensitivity and allow lite
restores for the simple case. We still need to double check upon
submitting the context, to allow for multiple preemptions and
resubmissions.

Fixes: 5ba32c7be81e ("drm/i915/execlists: Always force a context reload when rewinding RING_TAIL")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Mika Kuoppala <mika.kuoppala@linux.intel.com>
Cc: <stable@vger.kernel.org> # v5.4+
---
 drivers/gpu/drm/i915/gt/intel_engine_cs.c     |   4 +-
 drivers/gpu/drm/i915/gt/intel_lrc.c           |  21 +++-
 drivers/gpu/drm/i915/gt/intel_ring.c          |   4 +
 drivers/gpu/drm/i915/gt/selftest_mocs.c       |  18 ++-
 drivers/gpu/drm/i915/gt/selftest_ring.c       | 110 ++++++++++++++++++
 .../drm/i915/selftests/i915_mock_selftests.h  |   1 +
 6 files changed, 154 insertions(+), 4 deletions(-)
 create mode 100644 drivers/gpu/drm/i915/gt/selftest_ring.c

diff --git a/drivers/gpu/drm/i915/gt/intel_engine_cs.c b/drivers/gpu/drm/i915/gt/intel_engine_cs.c
index e5141a897786..0a05301e00fb 100644
--- a/drivers/gpu/drm/i915/gt/intel_engine_cs.c
+++ b/drivers/gpu/drm/i915/gt/intel_engine_cs.c
@@ -646,7 +646,7 @@ static int engine_setup_common(struct intel_engine_cs *engine)
 struct measure_breadcrumb {
 	struct i915_request rq;
 	struct intel_ring ring;
-	u32 cs[1024];
+	u32 cs[2048];
 };
 
 static int measure_breadcrumb_dw(struct intel_context *ce)
@@ -667,6 +667,8 @@ static int measure_breadcrumb_dw(struct intel_context *ce)
 
 	frame->ring.vaddr = frame->cs;
 	frame->ring.size = sizeof(frame->cs);
+	frame->ring.wrap =
+		BITS_PER_TYPE(frame->ring.size) - ilog2(frame->ring.size);
 	frame->ring.effective_size = frame->ring.size;
 	intel_ring_update_space(&frame->ring);
 	frame->rq.ring = &frame->ring;
diff --git a/drivers/gpu/drm/i915/gt/intel_lrc.c b/drivers/gpu/drm/i915/gt/intel_lrc.c
index a057f7a2a521..5f33342c15e2 100644
--- a/drivers/gpu/drm/i915/gt/intel_lrc.c
+++ b/drivers/gpu/drm/i915/gt/intel_lrc.c
@@ -1137,6 +1137,13 @@ __unwind_incomplete_requests(struct intel_engine_cs *engine)
 			list_move(&rq->sched.link, pl);
 			set_bit(I915_FENCE_FLAG_PQUEUE, &rq->fence.flags);
 
+			/* Check in case rollback so far, we wrap [size/2] */
+			if (intel_ring_direction(rq->ring,
+						 intel_ring_wrap(rq->ring,
+								 rq->tail),
+						 rq->ring->tail) > 0)
+				rq->context->lrc.desc |= CTX_DESC_FORCE_RESTORE;
+
 			active = rq;
 		} else {
 			struct intel_engine_cs *owner = rq->context->engine;
@@ -1505,8 +1512,9 @@ static u64 execlists_update_context(struct i915_request *rq)
 	 * HW has a tendency to ignore us rewinding the TAIL to the end of
 	 * an earlier request.
 	 */
+	GEM_BUG_ON(ce->lrc_reg_state[CTX_RING_TAIL] != rq->ring->tail);
+	prev = rq->ring->tail;
 	tail = intel_ring_set_tail(rq->ring, rq->tail);
-	prev = ce->lrc_reg_state[CTX_RING_TAIL];
 	if (unlikely(intel_ring_direction(rq->ring, tail, prev) <= 0))
 		desc |= CTX_DESC_FORCE_RESTORE;
 	ce->lrc_reg_state[CTX_RING_TAIL] = tail;
@@ -4758,6 +4766,14 @@ static int gen12_emit_flush(struct i915_request *request, u32 mode)
 	return 0;
 }
 
+static void assert_request_valid(struct i915_request *rq)
+{
+	struct intel_ring *ring __maybe_unused = rq->ring;
+
+	/* Can we unwind this request without appearing to go forwards? */
+	GEM_BUG_ON(intel_ring_direction(ring, rq->wa_tail, rq->head) <= 0);
+}
+
 /*
  * Reserve space for 2 NOOPs at the end of each request to be
  * used as a workaround for not being allowed to do lite
@@ -4770,6 +4786,9 @@ static u32 *gen8_emit_wa_tail(struct i915_request *request, u32 *cs)
 	*cs++ = MI_NOOP;
 	request->wa_tail = intel_ring_offset(request, cs);
 
+	/* Check that entire request is less than half the ring */
+	assert_request_valid(request);
+
 	return cs;
 }
 
diff --git a/drivers/gpu/drm/i915/gt/intel_ring.c b/drivers/gpu/drm/i915/gt/intel_ring.c
index 8cda1b7e17ba..bdb324167ef3 100644
--- a/drivers/gpu/drm/i915/gt/intel_ring.c
+++ b/drivers/gpu/drm/i915/gt/intel_ring.c
@@ -315,3 +315,7 @@ int intel_ring_cacheline_align(struct i915_request *rq)
 	GEM_BUG_ON(rq->ring->emit & (CACHELINE_BYTES - 1));
 	return 0;
 }
+
+#if IS_ENABLED(CONFIG_DRM_I915_SELFTEST)
+#include "selftest_ring.c"
+#endif
diff --git a/drivers/gpu/drm/i915/gt/selftest_mocs.c b/drivers/gpu/drm/i915/gt/selftest_mocs.c
index 7bae64018ad9..b25eba50c88e 100644
--- a/drivers/gpu/drm/i915/gt/selftest_mocs.c
+++ b/drivers/gpu/drm/i915/gt/selftest_mocs.c
@@ -18,6 +18,20 @@ struct live_mocs {
 	void *vaddr;
 };
 
+static struct intel_context *mocs_context_create(struct intel_engine_cs *engine)
+{
+	struct intel_context *ce;
+
+	ce = intel_context_create(engine);
+	if (IS_ERR(ce))
+		return ce;
+
+	/* We build large requests to read the registers from the ring */
+	ce->ring = __intel_context_ring_size(SZ_16K);
+
+	return ce;
+}
+
 static int request_add_sync(struct i915_request *rq, int err)
 {
 	i915_request_get(rq);
@@ -301,7 +315,7 @@ static int live_mocs_clean(void *arg)
 	for_each_engine(engine, gt, id) {
 		struct intel_context *ce;
 
-		ce = intel_context_create(engine);
+		ce = mocs_context_create(engine);
 		if (IS_ERR(ce)) {
 			err = PTR_ERR(ce);
 			break;
@@ -395,7 +409,7 @@ static int live_mocs_reset(void *arg)
 	for_each_engine(engine, gt, id) {
 		struct intel_context *ce;
 
-		ce = intel_context_create(engine);
+		ce = mocs_context_create(engine);
 		if (IS_ERR(ce)) {
 			err = PTR_ERR(ce);
 			break;
diff --git a/drivers/gpu/drm/i915/gt/selftest_ring.c b/drivers/gpu/drm/i915/gt/selftest_ring.c
new file mode 100644
index 000000000000..2a8c534dc125
--- /dev/null
+++ b/drivers/gpu/drm/i915/gt/selftest_ring.c
@@ -0,0 +1,110 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright © 2020 Intel Corporation
+ */
+
+static struct intel_ring *mock_ring(unsigned long sz)
+{
+	struct intel_ring *ring;
+
+	ring = kzalloc(sizeof(*ring) + sz, GFP_KERNEL);
+	if (!ring)
+		return NULL;
+
+	kref_init(&ring->ref);
+	ring->size = sz;
+	ring->wrap = BITS_PER_TYPE(ring->size) - ilog2(sz);
+	ring->effective_size = sz;
+	ring->vaddr = (void *)(ring + 1);
+	atomic_set(&ring->pin_count, 1);
+
+	intel_ring_update_space(ring);
+
+	return ring;
+}
+
+static void mock_ring_free(struct intel_ring *ring)
+{
+	kfree(ring);
+}
+
+static int check_ring_direction(struct intel_ring *ring,
+				u32 next, u32 prev,
+				int expected)
+{
+	int result;
+
+	result = intel_ring_direction(ring, next, prev);
+	if (result < 0)
+		result = -1;
+	else if (result > 0)
+		result = 1;
+
+	if (result != expected) {
+		pr_err("intel_ring_direction(%u, %u):%d != %d\n",
+		       next, prev, result, expected);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int check_ring_step(struct intel_ring *ring, u32 x, u32 step)
+{
+	u32 prev = x, next = intel_ring_wrap(ring, x + step);
+	int err = 0;
+
+	err |= check_ring_direction(ring, next, next,  0);
+	err |= check_ring_direction(ring, prev, prev,  0);
+	err |= check_ring_direction(ring, next, prev,  1);
+	err |= check_ring_direction(ring, prev, next, -1);
+
+	return err;
+}
+
+static int check_ring_offset(struct intel_ring *ring, u32 x, u32 step)
+{
+	int err = 0;
+
+	err |= check_ring_step(ring, x, step);
+	err |= check_ring_step(ring, intel_ring_wrap(ring, x + 1), step);
+	err |= check_ring_step(ring, intel_ring_wrap(ring, x - 1), step);
+
+	return err;
+}
+
+static int igt_ring_direction(void *dummy)
+{
+	struct intel_ring *ring;
+	unsigned int half = 2048;
+	int step, err = 0;
+
+	ring = mock_ring(2 * half);
+	if (!ring)
+		return -ENOMEM;
+
+	GEM_BUG_ON(ring->size != 2 * half);
+
+	/* Precision of wrap detection is limited to ring->size / 2 */
+	for (step = 1; step < half; step <<= 1) {
+		err |= check_ring_offset(ring, 0, step);
+		err |= check_ring_offset(ring, half, step);
+	}
+	err |= check_ring_step(ring, 0, half - 64);
+
+	/* And check unwrapped handling for good measure */
+	err |= check_ring_offset(ring, 0, 2 * half + 64);
+	err |= check_ring_offset(ring, 3 * half, 1);
+
+	mock_ring_free(ring);
+	return err;
+}
+
+int intel_ring_mock_selftests(void)
+{
+	static const struct i915_subtest tests[] = {
+		SUBTEST(igt_ring_direction),
+	};
+
+	return i915_subtests(tests, NULL);
+}
diff --git a/drivers/gpu/drm/i915/selftests/i915_mock_selftests.h b/drivers/gpu/drm/i915/selftests/i915_mock_selftests.h
index 1929feba4e8e..3db34d3eea58 100644
--- a/drivers/gpu/drm/i915/selftests/i915_mock_selftests.h
+++ b/drivers/gpu/drm/i915/selftests/i915_mock_selftests.h
@@ -21,6 +21,7 @@ selftest(fence, i915_sw_fence_mock_selftests)
 selftest(scatterlist, scatterlist_mock_selftests)
 selftest(syncmap, i915_syncmap_mock_selftests)
 selftest(uncore, intel_uncore_mock_selftests)
+selftest(ring, intel_ring_mock_selftests)
 selftest(engine, intel_engine_cs_mock_selftests)
 selftest(timelines, intel_timeline_mock_selftests)
 selftest(requests, i915_request_mock_selftests)
-- 
2.20.1

