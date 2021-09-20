Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C2FB4125D4
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:49:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384679AbhITSsf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:48:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:59876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1384101AbhITSqd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:46:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E4E0A63363;
        Mon, 20 Sep 2021 17:33:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632159222;
        bh=BvUepuoep7XTWaVhs83x1LXOtgm9K1UWGy0biRI2gO4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U7Y/YCEVjx5wJPuXyAp1x3uzChBur+IZEi1rd9jXymj9IKlbpJen2GdCP6pl4qjLj
         rb+PwpIEV1/BtUde6E2FR9f9ZEI6jPrlWLchgRdp+00Q3siZ/GzbuByQjtJ+mqFbkA
         jfKbFl+j9QA54zJmszF5JXM6S1yNQR1BSUHi0MJk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrew Scull <ascull@google.com>,
        Quentin Perret <qperret@google.com>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 101/168] KVM: arm64: Make hyp_panic() more robust when protected mode is enabled
Date:   Mon, 20 Sep 2021 18:43:59 +0200
Message-Id: <20210920163924.960132609@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163921.633181900@linuxfoundation.org>
References: <20210920163921.633181900@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



