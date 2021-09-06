Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D65DE401363
	for <lists+stable@lfdr.de>; Mon,  6 Sep 2021 03:25:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239960AbhIFBZl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Sep 2021 21:25:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:39302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239950AbhIFBYI (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 5 Sep 2021 21:24:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 44F5C60F45;
        Mon,  6 Sep 2021 01:21:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630891319;
        bh=I5TKpZ7wZFl7VHnprLymKXat9YKBVNE+q9pWspuy9P0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=roaBiXvj7hwgAmHHwAvthzRguEPXc4uq6RshpXkqSelisrW3rYMGTxkNu0ebTAgi5
         ULX7dlLW95+meQwAuX1sPJvLPHqsXm7NNmLIM7kty7MJqJ2A1xcq1KJSWqUJKvhpiG
         Ka/5AXpi18Ff/mEv+ZAtB4ARGjqCZ2RXizerMbKWG+eJ2rNB+s6FcfSJuTYPC88FyU
         JzobAqS+LX82Qd2Fy/K7k7EuT9iPnU2+yj9VJDOP4BV3es1M5VxL5fVAlz+n1MTVKp
         +9iaOjH38umDVRkmY0oQDZkXOI6PMPeCmE4purZi1xnJF+P06k92c9bsUkMftthz11
         B57VtLArWUp1A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Quentin Perret <qperret@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.10 05/39] sched/deadline: Fix reset_on_fork reporting of DL tasks
Date:   Sun,  5 Sep 2021 21:21:19 -0400
Message-Id: <20210906012153.929962-5-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210906012153.929962-1-sashal@kernel.org>
References: <20210906012153.929962-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Quentin Perret <qperret@google.com>

[ Upstream commit f95091536f78971b269ec321b057b8d630b0ad8a ]

It is possible for sched_getattr() to incorrectly report the state of
the reset_on_fork flag when called on a deadline task.

Indeed, if the flag was set on a deadline task using sched_setattr()
with flags (SCHED_FLAG_RESET_ON_FORK | SCHED_FLAG_KEEP_PARAMS), then
p->sched_reset_on_fork will be set, but __setscheduler() will bail out
early, which means that the dl_se->flags will not get updated by
__setscheduler_params()->__setparam_dl(). Consequently, if
sched_getattr() is then called on the task, __getparam_dl() will
override kattr.sched_flags with the now out-of-date copy in dl_se->flags
and report the stale value to userspace.

To fix this, make sure to only copy the flags that are relevant to
sched_deadline to and from the dl_se->flags field.

Signed-off-by: Quentin Perret <qperret@google.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lore.kernel.org/r/20210727101103.2729607-2-qperret@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/deadline.c | 7 ++++---
 kernel/sched/sched.h    | 2 ++
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 6b98c1fe6e7f..82c76196a9d2 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -2703,7 +2703,7 @@ void __setparam_dl(struct task_struct *p, const struct sched_attr *attr)
 	dl_se->dl_runtime = attr->sched_runtime;
 	dl_se->dl_deadline = attr->sched_deadline;
 	dl_se->dl_period = attr->sched_period ?: dl_se->dl_deadline;
-	dl_se->flags = attr->sched_flags;
+	dl_se->flags = attr->sched_flags & SCHED_DL_FLAGS;
 	dl_se->dl_bw = to_ratio(dl_se->dl_period, dl_se->dl_runtime);
 	dl_se->dl_density = to_ratio(dl_se->dl_deadline, dl_se->dl_runtime);
 }
@@ -2716,7 +2716,8 @@ void __getparam_dl(struct task_struct *p, struct sched_attr *attr)
 	attr->sched_runtime = dl_se->dl_runtime;
 	attr->sched_deadline = dl_se->dl_deadline;
 	attr->sched_period = dl_se->dl_period;
-	attr->sched_flags = dl_se->flags;
+	attr->sched_flags &= ~SCHED_DL_FLAGS;
+	attr->sched_flags |= dl_se->flags;
 }
 
 /*
@@ -2813,7 +2814,7 @@ bool dl_param_changed(struct task_struct *p, const struct sched_attr *attr)
 	if (dl_se->dl_runtime != attr->sched_runtime ||
 	    dl_se->dl_deadline != attr->sched_deadline ||
 	    dl_se->dl_period != attr->sched_period ||
-	    dl_se->flags != attr->sched_flags)
+	    dl_se->flags != (attr->sched_flags & SCHED_DL_FLAGS))
 		return true;
 
 	return false;
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 39112ac7ab34..08db8e095e48 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -226,6 +226,8 @@ static inline void update_avg(u64 *avg, u64 sample)
  */
 #define SCHED_FLAG_SUGOV	0x10000000
 
+#define SCHED_DL_FLAGS (SCHED_FLAG_RECLAIM | SCHED_FLAG_DL_OVERRUN | SCHED_FLAG_SUGOV)
+
 static inline bool dl_entity_is_special(struct sched_dl_entity *dl_se)
 {
 #ifdef CONFIG_CPU_FREQ_GOV_SCHEDUTIL
-- 
2.30.2

