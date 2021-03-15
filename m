Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53F5633B26E
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 13:22:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229636AbhCOMWG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 08:22:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbhCOMV5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Mar 2021 08:21:57 -0400
Received: from mail-wr1-x449.google.com (mail-wr1-x449.google.com [IPv6:2a00:1450:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAE4DC061574
        for <stable@vger.kernel.org>; Mon, 15 Mar 2021 05:21:56 -0700 (PDT)
Received: by mail-wr1-x449.google.com with SMTP id h5so14978870wrr.17
        for <stable@vger.kernel.org>; Mon, 15 Mar 2021 05:21:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=rWGHkQq4CRrUt+Oq/fI3HH/oNurXWdCCzpIoEn9t8do=;
        b=u4PtRZRvqvHXmKXvdHZye7vbc0gPFgjiMAS5YHeyfe0v+wdt8PIUqok1c7LIHKk/xu
         wNip/k1M0ttzYMa6AgXAspCsVSrzb9K4xBxk4Z0ToeTO260FgnJF1ufq0TVGUf/gUa8p
         p2S7jTL37pwjDc3ntUQoPdgegA4s/0X1/5CvMGXNTFTzxoZlzx1IYgi2lWanBhcP4X85
         1xO6QJDk3sdX7hUbK/hr0UWUBRygdtSn/YC6Ut0KkYBpz3fidTF9DbFsWtwp752CzbGi
         Hhis1bakRGkt7+4ZFvh49kfI87qxKDw/Ut0Sjn08Z11ifwrn8skNvDaErWJTeu+Q8mjT
         Swbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=rWGHkQq4CRrUt+Oq/fI3HH/oNurXWdCCzpIoEn9t8do=;
        b=KcNoBp3zN7lQIIr5h4Dl66HioKkwIOcrcZ5ybEoKhCgZrE8yCfgyaRS1+wkVfMu9qX
         UP5RVQjG7cMubUVrvje1b6hu3mGi7CDgRL986o57e7YX4GOggvBQK4+eJ4aOmKO12Cav
         Qkb9D1sfpjEQqgNxsMyoGODvl4A+0LabN692mNwdo0q1P4FIZ4GhQ/M8tV2DmmHdPUV5
         ZqAXzpO3xPg0iHH/NOTv0s65gEIPFClERS64Bhwvz9H4bvtvcpMHlXp6d1Oa7FBXby8m
         NPbP+l78jAYZw+lPJMbt67PTx+MKUO0I7X5xWOlz2VAYFuMMdBNofgdMZ2gtJaDh/k4v
         viMg==
X-Gm-Message-State: AOAM532JVIDP4KsGJp6wUxEXI23BwggntJoQdGEv5yfdOMXlOft4zLYz
        oaWNxuchjO+CzmbE7bKb7yB7a2Rh35M=
X-Google-Smtp-Source: ABdhPJy7ZiF4nGEuc1Kdo9S3yPKlqtOccjvtqDjuN/rKVIVZn45Ks8svIp3ww68gBKQIjbUhQxWF6fSF84c=
X-Received: from ascull.c.googlers.com ([fda3:e722:ac3:10:28:9cb1:c0a8:1510])
 (user=ascull job=sendgmr) by 2002:a5d:6144:: with SMTP id y4mr27134912wrt.203.1615810915443;
 Mon, 15 Mar 2021 05:21:55 -0700 (PDT)
Date:   Mon, 15 Mar 2021 12:21:36 +0000
Message-Id: <20210315122136.1687370-1-ascull@google.com>
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
Cc: stable@vger.kernel.org # 5.11.y only
Signed-off-by: Andrew Scull <ascull@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20210219122406.1337626-1-ascull@google.com
---
 arch/arm64/include/asm/kvm_hyp.h |  3 ++-
 arch/arm64/kvm/hyp/nvhe/host.S   | 20 ++++++++++----------
 arch/arm64/kvm/hyp/nvhe/switch.c |  3 +--
 3 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index c0450828378b..fb8404fefd1f 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -97,7 +97,8 @@ bool kvm_host_psci_handler(struct kvm_cpu_context *host_ctxt);
 
 void __noreturn hyp_panic(void);
 #ifdef __KVM_NVHE_HYPERVISOR__
-void __noreturn __hyp_do_panic(bool restore_host, u64 spsr, u64 elr, u64 par);
+void __noreturn __hyp_do_panic(struct kvm_cpu_context *host_ctxt, u64 spsr,
+			       u64 elr, u64 par);
 #endif
 
 #endif /* __ARM64_KVM_HYP_H__ */
diff --git a/arch/arm64/kvm/hyp/nvhe/host.S b/arch/arm64/kvm/hyp/nvhe/host.S
index a820dfdc9c25..3a06085aab6f 100644
--- a/arch/arm64/kvm/hyp/nvhe/host.S
+++ b/arch/arm64/kvm/hyp/nvhe/host.S
@@ -71,10 +71,15 @@ SYM_FUNC_START(__host_enter)
 SYM_FUNC_END(__host_enter)
 
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
 
@@ -89,13 +94,8 @@ SYM_FUNC_START(__hyp_do_panic)
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
 
@@ -150,7 +150,7 @@ SYM_FUNC_END(__hyp_do_panic)
 
 .macro invalid_host_el1_vect
 	.align 7
-	mov	x0, xzr		/* restore_host = false */
+	mov	x0, xzr		/* host_ctxt = NULL */
 	mrs	x1, spsr_el2
 	mrs	x2, elr_el2
 	mrs	x3, par_el1
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index f3d0e9eca56c..038147b7674b 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -257,7 +257,6 @@ void __noreturn hyp_panic(void)
 	u64 spsr = read_sysreg_el2(SYS_SPSR);
 	u64 elr = read_sysreg_el2(SYS_ELR);
 	u64 par = read_sysreg_par();
-	bool restore_host = true;
 	struct kvm_cpu_context *host_ctxt;
 	struct kvm_vcpu *vcpu;
 
@@ -271,7 +270,7 @@ void __noreturn hyp_panic(void)
 		__sysreg_restore_state_nvhe(host_ctxt);
 	}
 
-	__hyp_do_panic(restore_host, spsr, elr, par);
+	__hyp_do_panic(host_ctxt, spsr, elr, par);
 	unreachable();
 }
 
-- 
2.31.0.rc2.261.g7f71774620-goog

