Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2C677162A
	for <lists+stable@lfdr.de>; Tue, 23 Jul 2019 12:36:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388921AbfGWKgB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jul 2019 06:36:01 -0400
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:35789 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388008AbfGWKgB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Jul 2019 06:36:01 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 8D27B46F;
        Tue, 23 Jul 2019 06:36:00 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Tue, 23 Jul 2019 06:36:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=bF2wF4
        Y9QwyHqJEe/eNulh/YdbqbFCsOfXsY31duCEY=; b=PrH04wu5u+GdgPw+HRS7rr
        2l6700MNiU0akRkr8v3USYzbdZV34hz0KyRmlrlDcTD0kBLyZmcVX8UJyunsPlbN
        NypoV+U5FwMSzr5NYbYc5ze9J1I/mAMv2AY7W0UcRZQY0DILwXuQb48yNRXm2GVV
        sZsVb5pVI0SmqpsxMK2pEgVO3lBpsl4aNQuxSbY0gST6pZw7ktqHf/nvia2pXXyF
        8umaq3Y8Au3F4IRPyK6sz5Q3bhNgHnT51pkrP8EOCyjG4GnOHlyYAed2ygtUHLwJ
        73cR3WVQlNOMUBiAY8RW/H9O5fzPeqhe37LuvVGwTrDo8bFG5YzwjCjL4AjpTKQQ
        ==
X-ME-Sender: <xms:D-M2XZ-wMLLjNAsakv6ZVFibe1dhBJGyk3GnRvt2CtuC5gTHlhb2xw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrjeekgdefudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucffohhmrghinheprghpfhdrhhhoshhtnecukfhppeekfedrkeeirdekledruddtje
    enucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhmnecuvehl
    uhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:D-M2XQ8GYB8YLvZ3rhhd1OEPTbkI3Ad0ZnwsJvb5d_6qixZKGFNQdw>
    <xmx:D-M2XejqSr2ghrdTjdAB46G5fGjwcwE56Vy6lSLNSy3aMy6KWh_XDA>
    <xmx:D-M2XbGH56cFisKZ6w1j938rudop3orewCM3mZTjZ3zLSFvNNWgygg>
    <xmx:EOM2XWuaIzQYc-89Qdj1bzOGjmtpjobwVv1vQ6kgpV6DposRpG_zGg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 933F6380074;
        Tue, 23 Jul 2019 06:35:59 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: VMX: Fix handling of #MC that occurs during VM-Entry" failed to apply to 4.14-stable tree
To:     sean.j.christopherson@intel.com, jmattson@google.com,
        pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 23 Jul 2019 12:33:25 +0200
Message-ID: <1563878005206167@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From beb8d93b3e423043e079ef3dda19dad7b28467a8 Mon Sep 17 00:00:00 2001
From: Sean Christopherson <sean.j.christopherson@intel.com>
Date: Fri, 19 Apr 2019 22:50:55 -0700
Subject: [PATCH] KVM: VMX: Fix handling of #MC that occurs during VM-Entry

A previous fix to prevent KVM from consuming stale VMCS state after a
failed VM-Entry inadvertantly blocked KVM's handling of machine checks
that occur during VM-Entry.

Per Intel's SDM, a #MC during VM-Entry is handled in one of three ways,
depending on when the #MC is recognoized.  As it pertains to this bug
fix, the third case explicitly states EXIT_REASON_MCE_DURING_VMENTRY
is handled like any other VM-Exit during VM-Entry, i.e. sets bit 31 to
indicate the VM-Entry failed.

If a machine-check event occurs during a VM entry, one of the following occurs:
 - The machine-check event is handled as if it occurred before the VM entry:
        ...
 - The machine-check event is handled after VM entry completes:
        ...
 - A VM-entry failure occurs as described in Section 26.7. The basic
   exit reason is 41, for "VM-entry failure due to machine-check event".

Explicitly handle EXIT_REASON_MCE_DURING_VMENTRY as a one-off case in
vmx_vcpu_run() instead of binning it into vmx_complete_atomic_exit().
Doing so allows vmx_vcpu_run() to handle VMX_EXIT_REASONS_FAILED_VMENTRY
in a sane fashion and also simplifies vmx_complete_atomic_exit() since
VMCS.VM_EXIT_INTR_INFO is guaranteed to be fresh.

Fixes: b060ca3b2e9e7 ("kvm: vmx: Handle VMLAUNCH/VMRESUME failure properly")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 5d903f8909d1..1b3ca0582a0c 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6107,28 +6107,21 @@ static void vmx_apicv_post_state_restore(struct kvm_vcpu *vcpu)
 
 static void vmx_complete_atomic_exit(struct vcpu_vmx *vmx)
 {
-	u32 exit_intr_info = 0;
-	u16 basic_exit_reason = (u16)vmx->exit_reason;
-
-	if (!(basic_exit_reason == EXIT_REASON_MCE_DURING_VMENTRY
-	      || basic_exit_reason == EXIT_REASON_EXCEPTION_NMI))
+	if (vmx->exit_reason != EXIT_REASON_EXCEPTION_NMI)
 		return;
 
-	if (!(vmx->exit_reason & VMX_EXIT_REASONS_FAILED_VMENTRY))
-		exit_intr_info = vmcs_read32(VM_EXIT_INTR_INFO);
-	vmx->exit_intr_info = exit_intr_info;
+	vmx->exit_intr_info = vmcs_read32(VM_EXIT_INTR_INFO);
 
 	/* if exit due to PF check for async PF */
-	if (is_page_fault(exit_intr_info))
+	if (is_page_fault(vmx->exit_intr_info))
 		vmx->vcpu.arch.apf.host_apf_reason = kvm_read_and_reset_pf_reason();
 
 	/* Handle machine checks before interrupts are enabled */
-	if (basic_exit_reason == EXIT_REASON_MCE_DURING_VMENTRY ||
-	    is_machine_check(exit_intr_info))
+	if (is_machine_check(vmx->exit_intr_info))
 		kvm_machine_check();
 
 	/* We need to handle NMIs before interrupts are enabled */
-	if (is_nmi(exit_intr_info)) {
+	if (is_nmi(vmx->exit_intr_info)) {
 		kvm_before_interrupt(&vmx->vcpu);
 		asm("int $2");
 		kvm_after_interrupt(&vmx->vcpu);
@@ -6535,6 +6528,9 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
 	vmx->idt_vectoring_info = 0;
 
 	vmx->exit_reason = vmx->fail ? 0xdead : vmcs_read32(VM_EXIT_REASON);
+	if ((u16)vmx->exit_reason == EXIT_REASON_MCE_DURING_VMENTRY)
+		kvm_machine_check();
+
 	if (vmx->fail || (vmx->exit_reason & VMX_EXIT_REASONS_FAILED_VMENTRY))
 		return;
 

