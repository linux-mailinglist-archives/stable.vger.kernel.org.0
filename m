Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6362351C7E3
	for <lists+stable@lfdr.de>; Thu,  5 May 2022 20:37:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384331AbiEESh5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 May 2022 14:37:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384368AbiEEShG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 May 2022 14:37:06 -0400
Received: from out03.mta.xmission.com (out03.mta.xmission.com [166.70.13.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 468285E764;
        Thu,  5 May 2022 11:27:34 -0700 (PDT)
Received: from in01.mta.xmission.com ([166.70.13.51]:59586)
        by out03.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1nmgCL-00GUvI-6a; Thu, 05 May 2022 12:27:33 -0600
Received: from ip68-227-174-4.om.om.cox.net ([68.227.174.4]:37118 helo=localhost.localdomain)
        by in01.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1nmgCK-002BtP-2F; Thu, 05 May 2022 12:27:32 -0600
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
        "Eric W. Biederman" <ebiederm@xmission.com>,
        stable@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
Date:   Thu,  5 May 2022 13:26:40 -0500
Message-Id: <20220505182645.497868-7-ebiederm@xmission.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <87a6bv6dl6.fsf_-_@email.froward.int.ebiederm.org>
References: <87a6bv6dl6.fsf_-_@email.froward.int.ebiederm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-XM-SPF: eid=1nmgCK-002BtP-2F;;;mid=<20220505182645.497868-7-ebiederm@xmission.com>;;;hst=in01.mta.xmission.com;;;ip=68.227.174.4;;;frm=ebiederm@xmission.com;;;spf=softfail
X-XM-AID: U2FsdGVkX19NRZcRcR23auMiCzqsQtGurcA8snLDuqU=
X-SA-Exim-Connect-IP: 68.227.174.4
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=38 
X-Spam-Combo: ***;linux-kernel@vger.kernel.org
X-Spam-Relay-Country: 
X-Spam-Timing: total 490 ms - load_scoreonly_sql: 0.07 (0.0%),
        signal_user_changed: 11 (2.2%), b_tie_ro: 10 (1.9%), parse: 1.08
        (0.2%), extract_message_metadata: 15 (3.1%), get_uri_detail_list: 1.85
        (0.4%), tests_pri_-1000: 20 (4.1%), tests_pri_-950: 1.21 (0.2%),
        tests_pri_-900: 1.01 (0.2%), tests_pri_-90: 120 (24.5%), check_bayes:
        118 (24.1%), b_tokenize: 9 (1.8%), b_tok_get_all: 9 (1.8%),
        b_comp_prob: 2.8 (0.6%), b_tok_touch_all: 93 (19.1%), b_finish: 0.89
        (0.2%), tests_pri_0: 310 (63.2%), check_dkim_signature: 0.74 (0.2%),
        check_dkim_adsp: 3.1 (0.6%), poll_dns_idle: 1.17 (0.2%), tests_pri_10:
        1.78 (0.4%), tests_pri_500: 6 (1.2%), rewrite_mail: 0.00 (0.0%)
Subject: [PATCH v4 07/12] ptrace: Reimplement PTRACE_KILL by always sending SIGKILL
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The current implementation of PTRACE_KILL is buggy and has been for
many years as it assumes it's target has stopped in ptrace_stop.  At a
quick skim it looks like this assumption has existed since ptrace
support was added in linux v1.0.

While PTRACE_KILL has been deprecated we can not remove it as
a quick search with google code search reveals many existing
programs calling it.

When the ptracee is not stopped at ptrace_stop some fields would be
set that are ignored except in ptrace_stop.  Making the userspace
visible behavior of PTRACE_KILL a noop in those case.

As the usual rules are not obeyed it is not clear what the
consequences are of calling PTRACE_KILL on a running process.
Presumably userspace does not do this as it achieves nothing.

Replace the implementation of PTRACE_KILL with a simple
send_sig_info(SIGKILL) followed by a return 0.  This changes the
observable user space behavior only in that PTRACE_KILL on a process
not stopped in ptrace_stop will also kill it.  As that has always
been the intent of the code this seems like a reasonable change.

Cc: stable@vger.kernel.org
Reported-by: Al Viro <viro@zeniv.linux.org.uk>
Suggested-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 arch/x86/kernel/step.c | 3 +--
 kernel/ptrace.c        | 5 ++---
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/step.c b/arch/x86/kernel/step.c
index 0f3c307b37b3..8e2b2552b5ee 100644
--- a/arch/x86/kernel/step.c
+++ b/arch/x86/kernel/step.c
@@ -180,8 +180,7 @@ void set_task_blockstep(struct task_struct *task, bool on)
 	 *
 	 * NOTE: this means that set/clear TIF_BLOCKSTEP is only safe if
 	 * task is current or it can't be running, otherwise we can race
-	 * with __switch_to_xtra(). We rely on ptrace_freeze_traced() but
-	 * PTRACE_KILL is not safe.
+	 * with __switch_to_xtra(). We rely on ptrace_freeze_traced().
 	 */
 	local_irq_disable();
 	debugctl = get_debugctlmsr();
diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index da30dcd477a0..7105821595bc 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -1236,9 +1236,8 @@ int ptrace_request(struct task_struct *child, long request,
 		return ptrace_resume(child, request, data);
 
 	case PTRACE_KILL:
-		if (child->exit_state)	/* already dead */
-			return 0;
-		return ptrace_resume(child, request, SIGKILL);
+		send_sig_info(SIGKILL, SEND_SIG_NOINFO, child);
+		return 0;
 
 #ifdef CONFIG_HAVE_ARCH_TRACEHOOK
 	case PTRACE_GETREGSET:
-- 
2.35.3

