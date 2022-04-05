Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAA694F3A94
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 17:02:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381573AbiDELqX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:46:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354912AbiDEKQe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:16:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F121D1FA63;
        Tue,  5 Apr 2022 03:03:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6F552B81C86;
        Tue,  5 Apr 2022 10:03:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8A29C385A1;
        Tue,  5 Apr 2022 10:03:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649153032;
        bh=0EpLQqBQHjcTpSODKHXy71hIZ4eq3bpxMs0J0sqKlmw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t5GWJeQSuuyO0vuwWaQmxXU5zfPI5RT/UDT9yQNo8yek1KtHyXMkRULKPHPORE2Kl
         NNrZyfuNDvHlkxnNwKuuoVhBZserp1Bf5q1Xd+D9eIlkz3n/H3aOXaURcb4jKLGTJ3
         Fh/+KibwiqYzHaXlwNr/xee373efAg7z3mbzma2Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Jann Horn <jannh@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH 5.10 039/599] ptrace: Check PTRACE_O_SUSPEND_SECCOMP permission on PTRACE_SEIZE
Date:   Tue,  5 Apr 2022 09:25:33 +0200
Message-Id: <20220405070259.989212056@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070258.802373272@linuxfoundation.org>
References: <20220405070258.802373272@linuxfoundation.org>
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

From: Jann Horn <jannh@google.com>

commit ee1fee900537b5d9560e9f937402de5ddc8412f3 upstream.

Setting PTRACE_O_SUSPEND_SECCOMP is supposed to be a highly privileged
operation because it allows the tracee to completely bypass all seccomp
filters on kernels with CONFIG_CHECKPOINT_RESTORE=y. It is only supposed to
be settable by a process with global CAP_SYS_ADMIN, and only if that
process is not subject to any seccomp filters at all.

However, while these permission checks were done on the PTRACE_SETOPTIONS
path, they were missing on the PTRACE_SEIZE path, which also sets
user-specified ptrace flags.

Move the permissions checks out into a helper function and let both
ptrace_attach() and ptrace_setoptions() call it.

Cc: stable@kernel.org
Fixes: 13c4a90119d2 ("seccomp: add ptrace options for suspend/resume")
Signed-off-by: Jann Horn <jannh@google.com>
Link: https://lkml.kernel.org/r/20220319010838.1386861-1-jannh@google.com
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/ptrace.c |   47 ++++++++++++++++++++++++++++++++---------------
 1 file changed, 32 insertions(+), 15 deletions(-)

--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -370,6 +370,26 @@ bool ptrace_may_access(struct task_struc
 	return !err;
 }
 
+static int check_ptrace_options(unsigned long data)
+{
+	if (data & ~(unsigned long)PTRACE_O_MASK)
+		return -EINVAL;
+
+	if (unlikely(data & PTRACE_O_SUSPEND_SECCOMP)) {
+		if (!IS_ENABLED(CONFIG_CHECKPOINT_RESTORE) ||
+		    !IS_ENABLED(CONFIG_SECCOMP))
+			return -EINVAL;
+
+		if (!capable(CAP_SYS_ADMIN))
+			return -EPERM;
+
+		if (seccomp_mode(&current->seccomp) != SECCOMP_MODE_DISABLED ||
+		    current->ptrace & PT_SUSPEND_SECCOMP)
+			return -EPERM;
+	}
+	return 0;
+}
+
 static int ptrace_attach(struct task_struct *task, long request,
 			 unsigned long addr,
 			 unsigned long flags)
@@ -381,8 +401,16 @@ static int ptrace_attach(struct task_str
 	if (seize) {
 		if (addr != 0)
 			goto out;
+		/*
+		 * This duplicates the check in check_ptrace_options() because
+		 * ptrace_attach() and ptrace_setoptions() have historically
+		 * used different error codes for unknown ptrace options.
+		 */
 		if (flags & ~(unsigned long)PTRACE_O_MASK)
 			goto out;
+		retval = check_ptrace_options(flags);
+		if (retval)
+			return retval;
 		flags = PT_PTRACED | PT_SEIZED | (flags << PT_OPT_FLAG_SHIFT);
 	} else {
 		flags = PT_PTRACED;
@@ -655,22 +683,11 @@ int ptrace_writedata(struct task_struct
 static int ptrace_setoptions(struct task_struct *child, unsigned long data)
 {
 	unsigned flags;
+	int ret;
 
-	if (data & ~(unsigned long)PTRACE_O_MASK)
-		return -EINVAL;
-
-	if (unlikely(data & PTRACE_O_SUSPEND_SECCOMP)) {
-		if (!IS_ENABLED(CONFIG_CHECKPOINT_RESTORE) ||
-		    !IS_ENABLED(CONFIG_SECCOMP))
-			return -EINVAL;
-
-		if (!capable(CAP_SYS_ADMIN))
-			return -EPERM;
-
-		if (seccomp_mode(&current->seccomp) != SECCOMP_MODE_DISABLED ||
-		    current->ptrace & PT_SUSPEND_SECCOMP)
-			return -EPERM;
-	}
+	ret = check_ptrace_options(data);
+	if (ret)
+		return ret;
 
 	/* Avoid intermediate state when all opts are cleared */
 	flags = child->ptrace;


