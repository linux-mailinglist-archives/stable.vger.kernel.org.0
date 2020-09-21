Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0659F272F35
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:55:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728995AbgIUQzR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:55:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:51950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729545AbgIUQpv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:45:51 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D5BB1206B2;
        Mon, 21 Sep 2020 16:45:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706750;
        bh=vz1A1EnTnmnq+dGFZvksYIJn6ajb2NEqlTRsLvXgmQw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JCjg7hCyn+77axqEdEYRhOWsLEFuLhhEWMXgL8N2JWr3OWEpOb8joomrGw5VOTKY6
         FfPqjKcmH5IgMjtbI8KcWWlT0CFOvcH4wTzplz+X5dX7FWXrWhm2MarvEbg1AXkVUz
         O5fjoa4eWCfTFvqOLhUWgUMow5Dt4ZmD4Lv4SbII=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 079/118] locking/lockdep: Fix "USED" <- "IN-NMI" inversions
Date:   Mon, 21 Sep 2020 18:28:11 +0200
Message-Id: <20200921162040.010637032@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921162036.324813383@linuxfoundation.org>
References: <20200921162036.324813383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: peterz@infradead.org <peterz@infradead.org>

[ Upstream commit 23870f1227680d2aacff6f79c3ab2222bd04e86e ]

During the LPC RCU BoF Paul asked how come the "USED" <- "IN-NMI"
detector doesn't trip over rcu_read_lock()'s lockdep annotation.

Looking into this I found a very embarrasing typo in
verify_lock_unused():

	-	if (!(class->usage_mask & LOCK_USED))
	+	if (!(class->usage_mask & LOCKF_USED))

fixing that will indeed cause rcu_read_lock() to insta-splat :/

The above typo means that instead of testing for: 0x100 (1 <<
LOCK_USED), we test for 8 (LOCK_USED), which corresponds to (1 <<
LOCK_ENABLED_HARDIRQ).

So instead of testing for _any_ used lock, it will only match any lock
used with interrupts enabled.

The rcu_read_lock() annotation uses .check=0, which means it will not
set any of the interrupt bits and will thus never match.

In order to properly fix the situation and allow rcu_read_lock() to
correctly work, split LOCK_USED into LOCK_USED and LOCK_USED_READ and by
having .read users set USED_READ and test USED, pure read-recursive
locks are permitted.

Fixes: f6f48e180404 ("lockdep: Teach lockdep about "USED" <- "IN-NMI" inversions")
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Tested-by: Masami Hiramatsu <mhiramat@kernel.org>
Acked-by: Paul E. McKenney <paulmck@kernel.org>
Link: https://lore.kernel.org/r/20200902160323.GK1362448@hirez.programming.kicks-ass.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/locking/lockdep.c           | 35 +++++++++++++++++++++++++-----
 kernel/locking/lockdep_internals.h |  2 ++
 2 files changed, 31 insertions(+), 6 deletions(-)

diff --git a/kernel/locking/lockdep.c b/kernel/locking/lockdep.c
index 29a8de4c50b90..a611dedac7d60 100644
--- a/kernel/locking/lockdep.c
+++ b/kernel/locking/lockdep.c
@@ -3923,13 +3923,18 @@ static int separate_irq_context(struct task_struct *curr,
 static int mark_lock(struct task_struct *curr, struct held_lock *this,
 			     enum lock_usage_bit new_bit)
 {
-	unsigned int new_mask = 1 << new_bit, ret = 1;
+	unsigned int old_mask, new_mask, ret = 1;
 
 	if (new_bit >= LOCK_USAGE_STATES) {
 		DEBUG_LOCKS_WARN_ON(1);
 		return 0;
 	}
 
+	if (new_bit == LOCK_USED && this->read)
+		new_bit = LOCK_USED_READ;
+
+	new_mask = 1 << new_bit;
+
 	/*
 	 * If already set then do not dirty the cacheline,
 	 * nor do any checks:
@@ -3942,13 +3947,22 @@ static int mark_lock(struct task_struct *curr, struct held_lock *this,
 	/*
 	 * Make sure we didn't race:
 	 */
-	if (unlikely(hlock_class(this)->usage_mask & new_mask)) {
-		graph_unlock();
-		return 1;
-	}
+	if (unlikely(hlock_class(this)->usage_mask & new_mask))
+		goto unlock;
 
+	old_mask = hlock_class(this)->usage_mask;
 	hlock_class(this)->usage_mask |= new_mask;
 
+	/*
+	 * Save one usage_traces[] entry and map both LOCK_USED and
+	 * LOCK_USED_READ onto the same entry.
+	 */
+	if (new_bit == LOCK_USED || new_bit == LOCK_USED_READ) {
+		if (old_mask & (LOCKF_USED | LOCKF_USED_READ))
+			goto unlock;
+		new_bit = LOCK_USED;
+	}
+
 	if (!(hlock_class(this)->usage_traces[new_bit] = save_trace()))
 		return 0;
 
@@ -3962,6 +3976,7 @@ static int mark_lock(struct task_struct *curr, struct held_lock *this,
 			return 0;
 	}
 
+unlock:
 	graph_unlock();
 
 	/*
@@ -4896,12 +4911,20 @@ static void verify_lock_unused(struct lockdep_map *lock, struct held_lock *hlock
 {
 #ifdef CONFIG_PROVE_LOCKING
 	struct lock_class *class = look_up_lock_class(lock, subclass);
+	unsigned long mask = LOCKF_USED;
 
 	/* if it doesn't have a class (yet), it certainly hasn't been used yet */
 	if (!class)
 		return;
 
-	if (!(class->usage_mask & LOCK_USED))
+	/*
+	 * READ locks only conflict with USED, such that if we only ever use
+	 * READ locks, there is no deadlock possible -- RCU.
+	 */
+	if (!hlock->read)
+		mask |= LOCKF_USED_READ;
+
+	if (!(class->usage_mask & mask))
 		return;
 
 	hlock->class_idx = class - lock_classes;
diff --git a/kernel/locking/lockdep_internals.h b/kernel/locking/lockdep_internals.h
index baca699b94e91..b0be1560ed17a 100644
--- a/kernel/locking/lockdep_internals.h
+++ b/kernel/locking/lockdep_internals.h
@@ -19,6 +19,7 @@ enum lock_usage_bit {
 #include "lockdep_states.h"
 #undef LOCKDEP_STATE
 	LOCK_USED,
+	LOCK_USED_READ,
 	LOCK_USAGE_STATES
 };
 
@@ -40,6 +41,7 @@ enum {
 #include "lockdep_states.h"
 #undef LOCKDEP_STATE
 	__LOCKF(USED)
+	__LOCKF(USED_READ)
 };
 
 #define LOCKDEP_STATE(__STATE)	LOCKF_ENABLED_##__STATE |
-- 
2.25.1



