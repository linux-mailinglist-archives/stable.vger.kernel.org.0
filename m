Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8DEE4B1C06
	for <lists+stable@lfdr.de>; Fri, 11 Feb 2022 03:14:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347230AbiBKCON (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Feb 2022 21:14:13 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347204AbiBKCOI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Feb 2022 21:14:08 -0500
Received: from out01.mta.xmission.com (out01.mta.xmission.com [166.70.13.231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC3EB5FB4;
        Thu, 10 Feb 2022 18:14:07 -0800 (PST)
Received: from in01.mta.xmission.com ([166.70.13.51]:56980)
        by out01.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1nILRm-000fRD-NU; Thu, 10 Feb 2022 19:14:06 -0700
Received: from ip68-227-174-4.om.om.cox.net ([68.227.174.4]:52650 helo=localhost.localdomain)
        by in01.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1nILRj-00FMXV-UM; Thu, 10 Feb 2022 19:14:06 -0700
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
Date:   Thu, 10 Feb 2022 20:13:19 -0600
Message-Id: <20220211021324.4116773-3-ebiederm@xmission.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <87o83e2mbu.fsf@email.froward.int.ebiederm.org>
References: <87o83e2mbu.fsf@email.froward.int.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-XM-SPF: eid=1nILRj-00FMXV-UM;;;mid=<20220211021324.4116773-3-ebiederm@xmission.com>;;;hst=in01.mta.xmission.com;;;ip=68.227.174.4;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+t/nauytizkF2Z+L1yNTkR9kdtUK0tpC4=
X-SA-Exim-Connect-IP: 68.227.174.4
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Virus: No
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *****;linux-kernel@vger.kernel.org
X-Spam-Relay-Country: 
X-Spam-Timing: total 2140 ms - load_scoreonly_sql: 0.03 (0.0%),
        signal_user_changed: 4.0 (0.2%), b_tie_ro: 2.8 (0.1%), parse: 1.42
        (0.1%), extract_message_metadata: 19 (0.9%), get_uri_detail_list: 5
        (0.2%), tests_pri_-1000: 22 (1.0%), tests_pri_-950: 1.05 (0.0%),
        tests_pri_-900: 0.84 (0.0%), tests_pri_-90: 611 (28.5%), check_bayes:
        609 (28.5%), b_tokenize: 19 (0.9%), b_tok_get_all: 11 (0.5%),
        b_comp_prob: 3.3 (0.2%), b_tok_touch_all: 572 (26.7%), b_finish: 0.88
        (0.0%), tests_pri_0: 1468 (68.6%), check_dkim_signature: 0.46 (0.0%),
        check_dkim_adsp: 1.59 (0.1%), poll_dns_idle: 0.19 (0.0%),
        tests_pri_10: 1.87 (0.1%), tests_pri_500: 7 (0.3%), rewrite_mail: 0.00
        (0.0%)
Subject: [PATCH 3/8] ucounts: Fix and simplify RLIMIT_NPROC handling during setuid()+execve
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Michal Koutný <mkoutny@suse.com> wrote:
> The check is currently against the current->cred but since those are
> going to change and we want to check RLIMIT_NPROC condition after the
> switch, supply the capability check with the new cred.
> But since we're checking new_user being INIT_USER any new cred's
> capability-based allowance may be redundant when the check fails and the
> alternative solution would be revert of the commit 2863643fb8b9
> ("set_user: add capability check when rlimit(RLIMIT_NPROC) exceeds")

As of commit 2863643fb8b9 ("set_user: add capability check when
rlimit(RLIMIT_NPROC) exceeds") setting the flag to see if execve
should check RLIMIT_NPROC is buggy, as it tests the capabilites from
before the credential change and not aftwards.

As of commit 21d1c5e386bc ("Reimplement RLIMIT_NPROC on top of
ucounts") examining the rlimit is buggy as cred->ucounts has not yet
been properly set in the new credential.

Make the code correct and more robust moving the test to see if
execve() needs to test RLIMIT_NPROC into commit_creds, and defer all
of the rest of the logic into execve() itself.

As the flag only indicateds that RLIMIT_NPROC should be checked
in execve rename it from PF_NPROC_EXCEEDED to PF_NPROC_CHECK.

Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20220207121800.5079-2-mkoutny@suse.com
Link: https://lkml.kernel.org/r/20220207121800.5079-3-mkoutny@suse.com
Reported-by: Michal Koutný <mkoutny@suse.com>
Fixes: 2863643fb8b9 ("set_user: add capability check when rlimit(RLIMIT_NPROC) exceeds")
Fixes: 21d1c5e386bc ("Reimplement RLIMIT_NPROC on top of ucounts")
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 fs/exec.c             | 15 ++++++++-------
 include/linux/sched.h |  2 +-
 kernel/cred.c         | 13 +++++++++----
 kernel/fork.c         |  2 +-
 kernel/sys.c          | 14 --------------
 5 files changed, 19 insertions(+), 27 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 79f2c9483302..1e7f757cbc2c 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1875,20 +1875,21 @@ static int do_execveat_common(int fd, struct filename *filename,
 		return PTR_ERR(filename);
 
 	/*
-	 * We move the actual failure in case of RLIMIT_NPROC excess from
-	 * set*uid() to execve() because too many poorly written programs
-	 * don't check setuid() return code.  Here we additionally recheck
-	 * whether NPROC limit is still exceeded.
+	 * After calling set*uid() is RLIMT_NPROC exceeded?
+	 * This can not be checked in set*uid() because too many programs don't
+	 * check the setuid() return code.
 	 */
-	if ((current->flags & PF_NPROC_EXCEEDED) &&
-	    is_ucounts_overlimit(current_ucounts(), UCOUNT_RLIMIT_NPROC, rlimit(RLIMIT_NPROC))) {
+	if ((current->flags & PF_NPROC_CHECK) &&
+	    is_ucounts_overlimit(current_ucounts(), UCOUNT_RLIMIT_NPROC, rlimit(RLIMIT_NPROC)) &&
+	    (current_user() != INIT_USER) &&
+	    !capable(CAP_SYS_RESOURCE) && !capable(CAP_SYS_ADMIN)) {
 		retval = -EAGAIN;
 		goto out_ret;
 	}
 
 	/* We're below the limit (still or again), so we don't want to make
 	 * further execve() calls fail. */
-	current->flags &= ~PF_NPROC_EXCEEDED;
+	current->flags &= ~PF_NPROC_CHECK;
 
 	bprm = alloc_bprm(fd, filename);
 	if (IS_ERR(bprm)) {
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 75ba8aa60248..6605a262a6be 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1678,7 +1678,7 @@ extern struct pid *cad_pid;
 #define PF_DUMPCORE		0x00000200	/* Dumped core */
 #define PF_SIGNALED		0x00000400	/* Killed by a signal */
 #define PF_MEMALLOC		0x00000800	/* Allocating memory */
-#define PF_NPROC_EXCEEDED	0x00001000	/* set_user() noticed that RLIMIT_NPROC was exceeded */
+#define PF_NPROC_CHECK		0x00001000	/* Check in execve if RLIMIT_NPROC was exceeded */
 #define PF_USED_MATH		0x00002000	/* If unset the fpu must be initialized before use */
 #define PF_NOFREEZE		0x00008000	/* This thread should not be frozen */
 #define PF_FROZEN		0x00010000	/* Frozen for system suspend */
diff --git a/kernel/cred.c b/kernel/cred.c
index 933155c96922..229cff081167 100644
--- a/kernel/cred.c
+++ b/kernel/cred.c
@@ -490,13 +490,18 @@ int commit_creds(struct cred *new)
 	if (!gid_eq(new->fsgid, old->fsgid))
 		key_fsgid_changed(new);
 
-	/* do it
-	 * RLIMIT_NPROC limits on user->processes have already been checked
-	 * in set_user().
+	/*
+	 * Remember if the NPROC limit may be exceeded.  The set*uid() functions
+	 * can not fail if the NPROC limit is exceeded as too many programs
+	 * don't check the return code.  Instead enforce the NPROC limit for
+	 * programs doing set*uid()+execve by harmlessly defering the failure
+	 * to the execve() stage.
 	 */
 	alter_cred_subscribers(new, 2);
-	if (new->user != old->user || new->user_ns != old->user_ns)
+	if (new->user != old->user || new->user_ns != old->user_ns) {
 		inc_rlimit_ucounts(new->ucounts, UCOUNT_RLIMIT_NPROC, 1);
+		task->flags |= PF_NPROC_CHECK;
+	}
 	rcu_assign_pointer(task->real_cred, new);
 	rcu_assign_pointer(task->cred, new);
 	if (new->user != old->user || new->user_ns != old->user_ns)
diff --git a/kernel/fork.c b/kernel/fork.c
index 17d8a8c85e3b..2b6a28a86325 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -2031,7 +2031,7 @@ static __latent_entropy struct task_struct *copy_process(
 		    !capable(CAP_SYS_RESOURCE) && !capable(CAP_SYS_ADMIN))
 			goto bad_fork_cleanup_count;
 	}
-	current->flags &= ~PF_NPROC_EXCEEDED;
+	current->flags &= ~PF_NPROC_CHECK;
 
 	/*
 	 * If multiple threads are within copy_process(), then this check
diff --git a/kernel/sys.c b/kernel/sys.c
index ecc4cf019242..b1ed21d79f3b 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -472,20 +472,6 @@ static int set_user(struct cred *new)
 	if (!new_user)
 		return -EAGAIN;
 
-	/*
-	 * We don't fail in case of NPROC limit excess here because too many
-	 * poorly written programs don't check set*uid() return code, assuming
-	 * it never fails if called by root.  We may still enforce NPROC limit
-	 * for programs doing set*uid()+execve() by harmlessly deferring the
-	 * failure to the execve() stage.
-	 */
-	if (is_ucounts_overlimit(new->ucounts, UCOUNT_RLIMIT_NPROC, rlimit(RLIMIT_NPROC)) &&
-			new_user != INIT_USER &&
-			!capable(CAP_SYS_RESOURCE) && !capable(CAP_SYS_ADMIN))
-		current->flags |= PF_NPROC_EXCEEDED;
-	else
-		current->flags &= ~PF_NPROC_EXCEEDED;
-
 	free_uid(new->user);
 	new->user = new_user;
 	return 0;
-- 
2.29.2

