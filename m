Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB04E4F32E0
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 15:00:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238570AbiDEIoR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:44:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241256AbiDEIc6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:32:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D304D62D7;
        Tue,  5 Apr 2022 01:30:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6E233609D0;
        Tue,  5 Apr 2022 08:30:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 789CCC385A1;
        Tue,  5 Apr 2022 08:30:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649147445;
        bh=+XNFu5tzAZ28lpUNmFeUfsDI3/CgFwn+nRal1GCbe9E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R9HW318qcRDjd6FxgDir/48etQihrLiMdBd9pkzetI4d9S9FT5q4+dLVX8OXsR3EI
         Cl7RK1uyWDUvJiGtjBxTk27z6UNWRWM5QtVfbfvPcczBJjdJotl55pHpTjFz3vx/+M
         8w6v48BZbt3Hb0ANuX869ndkb7zakD2DLWruPkq8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jann Horn <jannh@google.com>,
        Kees Cook <keescook@chromium.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH 5.17 1125/1126] coredump/elf: Pass coredump_params into fill_note_info
Date:   Tue,  5 Apr 2022 09:31:12 +0200
Message-Id: <20220405070440.446167256@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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
 fs/binfmt_elf.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -1823,7 +1823,7 @@ static int fill_thread_core_info(struct
 
 static int fill_note_info(struct elfhdr *elf, int phdrs,
 			  struct elf_note_info *info,
-			  const kernel_siginfo_t *siginfo, struct pt_regs *regs)
+			  struct coredump_params *cprm)
 {
 	struct task_struct *dump_task = current;
 	const struct user_regset_view *view = task_user_regset_view(dump_task);
@@ -1895,7 +1895,7 @@ static int fill_note_info(struct elfhdr
 	 * Now fill in each thread's information.
 	 */
 	for (t = info->thread; t != NULL; t = t->next)
-		if (!fill_thread_core_info(t, view, siginfo->si_signo, &info->size))
+		if (!fill_thread_core_info(t, view, cprm->siginfo->si_signo, &info->size))
 			return 0;
 
 	/*
@@ -1904,7 +1904,7 @@ static int fill_note_info(struct elfhdr
 	fill_psinfo(psinfo, dump_task->group_leader, dump_task->mm);
 	info->size += notesize(&info->psinfo);
 
-	fill_siginfo_note(&info->signote, &info->csigdata, siginfo);
+	fill_siginfo_note(&info->signote, &info->csigdata, cprm->siginfo);
 	info->size += notesize(&info->signote);
 
 	fill_auxv_note(&info->auxv, current->mm);
@@ -2052,7 +2052,7 @@ static int elf_note_info_init(struct elf
 
 static int fill_note_info(struct elfhdr *elf, int phdrs,
 			  struct elf_note_info *info,
-			  const kernel_siginfo_t *siginfo, struct pt_regs *regs)
+			  struct coredump_params *cprm)
 {
 	struct core_thread *ct;
 	struct elf_thread_status *ets;
@@ -2073,13 +2073,13 @@ static int fill_note_info(struct elfhdr
 	list_for_each_entry(ets, &info->thread_list, list) {
 		int sz;
 
-		sz = elf_dump_thread_status(siginfo->si_signo, ets);
+		sz = elf_dump_thread_status(cprm->siginfo->si_signo, ets);
 		info->thread_status_size += sz;
 	}
 	/* now collect the dump for the current */
 	memset(info->prstatus, 0, sizeof(*info->prstatus));
-	fill_prstatus(&info->prstatus->common, current, siginfo->si_signo);
-	elf_core_copy_regs(&info->prstatus->pr_reg, regs);
+	fill_prstatus(&info->prstatus->common, current, cprm->siginfo->si_signo);
+	elf_core_copy_regs(&info->prstatus->pr_reg, cprm->regs);
 
 	/* Set up header */
 	fill_elf_header(elf, phdrs, ELF_ARCH, ELF_CORE_EFLAGS);
@@ -2095,7 +2095,7 @@ static int fill_note_info(struct elfhdr
 	fill_note(info->notes + 1, "CORE", NT_PRPSINFO,
 		  sizeof(*info->psinfo), info->psinfo);
 
-	fill_siginfo_note(info->notes + 2, &info->csigdata, siginfo);
+	fill_siginfo_note(info->notes + 2, &info->csigdata, cprm->siginfo);
 	fill_auxv_note(info->notes + 3, current->mm);
 	info->numnote = 4;
 
@@ -2105,8 +2105,8 @@ static int fill_note_info(struct elfhdr
 	}
 
 	/* Try to dump the FPU. */
-	info->prstatus->pr_fpvalid = elf_core_copy_task_fpregs(current, regs,
-							       info->fpu);
+	info->prstatus->pr_fpvalid =
+		elf_core_copy_task_fpregs(current, cprm->regs, info->fpu);
 	if (info->prstatus->pr_fpvalid)
 		fill_note(info->notes + info->numnote++,
 			  "CORE", NT_PRFPREG, sizeof(*info->fpu), info->fpu);
@@ -2219,7 +2219,7 @@ static int elf_core_dump(struct coredump
 	 * Collect all the non-memory information about the process for the
 	 * notes.  This also sets up the file header.
 	 */
-	if (!fill_note_info(&elf, e_phnum, &info, cprm->siginfo, cprm->regs))
+	if (!fill_note_info(&elf, e_phnum, &info, cprm))
 		goto end_coredump;
 
 	has_dumped = 1;


