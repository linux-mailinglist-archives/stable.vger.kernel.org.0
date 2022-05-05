Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E33A51C7C2
	for <lists+stable@lfdr.de>; Thu,  5 May 2022 20:37:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384412AbiEESh7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 May 2022 14:37:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384359AbiEEShG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 May 2022 14:37:06 -0400
Received: from out03.mta.xmission.com (out03.mta.xmission.com [166.70.13.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6555A186F1;
        Thu,  5 May 2022 11:27:24 -0700 (PDT)
Received: from in01.mta.xmission.com ([166.70.13.51]:59420)
        by out03.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1nmgCB-00GUsJ-0O; Thu, 05 May 2022 12:27:23 -0600
Received: from ip68-227-174-4.om.om.cox.net ([68.227.174.4]:37118 helo=localhost.localdomain)
        by in01.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1nmgC9-002BtP-Tj; Thu, 05 May 2022 12:27:22 -0600
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
Date:   Thu,  5 May 2022 13:26:37 -0500
Message-Id: <20220505182645.497868-4-ebiederm@xmission.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <87a6bv6dl6.fsf_-_@email.froward.int.ebiederm.org>
References: <87a6bv6dl6.fsf_-_@email.froward.int.ebiederm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-XM-SPF: eid=1nmgC9-002BtP-Tj;;;mid=<20220505182645.497868-4-ebiederm@xmission.com>;;;hst=in01.mta.xmission.com;;;ip=68.227.174.4;;;frm=ebiederm@xmission.com;;;spf=softfail
X-XM-AID: U2FsdGVkX1973aY/WpSed+2TdikIYWg88TidXM1HgGQ=
X-SA-Exim-Connect-IP: 68.227.174.4
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=54 
X-Spam-Combo: ***;linux-kernel@vger.kernel.org
X-Spam-Relay-Country: 
X-Spam-Timing: total 466 ms - load_scoreonly_sql: 0.04 (0.0%),
        signal_user_changed: 11 (2.4%), b_tie_ro: 10 (2.1%), parse: 1.17
        (0.3%), extract_message_metadata: 14 (2.9%), get_uri_detail_list: 2.4
        (0.5%), tests_pri_-1000: 14 (3.1%), tests_pri_-950: 1.25 (0.3%),
        tests_pri_-900: 1.06 (0.2%), tests_pri_-90: 110 (23.6%), check_bayes:
        109 (23.3%), b_tokenize: 10 (2.1%), b_tok_get_all: 9 (1.9%),
        b_comp_prob: 2.6 (0.6%), b_tok_touch_all: 84 (18.0%), b_finish: 0.89
        (0.2%), tests_pri_0: 299 (64.1%), check_dkim_signature: 0.53 (0.1%),
        check_dkim_adsp: 2.8 (0.6%), poll_dns_idle: 0.98 (0.2%), tests_pri_10:
        2.9 (0.6%), tests_pri_500: 9 (1.8%), rewrite_mail: 0.00 (0.0%)
Subject: [PATCH v4 04/12] ptrace/xtensa: Replace PT_SINGLESTEP with TIF_SINGLESTEP
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

xtensa is the last user of the PT_SINGLESTEP flag.  Changing tsk->ptrace in
user_enable_single_step and user_disable_single_step without locking could
potentiallly cause problems.

So use a thread info flag instead of a flag in tsk->ptrace.  Use TIF_SINGLESTEP
that xtensa already had defined but unused.

Remove the definitions of PT_SINGLESTEP and PT_BLOCKSTEP as they have no more users.

Cc: stable@vger.kernel.org
Acked-by: Max Filippov <jcmvbkbc@gmail.com>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 arch/xtensa/kernel/ptrace.c | 4 ++--
 arch/xtensa/kernel/signal.c | 4 ++--
 include/linux/ptrace.h      | 6 ------
 3 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/arch/xtensa/kernel/ptrace.c b/arch/xtensa/kernel/ptrace.c
index 323c678a691f..b952e67cc0cc 100644
--- a/arch/xtensa/kernel/ptrace.c
+++ b/arch/xtensa/kernel/ptrace.c
@@ -225,12 +225,12 @@ const struct user_regset_view *task_user_regset_view(struct task_struct *task)
 
 void user_enable_single_step(struct task_struct *child)
 {
-	child->ptrace |= PT_SINGLESTEP;
+	set_tsk_thread_flag(child, TIF_SINGLESTEP);
 }
 
 void user_disable_single_step(struct task_struct *child)
 {
-	child->ptrace &= ~PT_SINGLESTEP;
+	clear_tsk_thread_flag(child, TIF_SINGLESTEP);
 }
 
 /*
diff --git a/arch/xtensa/kernel/signal.c b/arch/xtensa/kernel/signal.c
index 6f68649e86ba..ac50ec46c8f1 100644
--- a/arch/xtensa/kernel/signal.c
+++ b/arch/xtensa/kernel/signal.c
@@ -473,7 +473,7 @@ static void do_signal(struct pt_regs *regs)
 		/* Set up the stack frame */
 		ret = setup_frame(&ksig, sigmask_to_save(), regs);
 		signal_setup_done(ret, &ksig, 0);
-		if (current->ptrace & PT_SINGLESTEP)
+		if (test_thread_flag(TIF_SINGLESTEP))
 			task_pt_regs(current)->icountlevel = 1;
 
 		return;
@@ -499,7 +499,7 @@ static void do_signal(struct pt_regs *regs)
 	/* If there's no signal to deliver, we just restore the saved mask.  */
 	restore_saved_sigmask();
 
-	if (current->ptrace & PT_SINGLESTEP)
+	if (test_thread_flag(TIF_SINGLESTEP))
 		task_pt_regs(current)->icountlevel = 1;
 	return;
 }
diff --git a/include/linux/ptrace.h b/include/linux/ptrace.h
index 4c06f9f8ef3f..c952c5ba8fab 100644
--- a/include/linux/ptrace.h
+++ b/include/linux/ptrace.h
@@ -46,12 +46,6 @@ extern int ptrace_access_vm(struct task_struct *tsk, unsigned long addr,
 #define PT_EXITKILL		(PTRACE_O_EXITKILL << PT_OPT_FLAG_SHIFT)
 #define PT_SUSPEND_SECCOMP	(PTRACE_O_SUSPEND_SECCOMP << PT_OPT_FLAG_SHIFT)
 
-/* single stepping state bits (used on ARM and PA-RISC) */
-#define PT_SINGLESTEP_BIT	31
-#define PT_SINGLESTEP		(1<<PT_SINGLESTEP_BIT)
-#define PT_BLOCKSTEP_BIT	30
-#define PT_BLOCKSTEP		(1<<PT_BLOCKSTEP_BIT)
-
 extern long arch_ptrace(struct task_struct *child, long request,
 			unsigned long addr, unsigned long data);
 extern int ptrace_readdata(struct task_struct *tsk, unsigned long src, char __user *dst, int len);
-- 
2.35.3

