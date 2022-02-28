Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB4A44C7483
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 18:45:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235726AbiB1Rpj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 12:45:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239501AbiB1RoR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 12:44:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D4FE9E555;
        Mon, 28 Feb 2022 09:36:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 734AEB815A6;
        Mon, 28 Feb 2022 17:36:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB446C340F1;
        Mon, 28 Feb 2022 17:36:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646069787;
        bh=aFHtDzRn92/ckV1DUQ1KrTVMJyNLtr7vHJdG9loj84Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uCniyjDjAnsW5OjA/w3PHgaL80t6i0nSiq0aSxqg7pGtxLtY/R6EqbQqJLgZ0uclH
         rXsc/RLSUtZWhh9zMoGE/hlsHkCyvVtGGmy2AOrwRddFrLnKL/lAYKOoUSy2yXTufr
         clewWo37NY5Rrp7f/PIxcmPi/wgPAGGzQW2a7ijI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Lu=C3=ADs=20Ferreira?= <contact@lsferreira.net>,
        Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@suse.de>
Subject: [PATCH 5.15 004/139] x86/ptrace: Fix xfpregs_set()s incorrect xmm clearing
Date:   Mon, 28 Feb 2022 18:22:58 +0100
Message-Id: <20220228172348.039335712@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172347.614588246@linuxfoundation.org>
References: <20220228172347.614588246@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Lutomirski <luto@kernel.org>

commit 44cad52cc14ae10062f142ec16ede489bccf4469 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/fpu/regset.c |    9 ++++-----
 arch/x86/kernel/ptrace.c     |    4 ++--
 2 files changed, 6 insertions(+), 7 deletions(-)

--- a/arch/x86/kernel/fpu/regset.c
+++ b/arch/x86/kernel/fpu/regset.c
@@ -87,11 +87,9 @@ int xfpregs_set(struct task_struct *targ
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
 
@@ -112,9 +110,10 @@ int xfpregs_set(struct task_struct *targ
 	/* Copy the state  */
 	memcpy(&fpu->state.fxsave, &newstate, sizeof(newstate));
 
-	/* Clear xmm8..15 */
+	/* Clear xmm8..15 for 32-bit callers */
 	BUILD_BUG_ON(sizeof(fpu->state.fxsave.xmm_space) != 16 * 16);
-	memset(&fpu->state.fxsave.xmm_space[8], 0, 8 * 16);
+	if (in_ia32_syscall())
+		memset(&fpu->state.fxsave.xmm_space[8*4], 0, 8 * 16);
 
 	/* Mark FP and SSE as in use when XSAVE is enabled */
 	if (use_xsave())
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -1224,7 +1224,7 @@ static struct user_regset x86_64_regsets
 	},
 	[REGSET_FP] = {
 		.core_note_type = NT_PRFPREG,
-		.n = sizeof(struct user_i387_struct) / sizeof(long),
+		.n = sizeof(struct fxregs_state) / sizeof(long),
 		.size = sizeof(long), .align = sizeof(long),
 		.active = regset_xregset_fpregs_active, .regset_get = xfpregs_get, .set = xfpregs_set
 	},
@@ -1271,7 +1271,7 @@ static struct user_regset x86_32_regsets
 	},
 	[REGSET_XFP] = {
 		.core_note_type = NT_PRXFPREG,
-		.n = sizeof(struct user32_fxsr_struct) / sizeof(u32),
+		.n = sizeof(struct fxregs_state) / sizeof(u32),
 		.size = sizeof(u32), .align = sizeof(u32),
 		.active = regset_xregset_fpregs_active, .regset_get = xfpregs_get, .set = xfpregs_set
 	},


