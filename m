Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E072130FA04
	for <lists+stable@lfdr.de>; Thu,  4 Feb 2021 18:45:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238567AbhBDRnu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Feb 2021 12:43:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238587AbhBDRbP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Feb 2021 12:31:15 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ADB3C0617AB
        for <stable@vger.kernel.org>; Thu,  4 Feb 2021 09:29:21 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id u14so3690676wmq.4
        for <stable@vger.kernel.org>; Thu, 04 Feb 2021 09:29:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4ltiq3mCpsTPc6kiuj14O3FHIVaCpAzgI/dn2agPl+o=;
        b=Fn89MqmC90zf8D7DVeJwrNOhXSjtY2uZm9Y3mgGEBtOK9DKxSDTkmi9QwNbuIxsgzh
         Mmm1k3MFzhlbOhz1WSy3JAtms5IlDer9uhwEyWCFTt7CTDjU5WPBFD+whR75roMsvDHk
         +xPBUyTGJ3P2jZ1tdWZAegJBO2KFfDvz6E3h4Ga0VzQzEMO9Yb7KB4yEpbkuEYBSmZ3v
         4UcWzhbfLRgJzCbMjMmsJ2dgoM+okD5TeicEiVNNGWTfZEgPNsg4+DWvtIbM+bK1OJyL
         uBUoaZTbDffqxRQ3hOy2DgOfO3Cr7yMnzADtagY9svTJNobnlHlUmu7RuJ3NMGFjI6OG
         pW1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4ltiq3mCpsTPc6kiuj14O3FHIVaCpAzgI/dn2agPl+o=;
        b=f4Ms8DOtLBTlY0EBfeXSHYU0HeV6wilGIkVlsnuzOrHYrb+dWI/2Hsg1CtoD9cBA7Q
         2F//BCoL4uKV+bhrS4IJLgAQowkr5Qo3oVi1qO+Cp6+9ZFtLQwdo3omB93/FQvlhL67c
         AZeWlOHoWeU3s4J47wB6mgTdwtovMJW2I+3+BMEfjOvkvMES8M4Lf/Zn/O8ySeOSP+wS
         1qG5LOAsK6+sZnSyWIpXY3noygl60YIefWk+qV5sbSr3hS7iZIA4jDv35CONth3zf7gl
         s5jax/5VSQcyvgQWnsUBIBW6eLifAtTWM7b+DmbDzNl5rsMXBaV/kZ4r28X8bUOoMg4m
         Wq8Q==
X-Gm-Message-State: AOAM5328uvavldTT58La7GDGJ5ltRoPaaR8xpRss+rtWEdiKitv9Dad9
        N8BiKkaa0+TO4M2OIU9TPpKYjzazBsNUbg==
X-Google-Smtp-Source: ABdhPJzIx5UPhbabk/d7KmMmGVkGbBAHR6IO3kK6MieBuXCBpRAEJriSJzTgMG+ZiKyd1Rd+jodj5w==
X-Received: by 2002:a05:600c:35d6:: with SMTP id r22mr244546wmq.44.1612459759426;
        Thu, 04 Feb 2021 09:29:19 -0800 (PST)
Received: from dell.default ([91.110.221.188])
        by smtp.gmail.com with ESMTPSA id j7sm9641334wrp.72.2021.02.04.09.29.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Feb 2021 09:29:18 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>, gzobqq@gmail.com,
        Peter Zijlstra <peterz@infradead.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 10/10] futex: Handle faults correctly for PI futexes
Date:   Thu,  4 Feb 2021 17:29:03 +0000
Message-Id: <20210204172903.2860981-11-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210204172903.2860981-1-lee.jones@linaro.org>
References: <20210204172903.2860981-1-lee.jones@linaro.org>
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
index 8300870666638..199e63c5b6120 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -1012,7 +1012,8 @@ static void exit_pi_state_list(struct task_struct *curr)
  *	FUTEX_OWNER_DIED bit. See [4]
  *
  * [10] There is no transient state which leaves owner and user space
- *	TID out of sync.
+ *	TID out of sync. Except one error case where the kernel is denied
+ *	write access to the user address, see fixup_pi_state_owner().
  */
 
 /*
@@ -2357,6 +2358,24 @@ handle_fault:
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
 
@@ -2742,13 +2761,6 @@ retry_private:
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
 
@@ -3053,8 +3065,6 @@ static int futex_wait_requeue_pi(u32 __user *uaddr, unsigned int flags,
 		if (q.pi_state && (q.pi_state->owner != current)) {
 			spin_lock(q.lock_ptr);
 			ret = fixup_pi_state_owner(uaddr2, &q, current);
-			if (ret && rt_mutex_owner(&q.pi_state->pi_mutex) == current)
-				rt_mutex_futex_unlock(&q.pi_state->pi_mutex);
 			/*
 			 * Drop the reference to the pi state which
 			 * the requeue_pi() code acquired for us.
@@ -3091,14 +3101,6 @@ static int futex_wait_requeue_pi(u32 __user *uaddr, unsigned int flags,
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

