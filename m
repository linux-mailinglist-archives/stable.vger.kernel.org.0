Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B911C4BD75B
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 08:44:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345741AbiBUG6J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 01:58:09 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243699AbiBUG6I (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 01:58:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D96625C4E
        for <stable@vger.kernel.org>; Sun, 20 Feb 2022 22:57:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9CED5B80E76
        for <stable@vger.kernel.org>; Mon, 21 Feb 2022 06:57:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDDF1C340E9;
        Mon, 21 Feb 2022 06:57:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645426662;
        bh=XsT0x6N7OjZ/mJqj+tR+Qp2VkzrNssVVptCUixFvO8k=;
        h=Subject:To:Cc:From:Date:From;
        b=rFzcFWEAoBRkd0QShoxTWFOAq/RtNIsafj5zwaEQOH0booG1u/GA9F3C+vXi+228H
         QzwJxDxpGNd69sGIRrTPWAxFnfOROxkh0eUSZloE/CmeVGoGhG8+AjE2sxxZSToTtt
         PWFlTAbyCbYFhohoBSPNOkCi483ONXOJuqfbtdFk=
Subject: FAILED: patch "[PATCH] x86/ptrace: Fix xfpregs_set()'s incorrect xmm clearing" failed to apply to 5.15-stable tree
To:     luto@kernel.org, bp@suse.de, contact@lsferreira.net,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 21 Feb 2022 07:57:39 +0100
Message-ID: <164542665924686@kroah.com>
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

From 44cad52cc14ae10062f142ec16ede489bccf4469 Mon Sep 17 00:00:00 2001
From: Andy Lutomirski <luto@kernel.org>
Date: Mon, 14 Feb 2022 13:05:49 +0100
Subject: [PATCH] x86/ptrace: Fix xfpregs_set()'s incorrect xmm clearing
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

xfpregs_set() handles 32-bit REGSET_XFP and 64-bit REGSET_FP. The actual
code treats these regsets as modern FX state (i.e. the beginning part of
XSTATE). The declarations of the regsets thought they were the legacy
i387 format. The code thought they were the 32-bit (no xmm8..15) variant
of XSTATE and, for good measure, made the high bits disappear by zeroing
the wrong part of the buffer. The latter broke ptrace, and everything
else confused anyone trying to understand the code. In particular, the
nonsense definitions of the regsets confused me when I wrote this code.

Clean this all up. Change the declarations to match reality (which
shouldn't change the generated code, let alone the ABI) and fix
xfpregs_set() to clear the correct bits and to only do so for 32-bit
callers.

Fixes: 6164331d15f7 ("x86/fpu: Rewrite xfpregs_set()")
Reported-by: Luís Ferreira <contact@lsferreira.net>
Signed-off-by: Andy Lutomirski <luto@kernel.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: <stable@vger.kernel.org>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=215524
Link: https://lore.kernel.org/r/YgpFnZpF01WwR8wU@zn.tnic

diff --git a/arch/x86/kernel/fpu/regset.c b/arch/x86/kernel/fpu/regset.c
index 437d7c930c0b..75ffaef8c299 100644
--- a/arch/x86/kernel/fpu/regset.c
+++ b/arch/x86/kernel/fpu/regset.c
@@ -91,11 +91,9 @@ int xfpregs_set(struct task_struct *target, const struct user_regset *regset,
 		const void *kbuf, const void __user *ubuf)
 {
 	struct fpu *fpu = &target->thread.fpu;
-	struct user32_fxsr_struct newstate;
+	struct fxregs_state newstate;
 	int ret;
 
-	BUILD_BUG_ON(sizeof(newstate) != sizeof(struct fxregs_state));
-
 	if (!cpu_feature_enabled(X86_FEATURE_FXSR))
 		return -ENODEV;
 
@@ -116,9 +114,10 @@ int xfpregs_set(struct task_struct *target, const struct user_regset *regset,
 	/* Copy the state  */
 	memcpy(&fpu->fpstate->regs.fxsave, &newstate, sizeof(newstate));
 
-	/* Clear xmm8..15 */
+	/* Clear xmm8..15 for 32-bit callers */
 	BUILD_BUG_ON(sizeof(fpu->__fpstate.regs.fxsave.xmm_space) != 16 * 16);
-	memset(&fpu->fpstate->regs.fxsave.xmm_space[8], 0, 8 * 16);
+	if (in_ia32_syscall())
+		memset(&fpu->fpstate->regs.fxsave.xmm_space[8*4], 0, 8 * 16);
 
 	/* Mark FP and SSE as in use when XSAVE is enabled */
 	if (use_xsave())
diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index 6d2244c94799..8d2f2f995539 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -1224,7 +1224,7 @@ static struct user_regset x86_64_regsets[] __ro_after_init = {
 	},
 	[REGSET_FP] = {
 		.core_note_type = NT_PRFPREG,
-		.n = sizeof(struct user_i387_struct) / sizeof(long),
+		.n = sizeof(struct fxregs_state) / sizeof(long),
 		.size = sizeof(long), .align = sizeof(long),
 		.active = regset_xregset_fpregs_active, .regset_get = xfpregs_get, .set = xfpregs_set
 	},
@@ -1271,7 +1271,7 @@ static struct user_regset x86_32_regsets[] __ro_after_init = {
 	},
 	[REGSET_XFP] = {
 		.core_note_type = NT_PRXFPREG,
-		.n = sizeof(struct user32_fxsr_struct) / sizeof(u32),
+		.n = sizeof(struct fxregs_state) / sizeof(u32),
 		.size = sizeof(u32), .align = sizeof(u32),
 		.active = regset_xregset_fpregs_active, .regset_get = xfpregs_get, .set = xfpregs_set
 	},

