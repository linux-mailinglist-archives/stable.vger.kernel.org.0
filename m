Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C46703C4C26
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:38:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242673AbhGLHB5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:01:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:56792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239655AbhGLG64 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:58:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6D554611C2;
        Mon, 12 Jul 2021 06:56:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626072969;
        bh=7HmrN5tN4VMxSuLZoByndgYAtP2ImpnstlzNDv+oe5I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UaD4YViPb/GWHrfvEhfq98ry26bZDr81fxsPVl2VcILKwKWlvQjFAkShYFoO5KZPW
         YmlM5i94qQMFdpJLBbjjTaBfeoIBb6jOpit5Dl6PaYauh8AjeYDzViHHUKQxvv41e/
         AZL3HT+nmghqFxfpzweZugxMbK7038P3Y7B2uXo0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yu Zhang <yu.c.zhang@linux.intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.12 075/700] KVM: x86: Force all MMUs to reinitialize if guest CPUID is modified
Date:   Mon, 12 Jul 2021 08:02:38 +0200
Message-Id: <20210712060935.311122049@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

commit 49c6f8756cdffeb9af1fbcb86bacacced26465d7 upstream.

Invalidate all MMUs' roles after a CPUID update to force reinitizliation
of the MMU context/helpers.  Despite the efforts of commit de3ccd26fafc
("KVM: MMU: record maximum physical address width in kvm_mmu_extended_role"),
there are still a handful of CPUID-based properties that affect MMU
behavior but are not incorporated into mmu_role.  E.g. 1gb hugepage
support, AMD vs. Intel handling of bit 8, and SEV's C-Bit location all
factor into the guest's reserved PTE bits.

The obvious alternative would be to add all such properties to mmu_role,
but doing so provides no benefit over simply forcing a reinitialization
on every CPUID update, as setting guest CPUID is a rare operation.

Note, reinitializing all MMUs after a CPUID update does not fix all of
KVM's woes.  Specifically, kvm_mmu_page_role doesn't track the CPUID
properties, which means that a vCPU can reuse shadow pages that should
not exist for the new vCPU model, e.g. that map GPAs that are now illegal
(due to MAXPHYADDR changes) or that set bits that are now reserved
(PAGE_SIZE for 1gb pages), etc...

Tracking the relevant CPUID properties in kvm_mmu_page_role would address
the majority of problems, but fully tracking that much state in the
shadow page role comes with an unpalatable cost as it would require a
non-trivial increase in KVM's memory footprint.  The GBPAGES case is even
worse, as neither Intel nor AMD provides a way to disable 1gb hugepage
support in the hardware page walker, i.e. it's a virtualization hole that
can't be closed when using TDP.

In other words, resetting the MMU after a CPUID update is largely a
superficial fix.  But, it will allow reverting the tracking of MAXPHYADDR
in the mmu_role, and that case in particular needs to mostly work because
KVM's shadow_root_level depends on guest MAXPHYADDR when 5-level paging
is supported.  For cases where KVM botches guest behavior, the damage is
limited to that guest.  But for the shadow_root_level, a misconfigured
MMU can cause KVM to incorrectly access memory, e.g. due to walking off
the end of its shadow page tables.

Fixes: 7dcd57552008 ("x86/kvm/mmu: check if tdp/shadow MMU reconfiguration is needed")
Cc: Yu Zhang <yu.c.zhang@linux.intel.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20210622175739.3610207-7-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/include/asm/kvm_host.h |    1 +
 arch/x86/kvm/cpuid.c            |    6 +++---
 arch/x86/kvm/mmu/mmu.c          |   12 ++++++++++++
 3 files changed, 16 insertions(+), 3 deletions(-)

--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1433,6 +1433,7 @@ void kvm_mmu_set_mask_ptes(u64 user_mask
 		u64 dirty_mask, u64 nx_mask, u64 x_mask, u64 p_mask,
 		u64 acc_track_mask, u64 me_mask);
 
+void kvm_mmu_after_set_cpuid(struct kvm_vcpu *vcpu);
 void kvm_mmu_reset_context(struct kvm_vcpu *vcpu);
 void kvm_mmu_slot_remove_write_access(struct kvm *kvm,
 				      struct kvm_memory_slot *memslot,
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -185,10 +185,10 @@ static void kvm_vcpu_after_set_cpuid(str
 	static_call(kvm_x86_vcpu_after_set_cpuid)(vcpu);
 
 	/*
-	 * Except for the MMU, which needs to be reset after any vendor
-	 * specific adjustments to the reserved GPA bits.
+	 * Except for the MMU, which needs to do its thing any vendor specific
+	 * adjustments to the reserved GPA bits.
 	 */
-	kvm_mmu_reset_context(vcpu);
+	kvm_mmu_after_set_cpuid(vcpu);
 }
 
 static int is_efer_nx(void)
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4846,6 +4846,18 @@ kvm_mmu_calc_root_page_role(struct kvm_v
 	return role.base;
 }
 
+void kvm_mmu_after_set_cpuid(struct kvm_vcpu *vcpu)
+{
+	/*
+	 * Invalidate all MMU roles to force them to reinitialize as CPUID
+	 * information is factored into reserved bit calculations.
+	 */
+	vcpu->arch.root_mmu.mmu_role.ext.valid = 0;
+	vcpu->arch.guest_mmu.mmu_role.ext.valid = 0;
+	vcpu->arch.nested_mmu.mmu_role.ext.valid = 0;
+	kvm_mmu_reset_context(vcpu);
+}
+
 void kvm_mmu_reset_context(struct kvm_vcpu *vcpu)
 {
 	kvm_mmu_unload(vcpu);


