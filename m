Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70116F9E5A
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 00:50:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726979AbfKLXuf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 18:50:35 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57284 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726923AbfKLXue (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Nov 2019 18:50:34 -0500
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iUfvc-0008I0-Vd; Tue, 12 Nov 2019 23:50:33 +0000
Received: from ben by deadeye with local (Exim 4.93-RC1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iUfvc-00056U-Db; Tue, 12 Nov 2019 23:50:32 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        "Jim Mattson" <jmattson@google.com>
Date:   Tue, 12 Nov 2019 23:47:59 +0000
Message-ID: <lsq.1573602477.729591670@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 02/25] KVM: x86: use Intel speculation bugs and
 features as  derived in generic x86 code
In-Reply-To: <lsq.1573602477.548403712@decadent.org.uk>
X-SA-Exim-Connect-IP: 167.98.27.226
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.77-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Bonzini <pbonzini@redhat.com>

commit 0c54914d0c52a15db9954a76ce80fee32cf318f4 upstream.

Similar to AMD bits, set the Intel bits from the vendor-independent
feature and bug flags, because KVM_GET_SUPPORTED_CPUID does not care
about the vendor and they should be set on AMD processors as well.

Suggested-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
[bwh: Backported to 3.16: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/kvm/cpuid.c | 7 +++++++
 arch/x86/kvm/x86.c   | 8 ++++++++
 2 files changed, 15 insertions(+)

--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -395,6 +395,13 @@ static inline int __do_cpuid_ent(struct
 			entry->ebx |= F(TSC_ADJUST);
 			entry->edx &= kvm_cpuid_7_0_edx_x86_features;
 			cpuid_mask(&entry->edx, 10);
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
@@ -917,8 +917,16 @@ u64 kvm_get_arch_capabilities(void)
 
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
 
 bool kvm_valid_efer(struct kvm_vcpu *vcpu, u64 efer)

