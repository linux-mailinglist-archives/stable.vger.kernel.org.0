Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF0CC15660C
	for <lists+stable@lfdr.de>; Sat,  8 Feb 2020 19:31:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728287AbgBHSbZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Feb 2020 13:31:25 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34826 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727977AbgBHS3u (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 Feb 2020 13:29:50 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1j0UrK-0003fa-1j; Sat, 08 Feb 2020 18:29:38 +0000
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1j0UrJ-000CRA-8Z; Sat, 08 Feb 2020 18:29:37 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Yang Tao" <yang.tao172@zte.com.cn>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        "Ingo Molnar" <mingo@kernel.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Yi Wang" <wang.yi59@zte.com.cn>
Date:   Sat, 08 Feb 2020 18:20:35 +0000
Message-ID: <lsq.1581185940.296689092@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 096/148] futex: Prevent robust futex exit race
In-Reply-To: <lsq.1581185939.857586636@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.82-rc1 review patch.  If anyone has any objections, please let me know.

------------------

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
Link: https://lkml.kernel.org/r/1573010582-35297-1-git-send-email-wang.yi59@zte.com.cn
Link: https://lkml.kernel.org/r/20191106224555.943191378@linutronix.de
[bwh: Backported to 3.16: Implementation is split between futex.c and
 futex_compat.c, with common definitions in <linux/futex.h>]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -2905,7 +2905,8 @@ err_unlock:
  * Process a futex-list entry, check whether it's owned by the
  * dying task, and do notification if so:
  */
-int handle_futex_death(u32 __user *uaddr, struct task_struct *curr, int pi)
+int handle_futex_death(u32 __user *uaddr, struct task_struct *curr,
+		       bool pi, bool pending_op)
 {
 	u32 uval, uninitialized_var(nval), mval;
 
@@ -2917,6 +2918,42 @@ retry:
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
 	if ((uval & FUTEX_TID_MASK) == task_pid_vnr(curr)) {
 		/*
 		 * Ok, this dying thread is truly holding a futex
@@ -3021,10 +3058,11 @@ void exit_robust_list(struct task_struct
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
@@ -3038,9 +3076,10 @@ void exit_robust_list(struct task_struct
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
--- a/kernel/futex_compat.c
+++ b/kernel/futex_compat.c
@@ -94,7 +94,8 @@ void compat_exit_robust_list(struct task
 		if (entry != pending) {
 			void __user *uaddr = futex_uaddr(entry, futex_offset);
 
-			if (handle_futex_death(uaddr, curr, pi))
+			if (handle_futex_death(uaddr, curr, pi,
+					       HANDLE_DEATH_LIST))
 				return;
 		}
 		if (rc)
@@ -113,7 +114,7 @@ void compat_exit_robust_list(struct task
 	if (pending) {
 		void __user *uaddr = futex_uaddr(pending, futex_offset);
 
-		handle_futex_death(uaddr, curr, pip);
+		handle_futex_death(uaddr, curr, pip, HANDLE_DEATH_PENDING);
 	}
 }
 
--- a/include/linux/futex.h
+++ b/include/linux/futex.h
@@ -11,8 +11,13 @@ union ktime;
 long do_futex(u32 __user *uaddr, int op, u32 val, union ktime *timeout,
 	      u32 __user *uaddr2, u32 val2, u32 val3);
 
+/* Constants for the pending_op argument of handle_futex_death */
+#define HANDLE_DEATH_PENDING	true
+#define HANDLE_DEATH_LIST	false
+
 extern int
-handle_futex_death(u32 __user *uaddr, struct task_struct *curr, int pi);
+handle_futex_death(u32 __user *uaddr, struct task_struct *curr,
+		   bool pi, bool pending_op);
 
 /*
  * Futexes are matched on equal values of this key.

