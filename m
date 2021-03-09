Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D33C331D36
	for <lists+stable@lfdr.de>; Tue,  9 Mar 2021 04:00:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230269AbhCIC72 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Mar 2021 21:59:28 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:13872 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229750AbhCIC7R (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Mar 2021 21:59:17 -0500
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4DvfyJ5VSNz8vQg;
        Tue,  9 Mar 2021 10:57:28 +0800 (CST)
Received: from code-website.localdomain (10.175.127.227) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.498.0; Tue, 9 Mar 2021 10:59:06 +0800
From:   Zheng Yejian <zhengyejian1@huawei.com>
To:     <gregkh@linuxfoundation.org>, <lee.jones@linaro.org>,
        <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <tglx@linutronix.de>, <cj.chengjian@huawei.com>,
        <judy.chenhui@huawei.com>, <zhangjinhao2@huawei.com>,
        <nixiaoming@huawei.com>
Subject: [PATCH 4.4 2/3] futex: Cure exit race
Date:   Tue, 9 Mar 2021 11:06:04 +0800
Message-ID: <20210309030605.3295183-3-zhengyejian1@huawei.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20210309030605.3295183-1-zhengyejian1@huawei.com>
References: <20210309030605.3295183-1-zhengyejian1@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

commit da791a667536bf8322042e38ca85d55a78d3c273 upstream.

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
---
 kernel/futex.c | 71 +++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 65 insertions(+), 6 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index b410752f5ad1..116766ef7de6 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -1196,11 +1196,67 @@ static void wait_for_owner_exiting(int ret, struct task_struct *exiting)
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
@@ -1211,12 +1267,15 @@ static int attach_to_pi_owner(u32 uval, union futex_key *key,
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
@@ -1235,7 +1294,7 @@ static int attach_to_pi_owner(u32 uval, union futex_key *key,
 		 * FUTEX_STATE_DEAD, we know that the task has finished
 		 * the cleanup:
 		 */
-		int ret = (p->futex_state = FUTEX_STATE_DEAD) ? -ESRCH : -EAGAIN;
+		int ret = handle_exit_race(uaddr, uval, p);
 
 		raw_spin_unlock_irq(&p->pi_lock);
 		/*
@@ -1301,7 +1360,7 @@ static int lookup_pi_state(u32 __user *uaddr, u32 uval,
 	 * We are the first waiter - try to look up the owner based on
 	 * @uval and attach to it.
 	 */
-	return attach_to_pi_owner(uval, key, ps, exiting);
+	return attach_to_pi_owner(uaddr, uval, key, ps, exiting);
 }
 
 static int lock_pi_update_atomic(u32 __user *uaddr, u32 uval, u32 newval)
@@ -1417,7 +1476,7 @@ static int futex_lock_pi_atomic(u32 __user *uaddr, struct futex_hash_bucket *hb,
 	 * attach to the owner. If that fails, no harm done, we only
 	 * set the FUTEX_WAITERS bit in the user space variable.
 	 */
-	return attach_to_pi_owner(uval, key, ps, exiting);
+	return attach_to_pi_owner(uaddr, newval, key, ps, exiting);
 }
 
 /**
-- 
2.25.4

