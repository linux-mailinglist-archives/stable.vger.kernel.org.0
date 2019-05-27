Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 869A52B46A
	for <lists+stable@lfdr.de>; Mon, 27 May 2019 14:07:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725943AbfE0MHR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 May 2019 08:07:17 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:48503 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725858AbfE0MHR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 May 2019 08:07:17 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 51F5B577;
        Mon, 27 May 2019 08:07:16 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 27 May 2019 08:07:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=1si1SX
        +hruXc6JZLBRkLnD71q/xoUmMRoIjWVAXHYgA=; b=K4xmLwp6Mpeq/p+UZn6KuY
        aa5lnEDGrdT0SEvT5khuT40vffyFq986wp4m7nJDe2FJgsMsf1fqytts3O9MF6ZX
        wRInn/Ws+FfawHtc0nPo9iRpX+TUDgIqBPlj6xZQs/znM5W7GWaSfbRkqY2RtqGa
        Sf+mCcsfileR2VzznE2RyAF/NAKErAaFFPlYCfEe6Lpc/+iEzenWba5fSpwWUgtg
        2NmvteT4q+vudrTh8SKiOgR/orTfa5WiJWHFVHrg3sRyO8q2mwg6SbRGQJbQEGEE
        bF/wSFIJ7Vh3DXWeBvLr2u0984/n60j7dwsAwm/7z6nFEXmEvLoSi7xYaNTij7xQ
        ==
X-ME-Sender: <xms:89LrXO1xi9gGU1y4SVcPAAyZr4DM74jzaUWyDUyElog0JRUdHFM49g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddruddvvddggeelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtjeenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehguhgvshhtrdhnrhenucfkphepkeefrdekiedrkeelrddutd
    ejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhenucev
    lhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:89LrXN8BXbFUFYO8rGg1wlvBmMKEX4O9cHeUy0jBh9Ul6Kg3Pmr-PQ>
    <xmx:89LrXFpPRdVKVYKUBi8n1b4kogqzJJqCJXtAHKTbvDqxEyBt5lYrig>
    <xmx:89LrXEGk-IUfdJMIuNFi4j2VcKotT9YTIQePMLKh5Klbh1by1bVKqw>
    <xmx:89LrXNbe4Egpj6iuOmZQpivzab8Ckn-UZzRlwICsJ-iBmyfmJNngyA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id D0FD4380085;
        Mon, 27 May 2019 08:07:14 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: nVMX: Fix using __this_cpu_read() in preemptible context" failed to apply to 5.0-stable tree
To:     wanpengli@tencent.com, pbonzini@redhat.com, rkrcmar@redhat.com,
        sean.j.christopherson@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 27 May 2019 14:07:13 +0200
Message-ID: <15589588334107@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.0-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 541e886f7972cc647804dbb4909189e67987a945 Mon Sep 17 00:00:00 2001
From: Wanpeng Li <wanpengli@tencent.com>
Date: Fri, 17 May 2019 16:49:50 +0800
Subject: [PATCH] KVM: nVMX: Fix using __this_cpu_read() in preemptible context
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 6b450839c766..1032f068f0b9 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2784,14 +2784,13 @@ static int nested_vmx_check_vmentry_hw(struct kvm_vcpu *vcpu)
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
@@ -2803,6 +2802,7 @@ static int nested_vmx_check_vmentry_hw(struct kvm_vcpu *vcpu)
 	local_irq_enable();
 	if (hw_breakpoint_active())
 		set_debugreg(__this_cpu_read(cpu_dr7), 7);
+	preempt_enable();
 
 	/*
 	 * A non-failing VMEntry means we somehow entered guest mode with

