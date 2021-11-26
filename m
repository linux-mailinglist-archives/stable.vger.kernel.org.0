Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7522645F2C3
	for <lists+stable@lfdr.de>; Fri, 26 Nov 2021 18:17:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235317AbhKZRVA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Nov 2021 12:21:00 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:28660 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230334AbhKZRS5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Nov 2021 12:18:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637946944;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JjbjPQPAvqdhPGFRDSb1vU4+b5m/8f/mEnd8iBTapH8=;
        b=aeu3ePi/VNtTWXYcZvo7GVaRhWyzHxF7su7JYirjh6zYHyg/o1hTDAjHazcrJ/D4lyYkWz
        PYoD3s3kcV4wyFDYSF8NJumYzQrPs6iK8nLz+eNn6BVfNJHGGudrm/XTPlHKwZ8QoEiCpg
        2e2Bs3zNepdLnHhU7310Hmsrgj2Jmck=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-458-syuTy5jrOh6XMcxzUSLANA-1; Fri, 26 Nov 2021 12:15:41 -0500
X-MC-Unique: syuTy5jrOh6XMcxzUSLANA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0112E1006AAA;
        Fri, 26 Nov 2021 17:15:40 +0000 (UTC)
Received: from t480s.redhat.com (unknown [10.39.193.226])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3BB065D9C0;
        Fri, 26 Nov 2021 17:15:38 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     stable@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        borntraeger@de.ibm.com, hca@linux.ibm.com, imbrenda@linux.ibm.com,
        David Hildenbrand <david@redhat.com>
Subject: [PATCH for 4.14-stable] s390/mm: validate VMA in PGSTE manipulation functions
Date:   Fri, 26 Nov 2021 18:15:36 +0100
Message-Id: <20211126171536.22963-1-david@redhat.com>
In-Reply-To: <16371715631177@kroah.com>
References: <16371715631177@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit fe3d10024073f06f04c74b9674bd71ccc1d787cf upstream.

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
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 arch/s390/mm/pgtable.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/s390/mm/pgtable.c b/arch/s390/mm/pgtable.c
index ae677f814bc0..aa6b9487c8bb 100644
--- a/arch/s390/mm/pgtable.c
+++ b/arch/s390/mm/pgtable.c
@@ -896,6 +896,7 @@ EXPORT_SYMBOL(get_guest_storage_key);
 int pgste_perform_essa(struct mm_struct *mm, unsigned long hva, int orc,
 			unsigned long *oldpte, unsigned long *oldpgste)
 {
+	struct vm_area_struct *vma;
 	unsigned long pgstev;
 	spinlock_t *ptl;
 	pgste_t pgste;
@@ -905,6 +906,10 @@ int pgste_perform_essa(struct mm_struct *mm, unsigned long hva, int orc,
 	WARN_ON_ONCE(orc > ESSA_MAX);
 	if (unlikely(orc > ESSA_MAX))
 		return -EINVAL;
+
+	vma = find_vma(mm, hva);
+	if (!vma || hva < vma->vm_start || is_vm_hugetlb_page(vma))
+		return -EFAULT;
 	ptep = get_locked_pte(mm, hva, &ptl);
 	if (unlikely(!ptep))
 		return -EFAULT;
@@ -997,10 +1002,14 @@ EXPORT_SYMBOL(pgste_perform_essa);
 int set_pgste_bits(struct mm_struct *mm, unsigned long hva,
 			unsigned long bits, unsigned long value)
 {
+	struct vm_area_struct *vma;
 	spinlock_t *ptl;
 	pgste_t new;
 	pte_t *ptep;
 
+	vma = find_vma(mm, hva);
+	if (!vma || hva < vma->vm_start || is_vm_hugetlb_page(vma))
+		return -EFAULT;
 	ptep = get_locked_pte(mm, hva, &ptl);
 	if (unlikely(!ptep))
 		return -EFAULT;
@@ -1025,9 +1034,13 @@ EXPORT_SYMBOL(set_pgste_bits);
  */
 int get_pgste(struct mm_struct *mm, unsigned long hva, unsigned long *pgstep)
 {
+	struct vm_area_struct *vma;
 	spinlock_t *ptl;
 	pte_t *ptep;
 
+	vma = find_vma(mm, hva);
+	if (!vma || hva < vma->vm_start || is_vm_hugetlb_page(vma))
+		return -EFAULT;
 	ptep = get_locked_pte(mm, hva, &ptl);
 	if (unlikely(!ptep))
 		return -EFAULT;
-- 
2.31.1

