Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE715500ED0
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 15:19:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244049AbiDNNUo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 09:20:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243905AbiDNNTc (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:19:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 551BE931A7;
        Thu, 14 Apr 2022 06:16:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DF3DAB8296A;
        Thu, 14 Apr 2022 13:16:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 534F8C385A5;
        Thu, 14 Apr 2022 13:16:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649942202;
        bh=Fn0N6rbu1aYIk80aqUu0WAhP8E6CbSv/1xTslSUVGuc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o97/F3VOpZC9x+JbKq+hP2YgguaDVHSpBBm5a0FKBCwb6nD/JfVfjSEyVdhW42GZ3
         aJyvvKFeomBFLuTm4GCIEgEtg3AJY4u//XQEVinLxJ5Bw2pxPNyQoAjtbcawcrg5XQ
         r50qSHCUis6G+n8+sV+NwC0J67h4s/A9paAD/B/g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Jann Horn <jannh@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH 4.19 024/338] ptrace: Check PTRACE_O_SUSPEND_SECCOMP permission on PTRACE_SEIZE
Date:   Thu, 14 Apr 2022 15:08:47 +0200
Message-Id: <20220414110839.580612502@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110838.883074566@linuxfoundation.org>
References: <20220414110838.883074566@linuxfoundation.org>
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
@@ -364,6 +364,26 @@ bool ptrace_may_access(struct task_struc
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
@@ -375,8 +395,16 @@ static int ptrace_attach(struct task_str
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
@@ -649,22 +677,11 @@ int ptrace_writedata(struct task_struct
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


