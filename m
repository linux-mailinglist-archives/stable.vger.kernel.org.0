Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9AA634C5DF
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:04:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231794AbhC2IDb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:03:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:45738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229711AbhC2IDD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:03:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2F4F06197F;
        Mon, 29 Mar 2021 08:03:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617004981;
        bh=B6aw/X5Az/IlMDMo4OjTNpm7RW+go5ZCrhp0lpEhYQE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K5T5qvmKFFzdd8CkN3A+DSumQN0F89JqB6d5RzgskJWUMsmUpjbBroOVlzUGI7q2E
         imFQtN9vQJbNrXEZ12/MxiwGr1TVPxrS4T3giZ3Ou5EzTDSC9yCqQhaiCmCngD6o/J
         v8G/UNPHAcp/IujJYGfCzQfXTShG/+pyOiWq5y/A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        juri.lelli@arm.com, bigeasy@linutronix.de, xlpang@redhat.com,
        rostedt@goodmis.org, mathieu.desnoyers@efficios.com,
        jdesfossez@efficios.com, dvhart@infradead.org, bristot@redhat.com,
        Thomas Gleixner <tglx@linutronix.de>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 4.9 38/53] futex,rt_mutex: Introduce rt_mutex_init_waiter()
Date:   Mon, 29 Mar 2021 09:58:13 +0200
Message-Id: <20210329075608.765269306@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075607.561619583@linuxfoundation.org>
References: <20210329075607.561619583@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

commit 50809358dd7199aa7ce232f6877dd09ec30ef374 upstream.

Since there's already two copies of this code, introduce a helper now
before adding a third one.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: juri.lelli@arm.com
Cc: bigeasy@linutronix.de
Cc: xlpang@redhat.com
Cc: rostedt@goodmis.org
Cc: mathieu.desnoyers@efficios.com
Cc: jdesfossez@efficios.com
Cc: dvhart@infradead.org
Cc: bristot@redhat.com
Link: http://lkml.kernel.org/r/20170322104151.950039479@infradead.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
[bwh: Backported to 4.9: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/futex.c                  |    5 +----
 kernel/locking/rtmutex.c        |   12 +++++++++---
 kernel/locking/rtmutex_common.h |    1 +
 3 files changed, 11 insertions(+), 7 deletions(-)

--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -3234,10 +3234,7 @@ static int futex_wait_requeue_pi(u32 __u
 	 * The waiter is allocated on our stack, manipulated by the requeue
 	 * code while we sleep on uaddr.
 	 */
-	debug_rt_mutex_init_waiter(&rt_waiter);
-	RB_CLEAR_NODE(&rt_waiter.pi_tree_entry);
-	RB_CLEAR_NODE(&rt_waiter.tree_entry);
-	rt_waiter.task = NULL;
+	rt_mutex_init_waiter(&rt_waiter);
 
 	ret = get_futex_key(uaddr2, flags & FLAGS_SHARED, &key2, VERIFY_WRITE);
 	if (unlikely(ret != 0))
--- a/kernel/locking/rtmutex.c
+++ b/kernel/locking/rtmutex.c
@@ -1176,6 +1176,14 @@ void rt_mutex_adjust_pi(struct task_stru
 				   next_lock, NULL, task);
 }
 
+void rt_mutex_init_waiter(struct rt_mutex_waiter *waiter)
+{
+	debug_rt_mutex_init_waiter(waiter);
+	RB_CLEAR_NODE(&waiter->pi_tree_entry);
+	RB_CLEAR_NODE(&waiter->tree_entry);
+	waiter->task = NULL;
+}
+
 /**
  * __rt_mutex_slowlock() - Perform the wait-wake-try-to-take loop
  * @lock:		 the rt_mutex to take
@@ -1258,9 +1266,7 @@ rt_mutex_slowlock(struct rt_mutex *lock,
 	unsigned long flags;
 	int ret = 0;
 
-	debug_rt_mutex_init_waiter(&waiter);
-	RB_CLEAR_NODE(&waiter.pi_tree_entry);
-	RB_CLEAR_NODE(&waiter.tree_entry);
+	rt_mutex_init_waiter(&waiter);
 
 	/*
 	 * Technically we could use raw_spin_[un]lock_irq() here, but this can
--- a/kernel/locking/rtmutex_common.h
+++ b/kernel/locking/rtmutex_common.h
@@ -103,6 +103,7 @@ extern struct task_struct *rt_mutex_next
 extern void rt_mutex_init_proxy_locked(struct rt_mutex *lock,
 				       struct task_struct *proxy_owner);
 extern void rt_mutex_proxy_unlock(struct rt_mutex *lock);
+extern void rt_mutex_init_waiter(struct rt_mutex_waiter *waiter);
 extern int rt_mutex_start_proxy_lock(struct rt_mutex *lock,
 				     struct rt_mutex_waiter *waiter,
 				     struct task_struct *task);


