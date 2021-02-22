Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3BF0321794
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 13:52:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231684AbhBVMus (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 07:50:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:56544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231577AbhBVMqu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Feb 2021 07:46:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9CD4F64F19;
        Mon, 22 Feb 2021 12:42:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613997724;
        bh=mKXWVJIySyeW2DYR2GVsYxGB4eiFh5S/De1yxyxounQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Tu7Cva7zYX2GytBWsHZ9+s1Jt0BaI5RfcAMO6APmrCDqHUIWjVs94APUMxLrYOyGU
         9cA4H9TrDHr5z8VfxcDVJi1Hp7vTpMZxFhAz73rU7BgM5jsmgkIILtWoW4hG7IViqm
         isTqV694ljpfo2/9LkoiNu03uldNwKXYALqKfrxI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4.9 13/49] futex: Ensure the correct return value from futex_lock_pi()
Date:   Mon, 22 Feb 2021 13:36:11 +0100
Message-Id: <20210222121025.806830758@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210222121022.546148341@linuxfoundation.org>
References: <20210222121022.546148341@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

commit 12bb3f7f1b03d5913b3f9d4236a488aa7774dfe9 upstream

In case that futex_lock_pi() was aborted by a signal or a timeout and the
task returned without acquiring the rtmutex, but is the designated owner of
the futex due to a concurrent futex_unlock_pi() fixup_owner() is invoked to
establish consistent state. In that case it invokes fixup_pi_state_owner()
which in turn tries to acquire the rtmutex again. If that succeeds then it
does not propagate this success to fixup_owner() and futex_lock_pi()
returns -EINTR or -ETIMEOUT despite having the futex locked.

Return success from fixup_pi_state_owner() in all cases where the current
task owns the rtmutex and therefore the futex and propagate it correctly
through fixup_owner(). Fixup the other callsite which does not expect a
positive return value.

Fixes: c1e2f0eaf015 ("futex: Avoid violating the 10th rule of futex")
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[Lee: Back-ported in support of a previous futex attempt]
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/futex.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -2322,7 +2322,7 @@ retry:
 		}
 
 		if (__rt_mutex_futex_trylock(&pi_state->pi_mutex)) {
-			/* We got the lock after all, nothing to fix. */
+			/* We got the lock. pi_state is correct. Tell caller. */
 			return 1;
 		}
 
@@ -2364,7 +2364,7 @@ retry:
 	 */
 	pi_state_update_owner(pi_state, newowner);
 
-	return 0;
+	return argowner == current;
 
 	/*
 	 * To handle the page fault we need to drop the hash bucket
@@ -2447,8 +2447,6 @@ static long futex_wait_restart(struct re
  */
 static int fixup_owner(u32 __user *uaddr, struct futex_q *q, int locked)
 {
-	int ret = 0;
-
 	if (locked) {
 		/*
 		 * Got the lock. We might not be the anticipated owner if we
@@ -2459,8 +2457,8 @@ static int fixup_owner(u32 __user *uaddr
 		 * stable state, anything else needs more attention.
 		 */
 		if (q->pi_state->owner != current)
-			ret = fixup_pi_state_owner(uaddr, q, current);
-		goto out;
+			return fixup_pi_state_owner(uaddr, q, current);
+		return 1;
 	}
 
 	/*
@@ -2471,10 +2469,8 @@ static int fixup_owner(u32 __user *uaddr
 	 * Another speculative read; pi_state->owner == current is unstable
 	 * but needs our attention.
 	 */
-	if (q->pi_state->owner == current) {
-		ret = fixup_pi_state_owner(uaddr, q, NULL);
-		goto out;
-	}
+	if (q->pi_state->owner == current)
+		return fixup_pi_state_owner(uaddr, q, NULL);
 
 	/*
 	 * Paranoia check. If we did not take the lock, then we should not be
@@ -2483,8 +2479,7 @@ static int fixup_owner(u32 __user *uaddr
 	if (WARN_ON_ONCE(rt_mutex_owner(&q->pi_state->pi_mutex) == current))
 		return fixup_pi_state_owner(uaddr, q, current);
 
-out:
-	return ret ? ret : locked;
+	return 0;
 }
 
 /**
@@ -3106,6 +3101,11 @@ static int futex_wait_requeue_pi(u32 __u
 			 */
 			put_pi_state(q.pi_state);
 			spin_unlock(q.lock_ptr);
+			/*
+			 * Adjust the return value. It's either -EFAULT or
+			 * success (1) but the caller expects 0 for success.
+			 */
+			ret = ret < 0 ? ret : 0;
 		}
 	} else {
 		struct rt_mutex *pi_mutex;


