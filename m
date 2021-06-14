Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0662C3A6143
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 12:44:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232903AbhFNKpr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 06:45:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:50058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233568AbhFNKna (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 06:43:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5E36761437;
        Mon, 14 Jun 2021 10:36:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623666961;
        bh=hWG69ZQ7oXZQhDv+R0Z1/05FRfBv7Ecuh1J/C1TuPJc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S/Z818I4O4lJbYb07OlBmwk1jk4nZKS2QI60nTZwY7he/sjh56KzScwQ454+tjdQC
         r5nmZxxciEO0yFgKI4YhYPajShhrh4T+e6gSUppcPcBtbgRpCz1xm5IR/iHcATtb1H
         lyedCtNPGpBNh2ola4XDtsrRCRfyaA4s8X9/y/5Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Wen Yang <wenyang@linux.alibaba.com>
Subject: [PATCH 4.19 01/67] perf/core: Fix endless multiplex timer
Date:   Mon, 14 Jun 2021 12:26:44 +0200
Message-Id: <20210614102643.844029584@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102643.797691914@linuxfoundation.org>
References: <20210614102643.797691914@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

commit 90c91dfb86d0ff545bd329d3ddd72c147e2ae198 upstream.

Kan and Andi reported that we fail to kill rotation when the flexible
events go empty, but the context does not. XXX moar

Fixes: fd7d55172d1e ("perf/cgroups: Don't rotate events for cgroups unnecessarily")
Reported-by: Andi Kleen <ak@linux.intel.com>
Reported-by: Kan Liang <kan.liang@linux.intel.com>
Tested-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Wen Yang <wenyang@linux.alibaba.com>
Link: https://lkml.kernel.org/r/20200305123851.GX2596@hirez.programming.kicks-ass.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/events/core.c |   20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -2086,6 +2086,7 @@ __perf_remove_from_context(struct perf_e
 
 	if (!ctx->nr_events && ctx->is_active) {
 		ctx->is_active = 0;
+		ctx->rotate_necessary = 0;
 		if (ctx->task) {
 			WARN_ON_ONCE(cpuctx->task_ctx != ctx);
 			cpuctx->task_ctx = NULL;
@@ -2952,12 +2953,6 @@ static void ctx_sched_out(struct perf_ev
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
@@ -2967,6 +2962,13 @@ static void ctx_sched_out(struct perf_ev
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
@@ -3705,6 +3707,12 @@ ctx_event_to_rotate(struct perf_event_co
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
 


