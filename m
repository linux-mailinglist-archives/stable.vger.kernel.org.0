Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5933B2266B6
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:05:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729172AbgGTQFd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:05:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:41132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728587AbgGTQFc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 12:05:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6A9382065E;
        Mon, 20 Jul 2020 16:05:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595261132;
        bh=BFkFJTDuBhrUoughrCS66pdZVgGgeSro+Mo6cklGwsg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0AA9nwr8cAOuI3pkrBgAaNDkOgnRVA28MnfIkxNDJa6RBVg9S0lJaSzXrVhYS1CNr
         tMoEvMjCszewOxSdeqIVn1Ua6ATLhbLDLRNDWQ44AtyHNRRTQgturCaJdtFid0FF/U
         hhDznntv9v3r/moXOiyS7R6dvaFY9xvyeoo+uHfo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Weimer <fweimer@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 5.4 202/215] sched: Fix unreliable rseq cpu_id for new tasks
Date:   Mon, 20 Jul 2020 17:38:04 +0200
Message-Id: <20200720152829.775097950@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152820.122442056@linuxfoundation.org>
References: <20200720152820.122442056@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

commit ce3614daabea8a2d01c1dd17ae41d1ec5e5ae7db upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/sched/core.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2889,6 +2889,7 @@ int sched_fork(unsigned long clone_flags
 	 * Silence PROVE_RCU.
 	 */
 	raw_spin_lock_irqsave(&p->pi_lock, flags);
+	rseq_migrate(p);
 	/*
 	 * We're setting the CPU for the first time, we don't migrate,
 	 * so use __set_task_cpu().
@@ -2953,6 +2954,7 @@ void wake_up_new_task(struct task_struct
 	 * as we're not fully set-up yet.
 	 */
 	p->recent_used_cpu = task_cpu(p);
+	rseq_migrate(p);
 	__set_task_cpu(p, select_task_rq(p, task_cpu(p), SD_BALANCE_FORK, 0));
 #endif
 	rq = __task_rq_lock(p, &rf);


