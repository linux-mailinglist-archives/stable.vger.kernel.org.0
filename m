Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4588933BA8D
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:11:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234980AbhCOOJh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:09:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:51650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234530AbhCOOEM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:04:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 521B8600EF;
        Mon, 15 Mar 2021 14:04:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615817051;
        bh=r2UAjOeMn+72T6EI3NXNl9nT+pi26cLFPqm9+jlfKg0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zW9GCTYvXA3ZUoiJsOXj3IyYh22pntxPWLey/s+sA+iN4oCUyCMZtGS+Jc1BF0cOF
         D5qLgobap3y5UbGvNY04stY849WReHbJqdynmkL1Q+93PDpC0f6E+EnRBiZ3faRbwW
         eTSbiwhVy2XjWYzoxyTMEkZZwfnmGbfWAqEkIx9c=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nadav Amit <nadav.amit@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 5.10 263/290] sched/membarrier: fix missing local execution of ipi_sync_rq_state()
Date:   Mon, 15 Mar 2021 14:55:56 +0100
Message-Id: <20210315135550.905336188@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135541.921894249@linuxfoundation.org>
References: <20210315135541.921894249@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

commit ce29ddc47b91f97e7f69a0fb7cbb5845f52a9825 upstream.

The function sync_runqueues_membarrier_state() should copy the
membarrier state from the @mm received as parameter to each runqueue
currently running tasks using that mm.

However, the use of smp_call_function_many() skips the current runqueue,
which is unintended. Replace by a call to on_each_cpu_mask().

Fixes: 227a4aadc75b ("sched/membarrier: Fix p->mm->membarrier_state racy load")
Reported-by: Nadav Amit <nadav.amit@gmail.com>
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: stable@vger.kernel.org # 5.4.x+
Link: https://lore.kernel.org/r/74F1E842-4A84-47BF-B6C2-5407DFDD4A4A@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/membarrier.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/kernel/sched/membarrier.c
+++ b/kernel/sched/membarrier.c
@@ -332,9 +332,7 @@ static int sync_runqueues_membarrier_sta
 	}
 	rcu_read_unlock();
 
-	preempt_disable();
-	smp_call_function_many(tmpmask, ipi_sync_rq_state, mm, 1);
-	preempt_enable();
+	on_each_cpu_mask(tmpmask, ipi_sync_rq_state, mm, true);
 
 	free_cpumask_var(tmpmask);
 	cpus_read_unlock();


