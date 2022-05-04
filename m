Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7915351B222
	for <lists+stable@lfdr.de>; Thu,  5 May 2022 00:42:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379021AbiEDWpH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 18:45:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377186AbiEDWpG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 18:45:06 -0400
Received: from out03.mta.xmission.com (out03.mta.xmission.com [166.70.13.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F05234B402;
        Wed,  4 May 2022 15:41:28 -0700 (PDT)
Received: from in02.mta.xmission.com ([166.70.13.52]:54180)
        by out03.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1nmNgV-00EDQ2-Px; Wed, 04 May 2022 16:41:27 -0600
Received: from ip68-227-174-4.om.om.cox.net ([68.227.174.4]:37004 helo=localhost.localdomain)
        by in02.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1nmNgT-00GI0k-N1; Wed, 04 May 2022 16:41:27 -0600
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
Date:   Wed,  4 May 2022 17:40:51 -0500
Message-Id: <20220504224058.476193-4-ebiederm@xmission.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <87k0b0apne.fsf_-_@email.froward.int.ebiederm.org>
References: <87k0b0apne.fsf_-_@email.froward.int.ebiederm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-XM-SPF: eid=1nmNgT-00GI0k-N1;;;mid=<20220504224058.476193-4-ebiederm@xmission.com>;;;hst=in02.mta.xmission.com;;;ip=68.227.174.4;;;frm=ebiederm@xmission.com;;;spf=softfail
X-XM-AID: U2FsdGVkX1+fWOQ9MaB429+o1HGyismIIFMdjPWEV4E=
X-SA-Exim-Connect-IP: 68.227.174.4
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Virus: No
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ***;linux-kernel@vger.kernel.org
X-Spam-Relay-Country: 
X-Spam-Timing: total 1456 ms - load_scoreonly_sql: 0.03 (0.0%),
        signal_user_changed: 3.9 (0.3%), b_tie_ro: 2.6 (0.2%), parse: 1.14
        (0.1%), extract_message_metadata: 12 (0.8%), get_uri_detail_list: 2.4
        (0.2%), tests_pri_-1000: 11 (0.7%), tests_pri_-950: 0.96 (0.1%),
        tests_pri_-900: 0.87 (0.1%), tests_pri_-90: 71 (4.8%), check_bayes: 69
        (4.7%), b_tokenize: 13 (0.9%), b_tok_get_all: 6 (0.4%), b_comp_prob:
        2.6 (0.2%), b_tok_touch_all: 45 (3.1%), b_finish: 0.54 (0.0%),
        tests_pri_0: 1342 (92.2%), check_dkim_signature: 0.69 (0.0%),
        check_dkim_adsp: 2.4 (0.2%), poll_dns_idle: 0.94 (0.1%), tests_pri_10:
        2.9 (0.2%), tests_pri_500: 8 (0.5%), rewrite_mail: 0.00 (0.0%)
Subject: [PATCH v3 04/11] ptrace/xtensa: Replace PT_SINGLESTEP with TIF_SINGLESTEP
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
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

