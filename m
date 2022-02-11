Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E3B04B1C02
	for <lists+stable@lfdr.de>; Fri, 11 Feb 2022 03:14:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347205AbiBKCOH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Feb 2022 21:14:07 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347204AbiBKCOD (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Feb 2022 21:14:03 -0500
Received: from out01.mta.xmission.com (out01.mta.xmission.com [166.70.13.231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 862B55FB4;
        Thu, 10 Feb 2022 18:14:03 -0800 (PST)
Received: from in01.mta.xmission.com ([166.70.13.51]:56868)
        by out01.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1nILRi-000fQN-LA; Thu, 10 Feb 2022 19:14:02 -0700
Received: from ip68-227-174-4.om.om.cox.net ([68.227.174.4]:52650 helo=localhost.localdomain)
        by in01.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1nILRg-00FMXV-2b; Thu, 10 Feb 2022 19:14:01 -0700
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
Date:   Thu, 10 Feb 2022 20:13:18 -0600
Message-Id: <20220211021324.4116773-2-ebiederm@xmission.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <87o83e2mbu.fsf@email.froward.int.ebiederm.org>
References: <87o83e2mbu.fsf@email.froward.int.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-XM-SPF: eid=1nILRg-00FMXV-2b;;;mid=<20220211021324.4116773-2-ebiederm@xmission.com>;;;hst=in01.mta.xmission.com;;;ip=68.227.174.4;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX180vY7xLxiQ5Z1bAjs0XvdVF8ggxZUA/u4=
X-SA-Exim-Connect-IP: 68.227.174.4
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;linux-kernel@vger.kernel.org
X-Spam-Relay-Country: 
X-Spam-Timing: total 1460 ms - load_scoreonly_sql: 0.04 (0.0%),
        signal_user_changed: 12 (0.8%), b_tie_ro: 11 (0.7%), parse: 1.39
        (0.1%), extract_message_metadata: 17 (1.2%), get_uri_detail_list: 2.6
        (0.2%), tests_pri_-1000: 24 (1.6%), tests_pri_-950: 1.26 (0.1%),
        tests_pri_-900: 1.04 (0.1%), tests_pri_-90: 93 (6.4%), check_bayes: 88
        (6.0%), b_tokenize: 8 (0.6%), b_tok_get_all: 9 (0.6%), b_comp_prob:
        2.8 (0.2%), b_tok_touch_all: 64 (4.4%), b_finish: 0.99 (0.1%),
        tests_pri_0: 1298 (88.9%), check_dkim_signature: 0.69 (0.0%),
        check_dkim_adsp: 2.9 (0.2%), poll_dns_idle: 0.37 (0.0%), tests_pri_10:
        2.2 (0.2%), tests_pri_500: 7 (0.5%), rewrite_mail: 0.00 (0.0%)
Subject: [PATCH 2/8] ucounts: Fix set_cred_ucounts
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Michal Koutný <mkoutny@suse.com> wrote:
> Tasks are associated to multiple users at once. Historically and as per
> setrlimit(2) RLIMIT_NPROC is enforce based on real user ID.
>
> The commit 21d1c5e386bc ("Reimplement RLIMIT_NPROC on top of ucounts")
> made the accounting structure "indexed" by euid and hence potentially
> account tasks differently.
>
> The effective user ID may be different e.g. for setuid programs but
> those are exec'd into already existing task (i.e. below limit), so
> different accounting is moot.
>
> Some special setresuid(2) users may notice the difference, justifying
> this fix.

I looked at the cred->ucount is only used for rlimit operations that
were previously stored in cred->user.  Making the fact cred->ucount
can refer to a different user from cred->user a bug working will all
rlimits not just RLIMIT_NPROC.

So fix set_cred_ucounts to always use the real uid not the effective uid.

Further simplify set_cred_ucounts by noticing that set_cred_ucounts
somehow retained a draft version of the check to see if alloc_ucounts
was needed that checks the new->user and new->user_ns against the
current_real_cred(), when nothing matters for setting the ucounts
field of a struct cred except the other fields in that same struct
cred.

So delete the confusing and wrong check against the
current_real_cred(), and all of it's intermediate variables.

Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20220207121800.5079-4-mkoutny@suse.com
Reported-by: Michal Koutný <mkoutny@suse.com>
Fixes: 21d1c5e386bc ("Reimplement RLIMIT_NPROC on top of ucounts")
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 kernel/cred.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/kernel/cred.c b/kernel/cred.c
index 473d17c431f3..933155c96922 100644
--- a/kernel/cred.c
+++ b/kernel/cred.c
@@ -665,21 +665,16 @@ EXPORT_SYMBOL(cred_fscmp);
 
 int set_cred_ucounts(struct cred *new)
 {
-	struct task_struct *task = current;
-	const struct cred *old = task->real_cred;
 	struct ucounts *new_ucounts, *old_ucounts = new->ucounts;
 
-	if (new->user == old->user && new->user_ns == old->user_ns)
-		return 0;
-
 	/*
 	 * This optimization is needed because alloc_ucounts() uses locks
 	 * for table lookups.
 	 */
-	if (old_ucounts->ns == new->user_ns && uid_eq(old_ucounts->uid, new->euid))
+	if (old_ucounts->ns == new->user_ns && uid_eq(old_ucounts->uid, new->uid))
 		return 0;
 
-	if (!(new_ucounts = alloc_ucounts(new->user_ns, new->euid)))
+	if (!(new_ucounts = alloc_ucounts(new->user_ns, new->uid)))
 		return -EAGAIN;
 
 	new->ucounts = new_ucounts;
-- 
2.29.2

