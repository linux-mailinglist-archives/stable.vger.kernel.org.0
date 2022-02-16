Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1E714B8D16
	for <lists+stable@lfdr.de>; Wed, 16 Feb 2022 16:59:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235837AbiBPP7a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Feb 2022 10:59:30 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232290AbiBPP72 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Feb 2022 10:59:28 -0500
Received: from out02.mta.xmission.com (out02.mta.xmission.com [166.70.13.232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D88862A7977;
        Wed, 16 Feb 2022 07:59:12 -0800 (PST)
Received: from in01.mta.xmission.com ([166.70.13.51]:51956)
        by out02.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1nKMhz-001oRf-8g; Wed, 16 Feb 2022 08:59:11 -0700
Received: from ip68-227-174-4.om.om.cox.net ([68.227.174.4]:37452 helo=localhost.localdomain)
        by in01.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1nKMhy-002YPH-9D; Wed, 16 Feb 2022 08:59:10 -0700
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
        linux-api@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>, stable@vger.kernel.org
Date:   Wed, 16 Feb 2022 09:58:30 -0600
Message-Id: <20220216155832.680775-3-ebiederm@xmission.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <87ilteiz4a.fsf_-_@email.froward.int.ebiederm.org>
References: <87ilteiz4a.fsf_-_@email.froward.int.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-XM-SPF: eid=1nKMhy-002YPH-9D;;;mid=<20220216155832.680775-3-ebiederm@xmission.com>;;;hst=in01.mta.xmission.com;;;ip=68.227.174.4;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18QxC/y1NnTrInE0B67wHNJHnzhwk93cEs=
X-SA-Exim-Connect-IP: 68.227.174.4
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-DCC: XMission; sa08 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;linux-kernel@vger.kernel.org
X-Spam-Relay-Country: 
X-Spam-Timing: total 393 ms - load_scoreonly_sql: 0.04 (0.0%),
        signal_user_changed: 11 (2.8%), b_tie_ro: 9 (2.4%), parse: 0.89 (0.2%),
         extract_message_metadata: 13 (3.3%), get_uri_detail_list: 1.58 (0.4%),
         tests_pri_-1000: 25 (6.5%), tests_pri_-950: 1.38 (0.4%),
        tests_pri_-900: 1.16 (0.3%), tests_pri_-90: 85 (21.6%), check_bayes:
        83 (21.2%), b_tokenize: 7 (1.8%), b_tok_get_all: 10 (2.5%),
        b_comp_prob: 2.6 (0.7%), b_tok_touch_all: 58 (14.8%), b_finish: 1.26
        (0.3%), tests_pri_0: 242 (61.7%), check_dkim_signature: 0.54 (0.1%),
        check_dkim_adsp: 2.8 (0.7%), poll_dns_idle: 1.03 (0.3%), tests_pri_10:
        2.1 (0.5%), tests_pri_500: 8 (2.0%), rewrite_mail: 0.00 (0.0%)
Subject: [PATCH v2 3/5] ucounts: Base set_cred_ucounts changes on the real user
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

I looked at cred->ucount and it is only used for rlimit operations
that were previously stored in cred->user.  Making the fact
cred->ucount can refer to a different user from cred->user a bug,
affecting all uses of cred->ulimit not just RLIMIT_NPROC.

Fix set_cred_ucounts to always use the real uid not the effective uid.

Further simplify set_cred_ucounts by noticing that set_cred_ucounts
somehow retained a draft version of the check to see if alloc_ucounts
was needed that checks the new->user and new->user_ns against the
current_real_cred().  Remove that draft version of the check.

All that matters for setting the cred->ucounts are the user_ns and uid
fields in the cred.

Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20220207121800.5079-4-mkoutny@suse.com
Reported-by: Michal Koutný <mkoutny@suse.com>
Reviewed-by: Michal Koutný <mkoutny@suse.com>
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

