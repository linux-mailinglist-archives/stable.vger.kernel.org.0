Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 624CE452376
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:23:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352024AbhKPB0o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:26:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:33630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243663AbhKOTCQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:02:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9B60A63353;
        Mon, 15 Nov 2021 18:14:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637000087;
        bh=OmMCTiSUUcF2dtLqGp6YNkVAGmq9iEo1aWCTDzEm34M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zLMHKlEwbqKk6gy1zfEpuHpiO8XSRGQigaLi47IyznQ2nGbQggwxBuMsDEScDZHBO
         oE+jLQO4CxNsBCgPLsT29/v04m/cIfzMYDMASQekjKRTn6BgkRrbte0ef0EGc6dNP9
         Agw+530FaCsRuzD4IBq/fdODifmpMuhho7rdtaJU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 500/849] s390/mm: fix VMA and page table handling code in storage key handling functions
Date:   Mon, 15 Nov 2021 17:59:43 +0100
Message-Id: <20211115165437.188838307@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Hildenbrand <david@redhat.com>

[ Upstream commit 949f5c1244ee6c36d2e81c588d1200eaa83a3df6 ]

There are multiple things broken about our storage key handling
functions:

1. We should not walk/touch page tables outside of VMA boundaries when
   holding only the mmap sem in read mode. Evil user space can modify the
   VMA layout just before this function runs and e.g., trigger races with
   page table removal code since commit dd2283f2605e ("mm: mmap: zap pages
   with read mmap_sem in munmap"). gfn_to_hva() will only translate using
   KVM memory regions, but won't validate the VMA.

2. We should not allocate page tables outside of VMA boundaries: if
   evil user space decides to map hugetlbfs to these ranges, bad things
   will happen because we suddenly have PTE or PMD page tables where we
   shouldn't have them.

3. We don't handle large PUDs that might suddenly appeared inside our page
   table hierarchy.

Don't manually allocate page tables, properly validate that we have VMA and
bail out on pud_large().

All callers of page table handling functions, except
get_guest_storage_key(), call fixup_user_fault() in case they
receive an -EFAULT and retry; this will allocate the necessary page tables
if required.

To keep get_guest_storage_key() working as expected and not requiring
kvm_s390_get_skeys() to call fixup_user_fault() distinguish between
"there is simply no page table or huge page yet and the key is assumed
to be 0" and "this is a fault to be reported".

Although commit 637ff9efe5ea ("s390/mm: Add huge pmd storage key handling")
introduced most of the affected code, it was actually already broken
before when using get_locked_pte() without any VMA checks.

Note: Ever since commit 637ff9efe5ea ("s390/mm: Add huge pmd storage key
handling") we can no longer set a guest storage key (for example from
QEMU during VM live migration) without actually resolving a fault.
Although we would have created most page tables, we would choke on the
!pmd_present(), requiring a call to fixup_user_fault(). I would
have thought that this is problematic in combination with postcopy life
migration ... but nobody noticed and this patch doesn't change the
situation. So maybe it's just fine.

Fixes: 9fcf93b5de06 ("KVM: S390: Create helper function get_guest_storage_key")
Fixes: 24d5dd0208ed ("s390/kvm: Provide function for setting the guest storage key")
Fixes: a7e19ab55ffd ("KVM: s390: handle missing storage-key facility")
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Acked-by: Heiko Carstens <hca@linux.ibm.com>
Link: https://lore.kernel.org/r/20210909162248.14969-5-david@redhat.com
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/mm/pgtable.c | 57 +++++++++++++++++++++++++++++-------------
 1 file changed, 39 insertions(+), 18 deletions(-)

diff --git a/arch/s390/mm/pgtable.c b/arch/s390/mm/pgtable.c
index 54969e0f3a944..5fb409ff78422 100644
--- a/arch/s390/mm/pgtable.c
+++ b/arch/s390/mm/pgtable.c
@@ -429,22 +429,36 @@ static inline pmd_t pmdp_flush_lazy(struct mm_struct *mm,
 }
 
 #ifdef CONFIG_PGSTE
-static pmd_t *pmd_alloc_map(struct mm_struct *mm, unsigned long addr)
+static int pmd_lookup(struct mm_struct *mm, unsigned long addr, pmd_t **pmdp)
 {
+	struct vm_area_struct *vma;
 	pgd_t *pgd;
 	p4d_t *p4d;
 	pud_t *pud;
-	pmd_t *pmd;
+
+	/* We need a valid VMA, otherwise this is clearly a fault. */
+	vma = vma_lookup(mm, addr);
+	if (!vma)
+		return -EFAULT;
 
 	pgd = pgd_offset(mm, addr);
-	p4d = p4d_alloc(mm, pgd, addr);
-	if (!p4d)
-		return NULL;
-	pud = pud_alloc(mm, p4d, addr);
-	if (!pud)
-		return NULL;
-	pmd = pmd_alloc(mm, pud, addr);
-	return pmd;
+	if (!pgd_present(*pgd))
+		return -ENOENT;
+
+	p4d = p4d_offset(pgd, addr);
+	if (!p4d_present(*p4d))
+		return -ENOENT;
+
+	pud = pud_offset(p4d, addr);
+	if (!pud_present(*pud))
+		return -ENOENT;
+
+	/* Large PUDs are not supported yet. */
+	if (pud_large(*pud))
+		return -EFAULT;
+
+	*pmdp = pmd_offset(pud, addr);
+	return 0;
 }
 #endif
 
@@ -778,8 +792,7 @@ int set_guest_storage_key(struct mm_struct *mm, unsigned long addr,
 	pmd_t *pmdp;
 	pte_t *ptep;
 
-	pmdp = pmd_alloc_map(mm, addr);
-	if (unlikely(!pmdp))
+	if (pmd_lookup(mm, addr, &pmdp))
 		return -EFAULT;
 
 	ptl = pmd_lock(mm, pmdp);
@@ -881,8 +894,7 @@ int reset_guest_reference_bit(struct mm_struct *mm, unsigned long addr)
 	pte_t *ptep;
 	int cc = 0;
 
-	pmdp = pmd_alloc_map(mm, addr);
-	if (unlikely(!pmdp))
+	if (pmd_lookup(mm, addr, &pmdp))
 		return -EFAULT;
 
 	ptl = pmd_lock(mm, pmdp);
@@ -935,15 +947,24 @@ int get_guest_storage_key(struct mm_struct *mm, unsigned long addr,
 	pmd_t *pmdp;
 	pte_t *ptep;
 
-	pmdp = pmd_alloc_map(mm, addr);
-	if (unlikely(!pmdp))
+	/*
+	 * If we don't have a PTE table and if there is no huge page mapped,
+	 * the storage key is 0.
+	 */
+	*key = 0;
+
+	switch (pmd_lookup(mm, addr, &pmdp)) {
+	case -ENOENT:
+		return 0;
+	case 0:
+		break;
+	default:
 		return -EFAULT;
+	}
 
 	ptl = pmd_lock(mm, pmdp);
 	if (!pmd_present(*pmdp)) {
-		/* Not yet mapped memory has a zero key */
 		spin_unlock(ptl);
-		*key = 0;
 		return 0;
 	}
 
-- 
2.33.0



