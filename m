Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67A6311329A
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 19:11:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730706AbfLDSJ5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 13:09:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:36262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729225AbfLDSJx (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Dec 2019 13:09:53 -0500
Received: from localhost (unknown [217.68.49.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C27DB20862;
        Wed,  4 Dec 2019 18:09:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575482992;
        bh=aL5Sn414+tIpz0/O69UP1uWvm46wNShiWNS3ouiAAcw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zax2WouBPOVoAHNqrqWt5ZbEatqBP1EDW4J71nXb1giKdjnp488eWeVDS7Z0tcMNO
         +rYz4BZnH2EedBQ67qpbsDMzPkt8WmHRcCkX5afG+rVz8PQAyRrgGydbEUkY3BTHn8
         uYmXyEbIfeCg303H+j1pYQ8Cp4hvbQZUEn48yUs8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yang Tao <yang.tao172@zte.com.cn>,
        Yi Wang <wang.yi59@zte.com.cn>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 4.14 186/209] futex: Prevent robust futex exit race
Date:   Wed,  4 Dec 2019 18:56:38 +0100
Message-Id: <20191204175336.294441343@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191204175321.609072813@linuxfoundation.org>
References: <20191204175321.609072813@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Tao <yang.tao172@zte.com.cn>

commit ca16d5bee59807bf04deaab0a8eccecd5061528c upstream.

Robust futexes utilize the robust_list mechanism to allow the kernel to
release futexes which are held when a task exits. The exit can be voluntary
or caused by a signal or fault. This prevents that waiters block forever.

The futex operations in user space store a pointer to the futex they are
either locking or unlocking in the op_pending member of the per task robust
list.

After a lock operation has succeeded the futex is queued in the robust list
linked list and the op_pending pointer is cleared.

After an unlock operation has succeeded the futex is removed from the
robust list linked list and the op_pending pointer is cleared.

The robust list exit code checks for the pending operation and any futex
which is queued in the linked list. It carefully checks whether the futex
value is the TID of the exiting task. If so, it sets the OWNER_DIED bit and
tries to wake up a potential waiter.

This is race free for the lock operation but unlock has two race scenarios
where waiters might not be woken up. These issues can be observed with
regular robust pthread mutexes. PI aware pthread mutexes are not affected.

(1) Unlocking task is killed after unlocking the futex value in user space
    before being able to wake a waiter.

        pthread_mutex_unlock()
                |
                V
        atomic_exchange_rel (&mutex->__data.__lock, 0)
                        <------------------------killed
            lll_futex_wake ()                   |
                                                |
                                                |(__lock = 0)
                                                |(enter kernel)
                                                |
                                                V
                                            do_exit()
                                            exit_mm()
                                          mm_release()
                                        exit_robust_list()
                                        handle_futex_death()
                                                |
                                                |(__lock = 0)
                                                |(uval = 0)
                                                |
                                                V
        if ((uval & FUTEX_TID_MASK) != task_pid_vnr(curr))
                return 0;

    The sanity check which ensures that the user space futex is owned by
    the exiting task prevents the wakeup of waiters which in consequence
    block infinitely.

(2) Waiting task is killed after a wakeup and before it can acquire the
    futex in user space.

        OWNER                         WAITER
				futex_wait()
   pthread_mutex_unlock()               |
                |                       |
                |(__lock = 0)           |
                |                       |
                V                       |
         futex_wake() ------------>  wakeup()
                                        |
                                        |(return to userspace)
                                        |(__lock = 0)
                                        |
                                        V
                        oldval = mutex->__data.__lock
                                          <-----------------killed
    atomic_compare_and_exchange_val_acq (&mutex->__data.__lock,  |
                        id | assume_other_futex_waiters, 0)      |
                                                                 |
                                                                 |
                                                   (enter kernel)|
                                                                 |
                                                                 V
                                                         do_exit()
                                                        |
                                                        |
                                                        V
                                        handle_futex_death()
                                        |
                                        |(__lock = 0)
                                        |(uval = 0)
                                        |
                                        V
        if ((uval & FUTEX_TID_MASK) != task_pid_vnr(curr))
                return 0;

    The sanity check which ensures that the user space futex is owned
    by the exiting task prevents the wakeup of waiters, which seems to
    be correct as the exiting task does not own the futex value, but
    the consequence is that other waiters wont be woken up and block
    infinitely.

In both scenarios the following conditions are true:

   - task->robust_list->list_op_pending != NULL
   - user space futex value == 0
   - Regular futex (not PI)

If these conditions are met then it is reasonably safe to wake up a
potential waiter in order to prevent the above problems.

As this might be a false positive it can cause spurious wakeups, but the
waiter side has to handle other types of unrelated wakeups, e.g. signals
gracefully anyway. So such a spurious wakeup will not affect the
correctness of these operations.

This workaround must not touch the user space futex value and cannot set
the OWNER_DIED bit because the lock value is 0, i.e. uncontended. Setting
OWNER_DIED in this case would result in inconsistent state and subsequently
in malfunction of the owner died handling in user space.

The rest of the user space state is still consistent as no other task can
observe the list_op_pending entry in the exiting tasks robust list.

The eventually woken up waiter will observe the uncontended lock value and
take it over.

[ tglx: Massaged changelog and comment. Made the return explicit and not
  	depend on the subsequent check and added constants to hand into
  	handle_futex_death() instead of plain numbers. Fixed a few coding
	style issues. ]

Fixes: 0771dfefc9e5 ("[PATCH] lightweight robust futexes: core")
Signed-off-by: Yang Tao <yang.tao172@zte.com.cn>
Signed-off-by: Yi Wang <wang.yi59@zte.com.cn>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Ingo Molnar <mingo@kernel.org>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/1573010582-35297-1-git-send-email-wang.yi59@zte.com.cn
Link: https://lkml.kernel.org/r/20191106224555.943191378@linutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/futex.c |   58 ++++++++++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 51 insertions(+), 7 deletions(-)

--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -3475,11 +3475,16 @@ err_unlock:
 	return ret;
 }
 
+/* Constants for the pending_op argument of handle_futex_death */
+#define HANDLE_DEATH_PENDING	true
+#define HANDLE_DEATH_LIST	false
+
 /*
  * Process a futex-list entry, check whether it's owned by the
  * dying task, and do notification if so:
  */
-static int handle_futex_death(u32 __user *uaddr, struct task_struct *curr, int pi)
+static int handle_futex_death(u32 __user *uaddr, struct task_struct *curr,
+			      bool pi, bool pending_op)
 {
 	u32 uval, uninitialized_var(nval), mval;
 	int err;
@@ -3492,6 +3497,42 @@ retry:
 	if (get_user(uval, uaddr))
 		return -1;
 
+	/*
+	 * Special case for regular (non PI) futexes. The unlock path in
+	 * user space has two race scenarios:
+	 *
+	 * 1. The unlock path releases the user space futex value and
+	 *    before it can execute the futex() syscall to wake up
+	 *    waiters it is killed.
+	 *
+	 * 2. A woken up waiter is killed before it can acquire the
+	 *    futex in user space.
+	 *
+	 * In both cases the TID validation below prevents a wakeup of
+	 * potential waiters which can cause these waiters to block
+	 * forever.
+	 *
+	 * In both cases the following conditions are met:
+	 *
+	 *	1) task->robust_list->list_op_pending != NULL
+	 *	   @pending_op == true
+	 *	2) User space futex value == 0
+	 *	3) Regular futex: @pi == false
+	 *
+	 * If these conditions are met, it is safe to attempt waking up a
+	 * potential waiter without touching the user space futex value and
+	 * trying to set the OWNER_DIED bit. The user space futex value is
+	 * uncontended and the rest of the user space mutex state is
+	 * consistent, so a woken waiter will just take over the
+	 * uncontended futex. Setting the OWNER_DIED bit would create
+	 * inconsistent state and malfunction of the user space owner died
+	 * handling.
+	 */
+	if (pending_op && !pi && !uval) {
+		futex_wake(uaddr, 1, 1, FUTEX_BITSET_MATCH_ANY);
+		return 0;
+	}
+
 	if ((uval & FUTEX_TID_MASK) != task_pid_vnr(curr))
 		return 0;
 
@@ -3611,10 +3652,11 @@ void exit_robust_list(struct task_struct
 		 * A pending lock might already be on the list, so
 		 * don't process it twice:
 		 */
-		if (entry != pending)
+		if (entry != pending) {
 			if (handle_futex_death((void __user *)entry + futex_offset,
-						curr, pi))
+						curr, pi, HANDLE_DEATH_LIST))
 				return;
+		}
 		if (rc)
 			return;
 		entry = next_entry;
@@ -3628,9 +3670,10 @@ void exit_robust_list(struct task_struct
 		cond_resched();
 	}
 
-	if (pending)
+	if (pending) {
 		handle_futex_death((void __user *)pending + futex_offset,
-				   curr, pip);
+				   curr, pip, HANDLE_DEATH_PENDING);
+	}
 }
 
 long do_futex(u32 __user *uaddr, int op, u32 val, ktime_t *timeout,
@@ -3805,7 +3848,8 @@ void compat_exit_robust_list(struct task
 		if (entry != pending) {
 			void __user *uaddr = futex_uaddr(entry, futex_offset);
 
-			if (handle_futex_death(uaddr, curr, pi))
+			if (handle_futex_death(uaddr, curr, pi,
+					       HANDLE_DEATH_LIST))
 				return;
 		}
 		if (rc)
@@ -3824,7 +3868,7 @@ void compat_exit_robust_list(struct task
 	if (pending) {
 		void __user *uaddr = futex_uaddr(pending, futex_offset);
 
-		handle_futex_death(uaddr, curr, pip);
+		handle_futex_death(uaddr, curr, pip, HANDLE_DEATH_PENDING);
 	}
 }
 


