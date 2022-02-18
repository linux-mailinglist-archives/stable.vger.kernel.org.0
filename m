Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 253AB4BB6F9
	for <lists+stable@lfdr.de>; Fri, 18 Feb 2022 11:36:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232208AbiBRKgX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Feb 2022 05:36:23 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229694AbiBRKgX (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Feb 2022 05:36:23 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4570B2B3575;
        Fri, 18 Feb 2022 02:36:05 -0800 (PST)
Date:   Fri, 18 Feb 2022 10:36:01 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1645180562;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vrDjnYGriIcx9Ox1QC6AoQgMAAK0YnoxLVYtUNI8yIQ=;
        b=43/GBuKy0U0w/+9/D/lAt4il4dHMluOl6XnW7S7rnpxWhW2Fyr33xbmUfTSz6xKT6AS++A
        OafHmrqgTw7xLfWaC0Clp3ryTAFqpxYhHQJhYxNiy/su7amUuDKT5jJr0cYTbw92zUeiLQ
        i0a5fI9e+SBxiixSPL69SaGEBHXkYQkX3gif/a6+dZ0JBv3EA7rX1+M1wI+mR8arYPnS1/
        iNVsSsDcshmCmu4j9e5AYqnahswp5sLvlgR03LMKwHSfqnoaTcAmrOghDjXtwW//tHS4Hn
        ysOER9Udk1E1zjnGxMjx9bFgJxXpcGdelNCr+v/xkK8UKmikOTH0/od53k2A1w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1645180562;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vrDjnYGriIcx9Ox1QC6AoQgMAAK0YnoxLVYtUNI8yIQ=;
        b=j2IMPyqZipmgd30pxq3e8vN2JWUv9bHEvb/cPuIqtU2mejAbHAWvPOMdPz5kZP0a+tOibW
        2Bka7hN1uXw6DzDg==
From:   "tip-bot2 for Andy Lutomirski" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/ptrace: Fix xfpregs_set()'s incorrect xmm clearing
Cc:     contact@lsferreira.net, Andy Lutomirski <luto@kernel.org>,
        Borislav Petkov <bp@suse.de>, <stable@vger.kernel.org>,
        x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <YgpFnZpF01WwR8wU@zn.tnic>
References: <YgpFnZpF01WwR8wU@zn.tnic>
MIME-Version: 1.0
Message-ID: <164518056109.16921.5538462519727377256.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     44cad52cc14ae10062f142ec16ede489bccf4469
Gitweb:        https://git.kernel.org/tip/44cad52cc14ae10062f142ec16ede489bcc=
f4469
Author:        Andy Lutomirski <luto@kernel.org>
AuthorDate:    Mon, 14 Feb 2022 13:05:49 +01:00
Committer:     Borislav Petkov <bp@suse.de>
CommitterDate: Fri, 18 Feb 2022 11:23:21 +01:00

x86/ptrace: Fix xfpregs_set()'s incorrect xmm clearing

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
Reported-by: Lu=C3=ADs Ferreira <contact@lsferreira.net>
Signed-off-by: Andy Lutomirski <luto@kernel.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: <stable@vger.kernel.org>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=3D215524
Link: https://lore.kernel.org/r/YgpFnZpF01WwR8wU@zn.tnic
---
 arch/x86/kernel/fpu/regset.c |  9 ++++-----
 arch/x86/kernel/ptrace.c     |  4 ++--
 2 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/fpu/regset.c b/arch/x86/kernel/fpu/regset.c
index 437d7c9..75ffaef 100644
--- a/arch/x86/kernel/fpu/regset.c
+++ b/arch/x86/kernel/fpu/regset.c
@@ -91,11 +91,9 @@ int xfpregs_set(struct task_struct *target, const struct u=
ser_regset *regset,
 		const void *kbuf, const void __user *ubuf)
 {
 	struct fpu *fpu =3D &target->thread.fpu;
-	struct user32_fxsr_struct newstate;
+	struct fxregs_state newstate;
 	int ret;
=20
-	BUILD_BUG_ON(sizeof(newstate) !=3D sizeof(struct fxregs_state));
-
 	if (!cpu_feature_enabled(X86_FEATURE_FXSR))
 		return -ENODEV;
=20
@@ -116,9 +114,10 @@ int xfpregs_set(struct task_struct *target, const struct=
 user_regset *regset,
 	/* Copy the state  */
 	memcpy(&fpu->fpstate->regs.fxsave, &newstate, sizeof(newstate));
=20
-	/* Clear xmm8..15 */
+	/* Clear xmm8..15 for 32-bit callers */
 	BUILD_BUG_ON(sizeof(fpu->__fpstate.regs.fxsave.xmm_space) !=3D 16 * 16);
-	memset(&fpu->fpstate->regs.fxsave.xmm_space[8], 0, 8 * 16);
+	if (in_ia32_syscall())
+		memset(&fpu->fpstate->regs.fxsave.xmm_space[8*4], 0, 8 * 16);
=20
 	/* Mark FP and SSE as in use when XSAVE is enabled */
 	if (use_xsave())
diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index 6d2244c..8d2f2f9 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -1224,7 +1224,7 @@ static struct user_regset x86_64_regsets[] __ro_after_i=
nit =3D {
 	},
 	[REGSET_FP] =3D {
 		.core_note_type =3D NT_PRFPREG,
-		.n =3D sizeof(struct user_i387_struct) / sizeof(long),
+		.n =3D sizeof(struct fxregs_state) / sizeof(long),
 		.size =3D sizeof(long), .align =3D sizeof(long),
 		.active =3D regset_xregset_fpregs_active, .regset_get =3D xfpregs_get, .se=
t =3D xfpregs_set
 	},
@@ -1271,7 +1271,7 @@ static struct user_regset x86_32_regsets[] __ro_after_i=
nit =3D {
 	},
 	[REGSET_XFP] =3D {
 		.core_note_type =3D NT_PRXFPREG,
-		.n =3D sizeof(struct user32_fxsr_struct) / sizeof(u32),
+		.n =3D sizeof(struct fxregs_state) / sizeof(u32),
 		.size =3D sizeof(u32), .align =3D sizeof(u32),
 		.active =3D regset_xregset_fpregs_active, .regset_get =3D xfpregs_get, .se=
t =3D xfpregs_set
 	},
