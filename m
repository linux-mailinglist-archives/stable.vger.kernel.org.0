Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 081963DD7C2
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 15:48:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234109AbhHBNsI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 09:48:08 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:16033 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234358AbhHBNrg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Aug 2021 09:47:36 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4GdfNb1kVWzZwdR;
        Mon,  2 Aug 2021 21:43:43 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 2 Aug 2021 21:47:15 +0800
Received: from thunder-town.china.huawei.com (10.174.179.0) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 2 Aug 2021 21:47:14 +0800
From:   Zhen Lei <thunder.leizhen@huawei.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable <stable@vger.kernel.org>
CC:     Zhen Lei <thunder.leizhen@huawei.com>,
        Anna-Maria Gleixner <anna-maria@linutronix.de>,
        Mike Galbraith <efault@gmx.de>,
        Sasha Levin <sasha.levin@oracle.com>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 4.4 06/11] futex: Futex_unlock_pi() determinism
Date:   Mon, 2 Aug 2021 21:46:19 +0800
Message-ID: <20210802134624.1934-7-thunder.leizhen@huawei.com>
X-Mailer: git-send-email 2.26.0.windows.1
In-Reply-To: <20210802134624.1934-1-thunder.leizhen@huawei.com>
References: <20210802134624.1934-1-thunder.leizhen@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.174.179.0]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpemm500006.china.huawei.com (7.185.36.236)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit bebe5b514345f09be2c15e414d076b02ecb9cce8 ]

The problem with returning -EAGAIN when the waiter state mismatches is that
it becomes very hard to proof a bounded execution time on the
operation. And seeing that this is a RT operation, this is somewhat
important.

While in practise; given the previous patch; it will be very unlikely to
ever really take more than one or two rounds, proving so becomes rather
hard.

However, now that modifying wait_list is done while holding both hb->lock
and wait_lock, the scenario can be avoided entirely by acquiring wait_lock
while still holding hb-lock. Doing a hand-over, without leaving a hole.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: juri.lelli@arm.com
Cc: bigeasy@linutronix.de
Cc: xlpang@redhat.com
Cc: rostedt@goodmis.org
Cc: mathieu.desnoyers@efficios.com
Cc: jdesfossez@efficios.com
Cc: dvhart@infradead.org
Cc: bristot@redhat.com
Link: http://lkml.kernel.org/r/20170322104152.112378812@infradead.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
---
 kernel/futex.c | 24 +++++++++++-------------
 1 file changed, 11 insertions(+), 13 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index 45f00a2fb59c554..8f6372d3a1feea0 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -1555,15 +1555,10 @@ static int wake_futex_pi(u32 __user *uaddr, u32 uval, struct futex_pi_state *pi_
 	WAKE_Q(wake_q);
 	int ret = 0;
 
-	raw_spin_lock_irq(&pi_state->pi_mutex.wait_lock);
 	new_owner = rt_mutex_next_owner(&pi_state->pi_mutex);
-	if (!new_owner) {
+	if (WARN_ON_ONCE(!new_owner)) {
 		/*
-		 * Since we held neither hb->lock nor wait_lock when coming
-		 * into this function, we could have raced with futex_lock_pi()
-		 * such that we might observe @this futex_q waiter, but the
-		 * rt_mutex's wait_list can be empty (either still, or again,
-		 * depending on which side we land).
+		 * As per the comment in futex_unlock_pi() this should not happen.
 		 *
 		 * When this happens, give up our locks and try again, giving
 		 * the futex_lock_pi() instance time to complete, either by
@@ -3020,15 +3015,18 @@ retry:
 		if (pi_state->owner != current)
 			goto out_unlock;
 
+		get_pi_state(pi_state);
 		/*
-		 * Grab a reference on the pi_state and drop hb->lock.
+		 * Since modifying the wait_list is done while holding both
+		 * hb->lock and wait_lock, holding either is sufficient to
+		 * observe it.
 		 *
-		 * The reference ensures pi_state lives, dropping the hb->lock
-		 * is tricky.. wake_futex_pi() will take rt_mutex::wait_lock to
-		 * close the races against futex_lock_pi(), but in case of
-		 * _any_ fail we'll abort and retry the whole deal.
+		 * By taking wait_lock while still holding hb->lock, we ensure
+		 * there is no point where we hold neither; and therefore
+		 * wake_futex_pi() must observe a state consistent with what we
+		 * observed.
 		 */
-		get_pi_state(pi_state);
+		raw_spin_lock_irq(&pi_state->pi_mutex.wait_lock);
 		spin_unlock(&hb->lock);
 
 		ret = wake_futex_pi(uaddr, uval, pi_state);
-- 
2.26.0.106.g9fadedd

