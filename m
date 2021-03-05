Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBBE432F33B
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 19:53:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229815AbhCESxY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 13:53:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:58254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229611AbhCESxC (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 13:53:02 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7B183650A1;
        Fri,  5 Mar 2021 18:53:02 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1lIFZM-00HYFA-RT; Fri, 05 Mar 2021 18:53:00 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Andrew Scull <ascull@google.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Howard Zhang <Howard.Zhang@arm.com>,
        Jia He <justin.he@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Quentin Perret <qperret@google.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        kernel-team@android.com, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH 3/8] KVM: arm64: Fix nVHE hyp panic host context restore
Date:   Fri,  5 Mar 2021 18:52:49 +0000
Message-Id: <20210305185254.3730990-4-maz@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210305185254.3730990-1-maz@kernel.org>
References: <87eegtzbch.wl-maz@kernel.org>
 <20210305185254.3730990-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, alexandru.elisei@arm.com, andre.przywara@arm.com, ascull@google.com, catalin.marinas@arm.com, christoffer.dall@arm.com, Howard.Zhang@arm.com, justin.he@arm.com, mark.rutland@arm.com, qperret@google.com, shameerali.kolothum.thodi@huawei.com, suzuki.poulose@arm.com, will@kernel.org, james.morse@arm.com, julien.thierry.kdev@gmail.com, kernel-team@android.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, stable@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrew Scull <ascull@google.com>

When panicking from the nVHE hyp and restoring the host context, x29 is
expected to hold a pointer to the host context. This wasn't being done
so fix it to make sure there's a valid pointer the host context being
used.

Rather than passing a boolean indicating whether or not the host context
should be restored, instead pass the pointer to the host context. NULL
is passed to indicate that no context should be restored.

Fixes: a2e102e20fd6 ("KVM: arm64: nVHE: Handle hyp panics")
Cc: stable@vger.kernel.org
Signed-off-by: Andrew Scull <ascull@google.com>
[maz: partial rewrite to fit 5.12-rc1]
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20210219122406.1337626-1-ascull@google.com
---
 arch/arm64/include/asm/kvm_hyp.h |  3 ++-
 arch/arm64/kvm/hyp/nvhe/host.S   | 15 ++++++++-------
 arch/arm64/kvm/hyp/nvhe/switch.c |  3 +--
 3 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index 385bd7dd3d39..32ae676236b6 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -102,7 +102,8 @@ bool kvm_host_psci_handler(struct kvm_cpu_context *host_ctxt);
 
 void __noreturn hyp_panic(void);
 #ifdef __KVM_NVHE_HYPERVISOR__
-void __noreturn __hyp_do_panic(bool restore_host, u64 spsr, u64 elr, u64 par);
+void __noreturn __hyp_do_panic(struct kvm_cpu_context *host_ctxt, u64 spsr,
+			       u64 elr, u64 par);
 #endif
 
 #endif /* __ARM64_KVM_HYP_H__ */
diff --git a/arch/arm64/kvm/hyp/nvhe/host.S b/arch/arm64/kvm/hyp/nvhe/host.S
index 6585a7cbbc56..5d94584840cc 100644
--- a/arch/arm64/kvm/hyp/nvhe/host.S
+++ b/arch/arm64/kvm/hyp/nvhe/host.S
@@ -71,7 +71,8 @@ SYM_FUNC_START(__host_enter)
 SYM_FUNC_END(__host_enter)
 
 /*
- * void __noreturn __hyp_do_panic(bool restore_host, u64 spsr, u64 elr, u64 par);
+ * void __noreturn __hyp_do_panic(struct kvm_cpu_context *host_ctxt, u64 spsr,
+ * 				  u64 elr, u64 par);
  */
 SYM_FUNC_START(__hyp_do_panic)
 	/* Prepare and exit to the host's panic funciton. */
@@ -82,9 +83,11 @@ SYM_FUNC_START(__hyp_do_panic)
 	hyp_kimg_va lr, x6
 	msr	elr_el2, lr
 
-	/* Set the panic format string. Use the, now free, LR as scratch. */
-	ldr	lr, =__hyp_panic_string
-	hyp_kimg_va lr, x6
+	mov	x29, x0
+
+	/* Load the format string into x0 and arguments into x1-7 */
+	ldr	x0, =__hyp_panic_string
+	hyp_kimg_va x0, x6
 
 	/* Load the format arguments into x1-7. */
 	mov	x6, x3
@@ -94,9 +97,7 @@ SYM_FUNC_START(__hyp_do_panic)
 	mrs	x5, hpfar_el2
 
 	/* Enter the host, conditionally restoring the host context. */
-	cmp	x0, xzr
-	mov	x0, lr
-	b.eq	__host_enter_without_restoring
+	cbz	x29, __host_enter_without_restoring
 	b	__host_enter_for_panic
 SYM_FUNC_END(__hyp_do_panic)
 
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 59aa1045fdaf..68ab6b4d5141 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -266,7 +266,6 @@ void __noreturn hyp_panic(void)
 	u64 spsr = read_sysreg_el2(SYS_SPSR);
 	u64 elr = read_sysreg_el2(SYS_ELR);
 	u64 par = read_sysreg_par();
-	bool restore_host = true;
 	struct kvm_cpu_context *host_ctxt;
 	struct kvm_vcpu *vcpu;
 
@@ -280,7 +279,7 @@ void __noreturn hyp_panic(void)
 		__sysreg_restore_state_nvhe(host_ctxt);
 	}
 
-	__hyp_do_panic(restore_host, spsr, elr, par);
+	__hyp_do_panic(host_ctxt, spsr, elr, par);
 	unreachable();
 }
 
-- 
2.29.2

