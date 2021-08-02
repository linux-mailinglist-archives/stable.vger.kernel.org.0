Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E0A13DD7CE
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 15:48:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234307AbhHBNsP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 09:48:15 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:12338 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234290AbhHBNrg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Aug 2021 09:47:36 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4GdfM40V16z81wF;
        Mon,  2 Aug 2021 21:42:24 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 2 Aug 2021 21:47:13 +0800
Received: from thunder-town.china.huawei.com (10.174.179.0) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 2 Aug 2021 21:47:12 +0800
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
Subject: [PATCH 4.4 02/11] futex: Cleanup refcounting
Date:   Mon, 2 Aug 2021 21:46:15 +0800
Message-ID: <20210802134624.1934-3-thunder.leizhen@huawei.com>
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

[ Upstream commit bf92cf3a5100f5a0d5f9834787b130159397cb22 ]

Add a put_pit_state() as counterpart for get_pi_state() so the refcounting
becomes consistent.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: juri.lelli@arm.com
Cc: bigeasy@linutronix.de
Cc: xlpang@redhat.com
Cc: rostedt@goodmis.org
Cc: mathieu.desnoyers@efficios.com
Cc: jdesfossez@efficios.com
Cc: dvhart@infradead.org
Cc: bristot@redhat.com
Link: http://lkml.kernel.org/r/20170322104151.801778516@infradead.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
---
 kernel/futex.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index dbb38e14f6fcc8e..dab9c79a931a23e 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -825,7 +825,7 @@ static int refill_pi_state_cache(void)
 	return 0;
 }
 
-static struct futex_pi_state * alloc_pi_state(void)
+static struct futex_pi_state *alloc_pi_state(void)
 {
 	struct futex_pi_state *pi_state = current->pi_state_cache;
 
@@ -858,6 +858,11 @@ static void pi_state_update_owner(struct futex_pi_state *pi_state,
 	}
 }
 
+static void get_pi_state(struct futex_pi_state *pi_state)
+{
+	WARN_ON_ONCE(!atomic_inc_not_zero(&pi_state->refcount));
+}
+
 /*
  * Drops a reference to the pi_state object and frees or caches it
  * when the last reference is gone.
@@ -901,7 +906,7 @@ static void put_pi_state(struct futex_pi_state *pi_state)
  * Look up the task based on what TID userspace gave us.
  * We dont trust it.
  */
-static struct task_struct * futex_find_get_task(pid_t pid)
+static struct task_struct *futex_find_get_task(pid_t pid)
 {
 	struct task_struct *p;
 
@@ -1149,7 +1154,7 @@ static int attach_to_pi_state(u32 __user *uaddr, u32 uval,
 		goto out_einval;
 
 out_attach:
-	atomic_inc(&pi_state->refcount);
+	get_pi_state(pi_state);
 	raw_spin_unlock_irq(&pi_state->pi_mutex.wait_lock);
 	*ps = pi_state;
 	return 0;
@@ -2204,7 +2209,7 @@ retry_private:
 		 */
 		if (requeue_pi) {
 			/* Prepare the waiter to take the rt_mutex. */
-			atomic_inc(&pi_state->refcount);
+			get_pi_state(pi_state);
 			this->pi_state = pi_state;
 			ret = rt_mutex_start_proxy_lock(&pi_state->pi_mutex,
 							this->rt_waiter,
-- 
2.26.0.106.g9fadedd

