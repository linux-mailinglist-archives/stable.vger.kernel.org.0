Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B91A521608A
	for <lists+stable@lfdr.de>; Mon,  6 Jul 2020 22:50:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726924AbgGFUto (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jul 2020 16:49:44 -0400
Received: from mail.efficios.com ([167.114.26.124]:56976 "EHLO
        mail.efficios.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725860AbgGFUto (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jul 2020 16:49:44 -0400
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id D62442DC9D7;
        Mon,  6 Jul 2020 16:49:42 -0400 (EDT)
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id N1qno2Dkpjte; Mon,  6 Jul 2020 16:49:42 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id 683412DCE21;
        Mon,  6 Jul 2020 16:49:42 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com 683412DCE21
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1594068582;
        bh=60oamRalyK4rKdeEnnnf7iJkqPhAmdQusJlFI420q5k=;
        h=From:To:Date:Message-Id;
        b=H42dMuI5Nu/42J0bhGwrdNKkl/BwhzMsRr7OMCof2YOn/ozdaaEj8d8zub60PFxxy
         rejoJYMu3dy+5MUMT7l9AqtpLdv/36KYGIR5RSUnV0FIJCu1GXbq/H9iSWw5Khigpk
         sfCbjmRYMyuaI845IwKEXcTbhWevMkj0i26TcDhTLgr4HTe4g41cxcqVgRFGh1jXL2
         9ka6ugCXOgLXblzQ0rsar4RxAKkKjqJU7Frchk2t1e6HCJtx66sDg4zEMOyQZpS1Zs
         BWVe6FUw22uqU/PHV9Jn8NjePdFQGljsuN8Bg6iYjm8Uo9eWwov7g4rnzq4M7A6J9s
         VePDhtDoIDrpg==
X-Virus-Scanned: amavisd-new at efficios.com
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id EBR4AzEQUwCz; Mon,  6 Jul 2020 16:49:42 -0400 (EDT)
Received: from localhost.localdomain (192-222-181-218.qc.cable.ebox.net [192.222.181.218])
        by mail.efficios.com (Postfix) with ESMTPSA id 1C5D52DCDA4;
        Mon,  6 Jul 2020 16:49:41 -0400 (EDT)
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        "Paul E . McKenney" <paulmck@linux.ibm.com>,
        Boqun Feng <boqun.feng@gmail.com>,
        "H . Peter Anvin" <hpa@zytor.com>, Paul Turner <pjt@google.com>,
        linux-api@vger.kernel.org, Florian Weimer <fw@deneb.enyo.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Neel Natu <neelnatu@google.com>, stable@vger.kernel.org
Subject: [RFC PATCH for 5.8 1/4] sched: Fix unreliable rseq cpu_id for new tasks
Date:   Mon,  6 Jul 2020 16:49:10 -0400
Message-Id: <20200706204913.20347-2-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200706204913.20347-1-mathieu.desnoyers@efficios.com>
References: <20200706204913.20347-1-mathieu.desnoyers@efficios.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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

Link: https://sourceware.org/pipermail/libc-alpha/2020-July/115816.html
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Florian Weimer <fw@deneb.enyo.de>
Cc: "Paul E. McKenney" <paulmck@linux.ibm.com>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: "H . Peter Anvin" <hpa@zytor.com>
Cc: Paul Turner <pjt@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Neel Natu <neelnatu@google.com>
Cc: linux-api@vger.kernel.org
Cc: stable@vger.kernel.org # v4.18+
---
 kernel/sched/core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index ca5db40392d4..86a855bd4d90 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2962,6 +2962,7 @@ int sched_fork(unsigned long clone_flags, struct task_struct *p)
 	 * Silence PROVE_RCU.
 	 */
 	raw_spin_lock_irqsave(&p->pi_lock, flags);
+	rseq_migrate(p);
 	/*
 	 * We're setting the CPU for the first time, we don't migrate,
 	 * so use __set_task_cpu().
@@ -3026,6 +3027,7 @@ void wake_up_new_task(struct task_struct *p)
 	 * as we're not fully set-up yet.
 	 */
 	p->recent_used_cpu = task_cpu(p);
+	rseq_migrate(p);
 	__set_task_cpu(p, select_task_rq(p, task_cpu(p), SD_BALANCE_FORK, 0));
 #endif
 	rq = __task_rq_lock(p, &rf);
-- 
2.17.1

