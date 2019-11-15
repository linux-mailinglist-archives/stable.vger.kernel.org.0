Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F142AFD64F
	for <lists+stable@lfdr.de>; Fri, 15 Nov 2019 07:24:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727431AbfKOGVv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Nov 2019 01:21:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:50856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727471AbfKOGVu (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Nov 2019 01:21:50 -0500
Received: from localhost (unknown [104.132.150.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EBC862053B;
        Fri, 15 Nov 2019 06:21:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573798910;
        bh=+8tKJ5KwR1Yj3sezuqYeaOuoJLVjJ86dELGalxZYXKw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n1DDy9bmbf5gMvFaLLojQfcHdyAowzClsqvoGXT+QpM444IeZsbfnwXAFULaznqI4
         WgsAMWwmL6q8ydOnxg9eyUk+y5VYgU1c9pfFb/PNaJfv/Iyq8lCRXAfa2bYoHNZ46G
         15M++xE+qWl/4r2hAYClhkUOvvLBmWgnqw4Y6LRg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 4.4 09/20] KVM: x86: use Intel speculation bugs and features as derived in generic x86 code
Date:   Fri, 15 Nov 2019 14:20:38 +0800
Message-Id: <20191115062011.042251416@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191115062006.854443935@linuxfoundation.org>
References: <20191115062006.854443935@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

commit 0c54914d0c52a15db9954a76ce80fee32cf318f4 upstream.

Similar to AMD bits, set the Intel bits from the vendor-independent
feature and bug flags, because KVM_GET_SUPPORTED_CPUID does not care
about the vendor and they should be set on AMD processors as well.

Suggested-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
[bwh: Backported to 4.4: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/cpuid.c |    7 +++++++
 arch/x86/kvm/x86.c   |    8 ++++++++
 2 files changed, 15 insertions(+)

--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -447,6 +447,13 @@ static inline int __do_cpuid_ent(struct
 			entry->ebx |= F(TSC_ADJUST);
 			entry->edx &= kvm_cpuid_7_0_edx_x86_features;
 			cpuid_mask(&entry->edx, CPUID_7_EDX);
+			if (boot_cpu_has(X86_FEATURE_IBPB) &&
+			    boot_cpu_has(X86_FEATURE_IBRS))
+				entry->edx |= F(SPEC_CTRL);
+			if (boot_cpu_has(X86_FEATURE_STIBP))
+				entry->edx |= F(INTEL_STIBP);
+			if (boot_cpu_has(X86_FEATURE_SSBD))
+				entry->edx |= F(SPEC_CTRL_SSBD);
 			/*
 			 * We emulate ARCH_CAPABILITIES in software even
 			 * if the host doesn't support it.
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1001,8 +1001,16 @@ u64 kvm_get_arch_capabilities(void)
 
 	rdmsrl_safe(MSR_IA32_ARCH_CAPABILITIES, &data);
 
+	if (!boot_cpu_has_bug(X86_BUG_CPU_MELTDOWN))
+		data |= ARCH_CAP_RDCL_NO;
+	if (!boot_cpu_has_bug(X86_BUG_SPEC_STORE_BYPASS))
+		data |= ARCH_CAP_SSB_NO;
+	if (!boot_cpu_has_bug(X86_BUG_MDS))
+		data |= ARCH_CAP_MDS_NO;
+
 	return data;
 }
+
 EXPORT_SYMBOL_GPL(kvm_get_arch_capabilities);
 
 static bool __kvm_valid_efer(struct kvm_vcpu *vcpu, u64 efer)


