Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66597797A1
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 22:02:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390555AbfG2Ttg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:49:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:40138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389987AbfG2Tte (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:49:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 372FE21655;
        Mon, 29 Jul 2019 19:49:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564429773;
        bh=BB3i0a7WNVHRMHYQq60v4UZ2dAiAnHvjY8Jd6CqZtOo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2Elawo3wlr0GnbOdajg/zAc68UPBksIH262DDzYnpu2aQbHjwxhbuVMCVu6fxuefP
         k3qMnULx08OSYseDh5eA5Q16CLmYzUkmwcGtRVV6BS4U3THXKDXpgWLt8DDjq5XeKD
         8xJsHWIKYnVdWpnv4f+I2f9YM+nrJHQGbCl9uZqk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        Liran Alon <liran.alon@oracle.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 074/215] KVM: nVMX: Intercept VMWRITEs to GUEST_{CS,SS}_AR_BYTES
Date:   Mon, 29 Jul 2019 21:21:10 +0200
Message-Id: <20190729190752.935522010@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190739.971253303@linuxfoundation.org>
References: <20190729190739.971253303@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit b643780562af5378ef7fe731c65b8f93e49c59c6 ]

VMMs frequently read the guest's CS and SS AR bytes to detect 64-bit
mode and CPL respectively, but effectively never write said fields once
the VM is initialized.  Intercepting VMWRITEs for the two fields saves
~55 cycles in copy_shadow_to_vmcs12().

Because some Intel CPUs, e.g. Haswell, drop the reserved bits of the
guest access rights fields on VMWRITE, exposing the fields to L1 for
VMREAD but not VMWRITE leads to inconsistent behavior between L1 and L2.
On hardware that drops the bits, L1 will see the stripped down value due
to reading the value from hardware, while L2 will see the full original
value as stored by KVM.  To avoid such an inconsistency, emulate the
behavior on all CPUS, but only for intercepted VMWRITEs so as to avoid
introducing pointless latency into copy_shadow_to_vmcs12(), e.g. if the
emulation were added to vmcs12_write_any().

Since the AR_BYTES emulation is done only for intercepted VMWRITE, if a
future patch (re)exposed AR_BYTES for both VMWRITE and VMREAD, then KVM
would end up with incosistent behavior on pre-Haswell hardware, e.g. KVM
would drop the reserved bits on intercepted VMWRITE, but direct VMWRITE
to the shadow VMCS would not drop the bits.  Add a WARN in the shadow
field initialization to detect any attempt to expose an AR_BYTES field
without updating vmcs12_write_any().

Note, emulation of the AR_BYTES reserved bit behavior is based on a
patch[1] from Jim Mattson that applied the emulation to all writes to
vmcs12 so that live migration across different generations of hardware
would not introduce divergent behavior.  But given that live migration
of nested state has already been enabled, that ship has sailed (not to
mention that no sane VMM will be affected by this behavior).

[1] https://patchwork.kernel.org/patch/10483321/

Cc: Jim Mattson <jmattson@google.com>
Cc: Liran Alon <liran.alon@oracle.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/vmx/nested.c             | 15 +++++++++++++++
 arch/x86/kvm/vmx/vmcs_shadow_fields.h |  4 ++--
 2 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 543d7d82479b..ac98b1328124 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -91,6 +91,10 @@ static void init_vmcs_shadow_fields(void)
 			pr_err("Missing field from shadow_read_write_field %x\n",
 			       field + 1);
 
+		WARN_ONCE(field >= GUEST_ES_AR_BYTES &&
+			  field <= GUEST_TR_AR_BYTES,
+			  "Update vmcs12_write_any() to expose AR_BYTES RW");
+
 		/*
 		 * PML and the preemption timer can be emulated, but the
 		 * processor cannot vmwrite to fields that don't exist
@@ -4500,6 +4504,17 @@ static int handle_vmwrite(struct kvm_vcpu *vcpu)
 		vmcs12 = get_shadow_vmcs12(vcpu);
 	}
 
+	/*
+	 * Some Intel CPUs intentionally drop the reserved bits of the AR byte
+	 * fields on VMWRITE.  Emulate this behavior to ensure consistent KVM
+	 * behavior regardless of the underlying hardware, e.g. if an AR_BYTE
+	 * field is intercepted for VMWRITE but not VMREAD (in L1), then VMREAD
+	 * from L1 will return a different value than VMREAD from L2 (L1 sees
+	 * the stripped down value, L2 sees the full value as stored by KVM).
+	 */
+	if (field >= GUEST_ES_AR_BYTES && field <= GUEST_TR_AR_BYTES)
+		field_value &= 0x1f0ff;
+
 	if (vmcs12_write_any(vmcs12, field, field_value) < 0)
 		return nested_vmx_failValid(vcpu,
 			VMXERR_UNSUPPORTED_VMCS_COMPONENT);
diff --git a/arch/x86/kvm/vmx/vmcs_shadow_fields.h b/arch/x86/kvm/vmx/vmcs_shadow_fields.h
index 132432f375c2..97dd5295be31 100644
--- a/arch/x86/kvm/vmx/vmcs_shadow_fields.h
+++ b/arch/x86/kvm/vmx/vmcs_shadow_fields.h
@@ -40,14 +40,14 @@ SHADOW_FIELD_RO(VM_EXIT_INSTRUCTION_LEN)
 SHADOW_FIELD_RO(IDT_VECTORING_INFO_FIELD)
 SHADOW_FIELD_RO(IDT_VECTORING_ERROR_CODE)
 SHADOW_FIELD_RO(VM_EXIT_INTR_ERROR_CODE)
+SHADOW_FIELD_RO(GUEST_CS_AR_BYTES)
+SHADOW_FIELD_RO(GUEST_SS_AR_BYTES)
 SHADOW_FIELD_RW(CPU_BASED_VM_EXEC_CONTROL)
 SHADOW_FIELD_RW(EXCEPTION_BITMAP)
 SHADOW_FIELD_RW(VM_ENTRY_EXCEPTION_ERROR_CODE)
 SHADOW_FIELD_RW(VM_ENTRY_INTR_INFO_FIELD)
 SHADOW_FIELD_RW(VM_ENTRY_INSTRUCTION_LEN)
 SHADOW_FIELD_RW(TPR_THRESHOLD)
-SHADOW_FIELD_RW(GUEST_CS_AR_BYTES)
-SHADOW_FIELD_RW(GUEST_SS_AR_BYTES)
 SHADOW_FIELD_RW(GUEST_INTERRUPTIBILITY_INFO)
 SHADOW_FIELD_RW(VMX_PREEMPTION_TIMER_VALUE)
 
-- 
2.20.1



