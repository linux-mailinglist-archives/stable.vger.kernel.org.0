Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4757D46DFFD
	for <lists+stable@lfdr.de>; Thu,  9 Dec 2021 02:06:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241773AbhLIBKE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Dec 2021 20:10:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241736AbhLIBKE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Dec 2021 20:10:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 858DEC0617A1;
        Wed,  8 Dec 2021 17:06:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 92FA2B82330;
        Thu,  9 Dec 2021 01:06:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08A59C341C7;
        Thu,  9 Dec 2021 01:06:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639011988;
        bh=AJgZ6c8q611DoxRratq+403Z/kSe9JMglcoWDPZwLeM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FEQBudGlo/OBS0+JYsdj3SnueK9llx9i/yLsxrToLIZUgNp2yKp+ZoYmXd1jVmDhR
         eUwhbpufQePihaxtakVoTd6CZ6wOESdAsWSJC6HJP3SVI+1cOxOSkVh3WxkG0jLD4f
         //JQuoK4flxF9hq2y9OYMauGEl+WW4uK+GadXAOGIXwtiUEJw8w+x1PMw9G0yH1iq8
         YHEpSTEHFanp79M/l5w4OpS/4fSkzmuQ5LdQzeifk6e/uYcILFQVzFX/U7jfXVKjdH
         NO7oDylADQUQFW4eSgzs2fAQaFsWvoBbOWJEjgXLVwwJ7qHzn2PFa3OTO5VdW8wmiO
         K4wQtq6tGzymQ==
From:   Eric Biggers <ebiggers@kernel.org>
To:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Benjamin LaHaise <bcrl@kvack.org>
Cc:     linux-aio@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ramji Jiyani <ramjiyani@google.com>,
        Christoph Hellwig <hch@lst.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Martijn Coenen <maco@android.com>, stable@vger.kernel.org
Subject: [PATCH v3 1/5] wait: add wake_up_pollfree()
Date:   Wed,  8 Dec 2021 17:04:51 -0800
Message-Id: <20211209010455.42744-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211209010455.42744-1-ebiggers@kernel.org>
References: <20211209010455.42744-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

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
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 include/linux/wait.h | 26 ++++++++++++++++++++++++++
 kernel/sched/wait.c  |  7 +++++++
 2 files changed, 33 insertions(+)

diff --git a/include/linux/wait.h b/include/linux/wait.h
index 2d0df57c99024..851e07da2583f 100644
--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -217,6 +217,7 @@ void __wake_up_sync_key(struct wait_queue_head *wq_head, unsigned int mode, void
 void __wake_up_locked_sync_key(struct wait_queue_head *wq_head, unsigned int mode, void *key);
 void __wake_up_locked(struct wait_queue_head *wq_head, unsigned int mode, int nr);
 void __wake_up_sync(struct wait_queue_head *wq_head, unsigned int mode);
+void __wake_up_pollfree(struct wait_queue_head *wq_head);
 
 #define wake_up(x)			__wake_up(x, TASK_NORMAL, 1, NULL)
 #define wake_up_nr(x, nr)		__wake_up(x, TASK_NORMAL, nr, NULL)
@@ -245,6 +246,31 @@ void __wake_up_sync(struct wait_queue_head *wq_head, unsigned int mode);
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
diff --git a/kernel/sched/wait.c b/kernel/sched/wait.c
index 76577d1642a5d..eca38107b32f1 100644
--- a/kernel/sched/wait.c
+++ b/kernel/sched/wait.c
@@ -238,6 +238,13 @@ void __wake_up_sync(struct wait_queue_head *wq_head, unsigned int mode)
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

