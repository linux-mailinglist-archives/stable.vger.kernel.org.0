Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBAB332EAEB
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 13:41:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232800AbhCEMk7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 07:40:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:56182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232244AbhCEMkp (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 07:40:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B8E7C64E84;
        Fri,  5 Mar 2021 12:40:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614948045;
        bh=SwcCi8I5s9Fk7jXCQKcNUAccniTQdcskiFZh/amYeSE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N8ie6ayh/af18zCePIRSTPs6biF4CLyaRqNeL54XMUSwlbcHG4jPEmNwo2pc6f2KH
         GyqZ8GXvxp0vov2iBxnOmmvPOZK35fdmugwQSVxV8bRvd+ZSRzbFArCYW5NeA43JNm
         +crRjyzJ9noygDGhxy1Fy6h9CUNeR02CUwIzjcmc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        juri.lelli@arm.com, bigeasy@linutronix.de, xlpang@redhat.com,
        rostedt@goodmis.org, mathieu.desnoyers@efficios.com,
        jdesfossez@efficios.com, dvhart@infradead.org, bristot@redhat.com,
        Thomas Gleixner <tglx@linutronix.de>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 4.9 01/41] futex: Cleanup variable names for futex_top_waiter()
Date:   Fri,  5 Mar 2021 13:22:08 +0100
Message-Id: <20210305120851.334085382@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210305120851.255002428@linuxfoundation.org>
References: <20210305120851.255002428@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ben Hutchings <ben@decadent.org.uk>

From: Peter Zijlstra <peterz@infradead.org>

commit 499f5aca2cdd5e958b27e2655e7e7f82524f46b1 upstream.

futex_top_waiter() returns the top-waiter on the pi_mutex. Assinging
this to a variable 'match' totally obscures the code.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: juri.lelli@arm.com
Cc: bigeasy@linutronix.de
Cc: xlpang@redhat.com
Cc: rostedt@goodmis.org
Cc: mathieu.desnoyers@efficios.com
Cc: jdesfossez@efficios.com
Cc: dvhart@infradead.org
Cc: bristot@redhat.com
Link: http://lkml.kernel.org/r/20170322104151.554710645@infradead.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
[bwh: Backported to 4.9: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/futex.c |   28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -1352,14 +1352,14 @@ static int lookup_pi_state(u32 __user *u
 			   union futex_key *key, struct futex_pi_state **ps,
 			   struct task_struct **exiting)
 {
-	struct futex_q *match = futex_top_waiter(hb, key);
+	struct futex_q *top_waiter = futex_top_waiter(hb, key);
 
 	/*
 	 * If there is a waiter on that futex, validate it and
 	 * attach to the pi_state when the validation succeeds.
 	 */
-	if (match)
-		return attach_to_pi_state(uaddr, uval, match->pi_state, ps);
+	if (top_waiter)
+		return attach_to_pi_state(uaddr, uval, top_waiter->pi_state, ps);
 
 	/*
 	 * We are the first waiter - try to look up the owner based on
@@ -1414,7 +1414,7 @@ static int futex_lock_pi_atomic(u32 __us
 				int set_waiters)
 {
 	u32 uval, newval, vpid = task_pid_vnr(task);
-	struct futex_q *match;
+	struct futex_q *top_waiter;
 	int ret;
 
 	/*
@@ -1440,9 +1440,9 @@ static int futex_lock_pi_atomic(u32 __us
 	 * Lookup existing state first. If it exists, try to attach to
 	 * its pi_state.
 	 */
-	match = futex_top_waiter(hb, key);
-	if (match)
-		return attach_to_pi_state(uaddr, uval, match->pi_state, ps);
+	top_waiter = futex_top_waiter(hb, key);
+	if (top_waiter)
+		return attach_to_pi_state(uaddr, uval, top_waiter->pi_state, ps);
 
 	/*
 	 * No waiter and user TID is 0. We are here because the
@@ -1532,11 +1532,11 @@ static void mark_wake_futex(struct wake_
 	q->lock_ptr = NULL;
 }
 
-static int wake_futex_pi(u32 __user *uaddr, u32 uval, struct futex_q *this,
+static int wake_futex_pi(u32 __user *uaddr, u32 uval, struct futex_q *top_waiter,
 			 struct futex_hash_bucket *hb)
 {
 	struct task_struct *new_owner;
-	struct futex_pi_state *pi_state = this->pi_state;
+	struct futex_pi_state *pi_state = top_waiter->pi_state;
 	u32 uninitialized_var(curval), newval;
 	WAKE_Q(wake_q);
 	bool deboost;
@@ -1557,7 +1557,7 @@ static int wake_futex_pi(u32 __user *uad
 
 	/*
 	 * When we interleave with futex_lock_pi() where it does
-	 * rt_mutex_timed_futex_lock(), we might observe @this futex_q waiter,
+	 * rt_mutex_timed_futex_lock(), we might observe @top_waiter futex_q waiter,
 	 * but the rt_mutex's wait_list can be empty (either still, or again,
 	 * depending on which side we land).
 	 *
@@ -2975,7 +2975,7 @@ static int futex_unlock_pi(u32 __user *u
 	u32 uninitialized_var(curval), uval, vpid = task_pid_vnr(current);
 	union futex_key key = FUTEX_KEY_INIT;
 	struct futex_hash_bucket *hb;
-	struct futex_q *match;
+	struct futex_q *top_waiter;
 	int ret;
 
 retry:
@@ -2999,9 +2999,9 @@ retry:
 	 * all and we at least want to know if user space fiddled
 	 * with the futex value instead of blindly unlocking.
 	 */
-	match = futex_top_waiter(hb, &key);
-	if (match) {
-		ret = wake_futex_pi(uaddr, uval, match, hb);
+	top_waiter = futex_top_waiter(hb, &key);
+	if (top_waiter) {
+		ret = wake_futex_pi(uaddr, uval, top_waiter, hb);
 		/*
 		 * In case of success wake_futex_pi dropped the hash
 		 * bucket lock.


