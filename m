Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DE94328BC2
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:41:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240352AbhCASis (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:38:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:47656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239487AbhCASdv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:33:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9961D64DF5;
        Mon,  1 Mar 2021 17:13:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618784;
        bh=f4nH5RCPDoEZ6AICNu9+etSMFr2lohCpheSfPMPFZX4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aHXGqgGKJ7/g4kXl91tivDrTHEYhQCSgzPrYEFN4pZiJFkr00j5iGp7ExHV6k1hRU
         eQXQHwl+POFV4odDUSvpJLs3rMHv5ZojA1n8Ydvxq7r7Qru83Z9II37G8Z3WKP3cpC
         cgBST6EAgCCAUa6EYhSFITLxQtkabQX8FqronMro=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 215/663] KVM: nSVM: Dont strip hosts C-bit from guests CR3 when reading PDPTRs
Date:   Mon,  1 Mar 2021 17:07:43 +0100
Message-Id: <20210301161152.428680702@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit 2732be90235347a3be4babdc9f88a1ea93970b0b ]

Don't clear the SME C-bit when reading a guest PDPTR, as the GPA (CR3) is
in the guest domain.

Barring a bizarre paravirtual use case, this is likely a benign bug.  SME
is not emulated by KVM, loading SEV guest PDPTRs is doomed as KVM can't
use the correct key to read guest memory, and setting guest MAXPHYADDR
higher than the host, i.e. overlapping the C-bit, would cause faults in
the guest.

Note, for SEV guests, stripping the C-bit is technically aligned with CPU
behavior, but for KVM it's the greater of two evils.  Because KVM doesn't
have access to the guest's encryption key, ignoring the C-bit would at
best result in KVM reading garbage.  By keeping the C-bit, KVM will
fail its read (unless userspace creates a memslot with the C-bit set).
The guest will still undoubtedly die, as KVM will use '0' for the PDPTR
value, but that's preferable to interpreting encrypted data as a PDPTR.

Fixes: d0ec49d4de90 ("kvm/x86/svm: Support Secure Memory Encryption within KVM")
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20210204000117.3303214-3-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/svm/nested.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 4fbe190c79159..dd45e647888f7 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -58,7 +58,7 @@ static u64 nested_svm_get_tdp_pdptr(struct kvm_vcpu *vcpu, int index)
 	u64 pdpte;
 	int ret;
 
-	ret = kvm_vcpu_read_guest_page(vcpu, gpa_to_gfn(__sme_clr(cr3)), &pdpte,
+	ret = kvm_vcpu_read_guest_page(vcpu, gpa_to_gfn(cr3), &pdpte,
 				       offset_in_page(cr3) + index * 8, 8);
 	if (ret)
 		return 0;
-- 
2.27.0



