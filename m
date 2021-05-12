Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E71137CB68
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:57:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242675AbhELQf0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:35:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:41044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240746AbhELQZP (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:25:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 520DC619A2;
        Wed, 12 May 2021 15:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834500;
        bh=AeNoU676/hXRF2+0Wo1lmfxJPnt+531zcm+cna2sJ80=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g6nv+17VbpXDWin5SsOs1ioih3JZg3EQhR0WnpUUKDZgfrvKytWVemuXfvSC7rl6I
         Mw5pwpD7URfuICc0j2kd0tudhozJyL9l118X3O5XsQFMKA7CUBQBcjNI+A7Id51SVX
         7Eu9J6Nwh/ytVQo9DcJ2rjYrF92Vk87PEr6Gjmqw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 570/601] KVM: VMX: Intercept FS/GS_BASE MSR accesses for 32-bit KVM
Date:   Wed, 12 May 2021 16:50:47 +0200
Message-Id: <20210512144846.624957172@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit dbdd096a5a74b94f6b786a47baef2085859b0dce ]

Disable pass-through of the FS and GS base MSRs for 32-bit KVM.  Intel's
SDM unequivocally states that the MSRs exist if and only if the CPU
supports x86-64.  FS_BASE and GS_BASE are mostly a non-issue; a clever
guest could opportunistically use the MSRs without issue.  KERNEL_GS_BASE
is a bigger problem, as a clever guest would subtly be broken if it were
migrated, as KVM disallows software access to the MSRs, and unlike the
direct variants, KERNEL_GS_BASE needs to be explicitly migrated as it's
not captured in the VMCS.

Fixes: 25c5f225beda ("KVM: VMX: Enable MSR Bitmap feature")
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20210422023831.3473491-1-seanjc@google.com>
[*NOT* for stable kernels. - Paolo]
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/vmx/nested.c | 2 ++
 arch/x86/kvm/vmx/vmx.c    | 4 ++++
 2 files changed, 6 insertions(+)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 4cf82488622c..0c41ffb7957f 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -618,6 +618,7 @@ static inline bool nested_vmx_prepare_msr_bitmap(struct kvm_vcpu *vcpu,
 	}
 
 	/* KVM unconditionally exposes the FS/GS base MSRs to L1. */
+#ifdef CONFIG_X86_64
 	nested_vmx_disable_intercept_for_msr(msr_bitmap_l1, msr_bitmap_l0,
 					     MSR_FS_BASE, MSR_TYPE_RW);
 
@@ -626,6 +627,7 @@ static inline bool nested_vmx_prepare_msr_bitmap(struct kvm_vcpu *vcpu,
 
 	nested_vmx_disable_intercept_for_msr(msr_bitmap_l1, msr_bitmap_l0,
 					     MSR_KERNEL_GS_BASE, MSR_TYPE_RW);
+#endif
 
 	/*
 	 * Checking the L0->L1 bitmap is trying to verify two things:
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 855c9740d957..852cfb4c063e 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -155,9 +155,11 @@ static u32 vmx_possible_passthrough_msrs[MAX_POSSIBLE_PASSTHROUGH_MSRS] = {
 	MSR_IA32_SPEC_CTRL,
 	MSR_IA32_PRED_CMD,
 	MSR_IA32_TSC,
+#ifdef CONFIG_X86_64
 	MSR_FS_BASE,
 	MSR_GS_BASE,
 	MSR_KERNEL_GS_BASE,
+#endif
 	MSR_IA32_SYSENTER_CS,
 	MSR_IA32_SYSENTER_ESP,
 	MSR_IA32_SYSENTER_EIP,
@@ -6890,9 +6892,11 @@ static int vmx_create_vcpu(struct kvm_vcpu *vcpu)
 	bitmap_fill(vmx->shadow_msr_intercept.write, MAX_POSSIBLE_PASSTHROUGH_MSRS);
 
 	vmx_disable_intercept_for_msr(vcpu, MSR_IA32_TSC, MSR_TYPE_R);
+#ifdef CONFIG_X86_64
 	vmx_disable_intercept_for_msr(vcpu, MSR_FS_BASE, MSR_TYPE_RW);
 	vmx_disable_intercept_for_msr(vcpu, MSR_GS_BASE, MSR_TYPE_RW);
 	vmx_disable_intercept_for_msr(vcpu, MSR_KERNEL_GS_BASE, MSR_TYPE_RW);
+#endif
 	vmx_disable_intercept_for_msr(vcpu, MSR_IA32_SYSENTER_CS, MSR_TYPE_RW);
 	vmx_disable_intercept_for_msr(vcpu, MSR_IA32_SYSENTER_ESP, MSR_TYPE_RW);
 	vmx_disable_intercept_for_msr(vcpu, MSR_IA32_SYSENTER_EIP, MSR_TYPE_RW);
-- 
2.30.2



