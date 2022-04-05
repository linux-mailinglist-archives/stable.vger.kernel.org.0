Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4628D4F3EEE
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 22:55:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383367AbiDEMZl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 08:25:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229985AbiDEKxR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:53:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80F44AA014;
        Tue,  5 Apr 2022 03:28:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F1A39B81C9A;
        Tue,  5 Apr 2022 10:28:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57EA5C385A1;
        Tue,  5 Apr 2022 10:28:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649154493;
        bh=f6cz/MNAsBqwTYBuSFyaQUy+qfrWVrxMZMvcDWc1FAU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nNGfA3+siTuhFxQBUPUK4FVbRxUDC1LI6V1HjbtAAhRv2wit30Y6rxeQjX85VFYiD
         YaxJlr3BzliWEvY/A29B/P1ojg/w72NNTmQn3NBIE6mXpR+9Xcy9tZ/rgbib9dFb45
         zt8f8eB2To0BexL+BbwHFqp+Uzj81Q5AD1qU/X5k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jann Horn <jannh@google.com>,
        Kees Cook <keescook@chromium.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH 5.10 597/599] coredump/elf: Pass coredump_params into fill_note_info
Date:   Tue,  5 Apr 2022 09:34:51 +0200
Message-Id: <20220405070316.605134581@linuxfoundation.org>
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

From: Eric W. Biederman <ebiederm@xmission.com>

commit 9ec7d3230717b4fe9b6c7afeb4811909c23fa1d7 upstream.

Instead of individually passing cprm->siginfo and cprm->regs
into fill_note_info pass all of struct coredump_params.

This is preparation to allow fill_files_note to use the existing
vma snapshot.

Reviewed-by: Jann Horn <jannh@google.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/binfmt_elf.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -1797,7 +1797,7 @@ static int fill_thread_core_info(struct
 
 static int fill_note_info(struct elfhdr *elf, int phdrs,
 			  struct elf_note_info *info,
-			  const kernel_siginfo_t *siginfo, struct pt_regs *regs)
+			  struct coredump_params *cprm)
 {
 	struct task_struct *dump_task = current;
 	const struct user_regset_view *view = task_user_regset_view(dump_task);
@@ -1869,7 +1869,7 @@ static int fill_note_info(struct elfhdr
 	 * Now fill in each thread's information.
 	 */
 	for (t = info->thread; t != NULL; t = t->next)
-		if (!fill_thread_core_info(t, view, siginfo->si_signo, &info->size))
+		if (!fill_thread_core_info(t, view, cprm->siginfo->si_signo, &info->size))
 			return 0;
 
 	/*
@@ -1878,7 +1878,7 @@ static int fill_note_info(struct elfhdr
 	fill_psinfo(psinfo, dump_task->group_leader, dump_task->mm);
 	info->size += notesize(&info->psinfo);
 
-	fill_siginfo_note(&info->signote, &info->csigdata, siginfo);
+	fill_siginfo_note(&info->signote, &info->csigdata, cprm->siginfo);
 	info->size += notesize(&info->signote);
 
 	fill_auxv_note(&info->auxv, current->mm);
@@ -2026,7 +2026,7 @@ static int elf_note_info_init(struct elf
 
 static int fill_note_info(struct elfhdr *elf, int phdrs,
 			  struct elf_note_info *info,
-			  const kernel_siginfo_t *siginfo, struct pt_regs *regs)
+			  struct coredump_params *cprm)
 {
 	struct core_thread *ct;
 	struct elf_thread_status *ets;
@@ -2069,7 +2069,7 @@ static int fill_note_info(struct elfhdr
 	fill_note(info->notes + 1, "CORE", NT_PRPSINFO,
 		  sizeof(*info->psinfo), info->psinfo);
 
-	fill_siginfo_note(info->notes + 2, &info->csigdata, siginfo);
+	fill_siginfo_note(info->notes + 2, &info->csigdata, cprm->siginfo);
 	fill_auxv_note(info->notes + 3, current->mm);
 	info->numnote = 4;
 
@@ -2079,8 +2079,8 @@ static int fill_note_info(struct elfhdr
 	}
 
 	/* Try to dump the FPU. */
-	info->prstatus->pr_fpvalid = elf_core_copy_task_fpregs(current, regs,
-							       info->fpu);
+	info->prstatus->pr_fpvalid =
+		elf_core_copy_task_fpregs(current, cprm->regs, info->fpu);
 	if (info->prstatus->pr_fpvalid)
 		fill_note(info->notes + info->numnote++,
 			  "CORE", NT_PRFPREG, sizeof(*info->fpu), info->fpu);
@@ -2193,7 +2193,7 @@ static int elf_core_dump(struct coredump
 	 * Collect all the non-memory information about the process for the
 	 * notes.  This also sets up the file header.
 	 */
-	if (!fill_note_info(&elf, e_phnum, &info, cprm->siginfo, cprm->regs))
+	if (!fill_note_info(&elf, e_phnum, &info, cprm))
 		goto end_coredump;
 
 	has_dumped = 1;


