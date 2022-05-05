Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86F9251C802
	for <lists+stable@lfdr.de>; Thu,  5 May 2022 20:37:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383368AbiEESh4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 May 2022 14:37:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376753AbiEEShG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 May 2022 14:37:06 -0400
Received: from out02.mta.xmission.com (out02.mta.xmission.com [166.70.13.232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E16F75DBFA;
        Thu,  5 May 2022 11:27:20 -0700 (PDT)
Received: from in01.mta.xmission.com ([166.70.13.51]:53346)
        by out02.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1nmgC7-007BrK-Rg; Thu, 05 May 2022 12:27:19 -0600
Received: from ip68-227-174-4.om.om.cox.net ([68.227.174.4]:37118 helo=localhost.localdomain)
        by in01.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1nmgC6-002BtP-LD; Thu, 05 May 2022 12:27:19 -0600
From:   "Eric W. Biederman" <ebiederm@xmission.com>
To:     linux-kernel@vger.kernel.org
Cc:     rjw@rjwysocki.net, Oleg Nesterov <oleg@redhat.com>,
        mingo@kernel.org, vincent.guittot@linaro.org,
        dietmar.eggemann@arm.com, rostedt@goodmis.org, mgorman@suse.de,
        bigeasy@linutronix.de, Will Deacon <will@kernel.org>,
        tj@kernel.org, linux-pm@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Richard Weinberger <richard@nod.at>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-um@lists.infradead.org, Chris Zankel <chris@zankel.net>,
        Max Filippov <jcmvbkbc@gmail.com>,
        linux-xtensa@linux-xtensa.org, Kees Cook <keescook@chromium.org>,
        Jann Horn <jannh@google.com>, linux-ia64@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>, stable@vger.kernel.org
Date:   Thu,  5 May 2022 13:26:36 -0500
Message-Id: <20220505182645.497868-3-ebiederm@xmission.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <87a6bv6dl6.fsf_-_@email.froward.int.ebiederm.org>
References: <87a6bv6dl6.fsf_-_@email.froward.int.ebiederm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-XM-SPF: eid=1nmgC6-002BtP-LD;;;mid=<20220505182645.497868-3-ebiederm@xmission.com>;;;hst=in01.mta.xmission.com;;;ip=68.227.174.4;;;frm=ebiederm@xmission.com;;;spf=softfail
X-XM-AID: U2FsdGVkX1+NY/+R9b/DDPjmitNF/LecD2BgPTMG9GU=
X-SA-Exim-Connect-IP: 68.227.174.4
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=61 
X-Spam-Combo: ***;linux-kernel@vger.kernel.org
X-Spam-Relay-Country: 
X-Spam-Timing: total 582 ms - load_scoreonly_sql: 0.12 (0.0%),
        signal_user_changed: 12 (2.0%), b_tie_ro: 10 (1.7%), parse: 1.92
        (0.3%), extract_message_metadata: 23 (4.0%), get_uri_detail_list: 4.4
        (0.8%), tests_pri_-1000: 23 (3.9%), tests_pri_-950: 1.58 (0.3%),
        tests_pri_-900: 1.30 (0.2%), tests_pri_-90: 73 (12.5%), check_bayes:
        71 (12.2%), b_tokenize: 15 (2.6%), b_tok_get_all: 10 (1.8%),
        b_comp_prob: 3.2 (0.5%), b_tok_touch_all: 39 (6.6%), b_finish: 0.88
        (0.2%), tests_pri_0: 426 (73.1%), check_dkim_signature: 0.79 (0.1%),
        check_dkim_adsp: 2.7 (0.5%), poll_dns_idle: 0.80 (0.1%), tests_pri_10:
        2.3 (0.4%), tests_pri_500: 14 (2.4%), rewrite_mail: 0.00 (0.0%)
Subject: [PATCH v4 03/12] ptrace/um: Replace PT_DTRACE with TIF_SINGLESTEP
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

User mode linux is the last user of the PT_DTRACE flag.  Using the flag to indicate
single stepping is a little confusing and worse changing tsk->ptrace without locking
could potentionally cause problems.

So use a thread info flag with a better name instead of flag in tsk->ptrace.

Remove the definition PT_DTRACE as uml is the last user.

Cc: stable@vger.kernel.org
Acked-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 arch/um/include/asm/thread_info.h | 2 ++
 arch/um/kernel/exec.c             | 2 +-
 arch/um/kernel/process.c          | 2 +-
 arch/um/kernel/ptrace.c           | 8 ++++----
 arch/um/kernel/signal.c           | 4 ++--
 include/linux/ptrace.h            | 1 -
 6 files changed, 10 insertions(+), 9 deletions(-)

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
-- 
2.35.3

