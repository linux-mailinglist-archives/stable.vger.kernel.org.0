Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D6E74BE473
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:59:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350641AbiBUJjC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:39:02 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351304AbiBUJg5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:36:57 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FBFD2DD65;
        Mon, 21 Feb 2022 01:15:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id CD261CE0E88;
        Mon, 21 Feb 2022 09:15:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD7D6C340E9;
        Mon, 21 Feb 2022 09:15:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645434933;
        bh=lVqdbNoCjzKukT0HxHifSUEyvjU+OER1Prmo9ZRZWl4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SFGIcOyiU7a0i8dAYgTxgXje3R3k8R1R5R8bACA+YC2ERqFEd9LKDNI/o6fb6EKUQ
         y1/T6mZ4GP8SwT/+HzKvMG1RDje2k3AqUyPfapfE7dJjdyADMBCRumFNSl9S5Hunvk
         dzF4ZXXzRnrcIfwx+7RWz82KiyYaI4SC5Wmo3w5Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH 5.15 181/196] ucounts: Enforce RLIMIT_NPROC not RLIMIT_NPROC+1
Date:   Mon, 21 Feb 2022 09:50:13 +0100
Message-Id: <20220221084937.001300077@linuxfoundation.org>
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

commit 8f2f9c4d82f24f172ae439e5035fc1e0e4c229dd upstream.

Michal Koutný <mkoutny@suse.com> wrote:

> It was reported that v5.14 behaves differently when enforcing
> RLIMIT_NPROC limit, namely, it allows one more task than previously.
> This is consequence of the commit 21d1c5e386bc ("Reimplement
> RLIMIT_NPROC on top of ucounts") that missed the sharpness of
> equality in the forking path.

This can be fixed either by fixing the test or by moving the increment
to be before the test.  Fix it my moving copy_creds which contains
the increment before is_ucounts_overlimit.

In the case of CLONE_NEWUSER the ucounts in the task_cred changes.
The function is_ucounts_overlimit needs to use the final version of
the ucounts for the new process.  Which means moving the
is_ucounts_overlimit test after copy_creds is necessary.

Both the test in fork and the test in set_user were semantically
changed when the code moved to ucounts.  The change of the test in
fork was bad because it was before the increment.  The test in
set_user was wrong and the change to ucounts fixed it.  So this
fix only restores the old behavior in one lcation not two.

Link: https://lkml.kernel.org/r/20220204181144.24462-1-mkoutny@suse.com
Link: https://lkml.kernel.org/r/20220216155832.680775-2-ebiederm@xmission.com
Cc: stable@vger.kernel.org
Reported-by: Michal Koutný <mkoutny@suse.com>
Reviewed-by: Michal Koutný <mkoutny@suse.com>
Fixes: 21d1c5e386bc ("Reimplement RLIMIT_NPROC on top of ucounts")
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/fork.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -2055,18 +2055,18 @@ static __latent_entropy struct task_stru
 #ifdef CONFIG_PROVE_LOCKING
 	DEBUG_LOCKS_WARN_ON(!p->softirqs_enabled);
 #endif
+	retval = copy_creds(p, clone_flags);
+	if (retval < 0)
+		goto bad_fork_free;
+
 	retval = -EAGAIN;
 	if (is_ucounts_overlimit(task_ucounts(p), UCOUNT_RLIMIT_NPROC, rlimit(RLIMIT_NPROC))) {
 		if (p->real_cred->user != INIT_USER &&
 		    !capable(CAP_SYS_RESOURCE) && !capable(CAP_SYS_ADMIN))
-			goto bad_fork_free;
+			goto bad_fork_cleanup_count;
 	}
 	current->flags &= ~PF_NPROC_EXCEEDED;
 
-	retval = copy_creds(p, clone_flags);
-	if (retval < 0)
-		goto bad_fork_free;
-
 	/*
 	 * If multiple threads are within copy_process(), then this check
 	 * triggers too late. This doesn't hurt, the check is only there


