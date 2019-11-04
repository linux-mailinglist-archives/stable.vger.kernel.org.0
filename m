Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E13F4EEE72
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:15:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390016AbfKDWG4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 17:06:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:39110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390007AbfKDWGz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 17:06:55 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1E76B21929;
        Mon,  4 Nov 2019 22:06:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572905214;
        bh=kyjLqph88o+wPleGjm0mTVV/EB/K+0iYsh689D4+bjc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UXajCUeUMNa7qIhiQLc9W3ljffP5LuB94bKOz6SGpzStWxqnLC+MFeJ0C66OOy7tO
         /DRpMOfH1isIcKdge67mxla1Bs6sMLtMblMFI4MclTM1mDG9hMJZkhXXeh2QwIekt9
         Tqac1vs9WXAnQfqHQnbZ/OkfME+wN88QRbGt3/Gw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Song Liu <songliubraving@fb.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        kernel-team@fb.com, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 5.3 068/163] perf/core: Fix corner case in perf_rotate_context()
Date:   Mon,  4 Nov 2019 22:44:18 +0100
Message-Id: <20191104212144.873111985@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104212140.046021995@linuxfoundation.org>
References: <20191104212140.046021995@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/events/core.c | 22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index c0a6a50e01af6..2ff44d7308dd7 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -3694,11 +3694,23 @@ static void rotate_ctx(struct perf_event_context *ctx, struct perf_event *event)
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
@@ -3723,9 +3735,9 @@ static bool perf_rotate_context(struct perf_cpu_context *cpuctx)
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
2.20.1



