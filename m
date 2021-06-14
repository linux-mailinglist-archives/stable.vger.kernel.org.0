Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9553B3A5D68
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 09:08:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232096AbhFNHKw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 03:10:52 -0400
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:43577 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232424AbhFNHKw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Jun 2021 03:10:52 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R751e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=wenyang@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0UcIt26E_1623654521;
Received: from localhost(mailfrom:wenyang@linux.alibaba.com fp:SMTPD_---0UcIt26E_1623654521)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 14 Jun 2021 15:08:48 +0800
From:   Wen Yang <wenyang@linux.alibaba.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     stable <stable@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andi Kleen <ak@linux.intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Wen Yang <wenyang@linux.alibaba.com>
Subject: [PATCH 4.19] perf/core: Fix endless multiplex timer
Date:   Mon, 14 Jun 2021 15:08:26 +0800
Message-Id: <20210614070826.41040-1-wenyang@linux.alibaba.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 90c91dfb86d0ff545bd329d3ddd72c147e2ae198 ]

Kan and Andi reported that we fail to kill rotation when the flexible
events go empty, but the context does not. XXX moar

Fixes: fd7d55172d1e ("perf/cgroups: Don't rotate events for cgroups unnecessarily")
Reported-by: Andi Kleen <ak@linux.intel.com>
Reported-by: Kan Liang <kan.liang@linux.intel.com>
Tested-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20200305123851.GX2596@hirez.programming.kicks-ass.net
Cc: <stable@vger.kernel.org> # 4.19
Signed-off-by: Wen Yang <wenyang@linux.alibaba.com>
---
 kernel/events/core.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 335fbde..0d60c82 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -2081,6 +2081,7 @@ static inline int pmu_filter_match(struct perf_event *event)
 
 	if (!ctx->nr_events && ctx->is_active) {
 		ctx->is_active = 0;
+		ctx->rotate_necessary = 0;
 		if (ctx->task) {
 			WARN_ON_ONCE(cpuctx->task_ctx != ctx);
 			cpuctx->task_ctx = NULL;
@@ -2957,12 +2958,6 @@ static void ctx_sched_out(struct perf_event_context *ctx,
 	if (!ctx->nr_active || !(is_active & EVENT_ALL))
 		return;
 
-	/*
-	 * If we had been multiplexing, no rotations are necessary, now no events
-	 * are active.
-	 */
-	ctx->rotate_necessary = 0;
-
 	perf_pmu_disable(ctx->pmu);
 	if (is_active & EVENT_PINNED) {
 		list_for_each_entry_safe(event, tmp, &ctx->pinned_active, active_list)
@@ -2972,6 +2967,13 @@ static void ctx_sched_out(struct perf_event_context *ctx,
 	if (is_active & EVENT_FLEXIBLE) {
 		list_for_each_entry_safe(event, tmp, &ctx->flexible_active, active_list)
 			group_sched_out(event, cpuctx, ctx);
+
+		/*
+		 * Since we cleared EVENT_FLEXIBLE, also clear
+		 * rotate_necessary, is will be reset by
+		 * ctx_flexible_sched_in() when needed.
+		 */
+		ctx->rotate_necessary = 0;
 	}
 	perf_pmu_enable(ctx->pmu);
 }
@@ -3710,6 +3712,12 @@ static void rotate_ctx(struct perf_event_context *ctx, struct perf_event *event)
 				      typeof(*event), group_node);
 	}
 
+	/*
+	 * Unconditionally clear rotate_necessary; if ctx_flexible_sched_in()
+	 * finds there are unschedulable events, it will set it again.
+	 */
+	ctx->rotate_necessary = 0;
+
 	return event;
 }
 
-- 
1.8.3.1

