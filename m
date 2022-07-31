Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AC4A585D99
	for <lists+stable@lfdr.de>; Sun, 31 Jul 2022 07:03:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231342AbiGaFDs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 31 Jul 2022 01:03:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229911AbiGaFDr (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 31 Jul 2022 01:03:47 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11F6913D5A
        for <stable@vger.kernel.org>; Sat, 30 Jul 2022 22:03:45 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id f11so7059581pgj.7
        for <stable@vger.kernel.org>; Sat, 30 Jul 2022 22:03:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kylehuey.com; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=LzB8XuGXprfZz0N1oF/7jRPSpf9FyZkTZ3frqXsBtnc=;
        b=gEXYE/ZP3mN9LEHWIo967jESNWuZeLpX+BsRSQEr7/bTs5+csJDdmdlrquXNZzrHj8
         yB1w1IDLEN/ReoNtW8GZbkvfXZUIF38jJA1qO+U4POMf+6YCF7TF1Ej5sEm8JrhSb69c
         UzxWfCJWJB6ZZVxuK/DehOcqsr710h1ZHAZ9IVtCzvFzjfo7c/kdFoEmW7kFCX6jmfmz
         sANy1OA3T4zYyEeyXQispCvWsuLjhF/GmeYbTMu3LzlOV5H7ORrLVF4UqyfhpP4nGEmE
         OMgw3A8x6X5YS7Tsen2gx6V10i1ruSahUIMztiaXIB3mcy1Td+6gmwWEXgdeMoyRzU6P
         GwrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=LzB8XuGXprfZz0N1oF/7jRPSpf9FyZkTZ3frqXsBtnc=;
        b=ptEOg2dp9rwpHHDwrms/VS/C5p7HdtG9SyH4ekDWK1F4rTnqbvsMgjLDv+f+KOT4rQ
         akyAOWqID6cWsJhomDR4b57HtYKyW/M+RpZOFFLHOYW7stny8GI5JOfS0/B+XFXCXUuL
         RMgJwmUHNvGIezMKL4roQyWMKz4ADaW9Ivl+ORYzEf1j4S3AUDRVTI0OevLgPjuakoWK
         Lr8DsJ3cdgpAROXWhtufoFZaJWzxQXaBBHptuUywu9y56KDKyybre0AQ9O+zgfOH8lVM
         mqbTBFZmaQRxSmWSgxtYznsZZBXWKlgxJBK09JI20Q2biHm2cv2d2oyos6Pq/eUcZvIf
         qLsQ==
X-Gm-Message-State: AJIora/ZkMRi2Sl6dkGoFIkoymrmRxVdNhhD2wg0n9sZo4RQJ+AboJ3W
        B+KX6hKaQGcBjlbDKvYvx92StA==
X-Google-Smtp-Source: AGRyM1sVdAH14sGSgUBwRYIjpmst+tPrJVkOlRxmDnDET70SUsJNKV30xDvo/M2GgAMKxtUtTr9iIQ==
X-Received: by 2002:a05:6a00:bc5:b0:52b:49c9:d26c with SMTP id x5-20020a056a000bc500b0052b49c9d26cmr10487567pfu.73.1659243824487;
        Sat, 30 Jul 2022 22:03:44 -0700 (PDT)
Received: from minbar.home.kylehuey.com (c-71-198-251-229.hsd1.ca.comcast.net. [71.198.251.229])
        by smtp.gmail.com with ESMTPSA id f14-20020a170902684e00b00162529828aesm6647811pln.109.2022.07.30.22.03.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 Jul 2022 22:03:44 -0700 (PDT)
From:   Kyle Huey <me@kylehuey.com>
X-Google-Original-From: Kyle Huey <khuey@kylehuey.com>
To:     Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>
Cc:     Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org,
        Robert O'Callahan <robert@ocallahan.org>,
        David Manouchehri <david.manouchehri@riseup.net>,
        Kyle Huey <me@kylehuey.com>, kvm@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH] x86/fpu: Allow PKRU to be (once again) written by ptrace.
Date:   Sat, 30 Jul 2022 22:03:42 -0700
Message-Id: <20220731050342.56513-1-khuey@kylehuey.com>
X-Mailer: git-send-email 2.37.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kyle Huey <me@kylehuey.com>

When management of the PKRU register was moved away from XSTATE, emulation
of PKRU's existence in XSTATE was added for APIs that read XSTATE, but not
for APIs that write XSTATE. This can be seen by running gdb and executing
`p $pkru`, `set $pkru = 42`, and `p $pkru`. On affected kernels (5.14+) the
write to the PKRU register (which gdb performs through ptrace) is ignored.

There are three relevant APIs: PTRACE_SETREGSET with NT_X86_XSTATE,
sigreturn, and KVM_SET_XSAVE. KVM_SET_XSAVE has its own special handling to
make PKRU writes take effect (in fpu_copy_uabi_to_guest_fpstate). Push that
down into copy_uabi_to_xstate and have PTRACE_SETREGSET with NT_X86_XSTATE
and sigreturn pass in pointers to the appropriate PKRU value.

This also adds code to initialize the PKRU value to the hardware init value
(namely 0) if the PKRU bit is not set in the XSTATE header to match XRSTOR.
This is a change to the current KVM_SET_XSAVE behavior.

Signed-off-by: Kyle Huey <me@kylehuey.com>
Cc: kvm@vger.kernel.org # For edge case behavior of KVM_SET_XSAVE
Cc: stable@vger.kernel.org # 5.14+
Fixes: e84ba47e313dbc097bf859bb6e4f9219883d5f78
---
 arch/x86/kernel/fpu/core.c   | 11 +----------
 arch/x86/kernel/fpu/regset.c |  2 +-
 arch/x86/kernel/fpu/signal.c |  2 +-
 arch/x86/kernel/fpu/xstate.c | 26 +++++++++++++++++++++-----
 arch/x86/kernel/fpu/xstate.h |  4 ++--
 5 files changed, 26 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
index 0531d6a06df5..dfb79e2ee81f 100644
--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -406,16 +406,7 @@ int fpu_copy_uabi_to_guest_fpstate(struct fpu_guest *gfpu, const void *buf,
 	if (ustate->xsave.header.xfeatures & ~xcr0)
 		return -EINVAL;
 
-	ret = copy_uabi_from_kernel_to_xstate(kstate, ustate);
-	if (ret)
-		return ret;
-
-	/* Retrieve PKRU if not in init state */
-	if (kstate->regs.xsave.header.xfeatures & XFEATURE_MASK_PKRU) {
-		xpkru = get_xsave_addr(&kstate->regs.xsave, XFEATURE_PKRU);
-		*vpkru = xpkru->pkru;
-	}
-	return 0;
+	return copy_uabi_from_kernel_to_xstate(kstate, ustate, vpkru);
 }
 EXPORT_SYMBOL_GPL(fpu_copy_uabi_to_guest_fpstate);
 #endif /* CONFIG_KVM */
diff --git a/arch/x86/kernel/fpu/regset.c b/arch/x86/kernel/fpu/regset.c
index 75ffaef8c299..6d056b68f4ed 100644
--- a/arch/x86/kernel/fpu/regset.c
+++ b/arch/x86/kernel/fpu/regset.c
@@ -167,7 +167,7 @@ int xstateregs_set(struct task_struct *target, const struct user_regset *regset,
 	}
 
 	fpu_force_restore(fpu);
-	ret = copy_uabi_from_kernel_to_xstate(fpu->fpstate, kbuf ?: tmpbuf);
+	ret = copy_uabi_from_kernel_to_xstate(fpu->fpstate, kbuf ?: tmpbuf, &target->thread.pkru);
 
 out:
 	vfree(tmpbuf);
diff --git a/arch/x86/kernel/fpu/signal.c b/arch/x86/kernel/fpu/signal.c
index 91d4b6de58ab..558076dbde5b 100644
--- a/arch/x86/kernel/fpu/signal.c
+++ b/arch/x86/kernel/fpu/signal.c
@@ -396,7 +396,7 @@ static bool __fpu_restore_sig(void __user *buf, void __user *buf_fx,
 
 	fpregs = &fpu->fpstate->regs;
 	if (use_xsave() && !fx_only) {
-		if (copy_sigframe_from_user_to_xstate(fpu->fpstate, buf_fx))
+		if (copy_sigframe_from_user_to_xstate(tsk, buf_fx))
 			return false;
 	} else {
 		if (__copy_from_user(&fpregs->fxsave, buf_fx,
diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
index c8340156bfd2..1eea7af4afd9 100644
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -1197,7 +1197,7 @@ static int copy_from_buffer(void *dst, unsigned int offset, unsigned int size,
 
 
 static int copy_uabi_to_xstate(struct fpstate *fpstate, const void *kbuf,
-			       const void __user *ubuf)
+			       const void __user *ubuf, u32 *pkru)
 {
 	struct xregs_state *xsave = &fpstate->regs.xsave;
 	unsigned int offset, size;
@@ -1235,6 +1235,22 @@ static int copy_uabi_to_xstate(struct fpstate *fpstate, const void *kbuf,
 	for (i = 0; i < XFEATURE_MAX; i++) {
 		mask = BIT_ULL(i);
 
+		if (i == XFEATURE_PKRU) {
+			/*
+			 * Retrieve PKRU if not in init state, otherwise
+			 * initialize it.
+			 */
+			if (hdr.xfeatures & mask) {
+				struct pkru_state xpkru = {0};
+
+				copy_from_buffer(&xpkru, xstate_offsets[i],
+						 sizeof(xpkru), kbuf, ubuf);
+				*pkru = xpkru.pkru;
+			} else {
+				*pkru = 0;
+			}
+		}
+
 		if (hdr.xfeatures & mask) {
 			void *dst = __raw_xsave_addr(xsave, i);
 
@@ -1264,9 +1280,9 @@ static int copy_uabi_to_xstate(struct fpstate *fpstate, const void *kbuf,
  * Convert from a ptrace standard-format kernel buffer to kernel XSAVE[S]
  * format and copy to the target thread. Used by ptrace and KVM.
  */
-int copy_uabi_from_kernel_to_xstate(struct fpstate *fpstate, const void *kbuf)
+int copy_uabi_from_kernel_to_xstate(struct fpstate *fpstate, const void *kbuf, u32 *pkru)
 {
-	return copy_uabi_to_xstate(fpstate, kbuf, NULL);
+	return copy_uabi_to_xstate(fpstate, kbuf, NULL, pkru);
 }
 
 /*
@@ -1274,10 +1290,10 @@ int copy_uabi_from_kernel_to_xstate(struct fpstate *fpstate, const void *kbuf)
  * XSAVE[S] format and copy to the target thread. This is called from the
  * sigreturn() and rt_sigreturn() system calls.
  */
-int copy_sigframe_from_user_to_xstate(struct fpstate *fpstate,
+int copy_sigframe_from_user_to_xstate(struct task_struct *tsk,
 				      const void __user *ubuf)
 {
-	return copy_uabi_to_xstate(fpstate, NULL, ubuf);
+	return copy_uabi_to_xstate(tsk->thread.fpu.fpstate, NULL, ubuf, &tsk->thread.pkru);
 }
 
 static bool validate_independent_components(u64 mask)
diff --git a/arch/x86/kernel/fpu/xstate.h b/arch/x86/kernel/fpu/xstate.h
index 5ad47031383b..a4ecb04d8d64 100644
--- a/arch/x86/kernel/fpu/xstate.h
+++ b/arch/x86/kernel/fpu/xstate.h
@@ -46,8 +46,8 @@ extern void __copy_xstate_to_uabi_buf(struct membuf to, struct fpstate *fpstate,
 				      u32 pkru_val, enum xstate_copy_mode copy_mode);
 extern void copy_xstate_to_uabi_buf(struct membuf to, struct task_struct *tsk,
 				    enum xstate_copy_mode mode);
-extern int copy_uabi_from_kernel_to_xstate(struct fpstate *fpstate, const void *kbuf);
-extern int copy_sigframe_from_user_to_xstate(struct fpstate *fpstate, const void __user *ubuf);
+extern int copy_uabi_from_kernel_to_xstate(struct fpstate *fpstate, const void *kbuf, u32 *pkru);
+extern int copy_sigframe_from_user_to_xstate(struct task_struct *tsk, const void __user *ubuf);
 
 
 extern void fpu__init_cpu_xstate(void);
-- 
2.37.0

