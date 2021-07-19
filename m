Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BBD43CCFAC
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 11:00:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235630AbhGSISq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 04:18:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:39374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235643AbhGSISp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 04:18:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 572D761245;
        Mon, 19 Jul 2021 08:54:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626684862;
        bh=6Oc4+Us+O3SNdYbL0oP1jdH812m5HRycq3k8SdwCWQk=;
        h=Subject:To:Cc:From:Date:From;
        b=DfLmqE8O+IwdrAgz8NQbJ7kQz7+IKIQpQT7bGiVlnzRWPONPS28T+kfIuZMalm2sm
         p7Cjlo13LxdC0g6Pr5NF4g2+ug9jBOH4RFDu666Iy/nkjvkCKFw/jPFEM2Ty5XFRG1
         S1uq0wgZA9JPkX7HALbnuyBnpz+e2SrCIkKFrUC8=
Subject: FAILED: patch "[PATCH] KVM: SVM: Revert clearing of C-bit on GPA in #NPF handler" failed to apply to 5.10-stable tree
To:     seanjc@google.com, brijesh.singh@amd.com, pbonzini@redhat.com,
        pgonda@google.com, thomas.lendacky@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 19 Jul 2021 10:54:04 +0200
Message-ID: <162668484410346@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 76ff371b67cb12fb635396234468abcf6a466f16 Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Thu, 24 Jun 2021 19:03:54 -0700
Subject: [PATCH] KVM: SVM: Revert clearing of C-bit on GPA in #NPF handler

Don't clear the C-bit in the #NPF handler, as it is a legal GPA bit for
non-SEV guests, and for SEV guests the C-bit is dropped before the GPA
hits the NPT in hardware.  Clearing the bit for non-SEV guests causes KVM
to mishandle #NPFs with that collide with the host's C-bit.

Although the APM doesn't explicitly state that the C-bit is not reserved
for non-SEV, Tom Lendacky confirmed that the following snippet about the
effective reduction due to the C-bit does indeed apply only to SEV guests.

  Note that because guest physical addresses are always translated
  through the nested page tables, the size of the guest physical address
  space is not impacted by any physical address space reduction indicated
  in CPUID 8000_001F[EBX]. If the C-bit is a physical address bit however,
  the guest physical address space is effectively reduced by 1 bit.

And for SEV guests, the APM clearly states that the bit is dropped before
walking the nested page tables.

  If the C-bit is an address bit, this bit is masked from the guest
  physical address when it is translated through the nested page tables.
  Consequently, the hypervisor does not need to be aware of which pages
  the guest has chosen to mark private.

Note, the bogus C-bit clearing was removed from legacy #PF handler in
commit 6d1b867d0456 ("KVM: SVM: Don't strip the C-bit from CR2 on #PF
interception").

Fixes: 0ede79e13224 ("KVM: SVM: Clear C-bit from the page fault address")
Cc: Peter Gonda <pgonda@google.com>
Cc: Brijesh Singh <brijesh.singh@amd.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20210625020354.431829-3-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 8834822c00cd..ca5614a48b21 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1923,7 +1923,7 @@ static int npf_interception(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
-	u64 fault_address = __sme_clr(svm->vmcb->control.exit_info_2);
+	u64 fault_address = svm->vmcb->control.exit_info_2;
 	u64 error_code = svm->vmcb->control.exit_info_1;
 
 	trace_kvm_page_fault(fault_address, error_code);

