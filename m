Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 971F3323D91
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 14:18:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234724AbhBXNN0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Feb 2021 08:13:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:55442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235374AbhBXNCV (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Feb 2021 08:02:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F1CAA64F08;
        Wed, 24 Feb 2021 12:53:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614171201;
        bh=Htf3q0yZmf4S90LxsL8xm1T6DsbCQIixfK5DT96a4Gs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EyGTplq1UjrLM6n1jAqeam1E9PUJgYXk28pp/0MkMyltE2ncKEdN3VX25uZ/T99Tv
         fPzf2lOyVWJ9+7cR0udGuexEk2DrF1qcndE7hBWs+gudsIobAYIx6mApIBZ87kf4CQ
         ZBRRp3k8O0gVoaALRnBAJX8lb+rUJ+rY/rPe/8XSjsSKnG5wpbxKGPYxWYmUAxycMa
         VdGNaGZ2eEbGTFZ2cbBv4N9YRdhBaTTvAj1f10sqJWgPqEHNIppxz0gZ0wQ4GsVz9g
         dgeFU9pwhnxA4ThZB3V6FkuhAhOhQsHnd2HqpCNfE/R+to1Px5/E6w/UbPEB3qOqyP
         l4BlUvHkJF7sg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Juri Lelli <juri.lelli@redhat.com>,
        "Luis Claudio R . Goncalves" <lgoncalv@redhat.com>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.10 52/56] sched/features: Fix hrtick reprogramming
Date:   Wed, 24 Feb 2021 07:52:08 -0500
Message-Id: <20210224125212.482485-52-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210224125212.482485-1-sashal@kernel.org>
References: <20210224125212.482485-1-sashal@kernel.org>
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
index 269165bf440af..3a150445e0cba 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -363,8 +363,9 @@ static enum hrtimer_restart hrtick(struct hrtimer *timer)
 static void __hrtick_restart(struct rq *rq)
 {
 	struct hrtimer *timer = &rq->hrtick_timer;
+	ktime_t time = rq->hrtick_time;
 
-	hrtimer_start_expires(timer, HRTIMER_MODE_ABS_PINNED_HARD);
+	hrtimer_start(timer, time, HRTIMER_MODE_ABS_PINNED_HARD);
 }
 
 /*
@@ -388,7 +389,6 @@ static void __hrtick_start(void *arg)
 void hrtick_start(struct rq *rq, u64 delay)
 {
 	struct hrtimer *timer = &rq->hrtick_timer;
-	ktime_t time;
 	s64 delta;
 
 	/*
@@ -396,9 +396,7 @@ void hrtick_start(struct rq *rq, u64 delay)
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
index c122176c627ec..fac1b121d1130 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1018,6 +1018,7 @@ struct rq {
 	call_single_data_t	hrtick_csd;
 #endif
 	struct hrtimer		hrtick_timer;
+	ktime_t 		hrtick_time;
 #endif
 
 #ifdef CONFIG_SCHEDSTATS
-- 
2.27.0

