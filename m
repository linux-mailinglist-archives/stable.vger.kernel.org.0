Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28868383836
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:51:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240192AbhEQPus (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:50:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:33864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244769AbhEQPrp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:47:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4E7F461D3D;
        Mon, 17 May 2021 14:44:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621262683;
        bh=ZX2D0TRxrlnnplpK86QgzllrXGhrjlj9rhwj+yGCWSE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lMuq6JVSkkQ0k7xBJSM22De9Gp8duEiRxf0sCy3Cdead/ly+fgxLlk0ossmDA0AOP
         vX363/mibu4dNg9riYiV/y1RppSj/PJBxu76FlTGmApNh/rwKjy39uDi6mMDnQ1aJJ
         6UsLlQ1M7rPU6Apqbs7+mE33HyW0xE11NqH1aDUw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.10 260/289] KVM: VMX: Disable preemption when probing user return MSRs
Date:   Mon, 17 May 2021 16:03:05 +0200
Message-Id: <20210517140313.898967357@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140305.140529752@linuxfoundation.org>
References: <20210517140305.140529752@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

commit 5104d7ffcf24749939bea7fdb5378d186473f890 upstream.

Disable preemption when probing a user return MSR via RDSMR/WRMSR.  If
the MSR holds a different value per logical CPU, the WRMSR could corrupt
the host's value if KVM is preempted between the RDMSR and WRMSR, and
then rescheduled on a different CPU.

Opportunistically land the helper in common x86, SVM will use the helper
in a future commit.

Fixes: 4be534102624 ("KVM: VMX: Initialize vmx->guest_msrs[] right after allocation")
Cc: stable@vger.kernel.org
Cc: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20210504171734.1434054-6-seanjc@google.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/kvm_host.h |    1 +
 arch/x86/kvm/vmx/vmx.c          |    5 +----
 arch/x86/kvm/x86.c              |   16 ++++++++++++++++
 3 files changed, 18 insertions(+), 4 deletions(-)

--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1668,6 +1668,7 @@ int kvm_pv_send_ipi(struct kvm *kvm, uns
 		    unsigned long icr, int op_64_bit);
 
 void kvm_define_user_return_msr(unsigned index, u32 msr);
+int kvm_probe_user_return_msr(u32 msr);
 int kvm_set_user_return_msr(unsigned index, u64 val, u64 mask);
 
 u64 kvm_scale_tsc(struct kvm_vcpu *vcpu, u64 tsc);
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6864,12 +6864,9 @@ static int vmx_create_vcpu(struct kvm_vc
 
 	for (i = 0; i < ARRAY_SIZE(vmx_uret_msrs_list); ++i) {
 		u32 index = vmx_uret_msrs_list[i];
-		u32 data_low, data_high;
 		int j = vmx->nr_uret_msrs;
 
-		if (rdmsr_safe(index, &data_low, &data_high) < 0)
-			continue;
-		if (wrmsr_safe(index, data_low, data_high) < 0)
+		if (kvm_probe_user_return_msr(index))
 			continue;
 
 		vmx->guest_uret_msrs[j].slot = i;
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -322,6 +322,22 @@ static void kvm_on_user_return(struct us
 	}
 }
 
+int kvm_probe_user_return_msr(u32 msr)
+{
+	u64 val;
+	int ret;
+
+	preempt_disable();
+	ret = rdmsrl_safe(msr, &val);
+	if (ret)
+		goto out;
+	ret = wrmsrl_safe(msr, val);
+out:
+	preempt_enable();
+	return ret;
+}
+EXPORT_SYMBOL_GPL(kvm_probe_user_return_msr);
+
 void kvm_define_user_return_msr(unsigned slot, u32 msr)
 {
 	BUG_ON(slot >= KVM_MAX_NR_USER_RETURN_MSRS);


