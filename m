Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9AFCFCA49F
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 18:33:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389997AbfJCQ0l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:26:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:57942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391100AbfJCQ0j (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:26:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F2BF720867;
        Thu,  3 Oct 2019 16:26:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570119998;
        bh=R6nvQTWWdY2hSuO8CYz1sdOi8H89MTYKjyyPSd3VUKY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WMIckvtJTvoR39oLsgJfRz/m18daZBrACFkN3C69ZAL8CDPo6hWErgKwWUdXfzenq
         l/D5dAges3CS0tcqXnUm5jCSj+77Sdk5plim2SSB5beDqv3k85JvViVZGBjfeZUpLe
         KYNgBQXArmF56cx5q0OC5xMC0yFBw0VcFKxDfh9k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, bristot@redhat.com,
        claudio@evidence.eu.com, lizefan@huawei.com, longman@redhat.com,
        luca.abeni@santannapisa.it, mathieu.poirier@linaro.org,
        rostedt@goodmis.org, tj@kernel.org,
        tommaso.cucinotta@santannapisa.it, Ingo Molnar <mingo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 059/313] rcu/tree: Call setschedule() gp ktread to SCHED_FIFO outside of atomic region
Date:   Thu,  3 Oct 2019 17:50:37 +0200
Message-Id: <20191003154538.830790877@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154533.590915454@linuxfoundation.org>
References: <20191003154533.590915454@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Juri Lelli <juri.lelli@redhat.com>

[ Upstream commit 1a763fd7c6335e3122c1cc09576ef6c99ada4267 ]

sched_setscheduler() needs to acquire cpuset_rwsem, but it is currently
called from an invalid (atomic) context by rcu_spawn_gp_kthread().

Fix that by simply moving sched_setscheduler_nocheck() call outside of
the atomic region, as it doesn't actually require to be guarded by
rcu_node lock.

Suggested-by: Peter Zijlstra <peterz@infradead.org>
Tested-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
Signed-off-by: Juri Lelli <juri.lelli@redhat.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: bristot@redhat.com
Cc: claudio@evidence.eu.com
Cc: lizefan@huawei.com
Cc: longman@redhat.com
Cc: luca.abeni@santannapisa.it
Cc: mathieu.poirier@linaro.org
Cc: rostedt@goodmis.org
Cc: tj@kernel.org
Cc: tommaso.cucinotta@santannapisa.it
Link: https://lkml.kernel.org/r/20190719140000.31694-8-juri.lelli@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/rcu/tree.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 980ca3ca643fb..32ea75acba144 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -3123,13 +3123,13 @@ static int __init rcu_spawn_gp_kthread(void)
 	t = kthread_create(rcu_gp_kthread, NULL, "%s", rcu_state.name);
 	if (WARN_ONCE(IS_ERR(t), "%s: Could not start grace-period kthread, OOM is now expected behavior\n", __func__))
 		return 0;
+	if (kthread_prio)
+		sched_setscheduler_nocheck(t, SCHED_FIFO, &sp);
 	rnp = rcu_get_root();
 	raw_spin_lock_irqsave_rcu_node(rnp, flags);
 	rcu_state.gp_kthread = t;
-	if (kthread_prio) {
+	if (kthread_prio)
 		sp.sched_priority = kthread_prio;
-		sched_setscheduler_nocheck(t, SCHED_FIFO, &sp);
-	}
 	raw_spin_unlock_irqrestore_rcu_node(rnp, flags);
 	wake_up_process(t);
 	rcu_spawn_nocb_kthreads();
-- 
2.20.1



