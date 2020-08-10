Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67C642408E3
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 17:26:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728646AbgHJP0g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 11:26:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:60524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728182AbgHJP0f (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Aug 2020 11:26:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9D35F22B47;
        Mon, 10 Aug 2020 15:26:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597073195;
        bh=ngKCcMzHTQNYCHTw8bd6wbDeqC73Pdu0xRCEpWuv/co=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pDLsyBT6uTgmixhAigSUZETd8lMzIk7kUQ+tfzrZDJqg1SbZVG6gfOaUfYceM7A6+
         YU9EjIDIv7UyZ/V1SPyRf0mRf/HivWfWz1kfP2DpaFLPRRDq5V4uWXXq8LNnw7El7B
         ltTT8Te2zcQK3rFB92Wra5uF1olut9zHgaiK41Sg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Robin Murphy <robin.murphy@arm.com>
Subject: [PATCH 5.4 02/67] perf/core: Fix endless multiplex timer
Date:   Mon, 10 Aug 2020 17:20:49 +0200
Message-Id: <20200810151809.565265387@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200810151809.438685785@linuxfoundation.org>
References: <20200810151809.438685785@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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
Link: https://lkml.kernel.org/r/20200305123851.GX2596@hirez.programming.kicks-ass.net
Cc: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/events/core.c |   20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -2171,6 +2171,7 @@ __perf_remove_from_context(struct perf_e
 
 	if (!ctx->nr_events && ctx->is_active) {
 		ctx->is_active = 0;
+		ctx->rotate_necessary = 0;
 		if (ctx->task) {
 			WARN_ON_ONCE(cpuctx->task_ctx != ctx);
 			cpuctx->task_ctx = NULL;
@@ -3047,12 +3048,6 @@ static void ctx_sched_out(struct perf_ev
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
@@ -3062,6 +3057,13 @@ static void ctx_sched_out(struct perf_ev
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
@@ -3800,6 +3802,12 @@ ctx_event_to_rotate(struct perf_event_co
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
 


