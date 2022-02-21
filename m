Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8133A4BE6E8
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 19:02:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350649AbiBUJjJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:39:09 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351289AbiBUJg5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:36:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF36F2DABB;
        Mon, 21 Feb 2022 01:15:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 19F7C60B1E;
        Mon, 21 Feb 2022 09:15:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3698C340E9;
        Mon, 21 Feb 2022 09:15:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645434930;
        bh=ndV0d7LE6q+zLbv7DPboGaYMp5aB/82uoAfM0/0l9TQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jAevjQv6EDPoO12WI3GOJzVpprw42czspLAhaKLQfhG8T1SHvYNhDms+f6lUFi1ZH
         FbMJqhj1oaLqV/Y/rsPRtpGIfYtSmyY3kPkhrEq6vgiU8CaxUwO2ByeZmBKZR6oivo
         Hty6+8CUCcKNiUH0NI7wLjbanFFhG7CQheuP9V7c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH 5.15 180/196] ucounts: Base set_cred_ucounts changes on the real user
Date:   Mon, 21 Feb 2022 09:50:12 +0100
Message-Id: <20220221084936.968722973@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084930.872957717@linuxfoundation.org>
References: <20220221084930.872957717@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

commit a55d07294f1e9b576093bdfa95422f8119941e83 upstream.

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
Link: https://lkml.kernel.org/r/20220216155832.680775-3-ebiederm@xmission.com
Reported-by: Michal Koutný <mkoutny@suse.com>
Reviewed-by: Michal Koutný <mkoutny@suse.com>
Fixes: 21d1c5e386bc ("Reimplement RLIMIT_NPROC on top of ucounts")
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/cred.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

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


