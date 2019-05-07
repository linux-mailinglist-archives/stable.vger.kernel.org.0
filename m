Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 966D915CB2
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 08:06:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726684AbfEGGF7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 02:05:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:53916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727370AbfEGFeC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 May 2019 01:34:02 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C4A5B20B7C;
        Tue,  7 May 2019 05:34:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557207241;
        bh=eFlkb15AdCBiSrkI/aUKUvyGyiAQO7YCQ62FeMN9Qkk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AiHggnrN55hTzaGNPE6/hMCxS+shQMmD1MccLXAkDBfAPSnQq5KImykgSyQH8doa9
         usNL9x5EF2Gf4xHgJNIP/krqb6C6o2JtuU3D8yJsSem0jwn7hOBNz81U9rZQZaAFD3
         As8P9+UuEGCWNVzBFIaTmH4dHkt9Ntw96M8cfjjA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, kvm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.0 44/99] KVM: nVMX: always use early vmcs check when EPT is disabled
Date:   Tue,  7 May 2019 01:31:38 -0400
Message-Id: <20190507053235.29900-44-sashal@kernel.org>
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

From: Paolo Bonzini <pbonzini@redhat.com>

[ Upstream commit 2b27924bb1d48e3775f432b70bdad5e6dd4e7798 ]

The remaining failures of vmx.flat when EPT is disabled are caused by
incorrectly reflecting VMfails to the L1 hypervisor.  What happens is
that nested_vmx_restore_host_state corrupts the guest CR3, reloading it
with the host's shadow CR3 instead, because it blindly loads GUEST_CR3
from the vmcs01.

For simplicity let's just always use hardware VMCS checks when EPT is
disabled.  This way, nested_vmx_restore_host_state is not reached at
all (or at least shouldn't be reached).

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/uapi/asm/vmx.h |  1 +
 arch/x86/kvm/vmx/nested.c       | 22 ++++++++++++++++++++--
 2 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/uapi/asm/vmx.h b/arch/x86/include/uapi/asm/vmx.h
index f0b0c90dd398..d213ec5c3766 100644
--- a/arch/x86/include/uapi/asm/vmx.h
+++ b/arch/x86/include/uapi/asm/vmx.h
@@ -146,6 +146,7 @@
 
 #define VMX_ABORT_SAVE_GUEST_MSR_FAIL        1
 #define VMX_ABORT_LOAD_HOST_PDPTE_FAIL       2
+#define VMX_ABORT_VMCS_CORRUPTED             3
 #define VMX_ABORT_LOAD_HOST_MSR_FAIL         4
 
 #endif /* _UAPIVMX_H */
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index f90b3a948291..c1de052d8748 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3790,8 +3790,18 @@ static void nested_vmx_restore_host_state(struct kvm_vcpu *vcpu)
 	vmx_set_cr4(vcpu, vmcs_readl(CR4_READ_SHADOW));
 
 	nested_ept_uninit_mmu_context(vcpu);
-	vcpu->arch.cr3 = vmcs_readl(GUEST_CR3);
-	__set_bit(VCPU_EXREG_CR3, (ulong *)&vcpu->arch.regs_avail);
+
+	/*
+	 * This is only valid if EPT is in use, otherwise the vmcs01 GUEST_CR3
+	 * points to shadow pages!  Fortunately we only get here after a WARN_ON
+	 * if EPT is disabled, so a VMabort is perfectly fine.
+	 */
+	if (enable_ept) {
+		vcpu->arch.cr3 = vmcs_readl(GUEST_CR3);
+		__set_bit(VCPU_EXREG_CR3, (ulong *)&vcpu->arch.regs_avail);
+	} else {
+		nested_vmx_abort(vcpu, VMX_ABORT_VMCS_CORRUPTED);
+	}
 
 	/*
 	 * Use ept_save_pdptrs(vcpu) to load the MMU's cached PDPTRs
@@ -5739,6 +5749,14 @@ __init int nested_vmx_hardware_setup(int (*exit_handlers[])(struct kvm_vcpu *))
 {
 	int i;
 
+	/*
+	 * Without EPT it is not possible to restore L1's CR3 and PDPTR on
+	 * VMfail, because they are not available in vmcs01.  Just always
+	 * use hardware checks.
+	 */
+	if (!enable_ept)
+		nested_early_check = 1;
+
 	if (!cpu_has_vmx_shadow_vmcs())
 		enable_shadow_vmcs = 0;
 	if (enable_shadow_vmcs) {
-- 
2.20.1

