Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 242BB191053
	for <lists+stable@lfdr.de>; Tue, 24 Mar 2020 14:31:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729246AbgCXN1N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Mar 2020 09:27:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:52660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729781AbgCXN1M (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Mar 2020 09:27:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CB444208D6;
        Tue, 24 Mar 2020 13:27:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585056431;
        bh=jkvKFhV63OxrWibFRilbxYglbRAPsZJ3Xx77d/C46Ss=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1PG0+BZ107JFJwFg3IfnCERXPsdr06F59Kh6TrW1U2ewQzT7wNZJfbLo99QS2KmL2
         dPpeLldMDl9/CqhWPkWx30cELLpCEZlz/E2eGdoO4ZHrp9CHJcI6kd/BVFDued2mSf
         mV70ShBS0NNjHN3KSKmDx/t9SgA3IzjDRv7H4kEM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>,
        Mika Kuoppala <mika.kuoppala@linux.intel.com>,
        Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 5.5 114/119] drm/i915/execlists: Track active elements during dequeue
Date:   Tue, 24 Mar 2020 14:11:39 +0100
Message-Id: <20200324130819.024249147@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200324130808.041360967@linuxfoundation.org>
References: <20200324130808.041360967@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Wilson <chris@chris-wilson.co.uk>

commit 9777d8b2d2a148bc5d46694ec4f2559282fec8cf upstream.

Record the initial active element we use when building the next ELSP
submission, so that we can compare against it latter to see if there's
no change.

Fixes: 44d0a9c05bc0 ("drm/i915/execlists: Skip redundant resubmission")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Reviewed-by: Mika Kuoppala <mika.kuoppala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200311092624.10012-2-chris@chris-wilson.co.uk
(cherry picked from commit 60ef5b7ac6a131f09d287a5f156c878c2c926a30)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/gt/intel_lrc.c |   32 ++++++++++++--------------------
 1 file changed, 12 insertions(+), 20 deletions(-)

--- a/drivers/gpu/drm/i915/gt/intel_lrc.c
+++ b/drivers/gpu/drm/i915/gt/intel_lrc.c
@@ -1422,17 +1422,6 @@ static void virtual_xfer_breadcrumbs(str
 	spin_unlock(&old->breadcrumbs.irq_lock);
 }
 
-static struct i915_request *
-last_active(const struct intel_engine_execlists *execlists)
-{
-	struct i915_request * const *last = READ_ONCE(execlists->active);
-
-	while (*last && i915_request_completed(*last))
-		last++;
-
-	return *last;
-}
-
 #define for_each_waiter(p__, rq__) \
 	list_for_each_entry_lockless(p__, \
 				     &(rq__)->sched.waiters_list, \
@@ -1562,11 +1551,9 @@ static void record_preemption(struct int
 	(void)I915_SELFTEST_ONLY(execlists->preempt_hang.count++);
 }
 
-static unsigned long active_preempt_timeout(struct intel_engine_cs *engine)
+static unsigned long active_preempt_timeout(struct intel_engine_cs *engine,
+					    const struct i915_request *rq)
 {
-	struct i915_request *rq;
-
-	rq = last_active(&engine->execlists);
 	if (!rq)
 		return 0;
 
@@ -1577,13 +1564,14 @@ static unsigned long active_preempt_time
 	return READ_ONCE(engine->props.preempt_timeout_ms);
 }
 
-static void set_preempt_timeout(struct intel_engine_cs *engine)
+static void set_preempt_timeout(struct intel_engine_cs *engine,
+				const struct i915_request *rq)
 {
 	if (!intel_engine_has_preempt_reset(engine))
 		return;
 
 	set_timer_ms(&engine->execlists.preempt,
-		     active_preempt_timeout(engine));
+		     active_preempt_timeout(engine, rq));
 }
 
 static void execlists_dequeue(struct intel_engine_cs *engine)
@@ -1591,6 +1579,7 @@ static void execlists_dequeue(struct int
 	struct intel_engine_execlists * const execlists = &engine->execlists;
 	struct i915_request **port = execlists->pending;
 	struct i915_request ** const last_port = port + execlists->port_mask;
+	struct i915_request * const *active;
 	struct i915_request *last;
 	struct rb_node *rb;
 	bool submit = false;
@@ -1645,7 +1634,10 @@ static void execlists_dequeue(struct int
 	 * i.e. we will retrigger preemption following the ack in case
 	 * of trouble.
 	 */
-	last = last_active(execlists);
+	active = READ_ONCE(execlists->active);
+	while ((last = *active) && i915_request_completed(last))
+		active++;
+
 	if (last) {
 		if (need_preempt(engine, last, rb)) {
 			GEM_TRACE("%s: preempting last=%llx:%lld, prio=%d, hint=%d\n",
@@ -1930,7 +1922,7 @@ done:
 		 * Skip if we ended up with exactly the same set of requests,
 		 * e.g. trying to timeslice a pair of ordered contexts
 		 */
-		if (!memcmp(execlists->active, execlists->pending,
+		if (!memcmp(active, execlists->pending,
 			    (port - execlists->pending + 1) * sizeof(*port))) {
 			do
 				execlists_schedule_out(fetch_and_zero(port));
@@ -1942,7 +1934,7 @@ done:
 		memset(port + 1, 0, (last_port - port) * sizeof(*port));
 		execlists_submit_ports(engine);
 
-		set_preempt_timeout(engine);
+		set_preempt_timeout(engine, *active);
 	} else {
 skip_submit:
 		ring_set_paused(engine, 0);


