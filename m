Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 824EC31363A
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:08:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233142AbhBHPHk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:07:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:52070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231372AbhBHPFO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:05:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 49EDF64EB8;
        Mon,  8 Feb 2021 15:04:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612796641;
        bh=tYuD+bDbpRI6eIWV+xAc5nbsS9ttC9FkoQvorGFiUgY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1Obf9fkswo90thOxLpfT7UwlImJQu0/KTXCmiBn71Ql96Qv1RzmjJy3sSsisD8kT7
         sSiFDhDBiv4iyQybFWctI7cJXC0sQXB9FM1oFMEdZVAb5O0R72VtcMigNnvn9EJeAO
         RqcLdNEDAgHiG7/7dD8gPIUANdoCaR4x3OX2ZZLo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>, gzobqq@gmail.com,
        Thomas Gleixner <tglx@linutronix.de>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4.9 13/43] futex: Handle faults correctly for PI futexes
Date:   Mon,  8 Feb 2021 16:00:39 +0100
Message-Id: <20210208145806.841637635@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210208145806.281758651@linuxfoundation.org>
References: <20210208145806.281758651@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

fixup_pi_state_owner() tries to ensure that the state of the rtmutex,
pi_state and the user space value related to the PI futex are consistent
before returning to user space. In case that the user space value update
faults and the fault cannot be resolved by faulting the page in via
fault_in_user_writeable() the function returns with -EFAULT and leaves
the rtmutex and pi_state owner state inconsistent.

A subsequent futex_unlock_pi() operates on the inconsistent pi_state and
releases the rtmutex despite not owning it which can corrupt the RB tree of
the rtmutex and cause a subsequent kernel stack use after free.

It was suggested to loop forever in fixup_pi_state_owner() if the fault
cannot be resolved, but that results in runaway tasks which is especially
undesired when the problem happens due to a programming error and not due
to malice.

As the user space value cannot be fixed up, the proper solution is to make
the rtmutex and the pi_state consistent so both have the same owner. This
leaves the user space value out of sync. Any subsequent operation on the
futex will fail because the 10th rule of PI futexes (pi_state owner and
user space value are consistent) has been violated.

As a consequence this removes the inept attempts of 'fixing' the situation
in case that the current task owns the rtmutex when returning with an
unresolvable fault by unlocking the rtmutex which left pi_state::owner and
rtmutex::owner out of sync in a different and only slightly less dangerous
way.

Fixes: 1b7558e457ed ("futexes: fix fault handling in futex_lock_pi")
Reported-by: gzobqq@gmail.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/futex.c |   38 ++++++++++++++++++++------------------
 1 file changed, 20 insertions(+), 18 deletions(-)

--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -1017,7 +1017,8 @@ static void exit_pi_state_list(struct ta
  *	FUTEX_OWNER_DIED bit. See [4]
  *
  * [10] There is no transient state which leaves owner and user space
- *	TID out of sync.
+ *	TID out of sync. Except one error case where the kernel is denied
+ *	write access to the user address, see fixup_pi_state_owner().
  */
 
 /*
@@ -2392,6 +2393,24 @@ handle_fault:
 	if (!err)
 		goto retry;
 
+	/*
+	 * fault_in_user_writeable() failed so user state is immutable. At
+	 * best we can make the kernel state consistent but user state will
+	 * be most likely hosed and any subsequent unlock operation will be
+	 * rejected due to PI futex rule [10].
+	 *
+	 * Ensure that the rtmutex owner is also the pi_state owner despite
+	 * the user space value claiming something different. There is no
+	 * point in unlocking the rtmutex if current is the owner as it
+	 * would need to wait until the next waiter has taken the rtmutex
+	 * to guarantee consistent state. Keep it simple. Userspace asked
+	 * for this wreckaged state.
+	 *
+	 * The rtmutex has an owner - either current or some other
+	 * task. See the EAGAIN loop above.
+	 */
+	pi_state_update_owner(pi_state, rt_mutex_owner(&pi_state->pi_mutex));
+
 	return err;
 }
 
@@ -2777,13 +2796,6 @@ retry_private:
 	if (res)
 		ret = (res < 0) ? res : 0;
 
-	/*
-	 * If fixup_owner() faulted and was unable to handle the fault, unlock
-	 * it and return the fault to userspace.
-	 */
-	if (ret && (rt_mutex_owner(&q.pi_state->pi_mutex) == current))
-		rt_mutex_futex_unlock(&q.pi_state->pi_mutex);
-
 	/* Unqueue and drop the lock */
 	unqueue_me_pi(&q);
 
@@ -3088,8 +3100,6 @@ static int futex_wait_requeue_pi(u32 __u
 		if (q.pi_state && (q.pi_state->owner != current)) {
 			spin_lock(q.lock_ptr);
 			ret = fixup_pi_state_owner(uaddr2, &q, current);
-			if (ret && rt_mutex_owner(&q.pi_state->pi_mutex) == current)
-				rt_mutex_futex_unlock(&q.pi_state->pi_mutex);
 			/*
 			 * Drop the reference to the pi state which
 			 * the requeue_pi() code acquired for us.
@@ -3126,14 +3136,6 @@ static int futex_wait_requeue_pi(u32 __u
 		if (res)
 			ret = (res < 0) ? res : 0;
 
-		/*
-		 * If fixup_pi_state_owner() faulted and was unable to handle
-		 * the fault, unlock the rt_mutex and return the fault to
-		 * userspace.
-		 */
-		if (ret && rt_mutex_owner(pi_mutex) == current)
-			rt_mutex_futex_unlock(pi_mutex);
-
 		/* Unqueue and drop the lock. */
 		unqueue_me_pi(&q);
 	}


