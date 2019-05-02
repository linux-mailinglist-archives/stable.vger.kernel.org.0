Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE75811DD8
	for <lists+stable@lfdr.de>; Thu,  2 May 2019 17:37:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726406AbfEBPed (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 May 2019 11:34:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:51480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729086AbfEBPcC (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 May 2019 11:32:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D39CA20C01;
        Thu,  2 May 2019 15:32:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556811121;
        bh=Na7835Vjg79k31aUQRQ3eZo3Y9Jd6T+CHPZgrq81pmA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1iYidboAO5X5t8xrH6zk+Ukd4ZxOvK/7p+CE1biX+f5vki/vz3ie0PzvHgjXGpOEY
         cJQ9fCHqkUZ81zNNob7zS9QCKCS+hWoEelloU4qV+RP36sjeTk196TGmzVsMXK79qm
         OaZRyu/nxbNsfrkgOJnV1exrroy2s40ADkkgAka0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Venkatesh Srinivas <venkateshs@google.com>,
        Jim Mattson <jmattson@google.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Borislav Petkov <bp@alien8.de>, Joerg Roedel <joro@8bytes.org>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        "Sasha Levin (Microsoft)" <sashal@kernel.org>
Subject: [PATCH 5.0 083/101] KVM: SVM: Workaround errata#1096 (insn_len maybe zero on SMAP violation)
Date:   Thu,  2 May 2019 17:21:25 +0200
Message-Id: <20190502143345.428568863@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190502143339.434882399@linuxfoundation.org>
References: <20190502143339.434882399@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 05d5a48635259e621ea26d01e8316c6feeb34190 ]

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
Signed-off-by: Sasha Levin (Microsoft) <sashal@kernel.org>
---
 arch/x86/include/asm/kvm_host.h |  2 ++
 arch/x86/kvm/mmu.c              |  8 +++++---
 arch/x86/kvm/svm.c              | 32 ++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/vmx.c          |  6 ++++++
 4 files changed, 45 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 71d763ad2637..9f2d890733a9 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1198,6 +1198,8 @@ struct kvm_x86_ops {
 	int (*nested_enable_evmcs)(struct kvm_vcpu *vcpu,
 				   uint16_t *vmcs_version);
 	uint16_t (*nested_get_evmcs_version)(struct kvm_vcpu *vcpu);
+
+	bool (*need_emulation_on_page_fault)(struct kvm_vcpu *vcpu);
 };
 
 struct kvm_arch_async_pf {
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index acab95dcffb6..77dbb57412cc 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -5395,10 +5395,12 @@ int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gva_t cr2, u64 error_code,
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
index 516c1de03d47..e544cec812f9 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -7114,6 +7114,36 @@ static int nested_enable_evmcs(struct kvm_vcpu *vcpu,
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
@@ -7247,6 +7277,8 @@ static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
 
 	.nested_enable_evmcs = nested_enable_evmcs,
 	.nested_get_evmcs_version = nested_get_evmcs_version,
+
+	.need_emulation_on_page_fault = svm_need_emulation_on_page_fault,
 };
 
 static int __init svm_init(void)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 34499081022c..e7fe8c692362 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7526,6 +7526,11 @@ static int enable_smi_window(struct kvm_vcpu *vcpu)
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
@@ -7828,6 +7833,7 @@ static struct kvm_x86_ops vmx_x86_ops __ro_after_init = {
 	.set_nested_state = NULL,
 	.get_vmcs12_pages = NULL,
 	.nested_enable_evmcs = NULL,
+	.need_emulation_on_page_fault = vmx_need_emulation_on_page_fault,
 };
 
 static void vmx_cleanup_l1d_flush(void)
-- 
2.19.1



