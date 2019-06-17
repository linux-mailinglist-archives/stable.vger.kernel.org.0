Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67B634941E
	for <lists+stable@lfdr.de>; Mon, 17 Jun 2019 23:36:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728959AbfFQVfq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 17:35:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:47174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729547AbfFQVW3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Jun 2019 17:22:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ABC9E20833;
        Mon, 17 Jun 2019 21:22:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560806548;
        bh=dvxxn4rysdrsxXAtrKY2Bdb2fzE5Pk706zOzmuoP2eA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TWHCoyQ7mpBCTKsXiVzi8fTLOmC0eWobV96SV1n7ECixdn0wDpeZ9CIDBsyfaLBTy
         2xmypv6EsdBT+Fr1RpBkjIaPIbxv+VPpyLbfTpzovpJhbpCcb0/z6pXfikwce9LCS/
         XH1ZhR9cOORZzUFTVuHeKRvUiF9k6hfophVrb1n8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 088/115] KVM: x86: do not spam dmesg with VMCS/VMCB dumps
Date:   Mon, 17 Jun 2019 23:09:48 +0200
Message-Id: <20190617210804.454133767@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190617210759.929316339@linuxfoundation.org>
References: <20190617210759.929316339@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 6f2f84532c153d32a5e53b6083b06a3e24368d30 ]

Userspace can easily set up invalid processor state in such a way that
dmesg will be filled with VMCS or VMCB dumps.  Disable this by default
using a module parameter.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/svm.c     |  9 ++++++++-
 arch/x86/kvm/vmx/vmx.c | 26 +++++++++++++++++++-------
 2 files changed, 27 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index ae6e51828a54..aa3b77acfbf9 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -379,6 +379,9 @@ module_param(vgif, int, 0444);
 static int sev = IS_ENABLED(CONFIG_AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT);
 module_param(sev, int, 0444);
 
+static bool __read_mostly dump_invalid_vmcb = 0;
+module_param(dump_invalid_vmcb, bool, 0644);
+
 static u8 rsm_ins_bytes[] = "\x0f\xaa";
 
 static void svm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0);
@@ -4834,6 +4837,11 @@ static void dump_vmcb(struct kvm_vcpu *vcpu)
 	struct vmcb_control_area *control = &svm->vmcb->control;
 	struct vmcb_save_area *save = &svm->vmcb->save;
 
+	if (!dump_invalid_vmcb) {
+		pr_warn_ratelimited("set kvm_amd.dump_invalid_vmcb=1 to dump internal KVM state.\n");
+		return;
+	}
+
 	pr_err("VMCB Control Area:\n");
 	pr_err("%-20s%04x\n", "cr_read:", control->intercept_cr & 0xffff);
 	pr_err("%-20s%04x\n", "cr_write:", control->intercept_cr >> 16);
@@ -4992,7 +5000,6 @@ static int handle_exit(struct kvm_vcpu *vcpu)
 		kvm_run->exit_reason = KVM_EXIT_FAIL_ENTRY;
 		kvm_run->fail_entry.hardware_entry_failure_reason
 			= svm->vmcb->control.exit_code;
-		pr_err("KVM: FAILED VMRUN WITH VMCB:\n");
 		dump_vmcb(vcpu);
 		return 0;
 	}
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 2b4a3d32c511..cfb8f1ec9a0a 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -114,6 +114,9 @@ static u64 __read_mostly host_xss;
 bool __read_mostly enable_pml = 1;
 module_param_named(pml, enable_pml, bool, S_IRUGO);
 
+static bool __read_mostly dump_invalid_vmcs = 0;
+module_param(dump_invalid_vmcs, bool, 0644);
+
 #define MSR_BITMAP_MODE_X2APIC		1
 #define MSR_BITMAP_MODE_X2APIC_APICV	2
 
@@ -5605,15 +5608,24 @@ static void vmx_dump_dtsel(char *name, uint32_t limit)
 
 void dump_vmcs(void)
 {
-	u32 vmentry_ctl = vmcs_read32(VM_ENTRY_CONTROLS);
-	u32 vmexit_ctl = vmcs_read32(VM_EXIT_CONTROLS);
-	u32 cpu_based_exec_ctrl = vmcs_read32(CPU_BASED_VM_EXEC_CONTROL);
-	u32 pin_based_exec_ctrl = vmcs_read32(PIN_BASED_VM_EXEC_CONTROL);
-	u32 secondary_exec_control = 0;
-	unsigned long cr4 = vmcs_readl(GUEST_CR4);
-	u64 efer = vmcs_read64(GUEST_IA32_EFER);
+	u32 vmentry_ctl, vmexit_ctl;
+	u32 cpu_based_exec_ctrl, pin_based_exec_ctrl, secondary_exec_control;
+	unsigned long cr4;
+	u64 efer;
 	int i, n;
 
+	if (!dump_invalid_vmcs) {
+		pr_warn_ratelimited("set kvm_intel.dump_invalid_vmcs=1 to dump internal KVM state.\n");
+		return;
+	}
+
+	vmentry_ctl = vmcs_read32(VM_ENTRY_CONTROLS);
+	vmexit_ctl = vmcs_read32(VM_EXIT_CONTROLS);
+	cpu_based_exec_ctrl = vmcs_read32(CPU_BASED_VM_EXEC_CONTROL);
+	pin_based_exec_ctrl = vmcs_read32(PIN_BASED_VM_EXEC_CONTROL);
+	cr4 = vmcs_readl(GUEST_CR4);
+	efer = vmcs_read64(GUEST_IA32_EFER);
+	secondary_exec_control = 0;
 	if (cpu_has_secondary_exec_ctrls())
 		secondary_exec_control = vmcs_read32(SECONDARY_VM_EXEC_CONTROL);
 
-- 
2.20.1



