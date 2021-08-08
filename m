Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54D233E396C
	for <lists+stable@lfdr.de>; Sun,  8 Aug 2021 09:23:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231301AbhHHHXY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Aug 2021 03:23:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:55008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231328AbhHHHXV (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 8 Aug 2021 03:23:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7B27C60F02;
        Sun,  8 Aug 2021 07:23:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628407382;
        bh=q18wI37N9Ng3TVmmftyzIFDQXlXvP0TaDJNf2OjhR4I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o/uyMCtZ+o//OBpmbtn9zalfupwxUGU3Bmd6IAo9uLAbKbX+FYOYTmFORNwEk/YBP
         tOVmLFbTMqy2YsRKUKqgst6tEWFRaYZKN58uIv/pQgNZJtfeycoQ5hnjQ/hAIQPloK
         0u1F83QoNl4gDAJDCv/vtxoeqbNOGNCuIHZHesY0=
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
Subject: [PATCH 4.4 02/11] futex: Cleanup refcounting
Date:   Sun,  8 Aug 2021 09:22:37 +0200
Message-Id: <20210808072217.401551055@linuxfoundation.org>
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
Acked-by: Joe Korty <joe.korty@concurrent-rt.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/futex.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -825,7 +825,7 @@ static int refill_pi_state_cache(void)
 	return 0;
 }
 
-static struct futex_pi_state * alloc_pi_state(void)
+static struct futex_pi_state *alloc_pi_state(void)
 {
 	struct futex_pi_state *pi_state = current->pi_state_cache;
 
@@ -858,6 +858,11 @@ static void pi_state_update_owner(struct
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
@@ -901,7 +906,7 @@ static void put_pi_state(struct futex_pi
  * Look up the task based on what TID userspace gave us.
  * We dont trust it.
  */
-static struct task_struct * futex_find_get_task(pid_t pid)
+static struct task_struct *futex_find_get_task(pid_t pid)
 {
 	struct task_struct *p;
 
@@ -1149,7 +1154,7 @@ static int attach_to_pi_state(u32 __user
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


