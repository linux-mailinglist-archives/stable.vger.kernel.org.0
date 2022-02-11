Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C8D14B1C08
	for <lists+stable@lfdr.de>; Fri, 11 Feb 2022 03:14:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242403AbiBKCOP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Feb 2022 21:14:15 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347228AbiBKCON (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Feb 2022 21:14:13 -0500
Received: from out01.mta.xmission.com (out01.mta.xmission.com [166.70.13.231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 228605FCB;
        Thu, 10 Feb 2022 18:14:11 -0800 (PST)
Received: from in01.mta.xmission.com ([166.70.13.51]:57032)
        by out01.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1nILRq-000fRi-8G; Thu, 10 Feb 2022 19:14:10 -0700
Received: from ip68-227-174-4.om.om.cox.net ([68.227.174.4]:52650 helo=localhost.localdomain)
        by in01.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1nILRn-00FMXV-Vx; Thu, 10 Feb 2022 19:14:09 -0700
From:   "Eric W. Biederman" <ebiederm@xmission.com>
To:     linux-kernel@vger.kernel.org
Cc:     Alexey Gladkov <legion@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Shuah Khan <shuah@kernel.org>,
        Christian Brauner <brauner@kernel.org>,
        Solar Designer <solar@openwall.com>,
        Ran Xiaokai <ran.xiaokai@zte.com.cn>,
        containers@lists.linux-foundation.org,
        =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>, stable@vger.kernel.org
Date:   Thu, 10 Feb 2022 20:13:20 -0600
Message-Id: <20220211021324.4116773-4-ebiederm@xmission.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <87o83e2mbu.fsf@email.froward.int.ebiederm.org>
References: <87o83e2mbu.fsf@email.froward.int.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-XM-SPF: eid=1nILRn-00FMXV-Vx;;;mid=<20220211021324.4116773-4-ebiederm@xmission.com>;;;hst=in01.mta.xmission.com;;;ip=68.227.174.4;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+47gUkHsJ76O+AtzLsxplk9NA8yO0S5tw=
X-SA-Exim-Connect-IP: 68.227.174.4
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ***;linux-kernel@vger.kernel.org
X-Spam-Relay-Country: 
X-Spam-Timing: total 1614 ms - load_scoreonly_sql: 0.10 (0.0%),
        signal_user_changed: 13 (0.8%), b_tie_ro: 11 (0.7%), parse: 1.57
        (0.1%), extract_message_metadata: 23 (1.4%), get_uri_detail_list: 4.5
        (0.3%), tests_pri_-1000: 35 (2.2%), tests_pri_-950: 1.45 (0.1%),
        tests_pri_-900: 1.16 (0.1%), tests_pri_-90: 106 (6.6%), check_bayes:
        102 (6.3%), b_tokenize: 16 (1.0%), b_tok_get_all: 11 (0.7%),
        b_comp_prob: 3.8 (0.2%), b_tok_touch_all: 60 (3.7%), b_finish: 2.2
        (0.1%), tests_pri_0: 1402 (86.8%), check_dkim_signature: 1.09 (0.1%),
        check_dkim_adsp: 4.2 (0.3%), poll_dns_idle: 0.83 (0.1%), tests_pri_10:
        4.5 (0.3%), tests_pri_500: 22 (1.4%), rewrite_mail: 0.00 (0.0%)
Subject: [PATCH 4/8] ucounts: Only except the root user in init_user_ns from RLIMIT_NPROC
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In [1] Michal Koutný <mkoutny@suse.com> reported that it does not make
sense to unconditionally exempt the INIT_USER during fork and exec
from RLIMIT_NPROC and then to impose a limit on that same user with
is_ucounts_overlimit.  So I looked into why the exeception was added.

commit 909cc4ae86f3 ("[PATCH] Fix two bugs with process limits (RLIMIT_NPROC)") says:
>  If a setuid process swaps it's real and effective uids and then
>  forks, the fork fails if the new realuid has more processes than
>  the original process was limited to.  This is particularly a
>  problem if a user with a process limit (e.g. 256) runs a
>  setuid-root program which does setuid() + fork() (e.g. lprng) while
>  root already has more than 256 process (which is quite possible).
>
>  The root problem here is that a limit which should be a per-user
>  limit is being implemented as a per-process limit with per-process
>  (e.g. CAP_SYS_RESOURCE) controls.  Being a per-user limit, it
>  should be that the root-user can over-ride it, not just some
>  process with CAP_SYS_RESOURCE.
>
>  This patch adds a test to ignore process limits if the real user is root.

With the moving of the limits from per-user to per-user-per-user_ns it
is clear that testing a user_struct is no longer the proper test and
the test should be a test against the ucounts struct to match the
rest of the logic change that was made.

With RLIMIT_NPROC not being enforced for the global root user anywhere
else should it be enforced in is_ucounts_overlimit for a user
namespace created by the global root user?

Since this is limited to just the global root user, and RLIMIT_NPROC
is already ignored for that user I am going to vote no.

This change does imply that it becomes possible to limit all users in
a user namespace but to not enforce the rlimits on the root user or
anyone with CAP_SYS_ADMIN and CAP_SYS_RESOURCE in the user namespace.
It is not clear to me why any of those exceptions exist so I figure
we should until this is actually a problem for someone before
we relax the permission checks here.

Cc: stable@vger.kernel.org
Reported-by: Michal Koutný <mkoutny@suse.com>
[1] https://lkml.kernel.org/r/20220207121800.5079-5-mkoutny@suse.com
History-Tree: https://git.kernel.org/pub/scm/linux/kernel/git/tglx/history.git
Fixes: 21d1c5e386bc ("Reimplement RLIMIT_NPROC on top of ucounts")
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 fs/exec.c               | 2 +-
 kernel/fork.c           | 2 +-
 kernel/user_namespace.c | 2 ++
 3 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 1e7f757cbc2c..01c8c7bae9b4 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1881,7 +1881,7 @@ static int do_execveat_common(int fd, struct filename *filename,
 	 */
 	if ((current->flags & PF_NPROC_CHECK) &&
 	    is_ucounts_overlimit(current_ucounts(), UCOUNT_RLIMIT_NPROC, rlimit(RLIMIT_NPROC)) &&
-	    (current_user() != INIT_USER) &&
+	    (current_ucounts() != &init_ucounts) &&
 	    !capable(CAP_SYS_RESOURCE) && !capable(CAP_SYS_ADMIN)) {
 		retval = -EAGAIN;
 		goto out_ret;
diff --git a/kernel/fork.c b/kernel/fork.c
index 2b6a28a86325..6f62d37f3650 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -2027,7 +2027,7 @@ static __latent_entropy struct task_struct *copy_process(
 
 	retval = -EAGAIN;
 	if (is_ucounts_overlimit(task_ucounts(p), UCOUNT_RLIMIT_NPROC, rlimit(RLIMIT_NPROC))) {
-		if (p->real_cred->user != INIT_USER &&
+		if ((task_ucounts(p) != &init_ucounts) &&
 		    !capable(CAP_SYS_RESOURCE) && !capable(CAP_SYS_ADMIN))
 			goto bad_fork_cleanup_count;
 	}
diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
index 6b2e3ca7ee99..f0c04073403d 100644
--- a/kernel/user_namespace.c
+++ b/kernel/user_namespace.c
@@ -123,6 +123,8 @@ int create_user_ns(struct cred *new)
 		ns->ucount_max[i] = INT_MAX;
 	}
 	set_rlimit_ucount_max(ns, UCOUNT_RLIMIT_NPROC, rlimit(RLIMIT_NPROC));
+	if (new->ucounts == &init_ucounts)
+		set_rlimit_ucount_max(ns, UCOUNT_RLIMIT_NPROC, RLIMIT_INFINITY);
 	set_rlimit_ucount_max(ns, UCOUNT_RLIMIT_MSGQUEUE, rlimit(RLIMIT_MSGQUEUE));
 	set_rlimit_ucount_max(ns, UCOUNT_RLIMIT_SIGPENDING, rlimit(RLIMIT_SIGPENDING));
 	set_rlimit_ucount_max(ns, UCOUNT_RLIMIT_MEMLOCK, rlimit(RLIMIT_MEMLOCK));
-- 
2.29.2

