Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E00E6FDE6
	for <lists+stable@lfdr.de>; Mon, 22 Jul 2019 12:34:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728490AbfGVKeZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Jul 2019 06:34:25 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:42094 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729333AbfGVKeY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Jul 2019 06:34:24 -0400
Received: by mail-wr1-f66.google.com with SMTP id x1so23855860wrr.9
        for <stable@vger.kernel.org>; Mon, 22 Jul 2019 03:34:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=android.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WHp9M3qJ0as4l0hZ1g8tRt040eeFVSHraEoRw+oQ//4=;
        b=lVzvHNyjXhGIBfrPzTl+TohGrHMUF+zHsn4ABr5GhQibRLk6AY1/lC5Pegy9PQ6XV+
         Mpsa+rsB58b3LRwmQGb8hM5UIXvX9+pvWuV3KZbY3YViakVbf5ykq/dFnGdX6b1Wklts
         fQ/NDggF5fyYG9r8nlq1xFqWV83L2BYa/wofFlyPdVgTkVq70ethZMXMwhmV7f7Ag9F0
         AGl/qcsqX5LMyE37Lz3Eda10MLS8uBPsmUIGa0mbN2lBWyNo1BcG6jusgX99HKDm4cdH
         r4hv4yfmRhpeIcU2OG8hRicvWDpOwmE+vIpEGZ8/iqZ/NJ/jdGnZPYc7GRXyfBW0PFN6
         3WFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WHp9M3qJ0as4l0hZ1g8tRt040eeFVSHraEoRw+oQ//4=;
        b=agMgzj6JLr96iOWUjLKBrcGCT44Hjhn1AVscwtrOkDIM0438xP5ICzjdIi+TBT5r9l
         pMNhfhzwq82lfD8+aRs0jnjZhYAjTWo3IQ8TdN7usicajlRnpv7XXIy1JEzmqO6FlAQl
         11ApeNs+tUOXm9v0rO/5JLsdkBY3IATYw1o8vzks6TrV8s8tsjGqDnowrY6Ay47TdXku
         DKOq/PgPnTt6YYTInzhovUbKM8HfGhZ6Lt7UbGx/Jjs2RnffmVYc3WmTkLjQbsAGx43a
         rbR7uUhNf1iZ+s7XfzpZ0td8LfC1AHR6j7GIu3dtde+YHtAnUZbf5KPQnWQgzDIRWAhY
         XSMA==
X-Gm-Message-State: APjAAAWzaRC/xMf0e+lj2AZSgSjZkMbodZ33zVmGlJ3+CTLahFPYznpS
        wyueA7xvb0u+DgDK1nI0mcszER+P
X-Google-Smtp-Source: APXvYqy5rurIXBJxhE1kLqa2mlYyyr0PTD5jR8QsrZcd1WR1OdjmcgVJMtVgiF4oUGuZvH/N4yhLLQ==
X-Received: by 2002:adf:e4c6:: with SMTP id v6mr70915293wrm.315.1563791661888;
        Mon, 22 Jul 2019 03:34:21 -0700 (PDT)
Received: from balsini.lon.corp.google.com ([2a00:79e0:d:210:e751:37a0:1e95:e65d])
        by smtp.gmail.com with ESMTPSA id g25sm28217197wmk.39.2019.07.22.03.34.21
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 22 Jul 2019 03:34:21 -0700 (PDT)
From:   Alessio Balsini <balsini@android.com>
To:     gregkh@linuxfoundation.org
Cc:     astrachan@google.com, maennich@google.com, kernel-team@android.com,
        stable@vger.kernel.org
Subject: [PATCH 4.9 2/2] um: Fix FP register size for XSTATE/XSAVE
Date:   Mon, 22 Jul 2019 11:33:38 +0100
Message-Id: <20190722103338.111753-2-balsini@android.com>
X-Mailer: git-send-email 2.22.0.657.g960e92d24f-goog
In-Reply-To: <20190722103338.111753-1-balsini@android.com>
References: <20190722103338.111753-1-balsini@android.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Meyer <thomas@m3y3r.de>

commit 6f602afda7275c24c20ba38b5b6cd4ed08561fff upstream.

Hard code max size. Taken from
https://sourceware.org/git/?p=binutils-gdb.git;a=blob;f=gdb/common/x86-xstate.h

Change-Id: Iae6c1559b757e0c6a1d221f8e677573642dde05c
Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Alessio Balsini <balsini@android.com>
---
 arch/um/include/asm/thread_info.h |  3 +++
 arch/um/include/shared/os.h       |  2 +-
 arch/um/kernel/process.c          |  4 ++--
 arch/um/os-Linux/skas/process.c   | 17 ++++++++---------
 arch/x86/um/os-Linux/registers.c  | 18 ++++++++++++------
 arch/x86/um/user-offsets.c        |  4 ++--
 6 files changed, 28 insertions(+), 20 deletions(-)

diff --git a/arch/um/include/asm/thread_info.h b/arch/um/include/asm/thread_info.h
index 053baff03674..9300f7630d2a 100644
--- a/arch/um/include/asm/thread_info.h
+++ b/arch/um/include/asm/thread_info.h
@@ -11,6 +11,7 @@
 #include <asm/types.h>
 #include <asm/page.h>
 #include <asm/segment.h>
+#include <sysdep/ptrace_user.h>
 
 struct thread_info {
 	struct task_struct	*task;		/* main task structure */
@@ -22,6 +23,8 @@ struct thread_info {
 					 	   0-0xBFFFFFFF for user
 						   0-0xFFFFFFFF for kernel */
 	struct thread_info	*real_thread;    /* Points to non-IRQ stack */
+	unsigned long aux_fp_regs[FP_SIZE];	/* auxiliary fp_regs to save/restore
+						   them out-of-band */
 };
 
 #define INIT_THREAD_INFO(tsk)			\
diff --git a/arch/um/include/shared/os.h b/arch/um/include/shared/os.h
index de5d572225f3..cc64f0579949 100644
--- a/arch/um/include/shared/os.h
+++ b/arch/um/include/shared/os.h
@@ -274,7 +274,7 @@ extern int protect(struct mm_id * mm_idp, unsigned long addr,
 extern int is_skas_winch(int pid, int fd, void *data);
 extern int start_userspace(unsigned long stub_stack);
 extern int copy_context_skas0(unsigned long stack, int pid);
-extern void userspace(struct uml_pt_regs *regs);
+extern void userspace(struct uml_pt_regs *regs, unsigned long *aux_fp_regs);
 extern int map_stub_pages(int fd, unsigned long code, unsigned long data,
 			  unsigned long stack);
 extern void new_thread(void *stack, jmp_buf *buf, void (*handler)(void));
diff --git a/arch/um/kernel/process.c b/arch/um/kernel/process.c
index 034b42c7ab40..787568044a2a 100644
--- a/arch/um/kernel/process.c
+++ b/arch/um/kernel/process.c
@@ -128,7 +128,7 @@ void new_thread_handler(void)
 	 * callback returns only if the kernel thread execs a process
 	 */
 	n = fn(arg);
-	userspace(&current->thread.regs.regs);
+	userspace(&current->thread.regs.regs, current_thread_info()->aux_fp_regs);
 }
 
 /* Called magically, see new_thread_handler above */
@@ -147,7 +147,7 @@ void fork_handler(void)
 
 	current->thread.prev_sched = NULL;
 
-	userspace(&current->thread.regs.regs);
+	userspace(&current->thread.regs.regs, current_thread_info()->aux_fp_regs);
 }
 
 int copy_thread(unsigned long clone_flags, unsigned long sp,
diff --git a/arch/um/os-Linux/skas/process.c b/arch/um/os-Linux/skas/process.c
index 0a99d4515065..cd4a6ff676a8 100644
--- a/arch/um/os-Linux/skas/process.c
+++ b/arch/um/os-Linux/skas/process.c
@@ -87,12 +87,11 @@ void wait_stub_done(int pid)
 
 extern unsigned long current_stub_stack(void);
 
-static void get_skas_faultinfo(int pid, struct faultinfo *fi)
+static void get_skas_faultinfo(int pid, struct faultinfo *fi, unsigned long *aux_fp_regs)
 {
 	int err;
-	unsigned long fpregs[FP_SIZE];
 
-	err = get_fp_registers(pid, fpregs);
+	err = get_fp_registers(pid, aux_fp_regs);
 	if (err < 0) {
 		printk(UM_KERN_ERR "save_fp_registers returned %d\n",
 		       err);
@@ -112,7 +111,7 @@ static void get_skas_faultinfo(int pid, struct faultinfo *fi)
 	 */
 	memcpy(fi, (void *)current_stub_stack(), sizeof(*fi));
 
-	err = put_fp_registers(pid, fpregs);
+	err = put_fp_registers(pid, aux_fp_regs);
 	if (err < 0) {
 		printk(UM_KERN_ERR "put_fp_registers returned %d\n",
 		       err);
@@ -120,9 +119,9 @@ static void get_skas_faultinfo(int pid, struct faultinfo *fi)
 	}
 }
 
-static void handle_segv(int pid, struct uml_pt_regs * regs)
+static void handle_segv(int pid, struct uml_pt_regs *regs, unsigned long *aux_fp_regs)
 {
-	get_skas_faultinfo(pid, &regs->faultinfo);
+	get_skas_faultinfo(pid, &regs->faultinfo, aux_fp_regs);
 	segv(regs->faultinfo, 0, 1, NULL);
 }
 
@@ -305,7 +304,7 @@ int start_userspace(unsigned long stub_stack)
 	return err;
 }
 
-void userspace(struct uml_pt_regs *regs)
+void userspace(struct uml_pt_regs *regs, unsigned long *aux_fp_regs)
 {
 	int err, status, op, pid = userspace_pid[0];
 	/* To prevent races if using_sysemu changes under us.*/
@@ -374,11 +373,11 @@ void userspace(struct uml_pt_regs *regs)
 			case SIGSEGV:
 				if (PTRACE_FULL_FAULTINFO) {
 					get_skas_faultinfo(pid,
-							   &regs->faultinfo);
+							   &regs->faultinfo, aux_fp_regs);
 					(*sig_info[SIGSEGV])(SIGSEGV, (struct siginfo *)&si,
 							     regs);
 				}
-				else handle_segv(pid, regs);
+				else handle_segv(pid, regs, aux_fp_regs);
 				break;
 			case SIGTRAP + 0x80:
 			        handle_trap(pid, regs, local_using_sysemu);
diff --git a/arch/x86/um/os-Linux/registers.c b/arch/x86/um/os-Linux/registers.c
index 28775f55bde2..3c423dfcd78b 100644
--- a/arch/x86/um/os-Linux/registers.c
+++ b/arch/x86/um/os-Linux/registers.c
@@ -5,6 +5,7 @@
  */
 
 #include <errno.h>
+#include <stdlib.h>
 #include <sys/ptrace.h>
 #ifdef __i386__
 #include <sys/user.h>
@@ -31,7 +32,7 @@ int save_fp_registers(int pid, unsigned long *fp_regs)
 
 	if (have_xstate_support) {
 		iov.iov_base = fp_regs;
-		iov.iov_len = sizeof(struct _xstate);
+		iov.iov_len = FP_SIZE * sizeof(unsigned long);
 		if (ptrace(PTRACE_GETREGSET, pid, NT_X86_XSTATE, &iov) < 0)
 			return -errno;
 		return 0;
@@ -51,10 +52,9 @@ int restore_fp_registers(int pid, unsigned long *fp_regs)
 {
 #ifdef PTRACE_SETREGSET
 	struct iovec iov;
-
 	if (have_xstate_support) {
 		iov.iov_base = fp_regs;
-		iov.iov_len = sizeof(struct _xstate);
+		iov.iov_len = FP_SIZE * sizeof(unsigned long);
 		if (ptrace(PTRACE_SETREGSET, pid, NT_X86_XSTATE, &iov) < 0)
 			return -errno;
 		return 0;
@@ -125,13 +125,19 @@ int put_fp_registers(int pid, unsigned long *regs)
 void arch_init_registers(int pid)
 {
 #ifdef PTRACE_GETREGSET
-	struct _xstate fp_regs;
+	void * fp_regs;
 	struct iovec iov;
 
-	iov.iov_base = &fp_regs;
-	iov.iov_len = sizeof(struct _xstate);
+	fp_regs = malloc(FP_SIZE * sizeof(unsigned long));
+	if(fp_regs == NULL)
+		return;
+
+	iov.iov_base = fp_regs;
+	iov.iov_len = FP_SIZE * sizeof(unsigned long);
 	if (ptrace(PTRACE_GETREGSET, pid, NT_X86_XSTATE, &iov) == 0)
 		have_xstate_support = 1;
+
+	free(fp_regs);
 #endif
 }
 #endif
diff --git a/arch/x86/um/user-offsets.c b/arch/x86/um/user-offsets.c
index 8af0fb5d2780..7bcd10614f8b 100644
--- a/arch/x86/um/user-offsets.c
+++ b/arch/x86/um/user-offsets.c
@@ -50,8 +50,8 @@ void foo(void)
 	DEFINE(HOST_GS, GS);
 	DEFINE(HOST_ORIG_AX, ORIG_EAX);
 #else
-#if defined(PTRACE_GETREGSET) && defined(PTRACE_SETREGSET)
-	DEFINE(HOST_FP_SIZE, sizeof(struct _xstate) / sizeof(unsigned long));
+#ifdef FP_XSTATE_MAGIC1
+	DEFINE_LONGS(HOST_FP_SIZE, 2696);
 #else
 	DEFINE(HOST_FP_SIZE, sizeof(struct _fpstate) / sizeof(unsigned long));
 #endif
-- 
2.22.0.657.g960e92d24f-goog

