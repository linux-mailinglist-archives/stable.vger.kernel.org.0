Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 927AD53E74C
	for <lists+stable@lfdr.de>; Mon,  6 Jun 2022 19:07:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233071AbiFFJb5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jun 2022 05:31:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233067AbiFFJbz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jun 2022 05:31:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C226A192C54
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 02:31:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0AF9CB816E6
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 09:31:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5589CC385A9;
        Mon,  6 Jun 2022 09:31:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654507910;
        bh=phsWbtWZzPph8BUXutoWbnlaJ9Irbr7vcfgAYs0pNio=;
        h=Subject:To:Cc:From:Date:From;
        b=CSAhghXLicrERDkuGojfbuh9aSy/+Yy1Tep3SA+fGrYBOysNhLtVOf+e9JPB9L95R
         rf11uRcDPoYOwHncstCyB+h7Y3vEq96hZxiXecgDQ48W0Sq6RSd7rbcJsEYevIuaoH
         V4pygDnTNkemIKHbXx5iVhHqp8C9WvWd2vMLEMu8=
Subject: FAILED: patch "[PATCH] ptrace/um: Replace PT_DTRACE with TIF_SINGLESTEP" failed to apply to 4.14-stable tree
To:     ebiederm@xmission.com, johannes@sipsolutions.net,
        keescook@chromium.org, oleg@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 06 Jun 2022 11:31:36 +0200
Message-ID: <165450789615169@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From c200e4bb44e80b343c09841e7caaaca0aac5e5fa Mon Sep 17 00:00:00 2001
From: "Eric W. Biederman" <ebiederm@xmission.com>
Date: Tue, 26 Apr 2022 16:30:17 -0500
Subject: [PATCH] ptrace/um: Replace PT_DTRACE with TIF_SINGLESTEP

User mode linux is the last user of the PT_DTRACE flag.  Using the flag to indicate
single stepping is a little confusing and worse changing tsk->ptrace without locking
could potentionally cause problems.

So use a thread info flag with a better name instead of flag in tsk->ptrace.

Remove the definition PT_DTRACE as uml is the last user.

Cc: stable@vger.kernel.org
Acked-by: Johannes Berg <johannes@sipsolutions.net>
Tested-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Link: https://lkml.kernel.org/r/20220505182645.497868-3-ebiederm@xmission.com
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>

diff --git a/arch/um/include/asm/thread_info.h b/arch/um/include/asm/thread_info.h
index 1395cbd7e340..c7b4b49826a2 100644
--- a/arch/um/include/asm/thread_info.h
+++ b/arch/um/include/asm/thread_info.h
@@ -60,6 +60,7 @@ static inline struct thread_info *current_thread_info(void)
 #define TIF_RESTORE_SIGMASK	7
 #define TIF_NOTIFY_RESUME	8
 #define TIF_SECCOMP		9	/* secure computing */
+#define TIF_SINGLESTEP		10	/* single stepping userspace */
 
 #define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
 #define _TIF_SIGPENDING		(1 << TIF_SIGPENDING)
@@ -68,5 +69,6 @@ static inline struct thread_info *current_thread_info(void)
 #define _TIF_MEMDIE		(1 << TIF_MEMDIE)
 #define _TIF_SYSCALL_AUDIT	(1 << TIF_SYSCALL_AUDIT)
 #define _TIF_SECCOMP		(1 << TIF_SECCOMP)
+#define _TIF_SINGLESTEP		(1 << TIF_SINGLESTEP)
 
 #endif
diff --git a/arch/um/kernel/exec.c b/arch/um/kernel/exec.c
index c85e40c72779..58938d75871a 100644
--- a/arch/um/kernel/exec.c
+++ b/arch/um/kernel/exec.c
@@ -43,7 +43,7 @@ void start_thread(struct pt_regs *regs, unsigned long eip, unsigned long esp)
 {
 	PT_REGS_IP(regs) = eip;
 	PT_REGS_SP(regs) = esp;
-	current->ptrace &= ~PT_DTRACE;
+	clear_thread_flag(TIF_SINGLESTEP);
 #ifdef SUBARCH_EXECVE1
 	SUBARCH_EXECVE1(regs->regs);
 #endif
diff --git a/arch/um/kernel/process.c b/arch/um/kernel/process.c
index 80504680be08..88c5c7844281 100644
--- a/arch/um/kernel/process.c
+++ b/arch/um/kernel/process.c
@@ -335,7 +335,7 @@ int singlestepping(void * t)
 {
 	struct task_struct *task = t ? t : current;
 
-	if (!(task->ptrace & PT_DTRACE))
+	if (!test_thread_flag(TIF_SINGLESTEP))
 		return 0;
 
 	if (task->thread.singlestep_syscall)
diff --git a/arch/um/kernel/ptrace.c b/arch/um/kernel/ptrace.c
index bfaf6ab1ac03..5154b27de580 100644
--- a/arch/um/kernel/ptrace.c
+++ b/arch/um/kernel/ptrace.c
@@ -11,7 +11,7 @@
 
 void user_enable_single_step(struct task_struct *child)
 {
-	child->ptrace |= PT_DTRACE;
+	set_tsk_thread_flag(child, TIF_SINGLESTEP);
 	child->thread.singlestep_syscall = 0;
 
 #ifdef SUBARCH_SET_SINGLESTEPPING
@@ -21,7 +21,7 @@ void user_enable_single_step(struct task_struct *child)
 
 void user_disable_single_step(struct task_struct *child)
 {
-	child->ptrace &= ~PT_DTRACE;
+	clear_tsk_thread_flag(child, TIF_SINGLESTEP);
 	child->thread.singlestep_syscall = 0;
 
 #ifdef SUBARCH_SET_SINGLESTEPPING
@@ -120,7 +120,7 @@ static void send_sigtrap(struct uml_pt_regs *regs, int error_code)
 }
 
 /*
- * XXX Check PT_DTRACE vs TIF_SINGLESTEP for singlestepping check and
+ * XXX Check TIF_SINGLESTEP for singlestepping check and
  * PT_PTRACED vs TIF_SYSCALL_TRACE for syscall tracing check
  */
 int syscall_trace_enter(struct pt_regs *regs)
@@ -144,7 +144,7 @@ void syscall_trace_leave(struct pt_regs *regs)
 	audit_syscall_exit(regs);
 
 	/* Fake a debug trap */
-	if (ptraced & PT_DTRACE)
+	if (test_thread_flag(TIF_SINGLESTEP))
 		send_sigtrap(&regs->regs, 0);
 
 	if (!test_thread_flag(TIF_SYSCALL_TRACE))
diff --git a/arch/um/kernel/signal.c b/arch/um/kernel/signal.c
index 88cd9b5c1b74..ae4658f576ab 100644
--- a/arch/um/kernel/signal.c
+++ b/arch/um/kernel/signal.c
@@ -53,7 +53,7 @@ static void handle_signal(struct ksignal *ksig, struct pt_regs *regs)
 	unsigned long sp;
 	int err;
 
-	if ((current->ptrace & PT_DTRACE) && (current->ptrace & PT_PTRACED))
+	if (test_thread_flag(TIF_SINGLESTEP) && (current->ptrace & PT_PTRACED))
 		singlestep = 1;
 
 	/* Did we come from a system call? */
@@ -128,7 +128,7 @@ void do_signal(struct pt_regs *regs)
 	 * on the host.  The tracing thread will check this flag and
 	 * PTRACE_SYSCALL if necessary.
 	 */
-	if (current->ptrace & PT_DTRACE)
+	if (test_thread_flag(TIF_SINGLESTEP))
 		current->thread.singlestep_syscall =
 			is_syscall(PT_REGS_IP(&current->thread.regs));
 
diff --git a/include/linux/ptrace.h b/include/linux/ptrace.h
index 15b3d176b6b4..4c06f9f8ef3f 100644
--- a/include/linux/ptrace.h
+++ b/include/linux/ptrace.h
@@ -30,7 +30,6 @@ extern int ptrace_access_vm(struct task_struct *tsk, unsigned long addr,
 
 #define PT_SEIZED	0x00010000	/* SEIZE used, enable new behavior */
 #define PT_PTRACED	0x00000001
-#define PT_DTRACE	0x00000002	/* delayed trace (used on m68k, i386) */
 
 #define PT_OPT_FLAG_SHIFT	3
 /* PT_TRACE_* event enable flags */

