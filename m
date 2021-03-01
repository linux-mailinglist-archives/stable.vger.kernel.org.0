Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B028327BBE
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 11:17:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232568AbhCAKRH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 05:17:07 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:58274 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232276AbhCAKQ7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 05:16:59 -0500
Date:   Mon, 01 Mar 2021 10:16:15 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1614593776;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+hz1wJcLAYNHFJgzU3OU4jiBvPybuLQJlRGaQTUJ23g=;
        b=uAOIvn1P7krq0205V1nX7suykKQS4Cln5SFE4hv6oNdXuy6DWUEmsYO7kbKhmN1UihoSTa
        GuA7MDPr4/gDpcAXQa6RsoPTUhgol0wQdtp79XbpKyhwg7cznm7GWiCN7giVxXpeKqCQSm
        PHlMiRWUtHWWpVCD521AedF+PCKG83csZfeyZPN0pThtSJduIpFAGJgdi8R7m++1G3VeXK
        bcnV+HCLdbH30BxtK+XO6eBfYMSxoqifKDvi4FvidMCmiwUFc4jBSTSxI01WXap/soZ8uO
        zlONX3xrpVbQHhXKaV9BBsz093a0a1VHSI/YHWT61LWjumyaPyRWR+H3jPslfA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1614593776;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+hz1wJcLAYNHFJgzU3OU4jiBvPybuLQJlRGaQTUJ23g=;
        b=m8rkJla7zB6AghKSbruGpjFvQQmT/E1maQ52Oo0BzfH+D02QllbGekzrjLcgpYI13Np8NG
        CEQsu3bY6jxZFWCg==
From:   "tip-bot2 for Mathieu Desnoyers" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: sched/urgent] sched/membarrier: fix missing local execution of
 ipi_sync_rq_state()
Cc:     Nadav Amit <nadav.amit@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        stable@vger.kernel.org, #@tip-bot2.tec.linutronix.de,
        5.4.x+@tip-bot2.tec.linutronix.de, x86@kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <74F1E842-4A84-47BF-B6C2-5407DFDD4A4A@gmail.com>
References: <74F1E842-4A84-47BF-B6C2-5407DFDD4A4A@gmail.com>
MIME-Version: 1.0
Message-ID: <161459377595.20312.5845647845735679377.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the sched/urgent branch of tip:

Commit-ID:     fba111913e51a934eaad85734254eab801343836
Gitweb:        https://git.kernel.org/tip/fba111913e51a934eaad85734254eab801343836
Author:        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
AuthorDate:    Wed, 17 Feb 2021 11:56:51 -05:00
Committer:     Peter Zijlstra <peterz@infradead.org>
CommitterDate: Mon, 01 Mar 2021 11:02:15 +01:00

sched/membarrier: fix missing local execution of ipi_sync_rq_state()

The function sync_runqueues_membarrier_state() should copy the
membarrier state from the @mm received as parameter to each runqueue
currently running tasks using that mm.

However, the use of smp_call_function_many() skips the current runqueue,
which is unintended. Replace by a call to on_each_cpu_mask().

Fixes: 227a4aadc75b ("sched/membarrier: Fix p->mm->membarrier_state racy load")
Reported-by: Nadav Amit <nadav.amit@gmail.com>
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org # 5.4.x+
Link: https://lore.kernel.org/r/74F1E842-4A84-47BF-B6C2-5407DFDD4A4A@gmail.com
---
 kernel/sched/membarrier.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/kernel/sched/membarrier.c b/kernel/sched/membarrier.c
index acdae62..b5add64 100644
--- a/kernel/sched/membarrier.c
+++ b/kernel/sched/membarrier.c
@@ -471,9 +471,7 @@ static int sync_runqueues_membarrier_state(struct mm_struct *mm)
 	}
 	rcu_read_unlock();
 
-	preempt_disable();
-	smp_call_function_many(tmpmask, ipi_sync_rq_state, mm, 1);
-	preempt_enable();
+	on_each_cpu_mask(tmpmask, ipi_sync_rq_state, mm, true);
 
 	free_cpumask_var(tmpmask);
 	cpus_read_unlock();
