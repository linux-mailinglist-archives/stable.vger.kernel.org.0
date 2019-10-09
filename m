Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58453D1688
	for <lists+stable@lfdr.de>; Wed,  9 Oct 2019 19:31:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732130AbfJIRYH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Oct 2019 13:24:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:48592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732114AbfJIRYG (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 9 Oct 2019 13:24:06 -0400
Received: from sasha-vm.mshome.net (unknown [167.220.2.234])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E96F620B7C;
        Wed,  9 Oct 2019 17:24:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570641846;
        bh=0n0vAQGmipGpyI/AMrQCo2G1tsKLSKQXTFv/Wdt/X2U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y5diIJkXSq8RHzcipt0RbcXCIutB5eVwSvnMDMk2ULepedbAL+pHQPZBNxtLXC8Vc
         4zBFAq4bqG3+6vdpA9uMgqBoY8EjTHr1F4BDUM+9++GLc1tk5GVabr8U2enrrJBpsi
         GJ2m6e167FWRC0+G6jkgurkFC50QdpNZpUDeIl7o=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>, Marc Orr <marcorr@google.com>,
        Peter Shier <pshier@google.com>,
        Jacob Xu <jacobhxu@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, kvm@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 08/26] kvm: x86: Improve emulation of CPUID leaves 0BH and 1FH
Date:   Wed,  9 Oct 2019 13:05:40 -0400
Message-Id: <20191009170558.32517-8-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191009170558.32517-1-sashal@kernel.org>
References: <20191009170558.32517-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jim Mattson <jmattson@google.com>

[ Upstream commit 43561123ab3759eb6ff47693aec1a307af0aef83 ]

For these CPUID leaves, the EDX output is not dependent on the ECX
input (i.e. the SIGNIFCANT_INDEX flag doesn't apply to
EDX). Furthermore, the low byte of the ECX output is always identical
to the low byte of the ECX input. KVM does not produce the correct ECX
and EDX outputs for any undefined subleaves beyond the first.

Special-case these CPUID leaves in kvm_cpuid, so that the ECX and EDX
outputs are properly generated for all undefined subleaves.

Fixes: 0771671749b59a ("KVM: Enhance guest cpuid management")
Fixes: a87f2d3a6eadab ("KVM: x86: Add Intel CPUID.1F cpuid emulation support")
Signed-off-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Marc Orr <marcorr@google.com>
Reviewed-by: Peter Shier <pshier@google.com>
Reviewed-by: Jacob Xu <jacobhxu@google.com>
Cc: Sean Christopherson <sean.j.christopherson@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/cpuid.c | 83 +++++++++++++++++++++++++-------------------
 1 file changed, 47 insertions(+), 36 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index b810102a9cfac..ada2cae6bec51 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -891,53 +891,64 @@ struct kvm_cpuid_entry2 *kvm_find_cpuid_entry(struct kvm_vcpu *vcpu,
 EXPORT_SYMBOL_GPL(kvm_find_cpuid_entry);
 
 /*
- * If no match is found, check whether we exceed the vCPU's limit
- * and return the content of the highest valid _standard_ leaf instead.
- * This is to satisfy the CPUID specification.
+ * If the basic or extended CPUID leaf requested is higher than the
+ * maximum supported basic or extended leaf, respectively, then it is
+ * out of range.
  */
-static struct kvm_cpuid_entry2* check_cpuid_limit(struct kvm_vcpu *vcpu,
-                                                  u32 function, u32 index)
+static bool cpuid_function_in_range(struct kvm_vcpu *vcpu, u32 function)
 {
-	struct kvm_cpuid_entry2 *maxlevel;
-
-	maxlevel = kvm_find_cpuid_entry(vcpu, function & 0x80000000, 0);
-	if (!maxlevel || maxlevel->eax >= function)
-		return NULL;
-	if (function & 0x80000000) {
-		maxlevel = kvm_find_cpuid_entry(vcpu, 0, 0);
-		if (!maxlevel)
-			return NULL;
-	}
-	return kvm_find_cpuid_entry(vcpu, maxlevel->eax, index);
+	struct kvm_cpuid_entry2 *max;
+
+	max = kvm_find_cpuid_entry(vcpu, function & 0x80000000, 0);
+	return max && function <= max->eax;
 }
 
 bool kvm_cpuid(struct kvm_vcpu *vcpu, u32 *eax, u32 *ebx,
 	       u32 *ecx, u32 *edx, bool check_limit)
 {
 	u32 function = *eax, index = *ecx;
-	struct kvm_cpuid_entry2 *best;
-	bool entry_found = true;
-
-	best = kvm_find_cpuid_entry(vcpu, function, index);
-
-	if (!best) {
-		entry_found = false;
-		if (!check_limit)
-			goto out;
+	struct kvm_cpuid_entry2 *entry;
+	struct kvm_cpuid_entry2 *max;
+	bool found;
 
-		best = check_cpuid_limit(vcpu, function, index);
+	entry = kvm_find_cpuid_entry(vcpu, function, index);
+	found = entry;
+	/*
+	 * Intel CPUID semantics treats any query for an out-of-range
+	 * leaf as if the highest basic leaf (i.e. CPUID.0H:EAX) were
+	 * requested.
+	 */
+	if (!entry && check_limit && !cpuid_function_in_range(vcpu, function)) {
+		max = kvm_find_cpuid_entry(vcpu, 0, 0);
+		if (max) {
+			function = max->eax;
+			entry = kvm_find_cpuid_entry(vcpu, function, index);
+		}
 	}
-
-out:
-	if (best) {
-		*eax = best->eax;
-		*ebx = best->ebx;
-		*ecx = best->ecx;
-		*edx = best->edx;
-	} else
+	if (entry) {
+		*eax = entry->eax;
+		*ebx = entry->ebx;
+		*ecx = entry->ecx;
+		*edx = entry->edx;
+	} else {
 		*eax = *ebx = *ecx = *edx = 0;
-	trace_kvm_cpuid(function, *eax, *ebx, *ecx, *edx, entry_found);
-	return entry_found;
+		/*
+		 * When leaf 0BH or 1FH is defined, CL is pass-through
+		 * and EDX is always the x2APIC ID, even for undefined
+		 * subleaves. Index 1 will exist iff the leaf is
+		 * implemented, so we pass through CL iff leaf 1
+		 * exists. EDX can be copied from any existing index.
+		 */
+		if (function == 0xb || function == 0x1f) {
+			entry = kvm_find_cpuid_entry(vcpu, function, 1);
+			if (entry) {
+				*ecx = index & 0xff;
+				*edx = entry->edx;
+			}
+		}
+	}
+	trace_kvm_cpuid(function, *eax, *ebx, *ecx, *edx, found);
+	return found;
 }
 EXPORT_SYMBOL_GPL(kvm_cpuid);
 
-- 
2.20.1

