Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3980130273
	for <lists+stable@lfdr.de>; Sat,  4 Jan 2020 14:03:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725827AbgADNDR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 Jan 2020 08:03:17 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:39564 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725805AbgADNDR (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 4 Jan 2020 08:03:17 -0500
Received: by mail-wr1-f66.google.com with SMTP id y11so44817680wrt.6;
        Sat, 04 Jan 2020 05:03:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Jx4SLI4Z9KLYRUbb1SFG68L+fEF+yXR27NZhSzKFTk8=;
        b=ZqwHItTaGb0+q64wIW1e3ynchu1RaPOBaFfyODjRFgo212r8rS7eNTGLlQZQK7/q/w
         iIitPsM1OvU1G92EM+fd/ZSnHDBKZbjnF4raLjZZKrOlHULUgoPeA3Ak+10c8oAqrLyC
         nYzAIZpz7nyADyNpkJIv/X4dFccPwc8vKURED2IQdW0MOy9QMGTYfjzj15pEg8EcmGMU
         I+icVnKNsLMlAnFJa1LHU871ZtH5l0R/ZeFTsWKApE5CJnPAfmcgQBqnzmQZDjX9bQuh
         GZIr3COROkNjPyjaeaY9BK+bzPcG5qNUYK68sZ8Da75at8bRvleqbvQdFbDLyitAAbZU
         dbwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Jx4SLI4Z9KLYRUbb1SFG68L+fEF+yXR27NZhSzKFTk8=;
        b=JJJnTydomsJFKZlARco1HDMd7dqMpG6wNQC29SHK2HOheaDbN0nUESRNi6CUzB5PYS
         KlhYNSkO2BNqnK1+TyB4z+WYIOUQDIOwhUf68ZqMAJ9pJn/6D/8FRvPgvCw+AneWza60
         ZqcMXXtClW1Qup1/P6crqyG9bTPuBqIjPMP1+v4LulE66785DvkT3Mb9D1VnhlcBhyVQ
         07Fa3ItLeobBQnCDrpRWLMDG/gw3wsgUb1a5W++daReMTl3dNQ0ZkHp3f7kATNgqSk1G
         fGcdCCb+EXCtfhnUVccyYJM7aNNBzksRlB0w1ZJp1U4Hghl9mYrbbH8LB0zR6i7VUVO3
         l2eA==
X-Gm-Message-State: APjAAAWUQsdaD8LDgdqljPO5CCrXSA5iKQY+NhtefCk0mRtMZIeIF71x
        ue8xJecsMf9UzgNefWrXVOtJna3KuhuE3g==
X-Google-Smtp-Source: APXvYqzW5AW8mbrFYj0jm5McWGPTxMYPtwOzhTfncOAiDksqp2LtR6eyWR6PaW6sANsNC/oG0vkaQg==
X-Received: by 2002:a5d:6350:: with SMTP id b16mr94761787wrw.132.1578142995287;
        Sat, 04 Jan 2020 05:03:15 -0800 (PST)
Received: from amanieu-laptop.home ([2a01:cb19:8051:6200:3fe7:84:7f3:e713])
        by smtp.gmail.com with ESMTPSA id z83sm15911096wmg.2.2020.01.04.05.03.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Jan 2020 05:03:14 -0800 (PST)
From:   Amanieu d'Antras <amanieu@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     Christian Brauner <christian@brauner.io>,
        Amanieu d'Antras <amanieu@gmail.com>,
        linux-um@lists.infradead.org, stable@vger.kernel.org
Subject: [PATCH] um: Implement copy_thread_tls
Date:   Sat,  4 Jan 2020 13:39:30 +0100
Message-Id: <20200104123928.1048822-1-amanieu@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102172413.654385-1-amanieu@gmail.com>
References: <20200102172413.654385-1-amanieu@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is required for clone3 which passes the TLS value through a
struct rather than a register.

Signed-off-by: Amanieu d'Antras <amanieu@gmail.com>
Cc: linux-um@lists.infradead.org
Cc: <stable@vger.kernel.org> # 5.3.x
---
 arch/um/Kconfig                      | 1 +
 arch/um/include/asm/ptrace-generic.h | 2 +-
 arch/um/kernel/process.c             | 6 +++---
 arch/x86/um/tls_32.c                 | 6 ++----
 arch/x86/um/tls_64.c                 | 7 +++----
 5 files changed, 10 insertions(+), 12 deletions(-)

diff --git a/arch/um/Kconfig b/arch/um/Kconfig
index 2a6d04fcb3e9..6f0edd0c0220 100644
--- a/arch/um/Kconfig
+++ b/arch/um/Kconfig
@@ -14,6 +14,7 @@ config UML
 	select HAVE_FUTEX_CMPXCHG if FUTEX
 	select HAVE_DEBUG_KMEMLEAK
 	select HAVE_DEBUG_BUGVERBOSE
+	select HAVE_COPY_THREAD_TLS
 	select GENERIC_IRQ_SHOW
 	select GENERIC_CPU_DEVICES
 	select GENERIC_CLOCKEVENTS
diff --git a/arch/um/include/asm/ptrace-generic.h b/arch/um/include/asm/ptrace-generic.h
index 81c647ef9c6c..adf91ef553ae 100644
--- a/arch/um/include/asm/ptrace-generic.h
+++ b/arch/um/include/asm/ptrace-generic.h
@@ -36,7 +36,7 @@ extern long subarch_ptrace(struct task_struct *child, long request,
 extern unsigned long getreg(struct task_struct *child, int regno);
 extern int putreg(struct task_struct *child, int regno, unsigned long value);
 
-extern int arch_copy_tls(struct task_struct *new);
+extern int arch_set_tls(struct task_struct *new, unsigned long tls);
 extern void clear_flushed_tls(struct task_struct *task);
 extern int syscall_trace_enter(struct pt_regs *regs);
 extern void syscall_trace_leave(struct pt_regs *regs);
diff --git a/arch/um/kernel/process.c b/arch/um/kernel/process.c
index 263a8f069133..17045e7211bf 100644
--- a/arch/um/kernel/process.c
+++ b/arch/um/kernel/process.c
@@ -153,8 +153,8 @@ void fork_handler(void)
 	userspace(&current->thread.regs.regs, current_thread_info()->aux_fp_regs);
 }
 
-int copy_thread(unsigned long clone_flags, unsigned long sp,
-		unsigned long arg, struct task_struct * p)
+int copy_thread_tls(unsigned long clone_flags, unsigned long sp,
+		unsigned long arg, struct task_struct * p, unsigned long tls)
 {
 	void (*handler)(void);
 	int kthread = current->flags & PF_KTHREAD;
@@ -188,7 +188,7 @@ int copy_thread(unsigned long clone_flags, unsigned long sp,
 		 * Set a new TLS for the child thread?
 		 */
 		if (clone_flags & CLONE_SETTLS)
-			ret = arch_copy_tls(p);
+			ret = arch_set_tls(p, tls);
 	}
 
 	return ret;
diff --git a/arch/x86/um/tls_32.c b/arch/x86/um/tls_32.c
index 5bd949da7a4a..ac8eee093f9c 100644
--- a/arch/x86/um/tls_32.c
+++ b/arch/x86/um/tls_32.c
@@ -215,14 +215,12 @@ static int set_tls_entry(struct task_struct* task, struct user_desc *info,
 	return 0;
 }
 
-int arch_copy_tls(struct task_struct *new)
+int arch_set_tls(struct task_struct *new, unsigned long tls)
 {
 	struct user_desc info;
 	int idx, ret = -EFAULT;
 
-	if (copy_from_user(&info,
-			   (void __user *) UPT_SI(&new->thread.regs.regs),
-			   sizeof(info)))
+	if (copy_from_user(&info, (void __user *) tls, sizeof(info)))
 		goto out;
 
 	ret = -EINVAL;
diff --git a/arch/x86/um/tls_64.c b/arch/x86/um/tls_64.c
index 3a621e0d3925..ebd3855d9b13 100644
--- a/arch/x86/um/tls_64.c
+++ b/arch/x86/um/tls_64.c
@@ -6,14 +6,13 @@ void clear_flushed_tls(struct task_struct *task)
 {
 }
 
-int arch_copy_tls(struct task_struct *t)
+int arch_set_tls(struct task_struct *t, unsigned long tls)
 {
 	/*
 	 * If CLONE_SETTLS is set, we need to save the thread id
-	 * (which is argument 5, child_tid, of clone) so it can be set
-	 * during context switches.
+	 * so it can be set during context switches.
 	 */
-	t->thread.arch.fs = t->thread.regs.regs.gp[R8 / sizeof(long)];
+	t->thread.arch.fs = tls;
 
 	return 0;
 }
-- 
2.24.1

