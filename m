Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78CDF44C847
	for <lists+stable@lfdr.de>; Wed, 10 Nov 2021 19:59:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234401AbhKJTAl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Nov 2021 14:00:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:54840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234455AbhKJS6o (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Nov 2021 13:58:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2585A61207;
        Wed, 10 Nov 2021 18:51:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636570261;
        bh=mdqLijaQs1sokXQW7Xr0i9zNw8ATJOaPjtPAZ0iG5IA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cQY1d+PPtqqxnxACY+A+cFYaFFW91pfgpzVqhCZWv1/LFgIHWR4yr9Cwa+GZL2zzs
         fyVf6dXZy6VL+OdFQg+8u5BnMHYM05Qh/6AMCpzF4moZU9uDYiKiQ9m69En05+/uqV
         xQscjgycZlaD60WAUVEXx6fXjj6I5jd9+GH9amws=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <oliver.sang@intel.com>,
        Vito Caputo <vcaputo@pengaru.com>,
        Jann Horn <jannh@google.com>,
        Kees Cook <keescook@chromium.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 5.15 07/26] Revert "proc/wchan: use printk format instead of lookup_symbol_name()"
Date:   Wed, 10 Nov 2021 19:44:06 +0100
Message-Id: <20211110182003.943843760@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211110182003.700594531@linuxfoundation.org>
References: <20211110182003.700594531@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

commit 54354c6a9f7fd5572d2b9ec108117c4f376d4d23 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/proc/base.c |   21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

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
@@ -386,17 +387,19 @@ static int proc_pid_wchan(struct seq_fil
 			  struct pid *pid, struct task_struct *task)
 {
 	unsigned long wchan;
+	char symname[KSYM_NAME_LEN];
 
-	if (ptrace_may_access(task, PTRACE_MODE_READ_FSCREDS))
-		wchan = get_wchan(task);
-	else
-		wchan = 0;
-
-	if (wchan)
-		seq_printf(m, "%ps", (void *) wchan);
-	else
-		seq_putc(m, '0');
+	if (!ptrace_may_access(task, PTRACE_MODE_READ_FSCREDS))
+		goto print0;
 
+	wchan = get_wchan(task);
+	if (wchan && !lookup_symbol_name(wchan, symname)) {
+		seq_puts(m, symname);
+		return 0;
+	}
+
+print0:
+	seq_putc(m, '0');
 	return 0;
 }
 #endif /* CONFIG_KALLSYMS */


