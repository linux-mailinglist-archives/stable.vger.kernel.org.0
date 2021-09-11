Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 241434076EF
	for <lists+stable@lfdr.de>; Sat, 11 Sep 2021 15:13:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236119AbhIKNN1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Sep 2021 09:13:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:37246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236022AbhIKNNU (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Sep 2021 09:13:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6E03D61205;
        Sat, 11 Sep 2021 13:12:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631365928;
        bh=BvUepuoep7XTWaVhs83x1LXOtgm9K1UWGy0biRI2gO4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c6WJG379Oebp2jZvOHCPoW3E6rsvz/rzxrLPI061XzuOR71/4i9V2QYVEElpvcPIB
         n0CGum/BcQGQ7BFHmFBd1uulwA//eVHBkQvpceOj+oqLT9c+BIEt0mkWh03nNNIq/1
         pJxiQ+itEcLLJDT/b2QFdNghFgk6yAOgCwjyZppVSoA57aNpCuWD4ctMIeTCJN7+vP
         kmk8EAzOPt1aF8DDqLBPRL72XCdTyNztmkH2OPIXK7YjMBjzGkteiQ3IZuWyQfwToa
         bVpxeDjpPozMEsh8DZzZDeRdoIYhUM9vPQZGPDrt2QGBGDOsLoPLn9C8OHL7ElqZS6
         6jZM1bwnjHRKA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Will Deacon <will@kernel.org>, Andrew Scull <ascull@google.com>,
        Quentin Perret <qperret@google.com>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Subject: [PATCH AUTOSEL 5.14 13/32] KVM: arm64: Make hyp_panic() more robust when protected mode is enabled
Date:   Sat, 11 Sep 2021 09:11:30 -0400
Message-Id: <20210911131149.284397-13-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210911131149.284397-1-sashal@kernel.org>
References: <20210911131149.284397-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Will Deacon <will@kernel.org>

[ Upstream commit ccac96977243d7916053550f62e6489760ad0adc ]

When protected mode is enabled, the host is unable to access most parts
of the EL2 hypervisor image, including 'hyp_physvirt_offset' and the
contents of the hypervisor's '.rodata.str' section. Unfortunately,
nvhe_hyp_panic_handler() tries to read from both of these locations when
handling a BUG() triggered at EL2; the former for converting the ELR to
a physical address and the latter for displaying the name of the source
file where the BUG() occurred.

Hack the EL2 panic asm to pass both physical and virtual ELR values to
the host and utilise the newly introduced CONFIG_NVHE_EL2_DEBUG so that
we disable stage-2 protection for the host before returning to the EL1
panic handler. If the debug option is not enabled, display the address
instead of the source file:line information.

Cc: Andrew Scull <ascull@google.com>
Cc: Quentin Perret <qperret@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20210813130336.8139-1-will@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kvm/handle_exit.c   | 23 ++++++++++++++---------
 arch/arm64/kvm/hyp/nvhe/host.S | 21 +++++++++++++++++----
 2 files changed, 31 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index 6f48336b1d86..04ebab299aa4 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -292,11 +292,12 @@ void handle_exit_early(struct kvm_vcpu *vcpu, int exception_index)
 		kvm_handle_guest_serror(vcpu, kvm_vcpu_get_esr(vcpu));
 }
 
-void __noreturn __cold nvhe_hyp_panic_handler(u64 esr, u64 spsr, u64 elr,
+void __noreturn __cold nvhe_hyp_panic_handler(u64 esr, u64 spsr,
+					      u64 elr_virt, u64 elr_phys,
 					      u64 par, uintptr_t vcpu,
 					      u64 far, u64 hpfar) {
-	u64 elr_in_kimg = __phys_to_kimg(__hyp_pa(elr));
-	u64 hyp_offset = elr_in_kimg - kaslr_offset() - elr;
+	u64 elr_in_kimg = __phys_to_kimg(elr_phys);
+	u64 hyp_offset = elr_in_kimg - kaslr_offset() - elr_virt;
 	u64 mode = spsr & PSR_MODE_MASK;
 
 	/*
@@ -309,20 +310,24 @@ void __noreturn __cold nvhe_hyp_panic_handler(u64 esr, u64 spsr, u64 elr,
 		kvm_err("Invalid host exception to nVHE hyp!\n");
 	} else if (ESR_ELx_EC(esr) == ESR_ELx_EC_BRK64 &&
 		   (esr & ESR_ELx_BRK64_ISS_COMMENT_MASK) == BUG_BRK_IMM) {
-		struct bug_entry *bug = find_bug(elr_in_kimg);
 		const char *file = NULL;
 		unsigned int line = 0;
 
 		/* All hyp bugs, including warnings, are treated as fatal. */
-		if (bug)
-			bug_get_file_line(bug, &file, &line);
+		if (!is_protected_kvm_enabled() ||
+		    IS_ENABLED(CONFIG_NVHE_EL2_DEBUG)) {
+			struct bug_entry *bug = find_bug(elr_in_kimg);
+
+			if (bug)
+				bug_get_file_line(bug, &file, &line);
+		}
 
 		if (file)
 			kvm_err("nVHE hyp BUG at: %s:%u!\n", file, line);
 		else
-			kvm_err("nVHE hyp BUG at: %016llx!\n", elr + hyp_offset);
+			kvm_err("nVHE hyp BUG at: %016llx!\n", elr_virt + hyp_offset);
 	} else {
-		kvm_err("nVHE hyp panic at: %016llx!\n", elr + hyp_offset);
+		kvm_err("nVHE hyp panic at: %016llx!\n", elr_virt + hyp_offset);
 	}
 
 	/*
@@ -334,5 +339,5 @@ void __noreturn __cold nvhe_hyp_panic_handler(u64 esr, u64 spsr, u64 elr,
 	kvm_err("Hyp Offset: 0x%llx\n", hyp_offset);
 
 	panic("HYP panic:\nPS:%08llx PC:%016llx ESR:%08llx\nFAR:%016llx HPFAR:%016llx PAR:%016llx\nVCPU:%016lx\n",
-	      spsr, elr, esr, far, hpfar, par, vcpu);
+	      spsr, elr_virt, esr, far, hpfar, par, vcpu);
 }
diff --git a/arch/arm64/kvm/hyp/nvhe/host.S b/arch/arm64/kvm/hyp/nvhe/host.S
index 2b23400e0fb3..4b652ffb591d 100644
--- a/arch/arm64/kvm/hyp/nvhe/host.S
+++ b/arch/arm64/kvm/hyp/nvhe/host.S
@@ -7,6 +7,7 @@
 #include <linux/linkage.h>
 
 #include <asm/assembler.h>
+#include <asm/kvm_arm.h>
 #include <asm/kvm_asm.h>
 #include <asm/kvm_mmu.h>
 
@@ -85,12 +86,24 @@ SYM_FUNC_START(__hyp_do_panic)
 
 	mov	x29, x0
 
+#ifdef CONFIG_NVHE_EL2_DEBUG
+	/* Ensure host stage-2 is disabled */
+	mrs	x0, hcr_el2
+	bic	x0, x0, #HCR_VM
+	msr	hcr_el2, x0
+	isb
+	tlbi	vmalls12e1
+	dsb	nsh
+#endif
+
 	/* Load the panic arguments into x0-7 */
 	mrs	x0, esr_el2
-	get_vcpu_ptr x4, x5
-	mrs	x5, far_el2
-	mrs	x6, hpfar_el2
-	mov	x7, xzr			// Unused argument
+	mov	x4, x3
+	mov	x3, x2
+	hyp_pa	x3, x6
+	get_vcpu_ptr x5, x6
+	mrs	x6, far_el2
+	mrs	x7, hpfar_el2
 
 	/* Enter the host, conditionally restoring the host context. */
 	cbz	x29, __host_enter_without_restoring
-- 
2.30.2

