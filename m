Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51BCA1C1630
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 16:08:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731301AbgEANl3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:41:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:41762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730785AbgEANl1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:41:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6EA2B2173E;
        Fri,  1 May 2020 13:41:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588340486;
        bh=YdeKDp1S9xYSdO6SLjwTBfOnXBIYB8gyo/4DqfWJ088=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YO4Rh/Lvx5pt3/ZOcKfg//LP4nJsPuny6qGVXJM+FZualVh82PHSobqaqiiPYDmtZ
         Td3oGGSFi79xXe9th5UxZhRvMOFP+ArMCqf1rLFiyWkhNbwMMdTmutDABTUFiXgmB2
         UTj8aYJZlsI55fxquw4jvaFr65wldnWWt6bjZGmo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Lech Perczak <l.perczak@camlintechnologies.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Jann Horn <jannh@google.com>, Petr Mladek <pmladek@suse.com>,
        Theodore Tso <tytso@mit.edu>,
        John Ogness <john.ogness@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 5.6 002/106] printk: queue wake_up_klogd irq_work only if per-CPU areas are ready
Date:   Fri,  1 May 2020 15:22:35 +0200
Message-Id: <20200501131543.727103454@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501131543.421333643@linuxfoundation.org>
References: <20200501131543.421333643@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>

commit ab6f762f0f53162d41497708b33c9a3236d3609e upstream.

printk_deferred(), similarly to printk_safe/printk_nmi, does not
immediately attempt to print a new message on the consoles, avoiding
calls into non-reentrant kernel paths, e.g. scheduler or timekeeping,
which potentially can deadlock the system.

Those printk() flavors, instead, rely on per-CPU flush irq_work to print
messages from safer contexts.  For same reasons (recursive scheduler or
timekeeping calls) printk() uses per-CPU irq_work in order to wake up
user space syslog/kmsg readers.

However, only printk_safe/printk_nmi do make sure that per-CPU areas
have been initialised and that it's safe to modify per-CPU irq_work.
This means that, for instance, should printk_deferred() be invoked "too
early", that is before per-CPU areas are initialised, printk_deferred()
will perform illegal per-CPU access.

Lech Perczak [0] reports that after commit 1b710b1b10ef ("char/random:
silence a lockdep splat with printk()") user-space syslog/kmsg readers
are not able to read new kernel messages.

The reason is printk_deferred() being called too early (as was pointed
out by Petr and John).

Fix printk_deferred() and do not queue per-CPU irq_work before per-CPU
areas are initialized.

Link: https://lore.kernel.org/lkml/aa0732c6-5c4e-8a8b-a1c1-75ebe3dca05b@camlintechnologies.com/
Reported-by: Lech Perczak <l.perczak@camlintechnologies.com>
Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Tested-by: Jann Horn <jannh@google.com>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: John Ogness <john.ogness@linutronix.de>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/printk.h      |    5 -----
 init/main.c                 |    1 -
 kernel/printk/internal.h    |    5 +++++
 kernel/printk/printk.c      |   34 ++++++++++++++++++++++++++++++++++
 kernel/printk/printk_safe.c |   11 +----------
 5 files changed, 40 insertions(+), 16 deletions(-)

--- a/include/linux/printk.h
+++ b/include/linux/printk.h
@@ -202,7 +202,6 @@ __printf(1, 2) void dump_stack_set_arch_
 void dump_stack_print_info(const char *log_lvl);
 void show_regs_print_info(const char *log_lvl);
 extern asmlinkage void dump_stack(void) __cold;
-extern void printk_safe_init(void);
 extern void printk_safe_flush(void);
 extern void printk_safe_flush_on_panic(void);
 #else
@@ -269,10 +268,6 @@ static inline void dump_stack(void)
 {
 }
 
-static inline void printk_safe_init(void)
-{
-}
-
 static inline void printk_safe_flush(void)
 {
 }
--- a/init/main.c
+++ b/init/main.c
@@ -907,7 +907,6 @@ asmlinkage __visible void __init start_k
 	boot_init_stack_canary();
 
 	time_init();
-	printk_safe_init();
 	perf_event_init();
 	profile_init();
 	call_function_init();
--- a/kernel/printk/internal.h
+++ b/kernel/printk/internal.h
@@ -23,6 +23,9 @@ __printf(1, 0) int vprintk_func(const ch
 void __printk_safe_enter(void);
 void __printk_safe_exit(void);
 
+void printk_safe_init(void);
+bool printk_percpu_data_ready(void);
+
 #define printk_safe_enter_irqsave(flags)	\
 	do {					\
 		local_irq_save(flags);		\
@@ -64,4 +67,6 @@ __printf(1, 0) int vprintk_func(const ch
 #define printk_safe_enter_irq() local_irq_disable()
 #define printk_safe_exit_irq() local_irq_enable()
 
+static inline void printk_safe_init(void) { }
+static inline bool printk_percpu_data_ready(void) { return false; }
 #endif /* CONFIG_PRINTK */
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -460,6 +460,18 @@ static char __log_buf[__LOG_BUF_LEN] __a
 static char *log_buf = __log_buf;
 static u32 log_buf_len = __LOG_BUF_LEN;
 
+/*
+ * We cannot access per-CPU data (e.g. per-CPU flush irq_work) before
+ * per_cpu_areas are initialised. This variable is set to true when
+ * it's safe to access per-CPU data.
+ */
+static bool __printk_percpu_data_ready __read_mostly;
+
+bool printk_percpu_data_ready(void)
+{
+	return __printk_percpu_data_ready;
+}
+
 /* Return log buffer address */
 char *log_buf_addr_get(void)
 {
@@ -1146,12 +1158,28 @@ static void __init log_buf_add_cpu(void)
 static inline void log_buf_add_cpu(void) {}
 #endif /* CONFIG_SMP */
 
+static void __init set_percpu_data_ready(void)
+{
+	printk_safe_init();
+	/* Make sure we set this flag only after printk_safe() init is done */
+	barrier();
+	__printk_percpu_data_ready = true;
+}
+
 void __init setup_log_buf(int early)
 {
 	unsigned long flags;
 	char *new_log_buf;
 	unsigned int free;
 
+	/*
+	 * Some archs call setup_log_buf() multiple times - first is very
+	 * early, e.g. from setup_arch(), and second - when percpu_areas
+	 * are initialised.
+	 */
+	if (!early)
+		set_percpu_data_ready();
+
 	if (log_buf != __log_buf)
 		return;
 
@@ -2966,6 +2994,9 @@ static DEFINE_PER_CPU(struct irq_work, w
 
 void wake_up_klogd(void)
 {
+	if (!printk_percpu_data_ready())
+		return;
+
 	preempt_disable();
 	if (waitqueue_active(&log_wait)) {
 		this_cpu_or(printk_pending, PRINTK_PENDING_WAKEUP);
@@ -2976,6 +3007,9 @@ void wake_up_klogd(void)
 
 void defer_console_output(void)
 {
+	if (!printk_percpu_data_ready())
+		return;
+
 	preempt_disable();
 	__this_cpu_or(printk_pending, PRINTK_PENDING_OUTPUT);
 	irq_work_queue(this_cpu_ptr(&wake_up_klogd_work));
--- a/kernel/printk/printk_safe.c
+++ b/kernel/printk/printk_safe.c
@@ -27,7 +27,6 @@
  * There are situations when we want to make sure that all buffers
  * were handled or when IRQs are blocked.
  */
-static int printk_safe_irq_ready __read_mostly;
 
 #define SAFE_LOG_BUF_LEN ((1 << CONFIG_PRINTK_SAFE_LOG_BUF_SHIFT) -	\
 				sizeof(atomic_t) -			\
@@ -51,7 +50,7 @@ static DEFINE_PER_CPU(struct printk_safe
 /* Get flushed in a more safe context. */
 static void queue_flush_work(struct printk_safe_seq_buf *s)
 {
-	if (printk_safe_irq_ready)
+	if (printk_percpu_data_ready())
 		irq_work_queue(&s->work);
 }
 
@@ -402,14 +401,6 @@ void __init printk_safe_init(void)
 #endif
 	}
 
-	/*
-	 * In the highly unlikely event that a NMI were to trigger at
-	 * this moment. Make sure IRQ work is set up before this
-	 * variable is set.
-	 */
-	barrier();
-	printk_safe_irq_ready = 1;
-
 	/* Flush pending messages that did not have scheduled IRQ works. */
 	printk_safe_flush();
 }


