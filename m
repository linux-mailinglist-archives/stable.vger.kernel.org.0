Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C6D133B273
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 13:23:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229965AbhCOMWj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 08:22:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbhCOMWP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Mar 2021 08:22:15 -0400
Received: from mail-ed1-x549.google.com (mail-ed1-x549.google.com [IPv6:2a00:1450:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63034C061574
        for <stable@vger.kernel.org>; Mon, 15 Mar 2021 05:22:15 -0700 (PDT)
Received: by mail-ed1-x549.google.com with SMTP id w16so15865303edc.22
        for <stable@vger.kernel.org>; Mon, 15 Mar 2021 05:22:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=fRWjTowij/e3Q0sjNrdb6qA8tgM0QEsCeCOJzERGm7s=;
        b=VM6pgmCO6drvOMnmfsHHbMAwCCkLjWP5+72WdB76pNyrvLaA0vAktr0NQSsBKBY5AY
         S3E1gCjXvhjlUaz8CXR5CcITIKoUGItPD8arPEkn5ltUKOO8MnlXY2BH7tY8fp/HmjfH
         A+hWIpErM9/UdCcGZQpELEfMzniO5aDWLK9PFocZK/0SqD7A3TkiDRWYqDx0akT+TxTM
         fLT+0mFTO++tJU1WPvrUor0aDHbSDNZmSklpZDlcIpIgGZ9eN19DxK+ShurqofRZa3xE
         eKR4xy5x6YduyWdtg+L84yF7yQlqZvuIod4qU6TgEJl5JT43OfTWGN8c6eaQ3S1KxlOT
         SMoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=fRWjTowij/e3Q0sjNrdb6qA8tgM0QEsCeCOJzERGm7s=;
        b=Gvqmq7j/rhs3soXWH0yknRFEDtBcBhF5PaObzajULDcrqc83f7t3Hae97rt3tEgbyp
         nopJQEjE6LTNqRBIC1VCgjlzG4/LfZqxFKHPMK5wxkNzylC0Iu71Ql2Z2d/MwElhbn2J
         hwE0BAFMIqm5+L2CI+KMdBZ7rMIwr7F3J6mgTd8bEiOyoAGpfx1iDyYl73vu36S/zRs6
         2tQk1Gj7BT8B4bmHkk85ADOC6+byQ5/bdcliMZjtgon7hlJ0wyrpugS/VKNWSc+zr4NH
         +wcA/9FsvB4U1RQiC2nyi5yTa64ypw2MV56kCZO+KFnsuwYg3Z8zOwMx8gWR0R1co/Pn
         d5qw==
X-Gm-Message-State: AOAM532QQH+mFzUBRF9HSo7I9GgI879iETG+W1nvlhpN+B6MFhG4vcGU
        WnGdCkqRj1T/DXHvG9kMyRUSqqbnCyY=
X-Google-Smtp-Source: ABdhPJxO3avSctya0WAUjWrKQfStJ9JQYgruNzNVj9/RpYhwrDc4yuZequMkEqrAAiUxd2RjjO/9LOyODH0=
X-Received: from ascull.c.googlers.com ([fda3:e722:ac3:10:28:9cb1:c0a8:1510])
 (user=ascull job=sendgmr) by 2002:a17:907:7637:: with SMTP id
 jy23mr22426198ejc.12.1615810933760; Mon, 15 Mar 2021 05:22:13 -0700 (PDT)
Date:   Mon, 15 Mar 2021 12:22:10 +0000
Message-Id: <20210315122210.1688894-1-ascull@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.31.0.rc2.261.g7f71774620-goog
Subject: [PATCH] KVM: arm64: Fix nVHE hyp panic host context restore
From:   Andrew Scull <ascull@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     maz@kernel.org, kernel-team@android.com,
        Andrew Scull <ascull@google.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit c4b000c3928d4f20acef79dccf3a65ae3795e0b0 upstream.

When panicking from the nVHE hyp and restoring the host context, x29 is
expected to hold a pointer to the host context. This wasn't being done
so fix it to make sure there's a valid pointer the host context being
used.

Rather than passing a boolean indicating whether or not the host context
should be restored, instead pass the pointer to the host context. NULL
is passed to indicate that no context should be restored.

Fixes: a2e102e20fd6 ("KVM: arm64: nVHE: Handle hyp panics")
Cc: stable@vger.kernel.org # 5.10.y only
Signed-off-by: Andrew Scull <ascull@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20210219122406.1337626-1-ascull@google.com
---
 arch/arm64/include/asm/kvm_hyp.h |  3 ++-
 arch/arm64/kvm/hyp/nvhe/host.S   | 20 ++++++++++----------
 arch/arm64/kvm/hyp/nvhe/switch.c |  3 +--
 3 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index 6b664de5ec1f..183bc9c7e1cb 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -94,7 +94,8 @@ u64 __guest_enter(struct kvm_vcpu *vcpu);
 
 void __noreturn hyp_panic(void);
 #ifdef __KVM_NVHE_HYPERVISOR__
-void __noreturn __hyp_do_panic(bool restore_host, u64 spsr, u64 elr, u64 par);
+void __noreturn __hyp_do_panic(struct kvm_cpu_context *host_ctxt, u64 spsr,
+			       u64 elr, u64 par);
 #endif
 
 #endif /* __ARM64_KVM_HYP_H__ */
diff --git a/arch/arm64/kvm/hyp/nvhe/host.S b/arch/arm64/kvm/hyp/nvhe/host.S
index ed27f06a31ba..4ce934fc1f72 100644
--- a/arch/arm64/kvm/hyp/nvhe/host.S
+++ b/arch/arm64/kvm/hyp/nvhe/host.S
@@ -64,10 +64,15 @@ __host_enter_without_restoring:
 SYM_FUNC_END(__host_exit)
 
 /*
- * void __noreturn __hyp_do_panic(bool restore_host, u64 spsr, u64 elr, u64 par);
+ * void __noreturn __hyp_do_panic(struct kvm_cpu_context *host_ctxt, u64 spsr,
+ * 				  u64 elr, u64 par);
  */
 SYM_FUNC_START(__hyp_do_panic)
-	/* Load the format arguments into x1-7 */
+	mov	x29, x0
+
+	/* Load the format string into x0 and arguments into x1-7 */
+	ldr	x0, =__hyp_panic_string
+
 	mov	x6, x3
 	get_vcpu_ptr x7, x3
 
@@ -82,13 +87,8 @@ SYM_FUNC_START(__hyp_do_panic)
 	ldr	lr, =panic
 	msr	elr_el2, lr
 
-	/*
-	 * Set the panic format string and enter the host, conditionally
-	 * restoring the host context.
-	 */
-	cmp	x0, xzr
-	ldr	x0, =__hyp_panic_string
-	b.eq	__host_enter_without_restoring
+	/* Enter the host, conditionally restoring the host context. */
+	cbz	x29, __host_enter_without_restoring
 	b	__host_enter_for_panic
 SYM_FUNC_END(__hyp_do_panic)
 
@@ -144,7 +144,7 @@ SYM_FUNC_END(__hyp_do_panic)
 
 .macro invalid_host_el1_vect
 	.align 7
-	mov	x0, xzr		/* restore_host = false */
+	mov	x0, xzr		/* host_ctxt = NULL */
 	mrs	x1, spsr_el2
 	mrs	x2, elr_el2
 	mrs	x3, par_el1
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 8ae8160bc93a..1b16a3457e2b 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -251,7 +251,6 @@ void __noreturn hyp_panic(void)
 	u64 spsr = read_sysreg_el2(SYS_SPSR);
 	u64 elr = read_sysreg_el2(SYS_ELR);
 	u64 par = read_sysreg_par();
-	bool restore_host = true;
 	struct kvm_cpu_context *host_ctxt;
 	struct kvm_vcpu *vcpu;
 
@@ -265,7 +264,7 @@ void __noreturn hyp_panic(void)
 		__sysreg_restore_state_nvhe(host_ctxt);
 	}
 
-	__hyp_do_panic(restore_host, spsr, elr, par);
+	__hyp_do_panic(host_ctxt, spsr, elr, par);
 	unreachable();
 }
 
-- 
2.31.0.rc2.261.g7f71774620-goog

