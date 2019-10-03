Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64C0BCA32B
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 18:14:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730157AbfJCQM4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:12:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:35410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733026AbfJCQMz (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:12:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 489D720700;
        Thu,  3 Oct 2019 16:12:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570119174;
        bh=MTK46FpyGPKbPHLvjBoao46uHGc2Ic6vn2kaUe0llbw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WmczT+6K6/8NN7cCfDH1gEyap3wY01wVO8eajdgKC6iU38Xm5UppW6A5RKFlgpLu+
         geNQ0ro9m+ajfVJnYtC7h87OcSj8SNfAdGeybbbw0j7wHNy4StLHD2V7sKxrVk3rXX
         Kk8Iw+rlyHD5xBM5gZHkoSzfR7VQMAQZBwlb1ilg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nadav Amit <nadav.amit@gmail.com>,
        Doug Reiland <doug.reiland@intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Peter Xu <peterx@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 4.14 152/185] KVM: x86: Manually calculate reserved bits when loading PDPTRS
Date:   Thu,  3 Oct 2019 17:53:50 +0200
Message-Id: <20191003154513.729711402@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154437.541662648@linuxfoundation.org>
References: <20191003154437.541662648@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

commit 16cfacc8085782dab8e365979356ce1ca87fd6cc upstream.

Manually generate the PDPTR reserved bit mask when explicitly loading
PDPTRs.  The reserved bits that are being tracked by the MMU reflect the
current paging mode, which is unlikely to be PAE paging in the vast
majority of flows that use load_pdptrs(), e.g. CR0 and CR4 emulation,
__set_sregs(), etc...  This can cause KVM to incorrectly signal a bad
PDPTR, or more likely, miss a reserved bit check and subsequently fail
a VM-Enter due to a bad VMCS.GUEST_PDPTR.

Add a one off helper to generate the reserved bits instead of sharing
code across the MMU's calculations and the PDPTR emulation.  The PDPTR
reserved bits are basically set in stone, and pushing a helper into
the MMU's calculation adds unnecessary complexity without improving
readability.

Oppurtunistically fix/update the comment for load_pdptrs().

Note, the buggy commit also introduced a deliberate functional change,
"Also remove bit 5-6 from rsvd_bits_mask per latest SDM.", which was
effectively (and correctly) reverted by commit cd9ae5fe47df ("KVM: x86:
Fix page-tables reserved bits").  A bit of SDM archaeology shows that
the SDM from late 2008 had a bug (likely a copy+paste error) where it
listed bits 6:5 as AVL and A for PDPTEs used for 4k entries but reserved
for 2mb entries.  I.e. the SDM contradicted itself, and bits 6:5 are and
always have been reserved.

Fixes: 20c466b56168d ("KVM: Use rsvd_bits_mask in load_pdptrs()")
Cc: stable@vger.kernel.org
Cc: Nadav Amit <nadav.amit@gmail.com>
Reported-by: Doug Reiland <doug.reiland@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Reviewed-by: Peter Xu <peterx@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/x86.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -563,8 +563,14 @@ static int kvm_read_nested_guest_page(st
 				       data, offset, len, access);
 }
 
+static inline u64 pdptr_rsvd_bits(struct kvm_vcpu *vcpu)
+{
+	return rsvd_bits(cpuid_maxphyaddr(vcpu), 63) | rsvd_bits(5, 8) |
+	       rsvd_bits(1, 2);
+}
+
 /*
- * Load the pae pdptrs.  Return true is they are all valid.
+ * Load the pae pdptrs.  Return 1 if they are all valid, 0 otherwise.
  */
 int load_pdptrs(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu, unsigned long cr3)
 {
@@ -583,8 +589,7 @@ int load_pdptrs(struct kvm_vcpu *vcpu, s
 	}
 	for (i = 0; i < ARRAY_SIZE(pdpte); ++i) {
 		if ((pdpte[i] & PT_PRESENT_MASK) &&
-		    (pdpte[i] &
-		     vcpu->arch.mmu.guest_rsvd_check.rsvd_bits_mask[0][2])) {
+		    (pdpte[i] & pdptr_rsvd_bits(vcpu))) {
 			ret = 0;
 			goto out;
 		}


