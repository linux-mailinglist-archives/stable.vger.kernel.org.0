Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 603591ACA31
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 17:33:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410385AbgDPPcP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 11:32:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:55510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2441405AbgDPNma (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:42:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 73F822076D;
        Thu, 16 Apr 2020 13:42:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587044549;
        bh=7+c6pVLMVKpK+K5KTRWeQ5J/R2s6GfTYxOoxi9ddTZQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iKK5agGL+ci4jHiLYk9m8fM/SKrA65/m/0x7P/r59afpszUq8LYhlfoq3jR7Sajxn
         PK48V0f3L3l7gDu8M6GjY+oFAyge1gNWWNXiD2o/j5jS8WXv17k40EywC0DYtw2kfT
         bXODl0Dvonhnl/x5zqQPasJp2NHtpuaiC+8dFjNQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 254/257] perf/core: Remove struct sched_in_data
Date:   Thu, 16 Apr 2020 15:25:05 +0200
Message-Id: <20200416131357.280092911@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131325.891903893@linuxfoundation.org>
References: <20200416131325.891903893@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 2c2366c7548ecee65adfd264517ddf50f9e2d029 ]

We can deduce the ctx and cpuctx from the event, no need to pass them
along. Remove the structure and pass in can_add_hw directly.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/events/core.c | 36 +++++++++++-------------------------
 1 file changed, 11 insertions(+), 25 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 8d8e52a0922f4..78068b57cbba2 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -3437,17 +3437,11 @@ static int visit_groups_merge(struct perf_event_groups *groups, int cpu,
 	return 0;
 }
 
-struct sched_in_data {
-	struct perf_event_context *ctx;
-	struct perf_cpu_context *cpuctx;
-	int can_add_hw;
-};
-
 static int merge_sched_in(struct perf_event *event, void *data)
 {
-	struct sched_in_data *sid = data;
-
-	WARN_ON_ONCE(event->ctx != sid->ctx);
+	struct perf_event_context *ctx = event->ctx;
+	struct perf_cpu_context *cpuctx = __get_cpu_context(ctx);
+	int *can_add_hw = data;
 
 	if (event->state <= PERF_EVENT_STATE_OFF)
 		return 0;
@@ -3455,8 +3449,8 @@ static int merge_sched_in(struct perf_event *event, void *data)
 	if (!event_filter_match(event))
 		return 0;
 
-	if (group_can_go_on(event, sid->cpuctx, sid->can_add_hw)) {
-		if (!group_sched_in(event, sid->cpuctx, sid->ctx))
+	if (group_can_go_on(event, cpuctx, *can_add_hw)) {
+		if (!group_sched_in(event, cpuctx, ctx))
 			list_add_tail(&event->active_list, get_event_list(event));
 	}
 
@@ -3466,8 +3460,8 @@ static int merge_sched_in(struct perf_event *event, void *data)
 			perf_event_set_state(event, PERF_EVENT_STATE_ERROR);
 		}
 
-		sid->can_add_hw = 0;
-		sid->ctx->rotate_necessary = 1;
+		*can_add_hw = 0;
+		ctx->rotate_necessary = 1;
 	}
 
 	return 0;
@@ -3477,30 +3471,22 @@ static void
 ctx_pinned_sched_in(struct perf_event_context *ctx,
 		    struct perf_cpu_context *cpuctx)
 {
-	struct sched_in_data sid = {
-		.ctx = ctx,
-		.cpuctx = cpuctx,
-		.can_add_hw = 1,
-	};
+	int can_add_hw = 1;
 
 	visit_groups_merge(&ctx->pinned_groups,
 			   smp_processor_id(),
-			   merge_sched_in, &sid);
+			   merge_sched_in, &can_add_hw);
 }
 
 static void
 ctx_flexible_sched_in(struct perf_event_context *ctx,
 		      struct perf_cpu_context *cpuctx)
 {
-	struct sched_in_data sid = {
-		.ctx = ctx,
-		.cpuctx = cpuctx,
-		.can_add_hw = 1,
-	};
+	int can_add_hw = 1;
 
 	visit_groups_merge(&ctx->flexible_groups,
 			   smp_processor_id(),
-			   merge_sched_in, &sid);
+			   merge_sched_in, &can_add_hw);
 }
 
 static void
-- 
2.20.1



