Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A212162AF2F
	for <lists+stable@lfdr.de>; Wed, 16 Nov 2022 00:12:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232069AbiKOXMA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Nov 2022 18:12:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238574AbiKOXLj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Nov 2022 18:11:39 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EBFA2E6B3
        for <stable@vger.kernel.org>; Tue, 15 Nov 2022 15:11:38 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id y203so15767068pfb.4
        for <stable@vger.kernel.org>; Tue, 15 Nov 2022 15:11:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kylehuey.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JUnl5mVywhHwsFoEEbFn7p+05kDcFKVp21uUWgQ1eAI=;
        b=DsjDjVjE5eNrFy11hX+hSy394Ka7KCuWodECy1nbg4uc4FpRLFMxTr7G36Ovt+sQHk
         PJv0QI4UTeM0xRiJvJWeBsIm5Q1VBiC189XuLKUxCFH5vPD5+GxmyGT8AR8kM22M8GrL
         DCvOCfX0BrGFAKtgXxQL6ZUikSpBFMguHt956oDc3b6N7lspDsJfAG/p6bg6xbm3QlBH
         hoPVV1PE6f8ffwIlgLBK/5a56Bivs/clznujDp0ZxHLWrtfEJFItl/cOgwoynuqc00pq
         3JeGMobmsgjOK8KhTh9+nH4EvwzFFsQiXb8Q/k0aI/lQC0M0h4gRgm9f8mFiOt5R1YBv
         ukLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JUnl5mVywhHwsFoEEbFn7p+05kDcFKVp21uUWgQ1eAI=;
        b=u/grwaW9tdaA1tA8YsxB1fdGBNuhlrCzy8KljPH5+xRH2L5yt1myVpnn3XtOxcW8n9
         aIf2J9kw4gXUFQ6uZ9RPSKJK8L1vayUOJ6InFKH/o4kPoAug83a5GnWz6GiLB2J/mdeA
         MW7qQUI0ylheSuZ6w5OPKGVkF0aFz+q4eoGfEfFqhSvu0L2waAEAxH90lzBtApnBQkBm
         I1rQJrCxVzlpTB+iMPusFQtvaUI5rOi4TVkK7VAW0n4nf3aZ3DrgPSkbllmR4kY3Ay4W
         iIeFKbLqPNWpzuDsYIjGtPxQUKm4N1eU39KkbvROTTXmju+2lCu7DTqKD1qXQsQlRNIz
         rC1Q==
X-Gm-Message-State: ANoB5pmbUq5WC5MqUJiRbzn2jYrNLVFZe8UWZ0CPzy+HeQLGnBZuaxvT
        nU2CKcCM5xwmS0nf6uY34WQh4A==
X-Google-Smtp-Source: AA0mqf5Vevz7nIR3nzoyndXemt0pvmtLDIs7P8cK+Uk6E7iQU9QVJZ+4D4aKm5gpTaDsqkycsqUNwA==
X-Received: by 2002:a63:1a24:0:b0:470:60a5:2f70 with SMTP id a36-20020a631a24000000b0047060a52f70mr18313359pga.99.1668553897780;
        Tue, 15 Nov 2022 15:11:37 -0800 (PST)
Received: from minbar.home.kylehuey.com (c-71-198-251-229.hsd1.ca.comcast.net. [71.198.251.229])
        by smtp.gmail.com with ESMTPSA id f15-20020a62380f000000b0056c360af4e3sm9308372pfa.9.2022.11.15.15.11.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Nov 2022 15:11:37 -0800 (PST)
From:   Kyle Huey <me@kylehuey.com>
X-Google-Original-From: Kyle Huey <khuey@kylehuey.com>
To:     Dave Hansen <dave.hansen@linux.intel.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <seanjc@google.com>,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Robert O'Callahan <robert@ocallahan.org>,
        David Manouchehri <david.manouchehri@riseup.net>,
        Kyle Huey <me@kylehuey.com>, Borislav Petkov <bp@suse.de>,
        stable@vger.kernel.org
Subject: [PATCH v7 4/6] x86/fpu: Allow PKRU to be (once again) written by ptrace.
Date:   Tue, 15 Nov 2022 15:09:30 -0800
Message-Id: <20221115230932.7126-5-khuey@kylehuey.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221115230932.7126-1-khuey@kylehuey.com>
References: <20221115230932.7126-1-khuey@kylehuey.com>
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

Move KVM's PKRU handling code in fpu_copy_uabi_to_guest_fpstate() to
copy_uabi_to_xstate() so that it is shared with other APIs that write the
XSTATE such as PTRACE_SETREGSET with NT_X86_XSTATE.

This restores the pre-5.14 behavior of ptrace. The regression can be seen
by running gdb and executing `p $pkru`, `set $pkru = 42`, and `p $pkru`.
On affected kernels (5.14+) the write to the PKRU register (which gdb
performs through ptrace) is ignored.

Fixes: e84ba47e313d ("x86/fpu: Hook up PKRU into ptrace()")
Signed-off-by: Kyle Huey <me@kylehuey.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Borislav Petkov <bp@suse.de>
Cc: stable@vger.kernel.org # 5.14+
---
 arch/x86/kernel/fpu/core.c   | 13 +------------
 arch/x86/kernel/fpu/xstate.c | 21 ++++++++++++++++++++-
 2 files changed, 21 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
index 550157686323..46b935bc87c8 100644
--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -391,8 +391,6 @@ int fpu_copy_uabi_to_guest_fpstate(struct fpu_guest *gfpu, const void *buf,
 {
 	struct fpstate *kstate = gfpu->fpstate;
 	const union fpregs_state *ustate = buf;
-	struct pkru_state *xpkru;
-	int ret;
 
 	if (!cpu_feature_enabled(X86_FEATURE_XSAVE)) {
 		if (ustate->xsave.header.xfeatures & ~XFEATURE_MASK_FPSSE)
@@ -406,16 +404,7 @@ int fpu_copy_uabi_to_guest_fpstate(struct fpu_guest *gfpu, const void *buf,
 	if (ustate->xsave.header.xfeatures & ~xcr0)
 		return -EINVAL;
 
-	ret = copy_uabi_from_kernel_to_xstate(kstate, ustate, vpkru);
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
diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
index 3a6ced76e932..bebc30c29ed3 100644
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -1205,10 +1205,22 @@ static int copy_from_buffer(void *dst, unsigned int offset, unsigned int size,
  * @fpstate:	The fpstate buffer to copy to
  * @kbuf:	The UABI format buffer, if it comes from the kernel
  * @ubuf:	The UABI format buffer, if it comes from userspace
- * @pkru:	unused
+ * @pkru:	The location to write the PKRU value to
  *
  * Converts from the UABI format into the kernel internal hardware
  * dependent format.
+ *
+ * This function ultimately has three different callers with distinct PKRU
+ * behavior.
+ * 1.	When called from sigreturn the PKRU register will be restored from
+ *	@fpstate via an XRSTOR. Correctly copying the UABI format buffer to
+ *	@fpstate is sufficient to cover this case, but the caller will also
+ *	pass a pointer to the thread_struct's pkru field in @pkru and updating
+ *	it is harmless.
+ * 2.	When called from ptrace the PKRU register will be restored from the
+ *	thread_struct's pkru field. A pointer to that is passed in @pkru.
+ * 3.	When called from KVM the PKRU register will be restored from the vcpu's
+ *	pkru field. A pointer to that is passed in @pkru.
  */
 static int copy_uabi_to_xstate(struct fpstate *fpstate, const void *kbuf,
 			       const void __user *ubuf, u32 *pkru)
@@ -1260,6 +1272,13 @@ static int copy_uabi_to_xstate(struct fpstate *fpstate, const void *kbuf,
 		}
 	}
 
+	if (hdr.xfeatures & XFEATURE_MASK_PKRU) {
+		struct pkru_state *xpkru;
+
+		xpkru = __raw_xsave_addr(xsave, XFEATURE_PKRU);
+		*pkru = xpkru->pkru;
+	}
+
 	/*
 	 * The state that came in from userspace was user-state only.
 	 * Mask all the user states out of 'xfeatures':
-- 
2.38.1

