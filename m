Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A7BC2A5252
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 21:49:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731658AbgKCUsx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:48:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:40980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731657AbgKCUsw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:48:52 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2CAE722404;
        Tue,  3 Nov 2020 20:48:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436530;
        bh=sOS9JyeR6Rscudf+1ciDITmx5jn9OXADeMeDFYN+gRo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L7CLieNTUnnPNmC+IRq70wEAlBV/e/RJxAZeK7/0t6+N2iTZK5MriUB8RdfTwxkW4
         wBYx/xNDIQwSNT6iswhL+28cnC5zbsY0VTpZtO44y9nih3D1c9Fax7ksr3ZpafjA6f
         996/L9gcdqYfFE+MF+xFOavzZd9l/FsOV9hDKf/A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.9 263/391] powerpc: Fix random segfault when freeing hugetlb range
Date:   Tue,  3 Nov 2020 21:35:14 +0100
Message-Id: <20201103203404.769868838@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@csgroup.eu>

commit 542db12a9c42d1ce70c45091765e02f74c129f43 upstream.

The following random segfault is observed from time to time with
map_hugetlb selftest:

root@localhost:~# ./map_hugetlb 1 19
524288 kB hugepages
Mapping 1 Mbytes
Segmentation fault

[   31.219972] map_hugetlb[365]: segfault (11) at 117 nip 77974f8c lr 779a6834 code 1 in ld-2.23.so[77966000+21000]
[   31.220192] map_hugetlb[365]: code: 9421ffc0 480318d1 93410028 90010044 9361002c 93810030 93a10034 93c10038
[   31.220307] map_hugetlb[365]: code: 93e1003c 93210024 8123007c 81430038 <80e90004> 814a0004 7f443a14 813a0004
[   31.221911] BUG: Bad rss-counter state mm:(ptrval) type:MM_FILEPAGES val:33
[   31.229362] BUG: Bad rss-counter state mm:(ptrval) type:MM_ANONPAGES val:5

This fault is due to hugetlb_free_pgd_range() freeing page tables
that are also used by regular pages.

As explain in the comment at the beginning of
hugetlb_free_pgd_range(), the verification done in free_pgd_range()
on floor and ceiling is not done here, which means
hugetlb_free_pte_range() can free outside the expected range.

As the verification cannot be done in hugetlb_free_pgd_range(), it
must be done in hugetlb_free_pte_range().

Fixes: b250c8c08c79 ("powerpc/8xx: Manage 512k huge pages as standard pages.")
Cc: stable@vger.kernel.org
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/f0cb2a5477cd87d1eaadb128042e20aeb2bc2859.1598860677.git.christophe.leroy@csgroup.eu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/mm/hugetlbpage.c |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

--- a/arch/powerpc/mm/hugetlbpage.c
+++ b/arch/powerpc/mm/hugetlbpage.c
@@ -330,10 +330,24 @@ static void free_hugepd_range(struct mmu
 				 get_hugepd_cache_index(pdshift - shift));
 }
 
-static void hugetlb_free_pte_range(struct mmu_gather *tlb, pmd_t *pmd, unsigned long addr)
+static void hugetlb_free_pte_range(struct mmu_gather *tlb, pmd_t *pmd,
+				   unsigned long addr, unsigned long end,
+				   unsigned long floor, unsigned long ceiling)
 {
+	unsigned long start = addr;
 	pgtable_t token = pmd_pgtable(*pmd);
 
+	start &= PMD_MASK;
+	if (start < floor)
+		return;
+	if (ceiling) {
+		ceiling &= PMD_MASK;
+		if (!ceiling)
+			return;
+	}
+	if (end - 1 > ceiling - 1)
+		return;
+
 	pmd_clear(pmd);
 	pte_free_tlb(tlb, token, addr);
 	mm_dec_nr_ptes(tlb->mm);
@@ -363,7 +377,7 @@ static void hugetlb_free_pmd_range(struc
 			 */
 			WARN_ON(!IS_ENABLED(CONFIG_PPC_8xx));
 
-			hugetlb_free_pte_range(tlb, pmd, addr);
+			hugetlb_free_pte_range(tlb, pmd, addr, end, floor, ceiling);
 
 			continue;
 		}


