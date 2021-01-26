Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AD54304C17
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 23:28:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726984AbhAZWAh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 17:00:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732804AbhAZUFl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Jan 2021 15:05:41 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E512EC06174A;
        Tue, 26 Jan 2021 12:05:00 -0800 (PST)
Date:   Tue, 26 Jan 2021 20:04:56 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1611691499;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:  content-transfer-encoding:content-transfer-encoding;
        bh=HtIeBZJqaB6A3Fe/sSFD5TYQ0kbhWPKpRSzBCSyGDcE=;
        b=DHtMGpUWjYeQFl97IiD8HBl2RQZQPWaoqmWjOrsSxBAaGnTErGYvP7u86rP+D0/tLoBmeT
        R3FOIJA12mIMkPpezGv1Xoxq3pD7sTZMmKcdHxO+9trB2qB7ybMx8AudUkhtkBBZG6duSd
        Er1j8VP6TSvLTnkPW5jMHPts6/7pr/tSjm1prYipyALHYWKSQEDLmIqY+cdigxeAbGfhAy
        QS8jLOx3n0VQan/Na6RrYy22OBZL8vcWvGXNLMlbIfm4u0TB/FchYLbfEdSH5K1S/e1pX1
        1hplc2WWrGc0M05Zc7814QAsQ+rF0S86gW9D6p9OO3Ix2fjtsAAMHKVdTvsa6g==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1611691499;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:  content-transfer-encoding:content-transfer-encoding;
        bh=HtIeBZJqaB6A3Fe/sSFD5TYQ0kbhWPKpRSzBCSyGDcE=;
        b=6yZ3rcq5Ip1v57/zF7MRFBegPxF9kncrTdJSBbaFB7Rn+4ifLZ0a3DOJqCiwSeq1fDjCVR
        NkoGF55oyMqKdOBA==
From:   "tip-bot2 for Thomas Gleixner" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: locking/urgent] rtmutex: Remove unused argument from
 rt_mutex_proxy_unlock()
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        stable@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
MIME-Version: 1.0
Message-ID: <161169149688.414.3915277479657147549.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the locking/urgent branch of tip:

Commit-ID:     2156ac1934166d6deb6cd0f6ffc4c1076ec63697
Gitweb:        https://git.kernel.org/tip/2156ac1934166d6deb6cd0f6ffc4c1076ec63697
Author:        Thomas Gleixner <tglx@linutronix.de>
AuthorDate:    Wed, 20 Jan 2021 11:32:07 +01:00
Committer:     Thomas Gleixner <tglx@linutronix.de>
CommitterDate: Tue, 26 Jan 2021 15:10:58 +01:00

rtmutex: Remove unused argument from rt_mutex_proxy_unlock()

Nothing uses the argument. Remove it as preparation to use
pi_state_update_owner().

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
---
 kernel/futex.c                  | 2 +-
 kernel/locking/rtmutex.c        | 3 +--
 kernel/locking/rtmutex_common.h | 3 +--
 3 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index 7837f9e..cfca221 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -818,7 +818,7 @@ static void put_pi_state(struct futex_pi_state *pi_state)
 			list_del_init(&pi_state->list);
 			raw_spin_unlock(&owner->pi_lock);
 		}
-		rt_mutex_proxy_unlock(&pi_state->pi_mutex, owner);
+		rt_mutex_proxy_unlock(&pi_state->pi_mutex);
 		raw_spin_unlock_irqrestore(&pi_state->pi_mutex.wait_lock, flags);
 	}
 
diff --git a/kernel/locking/rtmutex.c b/kernel/locking/rtmutex.c
index cfdd5b9..2f8cd61 100644
--- a/kernel/locking/rtmutex.c
+++ b/kernel/locking/rtmutex.c
@@ -1716,8 +1716,7 @@ void rt_mutex_init_proxy_locked(struct rt_mutex *lock,
  * possible because it belongs to the pi_state which is about to be freed
  * and it is not longer visible to other tasks.
  */
-void rt_mutex_proxy_unlock(struct rt_mutex *lock,
-			   struct task_struct *proxy_owner)
+void rt_mutex_proxy_unlock(struct rt_mutex *lock)
 {
 	debug_rt_mutex_proxy_unlock(lock);
 	rt_mutex_set_owner(lock, NULL);
diff --git a/kernel/locking/rtmutex_common.h b/kernel/locking/rtmutex_common.h
index d1d62f9..ca6fb48 100644
--- a/kernel/locking/rtmutex_common.h
+++ b/kernel/locking/rtmutex_common.h
@@ -133,8 +133,7 @@ enum rtmutex_chainwalk {
 extern struct task_struct *rt_mutex_next_owner(struct rt_mutex *lock);
 extern void rt_mutex_init_proxy_locked(struct rt_mutex *lock,
 				       struct task_struct *proxy_owner);
-extern void rt_mutex_proxy_unlock(struct rt_mutex *lock,
-				  struct task_struct *proxy_owner);
+extern void rt_mutex_proxy_unlock(struct rt_mutex *lock);
 extern void rt_mutex_init_waiter(struct rt_mutex_waiter *waiter);
 extern int __rt_mutex_start_proxy_lock(struct rt_mutex *lock,
 				     struct rt_mutex_waiter *waiter,
