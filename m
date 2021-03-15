Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C897133B523
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 14:55:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230405AbhCONxd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 09:53:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:55554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229862AbhCONxC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:53:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0A2DC64EB6;
        Mon, 15 Mar 2021 13:52:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816381;
        bh=lgEPCoKRkyzEgb68wpQr0WOMNlEFkO0uKQfIXSmt5lM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NmkFCibnq8sXUNd/CvdW4klHxaKlAG3KzRWMKneHkLfxQckdjmmGBpAEsF5QyK32n
         /jJIe9LMaHHGRTTGT8ISNCTvjP42NRSqOTz44b6MRVIkG+1+f9k+V89Kfe8AyzadzI
         5+ZIqiBx0xXxz7+ufR232g23CxUg62B1aBdgZUbM=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Liebler <stli@linux.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Darren Hart <dvhart@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Lee Jones <lee.jones@linaro.org>,
        Zheng Yejian <zhengyejian1@huawei.com>
Subject: [PATCH 4.4 12/75] futex: Cure exit race
Date:   Mon, 15 Mar 2021 14:51:26 +0100
Message-Id: <20210315135208.663967134@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135208.252034256@linuxfoundation.org>
References: <20210315135208.252034256@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Thomas Gleixner <tglx@linutronix.de>

commit da791a667536bf8322042e38ca85d55a78d3c273 upstream.

This patch comes directly from an origin patch (commit
9c3f3986036760c48a92f04b36774aa9f63673f80) in v4.9.

Stefan reported, that the glibc tst-robustpi4 test case fails
occasionally. That case creates the following race between
sys_exit() and sys_futex_lock_pi():

 CPU0				CPU1

 sys_exit()			sys_futex()
  do_exit()			 futex_lock_pi()
   exit_signals(tsk)		  No waiters:
    tsk->flags |= PF_EXITING;	  *uaddr == 0x00000PID
  mm_release(tsk)		  Set waiter bit
   exit_robust_list(tsk) {	  *uaddr = 0x80000PID;
      Set owner died		  attach_to_pi_owner() {
    *uaddr = 0xC0000000;	   tsk = get_task(PID);
   }				   if (!tsk->flags & PF_EXITING) {
  ...				     attach();
  tsk->flags |= PF_EXITPIDONE;	   } else {
				     if (!(tsk->flags & PF_EXITPIDONE))
				       return -EAGAIN;
				     return -ESRCH; <--- FAIL
				   }

ESRCH is returned all the way to user space, which triggers the glibc test
case assert. Returning ESRCH unconditionally is wrong here because the user
space value has been changed by the exiting task to 0xC0000000, i.e. the
FUTEX_OWNER_DIED bit is set and the futex PID value has been cleared. This
is a valid state and the kernel has to handle it, i.e. taking the futex.

Cure it by rereading the user space value when PF_EXITING and PF_EXITPIDONE
is set in the task which 'owns' the futex. If the value has changed, let
the kernel retry the operation, which includes all regular sanity checks
and correctly handles the FUTEX_OWNER_DIED case.

If it hasn't changed, then return ESRCH as there is no way to distinguish
this case from malfunctioning user space. This happens when the exiting
task did not have a robust list, the robust list was corrupted or the user
space value in the futex was simply bogus.

Reported-by: Stefan Liebler <stli@linux.ibm.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Darren Hart <dvhart@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Sasha Levin <sashal@kernel.org>
Cc: stable@vger.kernel.org
Link: https://bugzilla.kernel.org/show_bug.cgi?id=200467
Link: https://lkml.kernel.org/r/20181210152311.986181245@linutronix.de
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[Lee: Required to satisfy functional dependency from futex back-port.
 Re-add the missing handle_exit_race() parts from:
 3d4775df0a89 ("futex: Replace PF_EXITPIDONE with a state")]
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Zheng Yejian <zhengyejian1@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/futex.c |   71 ++++++++++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 65 insertions(+), 6 deletions(-)

--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -1198,11 +1198,67 @@ static void wait_for_owner_exiting(int r
 	put_task_struct(exiting);
 }
 
+static int handle_exit_race(u32 __user *uaddr, u32 uval,
+			    struct task_struct *tsk)
+{
+	u32 uval2;
+
+	/*
+	 * If the futex exit state is not yet FUTEX_STATE_DEAD, wait
+	 * for it to finish.
+	 */
+	if (tsk && tsk->futex_state != FUTEX_STATE_DEAD)
+		return -EAGAIN;
+
+	/*
+	 * Reread the user space value to handle the following situation:
+	 *
+	 * CPU0				CPU1
+	 *
+	 * sys_exit()			sys_futex()
+	 *  do_exit()			 futex_lock_pi()
+	 *                                futex_lock_pi_atomic()
+	 *   exit_signals(tsk)		    No waiters:
+	 *    tsk->flags |= PF_EXITING;	    *uaddr == 0x00000PID
+	 *  mm_release(tsk)		    Set waiter bit
+	 *   exit_robust_list(tsk) {	    *uaddr = 0x80000PID;
+	 *      Set owner died		    attach_to_pi_owner() {
+	 *    *uaddr = 0xC0000000;	     tsk = get_task(PID);
+	 *   }				     if (!tsk->flags & PF_EXITING) {
+	 *  ...				       attach();
+	 *  tsk->futex_state =               } else {
+	 *	FUTEX_STATE_DEAD;              if (tsk->futex_state !=
+	 *					  FUTEX_STATE_DEAD)
+	 *				         return -EAGAIN;
+	 *				       return -ESRCH; <--- FAIL
+	 *				     }
+	 *
+	 * Returning ESRCH unconditionally is wrong here because the
+	 * user space value has been changed by the exiting task.
+	 *
+	 * The same logic applies to the case where the exiting task is
+	 * already gone.
+	 */
+	if (get_futex_value_locked(&uval2, uaddr))
+		return -EFAULT;
+
+	/* If the user space value has changed, try again. */
+	if (uval2 != uval)
+		return -EAGAIN;
+
+	/*
+	 * The exiting task did not have a robust list, the robust list was
+	 * corrupted or the user space value in *uaddr is simply bogus.
+	 * Give up and tell user space.
+	 */
+	return -ESRCH;
+}
+
 /*
  * Lookup the task for the TID provided from user space and attach to
  * it after doing proper sanity checks.
  */
-static int attach_to_pi_owner(u32 uval, union futex_key *key,
+static int attach_to_pi_owner(u32 __user *uaddr, u32 uval, union futex_key *key,
 			      struct futex_pi_state **ps,
 			      struct task_struct **exiting)
 {
@@ -1213,12 +1269,15 @@ static int attach_to_pi_owner(u32 uval,
 	/*
 	 * We are the first waiter - try to look up the real owner and attach
 	 * the new pi_state to it, but bail out when TID = 0 [1]
+	 *
+	 * The !pid check is paranoid. None of the call sites should end up
+	 * with pid == 0, but better safe than sorry. Let the caller retry
 	 */
 	if (!pid)
-		return -ESRCH;
+		return -EAGAIN;
 	p = futex_find_get_task(pid);
 	if (!p)
-		return -ESRCH;
+		return handle_exit_race(uaddr, uval, NULL);
 
 	if (unlikely(p->flags & PF_KTHREAD)) {
 		put_task_struct(p);
@@ -1237,7 +1296,7 @@ static int attach_to_pi_owner(u32 uval,
 		 * FUTEX_STATE_DEAD, we know that the task has finished
 		 * the cleanup:
 		 */
-		int ret = (p->futex_state = FUTEX_STATE_DEAD) ? -ESRCH : -EAGAIN;
+		int ret = handle_exit_race(uaddr, uval, p);
 
 		raw_spin_unlock_irq(&p->pi_lock);
 		/*
@@ -1303,7 +1362,7 @@ static int lookup_pi_state(u32 __user *u
 	 * We are the first waiter - try to look up the owner based on
 	 * @uval and attach to it.
 	 */
-	return attach_to_pi_owner(uval, key, ps, exiting);
+	return attach_to_pi_owner(uaddr, uval, key, ps, exiting);
 }
 
 static int lock_pi_update_atomic(u32 __user *uaddr, u32 uval, u32 newval)
@@ -1419,7 +1478,7 @@ static int futex_lock_pi_atomic(u32 __us
 	 * attach to the owner. If that fails, no harm done, we only
 	 * set the FUTEX_WAITERS bit in the user space variable.
 	 */
-	return attach_to_pi_owner(uval, key, ps, exiting);
+	return attach_to_pi_owner(uaddr, newval, key, ps, exiting);
 }
 
 /**


