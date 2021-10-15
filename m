Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EFDC42EE06
	for <lists+stable@lfdr.de>; Fri, 15 Oct 2021 11:45:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237674AbhJOJr0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Oct 2021 05:47:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237664AbhJOJrS (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Oct 2021 05:47:18 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EA69C06176E;
        Fri, 15 Oct 2021 02:45:07 -0700 (PDT)
Date:   Fri, 15 Oct 2021 09:45:05 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1634291106;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xg9+mT6WC+xN1RVcGak4Ru+QyUzYE1yD7h9mjQ/cuPY=;
        b=1OWC3i2DI7VBOY5dyRrnOOTyIWPD9kLWWJ8XBTJSh0471i/0qu/J0f2vwMEtOhLinvNdOm
        4CtMtVSqNQKPF72nsiOo8ImFoWzo7iAEYMOmFDfaClHSy+oxoUS2tkmr8hWDLPZMbhG8WG
        //tMB+F6rjqojwylQ/yzSXyoRWarxQ50bG9/tqZeAyoKPpkvfV9wm2yUgHmyLspa25zRI+
        Jby2tzFLu2UKnh3Udk/aCRFfLRLOdq6P0mIG94qlMHcwaGunUdKWCrtXv9oO7wtgwXd0Cx
        5GsEYwPKHYjCi3u7ednq75QLmbndpDvclWu3RR2xVOoPKSqGVn8mejyLUMmUNg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1634291106;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xg9+mT6WC+xN1RVcGak4Ru+QyUzYE1yD7h9mjQ/cuPY=;
        b=jJH4xr6BVDWYUMiKP9mIRqydvVh//Rks2JqpX0PNBgACUm5M4xglFx/o2IsclJn955xyxi
        5IefegpClJ+2IXDg==
From:   "tip-bot2 for Kees Cook" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: sched/core] Revert "proc/wchan: use printk format instead of
 lookup_symbol_name()"
Cc:     kernel test robot <oliver.sang@intel.com>,
        Vito Caputo <vcaputo@pengaru.com>,
        Jann Horn <jannh@google.com>,
        Kees Cook <keescook@chromium.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        stable@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20211008111626.090829198@infradead.org>
References: <20211008111626.090829198@infradead.org>
MIME-Version: 1.0
Message-ID: <163429110533.25758.7536227184582380260.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the sched/core branch of tip:

Commit-ID:     54354c6a9f7fd5572d2b9ec108117c4f376d4d23
Gitweb:        https://git.kernel.org/tip/54354c6a9f7fd5572d2b9ec108117c4f376d4d23
Author:        Kees Cook <keescook@chromium.org>
AuthorDate:    Wed, 29 Sep 2021 15:02:13 -07:00
Committer:     Peter Zijlstra <peterz@infradead.org>
CommitterDate: Fri, 15 Oct 2021 11:25:13 +02:00

Revert "proc/wchan: use printk format instead of lookup_symbol_name()"

This reverts commit 152c432b128cb043fc107e8f211195fe94b2159c.

When a kernel address couldn't be symbolized for /proc/$pid/wchan, it
would leak the raw value, a potential information exposure. This is a
regression compared to the safer pre-v5.12 behavior.

Reported-by: kernel test robot <oliver.sang@intel.com>
Reported-by: Vito Caputo <vcaputo@pengaru.com>
Reported-by: Jann Horn <jannh@google.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20211008111626.090829198@infradead.org
---
 fs/proc/base.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 533d583..1f39409 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -67,6 +67,7 @@
 #include <linux/mm.h>
 #include <linux/swap.h>
 #include <linux/rcupdate.h>
+#include <linux/kallsyms.h>
 #include <linux/stacktrace.h>
 #include <linux/resource.h>
 #include <linux/module.h>
@@ -386,17 +387,19 @@ static int proc_pid_wchan(struct seq_file *m, struct pid_namespace *ns,
 			  struct pid *pid, struct task_struct *task)
 {
 	unsigned long wchan;
+	char symname[KSYM_NAME_LEN];
 
-	if (ptrace_may_access(task, PTRACE_MODE_READ_FSCREDS))
-		wchan = get_wchan(task);
-	else
-		wchan = 0;
+	if (!ptrace_may_access(task, PTRACE_MODE_READ_FSCREDS))
+		goto print0;
 
-	if (wchan)
-		seq_printf(m, "%ps", (void *) wchan);
-	else
-		seq_putc(m, '0');
+	wchan = get_wchan(task);
+	if (wchan && !lookup_symbol_name(wchan, symname)) {
+		seq_puts(m, symname);
+		return 0;
+	}
 
+print0:
+	seq_putc(m, '0');
 	return 0;
 }
 #endif /* CONFIG_KALLSYMS */
