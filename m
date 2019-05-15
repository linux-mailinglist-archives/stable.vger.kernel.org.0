Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD1EF1F2C6
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 14:08:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728917AbfEOMG6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 08:06:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:43004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728876AbfEOLJq (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:09:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3197B2084F;
        Wed, 15 May 2019 11:09:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557918584;
        bh=fvQ7HN3G+WGKBDG2GyZKRvmrZ2b7KtUSJBPqQj+sA30=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f8/BIk70BGRcBgtBC5QmuY5nVFMncY5iiL9u3skPup5+IvWBYCy5D3+B4O0F30H5J
         xmXF9XtjOlTj9NlcP8tttMX0Yd/qav3/AyglLDEetUWeDYXbp9S7L+GYGZ9vM68ut/
         UnRssiI78+JaRPatKBV3HTf4nQiibd3cdKE677lM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Janakarajan Natarajan <Janakarajan.Natarajan@amd.com>,
        kvm@vger.kernel.org, KarimAllah Ahmed <karahmed@amazon.de>,
        andrew.cooper3@citrix.com, Joerg Roedel <joro@8bytes.org>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Borislav Petkov <bp@suse.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Kees Cook <keescook@chromium.org>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 4.4 188/266] x86/bugs: Add AMDs SPEC_CTRL MSR usage
Date:   Wed, 15 May 2019 12:54:55 +0200
Message-Id: <20190515090729.297898045@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090722.696531131@linuxfoundation.org>
References: <20190515090722.696531131@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

commit 6ac2f49edb1ef5446089c7c660017732886d62d6 upstream.

The AMD document outlining the SSBD handling
124441_AMD64_SpeculativeStoreBypassDisable_Whitepaper_final.pdf
mentions that if CPUID 8000_0008.EBX[24] is set we should be using
the SPEC_CTRL MSR (0x48) over the VIRT SPEC_CTRL MSR (0xC001_011f)
for speculative store bypass disable.

This in effect means we should clear the X86_FEATURE_VIRT_SSBD
flag so that we would prefer the SPEC_CTRL MSR.

See the document titled:
   124441_AMD64_SpeculativeStoreBypassDisable_Whitepaper_final.pdf

A copy of this document is available at
   https://bugzilla.kernel.org/show_bug.cgi?id=199889

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Janakarajan Natarajan <Janakarajan.Natarajan@amd.com>
Cc: kvm@vger.kernel.org
Cc: KarimAllah Ahmed <karahmed@amazon.de>
Cc: andrew.cooper3@citrix.com
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Radim Krčmář <rkrcmar@redhat.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: David Woodhouse <dwmw@amazon.co.uk>
Cc: Kees Cook <keescook@chromium.org>
Link: https://lkml.kernel.org/r/20180601145921.9500-3-konrad.wilk@oracle.com
[bwh: Backported to 4.4:
 - Update feature test in guest_cpuid_has_spec_ctrl() instead of
   svm_{get,set}_msr()
 - Adjust context, indentation]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/cpufeatures.h |    1 +
 arch/x86/kernel/cpu/bugs.c         |   12 +++++++-----
 arch/x86/kernel/cpu/common.c       |    6 ++++++
 arch/x86/kvm/cpuid.c               |   10 ++++++++--
 arch/x86/kvm/cpuid.h               |    2 +-
 arch/x86/kvm/svm.c                 |    2 +-
 6 files changed, 24 insertions(+), 9 deletions(-)

--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -269,6 +269,7 @@
 #define X86_FEATURE_AMD_IBPB	(13*32+12) /* "" Indirect Branch Prediction Barrier */
 #define X86_FEATURE_AMD_IBRS	(13*32+14) /* "" Indirect Branch Restricted Speculation */
 #define X86_FEATURE_AMD_STIBP	(13*32+15) /* "" Single Thread Indirect Branch Predictors */
+#define X86_FEATURE_AMD_SSBD	(13*32+24) /* "" Speculative Store Bypass Disable */
 #define X86_FEATURE_VIRT_SSBD	(13*32+25) /* Virtualized Speculative Store Bypass Disable */
 #define X86_FEATURE_AMD_SSB_NO	(13*32+26) /* "" Speculative Store Bypass is fixed in hardware. */
 
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -523,18 +523,20 @@ static enum ssb_mitigation __init __ssb_
 	if (mode == SPEC_STORE_BYPASS_DISABLE) {
 		setup_force_cpu_cap(X86_FEATURE_SPEC_STORE_BYPASS_DISABLE);
 		/*
-		 * Intel uses the SPEC CTRL MSR Bit(2) for this, while AMD uses
-		 * a completely different MSR and bit dependent on family.
+		 * Intel uses the SPEC CTRL MSR Bit(2) for this, while AMD may
+		 * use a completely different MSR and bit dependent on family.
 		 */
 		switch (boot_cpu_data.x86_vendor) {
 		case X86_VENDOR_INTEL:
+		case X86_VENDOR_AMD:
+			if (!static_cpu_has(X86_FEATURE_MSR_SPEC_CTRL)) {
+				x86_amd_ssb_disable();
+				break;
+			}
 			x86_spec_ctrl_base |= SPEC_CTRL_SSBD;
 			x86_spec_ctrl_mask |= SPEC_CTRL_SSBD;
 			wrmsrl(MSR_IA32_SPEC_CTRL, x86_spec_ctrl_base);
 			break;
-		case X86_VENDOR_AMD:
-			x86_amd_ssb_disable();
-			break;
 		}
 	}
 
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -709,6 +709,12 @@ static void init_speculation_control(str
 		set_cpu_cap(c, X86_FEATURE_STIBP);
 		set_cpu_cap(c, X86_FEATURE_MSR_SPEC_CTRL);
 	}
+
+	if (cpu_has(c, X86_FEATURE_AMD_SSBD)) {
+		set_cpu_cap(c, X86_FEATURE_SSBD);
+		set_cpu_cap(c, X86_FEATURE_MSR_SPEC_CTRL);
+		clear_cpu_cap(c, X86_FEATURE_VIRT_SSBD);
+	}
 }
 
 void get_cpu_cap(struct cpuinfo_x86 *c)
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -343,7 +343,8 @@ static inline int __do_cpuid_ent(struct
 
 	/* cpuid 0x80000008.ebx */
 	const u32 kvm_cpuid_8000_0008_ebx_x86_features =
-		F(AMD_IBPB) | F(AMD_IBRS) | F(VIRT_SSBD) | F(AMD_SSB_NO);
+		F(AMD_IBPB) | F(AMD_IBRS) | F(AMD_SSBD) | F(VIRT_SSBD) |
+		F(AMD_SSB_NO);
 
 	/* cpuid 0xC0000001.edx */
 	const u32 kvm_supported_word5_x86_features =
@@ -607,7 +608,12 @@ static inline int __do_cpuid_ent(struct
 			entry->ebx |= F(VIRT_SSBD);
 		entry->ebx &= kvm_cpuid_8000_0008_ebx_x86_features;
 		cpuid_mask(&entry->ebx, CPUID_8000_0008_EBX);
-		if (boot_cpu_has(X86_FEATURE_LS_CFG_SSBD))
+		/*
+		 * The preference is to use SPEC CTRL MSR instead of the
+		 * VIRT_SPEC MSR.
+		 */
+		if (boot_cpu_has(X86_FEATURE_LS_CFG_SSBD) &&
+		    !boot_cpu_has(X86_FEATURE_AMD_SSBD))
 			entry->ebx |= F(VIRT_SSBD);
 		break;
 	}
--- a/arch/x86/kvm/cpuid.h
+++ b/arch/x86/kvm/cpuid.h
@@ -175,7 +175,7 @@ static inline bool guest_cpuid_has_spec_
 	struct kvm_cpuid_entry2 *best;
 
 	best = kvm_find_cpuid_entry(vcpu, 0x80000008, 0);
-	if (best && (best->ebx & bit(X86_FEATURE_AMD_IBRS)))
+	if (best && (best->ebx & (bit(X86_FEATURE_AMD_IBRS | bit(X86_FEATURE_AMD_SSBD)))))
 		return true;
 	best = kvm_find_cpuid_entry(vcpu, 7, 0);
 	return best && (best->edx & (bit(X86_FEATURE_SPEC_CTRL) | bit(X86_FEATURE_SPEC_CTRL_SSBD)));
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -3197,7 +3197,7 @@ static int svm_set_msr(struct kvm_vcpu *
 			return 1;
 
 		/* The STIBP bit doesn't fault even if it's not advertised */
-		if (data & ~(SPEC_CTRL_IBRS | SPEC_CTRL_STIBP))
+		if (data & ~(SPEC_CTRL_IBRS | SPEC_CTRL_STIBP | SPEC_CTRL_SSBD))
 			return 1;
 
 		svm->spec_ctrl = data;


