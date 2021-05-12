Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43DE137C5EF
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:48:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234795AbhELPoh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:44:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:55166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236071AbhELPkW (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:40:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6171861444;
        Wed, 12 May 2021 15:21:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620832868;
        bh=ChPqBgFvL4Ahe3h75Qxl1shyA2FthDjLzBQXKMBuUkQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gisa5ngrERU2Gr9sruaBvBzvopi1TqtNbl1nZyvaREAW/bedXaaXFB1E8Fa8fWMCo
         bzJd1ufCWsTN2C7/1LDmw0im80nI83vg6uL0AQbaWOybwiBU+O5GEvww46SNOm+5jR
         if5xkw2iYQgCAJYJi03AUJQQa8yUmgc76OEF8UyQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        David Edmondson <david.edmondson@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 457/530] KVM: x86: dump_vmcs should not assume GUEST_IA32_EFER is valid
Date:   Wed, 12 May 2021 16:49:27 +0200
Message-Id: <20210512144834.784942355@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
References: <20210512144819.664462530@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Edmondson <david.edmondson@oracle.com>

[ Upstream commit d9e46d344e62a0d56fd86a8289db5bed8a57c92e ]

If the VM entry/exit controls for loading/saving MSR_EFER are either
not available (an older processor or explicitly disabled) or not
used (host and guest values are the same), reading GUEST_IA32_EFER
from the VMCS returns an inaccurate value.

Because of this, in dump_vmcs() don't use GUEST_IA32_EFER to decide
whether to print the PDPTRs - always do so if the fields exist.

Fixes: 4eb64dce8d0a ("KVM: x86: dump VMCS on invalid entry")
Signed-off-by: David Edmondson <david.edmondson@oracle.com>
Message-Id: <20210318120841.133123-2-david.edmondson@oracle.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/vmx/vmx.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index f8835cabf29f..8635413cc649 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5779,7 +5779,6 @@ void dump_vmcs(void)
 	u32 vmentry_ctl, vmexit_ctl;
 	u32 cpu_based_exec_ctrl, pin_based_exec_ctrl, secondary_exec_control;
 	unsigned long cr4;
-	u64 efer;
 
 	if (!dump_invalid_vmcs) {
 		pr_warn_ratelimited("set kvm_intel.dump_invalid_vmcs=1 to dump internal KVM state.\n");
@@ -5791,7 +5790,6 @@ void dump_vmcs(void)
 	cpu_based_exec_ctrl = vmcs_read32(CPU_BASED_VM_EXEC_CONTROL);
 	pin_based_exec_ctrl = vmcs_read32(PIN_BASED_VM_EXEC_CONTROL);
 	cr4 = vmcs_readl(GUEST_CR4);
-	efer = vmcs_read64(GUEST_IA32_EFER);
 	secondary_exec_control = 0;
 	if (cpu_has_secondary_exec_ctrls())
 		secondary_exec_control = vmcs_read32(SECONDARY_VM_EXEC_CONTROL);
@@ -5803,9 +5801,7 @@ void dump_vmcs(void)
 	pr_err("CR4: actual=0x%016lx, shadow=0x%016lx, gh_mask=%016lx\n",
 	       cr4, vmcs_readl(CR4_READ_SHADOW), vmcs_readl(CR4_GUEST_HOST_MASK));
 	pr_err("CR3 = 0x%016lx\n", vmcs_readl(GUEST_CR3));
-	if ((secondary_exec_control & SECONDARY_EXEC_ENABLE_EPT) &&
-	    (cr4 & X86_CR4_PAE) && !(efer & EFER_LMA))
-	{
+	if (cpu_has_vmx_ept()) {
 		pr_err("PDPTR0 = 0x%016llx  PDPTR1 = 0x%016llx\n",
 		       vmcs_read64(GUEST_PDPTR0), vmcs_read64(GUEST_PDPTR1));
 		pr_err("PDPTR2 = 0x%016llx  PDPTR3 = 0x%016llx\n",
@@ -5831,7 +5827,8 @@ void dump_vmcs(void)
 	if ((vmexit_ctl & (VM_EXIT_SAVE_IA32_PAT | VM_EXIT_SAVE_IA32_EFER)) ||
 	    (vmentry_ctl & (VM_ENTRY_LOAD_IA32_PAT | VM_ENTRY_LOAD_IA32_EFER)))
 		pr_err("EFER =     0x%016llx  PAT = 0x%016llx\n",
-		       efer, vmcs_read64(GUEST_IA32_PAT));
+		       vmcs_read64(GUEST_IA32_EFER),
+		       vmcs_read64(GUEST_IA32_PAT));
 	pr_err("DebugCtl = 0x%016llx  DebugExceptions = 0x%016lx\n",
 	       vmcs_read64(GUEST_IA32_DEBUGCTL),
 	       vmcs_readl(GUEST_PENDING_DBG_EXCEPTIONS));
-- 
2.30.2



