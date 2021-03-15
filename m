Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A3B233BAE8
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:11:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235771AbhCOOKo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:10:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:50442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234509AbhCOODr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:03:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 17AEA64EF9;
        Mon, 15 Mar 2021 14:03:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615817026;
        bh=PplaeYjiW7UAMAtNFVbW8J4x19PJGp6QA3tBFY0m3Rw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fq+W0FCWixILVgBoT9p9MAlaPzr9OMWAO+aqMsdMO7dRcixtKCiRIk4pm1jcY6wjU
         epKWxVJUEooz6ee0fVLZgFXqzpRxpajL+ifvixl+f9KIKWc4jrgbmVaftyxTfmI1qN
         Ccirnu8JtzVz3h9Q89KsfPYwHQwqIkUyqbkq7kDM=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gabriel Marin <gmx@google.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH 5.10 253/290] perf/core: Flush PMU internal buffers for per-CPU events
Date:   Mon, 15 Mar 2021 14:55:46 +0100
Message-Id: <20210315135550.565470611@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135541.921894249@linuxfoundation.org>
References: <20210315135541.921894249@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Kan Liang <kan.liang@linux.intel.com>

[ Upstream commit a5398bffc01fe044848c5024e5e867e407f239b8 ]

Sometimes the PMU internal buffers have to be flushed for per-CPU events
during a context switch, e.g., large PEBS. Otherwise, the perf tool may
report samples in locations that do not belong to the process where the
samples are processed in, because PEBS does not tag samples with PID/TID.

The current code only flush the buffers for a per-task event. It doesn't
check a per-CPU event.

Add a new event state flag, PERF_ATTACH_SCHED_CB, to indicate that the
PMU internal buffers have to be flushed for this event during a context
switch.

Add sched_cb_entry and perf_sched_cb_usages back to track the PMU/cpuctx
which is required to be flushed.

Only need to invoke the sched_task() for per-CPU events in this patch.
The per-task events have been handled in perf_event_context_sched_in/out
already.

Fixes: 9c964efa4330 ("perf/x86/intel: Drain the PEBS buffer during context switches")
Reported-by: Gabriel Marin <gmx@google.com>
Originally-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://lkml.kernel.org/r/20201130193842.10569-1-kan.liang@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/perf_event.h |  2 ++
 kernel/events/core.c       | 42 ++++++++++++++++++++++++++++++++++----
 2 files changed, 40 insertions(+), 4 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 96450f6fb1de..22ce0604b448 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -606,6 +606,7 @@ struct swevent_hlist {
 #define PERF_ATTACH_TASK	0x04
 #define PERF_ATTACH_TASK_DATA	0x08
 #define PERF_ATTACH_ITRACE	0x10
+#define PERF_ATTACH_SCHED_CB	0x20
 
 struct perf_cgroup;
 struct perf_buffer;
@@ -872,6 +873,7 @@ struct perf_cpu_context {
 	struct list_head		cgrp_cpuctx_entry;
 #endif
 
+	struct list_head		sched_cb_entry;
 	int				sched_cb_usage;
 
 	int				online;
diff --git a/kernel/events/core.c b/kernel/events/core.c
index c3ba29d058b7..4af161b3f322 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -383,6 +383,7 @@ static DEFINE_MUTEX(perf_sched_mutex);
 static atomic_t perf_sched_count;
 
 static DEFINE_PER_CPU(atomic_t, perf_cgroup_events);
+static DEFINE_PER_CPU(int, perf_sched_cb_usages);
 static DEFINE_PER_CPU(struct pmu_event_list, pmu_sb_events);
 
 static atomic_t nr_mmap_events __read_mostly;
@@ -3466,11 +3467,16 @@ static void perf_event_context_sched_out(struct task_struct *task, int ctxn,
 	}
 }
 
+static DEFINE_PER_CPU(struct list_head, sched_cb_list);
+
 void perf_sched_cb_dec(struct pmu *pmu)
 {
 	struct perf_cpu_context *cpuctx = this_cpu_ptr(pmu->pmu_cpu_context);
 
-	--cpuctx->sched_cb_usage;
+	this_cpu_dec(perf_sched_cb_usages);
+
+	if (!--cpuctx->sched_cb_usage)
+		list_del(&cpuctx->sched_cb_entry);
 }
 
 
@@ -3478,7 +3484,10 @@ void perf_sched_cb_inc(struct pmu *pmu)
 {
 	struct perf_cpu_context *cpuctx = this_cpu_ptr(pmu->pmu_cpu_context);
 
-	cpuctx->sched_cb_usage++;
+	if (!cpuctx->sched_cb_usage++)
+		list_add(&cpuctx->sched_cb_entry, this_cpu_ptr(&sched_cb_list));
+
+	this_cpu_inc(perf_sched_cb_usages);
 }
 
 /*
@@ -3507,6 +3516,24 @@ static void __perf_pmu_sched_task(struct perf_cpu_context *cpuctx, bool sched_in
 	perf_ctx_unlock(cpuctx, cpuctx->task_ctx);
 }
 
+static void perf_pmu_sched_task(struct task_struct *prev,
+				struct task_struct *next,
+				bool sched_in)
+{
+	struct perf_cpu_context *cpuctx;
+
+	if (prev == next)
+		return;
+
+	list_for_each_entry(cpuctx, this_cpu_ptr(&sched_cb_list), sched_cb_entry) {
+		/* will be handled in perf_event_context_sched_in/out */
+		if (cpuctx->task_ctx)
+			continue;
+
+		__perf_pmu_sched_task(cpuctx, sched_in);
+	}
+}
+
 static void perf_event_switch(struct task_struct *task,
 			      struct task_struct *next_prev, bool sched_in);
 
@@ -3529,6 +3556,9 @@ void __perf_event_task_sched_out(struct task_struct *task,
 {
 	int ctxn;
 
+	if (__this_cpu_read(perf_sched_cb_usages))
+		perf_pmu_sched_task(task, next, false);
+
 	if (atomic_read(&nr_switch_events))
 		perf_event_switch(task, next, false);
 
@@ -3837,6 +3867,9 @@ void __perf_event_task_sched_in(struct task_struct *prev,
 
 	if (atomic_read(&nr_switch_events))
 		perf_event_switch(task, prev, true);
+
+	if (__this_cpu_read(perf_sched_cb_usages))
+		perf_pmu_sched_task(prev, task, true);
 }
 
 static u64 perf_calculate_period(struct perf_event *event, u64 nsec, u64 count)
@@ -4661,7 +4694,7 @@ static void unaccount_event(struct perf_event *event)
 	if (event->parent)
 		return;
 
-	if (event->attach_state & PERF_ATTACH_TASK)
+	if (event->attach_state & (PERF_ATTACH_TASK | PERF_ATTACH_SCHED_CB))
 		dec = true;
 	if (event->attr.mmap || event->attr.mmap_data)
 		atomic_dec(&nr_mmap_events);
@@ -11056,7 +11089,7 @@ static void account_event(struct perf_event *event)
 	if (event->parent)
 		return;
 
-	if (event->attach_state & PERF_ATTACH_TASK)
+	if (event->attach_state & (PERF_ATTACH_TASK | PERF_ATTACH_SCHED_CB))
 		inc = true;
 	if (event->attr.mmap || event->attr.mmap_data)
 		atomic_inc(&nr_mmap_events);
@@ -12848,6 +12881,7 @@ static void __init perf_event_init_all_cpus(void)
 #ifdef CONFIG_CGROUP_PERF
 		INIT_LIST_HEAD(&per_cpu(cgrp_cpuctx_list, cpu));
 #endif
+		INIT_LIST_HEAD(&per_cpu(sched_cb_list, cpu));
 	}
 }
 
-- 
2.30.1



