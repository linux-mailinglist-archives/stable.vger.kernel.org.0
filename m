Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12B801661C6
	for <lists+stable@lfdr.de>; Thu, 20 Feb 2020 17:03:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728529AbgBTQDY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Feb 2020 11:03:24 -0500
Received: from mail.fireflyinternet.com ([77.68.26.236]:64432 "EHLO
        fireflyinternet.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728551AbgBTQDY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Feb 2020 11:03:24 -0500
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from haswell.alporthouse.com (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP id 20290540-1500050 
        for <stable@vger.kernel.org>; Thu, 20 Feb 2020 16:03:19 +0000
From:   Chris Wilson <chris@chris-wilson.co.uk>
To:     stable@vger.kernel.org
Subject: [PATCH 2/2] drm/i915/execlists: Always force a context reload when rewinding RING_TAIL
Date:   Thu, 20 Feb 2020 16:03:19 +0000
Message-Id: <20200220160319.1919629-2-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200220160319.1919629-1-chris@chris-wilson.co.uk>
References: <20200220160319.1919629-1-chris@chris-wilson.co.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Upstream: b1339ecac661 ("drm/i915/execlists: Always force a context reload when rewinding RING_TAIL")

If we rewind the RING_TAIL on a context, due to a preemption event, we
must force the context restore for the RING_TAIL update to be properly
handled. Rather than note which preemption events may cause us to rewind
the tail, compare the new request's tail with the previously submitted
RING_TAIL, as it turns out that timeslicing was causing unexpected
rewinds.

   <idle>-0       0d.s2 1280851190us : __execlists_submission_tasklet: 0000:00:02.0 rcs0: expired last=130:4698, prio=3, hint=3
   <idle>-0       0d.s2 1280851192us : __i915_request_unsubmit: 0000:00:02.0 rcs0: fence 66:119966, current 119964
   <idle>-0       0d.s2 1280851195us : __i915_request_unsubmit: 0000:00:02.0 rcs0: fence 130:4698, current 4695
   <idle>-0       0d.s2 1280851198us : __i915_request_unsubmit: 0000:00:02.0 rcs0: fence 130:4696, current 4695
^----  Note we unwind 2 requests from the same context

   <idle>-0       0d.s2 1280851208us : __i915_request_submit: 0000:00:02.0 rcs0: fence 130:4696, current 4695
   <idle>-0       0d.s2 1280851213us : __i915_request_submit: 0000:00:02.0 rcs0: fence 134:1508, current 1506
^---- But to apply the new timeslice, we have to replay the first request
      before the new client can start -- the unexpected RING_TAIL rewind

   <idle>-0       0d.s2 1280851219us : trace_ports: 0000:00:02.0 rcs0: submit { 130:4696*, 134:1508 }
 synmark2-5425    2..s. 1280851239us : process_csb: 0000:00:02.0 rcs0: cs-irq head=5, tail=0
 synmark2-5425    2..s. 1280851240us : process_csb: 0000:00:02.0 rcs0: csb[0]: status=0x00008002:0x00000000
^---- Preemption event for the ELSP update; note the lite-restore

 synmark2-5425    2..s. 1280851243us : trace_ports: 0000:00:02.0 rcs0: preempted { 130:4698, 66:119966 }
 synmark2-5425    2..s. 1280851246us : trace_ports: 0000:00:02.0 rcs0: promote { 130:4696*, 134:1508 }
 synmark2-5425    2.... 1280851462us : __i915_request_commit: 0000:00:02.0 rcs0: fence 130:4700, current 4695
 synmark2-5425    2.... 1280852111us : __i915_request_commit: 0000:00:02.0 rcs0: fence 130:4702, current 4695
 synmark2-5425    2.Ns1 1280852296us : process_csb: 0000:00:02.0 rcs0: cs-irq head=0, tail=2
 synmark2-5425    2.Ns1 1280852297us : process_csb: 0000:00:02.0 rcs0: csb[1]: status=0x00000814:0x00000000
 synmark2-5425    2.Ns1 1280852299us : trace_ports: 0000:00:02.0 rcs0: completed { 130:4696!, 134:1508 }
 synmark2-5425    2.Ns1 1280852301us : process_csb: 0000:00:02.0 rcs0: csb[2]: status=0x00000818:0x00000040
 synmark2-5425    2.Ns1 1280852302us : trace_ports: 0000:00:02.0 rcs0: completed { 134:1508, 0:0 }
 synmark2-5425    2.Ns1 1280852313us : process_csb: process_csb:2336 GEM_BUG_ON(!i915_request_completed(*execlists->active) && !reset_in_progress(execlists))

Fixes: 8ee36e048c98 ("drm/i915/execlists: Minimalistic timeslicing")
Referenecs: 82c69bf58650 ("drm/i915/gt: Detect if we miss WaIdleLiteRestore")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Mika Kuoppala <mika.kuoppala@linux.intel.com>
Reviewed-by: Mika Kuoppala <mika.kuoppala@linux.intel.com>
Cc: <stable@vger.kernel.org> # v5.4+
Link: https://patchwork.freedesktop.org/patch/msgid/20200207211452.2860634-1-chris@chris-wilson.co.uk
(cherry picked from commit 5ba32c7be81e53ea8a27190b0f6be98e6c6779af)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
---
 drivers/gpu/drm/i915/gt/intel_engine.h       |  8 ++++++++
 drivers/gpu/drm/i915/gt/intel_engine_types.h |  1 +
 drivers/gpu/drm/i915/gt/intel_lrc.c          | 18 ++++++++----------
 drivers/gpu/drm/i915/gt/intel_ringbuffer.c   |  2 ++
 4 files changed, 19 insertions(+), 10 deletions(-)

diff --git a/drivers/gpu/drm/i915/gt/intel_engine.h b/drivers/gpu/drm/i915/gt/intel_engine.h
index 22aab8593abf..926272b5a0ca 100644
--- a/drivers/gpu/drm/i915/gt/intel_engine.h
+++ b/drivers/gpu/drm/i915/gt/intel_engine.h
@@ -250,6 +250,14 @@ static inline u32 intel_ring_wrap(const struct intel_ring *ring, u32 pos)
 	return pos & (ring->size - 1);
 }
 
+static inline int intel_ring_direction(const struct intel_ring *ring,
+				       u32 next, u32 prev)
+{
+	typecheck(typeof(ring->size), next);
+	typecheck(typeof(ring->size), prev);
+	return (next - prev) << ring->wrap;
+}
+
 static inline bool
 intel_ring_offset_valid(const struct intel_ring *ring,
 			unsigned int pos)
diff --git a/drivers/gpu/drm/i915/gt/intel_engine_types.h b/drivers/gpu/drm/i915/gt/intel_engine_types.h
index 798e1b024406..c77c9518c58b 100644
--- a/drivers/gpu/drm/i915/gt/intel_engine_types.h
+++ b/drivers/gpu/drm/i915/gt/intel_engine_types.h
@@ -107,6 +107,7 @@ struct intel_ring {
 
 	u32 space;
 	u32 size;
+	u32 wrap;
 	u32 effective_size;
 };
 
diff --git a/drivers/gpu/drm/i915/gt/intel_lrc.c b/drivers/gpu/drm/i915/gt/intel_lrc.c
index e0e4f3deb2da..bf6addece25b 100644
--- a/drivers/gpu/drm/i915/gt/intel_lrc.c
+++ b/drivers/gpu/drm/i915/gt/intel_lrc.c
@@ -647,7 +647,7 @@ static u64 execlists_update_context(struct i915_request *rq)
 {
 	struct intel_context *ce = rq->hw_context;
 	u64 desc = ce->lrc_desc;
-	u32 tail;
+	u32 tail, prev;
 
 	/*
 	 * WaIdleLiteRestore:bdw,skl
@@ -660,9 +660,15 @@ static u64 execlists_update_context(struct i915_request *rq)
 	 * subsequent resubmissions (for lite restore). Should that fail us,
 	 * and we try and submit the same tail again, force the context
 	 * reload.
+	 *
+	 * If we need to return to a preempted context, we need to skip the
+	 * lite-restore and force it to reload the RING_TAIL. Otherwise, the
+	 * HW has a tendency to ignore us rewinding the TAIL to the end of
+	 * an earlier request.
 	 */
 	tail = intel_ring_set_tail(rq->ring, rq->tail);
-	if (unlikely(ce->lrc_reg_state[CTX_RING_TAIL + 1] == tail))
+	prev = ce->lrc_reg_state[CTX_RING_TAIL + 1];
+	if (unlikely(intel_ring_direction(rq->ring, tail, prev) <= 0))
 		desc |= CTX_DESC_FORCE_RESTORE;
 	ce->lrc_reg_state[CTX_RING_TAIL + 1] = tail;
 	rq->tail = rq->wa_tail;
@@ -1110,14 +1116,6 @@ static void execlists_dequeue(struct intel_engine_cs *engine)
 			 */
 			__unwind_incomplete_requests(engine);
 
-			/*
-			 * If we need to return to the preempted context, we
-			 * need to skip the lite-restore and force it to
-			 * reload the RING_TAIL. Otherwise, the HW has a
-			 * tendency to ignore us rewinding the TAIL to the
-			 * end of an earlier request.
-			 */
-			last->hw_context->lrc_desc |= CTX_DESC_FORCE_RESTORE;
 			last = NULL;
 		} else if (need_timeslice(engine, last) &&
 			   !timer_pending(&engine->execlists.timer)) {
diff --git a/drivers/gpu/drm/i915/gt/intel_ringbuffer.c b/drivers/gpu/drm/i915/gt/intel_ringbuffer.c
index bacaa7bb8c9a..eee9fcbe0434 100644
--- a/drivers/gpu/drm/i915/gt/intel_ringbuffer.c
+++ b/drivers/gpu/drm/i915/gt/intel_ringbuffer.c
@@ -1312,6 +1312,8 @@ intel_engine_create_ring(struct intel_engine_cs *engine, int size)
 	kref_init(&ring->ref);
 
 	ring->size = size;
+	ring->wrap = BITS_PER_TYPE(ring->size) - ilog2(size);
+
 	/* Workaround an erratum on the i830 which causes a hang if
 	 * the TAIL pointer points to within the last 2 cachelines
 	 * of the buffer.
-- 
2.25.1

