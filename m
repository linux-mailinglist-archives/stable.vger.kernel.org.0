Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA509472771
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 11:05:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240311AbhLMKBA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 05:01:00 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:45218 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239859AbhLMJ64 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:58:56 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E98D5B80E0E;
        Mon, 13 Dec 2021 09:58:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D3AEC34600;
        Mon, 13 Dec 2021 09:58:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639389533;
        bh=pJKi27cSTr0x7XYdTRWTxQg+0FLKOWf4U2pq/h4+Kfg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KFRRNM8Pvtl9EUJCmSh51KQpiF61CnPGdHLn5qIjdq4m+QKAYHC99ACDYejtZyHCu
         s8jnGwRrcwgZzDmBB8++uRegLWj9/p8FtBLZ8MfoM3enJ8sfMCQ0Q6dP74t3wXC89W
         bPrB2SRlT/7QCXDTDWHyrtRDEUf8lWTJ7cT5pzt0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Eric Biggers <ebiggers@google.com>
Subject: [PATCH 5.15 095/171] wait: add wake_up_pollfree()
Date:   Mon, 13 Dec 2021 10:30:10 +0100
Message-Id: <20211213092948.240830190@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092945.091487407@linuxfoundation.org>
References: <20211213092945.091487407@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/wait.h |   26 ++++++++++++++++++++++++++
 kernel/sched/wait.c  |    7 +++++++
 2 files changed, 33 insertions(+)

--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -217,6 +217,7 @@ void __wake_up_sync_key(struct wait_queu
 void __wake_up_locked_sync_key(struct wait_queue_head *wq_head, unsigned int mode, void *key);
 void __wake_up_locked(struct wait_queue_head *wq_head, unsigned int mode, int nr);
 void __wake_up_sync(struct wait_queue_head *wq_head, unsigned int mode);
+void __wake_up_pollfree(struct wait_queue_head *wq_head);
 
 #define wake_up(x)			__wake_up(x, TASK_NORMAL, 1, NULL)
 #define wake_up_nr(x, nr)		__wake_up(x, TASK_NORMAL, nr, NULL)
@@ -245,6 +246,31 @@ void __wake_up_sync(struct wait_queue_he
 #define wake_up_interruptible_sync_poll_locked(x, m)				\
 	__wake_up_locked_sync_key((x), TASK_INTERRUPTIBLE, poll_to_key(m))
 
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
--- a/kernel/sched/wait.c
+++ b/kernel/sched/wait.c
@@ -238,6 +238,13 @@ void __wake_up_sync(struct wait_queue_he
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


