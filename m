Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E90A2223A42
	for <lists+stable@lfdr.de>; Fri, 17 Jul 2020 13:21:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725950AbgGQLV6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Jul 2020 07:21:58 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:40062 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725912AbgGQLV6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Jul 2020 07:21:58 -0400
Date:   Fri, 17 Jul 2020 11:21:54 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1594984915;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2N7cl9Uv5C2BfTmcs6AcgRYir7yXNppoUxiGa6sKO0s=;
        b=pHFLMjCZfl8dEb9NJli+wvKsWOyJCm4uv+kwgNehGo494JrWm7LkJaMxkUnkSUcxRmGIIB
        JFntO7z87LrNyfSAAx8PgSVrOv48yyZPg6ppZfnLm/4CJcvgn6fkBsyzHbd2NfeVC5U+rx
        zyBCn0jK7Yao+8CfaPF0+0sQtNEFzFpw0gam9UkEkwmEbFbR56JmT0Zc9tc+yJZZ3S00Ou
        fSmzhH30Yg1TW8xccuf/mFopvSGDpVX5mQHI7mxYzZsW71sk3DTNxuSOQygPNjvkOrmLkB
        e6j3JQIo7ICRPonWYMYurHcA0CCIwA2Loh8wywrcusMQEhA0dZ3WzaUgOn0QtA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1594984915;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2N7cl9Uv5C2BfTmcs6AcgRYir7yXNppoUxiGa6sKO0s=;
        b=9SuBPK/vnOVHz/2gDXbIDl6CQbKZN0lMQ2VhrQHRA7+m65L5VQJolm6Ok2iM6aV88RZSN/
        8ui1Oa/N0rtU8sDA==
From:   "tip-bot2 for Vincent Guittot" <tip-bot2@linutronix.de>
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: sched/urgent] sched/fair: handle case of task_h_load() returning 0
Cc:     Vincent Guittot <vincent.guittot@linaro.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Valentin Schneider <valentin.schneider@arm.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        <stable@vger.kernel.org>, x86 <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20200710152426.16981-1-vincent.guittot@linaro.org>
References: <20200710152426.16981-1-vincent.guittot@linaro.org>
MIME-Version: 1.0
Message-ID: <159498491467.4006.8575391976004781075.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2.linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the sched/urgent branch of tip:

Commit-ID:     01cfcde9c26d8555f0e6e9aea9d6049f87683998
Gitweb:        https://git.kernel.org/tip/01cfcde9c26d8555f0e6e9aea9d6049f87683998
Author:        Vincent Guittot <vincent.guittot@linaro.org>
AuthorDate:    Fri, 10 Jul 2020 17:24:26 +02:00
Committer:     Peter Zijlstra <peterz@infradead.org>
CommitterDate: Thu, 16 Jul 2020 23:19:48 +02:00

sched/fair: handle case of task_h_load() returning 0

task_h_load() can return 0 in some situations like running stress-ng
mmapfork, which forks thousands of threads, in a sched group on a 224 cores
system. The load balance doesn't handle this correctly because
env->imbalance never decreases and it will stop pulling tasks only after
reaching loop_max, which can be equal to the number of running tasks of
the cfs. Make sure that imbalance will be decreased by at least 1.

misfit task is the other feature that doesn't handle correctly such
situation although it's probably more difficult to face the problem
because of the smaller number of CPUs and running tasks on heterogenous
system.

We can't simply ensure that task_h_load() returns at least one because it
would imply to handle underflow in other places.

Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Valentin Schneider <valentin.schneider@arm.com>
Reviewed-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
Tested-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: <stable@vger.kernel.org> # v4.4+
Link: https://lkml.kernel.org/r/20200710152426.16981-1-vincent.guittot@linaro.org
---
 kernel/sched/fair.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 658aa7a..04fa8db 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4039,7 +4039,11 @@ static inline void update_misfit_status(struct task_struct *p, struct rq *rq)
 		return;
 	}
 
-	rq->misfit_task_load = task_h_load(p);
+	/*
+	 * Make sure that misfit_task_load will not be null even if
+	 * task_h_load() returns 0.
+	 */
+	rq->misfit_task_load = max_t(unsigned long, task_h_load(p), 1);
 }
 
 #else /* CONFIG_SMP */
@@ -7638,7 +7642,14 @@ static int detach_tasks(struct lb_env *env)
 
 		switch (env->migration_type) {
 		case migrate_load:
-			load = task_h_load(p);
+			/*
+			 * Depending of the number of CPUs and tasks and the
+			 * cgroup hierarchy, task_h_load() can return a null
+			 * value. Make sure that env->imbalance decreases
+			 * otherwise detach_tasks() will stop only after
+			 * detaching up to loop_max tasks.
+			 */
+			load = max_t(unsigned long, task_h_load(p), 1);
 
 			if (sched_feat(LB_MIN) &&
 			    load < 16 && !env->sd->nr_balance_failed)
