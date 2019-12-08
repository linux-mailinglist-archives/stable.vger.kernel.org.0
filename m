Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABC95116207
	for <lists+stable@lfdr.de>; Sun,  8 Dec 2019 14:57:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726806AbfLHNyn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Dec 2019 08:54:43 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60200 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726761AbfLHNym (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 8 Dec 2019 08:54:42 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1idx1C-0007e9-O3; Sun, 08 Dec 2019 13:54:38 +0000
Received: from ben by deadeye with local (Exim 4.93-RC1)
        (envelope-from <ben@decadent.org.uk>)
        id 1idx1B-0002Mu-Ff; Sun, 08 Dec 2019 13:54:37 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Nadav Amit" <nadav.amit@gmail.com>,
        "Doug Reiland" <doug.reiland@intel.com>,
        "Sean Christopherson" <sean.j.christopherson@intel.com>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        "Peter Xu" <peterx@redhat.com>
Date:   Sun, 08 Dec 2019 13:53:15 +0000
Message-ID: <lsq.1575813165.887619822@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 31/72] KVM: x86: Manually calculate reserved bits
 when loading PDPTRS
In-Reply-To: <lsq.1575813164.154362148@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.79-rc1 review patch.  If anyone has any objections, please let me know.

------------------

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
Cc: Nadav Amit <nadav.amit@gmail.com>
Reported-by: Doug Reiland <doug.reiland@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Reviewed-by: Peter Xu <peterx@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
[bwh: Backported to 3.16: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -465,8 +465,14 @@ int kvm_read_nested_guest_page(struct kv
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
@@ -485,7 +491,7 @@ int load_pdptrs(struct kvm_vcpu *vcpu, s
 	}
 	for (i = 0; i < ARRAY_SIZE(pdpte); ++i) {
 		if (is_present_gpte(pdpte[i]) &&
-		    (pdpte[i] & vcpu->arch.mmu.rsvd_bits_mask[0][2])) {
+		    (pdpte[i] & pdptr_rsvd_bits(vcpu))) {
 			ret = 0;
 			goto out;
 		}

