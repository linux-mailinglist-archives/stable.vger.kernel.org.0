Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B138E45C629
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 15:02:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353878AbhKXOFj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 09:05:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:51874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1356028AbhKXOD1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 09:03:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6F0E06331A;
        Wed, 24 Nov 2021 13:10:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637759445;
        bh=BByTlpL2M+ZkioHvK33DrYO19Zvh9oxdkSEF3XJAhmc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JhWEVQIHEawUYdVp7yhAHdgIyWHmF/3wHdXZrGIBCK9HakMVXIVJPLeLSTyQ2OodQ
         YXQRW6R6IDRKK6F2twxKj8C9+LbxggCE74cnuDCB1+5IgmrkAc9wwJplCiswbd/3ek
         cOHg2Yvxnp4nzU7tfQZRJJG5e5PZpJJKt3gwN5No=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>,
        Petr Mladek <pmladek@suse.com>,
        John Ogness <john.ogness@linutronix.de>
Subject: [PATCH 5.15 227/279] printk: restore flushing of NMI buffers on remote CPUs after NMI backtraces
Date:   Wed, 24 Nov 2021 12:58:34 +0100
Message-Id: <20211124115726.589357761@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.776172708@linuxfoundation.org>
References: <20211124115718.776172708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Piggin <npiggin@gmail.com>

commit 5d5e4522a7f404d1a96fd6c703989d32a9c9568d upstream.

printk from NMI context relies on irq work being raised on the local CPU
to print to console. This can be a problem if the NMI was raised by a
lockup detector to print lockup stack and regs, because the CPU may not
enable irqs (because it is locked up).

Introduce printk_trigger_flush() that can be called another CPU to try
to get those messages to the console, call that where printk_safe_flush
was previously called.

Fixes: 93d102f094be ("printk: remove safe buffers")
Cc: stable@vger.kernel.org # 5.15
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Reviewed-by: John Ogness <john.ogness@linutronix.de>
Signed-off-by: Petr Mladek <pmladek@suse.com>
Link: https://lore.kernel.org/r/20211107045116.1754411-1-npiggin@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/kernel/watchdog.c |    6 ++++++
 include/linux/printk.h         |    4 ++++
 kernel/printk/printk.c         |    5 +++++
 lib/nmi_backtrace.c            |    6 ++++++
 4 files changed, 21 insertions(+)

--- a/arch/powerpc/kernel/watchdog.c
+++ b/arch/powerpc/kernel/watchdog.c
@@ -187,6 +187,12 @@ static void watchdog_smp_panic(int cpu,
 	if (sysctl_hardlockup_all_cpu_backtrace)
 		trigger_allbutself_cpu_backtrace();
 
+	/*
+	 * Force flush any remote buffers that might be stuck in IRQ context
+	 * and therefore could not run their irq_work.
+	 */
+	printk_trigger_flush();
+
 	if (hardlockup_panic)
 		nmi_panic(NULL, "Hard LOCKUP");
 
--- a/include/linux/printk.h
+++ b/include/linux/printk.h
@@ -198,6 +198,7 @@ void dump_stack_print_info(const char *l
 void show_regs_print_info(const char *log_lvl);
 extern asmlinkage void dump_stack_lvl(const char *log_lvl) __cold;
 extern asmlinkage void dump_stack(void) __cold;
+void printk_trigger_flush(void);
 #else
 static inline __printf(1, 0)
 int vprintk(const char *s, va_list args)
@@ -274,6 +275,9 @@ static inline void dump_stack_lvl(const
 static inline void dump_stack(void)
 {
 }
+static inline void printk_trigger_flush(void)
+{
+}
 #endif
 
 #ifdef CONFIG_SMP
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -3252,6 +3252,11 @@ void defer_console_output(void)
 	preempt_enable();
 }
 
+void printk_trigger_flush(void)
+{
+	defer_console_output();
+}
+
 int vprintk_deferred(const char *fmt, va_list args)
 {
 	int r;
--- a/lib/nmi_backtrace.c
+++ b/lib/nmi_backtrace.c
@@ -75,6 +75,12 @@ void nmi_trigger_cpumask_backtrace(const
 		touch_softlockup_watchdog();
 	}
 
+	/*
+	 * Force flush any remote buffers that might be stuck in IRQ context
+	 * and therefore could not run their irq_work.
+	 */
+	printk_trigger_flush();
+
 	clear_bit_unlock(0, &backtrace_flag);
 	put_cpu();
 }


