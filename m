Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4FB12C0939
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:17:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387592AbgKWNFS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 08:05:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:35282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387588AbgKWMud (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:50:33 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0006421534;
        Mon, 23 Nov 2020 12:50:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135828;
        bh=2/S5/5ujUmjXMubiZq8/HYV6HyrcOm5vFamNeArFYqw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZjqpzRKVPDRzW35+bp5C557L1IMUGuxJOtCKIIztTnUwkf0Y0ty5NO4VgxGenqLEF
         6uyYBoPzZ2wz5wWK7uU7DEWu2uJodG+JshYn9h3B712TyMQ0HKRmkKCyJD9z/JQ1At
         Zls2YVS03Bs/0zotHEzALz7xTfneFZO94IyzNgOg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mel Gorman <mgorman@techsingularity.net>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>, Will Deacon <will@kernel.org>
Subject: [PATCH 5.9 181/252] sched: Fix data-race in wakeup
Date:   Mon, 23 Nov 2020 13:22:11 +0100
Message-Id: <20201123121844.330555813@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121835.580259631@linuxfoundation.org>
References: <20201123121835.580259631@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit f97bb5272d9e95d400d6c8643ebb146b3e3e7842 ]

Mel reported that on some ARM64 platforms loadavg goes bananas and
Will tracked it down to the following race:

  CPU0					CPU1

  schedule()
    prev->sched_contributes_to_load = X;
    deactivate_task(prev);

					try_to_wake_up()
					  if (p->on_rq &&) // false
					  if (smp_load_acquire(&p->on_cpu) && // true
					      ttwu_queue_wakelist())
					        p->sched_remote_wakeup = Y;

    smp_store_release(prev->on_cpu, 0);

where both p->sched_contributes_to_load and p->sched_remote_wakeup are
in the same word, and thus the stores X and Y race (and can clobber
one another's data).

Whereas prior to commit c6e7bd7afaeb ("sched/core: Optimize ttwu()
spinning on p->on_cpu") the p->on_cpu handoff serialized access to
p->sched_remote_wakeup (just as it still does with
p->sched_contributes_to_load) that commit broke that by calling
ttwu_queue_wakelist() with p->on_cpu != 0.

However, due to

  p->XXX = X			ttwu()
  schedule()			  if (p->on_rq && ...) // false
    smp_mb__after_spinlock()	  if (smp_load_acquire(&p->on_cpu) &&
    deactivate_task()		      ttwu_queue_wakelist())
      p->on_rq = 0;		        p->sched_remote_wakeup = Y;

We can be sure any 'current' store is complete and 'current' is
guaranteed asleep. Therefore we can move p->sched_remote_wakeup into
the current flags word.

Note: while the observed failure was loadavg accounting gone wrong due
to ttwu() cobbering p->sched_contributes_to_load, the reverse problem
is also possible where schedule() clobbers p->sched_remote_wakeup,
this could result in enqueue_entity() wrecking ->vruntime and causing
scheduling artifacts.

Fixes: c6e7bd7afaeb ("sched/core: Optimize ttwu() spinning on p->on_cpu")
Reported-by: Mel Gorman <mgorman@techsingularity.net>
Debugged-by: Will Deacon <will@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20201117083016.GK3121392@hirez.programming.kicks-ass.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/sched.h | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 8bf2295ebee48..12aa57de8eea0 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -770,7 +770,6 @@ struct task_struct {
 	unsigned			sched_reset_on_fork:1;
 	unsigned			sched_contributes_to_load:1;
 	unsigned			sched_migrated:1;
-	unsigned			sched_remote_wakeup:1;
 #ifdef CONFIG_PSI
 	unsigned			sched_psi_wake_requeue:1;
 #endif
@@ -780,6 +779,21 @@ struct task_struct {
 
 	/* Unserialized, strictly 'current' */
 
+	/*
+	 * This field must not be in the scheduler word above due to wakelist
+	 * queueing no longer being serialized by p->on_cpu. However:
+	 *
+	 * p->XXX = X;			ttwu()
+	 * schedule()			  if (p->on_rq && ..) // false
+	 *   smp_mb__after_spinlock();	  if (smp_load_acquire(&p->on_cpu) && //true
+	 *   deactivate_task()		      ttwu_queue_wakelist())
+	 *     p->on_rq = 0;			p->sched_remote_wakeup = Y;
+	 *
+	 * guarantees all stores of 'current' are visible before
+	 * ->sched_remote_wakeup gets used, so it can be in this word.
+	 */
+	unsigned			sched_remote_wakeup:1;
+
 	/* Bit to tell LSMs we're in execve(): */
 	unsigned			in_execve:1;
 	unsigned			in_iowait:1;
-- 
2.27.0



