Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC71F461EA3
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 19:36:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353411AbhK2Siq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 13:38:46 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:53618 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379013AbhK2Sge (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 13:36:34 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id D3D3FCE157F;
        Mon, 29 Nov 2021 18:33:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82271C53FD0;
        Mon, 29 Nov 2021 18:33:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210793;
        bh=Zb8ifKlzWNXeZ8yM4Hq0X0BJEtNmuR1DIE0wPXoNHKw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IU8m9iPSfqjgn1VYbYN8N79erTagOOoTCvRIgGtjZaxR7dMvDPlHQG1uvGNQY7jHO
         b79POLbJqOMnddQuzer7Ns4gSosgmtnkBKJr/WHkPYfLx8rqiEWmkULDLXM4/kaxJV
         9CbQnSl6/jPIZuYafVaE6HWSLPTE2wroYhXi+290=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [PATCH 5.10 118/121] s390/mm: validate VMA in PGSTE manipulation functions
Date:   Mon, 29 Nov 2021 19:19:09 +0100
Message-Id: <20211129181715.636136621@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181711.642046348@linuxfoundation.org>
References: <20211129181711.642046348@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Hildenbrand <david@redhat.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/s390/mm/pgtable.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

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
@@ -997,6 +998,10 @@ int pgste_perform_essa(struct mm_struct
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
@@ -1089,10 +1094,14 @@ EXPORT_SYMBOL(pgste_perform_essa);
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
@@ -1117,9 +1126,13 @@ EXPORT_SYMBOL(set_pgste_bits);
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


