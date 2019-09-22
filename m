Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 394B8BA66E
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 21:46:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729125AbfIVSua (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 14:50:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:47576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403936AbfIVSu2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Sep 2019 14:50:28 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 262BC21A4A;
        Sun, 22 Sep 2019 18:50:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569178228;
        bh=R6nvQTWWdY2hSuO8CYz1sdOi8H89MTYKjyyPSd3VUKY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GYDir0UkR1g6sDkEkAJT/BsqDs80NhACd+VDFiCy+VCPGVwTCC/lFMTNkfmXSqvc9
         yrKuaCymzIrgJuAk3BUQjRKZMeAW2KjcHv+UUWRzZi/4mG/81ouDt5VLJ8NpSp6Uu1
         4Ms9rcSH4TtUjEv9XRoBbLowEeRsQoqdCYARYFuU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Juri Lelli <juri.lelli@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, bristot@redhat.com,
        claudio@evidence.eu.com, lizefan@huawei.com, longman@redhat.com,
        luca.abeni@santannapisa.it, mathieu.poirier@linaro.org,
        rostedt@goodmis.org, tj@kernel.org,
        tommaso.cucinotta@santannapisa.it, Ingo Molnar <mingo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.2 027/185] rcu/tree: Call setschedule() gp ktread to SCHED_FIFO outside of atomic region
Date:   Sun, 22 Sep 2019 14:46:45 -0400
Message-Id: <20190922184924.32534-27-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190922184924.32534-1-sashal@kernel.org>
References: <20190922184924.32534-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

