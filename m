Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDA292F6CB
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 07:00:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727580AbfE3DJ3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:09:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:44120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727563AbfE3DJ2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:09:28 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CC14124480;
        Thu, 30 May 2019 03:09:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185767;
        bh=JPsMg2qdVebugYbJg/LHRwLUiu4TwnK5mJDChYZwLVc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0MdrbZCNIg3zBAr/rJ3+8luS3K3s8F9+QAI8bXg7dOIAoR5IXo92NTlD6bfPH3CVk
         pW1WeuQs3rVj170paeEmYXeAbnR7QdFo63vsQLgmi8NgVZ4pXQ+jD5LerNvDTiSgtr
         hAOTxOul0yAt1yPtCU0xFtGE8dp25mEmgQLMsJCM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH 5.1 017/405] KVM: nVMX: Fix using __this_cpu_read() in preemptible context
Date:   Wed, 29 May 2019 20:00:15 -0700
Message-Id: <20190530030541.409293451@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.291644921@linuxfoundation.org>
References: <20190530030540.291644921@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

commit 541e886f7972cc647804dbb4909189e67987a945 upstream.

 BUG: using __this_cpu_read() in preemptible [00000000] code: qemu-system-x86/4590
  caller is nested_vmx_enter_non_root_mode+0xebd/0x1790 [kvm_intel]
  CPU: 4 PID: 4590 Comm: qemu-system-x86 Tainted: G           OE     5.1.0-rc4+ #1
  Call Trace:
   dump_stack+0x67/0x95
   __this_cpu_preempt_check+0xd2/0xe0
   nested_vmx_enter_non_root_mode+0xebd/0x1790 [kvm_intel]
   nested_vmx_run+0xda/0x2b0 [kvm_intel]
   handle_vmlaunch+0x13/0x20 [kvm_intel]
   vmx_handle_exit+0xbd/0x660 [kvm_intel]
   kvm_arch_vcpu_ioctl_run+0xa2c/0x1e50 [kvm]
   kvm_vcpu_ioctl+0x3ad/0x6d0 [kvm]
   do_vfs_ioctl+0xa5/0x6e0
   ksys_ioctl+0x6d/0x80
   __x64_sys_ioctl+0x1a/0x20
   do_syscall_64+0x6f/0x6c0
   entry_SYSCALL_64_after_hwframe+0x49/0xbe

Accessing per-cpu variable should disable preemption, this patch extends the
preemption disable region for __this_cpu_read().

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Radim Krčmář <rkrcmar@redhat.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
Fixes: 52017608da33 ("KVM: nVMX: add option to perform early consistency checks via H/W")
Cc: stable@vger.kernel.org
Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/vmx/nested.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2792,14 +2792,13 @@ static int nested_vmx_check_vmentry_hw(s
 	      : "cc", "memory"
 	);
 
-	preempt_enable();
-
 	if (vmx->msr_autoload.host.nr)
 		vmcs_write32(VM_EXIT_MSR_LOAD_COUNT, vmx->msr_autoload.host.nr);
 	if (vmx->msr_autoload.guest.nr)
 		vmcs_write32(VM_ENTRY_MSR_LOAD_COUNT, vmx->msr_autoload.guest.nr);
 
 	if (vm_fail) {
+		preempt_enable();
 		WARN_ON_ONCE(vmcs_read32(VM_INSTRUCTION_ERROR) !=
 			     VMXERR_ENTRY_INVALID_CONTROL_FIELD);
 		return 1;
@@ -2811,6 +2810,7 @@ static int nested_vmx_check_vmentry_hw(s
 	local_irq_enable();
 	if (hw_breakpoint_active())
 		set_debugreg(__this_cpu_read(cpu_dr7), 7);
+	preempt_enable();
 
 	/*
 	 * A non-failing VMEntry means we somehow entered guest mode with


