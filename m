Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E01EF2700A9
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 17:15:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725955AbgIRPPs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Sep 2020 11:15:48 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:4906 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726139AbgIRPPs (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Sep 2020 11:15:48 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08IF13rZ183685;
        Fri, 18 Sep 2020 11:15:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 content-transfer-encoding : in-reply-to; s=pp1;
 bh=bGHOI5nKzy+2/MrUFcXHTL0ZBrnwhKHB2NOqeMUWcss=;
 b=WTDZTCSrmMuWm89bo95ZDWboc1kNCxWhUpVEEiu8WualcBbEYonFjufXbcKOGAl/y4KT
 RZnW3Y2AqN7XRLMVkPjq2XoGSpoGjBkcrIRJayTNdnBnfjIN4p7ykMZkwVc9so6IkwYm
 n9/OG9hFPX6fEsiwBU0x/N+aIaT9ptC6idq5TvAf1bxyJuy+ACx9GW10SfJeih1/kE/t
 1QHSV0sK6Mvw+THMTm53QXohSfHi98TQ5R3iDqyCiy4gta+p0E3OpF2V1dE1GBJW0HNu
 +F5K5odTzFGu77LL3YgcwFTBK1vELlZ13QnLMBp9mkfJMRO1zsijuPSDLRP+jlInrEh7 lg== 
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0b-001b2d01.pphosted.com with ESMTP id 33mx4m2qsn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 18 Sep 2020 11:15:42 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08IFDn7o005132;
        Fri, 18 Sep 2020 15:15:40 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma01fra.de.ibm.com with ESMTP id 33k5v99qck-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 18 Sep 2020 15:15:40 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08IFFccL28180952
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Sep 2020 15:15:38 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EFAC852057;
        Fri, 18 Sep 2020 15:15:37 +0000 (GMT)
Received: from localhost (unknown [9.145.8.164])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTPS id 8BD4652054;
        Fri, 18 Sep 2020 15:15:37 +0000 (GMT)
Date:   Fri, 18 Sep 2020 17:15:36 +0200
From:   Vasily Gorbik <gor@linux.ibm.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        stable@vger.kernel.org
Subject: [PATCH stable-5.4.y backport] mm/gup: fix gup_fast with dynamic page
 table folding
Message-ID: <patch-1.thread-41918b.git-41918be365c0.your-ad-here.call-01600439945-ext-8991@work.hours>
References: <20200917155334.09651208E4@mail.kernel.org>
 <cover.thread-41918b.your-ad-here.call-01600439945-ext-8991@work.hours>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cover.thread-41918b.your-ad-here.call-01600439945-ext-8991@work.hours>
X-Patchwork-Bot: notify
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-18_14:2020-09-16,2020-09-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 mlxscore=0
 bulkscore=0 impostorscore=0 malwarescore=0 clxscore=1015 suspectscore=0
 priorityscore=1501 adultscore=0 mlxlogscore=999 lowpriorityscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009180119
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Currently to make sure that every page table entry is read just once
gup_fast walks perform READ_ONCE and pass pXd value down to the next
gup_pXd_range function by value e.g.:

static int gup_pud_range(p4d_t p4d, unsigned long addr, unsigned long end,
                         unsigned int flags, struct page **pages, int *nr)
...
        pudp = pud_offset(&p4d, addr);

This function passes a reference on that local value copy to pXd_offset,
and might get the very same pointer in return.  This happens when the
level is folded (on most arches), and that pointer should not be iterated.

On s390 due to the fact that each task might have different 5,4 or 3-level
address translation and hence different levels folded the logic is more
complex and non-iteratable pointer to a local copy leads to severe
problems.

Here is an example of what happens with gup_fast on s390, for a task with
3-levels paging, crossing a 2 GB pud boundary:

// addr = 0x1007ffff000, end = 0x10080001000
static int gup_pud_range(p4d_t p4d, unsigned long addr, unsigned long end,
                         unsigned int flags, struct page **pages, int *nr)
{
        unsigned long next;
        pud_t *pudp;

        // pud_offset returns &p4d itself (a pointer to a value on stack)
        pudp = pud_offset(&p4d, addr);
        do {
                // on second iteratation reading "random" stack value
                pud_t pud = READ_ONCE(*pudp);

                // next = 0x10080000000, due to PUD_SIZE/MASK != PGDIR_SIZE/MASK on s390
                next = pud_addr_end(addr, end);
                ...
        } while (pudp++, addr = next, addr != end); // pudp++ iterating over stack

        return 1;
}

This happens since s390 moved to common gup code with commit d1874a0c2805
("s390/mm: make the pxd_offset functions more robust") and commit
1a42010cdc26 ("s390/mm: convert to the generic get_user_pages_fast code").
s390 tried to mimic static level folding by changing pXd_offset
primitives to always calculate top level page table offset in pgd_offset
and just return the value passed when pXd_offset has to act as folded.

What is crucial for gup_fast and what has been overlooked is that
PxD_SIZE/MASK and thus pXd_addr_end should also change correspondingly.
And the latter is not possible with dynamic folding.

To fix the issue in addition to pXd values pass original pXdp pointers
down to gup_pXd_range functions.  And introduce pXd_offset_lockless
helpers, which take an additional pXd entry value parameter.  This has
already been discussed in
https://lkml.kernel.org/r/20190418100218.0a4afd51@mschwideX1

Link: https://lkml.kernel.org/r/patch.git-943f1e5dcff2.your-ad-here.call-01599856292-ext-8676@work.hours
Fixes: 1a42010cdc26 ("s390/mm: convert to the generic get_user_pages_fast code")
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Reviewed-by: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Reviewed-by: Alexander Gordeev <agordeev@linux.ibm.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Mike Rapoport <rppt@linux.ibm.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: <stable@vger.kernel.org>	[5.2+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---
 arch/s390/include/asm/pgtable.h | 42 +++++++++++++++++++++++----------
 include/asm-generic/pgtable.h   | 10 ++++++++
 mm/gup.c                        | 18 +++++++-------
 3 files changed, 49 insertions(+), 21 deletions(-)

diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
index 34a655ad7123..a03862579d6b 100644
--- a/arch/s390/include/asm/pgtable.h
+++ b/arch/s390/include/asm/pgtable.h
@@ -1247,25 +1247,43 @@ static inline pgd_t *pgd_offset_raw(pgd_t *pgd, unsigned long address)
 #define pgd_offset(mm, address) pgd_offset_raw(READ_ONCE((mm)->pgd), address)
 #define pgd_offset_k(address) pgd_offset(&init_mm, address)
 
-static inline p4d_t *p4d_offset(pgd_t *pgd, unsigned long address)
+static inline p4d_t *p4d_offset_lockless(pgd_t *pgdp, pgd_t pgd, unsigned long address)
 {
-	if ((pgd_val(*pgd) & _REGION_ENTRY_TYPE_MASK) >= _REGION_ENTRY_TYPE_R1)
-		return (p4d_t *) pgd_deref(*pgd) + p4d_index(address);
-	return (p4d_t *) pgd;
+	if ((pgd_val(pgd) & _REGION_ENTRY_TYPE_MASK) >= _REGION_ENTRY_TYPE_R1)
+		return (p4d_t *) pgd_deref(pgd) + p4d_index(address);
+	return (p4d_t *) pgdp;
 }
+#define p4d_offset_lockless p4d_offset_lockless
 
-static inline pud_t *pud_offset(p4d_t *p4d, unsigned long address)
+static inline p4d_t *p4d_offset(pgd_t *pgdp, unsigned long address)
 {
-	if ((p4d_val(*p4d) & _REGION_ENTRY_TYPE_MASK) >= _REGION_ENTRY_TYPE_R2)
-		return (pud_t *) p4d_deref(*p4d) + pud_index(address);
-	return (pud_t *) p4d;
+	return p4d_offset_lockless(pgdp, *pgdp, address);
 }
 
-static inline pmd_t *pmd_offset(pud_t *pud, unsigned long address)
+static inline pud_t *pud_offset_lockless(p4d_t *p4dp, p4d_t p4d, unsigned long address)
 {
-	if ((pud_val(*pud) & _REGION_ENTRY_TYPE_MASK) >= _REGION_ENTRY_TYPE_R3)
-		return (pmd_t *) pud_deref(*pud) + pmd_index(address);
-	return (pmd_t *) pud;
+	if ((p4d_val(p4d) & _REGION_ENTRY_TYPE_MASK) >= _REGION_ENTRY_TYPE_R2)
+		return (pud_t *) p4d_deref(p4d) + pud_index(address);
+	return (pud_t *) p4dp;
+}
+#define pud_offset_lockless pud_offset_lockless
+
+static inline pud_t *pud_offset(p4d_t *p4dp, unsigned long address)
+{
+	return pud_offset_lockless(p4dp, *p4dp, address);
+}
+
+static inline pmd_t *pmd_offset_lockless(pud_t *pudp, pud_t pud, unsigned long address)
+{
+	if ((pud_val(pud) & _REGION_ENTRY_TYPE_MASK) >= _REGION_ENTRY_TYPE_R3)
+		return (pmd_t *) pud_deref(pud) + pmd_index(address);
+	return (pmd_t *) pudp;
+}
+#define pmd_offset_lockless pmd_offset_lockless
+
+static inline pmd_t *pmd_offset(pud_t *pudp, unsigned long address)
+{
+	return pmd_offset_lockless(pudp, *pudp, address);
 }
 
 static inline pte_t *pte_offset(pmd_t *pmd, unsigned long address)
diff --git a/include/asm-generic/pgtable.h b/include/asm-generic/pgtable.h
index 818691846c90..1423f08c6ba9 100644
--- a/include/asm-generic/pgtable.h
+++ b/include/asm-generic/pgtable.h
@@ -1187,4 +1187,14 @@ static inline bool arch_has_pfn_modify_check(void)
 #define mm_pmd_folded(mm)	__is_defined(__PAGETABLE_PMD_FOLDED)
 #endif
 
+#ifndef p4d_offset_lockless
+#define p4d_offset_lockless(pgdp, pgd, address) p4d_offset(&(pgd), address)
+#endif
+#ifndef pud_offset_lockless
+#define pud_offset_lockless(p4dp, p4d, address) pud_offset(&(p4d), address)
+#endif
+#ifndef pmd_offset_lockless
+#define pmd_offset_lockless(pudp, pud, address) pmd_offset(&(pud), address)
+#endif
+
 #endif /* _ASM_GENERIC_PGTABLE_H */
diff --git a/mm/gup.c b/mm/gup.c
index 4a8e969a6e59..3ef769529548 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -2184,13 +2184,13 @@ static int gup_huge_pgd(pgd_t orig, pgd_t *pgdp, unsigned long addr,
 	return 1;
 }
 
-static int gup_pmd_range(pud_t pud, unsigned long addr, unsigned long end,
+static int gup_pmd_range(pud_t *pudp, pud_t pud, unsigned long addr, unsigned long end,
 		unsigned int flags, struct page **pages, int *nr)
 {
 	unsigned long next;
 	pmd_t *pmdp;
 
-	pmdp = pmd_offset(&pud, addr);
+	pmdp = pmd_offset_lockless(pudp, pud, addr);
 	do {
 		pmd_t pmd = READ_ONCE(*pmdp);
 
@@ -2227,13 +2227,13 @@ static int gup_pmd_range(pud_t pud, unsigned long addr, unsigned long end,
 	return 1;
 }
 
-static int gup_pud_range(p4d_t p4d, unsigned long addr, unsigned long end,
+static int gup_pud_range(p4d_t *p4dp, p4d_t p4d, unsigned long addr, unsigned long end,
 			 unsigned int flags, struct page **pages, int *nr)
 {
 	unsigned long next;
 	pud_t *pudp;
 
-	pudp = pud_offset(&p4d, addr);
+	pudp = pud_offset_lockless(p4dp, p4d, addr);
 	do {
 		pud_t pud = READ_ONCE(*pudp);
 
@@ -2248,20 +2248,20 @@ static int gup_pud_range(p4d_t p4d, unsigned long addr, unsigned long end,
 			if (!gup_huge_pd(__hugepd(pud_val(pud)), addr,
 					 PUD_SHIFT, next, flags, pages, nr))
 				return 0;
-		} else if (!gup_pmd_range(pud, addr, next, flags, pages, nr))
+		} else if (!gup_pmd_range(pudp, pud, addr, next, flags, pages, nr))
 			return 0;
 	} while (pudp++, addr = next, addr != end);
 
 	return 1;
 }
 
-static int gup_p4d_range(pgd_t pgd, unsigned long addr, unsigned long end,
+static int gup_p4d_range(pgd_t *pgdp, pgd_t pgd, unsigned long addr, unsigned long end,
 			 unsigned int flags, struct page **pages, int *nr)
 {
 	unsigned long next;
 	p4d_t *p4dp;
 
-	p4dp = p4d_offset(&pgd, addr);
+	p4dp = p4d_offset_lockless(pgdp, pgd, addr);
 	do {
 		p4d_t p4d = READ_ONCE(*p4dp);
 
@@ -2273,7 +2273,7 @@ static int gup_p4d_range(pgd_t pgd, unsigned long addr, unsigned long end,
 			if (!gup_huge_pd(__hugepd(p4d_val(p4d)), addr,
 					 P4D_SHIFT, next, flags, pages, nr))
 				return 0;
-		} else if (!gup_pud_range(p4d, addr, next, flags, pages, nr))
+		} else if (!gup_pud_range(p4dp, p4d, addr, next, flags, pages, nr))
 			return 0;
 	} while (p4dp++, addr = next, addr != end);
 
@@ -2301,7 +2301,7 @@ static void gup_pgd_range(unsigned long addr, unsigned long end,
 			if (!gup_huge_pd(__hugepd(pgd_val(pgd)), addr,
 					 PGDIR_SHIFT, next, flags, pages, nr))
 				return;
-		} else if (!gup_p4d_range(pgd, addr, next, flags, pages, nr))
+		} else if (!gup_p4d_range(pgdp, pgd, addr, next, flags, pages, nr))
 			return;
 	} while (pgdp++, addr = next, addr != end);
 }
-- 
⣿⣿⣿⣿⢋⡀⣀⠹⣿⣿⣿⣿
⣿⣿⣿⣿⠠⣶⡦⠀⣿⣿⣿⣿
⣿⣿⣿⠏⣴⣮⣴⣧⠈⢿⣿⣿
⣿⣿⡏⢰⣿⠖⣠⣿⡆⠈⣿⣿
⣿⢛⣵⣄⠙⣶⣶⡟⣅⣠⠹⣿
⣿⣜⣛⠻⢎⣉⣉⣀⠿⣫⣵⣿
