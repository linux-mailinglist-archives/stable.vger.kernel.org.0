Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A81281F4049
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 18:09:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731030AbgFIQJg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 12:09:36 -0400
Received: from mga18.intel.com ([134.134.136.126]:26503 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731021AbgFIQJf (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Jun 2020 12:09:35 -0400
IronPort-SDR: oI6YQCbbyJDmOoxRvqG7xDNBO/wmtbAEQpHn7WUDvlcdjbFkfcoERcvm97s4Cd8TMnCvsnz1N3
 c4my4Pyc+K8g==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2020 09:09:28 -0700
IronPort-SDR: DONK5yYrym7RteOi5rGWJWVMTu5LeqwWV/94MvUfIQBtx0j2zzADjHrdf6HjfM953pnW0Czgqu
 J/NhGKDXcUEw==
X-IronPort-AV: E=Sophos;i="5.73,492,1583222400"; 
   d="scan'208";a="306306184"
Received: from gem-build.fi.intel.com (HELO localhost) ([10.237.72.180])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2020 09:09:26 -0700
From:   Chris Wilson <chris@chris-wilson.co.uk>
To:     gfx-internal-devel@eclists.intel.com
Cc:     Chris Wilson <chris@chris-wilson.co.uk>,
        Mika Kuoppala <mika.kuoppala@linux.intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        stable@vger.kernel.org
Subject: [PATCH 030/185] drm/i915/execlists: Enable timeslice on partial virtual engine dequeue
Date:   Tue,  9 Jun 2020 16:04:55 +0000
Message-Id: <20200609160731.287073-31-chris@chris-wilson.co.uk>
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

If we stop filling the ELSP due to an incompatible virtual engine
request, check if we should enable the timeslice on behalf of the queue.

This fixes the case where we are inspecting the last->next element when
we know that the last element is the last request in the execution queue,
and so decided we did not need to enable timeslicing despite the intent
to do so!

Fixes: 8ee36e048c98 ("drm/i915/execlists: Minimalistic timeslicing")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Mika Kuoppala <mika.kuoppala@linux.intel.com>
Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Cc: <stable@vger.kernel.org> # v5.4+
Reviewed-by: Mika Kuoppala <mika.kuoppala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200306113012.3184606-1-chris@chris-wilson.co.uk
(cherry picked from commit 3df2deed411e0f1b7312baf0139aab8bba4c0410)
---
 drivers/gpu/drm/i915/gt/intel_lrc.c | 29 ++++++++++++++++++-----------
 1 file changed, 18 insertions(+), 11 deletions(-)

diff --git a/drivers/gpu/drm/i915/gt/intel_lrc.c b/drivers/gpu/drm/i915/gt/intel_lrc.c
index 354c68b74cec0..114c2b070a6d9 100644
--- a/drivers/gpu/drm/i915/gt/intel_lrc.c
+++ b/drivers/gpu/drm/i915/gt/intel_lrc.c
@@ -1839,11 +1839,9 @@ need_timeslice(struct intel_engine_cs *engine, const struct i915_request *rq)
 	if (!intel_engine_has_timeslices(engine))
 		return false;
 
-	if (list_is_last(&rq->sched.link, &engine->active.requests))
-		return false;
-
-	hint = max(rq_prio(list_next_entry(rq, sched.link)),
-		   engine->execlists.queue_priority_hint);
+	hint = engine->execlists.queue_priority_hint;
+	if (!list_is_last(&rq->sched.link, &engine->active.requests))
+		hint = max(hint, rq_prio(list_next_entry(rq, sched.link)));
 
 	return hint >= effective_prio(rq);
 }
@@ -1885,6 +1883,18 @@ static void set_timeslice(struct intel_engine_cs *engine)
 	set_timer_ms(&engine->execlists.timer, active_timeslice(engine));
 }
 
+static void start_timeslice(struct intel_engine_cs *engine)
+{
+	struct intel_engine_execlists *execlists = &engine->execlists;
+
+	execlists->switch_priority_hint = execlists->queue_priority_hint;
+
+	if (timer_pending(&execlists->timer))
+		return;
+
+	set_timer_ms(&execlists->timer, timeslice(engine));
+}
+
 static void record_preemption(struct intel_engine_execlists *execlists)
 {
 	(void)I915_SELFTEST_ONLY(execlists->preempt_hang.count++);
@@ -2048,11 +2058,7 @@ static void execlists_dequeue(struct intel_engine_cs *engine)
 				 * Even if ELSP[1] is occupied and not worthy
 				 * of timeslices, our queue might be.
 				 */
-				if (!execlists->timer.expires &&
-				    need_timeslice(engine, last))
-					set_timer_ms(&execlists->timer,
-						     timeslice(engine));
-
+				start_timeslice(engine);
 				return;
 			}
 		}
@@ -2087,7 +2093,8 @@ static void execlists_dequeue(struct intel_engine_cs *engine)
 
 			if (last && !can_merge_rq(last, rq)) {
 				spin_unlock(&ve->base.active.lock);
-				return; /* leave this for another */
+				start_timeslice(engine);
+				return; /* leave this for another sibling */
 			}
 
 			ENGINE_TRACE(engine,
---------------------------------------------------------------------
Intel Corporation (UK) Limited
Registered No. 1134945 (England)
Registered Office: Pipers Way, Swindon SN3 1RJ
VAT No: 860 2173 47

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

