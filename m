Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8706554086C
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 19:58:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348968AbiFGR6e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 13:58:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348979AbiFGR5i (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 13:57:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40D73403D4;
        Tue,  7 Jun 2022 10:40:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 493566137B;
        Tue,  7 Jun 2022 17:40:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5431FC385A5;
        Tue,  7 Jun 2022 17:40:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654623637;
        bh=ITUahHDwW1gTaJlV8oHzxviHbnKXY4XzaJ5No6iHqSQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RcKXqVhgi4I76MNFK9UgFE3m8e3FwS9Zay6p95caw9Qzmorf14RcwnzKrjnOdYJd6
         1JEeqkqk1VNjSA4ZnIIOOflbGKYEuoJvkInIFEBpOF8bXfL8hMb9FomHindZaPdwx6
         nDIXb4iXzyx6XnoIUuARWp8Nat+popoe1jq3rueQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes@sipsolutions.net>,
        Kees Cook <keescook@chromium.org>,
        Oleg Nesterov <oleg@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH 5.15 036/667] ptrace/um: Replace PT_DTRACE with TIF_SINGLESTEP
Date:   Tue,  7 Jun 2022 18:55:01 +0200
Message-Id: <20220607164935.880810460@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Eric W. Biederman <ebiederm@xmission.com>

commit c200e4bb44e80b343c09841e7caaaca0aac5e5fa upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/um/include/asm/thread_info.h |    2 ++
 arch/um/kernel/exec.c             |    2 +-
 arch/um/kernel/process.c          |    2 +-
 arch/um/kernel/ptrace.c           |    8 ++++----
 arch/um/kernel/signal.c           |    4 ++--
 include/linux/ptrace.h            |    1 -
 6 files changed, 10 insertions(+), 9 deletions(-)

--- a/arch/um/include/asm/thread_info.h
+++ b/arch/um/include/asm/thread_info.h
@@ -64,6 +64,7 @@ static inline struct thread_info *curren
 #define TIF_RESTORE_SIGMASK	7
 #define TIF_NOTIFY_RESUME	8
 #define TIF_SECCOMP		9	/* secure computing */
+#define TIF_SINGLESTEP		10	/* single stepping userspace */
 
 #define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
 #define _TIF_SIGPENDING		(1 << TIF_SIGPENDING)
@@ -72,5 +73,6 @@ static inline struct thread_info *curren
 #define _TIF_MEMDIE		(1 << TIF_MEMDIE)
 #define _TIF_SYSCALL_AUDIT	(1 << TIF_SYSCALL_AUDIT)
 #define _TIF_SECCOMP		(1 << TIF_SECCOMP)
+#define _TIF_SINGLESTEP		(1 << TIF_SINGLESTEP)
 
 #endif
--- a/arch/um/kernel/exec.c
+++ b/arch/um/kernel/exec.c
@@ -42,7 +42,7 @@ void start_thread(struct pt_regs *regs,
 {
 	PT_REGS_IP(regs) = eip;
 	PT_REGS_SP(regs) = esp;
-	current->ptrace &= ~PT_DTRACE;
+	clear_thread_flag(TIF_SINGLESTEP);
 #ifdef SUBARCH_EXECVE1
 	SUBARCH_EXECVE1(regs->regs);
 #endif
--- a/arch/um/kernel/process.c
+++ b/arch/um/kernel/process.c
@@ -339,7 +339,7 @@ int singlestepping(void * t)
 {
 	struct task_struct *task = t ? t : current;
 
-	if (!(task->ptrace & PT_DTRACE))
+	if (!test_thread_flag(TIF_SINGLESTEP))
 		return 0;
 
 	if (task->thread.singlestep_syscall)
--- a/arch/um/kernel/ptrace.c
+++ b/arch/um/kernel/ptrace.c
@@ -12,7 +12,7 @@
 
 void user_enable_single_step(struct task_struct *child)
 {
-	child->ptrace |= PT_DTRACE;
+	set_tsk_thread_flag(child, TIF_SINGLESTEP);
 	child->thread.singlestep_syscall = 0;
 
 #ifdef SUBARCH_SET_SINGLESTEPPING
@@ -22,7 +22,7 @@ void user_enable_single_step(struct task
 
 void user_disable_single_step(struct task_struct *child)
 {
-	child->ptrace &= ~PT_DTRACE;
+	clear_tsk_thread_flag(child, TIF_SINGLESTEP);
 	child->thread.singlestep_syscall = 0;
 
 #ifdef SUBARCH_SET_SINGLESTEPPING
@@ -121,7 +121,7 @@ static void send_sigtrap(struct uml_pt_r
 }
 
 /*
- * XXX Check PT_DTRACE vs TIF_SINGLESTEP for singlestepping check and
+ * XXX Check TIF_SINGLESTEP for singlestepping check and
  * PT_PTRACED vs TIF_SYSCALL_TRACE for syscall tracing check
  */
 int syscall_trace_enter(struct pt_regs *regs)
@@ -145,7 +145,7 @@ void syscall_trace_leave(struct pt_regs
 	audit_syscall_exit(regs);
 
 	/* Fake a debug trap */
-	if (ptraced & PT_DTRACE)
+	if (test_thread_flag(TIF_SINGLESTEP))
 		send_sigtrap(&regs->regs, 0);
 
 	if (!test_thread_flag(TIF_SYSCALL_TRACE))
--- a/arch/um/kernel/signal.c
+++ b/arch/um/kernel/signal.c
@@ -53,7 +53,7 @@ static void handle_signal(struct ksignal
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
 
--- a/include/linux/ptrace.h
+++ b/include/linux/ptrace.h
@@ -30,7 +30,6 @@ extern int ptrace_access_vm(struct task_
 
 #define PT_SEIZED	0x00010000	/* SEIZE used, enable new behavior */
 #define PT_PTRACED	0x00000001
-#define PT_DTRACE	0x00000002	/* delayed trace (used on m68k, i386) */
 
 #define PT_OPT_FLAG_SHIFT	3
 /* PT_TRACE_* event enable flags */


