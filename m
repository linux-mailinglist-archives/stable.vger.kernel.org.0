Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E7FA4A2F91
	for <lists+stable@lfdr.de>; Sat, 29 Jan 2022 13:53:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349719AbiA2MxU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 Jan 2022 07:53:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347906AbiA2MxS (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 Jan 2022 07:53:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC7BEC061714
        for <stable@vger.kernel.org>; Sat, 29 Jan 2022 04:53:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6B54F60BA0
        for <stable@vger.kernel.org>; Sat, 29 Jan 2022 12:53:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EF36C340E5;
        Sat, 29 Jan 2022 12:53:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643460797;
        bh=gK5AzxxKtRlvhuhJ6371vCuI/4JD2vfBcvRfibwldhM=;
        h=Subject:To:Cc:From:Date:From;
        b=TEvsNzQhDZ0SwZlHUFEBhuQphMSRn3DoftTyhcmiosINPuVtlXuWaTSXM9RWUV48f
         2JnvrUJldYYGcIIRV8fxzWkOUhBj7VE9ZL2uPAuFrZFRNcnXtPCdBvwGzAupOgGqTO
         hwWZHrhkSL1eZc4oynzWWYkLfrCo7kOeE0Zfil1g=
Subject: FAILED: patch "[PATCH] KVM: SVM: Workaround errata#1096 (insn_len maybe zero on SMAP" failed to apply to 5.4-stable tree
To:     brijesh.singh@amd.com, bp@alien8.de, jmattson@google.com,
        joro@8bytes.org, pbonzini@redhat.com, rkrcmar@redhat.com,
        thomas.lendacky@amd.com, venkateshs@google.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 29 Jan 2022 13:53:15 +0100
Message-ID: <16434607959496@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 05d5a48635259e621ea26d01e8316c6feeb34190 Mon Sep 17 00:00:00 2001
From: "Singh, Brijesh" <brijesh.singh@amd.com>
Date: Fri, 15 Feb 2019 17:24:12 +0000
Subject: [PATCH] KVM: SVM: Workaround errata#1096 (insn_len maybe zero on SMAP
 violation)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Errata#1096:

On a nested data page fault when CR.SMAP=1 and the guest data read
generates a SMAP violation, GuestInstrBytes field of the VMCB on a
VMEXIT will incorrectly return 0h instead the correct guest
instruction bytes .

Recommend Workaround:

To determine what instruction the guest was executing the hypervisor
will have to decode the instruction at the instruction pointer.

The recommended workaround can not be implemented for the SEV
guest because guest memory is encrypted with the guest specific key,
and instruction decoder will not be able to decode the instruction
bytes. If we hit this errata in the SEV guest then log the message
and request a guest shutdown.

Reported-by: Venkatesh Srinivas <venkateshs@google.com>
Cc: Jim Mattson <jmattson@google.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: "Radim Krčmář" <rkrcmar@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 88f5192ce05e..5b03006c00be 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1192,6 +1192,8 @@ struct kvm_x86_ops {
 	int (*nested_enable_evmcs)(struct kvm_vcpu *vcpu,
 				   uint16_t *vmcs_version);
 	uint16_t (*nested_get_evmcs_version)(struct kvm_vcpu *vcpu);
+
+	bool (*need_emulation_on_page_fault)(struct kvm_vcpu *vcpu);
 };
 
 struct kvm_arch_async_pf {
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 776a58b00682..f6d760dcdb75 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -5408,10 +5408,12 @@ int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gva_t cr2, u64 error_code,
 	 * This can happen if a guest gets a page-fault on data access but the HW
 	 * table walker is not able to read the instruction page (e.g instruction
 	 * page is not present in memory). In those cases we simply restart the
-	 * guest.
+	 * guest, with the exception of AMD Erratum 1096 which is unrecoverable.
 	 */
-	if (unlikely(insn && !insn_len))
-		return 1;
+	if (unlikely(insn && !insn_len)) {
+		if (!kvm_x86_ops->need_emulation_on_page_fault(vcpu))
+			return 1;
+	}
 
 	er = x86_emulate_instruction(vcpu, cr2, emulation_type, insn, insn_len);
 
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index b5b128a0a051..426039285fd1 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -7098,6 +7098,36 @@ static int nested_enable_evmcs(struct kvm_vcpu *vcpu,
 	return -ENODEV;
 }
 
+static bool svm_need_emulation_on_page_fault(struct kvm_vcpu *vcpu)
+{
+	bool is_user, smap;
+
+	is_user = svm_get_cpl(vcpu) == 3;
+	smap = !kvm_read_cr4_bits(vcpu, X86_CR4_SMAP);
+
+	/*
+	 * Detect and workaround Errata 1096 Fam_17h_00_0Fh
+	 *
+	 * In non SEV guest, hypervisor will be able to read the guest
+	 * memory to decode the instruction pointer when insn_len is zero
+	 * so we return true to indicate that decoding is possible.
+	 *
+	 * But in the SEV guest, the guest memory is encrypted with the
+	 * guest specific key and hypervisor will not be able to decode the
+	 * instruction pointer so we will not able to workaround it. Lets
+	 * print the error and request to kill the guest.
+	 */
+	if (is_user && smap) {
+		if (!sev_guest(vcpu->kvm))
+			return true;
+
+		pr_err_ratelimited("KVM: Guest triggered AMD Erratum 1096\n");
+		kvm_make_request(KVM_REQ_TRIPLE_FAULT, vcpu);
+	}
+
+	return false;
+}
+
 static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
 	.cpu_has_kvm_support = has_svm,
 	.disabled_by_bios = is_disabled,
@@ -7231,6 +7261,8 @@ static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
 
 	.nested_enable_evmcs = nested_enable_evmcs,
 	.nested_get_evmcs_version = nested_get_evmcs_version,
+
+	.need_emulation_on_page_fault = svm_need_emulation_on_page_fault,
 };
 
 static int __init svm_init(void)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index c73375e01ab8..6aa84e09217b 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7409,6 +7409,11 @@ static int enable_smi_window(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
+static bool vmx_need_emulation_on_page_fault(struct kvm_vcpu *vcpu)
+{
+	return 0;
+}
+
 static __init int hardware_setup(void)
 {
 	unsigned long host_bndcfgs;
@@ -7711,6 +7716,7 @@ static struct kvm_x86_ops vmx_x86_ops __ro_after_init = {
 	.set_nested_state = NULL,
 	.get_vmcs12_pages = NULL,
 	.nested_enable_evmcs = NULL,
+	.need_emulation_on_page_fault = vmx_need_emulation_on_page_fault,
 };
 
 static void vmx_cleanup_l1d_flush(void)

