Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F352815CA4
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 08:05:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727424AbfEGFeG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 01:34:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:53952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727411AbfEGFeF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 May 2019 01:34:05 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F32AE20B7C;
        Tue,  7 May 2019 05:34:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557207244;
        bh=YSIJSBBHtM0WqwfXn8MlZjoSKbffyCq5FDxyImeCKYc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MdgDMdib5QADik8ITb9tCPLolbcaxwQATvyBsRfgrWjUy7LH3kYto16Xmp8ZCC9bj
         tJtZQaJSMgI6qRTTxJ/PMqB17G1/TWxc+RzdVDeNjwIIgvZcZJOIwS/6LZPsdTwUzh
         kl6t6tsX0erl7tkeDr42fQJ3vkjax+qFBJriYxuo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Liran Alon <liran.alon@oracle.com>,
        Saar Amar <saaramar@microsoft.com>,
        Mihai Carabas <mihai.carabas@oracle.com>,
        Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, kvm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.0 46/99] KVM: nVMX: Expose RDPMC-exiting only when guest supports PMU
Date:   Tue,  7 May 2019 01:31:40 -0400
Message-Id: <20190507053235.29900-46-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190507053235.29900-1-sashal@kernel.org>
References: <20190507053235.29900-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liran Alon <liran.alon@oracle.com>

[ Upstream commit e51bfdb68725dc052d16241ace40ea3140f938aa ]

Issue was discovered when running kvm-unit-tests on KVM running as L1 on
top of Hyper-V.

When vmx_instruction_intercept unit-test attempts to run RDPMC to test
RDPMC-exiting, it is intercepted by L1 KVM which it's EXIT_REASON_RDPMC
handler raise #GP because vCPU exposed by Hyper-V doesn't support PMU.
Instead of unit-test expectation to be reflected with EXIT_REASON_RDPMC.

The reason vmx_instruction_intercept unit-test attempts to run RDPMC
even though Hyper-V doesn't support PMU is because L1 expose to L2
support for RDPMC-exiting. Which is reasonable to assume that is
supported only in case CPU supports PMU to being with.

Above issue can easily be simulated by modifying
vmx_instruction_intercept config in x86/unittests.cfg to run QEMU with
"-cpu host,+vmx,-pmu" and run unit-test.

To handle issue, change KVM to expose RDPMC-exiting only when guest
supports PMU.

Reported-by: Saar Amar <saaramar@microsoft.com>
Reviewed-by: Mihai Carabas <mihai.carabas@oracle.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Liran Alon <liran.alon@oracle.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/vmx/vmx.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 34499081022c..0479aee38f4d 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6982,6 +6982,30 @@ static void nested_vmx_entry_exit_ctls_update(struct kvm_vcpu *vcpu)
 	}
 }
 
+static bool guest_cpuid_has_pmu(struct kvm_vcpu *vcpu)
+{
+	struct kvm_cpuid_entry2 *entry;
+	union cpuid10_eax eax;
+
+	entry = kvm_find_cpuid_entry(vcpu, 0xa, 0);
+	if (!entry)
+		return false;
+
+	eax.full = entry->eax;
+	return (eax.split.version_id > 0);
+}
+
+static void nested_vmx_procbased_ctls_update(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	bool pmu_enabled = guest_cpuid_has_pmu(vcpu);
+
+	if (pmu_enabled)
+		vmx->nested.msrs.procbased_ctls_high |= CPU_BASED_RDPMC_EXITING;
+	else
+		vmx->nested.msrs.procbased_ctls_high &= ~CPU_BASED_RDPMC_EXITING;
+}
+
 static void update_intel_pt_cfg(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
@@ -7070,6 +7094,7 @@ static void vmx_cpuid_update(struct kvm_vcpu *vcpu)
 	if (nested_vmx_allowed(vcpu)) {
 		nested_vmx_cr_fixed1_bits_update(vcpu);
 		nested_vmx_entry_exit_ctls_update(vcpu);
+		nested_vmx_procbased_ctls_update(vcpu);
 	}
 
 	if (boot_cpu_has(X86_FEATURE_INTEL_PT) &&
-- 
2.20.1

