Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE8E31BC855
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 20:31:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728688AbgD1Sbo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:31:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:47410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729716AbgD1Sbn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:31:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0C2DA217D8;
        Tue, 28 Apr 2020 18:31:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588098702;
        bh=MVYol4TeARxm1s9GgiiD64YBSQzGmOSrVGxwYMQgi+o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P3jl0+TjNK1yT5mmtNcemIRqB3+OLmeGH+U1oPAkv6j1L2TH/6ALBEpd5FMDgGAO7
         2LO0anKDlBSiIGFKsyVd4fyxehf39CqqgNAcID5HdzkWwDoGgpYyBv9UF57MNJCmsh
         lYmY6sE/hXn7Q14Vr3rgq16plWpxlN3dgxP/asJQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liran Alon <liran.alon@oracle.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 043/131] KVM: nVMX: Always sync GUEST_BNDCFGS when it comes from vmcs01
Date:   Tue, 28 Apr 2020 20:24:15 +0200
Message-Id: <20200428182230.477331542@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200428182224.822179290@linuxfoundation.org>
References: <20200428182224.822179290@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

commit 3b013a2972d5bc344d6eaa8f24fdfe268211e45f upstream.

If L1 does not set VM_ENTRY_LOAD_BNDCFGS, then L1's BNDCFGS value must
be propagated to vmcs02 since KVM always runs with VM_ENTRY_LOAD_BNDCFGS
when MPX is supported.  Because the value effectively comes from vmcs01,
vmcs02 must be updated even if vmcs12 is clean.

Fixes: 62cf9bd8118c4 ("KVM: nVMX: Fix emulation of VM_ENTRY_LOAD_BNDCFGS")
Cc: Liran Alon <liran.alon@oracle.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
[bwh: Backported to 4.19: adjust filename, context]
Signed-off-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/vmx.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index e4d0ad06790e1..ccbddc80ad55f 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -12137,13 +12137,9 @@ static void prepare_vmcs02_full(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12)
 
 	set_cr4_guest_host_mask(vmx);
 
-	if (kvm_mpx_supported()) {
-		if (vmx->nested.nested_run_pending &&
-			(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_BNDCFGS))
-			vmcs_write64(GUEST_BNDCFGS, vmcs12->guest_bndcfgs);
-		else
-			vmcs_write64(GUEST_BNDCFGS, vmx->nested.vmcs01_guest_bndcfgs);
-	}
+	if (kvm_mpx_supported() && vmx->nested.nested_run_pending &&
+	    (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_BNDCFGS))
+		vmcs_write64(GUEST_BNDCFGS, vmcs12->guest_bndcfgs);
 
 	if (enable_vpid) {
 		if (nested_cpu_has_vpid(vmcs12) && vmx->nested.vpid02)
@@ -12207,6 +12203,9 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
 		kvm_set_dr(vcpu, 7, vcpu->arch.dr7);
 		vmcs_write64(GUEST_IA32_DEBUGCTL, vmx->nested.vmcs01_debugctl);
 	}
+	if (kvm_mpx_supported() && (!vmx->nested.nested_run_pending ||
+	    !(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_BNDCFGS)))
+		vmcs_write64(GUEST_BNDCFGS, vmx->nested.vmcs01_guest_bndcfgs);
 	if (vmx->nested.nested_run_pending) {
 		vmcs_write32(VM_ENTRY_INTR_INFO_FIELD,
 			     vmcs12->vm_entry_intr_info_field);
-- 
2.20.1



