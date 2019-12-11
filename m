Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AABD011B78A
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 17:09:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731080AbfLKQIc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 11:08:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:33480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730717AbfLKPMP (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:12:15 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2142A24658;
        Wed, 11 Dec 2019 15:12:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077134;
        bh=NqacZIeY751Sk6P9cZCPH3F55m9l65RSJBYodqLMxuc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YJoNaUjoNpLlRuIXUuAJsWLZ66tumSy9mDGwhZCyngo4KUrP7xRelydL/+dfAK+f8
         B0GZ2sw7rU2NIZDTDOA4A+ibwW1GhDMwznpnbdf5NbA74LK0tSXy766hEXAO9NkDVD
         j3RbCQEpCVGfPYjVEyXXiDpSKY1lxDdrJweZaJIs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Qian Cai <cai@lca.pw>, Thomas Gleixner <tglx@linutronix.de>,
        akpm@linux-foundation.org, bigeasy@linutronix.de, cl@linux.com,
        keescook@chromium.org, penberg@kernel.org, rientjes@google.com,
        thgarnie@google.com, tytso@mit.edu, will@kernel.org,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 029/105] sched/core: Avoid spurious lock dependencies
Date:   Wed, 11 Dec 2019 16:05:18 +0100
Message-Id: <20191211150230.036214995@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150221.153659747@linuxfoundation.org>
References: <20191211150221.153659747@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit ff51ff84d82aea5a889b85f2b9fb3aa2b8691668 ]

While seemingly harmless, __sched_fork() does hrtimer_init(), which,
when DEBUG_OBJETS, can end up doing allocations.

This then results in the following lock order:

  rq->lock
    zone->lock.rlock
      batched_entropy_u64.lock

Which in turn causes deadlocks when we do wakeups while holding that
batched_entropy lock -- as the random code does.

Solve this by moving __sched_fork() out from under rq->lock. This is
safe because nothing there relies on rq->lock, as also evident from the
other __sched_fork() callsite.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Qian Cai <cai@lca.pw>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: akpm@linux-foundation.org
Cc: bigeasy@linutronix.de
Cc: cl@linux.com
Cc: keescook@chromium.org
Cc: penberg@kernel.org
Cc: rientjes@google.com
Cc: thgarnie@google.com
Cc: tytso@mit.edu
Cc: will@kernel.org
Fixes: b7d5dc21072c ("random: add a spinlock_t to struct batched_entropy")
Link: https://lkml.kernel.org/r/20191001091837.GK4536@hirez.programming.kicks-ass.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index fffe790d98bb2..9a839798851c2 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5874,10 +5874,11 @@ void init_idle(struct task_struct *idle, int cpu)
 	struct rq *rq = cpu_rq(cpu);
 	unsigned long flags;
 
+	__sched_fork(0, idle);
+
 	raw_spin_lock_irqsave(&idle->pi_lock, flags);
 	raw_spin_lock(&rq->lock);
 
-	__sched_fork(0, idle);
 	idle->state = TASK_RUNNING;
 	idle->se.exec_start = sched_clock();
 	idle->flags |= PF_IDLE;
-- 
2.20.1



