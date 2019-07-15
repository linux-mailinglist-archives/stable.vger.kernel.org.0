Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D36F768C40
	for <lists+stable@lfdr.de>; Mon, 15 Jul 2019 15:50:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731312AbfGONuU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jul 2019 09:50:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:39854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731499AbfGONuP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Jul 2019 09:50:15 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2180F20651;
        Mon, 15 Jul 2019 13:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563198615;
        bh=cjpjSj3AzXuiVMQMLaBnrsknvjiXP7O8xE/5/piMkb4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dcjEKe6qWdHDEveonRouRlsAiHT6sW/8rUDCSoubzfqwZMeNANOdfCOn2eo6z1AGB
         FaQ8DALNE4UMiuQM3bVqsLor9LFW22f4AfUTH7f6bGJpaUwRjWzXfmxLj2l4EoltGs
         lqoB8rVmJaaSjMOSONci73qr2Wsdt9mSyMlITzR0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Imre Deak <imre.deak@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Will Deacon <will.deacon@arm.com>,
        ville.syrjala@linux.intel.com, Ingo Molnar <mingo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.2 060/249] locking/lockdep: Fix OOO unlock when hlocks need merging
Date:   Mon, 15 Jul 2019 09:43:45 -0400
Message-Id: <20190715134655.4076-60-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715134655.4076-1-sashal@kernel.org>
References: <20190715134655.4076-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Imre Deak <imre.deak@intel.com>

[ Upstream commit 8c8889d8eaf4501ae4aaf870b6f8f55db5d5109a ]

The sequence

	static DEFINE_WW_CLASS(test_ww_class);

	struct ww_acquire_ctx ww_ctx;
	struct ww_mutex ww_lock_a;
	struct ww_mutex ww_lock_b;
	struct mutex lock_c;
	struct mutex lock_d;

	ww_acquire_init(&ww_ctx, &test_ww_class);

	ww_mutex_init(&ww_lock_a, &test_ww_class);
	ww_mutex_init(&ww_lock_b, &test_ww_class);

	mutex_init(&lock_c);

	ww_mutex_lock(&ww_lock_a, &ww_ctx);

	mutex_lock(&lock_c);

	ww_mutex_lock(&ww_lock_b, &ww_ctx);

	mutex_unlock(&lock_c);		(*)

	ww_mutex_unlock(&ww_lock_b);
	ww_mutex_unlock(&ww_lock_a);

	ww_acquire_fini(&ww_ctx);

triggers the following WARN in __lock_release() when doing the unlock at *:

	DEBUG_LOCKS_WARN_ON(curr->lockdep_depth != depth - 1);

The problem is that the WARN check doesn't take into account the merging
of ww_lock_a and ww_lock_b which results in decreasing curr->lockdep_depth
by 2 not only 1.

Note that the following sequence doesn't trigger the WARN, since there
won't be any hlock merging.

	ww_acquire_init(&ww_ctx, &test_ww_class);

	ww_mutex_init(&ww_lock_a, &test_ww_class);
	ww_mutex_init(&ww_lock_b, &test_ww_class);

	mutex_init(&lock_c);
	mutex_init(&lock_d);

	ww_mutex_lock(&ww_lock_a, &ww_ctx);

	mutex_lock(&lock_c);
	mutex_lock(&lock_d);

	ww_mutex_lock(&ww_lock_b, &ww_ctx);

	mutex_unlock(&lock_d);

	ww_mutex_unlock(&ww_lock_b);
	ww_mutex_unlock(&ww_lock_a);

	mutex_unlock(&lock_c);

	ww_acquire_fini(&ww_ctx);

In general both of the above two sequences are valid and shouldn't
trigger any lockdep warning.

Fix this by taking the decrement due to the hlock merging into account
during lock release and hlock class re-setting. Merging can't happen
during lock downgrading since there won't be a new possibility to merge
hlocks in that case, so add a WARN if merging still happens then.

Signed-off-by: Imre Deak <imre.deak@intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will.deacon@arm.com>
Cc: ville.syrjala@linux.intel.com
Link: https://lkml.kernel.org/r/20190524201509.9199-1-imre.deak@intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/locking/lockdep.c | 41 ++++++++++++++++++++++++++++------------
 1 file changed, 29 insertions(+), 12 deletions(-)

diff --git a/kernel/locking/lockdep.c b/kernel/locking/lockdep.c
index c47788fa85f9..82361e1bce0f 100644
--- a/kernel/locking/lockdep.c
+++ b/kernel/locking/lockdep.c
@@ -3715,7 +3715,7 @@ static int __lock_acquire(struct lockdep_map *lock, unsigned int subclass,
 				hlock->references = 2;
 			}
 
-			return 1;
+			return 2;
 		}
 	}
 
@@ -3921,22 +3921,33 @@ static struct held_lock *find_held_lock(struct task_struct *curr,
 }
 
 static int reacquire_held_locks(struct task_struct *curr, unsigned int depth,
-			      int idx)
+				int idx, unsigned int *merged)
 {
 	struct held_lock *hlock;
+	int first_idx = idx;
 
 	if (DEBUG_LOCKS_WARN_ON(!irqs_disabled()))
 		return 0;
 
 	for (hlock = curr->held_locks + idx; idx < depth; idx++, hlock++) {
-		if (!__lock_acquire(hlock->instance,
+		switch (__lock_acquire(hlock->instance,
 				    hlock_class(hlock)->subclass,
 				    hlock->trylock,
 				    hlock->read, hlock->check,
 				    hlock->hardirqs_off,
 				    hlock->nest_lock, hlock->acquire_ip,
-				    hlock->references, hlock->pin_count))
+				    hlock->references, hlock->pin_count)) {
+		case 0:
 			return 1;
+		case 1:
+			break;
+		case 2:
+			*merged += (idx == first_idx);
+			break;
+		default:
+			WARN_ON(1);
+			return 0;
+		}
 	}
 	return 0;
 }
@@ -3947,9 +3958,9 @@ __lock_set_class(struct lockdep_map *lock, const char *name,
 		 unsigned long ip)
 {
 	struct task_struct *curr = current;
+	unsigned int depth, merged = 0;
 	struct held_lock *hlock;
 	struct lock_class *class;
-	unsigned int depth;
 	int i;
 
 	if (unlikely(!debug_locks))
@@ -3974,14 +3985,14 @@ __lock_set_class(struct lockdep_map *lock, const char *name,
 	curr->lockdep_depth = i;
 	curr->curr_chain_key = hlock->prev_chain_key;
 
-	if (reacquire_held_locks(curr, depth, i))
+	if (reacquire_held_locks(curr, depth, i, &merged))
 		return 0;
 
 	/*
 	 * I took it apart and put it back together again, except now I have
 	 * these 'spare' parts.. where shall I put them.
 	 */
-	if (DEBUG_LOCKS_WARN_ON(curr->lockdep_depth != depth))
+	if (DEBUG_LOCKS_WARN_ON(curr->lockdep_depth != depth - merged))
 		return 0;
 	return 1;
 }
@@ -3989,8 +4000,8 @@ __lock_set_class(struct lockdep_map *lock, const char *name,
 static int __lock_downgrade(struct lockdep_map *lock, unsigned long ip)
 {
 	struct task_struct *curr = current;
+	unsigned int depth, merged = 0;
 	struct held_lock *hlock;
-	unsigned int depth;
 	int i;
 
 	if (unlikely(!debug_locks))
@@ -4015,7 +4026,11 @@ static int __lock_downgrade(struct lockdep_map *lock, unsigned long ip)
 	hlock->read = 1;
 	hlock->acquire_ip = ip;
 
-	if (reacquire_held_locks(curr, depth, i))
+	if (reacquire_held_locks(curr, depth, i, &merged))
+		return 0;
+
+	/* Merging can't happen with unchanged classes.. */
+	if (DEBUG_LOCKS_WARN_ON(merged))
 		return 0;
 
 	/*
@@ -4024,6 +4039,7 @@ static int __lock_downgrade(struct lockdep_map *lock, unsigned long ip)
 	 */
 	if (DEBUG_LOCKS_WARN_ON(curr->lockdep_depth != depth))
 		return 0;
+
 	return 1;
 }
 
@@ -4038,8 +4054,8 @@ static int
 __lock_release(struct lockdep_map *lock, int nested, unsigned long ip)
 {
 	struct task_struct *curr = current;
+	unsigned int depth, merged = 1;
 	struct held_lock *hlock;
-	unsigned int depth;
 	int i;
 
 	if (unlikely(!debug_locks))
@@ -4094,14 +4110,15 @@ __lock_release(struct lockdep_map *lock, int nested, unsigned long ip)
 	if (i == depth-1)
 		return 1;
 
-	if (reacquire_held_locks(curr, depth, i + 1))
+	if (reacquire_held_locks(curr, depth, i + 1, &merged))
 		return 0;
 
 	/*
 	 * We had N bottles of beer on the wall, we drank one, but now
 	 * there's not N-1 bottles of beer left on the wall...
+	 * Pouring two of the bottles together is acceptable.
 	 */
-	DEBUG_LOCKS_WARN_ON(curr->lockdep_depth != depth-1);
+	DEBUG_LOCKS_WARN_ON(curr->lockdep_depth != depth - merged);
 
 	/*
 	 * Since reacquire_held_locks() would have called check_chain_key()
-- 
2.20.1

