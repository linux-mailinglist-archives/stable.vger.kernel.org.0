Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4989C10AD3D
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 11:08:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726133AbfK0KIJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 05:08:09 -0500
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:58201 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726092AbfK0KIJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Nov 2019 05:08:09 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 36D30B7B;
        Wed, 27 Nov 2019 05:08:08 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Wed, 27 Nov 2019 05:08:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=jEGoVu
        6xLGYKz3irXASgnW7/EwOLWyIuzmKPSgQGk4s=; b=IICsUZv66mAxXzmVVLhFV5
        eurM6yxlnIOLi5a8T9pyXEddn5IFYY+LC1Jvfy6jk76ujefjBlkRyfiZbBKvpm+r
        NTPcr/hJfsPP5dDIeJjinQopuCMMtcFYhWJMIO2q6iMty7JfosDsDpY8G/zEdskc
        mbTjTQUI68M0U+be52yOT3HQcDJ+3FBkAXn/SlMT0Raiy1DmETsNKX4BeaNzse/E
        3VJewzvMXfsd7n7qihx9gRNQ+y0+Pbx6HsGfNa8LUzjNkdp9lbw0do29PhQmCGpD
        8P8JBD+kgOL6C5V/o0JH3BB0yajSUYlxCfFrpon8vkAvLSsOIH8c7yrh9H4Tj/Vg
        ==
X-ME-Sender: <xms:BkveXfmeyIn3cSOborsA3dFA27V9GxBxxvOYFO36ooQl0K-72BohgQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrudeihedgudduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrd
    dutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhen
    ucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:BkveXaCrpid8QJvTxh_30QjIEx-4PNLSdZEtDiSdX0bttZnjmsOnRA>
    <xmx:BkveXaDJB0DR-1OCPgN0nGEn1qTuoEM_lQUH9Ca5h0AGSUpl8LAWMg>
    <xmx:BkveXQQDefxAenONTHCcK1BWeUK0r_wMjOJrwS303i4ym_c5aFoyRg>
    <xmx:B0veXbuyHHoTy1ACcec0RQhZ4hHvLxAPZIdgBsF2m5kaOfc6tHETXg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 85F033060060;
        Wed, 27 Nov 2019 05:08:06 -0500 (EST)
Subject: FAILED: patch "[PATCH] futex: Prevent robust futex exit race" failed to apply to 4.19-stable tree
To:     yang.tao172@zte.com.cn, mingo@kernel.org, peterz@infradead.org,
        tglx@linutronix.de, wang.yi59@zte.com.cn
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 27 Nov 2019 11:08:05 +0100
Message-ID: <1574849285203208@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From ca16d5bee59807bf04deaab0a8eccecd5061528c Mon Sep 17 00:00:00 2001
From: Yang Tao <yang.tao172@zte.com.cn>
Date: Wed, 6 Nov 2019 22:55:35 +0100
Subject: [PATCH] futex: Prevent robust futex exit race

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

diff --git a/kernel/futex.c b/kernel/futex.c
index 43229f8999fc..49eaf5be851a 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -3452,11 +3452,16 @@ SYSCALL_DEFINE3(get_robust_list, int, pid,
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
@@ -3469,6 +3474,42 @@ static int handle_futex_death(u32 __user *uaddr, struct task_struct *curr, int p
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
 
@@ -3588,10 +3629,11 @@ void exit_robust_list(struct task_struct *curr)
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
@@ -3605,9 +3647,10 @@ void exit_robust_list(struct task_struct *curr)
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
@@ -3784,7 +3827,8 @@ void compat_exit_robust_list(struct task_struct *curr)
 		if (entry != pending) {
 			void __user *uaddr = futex_uaddr(entry, futex_offset);
 
-			if (handle_futex_death(uaddr, curr, pi))
+			if (handle_futex_death(uaddr, curr, pi,
+					       HANDLE_DEATH_LIST))
 				return;
 		}
 		if (rc)
@@ -3803,7 +3847,7 @@ void compat_exit_robust_list(struct task_struct *curr)
 	if (pending) {
 		void __user *uaddr = futex_uaddr(pending, futex_offset);
 
-		handle_futex_death(uaddr, curr, pip);
+		handle_futex_death(uaddr, curr, pip, HANDLE_DEATH_PENDING);
 	}
 }
 

