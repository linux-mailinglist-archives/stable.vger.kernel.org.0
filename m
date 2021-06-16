Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAEE93A90C4
	for <lists+stable@lfdr.de>; Wed, 16 Jun 2021 06:53:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229543AbhFPEzn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Jun 2021 00:55:43 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:62406 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229514AbhFPEzn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Jun 2021 00:55:43 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15G4YPsa149932;
        Wed, 16 Jun 2021 00:53:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=tc89fYQdCp9ax4IUM9ps4kro+EJ0GdbMKmJn/1p3f/I=;
 b=B2yo8tWQi0fpDcJEQeqn8/jntEVlhWXLAi2KxR1K3ANyv+dy5mTP2pQBsgaGl91zGAvh
 hY4VNDHMeMHbDkU2xKTMdj+yy4PoHnw5Mx46zMKgO3obcjihsz5QHafSGlwpDqsx0HAq
 PE/XFc78xDrZMREf2AfAPZFdmfYOY9UrvTkghUwQTobeYTCu+YtBO+PDUkffI7WlF6Ls
 +rdM1QvmgLSeKgzadWFQGH58U8AJm4UA+Ajo/Oc/4ZDSLaBERCNCXyRBKY+u5EC1lvDi
 tMm7kcX7QZWoAAnpY40HzgicjsD0gJAkExcOiuydF/21GnUauHWu3auyF3dtUaIt5ehn Hg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 397a3x0ns8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Jun 2021 00:53:23 -0400
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 15G4ZFqP152620;
        Wed, 16 Jun 2021 00:53:23 -0400
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0b-001b2d01.pphosted.com with ESMTP id 397a3x0ns1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Jun 2021 00:53:23 -0400
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15G4pdSi025626;
        Wed, 16 Jun 2021 04:53:22 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma03dal.us.ibm.com with ESMTP id 394mj9vt50-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Jun 2021 04:53:22 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15G4rLYt21627344
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Jun 2021 04:53:21 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5A2497805F;
        Wed, 16 Jun 2021 04:53:21 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 896FF7805C;
        Wed, 16 Jun 2021 04:53:13 +0000 (GMT)
Received: from skywalker.ibmuc.com (unknown [9.85.71.33])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Wed, 16 Jun 2021 04:53:13 +0000 (GMT)
From:   "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
To:     linux-mm@kvack.org, akpm@linux-foundation.org
Cc:     mpe@ellerman.id.au, linuxppc-dev@lists.ozlabs.org,
        kaleshsingh@google.com, npiggin@gmail.com, joel@joelfernandes.org,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        stable@vger.kernel.org, Hugh Dickins <hughd@google.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCH v2 6/6] mm/mremap: hold the rmap lock in write mode when moving page table entries.
Date:   Wed, 16 Jun 2021 10:22:39 +0530
Message-Id: <20210616045239.370802-7-aneesh.kumar@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210616045239.370802-1-aneesh.kumar@linux.ibm.com>
References: <20210616045239.370802-1-aneesh.kumar@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: dG1wX7yp2fpqt8q68AijO8KF2N2e6tsD
X-Proofpoint-GUID: _IsyhOz3r46yHPOdLz28EYZU4134jYpS
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-15_09:2021-06-15,2021-06-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 clxscore=1011
 bulkscore=0 phishscore=0 impostorscore=0 priorityscore=1501 malwarescore=0
 lowpriorityscore=0 mlxscore=0 spamscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106160027
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

To avoid a race between rmap walk and mremap, mremap does take_rmap_locks().
The lock was taken to ensure that rmap walk don't miss a page table entry due to
PTE moves via move_pagetables(). The kernel does further optimization of
this lock such that if we are going to find the newly added vma after the
old vma, the rmap lock is not taken. This is because rmap walk would find the
vmas in the same order and if we don't find the page table attached to
older vma we would find it with the new vma which we would iterate later.

As explained in commit eb66ae030829 ("mremap: properly flush TLB before releasing the page")
mremap is special in that it doesn't take ownership of the page. The
optimized version for PUD/PMD aligned mremap also doesn't hold the ptl lock.
This can result in stale TLB entries as show below.

This patch updates the rmap locking requirement in mremap to handle the race condition
explained below with optimized mremap::

Optmized PMD move

    CPU 1                           CPU 2                                   CPU 3

    mremap(old_addr, new_addr)      page_shrinker/try_to_unmap_one

    mmap_write_lock_killable()

                                    addr = old_addr
                                    lock(pte_ptl)
    lock(pmd_ptl)
    pmd = *old_pmd
    pmd_clear(old_pmd)
    flush_tlb_range(old_addr)

    *new_pmd = pmd
                                                                            *new_addr = 10; and fills
                                                                            TLB with new addr
                                                                            and old pfn

    unlock(pmd_ptl)
                                    ptep_clear_flush()
                                    old pfn is free.
                                                                            Stale TLB entry

Optimized PUD move also suffers from a similar race.
Both the above race condition can be fixed if we force mremap path to take rmap lock.

Cc: stable@vger.kernel.org
Fixes: 2c91bd4a4e2e ("mm: speed up mremap by 20x on large regions")
Fixes: c49dd3401802 ("mm: speedup mremap on 1GB or larger regions")
Link: https://lore.kernel.org/linux-mm/CAHk-=wgXVR04eBNtxQfevontWnP6FDm+oj5vauQXP3S-huwbPw@mail.gmail.com
Acked-by: Hugh Dickins <hughd@google.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
---
 mm/mremap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/mremap.c b/mm/mremap.c
index 72fa0491681e..c3cad539a7aa 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -503,7 +503,7 @@ unsigned long move_page_tables(struct vm_area_struct *vma,
 		} else if (IS_ENABLED(CONFIG_HAVE_MOVE_PUD) && extent == PUD_SIZE) {
 
 			if (move_pgt_entry(NORMAL_PUD, vma, old_addr, new_addr,
-					   old_pud, new_pud, need_rmap_locks))
+					   old_pud, new_pud, true))
 				continue;
 		}
 
@@ -530,7 +530,7 @@ unsigned long move_page_tables(struct vm_area_struct *vma,
 			 * moving at the PMD level if possible.
 			 */
 			if (move_pgt_entry(NORMAL_PMD, vma, old_addr, new_addr,
-					   old_pmd, new_pmd, need_rmap_locks))
+					   old_pmd, new_pmd, true))
 				continue;
 		}
 
-- 
2.31.1

