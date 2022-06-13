Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A04815498D9
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:37:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346698AbiFMKzR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 06:55:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349243AbiFMKyQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 06:54:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C3C22F396;
        Mon, 13 Jun 2022 03:27:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 49D1760EF5;
        Mon, 13 Jun 2022 10:27:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59E66C34114;
        Mon, 13 Jun 2022 10:27:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655116077;
        bh=gyhKNvxoiETnk+TrSOc9Q+QUOEp1CDY03KAvzlYOA1A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N9SwkwN7NRyz4K/8PWGFyVBKJykf5UIxLxBCU0SP4uTT7QOujNjxBhPsj9AbqafqB
         4+ZOUPHwVaZYTLOJLPhF9bu9bVAttrZ8SXlkCGu0cVxA0EwSsmWAwT8O5tJ7BZS+VF
         0bBjB+W9wnE0vYZB7hIk3QlyKhdUx+KDzqthKagI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Max Filippov <jcmvbkbc@gmail.com>,
        Kees Cook <keescook@chromium.org>,
        Oleg Nesterov <oleg@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH 5.4 008/411] ptrace/xtensa: Replace PT_SINGLESTEP with TIF_SINGLESTEP
Date:   Mon, 13 Jun 2022 12:04:41 +0200
Message-Id: <20220613094928.745114205@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094928.482772422@linuxfoundation.org>
References: <20220613094928.482772422@linuxfoundation.org>
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

commit 4a3d2717d140401df7501a95e454180831a0c5af upstream.

xtensa is the last user of the PT_SINGLESTEP flag.  Changing tsk->ptrace in
user_enable_single_step and user_disable_single_step without locking could
potentiallly cause problems.

So use a thread info flag instead of a flag in tsk->ptrace.  Use TIF_SINGLESTEP
that xtensa already had defined but unused.

Remove the definitions of PT_SINGLESTEP and PT_BLOCKSTEP as they have no more users.

Cc: stable@vger.kernel.org
Acked-by: Max Filippov <jcmvbkbc@gmail.com>
Tested-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Link: https://lkml.kernel.org/r/20220505182645.497868-4-ebiederm@xmission.com
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/xtensa/kernel/ptrace.c |    4 ++--
 arch/xtensa/kernel/signal.c |    4 ++--
 include/linux/ptrace.h      |    6 ------
 3 files changed, 4 insertions(+), 10 deletions(-)

--- a/arch/xtensa/kernel/ptrace.c
+++ b/arch/xtensa/kernel/ptrace.c
@@ -225,12 +225,12 @@ const struct user_regset_view *task_user
 
 void user_enable_single_step(struct task_struct *child)
 {
-	child->ptrace |= PT_SINGLESTEP;
+	set_tsk_thread_flag(child, TIF_SINGLESTEP);
 }
 
 void user_disable_single_step(struct task_struct *child)
 {
-	child->ptrace &= ~PT_SINGLESTEP;
+	clear_tsk_thread_flag(child, TIF_SINGLESTEP);
 }
 
 /*
--- a/arch/xtensa/kernel/signal.c
+++ b/arch/xtensa/kernel/signal.c
@@ -465,7 +465,7 @@ static void do_signal(struct pt_regs *re
 		/* Set up the stack frame */
 		ret = setup_frame(&ksig, sigmask_to_save(), regs);
 		signal_setup_done(ret, &ksig, 0);
-		if (current->ptrace & PT_SINGLESTEP)
+		if (test_thread_flag(TIF_SINGLESTEP))
 			task_pt_regs(current)->icountlevel = 1;
 
 		return;
@@ -491,7 +491,7 @@ static void do_signal(struct pt_regs *re
 	/* If there's no signal to deliver, we just restore the saved mask.  */
 	restore_saved_sigmask();
 
-	if (current->ptrace & PT_SINGLESTEP)
+	if (test_thread_flag(TIF_SINGLESTEP))
 		task_pt_regs(current)->icountlevel = 1;
 	return;
 }
--- a/include/linux/ptrace.h
+++ b/include/linux/ptrace.h
@@ -46,12 +46,6 @@ extern int ptrace_access_vm(struct task_
 #define PT_EXITKILL		(PTRACE_O_EXITKILL << PT_OPT_FLAG_SHIFT)
 #define PT_SUSPEND_SECCOMP	(PTRACE_O_SUSPEND_SECCOMP << PT_OPT_FLAG_SHIFT)
 
-/* single stepping state bits (used on ARM and PA-RISC) */
-#define PT_SINGLESTEP_BIT	31
-#define PT_SINGLESTEP		(1<<PT_SINGLESTEP_BIT)
-#define PT_BLOCKSTEP_BIT	30
-#define PT_BLOCKSTEP		(1<<PT_BLOCKSTEP_BIT)
-
 extern long arch_ptrace(struct task_struct *child, long request,
 			unsigned long addr, unsigned long data);
 extern int ptrace_readdata(struct task_struct *tsk, unsigned long src, char __user *dst, int len);


