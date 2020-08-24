Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6485C24FAC8
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 11:59:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726986AbgHXJ7w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 05:59:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:40202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726878AbgHXIdA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 04:33:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 98762207DF;
        Mon, 24 Aug 2020 08:32:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598257977;
        bh=q7ovJEESpMS9fL3yuRScjYX4gV5PCOccEWwYhFe/NaE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GxYL6tfwb6wR7q0HU8MBmJlLJbWHvgUNzkgIS9gA/tkF84Ps8sm1YSWo8mQH5y79U
         BjAT1h9IrgkIi8U8iHo3nwSiVamwXs2SgN4TZXgprhiXc1VFaioO8JuTAQqA76pQlr
         PINBfrpgTajQJh8whsIN6EFbuFsWJhJWPGTTk+YE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        James Morse <james.morse@arm.com>,
        Will Deacon <will@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.8 029/148] KVM: Pass MMU notifier range flags to kvm_unmap_hva_range()
Date:   Mon, 24 Aug 2020 10:28:47 +0200
Message-Id: <20200824082415.348353053@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200824082413.900489417@linuxfoundation.org>
References: <20200824082413.900489417@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Will Deacon <will@kernel.org>

commit fdfe7cbd58806522e799e2a50a15aee7f2cbb7b6 upstream.

The 'flags' field of 'struct mmu_notifier_range' is used to indicate
whether invalidate_range_{start,end}() are permitted to block. In the
case of kvm_mmu_notifier_invalidate_range_start(), this field is not
forwarded on to the architecture-specific implementation of
kvm_unmap_hva_range() and therefore the backend cannot sensibly decide
whether or not to block.

Add an extra 'flags' parameter to kvm_unmap_hva_range() so that
architectures are aware as to whether or not they are permitted to block.

Cc: <stable@vger.kernel.org>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: James Morse <james.morse@arm.com>
Signed-off-by: Will Deacon <will@kernel.org>
Message-Id: <20200811102725.7121-2-will@kernel.org>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/include/asm/kvm_host.h   |    2 +-
 arch/arm64/kvm/mmu.c                |    2 +-
 arch/mips/include/asm/kvm_host.h    |    2 +-
 arch/mips/kvm/mmu.c                 |    3 ++-
 arch/powerpc/include/asm/kvm_host.h |    3 ++-
 arch/powerpc/kvm/book3s.c           |    3 ++-
 arch/powerpc/kvm/e500_mmu_host.c    |    3 ++-
 arch/x86/include/asm/kvm_host.h     |    3 ++-
 arch/x86/kvm/mmu/mmu.c              |    3 ++-
 virt/kvm/kvm_main.c                 |    3 ++-
 10 files changed, 17 insertions(+), 10 deletions(-)

--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -443,7 +443,7 @@ int __kvm_arm_vcpu_set_events(struct kvm
 
 #define KVM_ARCH_WANT_MMU_NOTIFIER
 int kvm_unmap_hva_range(struct kvm *kvm,
-			unsigned long start, unsigned long end);
+			unsigned long start, unsigned long end, unsigned flags);
 int kvm_set_spte_hva(struct kvm *kvm, unsigned long hva, pte_t pte);
 int kvm_age_hva(struct kvm *kvm, unsigned long start, unsigned long end);
 int kvm_test_age_hva(struct kvm *kvm, unsigned long hva);
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -2203,7 +2203,7 @@ static int kvm_unmap_hva_handler(struct
 }
 
 int kvm_unmap_hva_range(struct kvm *kvm,
-			unsigned long start, unsigned long end)
+			unsigned long start, unsigned long end, unsigned flags)
 {
 	if (!kvm->arch.pgd)
 		return 0;
--- a/arch/mips/include/asm/kvm_host.h
+++ b/arch/mips/include/asm/kvm_host.h
@@ -981,7 +981,7 @@ enum kvm_mips_fault_result kvm_trap_emul
 
 #define KVM_ARCH_WANT_MMU_NOTIFIER
 int kvm_unmap_hva_range(struct kvm *kvm,
-			unsigned long start, unsigned long end);
+			unsigned long start, unsigned long end, unsigned flags);
 int kvm_set_spte_hva(struct kvm *kvm, unsigned long hva, pte_t pte);
 int kvm_age_hva(struct kvm *kvm, unsigned long start, unsigned long end);
 int kvm_test_age_hva(struct kvm *kvm, unsigned long hva);
--- a/arch/mips/kvm/mmu.c
+++ b/arch/mips/kvm/mmu.c
@@ -518,7 +518,8 @@ static int kvm_unmap_hva_handler(struct
 	return 1;
 }
 
-int kvm_unmap_hva_range(struct kvm *kvm, unsigned long start, unsigned long end)
+int kvm_unmap_hva_range(struct kvm *kvm, unsigned long start, unsigned long end,
+			unsigned flags)
 {
 	handle_hva_to_gpa(kvm, start, end, &kvm_unmap_hva_handler, NULL);
 
--- a/arch/powerpc/include/asm/kvm_host.h
+++ b/arch/powerpc/include/asm/kvm_host.h
@@ -58,7 +58,8 @@
 #define KVM_ARCH_WANT_MMU_NOTIFIER
 
 extern int kvm_unmap_hva_range(struct kvm *kvm,
-			       unsigned long start, unsigned long end);
+			       unsigned long start, unsigned long end,
+			       unsigned flags);
 extern int kvm_age_hva(struct kvm *kvm, unsigned long start, unsigned long end);
 extern int kvm_test_age_hva(struct kvm *kvm, unsigned long hva);
 extern int kvm_set_spte_hva(struct kvm *kvm, unsigned long hva, pte_t pte);
--- a/arch/powerpc/kvm/book3s.c
+++ b/arch/powerpc/kvm/book3s.c
@@ -834,7 +834,8 @@ void kvmppc_core_commit_memory_region(st
 	kvm->arch.kvm_ops->commit_memory_region(kvm, mem, old, new, change);
 }
 
-int kvm_unmap_hva_range(struct kvm *kvm, unsigned long start, unsigned long end)
+int kvm_unmap_hva_range(struct kvm *kvm, unsigned long start, unsigned long end,
+			unsigned flags)
 {
 	return kvm->arch.kvm_ops->unmap_hva_range(kvm, start, end);
 }
--- a/arch/powerpc/kvm/e500_mmu_host.c
+++ b/arch/powerpc/kvm/e500_mmu_host.c
@@ -734,7 +734,8 @@ static int kvm_unmap_hva(struct kvm *kvm
 	return 0;
 }
 
-int kvm_unmap_hva_range(struct kvm *kvm, unsigned long start, unsigned long end)
+int kvm_unmap_hva_range(struct kvm *kvm, unsigned long start, unsigned long end,
+			unsigned flags)
 {
 	/* kvm_unmap_hva flushes everything anyways */
 	kvm_unmap_hva(kvm, start);
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1641,7 +1641,8 @@ asmlinkage void kvm_spurious_fault(void)
 	_ASM_EXTABLE(666b, 667b)
 
 #define KVM_ARCH_WANT_MMU_NOTIFIER
-int kvm_unmap_hva_range(struct kvm *kvm, unsigned long start, unsigned long end);
+int kvm_unmap_hva_range(struct kvm *kvm, unsigned long start, unsigned long end,
+			unsigned flags);
 int kvm_age_hva(struct kvm *kvm, unsigned long start, unsigned long end);
 int kvm_test_age_hva(struct kvm *kvm, unsigned long hva);
 int kvm_set_spte_hva(struct kvm *kvm, unsigned long hva, pte_t pte);
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1971,7 +1971,8 @@ static int kvm_handle_hva(struct kvm *kv
 	return kvm_handle_hva_range(kvm, hva, hva + 1, data, handler);
 }
 
-int kvm_unmap_hva_range(struct kvm *kvm, unsigned long start, unsigned long end)
+int kvm_unmap_hva_range(struct kvm *kvm, unsigned long start, unsigned long end,
+			unsigned flags)
 {
 	return kvm_handle_hva_range(kvm, start, end, 0, kvm_unmap_rmapp);
 }
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -427,7 +427,8 @@ static int kvm_mmu_notifier_invalidate_r
 	 * count is also read inside the mmu_lock critical section.
 	 */
 	kvm->mmu_notifier_count++;
-	need_tlb_flush = kvm_unmap_hva_range(kvm, range->start, range->end);
+	need_tlb_flush = kvm_unmap_hva_range(kvm, range->start, range->end,
+					     range->flags);
 	need_tlb_flush |= kvm->tlbs_dirty;
 	/* we've to flush the tlb before the pages can be freed */
 	if (need_tlb_flush)


