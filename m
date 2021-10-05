Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 768B44228C6
	for <lists+stable@lfdr.de>; Tue,  5 Oct 2021 15:52:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236139AbhJENyP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Oct 2021 09:54:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:33172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235139AbhJENxX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 Oct 2021 09:53:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7D0BC61A56;
        Tue,  5 Oct 2021 13:51:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633441893;
        bh=HMRab5a0PXOH864n7eniAn3IyhBdZDy/3/p7pynA8Rk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=myPP8NbdBl08rBX3fUGpW50+WKZoek51vQZCtVyfjbYTqMNnWSBVGh/0EakQmfCak
         0uzJVKuaps5Pi3f8OFgislcn5A3M7+XnGqN7DM2HnbiWtjr7kyd1N+RTatC5e9XbKK
         nqg5I51H4Pw4N0jgKwp5bBNR1lQAppljaIMmBmrf+hhfxsbpV+7JJE2giMPBpnATCk
         RPWruBk2AdHchwiCryi1WwRlX6FzJmwJB3aOWeiv+xYcoZgml/mAyZ5nsH5HgeKJpk
         mSn1Y6LnI37fIIyAXZ2OFTXkTcFWSa98OQR9ugYup//+KwsZ+KY5aO/PD6BHzqPX1b
         SaHLIzzis7aWg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Song Liu <songliubraving@fb.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Lucian Grijincu <lucian@fb.com>,
        Sasha Levin <sashal@kernel.org>, mingo@redhat.com,
        acme@kernel.org, linux-perf-users@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 37/40] perf/core: fix userpage->time_enabled of inactive events
Date:   Tue,  5 Oct 2021 09:50:16 -0400
Message-Id: <20211005135020.214291-37-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211005135020.214291-1-sashal@kernel.org>
References: <20211005135020.214291-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Song Liu <songliubraving@fb.com>

[ Upstream commit f792565326825ed806626da50c6f9a928f1079c1 ]

Users of rdpmc rely on the mmapped user page to calculate accurate
time_enabled. Currently, userpage->time_enabled is only updated when the
event is added to the pmu. As a result, inactive event (due to counter
multiplexing) does not have accurate userpage->time_enabled. This can
be reproduced with something like:

   /* open 20 task perf_event "cycles", to create multiplexing */

   fd = perf_event_open();  /* open task perf_event "cycles" */
   userpage = mmap(fd);     /* use mmap and rdmpc */

   while (true) {
     time_enabled_mmap = xxx; /* use logic in perf_event_mmap_page */
     time_enabled_read = read(fd).time_enabled;
     if (time_enabled_mmap > time_enabled_read)
         BUG();
   }

Fix this by updating userpage for inactive events in merge_sched_in.

Suggested-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reported-and-tested-by: Lucian Grijincu <lucian@fb.com>
Signed-off-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20210929194313.2398474-1-songliubraving@fb.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/perf_event.h |  4 +++-
 kernel/events/core.c       | 34 ++++++++++++++++++++++++++++++----
 2 files changed, 33 insertions(+), 5 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 2d510ad750ed..4aa52f7a48c1 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -683,7 +683,9 @@ struct perf_event {
 	/*
 	 * timestamp shadows the actual context timing but it can
 	 * be safely used in NMI interrupt context. It reflects the
-	 * context time as it was when the event was last scheduled in.
+	 * context time as it was when the event was last scheduled in,
+	 * or when ctx_sched_in failed to schedule the event because we
+	 * run out of PMC.
 	 *
 	 * ctx_time already accounts for ctx->timestamp. Therefore to
 	 * compute ctx_time for a sample, simply add perf_clock().
diff --git a/kernel/events/core.c b/kernel/events/core.c
index e5c4aca620c5..22c5b1622c22 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -3707,6 +3707,29 @@ static noinline int visit_groups_merge(struct perf_cpu_context *cpuctx,
 	return 0;
 }
 
+static inline bool event_update_userpage(struct perf_event *event)
+{
+	if (likely(!atomic_read(&event->mmap_count)))
+		return false;
+
+	perf_event_update_time(event);
+	perf_set_shadow_time(event, event->ctx);
+	perf_event_update_userpage(event);
+
+	return true;
+}
+
+static inline void group_update_userpage(struct perf_event *group_event)
+{
+	struct perf_event *event;
+
+	if (!event_update_userpage(group_event))
+		return;
+
+	for_each_sibling_event(event, group_event)
+		event_update_userpage(event);
+}
+
 static int merge_sched_in(struct perf_event *event, void *data)
 {
 	struct perf_event_context *ctx = event->ctx;
@@ -3725,14 +3748,15 @@ static int merge_sched_in(struct perf_event *event, void *data)
 	}
 
 	if (event->state == PERF_EVENT_STATE_INACTIVE) {
+		*can_add_hw = 0;
 		if (event->attr.pinned) {
 			perf_cgroup_event_disable(event, ctx);
 			perf_event_set_state(event, PERF_EVENT_STATE_ERROR);
+		} else {
+			ctx->rotate_necessary = 1;
+			perf_mux_hrtimer_restart(cpuctx);
+			group_update_userpage(event);
 		}
-
-		*can_add_hw = 0;
-		ctx->rotate_necessary = 1;
-		perf_mux_hrtimer_restart(cpuctx);
 	}
 
 	return 0;
@@ -6311,6 +6335,8 @@ static int perf_mmap(struct file *file, struct vm_area_struct *vma)
 
 		ring_buffer_attach(event, rb);
 
+		perf_event_update_time(event);
+		perf_set_shadow_time(event, event->ctx);
 		perf_event_init_userpage(event);
 		perf_event_update_userpage(event);
 	} else {
-- 
2.33.0

