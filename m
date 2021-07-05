Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5DFB3BBBC3
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 12:59:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231315AbhGELCU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 07:02:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:47306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231267AbhGELCS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Jul 2021 07:02:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3F8AB61416;
        Mon,  5 Jul 2021 10:59:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625482781;
        bh=B3cEjxFLRtniOauD/HlQ1ByfrWb2iyoh6afswmiNGL4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NlD7pd35qLTEA8E4vUzTdzOM/R2M4QGLjiuDpyIq3THta8o1ZJHmKllHVWdzuiMHB
         umbdws8DwNpZangcSEDR9ZCfALeb9DkJcOEgSBOB7mwWNKh/nS09sWo4eD9TtM7DsV
         Hlb7EqVNfcXr/915xYiF1MsTa9nzZFAkpIMEdydVgwbYsR1+YbeSJ32VuKilif5xXL
         EslgXC6HUp6H46fE7oAzH1wAGoQdtNx1t4ir3kowlO/0i8JrQ3VAxwnXJJDkV0rz8g
         JjG3mVGdcV6W5ydgmWBlBJTqMc1VJFIc1qT5L6eItG2cq+jAOZPLLBStO52jPVCwnQ
         dd8yyGuKLG4rQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.12 6/7] Revert "KVM: x86/mmu: Drop kvm_mmu_extended_role.cr4_la57 hack"
Date:   Mon,  5 Jul 2021 06:59:33 -0400
Message-Id: <20210705105934.1513188-7-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210705105934.1513188-1-sashal@kernel.org>
References: <20210705105934.1513188-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.15-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.12.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.12.15-rc1
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
index eec2dcca2f39..ac7c786fa09f 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -307,6 +307,7 @@ union kvm_mmu_extended_role {
 		unsigned int cr4_pke:1;
 		unsigned int cr4_smap:1;
 		unsigned int cr4_smep:1;
+		unsigned int cr4_la57:1;
 		unsigned int maxphyaddr:6;
 	};
 };
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 676ec0d1e6be..fb2231cf19b5 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4463,6 +4463,7 @@ static union kvm_mmu_extended_role kvm_calc_mmu_role_ext(struct kvm_vcpu *vcpu)
 	ext.cr4_smap = !!kvm_read_cr4_bits(vcpu, X86_CR4_SMAP);
 	ext.cr4_pse = !!is_pse(vcpu);
 	ext.cr4_pke = !!kvm_read_cr4_bits(vcpu, X86_CR4_PKE);
+	ext.cr4_la57 = !!kvm_read_cr4_bits(vcpu, X86_CR4_LA57);
 	ext.maxphyaddr = cpuid_maxphyaddr(vcpu);
 
 	ext.valid = 1;
-- 
2.30.2

