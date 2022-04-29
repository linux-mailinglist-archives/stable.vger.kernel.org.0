Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC8DD51575E
	for <lists+stable@lfdr.de>; Fri, 29 Apr 2022 23:50:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239618AbiD2Vwl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Apr 2022 17:52:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239590AbiD2Vwd (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Apr 2022 17:52:33 -0400
Received: from out01.mta.xmission.com (out01.mta.xmission.com [166.70.13.231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C817DB4B6;
        Fri, 29 Apr 2022 14:49:14 -0700 (PDT)
Received: from in02.mta.xmission.com ([166.70.13.52]:49872)
        by out01.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1nkYUD-007OE5-Gn; Fri, 29 Apr 2022 15:49:13 -0600
Received: from ip68-227-174-4.om.om.cox.net ([68.227.174.4]:36464 helo=localhost.localdomain)
        by in02.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1nkYUC-007RIp-Gl; Fri, 29 Apr 2022 15:49:13 -0600
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
Date:   Fri, 29 Apr 2022 16:48:31 -0500
Message-Id: <20220429214837.386518-6-ebiederm@xmission.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <87k0b7v9yk.fsf_-_@email.froward.int.ebiederm.org>
References: <87k0b7v9yk.fsf_-_@email.froward.int.ebiederm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-XM-SPF: eid=1nkYUC-007RIp-Gl;;;mid=<20220429214837.386518-6-ebiederm@xmission.com>;;;hst=in02.mta.xmission.com;;;ip=68.227.174.4;;;frm=ebiederm@xmission.com;;;spf=softfail
X-XM-AID: U2FsdGVkX1+vbrOvInw4J3zemlYv0MOslvPzk7U8i+A=
X-SA-Exim-Connect-IP: 68.227.174.4
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ***;linux-kernel@vger.kernel.org
X-Spam-Relay-Country: 
X-Spam-Timing: total 359 ms - load_scoreonly_sql: 0.05 (0.0%),
        signal_user_changed: 11 (3.0%), b_tie_ro: 9 (2.6%), parse: 0.98 (0.3%),
         extract_message_metadata: 15 (4.2%), get_uri_detail_list: 1.03 (0.3%),
         tests_pri_-1000: 20 (5.7%), tests_pri_-950: 1.34 (0.4%),
        tests_pri_-900: 1.16 (0.3%), tests_pri_-90: 90 (25.1%), check_bayes:
        88 (24.4%), b_tokenize: 7 (2.0%), b_tok_get_all: 7 (1.9%),
        b_comp_prob: 2.3 (0.6%), b_tok_touch_all: 68 (18.9%), b_finish: 1.01
        (0.3%), tests_pri_0: 207 (57.6%), check_dkim_signature: 0.68 (0.2%),
        check_dkim_adsp: 3.4 (1.0%), poll_dns_idle: 1.11 (0.3%), tests_pri_10:
        2.3 (0.6%), tests_pri_500: 7 (2.0%), rewrite_mail: 0.00 (0.0%)
Subject: [PATCH v2 06/12] ptrace: Reimplement PTRACE_KILL by always sending SIGKILL
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Call send_sig_info in PTRACE_KILL instead of ptrace_resume.  Calling
ptrace_resume is not safe to call if the task has not been stopped
with ptrace_freeze_traced.

Cc: stable@vger.kernel.org
Reported-by: Al Viro <viro@zeniv.linux.org.uk>
Suggested-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 kernel/ptrace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index ccc4b465775b..43da5764b6f3 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -1238,7 +1238,7 @@ int ptrace_request(struct task_struct *child, long request,
 	case PTRACE_KILL:
 		if (child->exit_state)	/* already dead */
 			return 0;
-		return ptrace_resume(child, request, SIGKILL);
+		return send_sig_info(SIGKILL, SEND_SIG_NOINFO, child);
 
 #ifdef CONFIG_HAVE_ARCH_TRACEHOOK
 	case PTRACE_GETREGSET:
-- 
2.35.3

