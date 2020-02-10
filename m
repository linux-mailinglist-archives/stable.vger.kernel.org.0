Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02F43157742
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 13:59:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728670AbgBJM6x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 07:58:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:43110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728386AbgBJMlP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:41:15 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E595B20733;
        Mon, 10 Feb 2020 12:41:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338475;
        bh=8eyn8EE5f6D6Y5h7u0U0tegwEcCBL4FTV9oRj41HMt4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vIS5BCRn+YAliZPIRofaRXoPX+ToFyXt8tkKAJtrshX2TwgQBjnqx0XOew7kn881W
         jaezvPtm5ViMOFOMNvXbH915SHNV1Hg6QR+wK2pr1Bi3Kh84zYobshlzA1xw8qqa/6
         G41D6ziBZLpV3+hKhOXeYBeWha8B9cTOnNd4d5go=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Allen <john.allen@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.5 242/367] kvm/svm: PKU not currently supported
Date:   Mon, 10 Feb 2020 04:32:35 -0800
Message-Id: <20200210122446.520845478@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122423.695146547@linuxfoundation.org>
References: <20200210122423.695146547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Allen <john.allen@amd.com>

commit a47970ed74a535b1accb4bc73643fd5a93993c3e upstream.

Current SVM implementation does not have support for handling PKU. Guests
running on a host with future AMD cpus that support the feature will read
garbage from the PKRU register and will hit segmentation faults on boot as
memory is getting marked as protected that should not be. Ensure that cpuid
from SVM does not advertise the feature.

Signed-off-by: John Allen <john.allen@amd.com>
Cc: stable@vger.kernel.org
Fixes: 0556cbdc2fbc ("x86/pkeys: Don't check if PKRU is zero before writing it")
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/include/asm/kvm_host.h |    1 +
 arch/x86/kvm/cpuid.c            |    4 +++-
 arch/x86/kvm/svm.c              |    6 ++++++
 arch/x86/kvm/vmx/capabilities.h |    5 +++++
 arch/x86/kvm/vmx/vmx.c          |    1 +
 5 files changed, 16 insertions(+), 1 deletion(-)

--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1145,6 +1145,7 @@ struct kvm_x86_ops {
 	bool (*xsaves_supported)(void);
 	bool (*umip_emulated)(void);
 	bool (*pt_supported)(void);
+	bool (*pku_supported)(void);
 
 	int (*check_nested_events)(struct kvm_vcpu *vcpu, bool external_intr);
 	void (*request_immediate_exit)(struct kvm_vcpu *vcpu);
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -352,6 +352,7 @@ static inline void do_cpuid_7_mask(struc
 	unsigned f_umip = kvm_x86_ops->umip_emulated() ? F(UMIP) : 0;
 	unsigned f_intel_pt = kvm_x86_ops->pt_supported() ? F(INTEL_PT) : 0;
 	unsigned f_la57;
+	unsigned f_pku = kvm_x86_ops->pku_supported() ? F(PKU) : 0;
 
 	/* cpuid 7.0.ebx */
 	const u32 kvm_cpuid_7_0_ebx_x86_features =
@@ -363,7 +364,7 @@ static inline void do_cpuid_7_mask(struc
 
 	/* cpuid 7.0.ecx*/
 	const u32 kvm_cpuid_7_0_ecx_x86_features =
-		F(AVX512VBMI) | F(LA57) | F(PKU) | 0 /*OSPKE*/ | F(RDPID) |
+		F(AVX512VBMI) | F(LA57) | 0 /*PKU*/ | 0 /*OSPKE*/ | F(RDPID) |
 		F(AVX512_VPOPCNTDQ) | F(UMIP) | F(AVX512_VBMI2) | F(GFNI) |
 		F(VAES) | F(VPCLMULQDQ) | F(AVX512_VNNI) | F(AVX512_BITALG) |
 		F(CLDEMOTE) | F(MOVDIRI) | F(MOVDIR64B) | 0 /*WAITPKG*/;
@@ -392,6 +393,7 @@ static inline void do_cpuid_7_mask(struc
 		/* Set LA57 based on hardware capability. */
 		entry->ecx |= f_la57;
 		entry->ecx |= f_umip;
+		entry->ecx |= f_pku;
 		/* PKU is not yet implemented for shadow paging. */
 		if (!tdp_enabled || !boot_cpu_has(X86_FEATURE_OSPKE))
 			entry->ecx &= ~F(PKU);
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -6001,6 +6001,11 @@ static bool svm_has_wbinvd_exit(void)
 	return true;
 }
 
+static bool svm_pku_supported(void)
+{
+	return false;
+}
+
 #define PRE_EX(exit)  { .exit_code = (exit), \
 			.stage = X86_ICPT_PRE_EXCEPT, }
 #define POST_EX(exit) { .exit_code = (exit), \
@@ -7341,6 +7346,7 @@ static struct kvm_x86_ops svm_x86_ops __
 	.xsaves_supported = svm_xsaves_supported,
 	.umip_emulated = svm_umip_emulated,
 	.pt_supported = svm_pt_supported,
+	.pku_supported = svm_pku_supported,
 
 	.set_supported_cpuid = svm_set_supported_cpuid,
 
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -145,6 +145,11 @@ static inline bool vmx_umip_emulated(voi
 		SECONDARY_EXEC_DESC;
 }
 
+static inline bool vmx_pku_supported(void)
+{
+	return boot_cpu_has(X86_FEATURE_PKU);
+}
+
 static inline bool cpu_has_vmx_rdtscp(void)
 {
 	return vmcs_config.cpu_based_2nd_exec_ctrl &
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7870,6 +7870,7 @@ static struct kvm_x86_ops vmx_x86_ops __
 	.xsaves_supported = vmx_xsaves_supported,
 	.umip_emulated = vmx_umip_emulated,
 	.pt_supported = vmx_pt_supported,
+	.pku_supported = vmx_pku_supported,
 
 	.request_immediate_exit = vmx_request_immediate_exit,
 


