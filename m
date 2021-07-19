Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EAE13CD04E
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 11:15:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235290AbhGSIea (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 04:34:30 -0400
Received: from gateway23.websitewelcome.com ([192.185.49.104]:15856 "EHLO
        gateway23.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235150AbhGSIea (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Jul 2021 04:34:30 -0400
X-Greylist: delayed 2174 seconds by postgrey-1.27 at vger.kernel.org; Mon, 19 Jul 2021 04:34:30 EDT
Received: from cm17.websitewelcome.com (cm17.websitewelcome.com [100.42.49.20])
        by gateway23.websitewelcome.com (Postfix) with ESMTP id 295ED8D40
        for <stable@vger.kernel.org>; Mon, 19 Jul 2021 02:55:15 -0500 (CDT)
Received: from gator4132.hostgator.com ([192.185.4.144])
        by cmsmtp with SMTP
        id 5O7Pm0v5XMGeE5O7PmR3Oy; Mon, 19 Jul 2021 02:55:15 -0500
X-Authority-Reason: nr=8
Received: from host-79-37-206-118.retail.telecomitalia.it ([79.37.206.118]:40920 helo=f34.bristot.me)
        by gator4132.hostgator.com with esmtpa (Exim 4.94.2)
        (envelope-from <bristot@kernel.org>)
        id 1m5O7K-004Hrb-2v; Mon, 19 Jul 2021 02:55:10 -0500
From:   Daniel Bristot de Oliveira <bristot@kernel.org>
To:     Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-kernel@vger.kernel.org
Cc:     Daniel Bristot de Oliveira <bristot@kernel.org>,
        He Zhe <zhe.he@windriver.com>, Jens Axboe <axboe@kernel.dk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        stable@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH] eventfd: protect eventfd_wake_count with a local_lock
Date:   Mon, 19 Jul 2021 09:54:52 +0200
Message-Id: <523c91c4a30f21295508004c81cd2e46ccc37dc2.1626680553.git.bristot@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4132.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - kernel.org
X-BWhitelist: no
X-Source-IP: 79.37.206.118
X-Source-L: No
X-Exim-ID: 1m5O7K-004Hrb-2v
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: host-79-37-206-118.retail.telecomitalia.it (f34.bristot.me) [79.37.206.118]:40920
X-Source-Auth: kernel@bristot.me
X-Email-Count: 3
X-Source-Cap: YnJpc3RvdG1lO2JyaXN0b3RtZTtnYXRvcjQxMzIuaG9zdGdhdG9yLmNvbQ==
X-Local-Domain: no
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

eventfd_signal assumes that spin_lock_irqsave/spin_unlock_irqrestore is
non-preemptable and therefore increments and decrements the percpu
variable inside the critical section.

This obviously does not fly with PREEMPT_RT. If eventfd_signal is
preempted and an unrelated thread calls eventfd_signal, the result is
a spurious WARN. To avoid this, protect the percpu variable with a
local_lock.

Reported-by: Daniel Bristot de Oliveira <bristot@kernel.org>
Fixes: b5e683d5cab8 ("eventfd: track eventfd_signal() recursion depth")
Cc: He Zhe <zhe.he@windriver.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: stable@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Co-developed-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Daniel Bristot de Oliveira <bristot@kernel.org>
---
 fs/eventfd.c            | 27 ++++++++++++++++++++++-----
 include/linux/eventfd.h |  7 +------
 2 files changed, 23 insertions(+), 11 deletions(-)

diff --git a/fs/eventfd.c b/fs/eventfd.c
index e265b6dd4f34..9754fcd38690 100644
--- a/fs/eventfd.c
+++ b/fs/eventfd.c
@@ -12,6 +12,7 @@
 #include <linux/fs.h>
 #include <linux/sched/signal.h>
 #include <linux/kernel.h>
+#include <linux/local_lock.h>
 #include <linux/slab.h>
 #include <linux/list.h>
 #include <linux/spinlock.h>
@@ -25,8 +26,6 @@
 #include <linux/idr.h>
 #include <linux/uio.h>
 
-DEFINE_PER_CPU(int, eventfd_wake_count);
-
 static DEFINE_IDA(eventfd_ida);
 
 struct eventfd_ctx {
@@ -45,6 +44,20 @@ struct eventfd_ctx {
 	int id;
 };
 
+struct event_fd_recursion {
+	local_lock_t lock;
+	int count;
+};
+
+static DEFINE_PER_CPU(struct event_fd_recursion, event_fd_recursion) = {
+	.lock = INIT_LOCAL_LOCK(lock),
+};
+
+bool eventfd_signal_count(void)
+{
+	return this_cpu_read(event_fd_recursion.count);
+}
+
 /**
  * eventfd_signal - Adds @n to the eventfd counter.
  * @ctx: [in] Pointer to the eventfd context.
@@ -71,18 +84,22 @@ __u64 eventfd_signal(struct eventfd_ctx *ctx, __u64 n)
 	 * it returns true, the eventfd_signal() call should be deferred to a
 	 * safe context.
 	 */
-	if (WARN_ON_ONCE(this_cpu_read(eventfd_wake_count)))
+	local_lock(&event_fd_recursion.lock);
+	if (WARN_ON_ONCE(this_cpu_read(event_fd_recursion.count))) {
+		local_unlock(&event_fd_recursion.lock);
 		return 0;
+	}
 
 	spin_lock_irqsave(&ctx->wqh.lock, flags);
-	this_cpu_inc(eventfd_wake_count);
+	this_cpu_inc(event_fd_recursion.count);
 	if (ULLONG_MAX - ctx->count < n)
 		n = ULLONG_MAX - ctx->count;
 	ctx->count += n;
 	if (waitqueue_active(&ctx->wqh))
 		wake_up_locked_poll(&ctx->wqh, EPOLLIN);
-	this_cpu_dec(eventfd_wake_count);
+	this_cpu_dec(event_fd_recursion.count);
 	spin_unlock_irqrestore(&ctx->wqh.lock, flags);
+	local_unlock(&event_fd_recursion.lock);
 
 	return n;
 }
diff --git a/include/linux/eventfd.h b/include/linux/eventfd.h
index fa0a524baed0..ca89d6c409c1 100644
--- a/include/linux/eventfd.h
+++ b/include/linux/eventfd.h
@@ -43,12 +43,7 @@ int eventfd_ctx_remove_wait_queue(struct eventfd_ctx *ctx, wait_queue_entry_t *w
 				  __u64 *cnt);
 void eventfd_ctx_do_read(struct eventfd_ctx *ctx, __u64 *cnt);
 
-DECLARE_PER_CPU(int, eventfd_wake_count);
-
-static inline bool eventfd_signal_count(void)
-{
-	return this_cpu_read(eventfd_wake_count);
-}
+bool eventfd_signal_count(void);
 
 #else /* CONFIG_EVENTFD */
 
-- 
2.31.1

