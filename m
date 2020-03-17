Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E38918808B
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 12:11:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728543AbgCQLLK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 07:11:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:54282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729029AbgCQLLK (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Mar 2020 07:11:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8491B20719;
        Tue, 17 Mar 2020 11:11:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584443469;
        bh=zNvJ3ICknpkN2zIsT7l86XyKLAoZLFhMG9n0Y6AeR+U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kWQVq5gNDXmzivzdhEYvgH/2Te4ZJQiGgltOp0Px4py7ZkOjwR8kE/G5BAdEQ55hS
         pu14LHMh5bAfeLyBIhvlqzJygPp9//NvkJFdKBlx/BDmk5hskiEl7ixkU68MvGWVuX
         8VgLPuq27Pt8G75roV5BqqAAT3NOwkXYwjX0I2f8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>,
        Mika Kuoppala <mika.kuoppala@linux.intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 5.5 090/151] drm/i915/execlists: Enable timeslice on partial virtual engine dequeue
Date:   Tue, 17 Mar 2020 11:55:00 +0100
Message-Id: <20200317103332.842961594@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200317103326.593639086@linuxfoundation.org>
References: <20200317103326.593639086@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Wilson <chris@chris-wilson.co.uk>

commit eafc2aa20fba319b6e791a1b0c45a91511eccb6b upstream.

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
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/gt/intel_lrc.c |   29 ++++++++++++++++++-----------
 1 file changed, 18 insertions(+), 11 deletions(-)

--- a/drivers/gpu/drm/i915/gt/intel_lrc.c
+++ b/drivers/gpu/drm/i915/gt/intel_lrc.c
@@ -1501,11 +1501,9 @@ need_timeslice(struct intel_engine_cs *e
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
@@ -1547,6 +1545,18 @@ static void set_timeslice(struct intel_e
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
@@ -1705,11 +1715,7 @@ static void execlists_dequeue(struct int
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
@@ -1744,7 +1750,8 @@ static void execlists_dequeue(struct int
 
 			if (last && !can_merge_rq(last, rq)) {
 				spin_unlock(&ve->base.active.lock);
-				return; /* leave this for another */
+				start_timeslice(engine);
+				return; /* leave this for another sibling */
 			}
 
 			GEM_TRACE("%s: virtual rq=%llx:%lld%s, new engine? %s\n",


