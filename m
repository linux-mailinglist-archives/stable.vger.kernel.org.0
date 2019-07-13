Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97596679E8
	for <lists+stable@lfdr.de>; Sat, 13 Jul 2019 13:12:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727418AbfGMLMg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Jul 2019 07:12:36 -0400
Received: from terminus.zytor.com ([198.137.202.136]:41005 "EHLO
        terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726474AbfGMLMg (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 13 Jul 2019 07:12:36 -0400
Received: from terminus.zytor.com (localhost [127.0.0.1])
        by terminus.zytor.com (8.15.2/8.15.2) with ESMTPS id x6DBCJLN3842035
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Sat, 13 Jul 2019 04:12:19 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 terminus.zytor.com x6DBCJLN3842035
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
        s=2019061801; t=1563016340;
        bh=8P1Xx6tgO+zT9lTIq+5BV5iWKojj++eBEI9j+VPGaBQ=;
        h=Date:From:Cc:Reply-To:In-Reply-To:References:To:Subject:From;
        b=FYxhmluXHhqF2Rknt7Z6vMBTx+UyKMGh1AVebGXh8Ii22P2RXsoK+2/sf6fnNwlMz
         fMB0x+QEGP+c6duyihUEntHtGd2RrRtbPe12ZThIDJf0Fbq5wOurCy+rZCPxieJDr/
         UY0JIMW4HQLJc8rMh2Y1VtfmW/Up1M9CEN4yTQkqndXRM5paQqsWtgNatN8l4pU9NE
         EM4iNoL9U9hhavOkCeA1rGA9oeScco1gIVxjpNQ0CxLS86jQbfhm6e3pRr4VL4TEiA
         u1sPYTdSrqt69n4GW6LHgsyBN9oI/UnfdC7vSqv6cD+RQvAoWzDbUg5W/dqGSpEOfS
         D4JBzSyl3p7tQ==
Received: (from tipbot@localhost)
        by terminus.zytor.com (8.15.2/8.15.2/Submit) id x6DBCJAX3842032;
        Sat, 13 Jul 2019 04:12:19 -0700
Date:   Sat, 13 Jul 2019 04:12:19 -0700
X-Authentication-Warning: terminus.zytor.com: tipbot set sender to tipbot@zytor.com using -f
From:   tip-bot for Alexander Shishkin <tipbot@zytor.com>
Message-ID: <tip-8a58ddae23796c733c5dfbd717538d89d036c5bd@git.kernel.org>
Cc:     linux-kernel@vger.kernel.org, alexander.shishkin@linux.intel.com,
        tglx@linutronix.de, hpa@zytor.com, torvalds@linux-foundation.org,
        stable@vger.kernel.org, jolsa@redhat.com, vincent.weaver@maine.edu,
        acme@redhat.com, peterz@infradead.org, mingo@kernel.org,
        eranian@google.com
Reply-To: linux-kernel@vger.kernel.org, alexander.shishkin@linux.intel.com,
          tglx@linutronix.de, hpa@zytor.com, torvalds@linux-foundation.org,
          stable@vger.kernel.org, jolsa@redhat.com,
          vincent.weaver@maine.edu, acme@redhat.com, peterz@infradead.org,
          mingo@kernel.org, eranian@google.com
In-Reply-To: <20190701110755.24646-1-alexander.shishkin@linux.intel.com>
References: <20190701110755.24646-1-alexander.shishkin@linux.intel.com>
To:     linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf/core: Fix exclusive events' grouping
Git-Commit-ID: 8a58ddae23796c733c5dfbd717538d89d036c5bd
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from
 these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Spam-Status: No, score=-1.2 required=5.0 tests=ALL_TRUSTED,BAYES_00,
        DATE_IN_FUTURE_06_12,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,
        DKIM_VALID_EF autolearn=ham autolearn_force=no version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on terminus.zytor.com
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit-ID:  8a58ddae23796c733c5dfbd717538d89d036c5bd
Gitweb:     https://git.kernel.org/tip/8a58ddae23796c733c5dfbd717538d89d036c5bd
Author:     Alexander Shishkin <alexander.shishkin@linux.intel.com>
AuthorDate: Mon, 1 Jul 2019 14:07:55 +0300
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sat, 13 Jul 2019 11:21:28 +0200

perf/core: Fix exclusive events' grouping

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
---
 include/linux/perf_event.h |  5 +++++
 kernel/events/core.c       | 34 ++++++++++++++++++++++------------
 2 files changed, 27 insertions(+), 12 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 16e38c286d46..e8ad3c590a23 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -1055,6 +1055,11 @@ static inline int in_software_context(struct perf_event *event)
 	return event->ctx->pmu->task_ctx_nr == perf_sw_context;
 }
 
+static inline int is_exclusive_pmu(struct pmu *pmu)
+{
+	return pmu->capabilities & PERF_PMU_CAP_EXCLUSIVE;
+}
+
 extern struct static_key perf_swevent_enabled[PERF_COUNT_SW_MAX];
 
 extern void ___perf_sw_event(u32, u64, struct pt_regs *, u64);
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 5dd19bedbf64..eea9d52b010c 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -2553,6 +2553,9 @@ unlock:
 	return ret;
 }
 
+static bool exclusive_event_installable(struct perf_event *event,
+					struct perf_event_context *ctx);
+
 /*
  * Attach a performance event to a context.
  *
@@ -2567,6 +2570,8 @@ perf_install_in_context(struct perf_event_context *ctx,
 
 	lockdep_assert_held(&ctx->mutex);
 
+	WARN_ON_ONCE(!exclusive_event_installable(event, ctx));
+
 	if (event->cpu != -1)
 		event->cpu = cpu;
 
@@ -4360,7 +4365,7 @@ static int exclusive_event_init(struct perf_event *event)
 {
 	struct pmu *pmu = event->pmu;
 
-	if (!(pmu->capabilities & PERF_PMU_CAP_EXCLUSIVE))
+	if (!is_exclusive_pmu(pmu))
 		return 0;
 
 	/*
@@ -4391,7 +4396,7 @@ static void exclusive_event_destroy(struct perf_event *event)
 {
 	struct pmu *pmu = event->pmu;
 
-	if (!(pmu->capabilities & PERF_PMU_CAP_EXCLUSIVE))
+	if (!is_exclusive_pmu(pmu))
 		return;
 
 	/* see comment in exclusive_event_init() */
@@ -4411,14 +4416,15 @@ static bool exclusive_event_match(struct perf_event *e1, struct perf_event *e2)
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
@@ -10947,11 +10953,6 @@ SYSCALL_DEFINE5(perf_event_open,
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
@@ -11039,6 +11040,18 @@ SYSCALL_DEFINE5(perf_event_open,
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
@@ -11075,9 +11088,6 @@ SYSCALL_DEFINE5(perf_event_open,
 	 * because we need to serialize with concurrent event creation.
 	 */
 	if (!exclusive_event_installable(event, ctx)) {
-		/* exclusive and group stuff are assumed mutually exclusive */
-		WARN_ON_ONCE(move_group);
-
 		err = -EBUSY;
 		goto err_locked;
 	}
