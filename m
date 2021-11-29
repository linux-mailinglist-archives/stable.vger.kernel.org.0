Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38697462795
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 00:05:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236509AbhK2XIF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 18:08:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236010AbhK2XHU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 18:07:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE108C125CCE;
        Mon, 29 Nov 2021 10:27:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6688BB815D5;
        Mon, 29 Nov 2021 18:27:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98DE6C53FCD;
        Mon, 29 Nov 2021 18:27:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210469;
        bh=FlXA4wkfmX4mHoqBQwMhHXdzQfuSBHqUkpwURfqOY9o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LtwK34NuaOqARymxiBHBU8lCcCJe+vNYzeTvixcZydxO+z9O5ba78hAXUKuDBE+sC
         s2/5/1RJI7JcHPFmU0tlRnhUxxsqX12leMiNhAS1AQtr1GLVhVXWMf4HXYygkmfCvk
         4o7k7TJ9AzIyvWbXBRpBkkl6c7febNg8m6OEUZ+0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [PATCH 5.4 80/92] s390/mm: validate VMA in PGSTE manipulation functions
Date:   Mon, 29 Nov 2021 19:18:49 +0100
Message-Id: <20211129181710.076570690@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181707.392764191@linuxfoundation.org>
References: <20211129181707.392764191@linuxfoundation.org>
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
@@ -970,6 +970,7 @@ EXPORT_SYMBOL(get_guest_storage_key);
 int pgste_perform_essa(struct mm_struct *mm, unsigned long hva, int orc,
 			unsigned long *oldpte, unsigned long *oldpgste)
 {
+	struct vm_area_struct *vma;
 	unsigned long pgstev;
 	spinlock_t *ptl;
 	pgste_t pgste;
@@ -979,6 +980,10 @@ int pgste_perform_essa(struct mm_struct
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
@@ -1071,10 +1076,14 @@ EXPORT_SYMBOL(pgste_perform_essa);
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
@@ -1099,9 +1108,13 @@ EXPORT_SYMBOL(set_pgste_bits);
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


