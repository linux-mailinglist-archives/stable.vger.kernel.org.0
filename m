Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFA3821841E
	for <lists+stable@lfdr.de>; Wed,  8 Jul 2020 11:46:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728447AbgGHJqQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jul 2020 05:46:16 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:47792 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726445AbgGHJqP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jul 2020 05:46:15 -0400
Date:   Wed, 08 Jul 2020 09:46:11 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1594201572;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=diJYgjtaYO5ivE+OT0+Yz2/Iul+eRtIpp4mpsKVZrP0=;
        b=0EzvjxA0TpIf9NJ5cXcn86b7Y2TPeWuyLeA0Ds3uuNe8dwQ/UmakyCs6nANy7AUw9hQ6nc
        Rux//gREIPcoma7zOnziAT/O19vkqgpnMZ5EY/FMjojGrZIi5d7XQbVQ+WOLZebOYHXSie
        VWsiccuw3Y8qp3jbOmLNmoFlI3u459K6sfTFRkfhYNSw+ruyCCdSg7F1QgG7RuUCjtPpsf
        qSiRfIE8cssVg5BD12ouiQWcZSU6TP5kq4Ym3yD6HQDTZo/5SJZknuhNZ7rNnVILcXU5AG
        N6gowdy4aDnCz2yZEWjny/OyQuK9InD+RznJ0+/wCBl7Gc0e4yS64qgMohQVCg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1594201572;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=diJYgjtaYO5ivE+OT0+Yz2/Iul+eRtIpp4mpsKVZrP0=;
        b=kpN1+7l8MgriG9q+5yc3MU46xjR/5inqZxVuDbkhMB9s4S0fFAE+sApU2Iheuh6/6NFaVB
        5Q+R6UpEqyLN5BCQ==
From:   "tip-bot2 for Mathieu Desnoyers" <tip-bot2@linutronix.de>
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: sched/urgent] sched: Fix unreliable rseq cpu_id for new tasks
Cc:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        stable@vger.kernel.org, #@tip-bot2.tec.linutronix.de,
        v4.18+@tip-bot2.tec.linutronix.de, x86 <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20200707201505.2632-1-mathieu.desnoyers@efficios.com>
References: <20200707201505.2632-1-mathieu.desnoyers@efficios.com>
MIME-Version: 1.0
Message-ID: <159420157146.4006.2039144692145212660.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2.linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the sched/urgent branch of tip:

Commit-ID:     ce3614daabea8a2d01c1dd17ae41d1ec5e5ae7db
Gitweb:        https://git.kernel.org/tip/ce3614daabea8a2d01c1dd17ae41d1ec5e5ae7db
Author:        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
AuthorDate:    Mon, 06 Jul 2020 16:49:10 -04:00
Committer:     Peter Zijlstra <peterz@infradead.org>
CommitterDate: Wed, 08 Jul 2020 11:38:50 +02:00

sched: Fix unreliable rseq cpu_id for new tasks

While integrating rseq into glibc and replacing glibc's sched_getcpu
implementation with rseq, glibc's tests discovered an issue with
incorrect __rseq_abi.cpu_id field value right after the first time
a newly created process issues sched_setaffinity.

For the records, it triggers after building glibc and running tests, and
then issuing:

  for x in {1..2000} ; do posix/tst-affinity-static  & done

and shows up as:

error: Unexpected CPU 2, expected 0
error: Unexpected CPU 2, expected 0
error: Unexpected CPU 2, expected 0
error: Unexpected CPU 2, expected 0
error: Unexpected CPU 138, expected 0
error: Unexpected CPU 138, expected 0
error: Unexpected CPU 138, expected 0
error: Unexpected CPU 138, expected 0

This is caused by the scheduler invoking __set_task_cpu() directly from
sched_fork() and wake_up_new_task(), thus bypassing rseq_migrate() which
is done by set_task_cpu().

Add the missing rseq_migrate() to both functions. The only other direct
use of __set_task_cpu() is done by init_idle(), which does not involve a
user-space task.

Based on my testing with the glibc test-case, just adding rseq_migrate()
to wake_up_new_task() is sufficient to fix the observed issue. Also add
it to sched_fork() to keep things consistent.

The reason why this never triggered so far with the rseq/basic_test
selftest is unclear.

The current use of sched_getcpu(3) does not typically require it to be
always accurate. However, use of the __rseq_abi.cpu_id field within rseq
critical sections requires it to be accurate. If it is not accurate, it
can cause corruption in the per-cpu data targeted by rseq critical
sections in user-space.

Reported-By: Florian Weimer <fweimer@redhat.com>
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Tested-By: Florian Weimer <fweimer@redhat.com>
Cc: stable@vger.kernel.org # v4.18+
Link: https://lkml.kernel.org/r/20200707201505.2632-1-mathieu.desnoyers@efficios.com
---
 kernel/sched/core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 950ac45..e15543c 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2965,6 +2965,7 @@ int sched_fork(unsigned long clone_flags, struct task_struct *p)
 	 * Silence PROVE_RCU.
 	 */
 	raw_spin_lock_irqsave(&p->pi_lock, flags);
+	rseq_migrate(p);
 	/*
 	 * We're setting the CPU for the first time, we don't migrate,
 	 * so use __set_task_cpu().
@@ -3029,6 +3030,7 @@ void wake_up_new_task(struct task_struct *p)
 	 * as we're not fully set-up yet.
 	 */
 	p->recent_used_cpu = task_cpu(p);
+	rseq_migrate(p);
 	__set_task_cpu(p, select_task_rq(p, task_cpu(p), SD_BALANCE_FORK, 0));
 #endif
 	rq = __task_rq_lock(p, &rf);
