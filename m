Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EF393832A0
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:50:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240372AbhEQOuO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:50:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:37902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240509AbhEQOr7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:47:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CD5B06196C;
        Mon, 17 May 2021 14:22:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621261325;
        bh=bhkuDGn9CSoZ0F+cT7Z7/si1jIFFiEWhKkLCK9J1VPg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tKpwbPJEp+GtquGN+NsxDBOmKmUBF4YSdAAR2zeFhcddwsDVRYurTlxQSd9tDTnY6
         8YORp7AnVFNbVbbPRSqQQtU2w6EOgGss5x4WB03eXjDJfJVZn/4ZSiG3AXgnGzB03w
         vknAMszHZK0BmpVZo5Mq9QVyTs87Kk8+AvlwuS1M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.12 334/363] KVM: VMX: Disable preemption when probing user return MSRs
Date:   Mon, 17 May 2021 16:03:20 +0200
Message-Id: <20210517140313.896477790@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.508966430@linuxfoundation.org>
References: <20210517140302.508966430@linuxfoundation.org>
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
@@ -1753,6 +1753,7 @@ int kvm_pv_send_ipi(struct kvm *kvm, uns
 		    unsigned long icr, int op_64_bit);
 
 void kvm_define_user_return_msr(unsigned index, u32 msr);
+int kvm_probe_user_return_msr(u32 msr);
 int kvm_set_user_return_msr(unsigned index, u64 val, u64 mask);
 
 u64 kvm_scale_tsc(struct kvm_vcpu *vcpu, u64 tsc);
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6914,12 +6914,9 @@ static int vmx_create_vcpu(struct kvm_vc
 
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
@@ -335,6 +335,22 @@ static void kvm_on_user_return(struct us
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


