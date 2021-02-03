Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12E0C30DBB5
	for <lists+stable@lfdr.de>; Wed,  3 Feb 2021 14:48:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232207AbhBCNrr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Feb 2021 08:47:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232170AbhBCNrW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Feb 2021 08:47:22 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 023F0C0617A7
        for <stable@vger.kernel.org>; Wed,  3 Feb 2021 05:46:00 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id q7so24334537wre.13
        for <stable@vger.kernel.org>; Wed, 03 Feb 2021 05:45:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IefE4HShlaoESIdM7PNGNW8PHMR5MUG9Lc5XYbz4i4Y=;
        b=WrgYDPQPnfNK7+xWMP9tR8smGsyoEmixcR5cw0OSFJjhJKKGmmDkwZ2vTxVPfwT+lW
         wkI7gJ1NAoUiAhxreUbMeBfON7XMjR/Gxm8xCjt+fmhupIj9piTXn6tj8/L8Ow60h4P1
         vAV6Bi7yNnigvzIDi9CFbtygT5Kaga0nUq91aZ96v4TkZqUuhIFgXavto0/Q/q4NkFL5
         wKMU+BIzBIrzGyG6JBMiIiVGEF3CTNdMZe26XBMSPS/Ix0oD/xxvguqC0SYPhHqpEgA4
         emLiYtaAA9bv/m7K8e7E4/IfTsjrElVKWdsRPX/aDlrprbbNmarsKeuQVp5axahba/Nt
         jLTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IefE4HShlaoESIdM7PNGNW8PHMR5MUG9Lc5XYbz4i4Y=;
        b=hPVC7lqx/6v7CjGmlelYqpk1AHRg/PtSli+O8oe6pmsh0LMRJL4UXBV15dkdT32ozR
         At68TeDBXgK2p9PSXPNmp3+GM54iIOaQdHGHvGvs82yV2zFpV30hdyVIrCj4L7Khg8DL
         T2cwED22aNWYRtVmoOoHRPVGHYcZd+paCgI4AovQN+vWElEcBu4fY+hDW1vrdOSpy6ni
         z/0Va5YvxXs9yBWiGKplwrQoXXBN7p8b3ISK8/wkA9vs7pNOmIQjCjNxI0zca24L463n
         52Eoo0tzOZQRYPf/cN/H6TatRJg9pdjpxCsMBM+wo1IMcaT8nwMepbkDj2njagJBQVRc
         nCWw==
X-Gm-Message-State: AOAM533MVv9N1FzXtQDB3/nPF0YyylXmRg39ftAQs/XCkNbZMJVaTdSX
        56MCOXPkkzZ072+2Phr5eVeMHm674VgxaQ==
X-Google-Smtp-Source: ABdhPJw6rPyAK60QZgWtGjIO7wmjQJS6hJU+otS6GBDUlj7OxCB4kr8gZEDK9Hx2OPaI2MmQs8aXQA==
X-Received: by 2002:a05:6000:1788:: with SMTP id e8mr3657643wrg.171.1612359958406;
        Wed, 03 Feb 2021 05:45:58 -0800 (PST)
Received: from dell.default ([91.110.221.188])
        by smtp.gmail.com with ESMTPSA id r124sm2867900wmr.16.2021.02.03.05.45.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Feb 2021 05:45:57 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>, gzobqq@gmail.com,
        Peter Zijlstra <peterz@infradead.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 10/10] futex: Handle faults correctly for PI futexes
Date:   Wed,  3 Feb 2021 13:45:39 +0000
Message-Id: <20210203134539.2583943-11-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210203134539.2583943-1-lee.jones@linaro.org>
References: <20210203134539.2583943-1-lee.jones@linaro.org>
MIME-Version: 1.0
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
---
 kernel/futex.c | 38 ++++++++++++++++++++------------------
 1 file changed, 20 insertions(+), 18 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index c163f5d6efab3..83db5787c67ef 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -1017,7 +1017,8 @@ static void exit_pi_state_list(struct task_struct *curr)
  *	FUTEX_OWNER_DIED bit. See [4]
  *
  * [10] There is no transient state which leaves owner and user space
- *	TID out of sync.
+ *	TID out of sync. Except one error case where the kernel is denied
+ *	write access to the user address, see fixup_pi_state_owner().
  */
 
 /*
@@ -2392,6 +2393,24 @@ static int __fixup_pi_state_owner(u32 __user *uaddr, struct futex_q *q,
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
 
@@ -2777,13 +2796,6 @@ static int futex_lock_pi(u32 __user *uaddr, unsigned int flags,
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
 
@@ -3088,8 +3100,6 @@ static int futex_wait_requeue_pi(u32 __user *uaddr, unsigned int flags,
 		if (q.pi_state && (q.pi_state->owner != current)) {
 			spin_lock(q.lock_ptr);
 			ret = fixup_pi_state_owner(uaddr2, &q, current);
-			if (ret && rt_mutex_owner(&q.pi_state->pi_mutex) == current)
-				rt_mutex_futex_unlock(&q.pi_state->pi_mutex);
 			/*
 			 * Drop the reference to the pi state which
 			 * the requeue_pi() code acquired for us.
@@ -3126,14 +3136,6 @@ static int futex_wait_requeue_pi(u32 __user *uaddr, unsigned int flags,
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
-- 
2.25.1

