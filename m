Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F38B58966E
	for <lists+stable@lfdr.de>; Thu,  4 Aug 2022 05:16:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238732AbiHDDQl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Aug 2022 23:16:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237531AbiHDDQi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Aug 2022 23:16:38 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17B715E31C
        for <stable@vger.kernel.org>; Wed,  3 Aug 2022 20:16:35 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id o3so18172837ple.5
        for <stable@vger.kernel.org>; Wed, 03 Aug 2022 20:16:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kylehuey.com; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=0Eidlkaci04rHoeZFe7JPn0wdB0zBqovVdfDYpCgudw=;
        b=ROdIXNMccLVEnJtpOwGav/0wNNCzgREpIq+MQUlTjRT0tCJoPfGpubTVJ1LHnaruTr
         OZgYaRXIvMlhGs9skVZFDZSRfFYzEmoebwyR/gMMEFyXwbePhNKufjN8A4OeUu84uCTb
         Rq2vUq5JtHLNTDNdXnrQB2OCoBOtSNAQO5x19A2bdHN2mXnFvq2hDNFNsld68uWMWABH
         cOHPcV2qz/8PDhGBcCS3lLI+AfKgqdEqVktdUVNMtwoIx4DnPv5JD5MnPSrLsGaVZ8vB
         iIVQwUEHnmvhA7LzASwb0dPEwg5Fu5BWMXKk5kfGoz/9CG0Xi9mKPYXZsskrLun9Y//k
         j3Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=0Eidlkaci04rHoeZFe7JPn0wdB0zBqovVdfDYpCgudw=;
        b=5BCHGLLLNXj1nvEhRMbXUpItrnQMdKbApk2yXgYgI+WRMSOCpJ7tiAarWRiPEeUm/B
         V9VgELPQzaPzAtmEE4SQChsg74DGTIQzCZFZeURpXfU7Y6btZo8+zyX8Zt15rtRv/e7h
         nu8wgGvpCpvvZs9DYToI15FYKdUVvK7mNOrXd1g/d0Fp0aXSHvAy8mhvinizlzxWSvdT
         5OEvpY7PBKWxT9I612ENIFBgOKm6Y7R9zbnEgvGuTCn+5G9230LOUdRsWjb6xOQ6GI9f
         AJsJYL7aNSMVH9T5EGGqIE26ZYYGOuRi80HcSlFwDgnbChjuQ+Emi0i2eskC38kFLyqM
         5MOA==
X-Gm-Message-State: ACgBeo3gCkDaeWIg3Q9/hNYwSiiYJuEnhGMvUqYvbRrQ1nC7IyJk+1kR
        8xWsxFBDCfovBy7QhYm6gTHZNg==
X-Google-Smtp-Source: AA6agR7Ks9ZG70ZGVbxOdEryKUq3Xnv+8QfCWcNgh9DQpzlr4m1G4zvNLtyqeMU7Pdi4Gcva1NGZrg==
X-Received: by 2002:a17:90a:e7c7:b0:1f2:bea3:37df with SMTP id kb7-20020a17090ae7c700b001f2bea337dfmr8330056pjb.133.1659582995107;
        Wed, 03 Aug 2022 20:16:35 -0700 (PDT)
Received: from minbar.home.kylehuey.com (c-71-198-251-229.hsd1.ca.comcast.net. [71.198.251.229])
        by smtp.gmail.com with ESMTPSA id q6-20020a17090a68c600b001f2e20edd14sm2334699pjj.45.2022.08.03.20.16.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Aug 2022 20:16:34 -0700 (PDT)
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
        Kyle Huey <me@kylehuey.com>, Borislav Petkov <bp@suse.de>,
        kvm@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH v2] x86/fpu: Allow PKRU to be (once again) written by ptrace.
Date:   Wed,  3 Aug 2022 20:16:32 -0700
Message-Id: <20220804031632.52921-1-khuey@kylehuey.com>
X-Mailer: git-send-email 2.37.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
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

Changelog since v1:
- Handles the error case of copy_to_buffer().

Signed-off-by: Kyle Huey <me@kylehuey.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Borislav Petkov <bp@suse.de>
Cc: kvm@vger.kernel.org # For edge case behavior of KVM_SET_XSAVE
Cc: stable@vger.kernel.org # 5.14+
Fixes: e84ba47e313d ("x86/fpu: Hook up PKRU into ptrace()")
---
 arch/x86/kernel/fpu/core.c   | 11 +----------
 arch/x86/kernel/fpu/regset.c |  2 +-
 arch/x86/kernel/fpu/signal.c |  2 +-
 arch/x86/kernel/fpu/xstate.c | 28 +++++++++++++++++++++++-----
 arch/x86/kernel/fpu/xstate.h |  4 ++--
 5 files changed, 28 insertions(+), 19 deletions(-)

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
index c8340156bfd2..e01d3514ae68 100644
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -1197,7 +1197,7 @@ static int copy_from_buffer(void *dst, unsigned int offset, unsigned int size,
 
 
 static int copy_uabi_to_xstate(struct fpstate *fpstate, const void *kbuf,
-			       const void __user *ubuf)
+			       const void __user *ubuf, u32 *pkru)
 {
 	struct xregs_state *xsave = &fpstate->regs.xsave;
 	unsigned int offset, size;
@@ -1235,6 +1235,24 @@ static int copy_uabi_to_xstate(struct fpstate *fpstate, const void *kbuf,
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
+				if (copy_from_buffer(&xpkru, xstate_offsets[i],
+						     sizeof(xpkru), kbuf, ubuf))
+					return -EFAULT;
+
+				*pkru = xpkru.pkru;
+			} else {
+				*pkru = 0;
+			}
+		}
+
 		if (hdr.xfeatures & mask) {
 			void *dst = __raw_xsave_addr(xsave, i);
 
@@ -1264,9 +1282,9 @@ static int copy_uabi_to_xstate(struct fpstate *fpstate, const void *kbuf,
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
@@ -1274,10 +1292,10 @@ int copy_uabi_from_kernel_to_xstate(struct fpstate *fpstate, const void *kbuf)
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

