Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11F593CE1BD
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:12:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347448AbhGSP13 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:27:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:38038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348181AbhGSPYi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:24:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F378061457;
        Mon, 19 Jul 2021 16:02:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626710565;
        bh=0c0kS3WBbzf+geo/geL0adM2cWP0Qmsk1pEjLDIVQAI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Bm1D8nOiPvmmgMjfGAScuHozDs9cfUWIxrUh/okGYOuGCsT9k9zppxZ4helbtqXam
         eyrinjkOxUwvQ4MjEwO+enaa1PbbhUhv+xHJWlW02GhmLCMjtDToS3rfJN0z4CPkuo
         nQMvOrlzOzFVL45jbPlb1+wvTQKWg4MXxgULBIo4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Gonda <pgonda@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.13 009/351] KVM: SVM: Revert clearing of C-bit on GPA in #NPF handler
Date:   Mon, 19 Jul 2021 16:49:15 +0200
Message-Id: <20210719144944.843257726@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144944.537151528@linuxfoundation.org>
References: <20210719144944.537151528@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

commit 76ff371b67cb12fb635396234468abcf6a466f16 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/svm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1897,7 +1897,7 @@ static int npf_interception(struct kvm_v
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
-	u64 fault_address = __sme_clr(svm->vmcb->control.exit_info_2);
+	u64 fault_address = svm->vmcb->control.exit_info_2;
 	u64 error_code = svm->vmcb->control.exit_info_1;
 
 	trace_kvm_page_fault(fault_address, error_code);


