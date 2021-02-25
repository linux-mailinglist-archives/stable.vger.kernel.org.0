Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7011324D8E
	for <lists+stable@lfdr.de>; Thu, 25 Feb 2021 11:09:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234175AbhBYKFe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Feb 2021 05:05:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:34820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230467AbhBYKAs (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Feb 2021 05:00:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 65D8164F29;
        Thu, 25 Feb 2021 09:55:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614246947;
        bh=4A3BHObAfTViNydQm34vG+RuPr5iD54DS52w7kHNsPM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lU1IlSQC1r4UNTF7hhzGmcKMJd2DfKkInlYh4viI7CctyUn0RQs5k7S2neIs/MxvQ
         flLMQNZ1njzdg3PaaLLRGRRNgJR0ik6jg76OQVs/uYDFsvciD/GTydiY1VCz0m/QFW
         6h3wesCCxgTynr1hM5fkhad19tcjUXpy231Sb0iM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Stevens <stevensd@google.com>,
        3pvd@google.com, Jann Horn <jannh@google.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.4 11/17] KVM: do not assume PTE is writable after follow_pfn
Date:   Thu, 25 Feb 2021 10:53:56 +0100
Message-Id: <20210225092515.557115543@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210225092515.001992375@linuxfoundation.org>
References: <20210225092515.001992375@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

commit bd2fae8da794b55bf2ac02632da3a151b10e664c upstream.

In order to convert an HVA to a PFN, KVM usually tries to use
the get_user_pages family of functinso.  This however is not
possible for VM_IO vmas; in that case, KVM instead uses follow_pfn.

In doing this however KVM loses the information on whether the
PFN is writable.  That is usually not a problem because the main
use of VM_IO vmas with KVM is for BARs in PCI device assignment,
however it is a bug.  To fix it, use follow_pte and check pte_write
while under the protection of the PTE lock.  The information can
be used to fail hva_to_pfn_remapped or passed back to the
caller via *writable.

Usage of follow_pfn was introduced in commit add6a0cd1c5b ("KVM: MMU: try to fix
up page faults before giving up", 2016-07-05); however, even older version
have the same issue, all the way back to commit 2e2e3738af33 ("KVM:
Handle vma regions with no backing page", 2008-07-20), as they also did
not check whether the PFN was writable.

Fixes: 2e2e3738af33 ("KVM: Handle vma regions with no backing page")
Reported-by: David Stevens <stevensd@google.com>
Cc: 3pvd@google.com
Cc: Jann Horn <jannh@google.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 virt/kvm/kvm_main.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1599,9 +1599,11 @@ static int hva_to_pfn_remapped(struct vm
 			       kvm_pfn_t *p_pfn)
 {
 	unsigned long pfn;
+	pte_t *ptep;
+	spinlock_t *ptl;
 	int r;
 
-	r = follow_pfn(vma, addr, &pfn);
+	r = follow_pte(vma->vm_mm, addr, NULL, &ptep, NULL, &ptl);
 	if (r) {
 		/*
 		 * get_user_pages fails for VM_IO and VM_PFNMAP vmas and does
@@ -1616,14 +1618,19 @@ static int hva_to_pfn_remapped(struct vm
 		if (r)
 			return r;
 
-		r = follow_pfn(vma, addr, &pfn);
+		r = follow_pte(vma->vm_mm, addr, NULL, &ptep, NULL, &ptl);
 		if (r)
 			return r;
+	}
 
+	if (write_fault && !pte_write(*ptep)) {
+		pfn = KVM_PFN_ERR_RO_FAULT;
+		goto out;
 	}
 
 	if (writable)
-		*writable = true;
+		*writable = pte_write(*ptep);
+	pfn = pte_pfn(*ptep);
 
 	/*
 	 * Get a reference here because callers of *hva_to_pfn* and
@@ -1638,6 +1645,8 @@ static int hva_to_pfn_remapped(struct vm
 	 */ 
 	kvm_get_pfn(pfn);
 
+out:
+	pte_unmap_unlock(ptep, ptl);
 	*p_pfn = pfn;
 	return 0;
 }


