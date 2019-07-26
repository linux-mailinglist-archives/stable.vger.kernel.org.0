Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B86D476D3C
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 17:32:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388941AbfGZPb6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 11:31:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:47044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388547AbfGZPb5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jul 2019 11:31:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2500A2054F;
        Fri, 26 Jul 2019 15:31:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564155116;
        bh=m0pjgZqAwwp79HXzIMN+N5yibjjUnFB3FUV5X1zWHTU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d7Pc3NM4DnBZQm3OBEnBfrMlnXCvEHTsHyTWkG+ii0sIYUrloBjs5WoK/vTWK0gpF
         emNKoYVJLhq8JhiewEcle2pVMyLjqhLMoEIzZ1e09h+wEDUnR/Ao/VRvFdy7U/06hi
         hjO9WkcnFFdXOkBCV3O5Gpus9dTmxZ8mZ/7/4+nI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Stephane Eranian <eranian@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vince Weaver <vincent.weaver@maine.edu>,
        mathieu.poirier@linaro.org, will.deacon@arm.com,
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 5.1 49/62] perf/core: Fix exclusive events grouping
Date:   Fri, 26 Jul 2019 17:25:01 +0200
Message-Id: <20190726152307.196264676@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190726152301.720139286@linuxfoundation.org>
References: <20190726152301.720139286@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Shishkin <alexander.shishkin@linux.intel.com>

commit 8a58ddae23796c733c5dfbd717538d89d036c5bd upstream.

So far, we tried to disallow grouping exclusive events for the fear of
complications they would cause with moving between contexts. Specifically,
moving a software group to a hardware context would violate the exclusivity
rules if both groups contain matching exclusive events.

This attempt was, however, unsuccessful: the check that we have in the
perf_event_open() syscall is both wrong (looks at wrong PMU) and
insufficient (group leader may still be exclusive), as can be illustrated
by running:

  $ perf record -e '{intel_pt//,cycles}' uname
  $ perf record -e '{cycles,intel_pt//}' uname

ultimately successfully.

Furthermore, we are completely free to trigger the exclusivity violation
by:

   perf -e '{cycles,intel_pt//}' -e '{intel_pt//,instructions}'

even though the helpful perf record will not allow that, the ABI will.

The warning later in the perf_event_open() path will also not trigger, because
it's also wrong.

Fix all this by validating the original group before moving, getting rid
of broken safeguards and placing a useful one to perf_install_in_context().

Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: <stable@vger.kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vince Weaver <vincent.weaver@maine.edu>
Cc: mathieu.poirier@linaro.org
Cc: will.deacon@arm.com
Fixes: bed5b25ad9c8a ("perf: Add a pmu capability for "exclusive" events")
Link: https://lkml.kernel.org/r/20190701110755.24646-1-alexander.shishkin@linux.intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/perf_event.h |    5 +++++
 kernel/events/core.c       |   34 ++++++++++++++++++++++------------
 2 files changed, 27 insertions(+), 12 deletions(-)

--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -1044,6 +1044,11 @@ static inline int in_software_context(st
 	return event->ctx->pmu->task_ctx_nr == perf_sw_context;
 }
 
+static inline int is_exclusive_pmu(struct pmu *pmu)
+{
+	return pmu->capabilities & PERF_PMU_CAP_EXCLUSIVE;
+}
+
 extern struct static_key perf_swevent_enabled[PERF_COUNT_SW_MAX];
 
 extern void ___perf_sw_event(u32, u64, struct pt_regs *, u64);
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -2543,6 +2543,9 @@ unlock:
 	return ret;
 }
 
+static bool exclusive_event_installable(struct perf_event *event,
+					struct perf_event_context *ctx);
+
 /*
  * Attach a performance event to a context.
  *
@@ -2557,6 +2560,8 @@ perf_install_in_context(struct perf_even
 
 	lockdep_assert_held(&ctx->mutex);
 
+	WARN_ON_ONCE(!exclusive_event_installable(event, ctx));
+
 	if (event->cpu != -1)
 		event->cpu = cpu;
 
@@ -4348,7 +4353,7 @@ static int exclusive_event_init(struct p
 {
 	struct pmu *pmu = event->pmu;
 
-	if (!(pmu->capabilities & PERF_PMU_CAP_EXCLUSIVE))
+	if (!is_exclusive_pmu(pmu))
 		return 0;
 
 	/*
@@ -4379,7 +4384,7 @@ static void exclusive_event_destroy(stru
 {
 	struct pmu *pmu = event->pmu;
 
-	if (!(pmu->capabilities & PERF_PMU_CAP_EXCLUSIVE))
+	if (!is_exclusive_pmu(pmu))
 		return;
 
 	/* see comment in exclusive_event_init() */
@@ -4399,14 +4404,15 @@ static bool exclusive_event_match(struct
 	return false;
 }
 
-/* Called under the same ctx::mutex as perf_install_in_context() */
 static bool exclusive_event_installable(struct perf_event *event,
 					struct perf_event_context *ctx)
 {
 	struct perf_event *iter_event;
 	struct pmu *pmu = event->pmu;
 
-	if (!(pmu->capabilities & PERF_PMU_CAP_EXCLUSIVE))
+	lockdep_assert_held(&ctx->mutex);
+
+	if (!is_exclusive_pmu(pmu))
 		return true;
 
 	list_for_each_entry(iter_event, &ctx->event_list, event_entry) {
@@ -10899,11 +10905,6 @@ SYSCALL_DEFINE5(perf_event_open,
 		goto err_alloc;
 	}
 
-	if ((pmu->capabilities & PERF_PMU_CAP_EXCLUSIVE) && group_leader) {
-		err = -EBUSY;
-		goto err_context;
-	}
-
 	/*
 	 * Look up the group leader (we will attach this event to it):
 	 */
@@ -10991,6 +10992,18 @@ SYSCALL_DEFINE5(perf_event_open,
 				move_group = 0;
 			}
 		}
+
+		/*
+		 * Failure to create exclusive events returns -EBUSY.
+		 */
+		err = -EBUSY;
+		if (!exclusive_event_installable(group_leader, ctx))
+			goto err_locked;
+
+		for_each_sibling_event(sibling, group_leader) {
+			if (!exclusive_event_installable(sibling, ctx))
+				goto err_locked;
+		}
 	} else {
 		mutex_lock(&ctx->mutex);
 	}
@@ -11027,9 +11040,6 @@ SYSCALL_DEFINE5(perf_event_open,
 	 * because we need to serialize with concurrent event creation.
 	 */
 	if (!exclusive_event_installable(event, ctx)) {
-		/* exclusive and group stuff are assumed mutually exclusive */
-		WARN_ON_ONCE(move_group);
-
 		err = -EBUSY;
 		goto err_locked;
 	}


