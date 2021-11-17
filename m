Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF01E454C89
	for <lists+stable@lfdr.de>; Wed, 17 Nov 2021 18:52:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239692AbhKQRzo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Nov 2021 12:55:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:48432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237331AbhKQRzo (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Nov 2021 12:55:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 438FC613A4;
        Wed, 17 Nov 2021 17:52:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637171565;
        bh=Jpbmh8aC5m6g4hLafveMFCAET2IEnYLDhOZ/YfbblQM=;
        h=Subject:To:Cc:From:Date:From;
        b=bzyYywKdnAZXrtOf4gZM6T/RZ5bhEndbQEksHBSBANvn4z5ArwVgqTZDD0rjiIwRp
         TdYROQYZc6386aDUVA3T88pT8Xuh/dszcVJiCokhhSRcqdxB2Co+4xmW1kcAwESC+5
         7h95/YmtoQr9l3orZH625jazni7IOrKtb0HaxVdc=
Subject: FAILED: patch "[PATCH] s390/mm: validate VMA in PGSTE manipulation functions" failed to apply to 4.14-stable tree
To:     david@redhat.com, borntraeger@de.ibm.com, hca@linux.ibm.com,
        imbrenda@linux.ibm.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 17 Nov 2021 18:52:43 +0100
Message-ID: <16371715631177@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From fe3d10024073f06f04c74b9674bd71ccc1d787cf Mon Sep 17 00:00:00 2001
From: David Hildenbrand <david@redhat.com>
Date: Thu, 9 Sep 2021 18:22:42 +0200
Subject: [PATCH] s390/mm: validate VMA in PGSTE manipulation functions

We should not walk/touch page tables outside of VMA boundaries when
holding only the mmap sem in read mode. Evil user space can modify the
VMA layout just before this function runs and e.g., trigger races with
page table removal code since commit dd2283f2605e ("mm: mmap: zap pages
with read mmap_sem in munmap"). gfn_to_hva() will only translate using
KVM memory regions, but won't validate the VMA.

Further, we should not allocate page tables outside of VMA boundaries: if
evil user space decides to map hugetlbfs to these ranges, bad things will
happen because we suddenly have PTE or PMD page tables where we
shouldn't have them.

Similarly, we have to check if we suddenly find a hugetlbfs VMA, before
calling get_locked_pte().

Fixes: 2d42f9477320 ("s390/kvm: Add PGSTE manipulation functions")
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Acked-by: Heiko Carstens <hca@linux.ibm.com>
Link: https://lore.kernel.org/r/20210909162248.14969-4-david@redhat.com
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>

diff --git a/arch/s390/mm/pgtable.c b/arch/s390/mm/pgtable.c
index 034721a68d8f..2717a406edeb 100644
--- a/arch/s390/mm/pgtable.c
+++ b/arch/s390/mm/pgtable.c
@@ -988,6 +988,7 @@ EXPORT_SYMBOL(get_guest_storage_key);
 int pgste_perform_essa(struct mm_struct *mm, unsigned long hva, int orc,
 			unsigned long *oldpte, unsigned long *oldpgste)
 {
+	struct vm_area_struct *vma;
 	unsigned long pgstev;
 	spinlock_t *ptl;
 	pgste_t pgste;
@@ -997,6 +998,10 @@ int pgste_perform_essa(struct mm_struct *mm, unsigned long hva, int orc,
 	WARN_ON_ONCE(orc > ESSA_MAX);
 	if (unlikely(orc > ESSA_MAX))
 		return -EINVAL;
+
+	vma = vma_lookup(mm, hva);
+	if (!vma || is_vm_hugetlb_page(vma))
+		return -EFAULT;
 	ptep = get_locked_pte(mm, hva, &ptl);
 	if (unlikely(!ptep))
 		return -EFAULT;
@@ -1089,10 +1094,14 @@ EXPORT_SYMBOL(pgste_perform_essa);
 int set_pgste_bits(struct mm_struct *mm, unsigned long hva,
 			unsigned long bits, unsigned long value)
 {
+	struct vm_area_struct *vma;
 	spinlock_t *ptl;
 	pgste_t new;
 	pte_t *ptep;
 
+	vma = vma_lookup(mm, hva);
+	if (!vma || is_vm_hugetlb_page(vma))
+		return -EFAULT;
 	ptep = get_locked_pte(mm, hva, &ptl);
 	if (unlikely(!ptep))
 		return -EFAULT;
@@ -1117,9 +1126,13 @@ EXPORT_SYMBOL(set_pgste_bits);
  */
 int get_pgste(struct mm_struct *mm, unsigned long hva, unsigned long *pgstep)
 {
+	struct vm_area_struct *vma;
 	spinlock_t *ptl;
 	pte_t *ptep;
 
+	vma = vma_lookup(mm, hva);
+	if (!vma || is_vm_hugetlb_page(vma))
+		return -EFAULT;
 	ptep = get_locked_pte(mm, hva, &ptl);
 	if (unlikely(!ptep))
 		return -EFAULT;

