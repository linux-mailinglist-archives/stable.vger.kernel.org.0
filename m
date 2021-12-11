Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 404D2470F6F
	for <lists+stable@lfdr.de>; Sat, 11 Dec 2021 01:28:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241531AbhLKAcV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Dec 2021 19:32:21 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:54476 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241482AbhLKAcV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Dec 2021 19:32:21 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0B678B821CD;
        Sat, 11 Dec 2021 00:28:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B42B7C341C6;
        Sat, 11 Dec 2021 00:28:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639182523;
        bh=GXdn75I8saqXkrtakHw/QnPNWQzQUBkIRGRreApXKUI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N3bV0e75JPvpTMggl8vPZ+FsDR9/Frm+MT2trZpFE9ppSGnQfzqenogcfE/kcGLXT
         a8c1pkeG/KLgOb9OwxtptL99NSzHN/mZelCm8WnlH6QTa7Bqk9RFst9uo4p9yflWLC
         1wV5//1MkCaZtFiwCuQKiFj6zcjL3Wssangvk8bdEpcXiiU2nqID/4enn56E3eDFAy
         Z3ejSmlWz3aC8iuUUl6AEn2f9+TecSqimZS63Vcx5YBLLKnEegQJu6+2fhs8L7ueDy
         dHlmU7BGmcXY5M0GmhvTsoCMLjr0ByPSRtMKEdD5BfHHMloEj0FAANxE9Xyfw/OJvl
         jrnBND67+FQ/A==
From:   Eric Biggers <ebiggers@kernel.org>
To:     stable@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.4,4.9 1/3] wait: add wake_up_pollfree()
Date:   Fri, 10 Dec 2021 16:28:30 -0800
Message-Id: <20211211002832.153742-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211211002832.153742-1-ebiggers@kernel.org>
References: <20211211002832.153742-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

commit 42288cb44c4b5fff7653bc392b583a2b8bd6a8c0 upstream.

Several ->poll() implementations are special in that they use a
waitqueue whose lifetime is the current task, rather than the struct
file as is normally the case.  This is okay for blocking polls, since a
blocking poll occurs within one task; however, non-blocking polls
require another solution.  This solution is for the queue to be cleared
before it is freed, using 'wake_up_poll(wq, EPOLLHUP | POLLFREE);'.

However, that has a bug: wake_up_poll() calls __wake_up() with
nr_exclusive=1.  Therefore, if there are multiple "exclusive" waiters,
and the wakeup function for the first one returns a positive value, only
that one will be called.  That's *not* what's needed for POLLFREE;
POLLFREE is special in that it really needs to wake up everyone.

Considering the three non-blocking poll systems:

- io_uring poll doesn't handle POLLFREE at all, so it is broken anyway.

- aio poll is unaffected, since it doesn't support exclusive waits.
  However, that's fragile, as someone could add this feature later.

- epoll doesn't appear to be broken by this, since its wakeup function
  returns 0 when it sees POLLFREE.  But this is fragile.

Although there is a workaround (see epoll), it's better to define a
function which always sends POLLFREE to all waiters.  Add such a
function.  Also make it verify that the queue really becomes empty after
all waiters have been woken up.

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20211209010455.42744-2-ebiggers@kernel.org
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 include/linux/wait.h | 26 ++++++++++++++++++++++++++
 kernel/sched/wait.c  |  8 ++++++++
 2 files changed, 34 insertions(+)

diff --git a/include/linux/wait.h b/include/linux/wait.h
index 2408e8d5c05cc..e022ee95bd45c 100644
--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -202,6 +202,7 @@ void __wake_up_locked_key(wait_queue_head_t *q, unsigned int mode, void *key);
 void __wake_up_sync_key(wait_queue_head_t *q, unsigned int mode, int nr, void *key);
 void __wake_up_locked(wait_queue_head_t *q, unsigned int mode, int nr);
 void __wake_up_sync(wait_queue_head_t *q, unsigned int mode, int nr);
+void __wake_up_pollfree(wait_queue_head_t *wq_head);
 void __wake_up_bit(wait_queue_head_t *, void *, int);
 int __wait_on_bit(wait_queue_head_t *, struct wait_bit_queue *, wait_bit_action_f *, unsigned);
 int __wait_on_bit_lock(wait_queue_head_t *, struct wait_bit_queue *, wait_bit_action_f *, unsigned);
@@ -236,6 +237,31 @@ wait_queue_head_t *bit_waitqueue(void *, int);
 #define wake_up_interruptible_sync_poll(x, m)				\
 	__wake_up_sync_key((x), TASK_INTERRUPTIBLE, 1, (void *) (m))
 
+/**
+ * wake_up_pollfree - signal that a polled waitqueue is going away
+ * @wq_head: the wait queue head
+ *
+ * In the very rare cases where a ->poll() implementation uses a waitqueue whose
+ * lifetime is tied to a task rather than to the 'struct file' being polled,
+ * this function must be called before the waitqueue is freed so that
+ * non-blocking polls (e.g. epoll) are notified that the queue is going away.
+ *
+ * The caller must also RCU-delay the freeing of the wait_queue_head, e.g. via
+ * an explicit synchronize_rcu() or call_rcu(), or via SLAB_DESTROY_BY_RCU.
+ */
+static inline void wake_up_pollfree(wait_queue_head_t *wq_head)
+{
+	/*
+	 * For performance reasons, we don't always take the queue lock here.
+	 * Therefore, we might race with someone removing the last entry from
+	 * the queue, and proceed while they still hold the queue lock.
+	 * However, rcu_read_lock() is required to be held in such cases, so we
+	 * can safely proceed with an RCU-delayed free.
+	 */
+	if (waitqueue_active(wq_head))
+		__wake_up_pollfree(wq_head);
+}
+
 #define ___wait_cond_timeout(condition)					\
 ({									\
 	bool __cond = (condition);					\
diff --git a/kernel/sched/wait.c b/kernel/sched/wait.c
index 9453efe9b25a6..133afaf05c3f4 100644
--- a/kernel/sched/wait.c
+++ b/kernel/sched/wait.c
@@ -10,6 +10,7 @@
 #include <linux/wait.h>
 #include <linux/hash.h>
 #include <linux/kthread.h>
+#include <linux/poll.h>
 
 void __init_waitqueue_head(wait_queue_head_t *q, const char *name, struct lock_class_key *key)
 {
@@ -156,6 +157,13 @@ void __wake_up_sync(wait_queue_head_t *q, unsigned int mode, int nr_exclusive)
 }
 EXPORT_SYMBOL_GPL(__wake_up_sync);	/* For internal use only */
 
+void __wake_up_pollfree(wait_queue_head_t *wq_head)
+{
+	__wake_up(wq_head, TASK_NORMAL, 0, (void *)(POLLHUP | POLLFREE));
+	/* POLLFREE must have cleared the queue. */
+	WARN_ON_ONCE(waitqueue_active(wq_head));
+}
+
 /*
  * Note: we use "set_current_state()" _after_ the wait-queue add,
  * because we need a memory barrier there on SMP, so that any
-- 
2.34.1

