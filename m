Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3104932B2B9
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:49:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343945AbhCCAx5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:53:57 -0500
Received: from ex13-edg-ou-002.vmware.com ([208.91.0.190]:15111 "EHLO
        EX13-EDG-OU-002.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1350530AbhCBUGA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Mar 2021 15:06:00 -0500
X-Greylist: delayed 970 seconds by postgrey-1.27 at vger.kernel.org; Tue, 02 Mar 2021 15:06:00 EST
Received: from sc9-mailhost2.vmware.com (10.113.161.72) by
 EX13-EDG-OU-002.vmware.com (10.113.208.156) with Microsoft SMTP Server id
 15.0.1156.6; Tue, 2 Mar 2021 11:47:56 -0800
Received: from ubuntu.localdomain (unknown [10.109.144.252])
        by sc9-mailhost2.vmware.com (Postfix) with ESMTP id 064FD207CE;
        Tue,  2 Mar 2021 11:47:51 -0800 (PST)
From:   Sharan Turlapati <sturlapati@vmware.com>
To:     <stable@vger.kernel.org>
CC:     <gregkh@linuxfoundation.org>, <lee.jones@linaro.org>,
        <srivatsab@vmware.com>, <srivatsa@csail.mit.edu>,
        <amakhalov@vmware.com>, <srinidhir@vmware.com>,
        <bvikas@vmware.com>, <anishs@vmware.com>, <vsirnapalli@vmware.com>,
        <akaher@vmware.com>
Subject: [PATCH v4.4.y] futex: Ensure the correct return value from futex_lock_pi()
Date:   Tue, 2 Mar 2021 11:47:49 -0800
Message-ID: <20210302194749.82945-1-sturlapati@vmware.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
Received-SPF: None (EX13-EDG-OU-002.vmware.com: sturlapati@vmware.com does not
 designate permitted sender hosts)
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
[Sharan: Backported patch for kernel 4.4.y. Also folded in is a part
 of the cleanup patch d7c5ed73b19c("futex: Remove needless goto's")]
Signed-off-by: Sharan Turlapati <sturlapati@vmware.com>
---
 kernel/futex.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index 199e63c5b612..49cd9f6316e5 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -2287,7 +2287,7 @@ retry:
 		}
 
 		if (__rt_mutex_futex_trylock(&pi_state->pi_mutex)) {
-			/* We got the lock after all, nothing to fix. */
+			/* We got the lock. pi_state is correct. Tell caller */
 			return 1;
 		}
 
@@ -2329,7 +2329,7 @@ retry:
 	 */
 	pi_state_update_owner(pi_state, newowner);
 
-	return 0;
+	return argowner == current;
 
 	/*
 	 * To handle the page fault we need to drop the hash bucket
@@ -2412,8 +2412,6 @@ static long futex_wait_restart(struct restart_block *restart);
  */
 static int fixup_owner(u32 __user *uaddr, struct futex_q *q, int locked)
 {
-	int ret = 0;
-
 	if (locked) {
 		/*
 		 * Got the lock. We might not be the anticipated owner if we
@@ -2424,8 +2422,8 @@ static int fixup_owner(u32 __user *uaddr, struct futex_q *q, int locked)
 		 * stable state, anything else needs more attention.
 		 */
 		if (q->pi_state->owner != current)
-			ret = fixup_pi_state_owner(uaddr, q, current);
-		goto out;
+			return fixup_pi_state_owner(uaddr, q, current);
+		return 1;
 	}
 
 	/*
@@ -2436,10 +2434,8 @@ static int fixup_owner(u32 __user *uaddr, struct futex_q *q, int locked)
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
@@ -2448,8 +2444,7 @@ static int fixup_owner(u32 __user *uaddr, struct futex_q *q, int locked)
 	if (WARN_ON_ONCE(rt_mutex_owner(&q->pi_state->pi_mutex) == current))
 		return fixup_pi_state_owner(uaddr, q, current);
 
-out:
-	return ret ? ret : locked;
+	return 0;
 }
 
 /**
@@ -3071,6 +3066,11 @@ static int futex_wait_requeue_pi(u32 __user *uaddr, unsigned int flags,
 			 */
 			free_pi_state(q.pi_state);
 			spin_unlock(q.lock_ptr);
+			/*
+			 * Adjust the return value. It's either -EFAULT or
+			 * success (1) but the caller expects 0 for success.
+			 */
+			ret = ret < 0 ? ret : 0;
 		}
 	} else {
 		struct rt_mutex *pi_mutex;
-- 
2.28.0

