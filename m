Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6DBDB5CA1
	for <lists+stable@lfdr.de>; Wed, 18 Sep 2019 08:28:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730520AbfIRG1g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Sep 2019 02:27:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:49528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727936AbfIRG1f (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Sep 2019 02:27:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7784121D56;
        Wed, 18 Sep 2019 06:27:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568788054;
        bh=gxS9ZUbbvVVkzsG5z+wVfzyHSZCRFBRYBIGeGuEaGog=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fy02PPBIYXRIj8qFuA26TGmESYPB/vCq+Km4C+xj5nV8N8PsKpIQB1J8n2cLRMGqV
         8Rp/PM9Ds8LGP6WztgYERgPK1l34R6XOx7WKAJJHfJNQ5JjrRCgIvpvE+Y0+Ns7vC/
         UI0HQlzZYbyWiOS2RQqQjX3/0COZ55gxELHMNWqI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Singh Brijesh <brijesh.singh@amd.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Liran Alon <liran.alon@oracle.com>
Subject: [PATCH 5.2 81/85] KVM: SVM: Fix detection of AMD Errata 1096
Date:   Wed, 18 Sep 2019 08:19:39 +0200
Message-Id: <20190918061237.939407203@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190918061234.107708857@linuxfoundation.org>
References: <20190918061234.107708857@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liran Alon <liran.alon@oracle.com>

commit 118154bdf54ca79e4b5f3ce6d4a8a7c6b7c2c76f upstream.

When CPU raise #NPF on guest data access and guest CR4.SMAP=1, it is
possible that CPU microcode implementing DecodeAssist will fail
to read bytes of instruction which caused #NPF. This is AMD errata
1096 and it happens because CPU microcode reading instruction bytes
incorrectly attempts to read code as implicit supervisor-mode data
accesses (that is, just like it would read e.g. a TSS), which are
susceptible to SMAP faults. The microcode reads CS:RIP and if it is
a user-mode address according to the page tables, the processor
gives up and returns no instruction bytes.  In this case,
GuestIntrBytes field of the VMCB on a VMEXIT will incorrectly
return 0 instead of the correct guest instruction bytes.

Current KVM code attemps to detect and workaround this errata, but it
has multiple issues:

1) It mistakenly checks if guest CR4.SMAP=0 instead of guest CR4.SMAP=1,
which is required for encountering a SMAP fault.

2) It assumes SMAP faults can only occur when guest CPL==3.
However, in case guest CR4.SMEP=0, the guest can execute an instruction
which reside in a user-accessible page with CPL<3 priviledge. If this
instruction raise a #NPF on it's data access, then CPU DecodeAssist
microcode will still encounter a SMAP violation.  Even though no sane
OS will do so (as it's an obvious priviledge escalation vulnerability),
we still need to handle this semanticly correct in KVM side.

Note that (2) *is* a useful optimization, because CR4.SMAP=1 is an easy
triggerable condition and guests usually enable SMAP together with SMEP.
If the vCPU has CR4.SMEP=1, the errata could indeed be encountered onlt
at guest CPL==3; otherwise, the CPU would raise a SMEP fault to guest
instead of #NPF.  We keep this condition to avoid false positives in
the detection of the errata.

In addition, to avoid future confusion and improve code readbility,
include details of the errata in code and not just in commit message.

Fixes: 05d5a4863525 ("KVM: SVM: Workaround errata#1096 (insn_len maybe zero on SMAP violation)")
Cc: Singh Brijesh <brijesh.singh@amd.com>
Cc: Sean Christopherson <sean.j.christopherson@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Signed-off-by: Liran Alon <liran.alon@oracle.com>
Reviewed-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/svm.c |   42 +++++++++++++++++++++++++++++++++++-------
 1 file changed, 35 insertions(+), 7 deletions(-)

--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -7116,13 +7116,41 @@ static int nested_enable_evmcs(struct kv
 
 static bool svm_need_emulation_on_page_fault(struct kvm_vcpu *vcpu)
 {
-	bool is_user, smap;
-
-	is_user = svm_get_cpl(vcpu) == 3;
-	smap = !kvm_read_cr4_bits(vcpu, X86_CR4_SMAP);
+	unsigned long cr4 = kvm_read_cr4(vcpu);
+	bool smep = cr4 & X86_CR4_SMEP;
+	bool smap = cr4 & X86_CR4_SMAP;
+	bool is_user = svm_get_cpl(vcpu) == 3;
 
 	/*
-	 * Detect and workaround Errata 1096 Fam_17h_00_0Fh
+	 * Detect and workaround Errata 1096 Fam_17h_00_0Fh.
+	 *
+	 * Errata:
+	 * When CPU raise #NPF on guest data access and vCPU CR4.SMAP=1, it is
+	 * possible that CPU microcode implementing DecodeAssist will fail
+	 * to read bytes of instruction which caused #NPF. In this case,
+	 * GuestIntrBytes field of the VMCB on a VMEXIT will incorrectly
+	 * return 0 instead of the correct guest instruction bytes.
+	 *
+	 * This happens because CPU microcode reading instruction bytes
+	 * uses a special opcode which attempts to read data using CPL=0
+	 * priviledges. The microcode reads CS:RIP and if it hits a SMAP
+	 * fault, it gives up and returns no instruction bytes.
+	 *
+	 * Detection:
+	 * We reach here in case CPU supports DecodeAssist, raised #NPF and
+	 * returned 0 in GuestIntrBytes field of the VMCB.
+	 * First, errata can only be triggered in case vCPU CR4.SMAP=1.
+	 * Second, if vCPU CR4.SMEP=1, errata could only be triggered
+	 * in case vCPU CPL==3 (Because otherwise guest would have triggered
+	 * a SMEP fault instead of #NPF).
+	 * Otherwise, vCPU CR4.SMEP=0, errata could be triggered by any vCPU CPL.
+	 * As most guests enable SMAP if they have also enabled SMEP, use above
+	 * logic in order to attempt minimize false-positive of detecting errata
+	 * while still preserving all cases semantic correctness.
+	 *
+	 * Workaround:
+	 * To determine what instruction the guest was executing, the hypervisor
+	 * will have to decode the instruction at the instruction pointer.
 	 *
 	 * In non SEV guest, hypervisor will be able to read the guest
 	 * memory to decode the instruction pointer when insn_len is zero
@@ -7133,11 +7161,11 @@ static bool svm_need_emulation_on_page_f
 	 * instruction pointer so we will not able to workaround it. Lets
 	 * print the error and request to kill the guest.
 	 */
-	if (is_user && smap) {
+	if (smap && (!smep || is_user)) {
 		if (!sev_guest(vcpu->kvm))
 			return true;
 
-		pr_err_ratelimited("KVM: Guest triggered AMD Erratum 1096\n");
+		pr_err_ratelimited("KVM: SEV Guest triggered AMD Erratum 1096\n");
 		kvm_make_request(KVM_REQ_TRIPLE_FAULT, vcpu);
 	}
 


