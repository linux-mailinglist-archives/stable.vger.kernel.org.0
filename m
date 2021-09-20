Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D594641201B
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:47:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354121AbhITRsz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:48:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:52814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349040AbhITRqx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:46:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A784760FC1;
        Mon, 20 Sep 2021 17:10:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632157833;
        bh=Jfj8dHX5v2vx7vL021xsoz7HbLwNAYbAkfkSXgbbQv4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cew6RUhtgUvDKsmeDchmPI+QMBy6vDWYcpZwX1aUA9O7OY7Xub2z/pK5Tiz9iOZXu
         SQKJRDLZtCLC2JJAOy+vdG9V57HLf9KITZghs9VgsnaUeR9HeUgJiK3mwROG1eGaJX
         k0qbaWE70z6kErrGo9Cw0eNa2ZThd31bDe13SsKg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nadav Amit <namit@vmware.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Jens Axboe <axboe@kernel.dk>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        Peter Xu <peterx@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 171/293] userfaultfd: prevent concurrent API initialization
Date:   Mon, 20 Sep 2021 18:42:13 +0200
Message-Id: <20210920163939.136770854@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163933.258815435@linuxfoundation.org>
References: <20210920163933.258815435@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nadav Amit <namit@vmware.com>

[ Upstream commit 22e5fe2a2a279d9a6fcbdfb4dffe73821bef1c90 ]

userfaultfd assumes that the enabled features are set once and never
changed after UFFDIO_API ioctl succeeded.

However, currently, UFFDIO_API can be called concurrently from two
different threads, succeed on both threads and leave userfaultfd's
features in non-deterministic state.  Theoretically, other uffd operations
(ioctl's and page-faults) can be dispatched while adversely affected by
such changes of features.

Moreover, the writes to ctx->state and ctx->features are not ordered,
which can - theoretically, again - let userfaultfd_ioctl() think that
userfaultfd API completed, while the features are still not initialized.

To avoid races, it is arguably best to get rid of ctx->state.  Since there
are only 2 states, record the API initialization in ctx->features as the
uppermost bit and remove ctx->state.

Link: https://lkml.kernel.org/r/20210808020724.1022515-3-namit@vmware.com
Fixes: 9cd75c3cd4c3d ("userfaultfd: non-cooperative: add ability to report non-PF events from uffd descriptor")
Signed-off-by: Nadav Amit <namit@vmware.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/userfaultfd.c | 93 +++++++++++++++++++++++-------------------------
 1 file changed, 45 insertions(+), 48 deletions(-)

diff --git a/fs/userfaultfd.c b/fs/userfaultfd.c
index d269d1139f7f..23c8efc967af 100644
--- a/fs/userfaultfd.c
+++ b/fs/userfaultfd.c
@@ -32,11 +32,6 @@
 
 static struct kmem_cache *userfaultfd_ctx_cachep __read_mostly;
 
-enum userfaultfd_state {
-	UFFD_STATE_WAIT_API,
-	UFFD_STATE_RUNNING,
-};
-
 /*
  * Start with fault_pending_wqh and fault_wqh so they're more likely
  * to be in the same cacheline.
@@ -68,8 +63,6 @@ struct userfaultfd_ctx {
 	unsigned int flags;
 	/* features requested from the userspace */
 	unsigned int features;
-	/* state machine */
-	enum userfaultfd_state state;
 	/* released */
 	bool released;
 	/* memory mappings are changing because of non-cooperative event */
@@ -103,6 +96,14 @@ struct userfaultfd_wake_range {
 	unsigned long len;
 };
 
+/* internal indication that UFFD_API ioctl was successfully executed */
+#define UFFD_FEATURE_INITIALIZED		(1u << 31)
+
+static bool userfaultfd_is_initialized(struct userfaultfd_ctx *ctx)
+{
+	return ctx->features & UFFD_FEATURE_INITIALIZED;
+}
+
 static int userfaultfd_wake_function(wait_queue_entry_t *wq, unsigned mode,
 				     int wake_flags, void *key)
 {
@@ -700,7 +701,6 @@ int dup_userfaultfd(struct vm_area_struct *vma, struct list_head *fcs)
 
 		atomic_set(&ctx->refcount, 1);
 		ctx->flags = octx->flags;
-		ctx->state = UFFD_STATE_RUNNING;
 		ctx->features = octx->features;
 		ctx->released = false;
 		ctx->mmap_changing = false;
@@ -981,38 +981,33 @@ static __poll_t userfaultfd_poll(struct file *file, poll_table *wait)
 
 	poll_wait(file, &ctx->fd_wqh, wait);
 
-	switch (ctx->state) {
-	case UFFD_STATE_WAIT_API:
+	if (!userfaultfd_is_initialized(ctx))
 		return EPOLLERR;
-	case UFFD_STATE_RUNNING:
-		/*
-		 * poll() never guarantees that read won't block.
-		 * userfaults can be waken before they're read().
-		 */
-		if (unlikely(!(file->f_flags & O_NONBLOCK)))
-			return EPOLLERR;
-		/*
-		 * lockless access to see if there are pending faults
-		 * __pollwait last action is the add_wait_queue but
-		 * the spin_unlock would allow the waitqueue_active to
-		 * pass above the actual list_add inside
-		 * add_wait_queue critical section. So use a full
-		 * memory barrier to serialize the list_add write of
-		 * add_wait_queue() with the waitqueue_active read
-		 * below.
-		 */
-		ret = 0;
-		smp_mb();
-		if (waitqueue_active(&ctx->fault_pending_wqh))
-			ret = EPOLLIN;
-		else if (waitqueue_active(&ctx->event_wqh))
-			ret = EPOLLIN;
-
-		return ret;
-	default:
-		WARN_ON_ONCE(1);
+
+	/*
+	 * poll() never guarantees that read won't block.
+	 * userfaults can be waken before they're read().
+	 */
+	if (unlikely(!(file->f_flags & O_NONBLOCK)))
 		return EPOLLERR;
-	}
+	/*
+	 * lockless access to see if there are pending faults
+	 * __pollwait last action is the add_wait_queue but
+	 * the spin_unlock would allow the waitqueue_active to
+	 * pass above the actual list_add inside
+	 * add_wait_queue critical section. So use a full
+	 * memory barrier to serialize the list_add write of
+	 * add_wait_queue() with the waitqueue_active read
+	 * below.
+	 */
+	ret = 0;
+	smp_mb();
+	if (waitqueue_active(&ctx->fault_pending_wqh))
+		ret = EPOLLIN;
+	else if (waitqueue_active(&ctx->event_wqh))
+		ret = EPOLLIN;
+
+	return ret;
 }
 
 static const struct file_operations userfaultfd_fops;
@@ -1206,7 +1201,7 @@ static ssize_t userfaultfd_read(struct file *file, char __user *buf,
 	struct uffd_msg msg;
 	int no_wait = file->f_flags & O_NONBLOCK;
 
-	if (ctx->state == UFFD_STATE_WAIT_API)
+	if (!userfaultfd_is_initialized(ctx))
 		return -EINVAL;
 
 	for (;;) {
@@ -1808,9 +1803,10 @@ static int userfaultfd_zeropage(struct userfaultfd_ctx *ctx,
 static inline unsigned int uffd_ctx_features(__u64 user_features)
 {
 	/*
-	 * For the current set of features the bits just coincide
+	 * For the current set of features the bits just coincide. Set
+	 * UFFD_FEATURE_INITIALIZED to mark the features as enabled.
 	 */
-	return (unsigned int)user_features;
+	return (unsigned int)user_features | UFFD_FEATURE_INITIALIZED;
 }
 
 /*
@@ -1823,12 +1819,10 @@ static int userfaultfd_api(struct userfaultfd_ctx *ctx,
 {
 	struct uffdio_api uffdio_api;
 	void __user *buf = (void __user *)arg;
+	unsigned int ctx_features;
 	int ret;
 	__u64 features;
 
-	ret = -EINVAL;
-	if (ctx->state != UFFD_STATE_WAIT_API)
-		goto out;
 	ret = -EFAULT;
 	if (copy_from_user(&uffdio_api, buf, sizeof(uffdio_api)))
 		goto out;
@@ -1845,9 +1839,13 @@ static int userfaultfd_api(struct userfaultfd_ctx *ctx,
 	ret = -EFAULT;
 	if (copy_to_user(buf, &uffdio_api, sizeof(uffdio_api)))
 		goto out;
-	ctx->state = UFFD_STATE_RUNNING;
+
 	/* only enable the requested features for this uffd context */
-	ctx->features = uffd_ctx_features(features);
+	ctx_features = uffd_ctx_features(features);
+	ret = -EINVAL;
+	if (cmpxchg(&ctx->features, 0, ctx_features) != 0)
+		goto err_out;
+
 	ret = 0;
 out:
 	return ret;
@@ -1864,7 +1862,7 @@ static long userfaultfd_ioctl(struct file *file, unsigned cmd,
 	int ret = -EINVAL;
 	struct userfaultfd_ctx *ctx = file->private_data;
 
-	if (cmd != UFFDIO_API && ctx->state == UFFD_STATE_WAIT_API)
+	if (cmd != UFFDIO_API && !userfaultfd_is_initialized(ctx))
 		return -EINVAL;
 
 	switch(cmd) {
@@ -1962,7 +1960,6 @@ SYSCALL_DEFINE1(userfaultfd, int, flags)
 	atomic_set(&ctx->refcount, 1);
 	ctx->flags = flags;
 	ctx->features = 0;
-	ctx->state = UFFD_STATE_WAIT_API;
 	ctx->released = false;
 	ctx->mmap_changing = false;
 	ctx->mm = current->mm;
-- 
2.30.2



