Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87EEB31DDBF
	for <lists+stable@lfdr.de>; Wed, 17 Feb 2021 17:58:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234055AbhBQQ5m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Feb 2021 11:57:42 -0500
Received: from mail.efficios.com ([167.114.26.124]:34222 "EHLO
        mail.efficios.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234250AbhBQQ5m (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Feb 2021 11:57:42 -0500
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id E2274322BB8;
        Wed, 17 Feb 2021 11:57:00 -0500 (EST)
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id mqr31whuHTGD; Wed, 17 Feb 2021 11:57:00 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id A8BD3322BB6;
        Wed, 17 Feb 2021 11:57:00 -0500 (EST)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com A8BD3322BB6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1613581020;
        bh=kigdUxiPvpka0QmDVy5m4ZaMBHNoNv4lCfBcLZhrnbc=;
        h=From:To:Date:Message-Id;
        b=pP9PC1t6+zXT8kUnP4zXPEMAqiT9OD19vQBQPuiYtAIs+8+7AUThmXakXSK3eo5JL
         TouAMHjwnntc8fv4XoLc3Ax5FMATPrPqbIc7uoJFVL47q+ajbjK/aMZg9x5mR6NnCA
         S8vHzXKZFKfORiqPKDBPY+7ZWKtIJTQzFxkYKEF+0+6AvpP0k9BPDl5o2Srk1n5zUd
         fJ6XJlsArXbh0GrZIau7QhBDfbLP3OjLM1ofs37G/xBQsMZ+lAK7jDT2+aWGj/sP49
         ChTzZFlBcXOvx7q0e8QKeKkPRceghDDu6/vuawUQgqMoi3x2qA5X0rVxoXTRgCZ4rD
         4ohsNrQ5yKKoA==
X-Virus-Scanned: amavisd-new at efficios.com
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 1ZjRzeLgU6cW; Wed, 17 Feb 2021 11:57:00 -0500 (EST)
Received: from localhost.localdomain (192-222-181-218.qc.cable.ebox.net [192.222.181.218])
        by mail.efficios.com (Postfix) with ESMTPSA id 80E7D322972;
        Wed, 17 Feb 2021 11:57:00 -0500 (EST)
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     linux-kernel@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Nadav Amit <nadav.amit@gmail.com>, stable@vger.kernel.org
Subject: [PATCH] sched/membarrier: fix missing local execution of ipi_sync_rq_state()
Date:   Wed, 17 Feb 2021 11:56:51 -0500
Message-Id: <20210217165651.8563-1-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The function sync_runqueues_membarrier_state() should copy the
membarrier state from the @mm received as parameter to each runqueue
currently running tasks using that mm.

However, the use of smp_call_function_many() skips the current runqueue,
which is unintended. Replace by a call to on_each_cpu_mask().

Fixes: 227a4aadc75b ("sched/membarrier: Fix p->mm->membarrier_state racy load")
Link: https://lore.kernel.org/r/74F1E842-4A84-47BF-B6C2-5407DFDD4A4A@gmail.com
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Reported-by: Nadav Amit <nadav.amit@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Nadav Amit <nadav.amit@gmail.com>
Cc: stable@vger.kernel.org # 5.4.x+
---
 kernel/sched/membarrier.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/kernel/sched/membarrier.c b/kernel/sched/membarrier.c
index 08ae45ad9261..f311bf85d211 100644
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
-- 
2.17.1

