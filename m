Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 061417F2A9
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 11:50:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392004AbfHBJpq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 05:45:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:49586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389830AbfHBJpp (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 05:45:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 379712086A;
        Fri,  2 Aug 2019 09:45:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564739144;
        bh=AKQhjteocrQMI7UQfRyLsQ+LF8i58Uc+bRj4Ny7xIFM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MPQmVStuQxXmFm0HO0VRZVTd0k5vX+yFNUA1geGBJciVQiW9cBUL/fGWBeiZvDq//
         I19DOHk+BbKKFXHkWaIWlZv9iL9NTiEkLAUSzVpseelfgPckcbKlrAh+sar4JSAgeD
         NdtplKGT/1SxSI5HfxBZHjzpySuMyWb9UdFzrPH0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Meyer <thomas@m3y3r.de>,
        Richard Weinberger <richard@nod.at>,
        Alessio Balsini <balsini@android.com>
Subject: [PATCH 4.9 115/223] um: Fix FP register size for XSTATE/XSAVE
Date:   Fri,  2 Aug 2019 11:35:40 +0200
Message-Id: <20190802092246.659891145@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190802092238.692035242@linuxfoundation.org>
References: <20190802092238.692035242@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Meyer <thomas@m3y3r.de>

commit 6f602afda7275c24c20ba38b5b6cd4ed08561fff upstream.

Hard code max size. Taken from
https://sourceware.org/git/?p=binutils-gdb.git;a=blob;f=gdb/common/x86-xstate.h

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Alessio Balsini <balsini@android.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/um/include/asm/thread_info.h |    3 +++
 arch/um/include/shared/os.h       |    2 +-
 arch/um/kernel/process.c          |    4 ++--
 arch/um/os-Linux/skas/process.c   |   17 ++++++++---------
 arch/x86/um/os-Linux/registers.c  |   18 ++++++++++++------
 arch/x86/um/user-offsets.c        |    4 ++--
 6 files changed, 28 insertions(+), 20 deletions(-)

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
--- a/arch/um/include/shared/os.h
+++ b/arch/um/include/shared/os.h
@@ -274,7 +274,7 @@ extern int protect(struct mm_id * mm_idp
 extern int is_skas_winch(int pid, int fd, void *data);
 extern int start_userspace(unsigned long stub_stack);
 extern int copy_context_skas0(unsigned long stack, int pid);
-extern void userspace(struct uml_pt_regs *regs);
+extern void userspace(struct uml_pt_regs *regs, unsigned long *aux_fp_regs);
 extern int map_stub_pages(int fd, unsigned long code, unsigned long data,
 			  unsigned long stack);
 extern void new_thread(void *stack, jmp_buf *buf, void (*handler)(void));
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
--- a/arch/um/os-Linux/skas/process.c
+++ b/arch/um/os-Linux/skas/process.c
@@ -87,12 +87,11 @@ bad_wait:
 
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
@@ -112,7 +111,7 @@ static void get_skas_faultinfo(int pid,
 	 */
 	memcpy(fi, (void *)current_stub_stack(), sizeof(*fi));
 
-	err = put_fp_registers(pid, fpregs);
+	err = put_fp_registers(pid, aux_fp_regs);
 	if (err < 0) {
 		printk(UM_KERN_ERR "put_fp_registers returned %d\n",
 		       err);
@@ -120,9 +119,9 @@ static void get_skas_faultinfo(int pid,
 	}
 }
 
-static void handle_segv(int pid, struct uml_pt_regs * regs)
+static void handle_segv(int pid, struct uml_pt_regs *regs, unsigned long *aux_fp_regs)
 {
-	get_skas_faultinfo(pid, &regs->faultinfo);
+	get_skas_faultinfo(pid, &regs->faultinfo, aux_fp_regs);
 	segv(regs->faultinfo, 0, 1, NULL);
 }
 
@@ -305,7 +304,7 @@ int start_userspace(unsigned long stub_s
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
--- a/arch/x86/um/os-Linux/registers.c
+++ b/arch/x86/um/os-Linux/registers.c
@@ -5,6 +5,7 @@
  */
 
 #include <errno.h>
+#include <stdlib.h>
 #include <sys/ptrace.h>
 #ifdef __i386__
 #include <sys/user.h>
@@ -31,7 +32,7 @@ int save_fp_registers(int pid, unsigned
 
 	if (have_xstate_support) {
 		iov.iov_base = fp_regs;
-		iov.iov_len = sizeof(struct _xstate);
+		iov.iov_len = FP_SIZE * sizeof(unsigned long);
 		if (ptrace(PTRACE_GETREGSET, pid, NT_X86_XSTATE, &iov) < 0)
 			return -errno;
 		return 0;
@@ -51,10 +52,9 @@ int restore_fp_registers(int pid, unsign
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
@@ -125,13 +125,19 @@ int put_fp_registers(int pid, unsigned l
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


