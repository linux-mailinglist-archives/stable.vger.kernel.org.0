Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA4DD470F0F
	for <lists+stable@lfdr.de>; Sat, 11 Dec 2021 00:54:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244110AbhLJX52 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Dec 2021 18:57:28 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:41078 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231656AbhLJX52 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Dec 2021 18:57:28 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 683E7B82A30;
        Fri, 10 Dec 2021 23:53:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F243DC341C6;
        Fri, 10 Dec 2021 23:53:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639180430;
        bh=zr055vkxNTSL1GCbgLv+4uQQE7BEt8wVeQzuOobeV5c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iLS/i6go8cl6hc7Tc5xekZ7V6kkSf1O3aCnnCTTEbKl6/LO/ucoGblxAXpFnwkNWX
         EhFv6QPBrKDXhv1wbN8wPWJR0H49Bx/azDwKzBrvHz7UXlvxFV6gkvC+QglrKhouQ+
         foq7N/hm4x/cD3Mwh4cR4xJpCnz0xiZz+lugo8snZIBdbmqwIcToMJlpKpP/Kyljbz
         eFWeFyAZbuM7F409CHEpwYiQmV3YznP2jneBDW+Jd/yC1uP6mbwR883Us61oqlXtVJ
         BcOkiAIG6E3bkw8zPvI11zKJY6/I7z6duE6a6eSehd9TyTJasysGXnzs2a31I5wYW3
         mr3G1wpzzFRjA==
From:   Eric Biggers <ebiggers@kernel.org>
To:     stable@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.19 1/5] wait: add wake_up_pollfree()
Date:   Fri, 10 Dec 2021 15:53:08 -0800
Message-Id: <20211210235312.40412-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211210235312.40412-1-ebiggers@kernel.org>
References: <20211210235312.40412-1-ebiggers@kernel.org>
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
 kernel/sched/wait.c  |  7 +++++++
 2 files changed, 33 insertions(+)

diff --git a/include/linux/wait.h b/include/linux/wait.h
index ed7c122cb31f4..1d726d79063c5 100644
--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -191,6 +191,7 @@ void __wake_up_locked_key_bookmark(struct wait_queue_head *wq_head,
 void __wake_up_sync_key(struct wait_queue_head *wq_head, unsigned int mode, int nr, void *key);
 void __wake_up_locked(struct wait_queue_head *wq_head, unsigned int mode, int nr);
 void __wake_up_sync(struct wait_queue_head *wq_head, unsigned int mode, int nr);
+void __wake_up_pollfree(struct wait_queue_head *wq_head);
 
 #define wake_up(x)			__wake_up(x, TASK_NORMAL, 1, NULL)
 #define wake_up_nr(x, nr)		__wake_up(x, TASK_NORMAL, nr, NULL)
@@ -217,6 +218,31 @@ void __wake_up_sync(struct wait_queue_head *wq_head, unsigned int mode, int nr);
 #define wake_up_interruptible_sync_poll(x, m)					\
 	__wake_up_sync_key((x), TASK_INTERRUPTIBLE, 1, poll_to_key(m))
 
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
+ * an explicit synchronize_rcu() or call_rcu(), or via SLAB_TYPESAFE_BY_RCU.
+ */
+static inline void wake_up_pollfree(struct wait_queue_head *wq_head)
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
 #define ___wait_cond_timeout(condition)						\
 ({										\
 	bool __cond = (condition);						\
diff --git a/kernel/sched/wait.c b/kernel/sched/wait.c
index 5dd47f1103d18..a44a57fb95402 100644
--- a/kernel/sched/wait.c
+++ b/kernel/sched/wait.c
@@ -209,6 +209,13 @@ void __wake_up_sync(struct wait_queue_head *wq_head, unsigned int mode, int nr_e
 }
 EXPORT_SYMBOL_GPL(__wake_up_sync);	/* For internal use only */
 
+void __wake_up_pollfree(struct wait_queue_head *wq_head)
+{
+	__wake_up(wq_head, TASK_NORMAL, 0, poll_to_key(EPOLLHUP | POLLFREE));
+	/* POLLFREE must have cleared the queue. */
+	WARN_ON_ONCE(waitqueue_active(wq_head));
+}
+
 /*
  * Note: we use "set_current_state()" _after_ the wait-queue add,
  * because we need a memory barrier there on SMP, so that any
-- 
2.34.1

