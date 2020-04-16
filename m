Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78ED21AC367
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 15:43:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407373AbgDPNm2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 09:42:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:55406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405440AbgDPNmZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:42:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 72BAD218AC;
        Thu, 16 Apr 2020 13:42:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587044545;
        bh=sM43j8+jjyYeXh9A6RDE8bPlJelQvkGDSH/i2ELAM/E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DPmWoVyg0zqu5MOHxH6qWZqzjVLzUihfxzz1U91JmUZPWsYawsN8r7///S7CQXr6+
         ACHkq33aFD5s2wm/Wverm12Y8QxfDOSw4DwOlZBs1957Iidq/YPfIAzifvsXF3A7SP
         iOZdpUvPCv0uXq+mQKs8UBI+7xDP5mvyyJf+CgxA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 252/257] perf/core: Unify {pinned,flexible}_sched_in()
Date:   Thu, 16 Apr 2020 15:25:03 +0200
Message-Id: <20200416131357.043818675@linuxfoundation.org>
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

[ Upstream commit ab6f824cfdf7363b5e529621cbc72ae6519c78d1 ]

Less is more; unify the two very nearly identical function.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/events/core.c | 58 ++++++++++++++++----------------------------
 1 file changed, 21 insertions(+), 37 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index fdb7f7ef380c4..b3d4f485bcfa6 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -1986,6 +1986,12 @@ static int perf_get_aux_event(struct perf_event *event,
 	return 1;
 }
 
+static inline struct list_head *get_event_list(struct perf_event *event)
+{
+	struct perf_event_context *ctx = event->ctx;
+	return event->attr.pinned ? &ctx->pinned_active : &ctx->flexible_active;
+}
+
 static void perf_group_detach(struct perf_event *event)
 {
 	struct perf_event *sibling, *tmp;
@@ -2028,12 +2034,8 @@ static void perf_group_detach(struct perf_event *event)
 		if (!RB_EMPTY_NODE(&event->group_node)) {
 			add_event_to_groups(sibling, event->ctx);
 
-			if (sibling->state == PERF_EVENT_STATE_ACTIVE) {
-				struct list_head *list = sibling->attr.pinned ?
-					&ctx->pinned_active : &ctx->flexible_active;
-
-				list_add_tail(&sibling->active_list, list);
-			}
+			if (sibling->state == PERF_EVENT_STATE_ACTIVE)
+				list_add_tail(&sibling->active_list, get_event_list(sibling));
 		}
 
 		WARN_ON_ONCE(sibling->ctx != event->ctx);
@@ -2350,6 +2352,8 @@ event_sched_in(struct perf_event *event,
 {
 	int ret = 0;
 
+	WARN_ON_ONCE(event->ctx != ctx);
+
 	lockdep_assert_held(&ctx->lock);
 
 	if (event->state <= PERF_EVENT_STATE_OFF)
@@ -3425,10 +3429,12 @@ struct sched_in_data {
 	int can_add_hw;
 };
 
-static int pinned_sched_in(struct perf_event *event, void *data)
+static int merge_sched_in(struct perf_event *event, void *data)
 {
 	struct sched_in_data *sid = data;
 
+	WARN_ON_ONCE(event->ctx != sid->ctx);
+
 	if (event->state <= PERF_EVENT_STATE_OFF)
 		return 0;
 
@@ -3437,37 +3443,15 @@ static int pinned_sched_in(struct perf_event *event, void *data)
 
 	if (group_can_go_on(event, sid->cpuctx, sid->can_add_hw)) {
 		if (!group_sched_in(event, sid->cpuctx, sid->ctx))
-			list_add_tail(&event->active_list, &sid->ctx->pinned_active);
+			list_add_tail(&event->active_list, get_event_list(event));
 	}
 
-	/*
-	 * If this pinned group hasn't been scheduled,
-	 * put it in error state.
-	 */
-	if (event->state == PERF_EVENT_STATE_INACTIVE)
-		perf_event_set_state(event, PERF_EVENT_STATE_ERROR);
-
-	return 0;
-}
-
-static int flexible_sched_in(struct perf_event *event, void *data)
-{
-	struct sched_in_data *sid = data;
-
-	if (event->state <= PERF_EVENT_STATE_OFF)
-		return 0;
-
-	if (!event_filter_match(event))
-		return 0;
+	if (event->state == PERF_EVENT_STATE_INACTIVE) {
+		if (event->attr.pinned)
+			perf_event_set_state(event, PERF_EVENT_STATE_ERROR);
 
-	if (group_can_go_on(event, sid->cpuctx, sid->can_add_hw)) {
-		int ret = group_sched_in(event, sid->cpuctx, sid->ctx);
-		if (ret) {
-			sid->can_add_hw = 0;
-			sid->ctx->rotate_necessary = 1;
-			return 0;
-		}
-		list_add_tail(&event->active_list, &sid->ctx->flexible_active);
+		sid->can_add_hw = 0;
+		sid->ctx->rotate_necessary = 1;
 	}
 
 	return 0;
@@ -3485,7 +3469,7 @@ ctx_pinned_sched_in(struct perf_event_context *ctx,
 
 	visit_groups_merge(&ctx->pinned_groups,
 			   smp_processor_id(),
-			   pinned_sched_in, &sid);
+			   merge_sched_in, &sid);
 }
 
 static void
@@ -3500,7 +3484,7 @@ ctx_flexible_sched_in(struct perf_event_context *ctx,
 
 	visit_groups_merge(&ctx->flexible_groups,
 			   smp_processor_id(),
-			   flexible_sched_in, &sid);
+			   merge_sched_in, &sid);
 }
 
 static void
-- 
2.20.1



