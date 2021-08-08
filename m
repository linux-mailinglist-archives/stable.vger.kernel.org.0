Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C42E33E396D
	for <lists+stable@lfdr.de>; Sun,  8 Aug 2021 09:23:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231314AbhHHHXY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Aug 2021 03:23:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:55066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231284AbhHHHXX (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 8 Aug 2021 03:23:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3478560EE7;
        Sun,  8 Aug 2021 07:23:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628407384;
        bh=1laAJwA0m3w1XOFNWusedhcgUBIn/Ok8fTYwSEJXPtc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yf2xBVVQXh07u4aLjUu4ixgYiObekv9RBNWcWH6HtnHmfAssg/zdJaiAj0A7v/6Gr
         Q4BhhNz0uPFa2k+F13kXvH0SEG7cDQaOQIOOIIzN585B9tOvRh1EafVHkyl4YjpH7a
         IwVwlB80nT36LyiXtRdk1RNaegsDjfY+UIls9ZLo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        juri.lelli@arm.com, bigeasy@linutronix.de, xlpang@redhat.com,
        rostedt@goodmis.org, mathieu.desnoyers@efficios.com,
        jdesfossez@efficios.com, dvhart@infradead.org, bristot@redhat.com,
        Thomas Gleixner <tglx@linutronix.de>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        Joe Korty <joe.korty@concurrent-rt.com>
Subject: [PATCH 4.4 03/11] futex,rt_mutex: Introduce rt_mutex_init_waiter()
Date:   Sun,  8 Aug 2021 09:22:38 +0200
Message-Id: <20210808072217.435137340@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210808072217.322468704@linuxfoundation.org>
References: <20210808072217.322468704@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 50809358dd7199aa7ce232f6877dd09ec30ef374 ]

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
Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
Acked-by: Joe Korty <joe.korty@concurrent-rt.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/futex.c                  |    5 +----
 kernel/locking/rtmutex.c        |   12 +++++++++---
 kernel/locking/rtmutex_common.h |    1 +
 3 files changed, 11 insertions(+), 7 deletions(-)

--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -3156,10 +3156,7 @@ static int futex_wait_requeue_pi(u32 __u
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
@@ -1155,6 +1155,14 @@ void rt_mutex_adjust_pi(struct task_stru
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
@@ -1236,9 +1244,7 @@ rt_mutex_slowlock(struct rt_mutex *lock,
 	struct rt_mutex_waiter waiter;
 	int ret = 0;
 
-	debug_rt_mutex_init_waiter(&waiter);
-	RB_CLEAR_NODE(&waiter.pi_tree_entry);
-	RB_CLEAR_NODE(&waiter.tree_entry);
+	rt_mutex_init_waiter(&waiter);
 
 	raw_spin_lock(&lock->wait_lock);
 
--- a/kernel/locking/rtmutex_common.h
+++ b/kernel/locking/rtmutex_common.h
@@ -102,6 +102,7 @@ extern struct task_struct *rt_mutex_next
 extern void rt_mutex_init_proxy_locked(struct rt_mutex *lock,
 				       struct task_struct *proxy_owner);
 extern void rt_mutex_proxy_unlock(struct rt_mutex *lock);
+extern void rt_mutex_init_waiter(struct rt_mutex_waiter *waiter);
 extern int rt_mutex_start_proxy_lock(struct rt_mutex *lock,
 				     struct rt_mutex_waiter *waiter,
 				     struct task_struct *task);


