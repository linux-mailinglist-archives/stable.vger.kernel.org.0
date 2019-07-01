Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BAAF6231F9
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 13:09:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726126AbfETLJA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 07:09:00 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:42453 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725601AbfETLJA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 May 2019 07:09:00 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 3194A2ABE0;
        Mon, 20 May 2019 07:08:59 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 20 May 2019 07:08:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=ob/8b9
        +9Yh/KMrRcA8FZOXq03RW2bVJt6li8vdTKgzU=; b=PVTP+XRtgmu8X+w2ugTnFI
        kxsWipSEsub/Mf30DJU4VKKW2SnVa5K9CUNZtRbi/gwkWMgbOkzyVhFrt+gt9uyP
        Jsw8GpIiZhh5lr/lS/Kk7L5HpPII63c/DIepgvkoN0asjb3X3o5qtHREhYEwyd+N
        aodl86jW+jj7c0Y8tDK4ioN2faDHaUxbteZFlLCvo+6Rj/yqLerJeNPe78Kq/fxj
        ZxFdc+3OHgK9m3q0o/b9VAPVPBhHw5Ids/tsfxg+hq5XGlf3VOJJRI7AOtdfJGwW
        tB55UVtFfXfASxDxSnS0ceXWehUXMwq0rCcvh1RAwwopbNH4abJQonstYk7HmFnQ
        ==
X-ME-Sender: <xms:yoriXOccxd_omTB3uIU888ojeUvalF2S3zWNC2-dC60F8g3iUiWA5w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddruddtkedgfeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:yoriXORnk5pcgwIgetYxbUUlVNhZo9axi4UEV7sKe09SqFEocOX3Rg>
    <xmx:yoriXCx10z5R7P6PqM-vvlYf6MlK4hP6cCEeqJ3xiQH3vsJITiaQ1g>
    <xmx:yoriXEEDhRd0ZzxvWUy8OGtO4CUKkYwSswPSqdplmnNkf3jlSTTkzA>
    <xmx:y4riXFNIXKnYalqXk5nc-SbTVoh3SFRBAhUX2BbGdVdtTywaPe-_-Q>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5F3D980061;
        Mon, 20 May 2019 07:08:58 -0400 (EDT)
Subject: FAILED: patch "[PATCH] s390/mm: make the pxd_offset functions more robust" failed to apply to 4.19-stable tree
To:     schwidefsky@de.ibm.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 20 May 2019 13:08:54 +0200
Message-ID: <15583505344317@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From d1874a0c2805fcfa9162c972d6b7541e57adb542 Mon Sep 17 00:00:00 2001
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Date: Tue, 23 Apr 2019 10:51:12 +0200
Subject: [PATCH] s390/mm: make the pxd_offset functions more robust

Change the way how pgd_offset, p4d_offset, pud_offset and pmd_offset
walk the page tables. pgd_offset now always calculates the index for
the top-level page table and adds it to the pgd, this is either a
segment table offset for a 2-level setup, a region-3 offset for 3-levels,
region-2 offset for 4-levels, or a region-1 offset for a 5-level setup.
The other three functions p4d_offset, pud_offset and pmd_offset will
only add the respective offset if they dereference the passed pointer.

With the new way of walking the page tables a sequence like this from
mm/gup.c now works:

     pgdp = pgd_offset(current->mm, addr);
     pgd = READ_ONCE(*pgdp);
     p4dp = p4d_offset(&pgd, addr);
     p4d = READ_ONCE(*p4dp);
     pudp = pud_offset(&p4d, addr);
     pud = READ_ONCE(*pudp);
     pmdp = pmd_offset(&pud, addr);
     pmd = READ_ONCE(*pmdp);

Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>

diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
index 76dc344edb8c..d48be9c27df9 100644
--- a/arch/s390/include/asm/pgtable.h
+++ b/arch/s390/include/asm/pgtable.h
@@ -1204,42 +1204,67 @@ static inline pte_t mk_pte(struct page *page, pgprot_t pgprot)
 #define pmd_index(address) (((address) >> PMD_SHIFT) & (PTRS_PER_PMD-1))
 #define pte_index(address) (((address) >> PAGE_SHIFT) & (PTRS_PER_PTE-1))
 
-#define pgd_offset(mm, address) ((mm)->pgd + pgd_index(address))
-#define pgd_offset_k(address) pgd_offset(&init_mm, address)
-#define pgd_offset_raw(pgd, addr) ((pgd) + pgd_index(addr))
-
 #define pmd_deref(pmd) (pmd_val(pmd) & _SEGMENT_ENTRY_ORIGIN)
 #define pud_deref(pud) (pud_val(pud) & _REGION_ENTRY_ORIGIN)
 #define p4d_deref(pud) (p4d_val(pud) & _REGION_ENTRY_ORIGIN)
 #define pgd_deref(pgd) (pgd_val(pgd) & _REGION_ENTRY_ORIGIN)
 
-static inline p4d_t *p4d_offset(pgd_t *pgd, unsigned long address)
+/*
+ * The pgd_offset function *always* adds the index for the top-level
+ * region/segment table. This is done to get a sequence like the
+ * following to work:
+ *	pgdp = pgd_offset(current->mm, addr);
+ *	pgd = READ_ONCE(*pgdp);
+ *	p4dp = p4d_offset(&pgd, addr);
+ *	...
+ * The subsequent p4d_offset, pud_offset and pmd_offset functions
+ * only add an index if they dereferenced the pointer.
+ */
+static inline pgd_t *pgd_offset_raw(pgd_t *pgd, unsigned long address)
 {
-	p4d_t *p4d = (p4d_t *) pgd;
+	unsigned long rste;
+	unsigned int shift;
 
-	if ((pgd_val(*pgd) & _REGION_ENTRY_TYPE_MASK) == _REGION_ENTRY_TYPE_R1)
-		p4d = (p4d_t *) pgd_deref(*pgd);
-	return p4d + p4d_index(address);
+	/* Get the first entry of the top level table */
+	rste = pgd_val(*pgd);
+	/* Pick up the shift from the table type of the first entry */
+	shift = ((rste & _REGION_ENTRY_TYPE_MASK) >> 2) * 11 + 20;
+	return pgd + ((address >> shift) & (PTRS_PER_PGD - 1));
 }
 
-static inline pud_t *pud_offset(p4d_t *p4d, unsigned long address)
+#define pgd_offset(mm, address) pgd_offset_raw(READ_ONCE((mm)->pgd), address)
+#define pgd_offset_k(address) pgd_offset(&init_mm, address)
+
+static inline p4d_t *p4d_offset(pgd_t *pgd, unsigned long address)
 {
-	pud_t *pud = (pud_t *) p4d;
+	if ((pgd_val(*pgd) & _REGION_ENTRY_TYPE_MASK) >= _REGION_ENTRY_TYPE_R1)
+		return (p4d_t *) pgd_deref(*pgd) + p4d_index(address);
+	return (p4d_t *) pgd;
+}
 
-	if ((p4d_val(*p4d) & _REGION_ENTRY_TYPE_MASK) == _REGION_ENTRY_TYPE_R2)
-		pud = (pud_t *) p4d_deref(*p4d);
-	return pud + pud_index(address);
+static inline pud_t *pud_offset(p4d_t *p4d, unsigned long address)
+{
+	if ((p4d_val(*p4d) & _REGION_ENTRY_TYPE_MASK) >= _REGION_ENTRY_TYPE_R2)
+		return (pud_t *) p4d_deref(*p4d) + pud_index(address);
+	return (pud_t *) p4d;
 }
 
 static inline pmd_t *pmd_offset(pud_t *pud, unsigned long address)
 {
-	pmd_t *pmd = (pmd_t *) pud;
+	if ((pud_val(*pud) & _REGION_ENTRY_TYPE_MASK) >= _REGION_ENTRY_TYPE_R3)
+		return (pmd_t *) pud_deref(*pud) + pmd_index(address);
+	return (pmd_t *) pud;
+}
 
-	if ((pud_val(*pud) & _REGION_ENTRY_TYPE_MASK) == _REGION_ENTRY_TYPE_R3)
-		pmd = (pmd_t *) pud_deref(*pud);
-	return pmd + pmd_index(address);
+static inline pte_t *pte_offset(pmd_t *pmd, unsigned long address)
+{
+	return (pte_t *) pmd_deref(*pmd) + pte_index(address);
 }
 
+#define pte_offset_kernel(pmd, address) pte_offset(pmd, address)
+#define pte_offset_map(pmd, address) pte_offset_kernel(pmd, address)
+#define pte_unmap(pte) do { } while (0)
+
 #define pfn_pte(pfn,pgprot) mk_pte_phys(__pa((pfn) << PAGE_SHIFT),(pgprot))
 #define pte_pfn(x) (pte_val(x) >> PAGE_SHIFT)
 #define pte_page(x) pfn_to_page(pte_pfn(x))
@@ -1249,12 +1274,6 @@ static inline pmd_t *pmd_offset(pud_t *pud, unsigned long address)
 #define p4d_page(p4d) pfn_to_page(p4d_pfn(p4d))
 #define pgd_page(pgd) pfn_to_page(pgd_pfn(pgd))
 
-/* Find an entry in the lowest level page table.. */
-#define pte_offset(pmd, addr) ((pte_t *) pmd_deref(*(pmd)) + pte_index(addr))
-#define pte_offset_kernel(pmd, address) pte_offset(pmd,address)
-#define pte_offset_map(pmd, address) pte_offset_kernel(pmd, address)
-#define pte_unmap(pte) do { } while (0)
-
 static inline pmd_t pmd_wrprotect(pmd_t pmd)
 {
 	pmd_val(pmd) &= ~_SEGMENT_ENTRY_WRITE;
diff --git a/arch/s390/mm/gup.c b/arch/s390/mm/gup.c
index 2809d11c7a28..a5ffcb132191 100644
--- a/arch/s390/mm/gup.c
+++ b/arch/s390/mm/gup.c
@@ -18,7 +18,7 @@
  * inlines everything into a single function which results in too much
  * register pressure.
  */
-static inline int gup_pte_range(pmd_t *pmdp, pmd_t pmd, unsigned long addr,
+static inline int gup_pte_range(pmd_t pmd, unsigned long addr,
 		unsigned long end, int write, struct page **pages, int *nr)
 {
 	struct page *head, *page;
@@ -27,7 +27,7 @@ static inline int gup_pte_range(pmd_t *pmdp, pmd_t pmd, unsigned long addr,
 
 	mask = (write ? _PAGE_PROTECT : 0) | _PAGE_INVALID | _PAGE_SPECIAL;
 
-	ptep = ((pte_t *) pmd_deref(pmd)) + pte_index(addr);
+	ptep = pte_offset_map(&pmd, addr);
 	do {
 		pte = *ptep;
 		barrier();
@@ -93,16 +93,13 @@ static inline int gup_huge_pmd(pmd_t *pmdp, pmd_t pmd, unsigned long addr,
 }
 
 
-static inline int gup_pmd_range(pud_t *pudp, pud_t pud, unsigned long addr,
+static inline int gup_pmd_range(pud_t pud, unsigned long addr,
 		unsigned long end, int write, struct page **pages, int *nr)
 {
 	unsigned long next;
 	pmd_t *pmdp, pmd;
 
-	pmdp = (pmd_t *) pudp;
-	if ((pud_val(pud) & _REGION_ENTRY_TYPE_MASK) == _REGION_ENTRY_TYPE_R3)
-		pmdp = (pmd_t *) pud_deref(pud);
-	pmdp += pmd_index(addr);
+	pmdp = pmd_offset(&pud, addr);
 	do {
 		pmd = *pmdp;
 		barrier();
@@ -120,7 +117,7 @@ static inline int gup_pmd_range(pud_t *pudp, pud_t pud, unsigned long addr,
 			if (!gup_huge_pmd(pmdp, pmd, addr, next,
 					  write, pages, nr))
 				return 0;
-		} else if (!gup_pte_range(pmdp, pmd, addr, next,
+		} else if (!gup_pte_range(pmd, addr, next,
 					  write, pages, nr))
 			return 0;
 	} while (pmdp++, addr = next, addr != end);
@@ -166,16 +163,13 @@ static int gup_huge_pud(pud_t *pudp, pud_t pud, unsigned long addr,
 	return 1;
 }
 
-static inline int gup_pud_range(p4d_t *p4dp, p4d_t p4d, unsigned long addr,
+static inline int gup_pud_range(p4d_t p4d, unsigned long addr,
 		unsigned long end, int write, struct page **pages, int *nr)
 {
 	unsigned long next;
 	pud_t *pudp, pud;
 
-	pudp = (pud_t *) p4dp;
-	if ((p4d_val(p4d) & _REGION_ENTRY_TYPE_MASK) == _REGION_ENTRY_TYPE_R2)
-		pudp = (pud_t *) p4d_deref(p4d);
-	pudp += pud_index(addr);
+	pudp = pud_offset(&p4d, addr);
 	do {
 		pud = *pudp;
 		barrier();
@@ -186,7 +180,7 @@ static inline int gup_pud_range(p4d_t *p4dp, p4d_t p4d, unsigned long addr,
 			if (!gup_huge_pud(pudp, pud, addr, next, write, pages,
 					  nr))
 				return 0;
-		} else if (!gup_pmd_range(pudp, pud, addr, next, write, pages,
+		} else if (!gup_pmd_range(pud, addr, next, write, pages,
 					  nr))
 			return 0;
 	} while (pudp++, addr = next, addr != end);
@@ -194,23 +188,20 @@ static inline int gup_pud_range(p4d_t *p4dp, p4d_t p4d, unsigned long addr,
 	return 1;
 }
 
-static inline int gup_p4d_range(pgd_t *pgdp, pgd_t pgd, unsigned long addr,
+static inline int gup_p4d_range(pgd_t pgd, unsigned long addr,
 		unsigned long end, int write, struct page **pages, int *nr)
 {
 	unsigned long next;
 	p4d_t *p4dp, p4d;
 
-	p4dp = (p4d_t *) pgdp;
-	if ((pgd_val(pgd) & _REGION_ENTRY_TYPE_MASK) == _REGION_ENTRY_TYPE_R1)
-		p4dp = (p4d_t *) pgd_deref(pgd);
-	p4dp += p4d_index(addr);
+	p4dp = p4d_offset(&pgd, addr);
 	do {
 		p4d = *p4dp;
 		barrier();
 		next = p4d_addr_end(addr, end);
 		if (p4d_none(p4d))
 			return 0;
-		if (!gup_pud_range(p4dp, p4d, addr, next, write, pages, nr))
+		if (!gup_pud_range(p4d, addr, next, write, pages, nr))
 			return 0;
 	} while (p4dp++, addr = next, addr != end);
 
@@ -253,7 +244,7 @@ int __get_user_pages_fast(unsigned long start, int nr_pages, int write,
 		next = pgd_addr_end(addr, end);
 		if (pgd_none(pgd))
 			break;
-		if (!gup_p4d_range(pgdp, pgd, addr, next, write, pages, &nr))
+		if (!gup_p4d_range(pgd, addr, next, write, pages, &nr))
 			break;
 	} while (pgdp++, addr = next, addr != end);
 	local_irq_restore(flags);

