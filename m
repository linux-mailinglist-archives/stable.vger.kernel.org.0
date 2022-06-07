Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75DFE5404C1
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 19:19:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345661AbiFGRTE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 13:19:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345638AbiFGRS5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 13:18:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECAAB104CAF;
        Tue,  7 Jun 2022 10:18:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3FB97B822B8;
        Tue,  7 Jun 2022 17:18:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D6A2C385A5;
        Tue,  7 Jun 2022 17:18:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654622332;
        bh=+wk2EABwxlb5J2SZ0+gM5lgp+xcxklX2wYWqEH/OWII=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QZFV0Besf34kdH0etBUi+MK97U9eEfuZ/KWg/CGmBOPz4NgbOAreA2v4BciI5jTdg
         m59LfQJlGrzmfOPLuS6auuzX/KA6MOCQZaWPXL9FOTYt49HxZhiVpHGtbtgDYG/SmT
         T6Z8yXQRC7HtZJMPBH4rI6BHYz5oRweIAUOi6Vhg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Kees Cook <keescook@chromium.org>,
        Oleg Nesterov <oleg@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH 5.10 021/452] ptrace: Reimplement PTRACE_KILL by always sending SIGKILL
Date:   Tue,  7 Jun 2022 18:57:58 +0200
Message-Id: <20220607164909.173940860@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164908.521895282@linuxfoundation.org>
References: <20220607164908.521895282@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

commit 6a2d90ba027adba528509ffa27097cffd3879257 upstream.

The current implementation of PTRACE_KILL is buggy and has been for
many years as it assumes it's target has stopped in ptrace_stop.  At a
quick skim it looks like this assumption has existed since ptrace
support was added in linux v1.0.

While PTRACE_KILL has been deprecated we can not remove it as
a quick search with google code search reveals many existing
programs calling it.

When the ptracee is not stopped at ptrace_stop some fields would be
set that are ignored except in ptrace_stop.  Making the userspace
visible behavior of PTRACE_KILL a noop in those case.

As the usual rules are not obeyed it is not clear what the
consequences are of calling PTRACE_KILL on a running process.
Presumably userspace does not do this as it achieves nothing.

Replace the implementation of PTRACE_KILL with a simple
send_sig_info(SIGKILL) followed by a return 0.  This changes the
observable user space behavior only in that PTRACE_KILL on a process
not stopped in ptrace_stop will also kill it.  As that has always
been the intent of the code this seems like a reasonable change.

Cc: stable@vger.kernel.org
Reported-by: Al Viro <viro@zeniv.linux.org.uk>
Suggested-by: Al Viro <viro@zeniv.linux.org.uk>
Tested-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Link: https://lkml.kernel.org/r/20220505182645.497868-7-ebiederm@xmission.com
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/step.c |    3 +--
 kernel/ptrace.c        |    5 ++---
 2 files changed, 3 insertions(+), 5 deletions(-)

--- a/arch/x86/kernel/step.c
+++ b/arch/x86/kernel/step.c
@@ -175,8 +175,7 @@ void set_task_blockstep(struct task_stru
 	 *
 	 * NOTE: this means that set/clear TIF_BLOCKSTEP is only safe if
 	 * task is current or it can't be running, otherwise we can race
-	 * with __switch_to_xtra(). We rely on ptrace_freeze_traced() but
-	 * PTRACE_KILL is not safe.
+	 * with __switch_to_xtra(). We rely on ptrace_freeze_traced().
 	 */
 	local_irq_disable();
 	debugctl = get_debugctlmsr();
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -1219,9 +1219,8 @@ int ptrace_request(struct task_struct *c
 		return ptrace_resume(child, request, data);
 
 	case PTRACE_KILL:
-		if (child->exit_state)	/* already dead */
-			return 0;
-		return ptrace_resume(child, request, SIGKILL);
+		send_sig_info(SIGKILL, SEND_SIG_NOINFO, child);
+		return 0;
 
 #ifdef CONFIG_HAVE_ARCH_TRACEHOOK
 	case PTRACE_GETREGSET:


