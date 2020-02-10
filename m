Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D8E0157573
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 13:41:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729588AbgBJMlG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 07:41:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:42562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729881AbgBJMlG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:41:06 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 42D042051A;
        Mon, 10 Feb 2020 12:41:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338465;
        bh=mcTEQcb3T5LI506dQtDxxSNtl3YZszq0YvZdKEWc2+E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xbLG4vhWrkCX+k342mv3FFdbdvuy0Yyyq2Go3w5pHHIH5qY9PQS+9JCrzoIR160GY
         2bzwnXCjGPgla+W32g/zSngvsLe1aJr8GVog1t9+0astitUMcQGRKlZndhhzcMurdt
         C7JtGyx37eklQWEtobXWG5BjlQVfJt1j0jR6aJ+4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.5 225/367] eventfd: track eventfd_signal() recursion depth
Date:   Mon, 10 Feb 2020 04:32:18 -0800
Message-Id: <20200210122444.857728145@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122423.695146547@linuxfoundation.org>
References: <20200210122423.695146547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

commit b5e683d5cab8cd433b06ae178621f083cabd4f63 upstream.

eventfd use cases from aio and io_uring can deadlock due to circular
or resursive calling, when eventfd_signal() tries to grab the waitqueue
lock. On top of that, it's also possible to construct notification
chains that are deep enough that we could blow the stack.

Add a percpu counter that tracks the percpu recursion depth, warn if we
exceed it. The counter is also exposed so that users of eventfd_signal()
can do the right thing if it's non-zero in the context where it is
called.

Cc: stable@vger.kernel.org # 4.19+
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/eventfd.c            |   15 +++++++++++++++
 include/linux/eventfd.h |   14 ++++++++++++++
 2 files changed, 29 insertions(+)

--- a/fs/eventfd.c
+++ b/fs/eventfd.c
@@ -24,6 +24,8 @@
 #include <linux/seq_file.h>
 #include <linux/idr.h>
 
+DEFINE_PER_CPU(int, eventfd_wake_count);
+
 static DEFINE_IDA(eventfd_ida);
 
 struct eventfd_ctx {
@@ -60,12 +62,25 @@ __u64 eventfd_signal(struct eventfd_ctx
 {
 	unsigned long flags;
 
+	/*
+	 * Deadlock or stack overflow issues can happen if we recurse here
+	 * through waitqueue wakeup handlers. If the caller users potentially
+	 * nested waitqueues with custom wakeup handlers, then it should
+	 * check eventfd_signal_count() before calling this function. If
+	 * it returns true, the eventfd_signal() call should be deferred to a
+	 * safe context.
+	 */
+	if (WARN_ON_ONCE(this_cpu_read(eventfd_wake_count)))
+		return 0;
+
 	spin_lock_irqsave(&ctx->wqh.lock, flags);
+	this_cpu_inc(eventfd_wake_count);
 	if (ULLONG_MAX - ctx->count < n)
 		n = ULLONG_MAX - ctx->count;
 	ctx->count += n;
 	if (waitqueue_active(&ctx->wqh))
 		wake_up_locked_poll(&ctx->wqh, EPOLLIN);
+	this_cpu_dec(eventfd_wake_count);
 	spin_unlock_irqrestore(&ctx->wqh.lock, flags);
 
 	return n;
--- a/include/linux/eventfd.h
+++ b/include/linux/eventfd.h
@@ -12,6 +12,8 @@
 #include <linux/fcntl.h>
 #include <linux/wait.h>
 #include <linux/err.h>
+#include <linux/percpu-defs.h>
+#include <linux/percpu.h>
 
 /*
  * CAREFUL: Check include/uapi/asm-generic/fcntl.h when defining
@@ -40,6 +42,13 @@ __u64 eventfd_signal(struct eventfd_ctx
 int eventfd_ctx_remove_wait_queue(struct eventfd_ctx *ctx, wait_queue_entry_t *wait,
 				  __u64 *cnt);
 
+DECLARE_PER_CPU(int, eventfd_wake_count);
+
+static inline bool eventfd_signal_count(void)
+{
+	return this_cpu_read(eventfd_wake_count);
+}
+
 #else /* CONFIG_EVENTFD */
 
 /*
@@ -68,6 +77,11 @@ static inline int eventfd_ctx_remove_wai
 	return -ENOSYS;
 }
 
+static inline bool eventfd_signal_count(void)
+{
+	return false;
+}
+
 #endif
 
 #endif /* _LINUX_EVENTFD_H */


