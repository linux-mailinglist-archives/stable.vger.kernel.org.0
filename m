Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6FBE4BD71B
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 08:43:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345750AbiBUG6v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 01:58:51 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238938AbiBUG6t (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 01:58:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFE2CE0F4
        for <stable@vger.kernel.org>; Sun, 20 Feb 2022 22:58:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 776BCB80E38
        for <stable@vger.kernel.org>; Mon, 21 Feb 2022 06:58:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9284CC340E9;
        Mon, 21 Feb 2022 06:58:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645426704;
        bh=YocEiF+YRlAG58Nf+ozke+jRCqFlhovmjO7ZpJijJEw=;
        h=Subject:To:Cc:From:Date:From;
        b=IdtFqxO3XJc1vtCjIbQUqhOfrIaEf6/ComE1Ivvk4Z7zinB8gfrZCvdnSu2YU6BCU
         cwKPoKXlcaOUrpJUqOqMpK2Nm0R53TDeL269SI+tZb8LixItUFLli5A8lGrtR2lQYC
         czwjQz1nip5fr3e3tMo3cJ8h3LoOgmoZGW7BgGA4=
Subject: FAILED: patch "[PATCH] ucounts: Base set_cred_ucounts changes on the real user" failed to apply to 5.15-stable tree
To:     ebiederm@xmission.com, mkoutny@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 21 Feb 2022 07:58:21 +0100
Message-ID: <164542670146140@kroah.com>
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


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From a55d07294f1e9b576093bdfa95422f8119941e83 Mon Sep 17 00:00:00 2001
From: "Eric W. Biederman" <ebiederm@xmission.com>
Date: Wed, 9 Feb 2022 16:22:20 -0600
Subject: [PATCH] ucounts: Base set_cred_ucounts changes on the real user
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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

