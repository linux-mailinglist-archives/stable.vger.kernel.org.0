Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1F6A3BBBD6
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 13:00:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231384AbhGELCo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 07:02:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:47808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231423AbhGELCl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Jul 2021 07:02:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4D524613B9;
        Mon,  5 Jul 2021 11:00:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625482804;
        bh=gHzhlrPdDQYZBieAeCVMxDDHj9FG8oaiRb+o7TjASDc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hnVLz+YN78xfiVn4d+16+GBytpmCBlN5bHPkkZaOqSIRvfR/U3c7E9gy5qrV+as9+
         rqDcO49Nd7gYVt+Q+ILC2te8713Zq4lYmdpVcQolwXzto8f5siCKicBHA/U1S4U5Ao
         ZuTnE+L8X+JOwbER3KxzIlVzFkubVORchqGa5xhEmpkMoqZzvodYlc4PeZ+N8A1Kcu
         RjK2jfR0RvSqgi3Dj7deROAl5Pm94iHPahYwepGBbdZ6zzhSoOTr7IGWZeCgJDImKU
         +p7YCbeX5SgkQGrkXu72oe/b0ZjCt/qKbELfI9SQ77QQzqa7KiaXgEHPLYzRPoEtZO
         kuy/mNFg1utRw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.10 6/7] Revert "KVM: x86/mmu: Drop kvm_mmu_extended_role.cr4_la57 hack"
Date:   Mon,  5 Jul 2021 06:59:56 -0400
Message-Id: <20210705105957.1513284-7-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210705105957.1513284-1-sashal@kernel.org>
References: <20210705105957.1513284-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.48-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.48-rc1
X-KernelTest-Deadline: 2021-07-07T10:59+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

commit f71a53d1180d5ecc346f0c6a23191d837fe2871b upstream.

Restore CR4.LA57 to the mmu_role to fix an amusing edge case with nested
virtualization.  When KVM (L0) is using TDP, CR4.LA57 is not reflected in
mmu_role.base.level because that tracks the shadow root level, i.e. TDP
level.  Normally, this is not an issue because LA57 can't be toggled
while long mode is active, i.e. the guest has to first disable paging,
then toggle LA57, then re-enable paging, thus ensuring an MMU
reinitialization.

But if L1 is crafty, it can load a new CR4 on VM-Exit and toggle LA57
without having to bounce through an unpaged section.  L1 can also load a
new CR3 on exit, i.e. it doesn't even need to play crazy paging games, a
single entry PML5 is sufficient.  Such shenanigans are only problematic
if L0 and L1 use TDP, otherwise L1 and L2 share an MMU that gets
reinitialized on nested VM-Enter/VM-Exit due to mmu_role.base.guest_mode.

Note, in the L2 case with nested TDP, even though L1 can switch between
L2s with different LA57 settings, thus bypassing the paging requirement,
in that case KVM's nested_mmu will track LA57 in base.level.

This reverts commit 8053f924cad30bf9f9a24e02b6c8ddfabf5202ea.

Fixes: 8053f924cad3 ("KVM: x86/mmu: Drop kvm_mmu_extended_role.cr4_la57 hack")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20210622175739.3610207-6-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/kvm_host.h | 1 +
 arch/x86/kvm/mmu/mmu.c          | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index ef56780022c3..d1ac2de41ea8 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -296,6 +296,7 @@ union kvm_mmu_extended_role {
 		unsigned int cr4_pke:1;
 		unsigned int cr4_smap:1;
 		unsigned int cr4_smep:1;
+		unsigned int cr4_la57:1;
 		unsigned int maxphyaddr:6;
 	};
 };
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 6b794344c02d..f2eeaf197294 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4442,6 +4442,7 @@ static union kvm_mmu_extended_role kvm_calc_mmu_role_ext(struct kvm_vcpu *vcpu)
 	ext.cr4_smap = !!kvm_read_cr4_bits(vcpu, X86_CR4_SMAP);
 	ext.cr4_pse = !!is_pse(vcpu);
 	ext.cr4_pke = !!kvm_read_cr4_bits(vcpu, X86_CR4_PKE);
+	ext.cr4_la57 = !!kvm_read_cr4_bits(vcpu, X86_CR4_LA57);
 	ext.maxphyaddr = cpuid_maxphyaddr(vcpu);
 
 	ext.valid = 1;
-- 
2.30.2

