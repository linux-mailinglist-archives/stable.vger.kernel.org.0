Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD17529B6B7
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:32:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1797573AbgJ0PYW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:24:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:39520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1797567AbgJ0PYR (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:24:17 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 454C32064B;
        Tue, 27 Oct 2020 15:24:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812256;
        bh=dQEcMIBawyy0i6yBra1m7V+Gndv3cML02ItMGDJ4lDo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ha6GyVfS4EXSRI/M3GFE+oD0dOG+6oW9INEKYTSxQ/o9tQBa0HH+79L8IHttW55mU
         jg+OCsqrUr1zrAA/bIKKLyVIl5qYVXUGUR3Os6OnF4lMSvvkIu3OR4pn516ZpkzlTd
         kHRCPro6WFn9UdHWDo9BwFkVYgTEDDSxCNCreGPk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qian Cai <cai@redhat.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        Boqun Feng <boqun.feng@gmail.com>
Subject: [PATCH 5.9 114/757] lockdep: Fix usage_traceoverflow
Date:   Tue, 27 Oct 2020 14:46:04 +0100
Message-Id: <20201027135455.917161913@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 2bb8945bcc1a768f2bc402a16c9610bba8d5187d ]

Basically print_lock_class_header()'s for loop is out of sync with the
the size of of ->usage_traces[].

Also clean things up a bit while at it, to avoid such mishaps in the future.

Fixes: 23870f122768 ("locking/lockdep: Fix "USED" <- "IN-NMI" inversions")
Reported-by: Qian Cai <cai@redhat.com>
Debugged-by: Boqun Feng <boqun.feng@gmail.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Tested-by: Qian Cai <cai@redhat.com>
Link: https://lkml.kernel.org/r/20200930094937.GE2651@hirez.programming.kicks-ass.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/lockdep_types.h      |  8 ++++++--
 kernel/locking/lockdep.c           | 32 ++++++++++++++----------------
 kernel/locking/lockdep_internals.h |  7 +++++--
 3 files changed, 26 insertions(+), 21 deletions(-)

diff --git a/include/linux/lockdep_types.h b/include/linux/lockdep_types.h
index bb35b449f5330..9a1fd49df17f6 100644
--- a/include/linux/lockdep_types.h
+++ b/include/linux/lockdep_types.h
@@ -35,8 +35,12 @@ enum lockdep_wait_type {
 /*
  * We'd rather not expose kernel/lockdep_states.h this wide, but we do need
  * the total number of states... :-(
+ *
+ * XXX_LOCK_USAGE_STATES is the number of lines in lockdep_states.h, for each
+ * of those we generates 4 states, Additionally we report on USED and USED_READ.
  */
-#define XXX_LOCK_USAGE_STATES		(1+2*4)
+#define XXX_LOCK_USAGE_STATES		2
+#define LOCK_TRACE_STATES		(XXX_LOCK_USAGE_STATES*4 + 2)
 
 /*
  * NR_LOCKDEP_CACHING_CLASSES ... Number of classes
@@ -106,7 +110,7 @@ struct lock_class {
 	 * IRQ/softirq usage tracking bits:
 	 */
 	unsigned long			usage_mask;
-	const struct lock_trace		*usage_traces[XXX_LOCK_USAGE_STATES];
+	const struct lock_trace		*usage_traces[LOCK_TRACE_STATES];
 
 	/*
 	 * Generation counter, when doing certain classes of graph walking,
diff --git a/kernel/locking/lockdep.c b/kernel/locking/lockdep.c
index 2facbbd146ec2..a430fbb01eb16 100644
--- a/kernel/locking/lockdep.c
+++ b/kernel/locking/lockdep.c
@@ -585,6 +585,8 @@ static const char *usage_str[] =
 #include "lockdep_states.h"
 #undef LOCKDEP_STATE
 	[LOCK_USED] = "INITIAL USE",
+	[LOCK_USED_READ] = "INITIAL READ USE",
+	/* abused as string storage for verify_lock_unused() */
 	[LOCK_USAGE_STATES] = "IN-NMI",
 };
 #endif
@@ -1939,7 +1941,7 @@ static void print_lock_class_header(struct lock_class *class, int depth)
 #endif
 	printk(KERN_CONT " {\n");
 
-	for (bit = 0; bit < LOCK_USAGE_STATES; bit++) {
+	for (bit = 0; bit < LOCK_TRACE_STATES; bit++) {
 		if (class->usage_mask & (1 << bit)) {
 			int len = depth;
 
@@ -3969,7 +3971,7 @@ static int separate_irq_context(struct task_struct *curr,
 static int mark_lock(struct task_struct *curr, struct held_lock *this,
 			     enum lock_usage_bit new_bit)
 {
-	unsigned int old_mask, new_mask, ret = 1;
+	unsigned int new_mask, ret = 1;
 
 	if (new_bit >= LOCK_USAGE_STATES) {
 		DEBUG_LOCKS_WARN_ON(1);
@@ -3996,30 +3998,26 @@ static int mark_lock(struct task_struct *curr, struct held_lock *this,
 	if (unlikely(hlock_class(this)->usage_mask & new_mask))
 		goto unlock;
 
-	old_mask = hlock_class(this)->usage_mask;
 	hlock_class(this)->usage_mask |= new_mask;
 
-	/*
-	 * Save one usage_traces[] entry and map both LOCK_USED and
-	 * LOCK_USED_READ onto the same entry.
-	 */
-	if (new_bit == LOCK_USED || new_bit == LOCK_USED_READ) {
-		if (old_mask & (LOCKF_USED | LOCKF_USED_READ))
-			goto unlock;
-		new_bit = LOCK_USED;
+	if (new_bit < LOCK_TRACE_STATES) {
+		if (!(hlock_class(this)->usage_traces[new_bit] = save_trace()))
+			return 0;
 	}
 
-	if (!(hlock_class(this)->usage_traces[new_bit] = save_trace()))
-		return 0;
-
 	switch (new_bit) {
+	case 0 ... LOCK_USED-1:
+		ret = mark_lock_irq(curr, this, new_bit);
+		if (!ret)
+			return 0;
+		break;
+
 	case LOCK_USED:
 		debug_atomic_dec(nr_unused_locks);
 		break;
+
 	default:
-		ret = mark_lock_irq(curr, this, new_bit);
-		if (!ret)
-			return 0;
+		break;
 	}
 
 unlock:
diff --git a/kernel/locking/lockdep_internals.h b/kernel/locking/lockdep_internals.h
index b0be1560ed17a..de49f9e1c11ba 100644
--- a/kernel/locking/lockdep_internals.h
+++ b/kernel/locking/lockdep_internals.h
@@ -20,9 +20,12 @@ enum lock_usage_bit {
 #undef LOCKDEP_STATE
 	LOCK_USED,
 	LOCK_USED_READ,
-	LOCK_USAGE_STATES
+	LOCK_USAGE_STATES,
 };
 
+/* states after LOCK_USED_READ are not traced and printed */
+static_assert(LOCK_TRACE_STATES == LOCK_USAGE_STATES);
+
 #define LOCK_USAGE_READ_MASK 1
 #define LOCK_USAGE_DIR_MASK  2
 #define LOCK_USAGE_STATE_MASK (~(LOCK_USAGE_READ_MASK | LOCK_USAGE_DIR_MASK))
@@ -121,7 +124,7 @@ static const unsigned long LOCKF_USED_IN_IRQ_READ =
 extern struct list_head all_lock_classes;
 extern struct lock_chain lock_chains[];
 
-#define LOCK_USAGE_CHARS (1+LOCK_USAGE_STATES/2)
+#define LOCK_USAGE_CHARS (2*XXX_LOCK_USAGE_STATES + 1)
 
 extern void get_usage_chars(struct lock_class *class,
 			    char usage[LOCK_USAGE_CHARS]);
-- 
2.25.1



