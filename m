Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B847F323CFC
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 14:06:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234399AbhBXNB0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Feb 2021 08:01:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:50916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235286AbhBXMzx (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Feb 2021 07:55:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6E35E64F3A;
        Wed, 24 Feb 2021 12:51:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614171111;
        bh=zu8QBW8b5xawBmPTL8xyu74N9hcmZjtyUEDgUX5e0bY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lSiltEexOXE4eFS1ByA9ZzbeNmRQ66HuH8gE1CPBJ0aN/KPHMLlxzTnhDW0QZvJZj
         O4P8b6ogGf4nv/B1Jmfonp7LOvvjsb5SFqArvX3g1oqwmnTdWA2+fh4sNxPv2nkGgD
         ZzgGsozk3mW/hYZ8jyS/x/QiHuzqiJnrRJ9vf4o5qMdWL+cefE7XK8YVZikvDKGfMM
         YyQf7qPyvyJEemF9sx4qa80JCYMyyFqgPjfuNkaBP3pQxFH1oMcIUnhh5lPZfiS0VP
         lSQj0C7YXfUVYS+1emYML+ud3t9KBReHFXP1BnO7m6VCk46Bukj36iPV7i7L02UyvT
         ZPFKOSSQt+w+Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Juri Lelli <juri.lelli@redhat.com>,
        "Luis Claudio R . Goncalves" <lgoncalv@redhat.com>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.11 63/67] sched/features: Fix hrtick reprogramming
Date:   Wed, 24 Feb 2021 07:50:21 -0500
Message-Id: <20210224125026.481804-63-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210224125026.481804-1-sashal@kernel.org>
References: <20210224125026.481804-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Juri Lelli <juri.lelli@redhat.com>

[ Upstream commit 156ec6f42b8d300dbbf382738ff35c8bad8f4c3a ]

Hung tasks and RCU stall cases were reported on systems which were not
100% busy. Investigation of such unexpected cases (no sign of potential
starvation caused by tasks hogging the system) pointed out that the
periodic sched tick timer wasn't serviced anymore after a certain point
and that caused all machinery that depends on it (timers, RCU, etc.) to
stop working as well. This issues was however only reproducible if
HRTICK was enabled.

Looking at core dumps it was found that the rbtree of the hrtimer base
used also for the hrtick was corrupted (i.e. next as seen from the base
root and actual leftmost obtained by traversing the tree are different).
Same base is also used for periodic tick hrtimer, which might get "lost"
if the rbtree gets corrupted.

Much alike what described in commit 1f71addd34f4c ("tick/sched: Do not
mess with an enqueued hrtimer") there is a race window between
hrtimer_set_expires() in hrtick_start and hrtimer_start_expires() in
__hrtick_restart() in which the former might be operating on an already
queued hrtick hrtimer, which might lead to corruption of the base.

Use hrtick_start() (which removes the timer before enqueuing it back) to
ensure hrtick hrtimer reprogramming is entirely guarded by the base
lock, so that no race conditions can occur.

Signed-off-by: Juri Lelli <juri.lelli@redhat.com>
Signed-off-by: Luis Claudio R. Goncalves <lgoncalv@redhat.com>
Signed-off-by: Daniel Bristot de Oliveira <bristot@redhat.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://lkml.kernel.org/r/20210208073554.14629-2-juri.lelli@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/core.c  | 8 +++-----
 kernel/sched/sched.h | 1 +
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 22f6748c16f68..fa1f83083a58b 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -355,8 +355,9 @@ static enum hrtimer_restart hrtick(struct hrtimer *timer)
 static void __hrtick_restart(struct rq *rq)
 {
 	struct hrtimer *timer = &rq->hrtick_timer;
+	ktime_t time = rq->hrtick_time;
 
-	hrtimer_start_expires(timer, HRTIMER_MODE_ABS_PINNED_HARD);
+	hrtimer_start(timer, time, HRTIMER_MODE_ABS_PINNED_HARD);
 }
 
 /*
@@ -380,7 +381,6 @@ static void __hrtick_start(void *arg)
 void hrtick_start(struct rq *rq, u64 delay)
 {
 	struct hrtimer *timer = &rq->hrtick_timer;
-	ktime_t time;
 	s64 delta;
 
 	/*
@@ -388,9 +388,7 @@ void hrtick_start(struct rq *rq, u64 delay)
 	 * doesn't make sense and can cause timer DoS.
 	 */
 	delta = max_t(s64, delay, 10000LL);
-	time = ktime_add_ns(timer->base->get_time(), delta);
-
-	hrtimer_set_expires(timer, time);
+	rq->hrtick_time = ktime_add_ns(timer->base->get_time(), delta);
 
 	if (rq == this_rq())
 		__hrtick_restart(rq);
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index bb09988451a04..282a6bbaacd73 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1031,6 +1031,7 @@ struct rq {
 	call_single_data_t	hrtick_csd;
 #endif
 	struct hrtimer		hrtick_timer;
+	ktime_t 		hrtick_time;
 #endif
 
 #ifdef CONFIG_SCHEDSTATS
-- 
2.27.0

