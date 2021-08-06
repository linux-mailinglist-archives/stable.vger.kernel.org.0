Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9F4B3E2519
	for <lists+stable@lfdr.de>; Fri,  6 Aug 2021 10:17:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243877AbhHFIRh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Aug 2021 04:17:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:46174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231823AbhHFIQF (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Aug 2021 04:16:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B9BFD61167;
        Fri,  6 Aug 2021 08:15:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628237749;
        bh=zQV37iLZUQpmTgGqLJyg26WRtdpfR90zV+yIoY3A9vI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EVJU4l+EMqMuGvlRapjsdj5+EDCjKLUiD9qX2fJyITPaAD56WVI81GMAqifNVCoFg
         d32Sk0P9YNVg9HcsgvCJqUBE7q2P4idd453Ai5WOvQHmNEnPHhmK8Uuf24crLz8IJd
         6DxI4Y3BFXNYloZIDE4y7QvR9Esh7Dizksd5pXlY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Stevens <stevensd@google.com>,
        3pvd@google.com, Jann Horn <jannh@google.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 4.14 08/11] KVM: do not assume PTE is writable after follow_pfn
Date:   Fri,  6 Aug 2021 10:14:51 +0200
Message-Id: <20210806081110.785046751@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210806081110.511221879@linuxfoundation.org>
References: <20210806081110.511221879@linuxfoundation.org>
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
[OP: backport to 4.14, adjust follow_pte() -> follow_pte_pmd()]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 virt/kvm/kvm_main.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1491,9 +1491,11 @@ static int hva_to_pfn_remapped(struct vm
 			       kvm_pfn_t *p_pfn)
 {
 	unsigned long pfn;
+	pte_t *ptep;
+	spinlock_t *ptl;
 	int r;
 
-	r = follow_pfn(vma, addr, &pfn);
+	r = follow_pte_pmd(vma->vm_mm, addr, NULL, NULL, &ptep, NULL, &ptl);
 	if (r) {
 		/*
 		 * get_user_pages fails for VM_IO and VM_PFNMAP vmas and does
@@ -1508,14 +1510,19 @@ static int hva_to_pfn_remapped(struct vm
 		if (r)
 			return r;
 
-		r = follow_pfn(vma, addr, &pfn);
+		r = follow_pte_pmd(vma->vm_mm, addr, NULL, NULL, &ptep, NULL, &ptl);
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
@@ -1530,6 +1537,8 @@ static int hva_to_pfn_remapped(struct vm
 	 */ 
 	kvm_get_pfn(pfn);
 
+out:
+	pte_unmap_unlock(ptep, ptl);
 	*p_pfn = pfn;
 	return 0;
 }


