Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1128239D6A1
	for <lists+stable@lfdr.de>; Mon,  7 Jun 2021 10:01:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230294AbhFGICn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Jun 2021 04:02:43 -0400
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:33968 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230175AbhFGICm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Jun 2021 04:02:42 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R651e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=wenyang@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0UbXBgFU_1623052849;
Received: from localhost(mailfrom:wenyang@linux.alibaba.com fp:SMTPD_---0UbXBgFU_1623052849)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 07 Jun 2021 16:00:50 +0800
From:   Wen Yang <wenyang@linux.alibaba.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     stable <stable@vger.kernel.org>, Song Liu <songliubraving@fb.com>,
        Peter Zijlstra <peterz@infradead.org>, kernel-team@fb.com,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>,
        Wen Yang <wenyang@linux.alibaba.com>
Subject: [PATCH 5.0 2/2] perf/core: Fix corner case in perf_rotate_context()
Date:   Mon,  7 Jun 2021 16:00:47 +0800
Message-Id: <20210607080047.8944-2-wenyang@linux.alibaba.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210607080047.8944-1-wenyang@linux.alibaba.com>
References: <20210607080047.8944-1-wenyang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Song Liu <songliubraving@fb.com>

[ Upstream commit 7fa343b7fdc4f351de4e3f28d5c285937dd1f42f ]

In perf_rotate_context(), when the first cpu flexible event fail to
schedule, cpu_rotate is 1, while cpu_event is NULL. Since cpu_event is
NULL, perf_rotate_context will _NOT_ call cpu_ctx_sched_out(), thus
cpuctx->ctx.is_active will have EVENT_FLEXIBLE set. Then, the next
perf_event_sched_in() will skip all cpu flexible events because of the
EVENT_FLEXIBLE bit.

In the next call of perf_rotate_context(), cpu_rotate stays 1, and
cpu_event stays NULL, so this process repeats. The end result is, flexible
events on this cpu will not be scheduled (until another event being added
to the cpuctx).

Here is an easy repro of this issue. On Intel CPUs, where ref-cycles
could only use one counter, run one pinned event for ref-cycles, one
flexible event for ref-cycles, and one flexible event for cycles. The
flexible ref-cycles is never scheduled, which is expected. However,
because of this issue, the cycles event is never scheduled either.

 $ perf stat -e ref-cycles:D,ref-cycles,cycles -C 5 -I 1000

           time             counts unit events
    1.000152973         15,412,480      ref-cycles:D
    1.000152973      <not counted>      ref-cycles     (0.00%)
    1.000152973      <not counted>      cycles         (0.00%)
    2.000486957         18,263,120      ref-cycles:D
    2.000486957      <not counted>      ref-cycles     (0.00%)
    2.000486957      <not counted>      cycles         (0.00%)

To fix this, when the flexible_active list is empty, try rotate the
first event in the flexible_groups. Also, rename ctx_first_active() to
ctx_event_to_rotate(), which is more accurate.

Signed-off-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: <kernel-team@fb.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Sasha Levin <sashal@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Fixes: 8d5bce0c37fa ("perf/core: Optimize perf_rotate_context() event scheduling")
Link: https://lkml.kernel.org/r/20191008165949.920548-1-songliubraving@fb.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: stable@vger.kernel.org # 4.19+
Signed-off-by: Wen Yang <wenyang@linux.alibaba.com>
---
 kernel/events/core.c | 22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 7e1f29f..6b7ad7a 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -3677,11 +3677,23 @@ static void rotate_ctx(struct perf_event_context *ctx, struct perf_event *event)
 	perf_event_groups_insert(&ctx->flexible_groups, event);
 }
 
+/* pick an event from the flexible_groups to rotate */
 static inline struct perf_event *
-ctx_first_active(struct perf_event_context *ctx)
+ctx_event_to_rotate(struct perf_event_context *ctx)
 {
-	return list_first_entry_or_null(&ctx->flexible_active,
-					struct perf_event, active_list);
+	struct perf_event *event;
+
+	/* pick the first active flexible event */
+	event = list_first_entry_or_null(&ctx->flexible_active,
+					 struct perf_event, active_list);
+
+	/* if no active flexible event, pick the first event */
+	if (!event) {
+		event = rb_entry_safe(rb_first(&ctx->flexible_groups.tree),
+				      typeof(*event), group_node);
+	}
+
+	return event;
 }
 
 static bool perf_rotate_context(struct perf_cpu_context *cpuctx)
@@ -3706,9 +3718,9 @@ static bool perf_rotate_context(struct perf_cpu_context *cpuctx)
 	perf_pmu_disable(cpuctx->ctx.pmu);
 
 	if (task_rotate)
-		task_event = ctx_first_active(task_ctx);
+		task_event = ctx_event_to_rotate(task_ctx);
 	if (cpu_rotate)
-		cpu_event = ctx_first_active(&cpuctx->ctx);
+		cpu_event = ctx_event_to_rotate(&cpuctx->ctx);
 
 	/*
 	 * As per the order given at ctx_resched() first 'pop' task flexible
-- 
1.8.3.1

