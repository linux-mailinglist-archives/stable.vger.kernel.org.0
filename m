Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECE39220C28
	for <lists+stable@lfdr.de>; Wed, 15 Jul 2020 13:52:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726212AbgGOLwB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jul 2020 07:52:01 -0400
Received: from mail.fireflyinternet.com ([77.68.26.236]:59442 "EHLO
        fireflyinternet.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730506AbgGOLwA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Jul 2020 07:52:00 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from build.alporthouse.com (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP id 21826146-1500050 
        for multiple; Wed, 15 Jul 2020 12:51:56 +0100
From:   Chris Wilson <chris@chris-wilson.co.uk>
To:     intel-gfx@lists.freedesktop.org
Cc:     Chris Wilson <chris@chris-wilson.co.uk>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        stable@vger.kernel.org
Subject: [PATCH 38/66] drm/i915/gt: Use virtual_engine during execlists_dequeue
Date:   Wed, 15 Jul 2020 12:51:19 +0100
Message-Id: <20200715115147.11866-38-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200715115147.11866-1-chris@chris-wilson.co.uk>
References: <20200715115147.11866-1-chris@chris-wilson.co.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Rather than going back and forth between the rb_node entry and the
virtual_engine type, store the ve local and reuse it. As the
container_of conversion from rb_node to virtual_engine requires a
variable offset, performing that conversion just once shaves off a bit
of code.

v2: Keep a single virtual engine lookup, for typical use.

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Cc: <stable@vger.kernel.org> # v5.4+
---
 drivers/gpu/drm/i915/gt/intel_lrc.c | 254 ++++++++++++----------------
 1 file changed, 111 insertions(+), 143 deletions(-)

diff --git a/drivers/gpu/drm/i915/gt/intel_lrc.c b/drivers/gpu/drm/i915/gt/intel_lrc.c
index fabb20a6800b..ec533dfe3be9 100644
--- a/drivers/gpu/drm/i915/gt/intel_lrc.c
+++ b/drivers/gpu/drm/i915/gt/intel_lrc.c
@@ -453,9 +453,15 @@ static int queue_prio(const struct intel_engine_execlists *execlists)
 	return ((p->priority + 1) << I915_USER_PRIORITY_SHIFT) - ffs(p->used);
 }
 
+static int virtual_prio(const struct intel_engine_execlists *el)
+{
+	struct rb_node *rb = rb_first_cached(&el->virtual);
+
+	return rb ? rb_entry(rb, struct ve_node, rb)->prio : INT_MIN;
+}
+
 static inline bool need_preempt(const struct intel_engine_cs *engine,
-				const struct i915_request *rq,
-				struct rb_node *rb)
+				const struct i915_request *rq)
 {
 	int last_prio;
 
@@ -492,25 +498,6 @@ static inline bool need_preempt(const struct intel_engine_cs *engine,
 	    rq_prio(list_next_entry(rq, sched.link)) > last_prio)
 		return true;
 
-	if (rb) {
-		struct virtual_engine *ve =
-			rb_entry(rb, typeof(*ve), nodes[engine->id].rb);
-		bool preempt = false;
-
-		if (engine == ve->siblings[0]) { /* only preempt one sibling */
-			struct i915_request *next;
-
-			rcu_read_lock();
-			next = READ_ONCE(ve->request);
-			if (next)
-				preempt = rq_prio(next) > last_prio;
-			rcu_read_unlock();
-		}
-
-		if (preempt)
-			return preempt;
-	}
-
 	/*
 	 * If the inflight context did not trigger the preemption, then maybe
 	 * it was the set of queued requests? Pick the highest priority in
@@ -521,7 +508,8 @@ static inline bool need_preempt(const struct intel_engine_cs *engine,
 	 * ELSP[0] or ELSP[1] as, thanks again to PI, if it was the same
 	 * context, it's priority would not exceed ELSP[0] aka last_prio.
 	 */
-	return queue_prio(&engine->execlists) > last_prio;
+	return max(virtual_prio(&engine->execlists),
+		   queue_prio(&engine->execlists)) > last_prio;
 }
 
 __maybe_unused static inline bool
@@ -1806,6 +1794,35 @@ static bool virtual_matches(const struct virtual_engine *ve,
 	return true;
 }
 
+static struct virtual_engine *
+first_virtual_engine(struct intel_engine_cs *engine)
+{
+	struct intel_engine_execlists *el = &engine->execlists;
+	struct rb_node *rb = rb_first_cached(&el->virtual);
+
+	while (rb) {
+		struct virtual_engine *ve =
+			rb_entry(rb, typeof(*ve), nodes[engine->id].rb);
+		struct i915_request *rq = READ_ONCE(ve->request);
+
+		/* lazily cleanup after another engine handled rq */
+		if (!rq) {
+			rb_erase_cached(rb, &el->virtual);
+			RB_CLEAR_NODE(rb);
+			rb = rb_first_cached(&el->virtual);
+			continue;
+		}
+
+		if (!virtual_matches(ve, rq, engine)) {
+			rb = rb_next(rb);
+			continue;
+		}
+		return ve;
+	}
+
+	return NULL;
+}
+
 static void virtual_xfer_breadcrumbs(struct virtual_engine *ve)
 {
 	/*
@@ -1889,32 +1906,15 @@ static void defer_active(struct intel_engine_cs *engine)
 
 static bool
 need_timeslice(const struct intel_engine_cs *engine,
-	       const struct i915_request *rq,
-	       const struct rb_node *rb)
+	       const struct i915_request *rq)
 {
 	int hint;
 
 	if (!intel_engine_has_timeslices(engine))
 		return false;
 
-	hint = engine->execlists.queue_priority_hint;
-
-	if (rb) {
-		const struct virtual_engine *ve =
-			rb_entry(rb, typeof(*ve), nodes[engine->id].rb);
-		const struct intel_engine_cs *inflight =
-			intel_context_inflight(&ve->context);
-
-		if (!inflight || inflight == engine) {
-			struct i915_request *next;
-
-			rcu_read_lock();
-			next = READ_ONCE(ve->request);
-			if (next)
-				hint = max(hint, rq_prio(next));
-			rcu_read_unlock();
-		}
-	}
+	hint = max(engine->execlists.queue_priority_hint,
+		   virtual_prio(&engine->execlists));
 
 	if (!list_is_last(&rq->sched.link, &engine->active.requests))
 		hint = max(hint, rq_prio(list_next_entry(rq, sched.link)));
@@ -2053,6 +2053,7 @@ static void execlists_dequeue(struct intel_engine_cs *engine)
 	struct i915_request **port = execlists->pending;
 	struct i915_request ** const last_port = port + execlists->port_mask;
 	struct i915_request * const *active = execlists->active;
+	struct virtual_engine *ve;
 	struct i915_request *last;
 	unsigned long flags;
 	struct rb_node *rb;
@@ -2081,26 +2082,6 @@ static void execlists_dequeue(struct intel_engine_cs *engine)
 	 */
 	spin_lock_irqsave(&engine->active.lock, flags);
 
-	for (rb = rb_first_cached(&execlists->virtual); rb; ) {
-		struct virtual_engine *ve =
-			rb_entry(rb, typeof(*ve), nodes[engine->id].rb);
-		struct i915_request *rq = READ_ONCE(ve->request);
-
-		if (!rq) { /* lazily cleanup after another engine handled rq */
-			rb_erase_cached(rb, &execlists->virtual);
-			RB_CLEAR_NODE(rb);
-			rb = rb_first_cached(&execlists->virtual);
-			continue;
-		}
-
-		if (!virtual_matches(ve, rq, engine)) {
-			rb = rb_next(rb);
-			continue;
-		}
-
-		break;
-	}
-
 	/*
 	 * If the queue is higher priority than the last
 	 * request in the currently active context, submit afresh.
@@ -2123,7 +2104,7 @@ static void execlists_dequeue(struct intel_engine_cs *engine)
 	if ((last = *active)) {
 		if (i915_request_completed(last)) {
 			goto check_secondary;
-		} else if (need_preempt(engine, last, rb)) {
+		} else if (need_preempt(engine, last)) {
 			ENGINE_TRACE(engine,
 				     "preempting last=%llx:%lld, prio=%d, hint=%d\n",
 				     last->fence.context,
@@ -2149,7 +2130,7 @@ static void execlists_dequeue(struct intel_engine_cs *engine)
 			__unwind_incomplete_requests(engine);
 
 			last = NULL;
-		} else if (need_timeslice(engine, last, rb) &&
+		} else if (need_timeslice(engine, last) &&
 			   timeslice_expired(execlists, last)) {
 			ENGINE_TRACE(engine,
 				     "expired last=%llx:%lld, prio=%d, hint=%d, yield?=%s\n",
@@ -2201,111 +2182,98 @@ static void execlists_dequeue(struct intel_engine_cs *engine)
 		}
 	}
 
-	while (rb) { /* XXX virtual is always taking precedence */
-		struct virtual_engine *ve =
-			rb_entry(rb, typeof(*ve), nodes[engine->id].rb);
+	/* XXX virtual is always taking precedence */
+	while ((ve = first_virtual_engine(engine))) {
 		struct i915_request *rq;
 
 		spin_lock(&ve->base.active.lock);
 
 		rq = ve->request;
-		if (unlikely(!rq)) { /* lost the race to a sibling */
-			spin_unlock(&ve->base.active.lock);
-			rb_erase_cached(rb, &execlists->virtual);
-			RB_CLEAR_NODE(rb);
-			rb = rb_first_cached(&execlists->virtual);
-			continue;
-		}
+		if (unlikely(!rq)) /* lost the race to a sibling */
+			goto unlock;
 
-		GEM_BUG_ON(rq != ve->request);
 		GEM_BUG_ON(rq->engine != &ve->base);
 		GEM_BUG_ON(rq->context != &ve->context);
 
-		if (rq_prio(rq) >= queue_prio(execlists)) {
-			if (!virtual_matches(ve, rq, engine)) {
-				spin_unlock(&ve->base.active.lock);
-				rb = rb_next(rb);
-				continue;
-			}
+		if (unlikely(rq_prio(rq) < queue_prio(execlists))) {
+			spin_unlock(&ve->base.active.lock);
+			break;
+		}
 
-			if (last && !can_merge_rq(last, rq)) {
-				spin_unlock(&ve->base.active.lock);
-				spin_unlock_irqrestore(&engine->active.lock, flags);
-				start_timeslice(engine, rq_prio(rq));
-				return; /* leave this for another sibling */
-			}
+		GEM_BUG_ON(!virtual_matches(ve, rq, engine));
 
-			ENGINE_TRACE(engine,
-				     "virtual rq=%llx:%lld%s, new engine? %s\n",
-				     rq->fence.context,
-				     rq->fence.seqno,
-				     i915_request_completed(rq) ? "!" :
-				     i915_request_started(rq) ? "*" :
-				     "",
-				     yesno(engine != ve->siblings[0]));
-
-			WRITE_ONCE(ve->request, NULL);
-			WRITE_ONCE(ve->base.execlists.queue_priority_hint,
-				   INT_MIN);
-			rb_erase_cached(rb, &execlists->virtual);
-			RB_CLEAR_NODE(rb);
+		if (last && !can_merge_rq(last, rq)) {
+			spin_unlock(&ve->base.active.lock);
+			spin_unlock_irqrestore(&engine->active.lock, flags);
+			start_timeslice(engine, rq_prio(rq));
+			return; /* leave this for another sibling */
+		}
 
-			GEM_BUG_ON(!(rq->execution_mask & engine->mask));
-			WRITE_ONCE(rq->engine, engine);
+		ENGINE_TRACE(engine,
+			     "virtual rq=%llx:%lld%s, new engine? %s\n",
+			     rq->fence.context,
+			     rq->fence.seqno,
+			     i915_request_completed(rq) ? "!" :
+			     i915_request_started(rq) ? "*" :
+			     "",
+			     yesno(engine != ve->siblings[0]));
 
-			if (engine != ve->siblings[0]) {
-				u32 *regs = ve->context.lrc_reg_state;
-				unsigned int n;
+		WRITE_ONCE(ve->request, NULL);
+		WRITE_ONCE(ve->base.execlists.queue_priority_hint, INT_MIN);
 
-				GEM_BUG_ON(READ_ONCE(ve->context.inflight));
+		rb = &ve->nodes[engine->id].rb;
+		rb_erase_cached(rb, &execlists->virtual);
+		RB_CLEAR_NODE(rb);
 
-				if (!intel_engine_has_relative_mmio(engine))
-					virtual_update_register_offsets(regs,
-									engine);
+		GEM_BUG_ON(!(rq->execution_mask & engine->mask));
+		WRITE_ONCE(rq->engine, engine);
 
-				if (!list_empty(&ve->context.signals))
-					virtual_xfer_breadcrumbs(ve);
+		if (engine != ve->siblings[0]) {
+			u32 *regs = ve->context.lrc_reg_state;
+			unsigned int n;
 
-				/*
-				 * Move the bound engine to the top of the list
-				 * for future execution. We then kick this
-				 * tasklet first before checking others, so that
-				 * we preferentially reuse this set of bound
-				 * registers.
-				 */
-				for (n = 1; n < ve->num_siblings; n++) {
-					if (ve->siblings[n] == engine) {
-						swap(ve->siblings[n],
-						     ve->siblings[0]);
-						break;
-					}
-				}
+			GEM_BUG_ON(READ_ONCE(ve->context.inflight));
 
-				GEM_BUG_ON(ve->siblings[0] != engine);
-			}
+			if (!intel_engine_has_relative_mmio(engine))
+				virtual_update_register_offsets(regs, engine);
 
-			if (__i915_request_submit(rq)) {
-				submit = true;
-				last = rq;
-			}
-			i915_request_put(rq);
+			if (!list_empty(&ve->context.signals))
+				virtual_xfer_breadcrumbs(ve);
 
 			/*
-			 * Hmm, we have a bunch of virtual engine requests,
-			 * but the first one was already completed (thanks
-			 * preempt-to-busy!). Keep looking at the veng queue
-			 * until we have no more relevant requests (i.e.
-			 * the normal submit queue has higher priority).
+			 * Move the bound engine to the top of the list for
+			 * future execution. We then kick this tasklet first
+			 * before checking others, so that we preferentially
+			 * reuse this set of bound registers.
 			 */
-			if (!submit) {
-				spin_unlock(&ve->base.active.lock);
-				rb = rb_first_cached(&execlists->virtual);
-				continue;
+			for (n = 1; n < ve->num_siblings; n++) {
+				if (ve->siblings[n] == engine) {
+					swap(ve->siblings[n], ve->siblings[0]);
+					break;
+				}
 			}
+
+			GEM_BUG_ON(ve->siblings[0] != engine);
+		}
+
+		if (__i915_request_submit(rq)) {
+			submit = true;
+			last = rq;
 		}
 
+		i915_request_put(rq);
+unlock:
 		spin_unlock(&ve->base.active.lock);
-		break;
+
+		/*
+		 * Hmm, we have a bunch of virtual engine requests,
+		 * but the first one was already completed (thanks
+		 * preempt-to-busy!). Keep looking at the veng queue
+		 * until we have no more relevant requests (i.e.
+		 * the normal submit queue has higher priority).
+		 */
+		if (submit)
+			break;
 	}
 
 	while ((rb = rb_first_cached(&execlists->queue))) {
-- 
2.20.1

