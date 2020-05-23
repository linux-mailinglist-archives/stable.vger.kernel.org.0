Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D0FF1DFA8D
	for <lists+stable@lfdr.de>; Sat, 23 May 2020 21:02:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728020AbgEWTCA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 May 2020 15:02:00 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:62458 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728012AbgEWTB7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 May 2020 15:01:59 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04NIUuSa089412;
        Sat, 23 May 2020 15:01:53 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 316wypknmc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 23 May 2020 15:01:53 -0400
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 04NIfidY112748;
        Sat, 23 May 2020 15:01:52 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 316wypknkp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 23 May 2020 15:01:52 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 04NJ12H9009287;
        Sat, 23 May 2020 19:01:50 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04ams.nl.ibm.com with ESMTP id 316uf8s3qu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 23 May 2020 19:01:50 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 04NJ1mfF58720388
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 23 May 2020 19:01:48 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 791F2A4053;
        Sat, 23 May 2020 19:01:48 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9ED9FA4055;
        Sat, 23 May 2020 19:01:47 +0000 (GMT)
Received: from linux.ibm.com (unknown [9.148.201.18])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Sat, 23 May 2020 19:01:47 +0000 (GMT)
Date:   Sat, 23 May 2020 22:01:45 +0300
From:   Mike Rapoport <rppt@linux.ibm.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     davem@davemloft.net, linux-mm@kvack.org, lkp@intel.com,
        matorola@gmail.com, mm-commits@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: [patch 09/11] sparc32: use PUD rather than PGD to get PMD in
 srmmu_nocache_init()
Message-ID: <20200523190145.GX1059226@linux.ibm.com>
References: <20200522222217.ee14ad7eda7aab1e6697da6c@linux-foundation.org>
 <20200523052309.4caVN81-C%akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200523052309.4caVN81-C%akpm@linux-foundation.org>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-23_09:2020-05-22,2020-05-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 impostorscore=0 phishscore=0 adultscore=0 clxscore=1011 malwarescore=0
 lowpriorityscore=0 suspectscore=2 priorityscore=1501 spamscore=0
 mlxscore=0 bulkscore=0 cotscore=-2147483648 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005230151
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 22, 2020 at 10:23:09PM -0700, Andrew Morton wrote:
> From: Mike Rapoport <rppt@linux.ibm.com>
> Subject: sparc32: use PUD rather than PGD to get PMD in srmmu_nocache_init()
> 
> The kbuild test robot reported the following warning:
> 
> arch/sparc/mm/srmmu.c: In function 'srmmu_nocache_init':
> >> arch/sparc/mm/srmmu.c:300:9: error: variable 'pud' set but not used
> >> [-Werror=unused-but-set-variable]
> 300 |  pud_t *pud;
> 
> This warning is caused by misprint in the page table traversal in
> srmmu_nocache_init() function which accessed a PMD entry using PGD rather
> than PUD.
> 
> Since sparc32 has only 3 page table levels, the PGD and PUD are
> essentially the same and usage of __nocache_fix() removed the type
> checking.
> 
> Use PUD for the consistency and to silence the compiler warning.

Unfortunately, this fixes a compile warning but breaks the boot :(

Since pgd, p4d and pud are eesentially the same thing and pgd_offset()
and p4d_offset() are no-ops, the __nocache_fix() should be done only at
pud level.

The correcteted patch is below, boot tested with qemu-systems-sparc.

> Link: http://lkml.kernel.org/r/20200520132005.GM1059226@linux.ibm.com
> Fixes: 7235db268a2777bc38 ("sparc32: use pgtable-nopud instead of 4level-fixup")
> Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
> Reported-by: kbuild test robot <lkp@intel.com>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Anatoly Pugachev <matorola@gmail.com>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---

From 9b8b3214f7f079864dca0c6a7b684ab442eeb437 Mon Sep 17 00:00:00 2001
From: Mike Rapoport <rppt@linux.ibm.com>
Date: Wed, 20 May 2020 15:39:22 +0300
Subject: [PATCH] sparc32: use PUD rather than PGD to get PMD in  srmmu_nocache_init()

The kbuild test robot reported the following warning:

arch/sparc/mm/srmmu.c: In function 'srmmu_nocache_init':
>> arch/sparc/mm/srmmu.c:300:9: error: variable 'pud' set but not used
>> [-Werror=unused-but-set-variable]
300 |  pud_t *pud;

This warning is caused by misprint in the page table traversal in
srmmu_nocache_init() function which accessed a PMD entry using PGD rather
than PUD.

Since pgd, p4d and pud are eesentially the same thing and pgd_offset()
and p4d_offset() are no-ops, the __nocache_fix() should be done only at
pud level.

Remove __nocache_fix() for p4d_offset() and pud_offset() and use it only
for PUD and lower levels.

Link: http://lkml.kernel.org/r/20200520132005.GM1059226@linux.ibm.com
Fixes: 7235db268a2777bc38 ("sparc32: use pgtable-nopud instead of 4level-fixup")
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Reported-by: kbuild test robot <lkp@intel.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Anatoly Pugachev <matorola@gmail.com>
Cc: <stable@vger.kernel.org>
---
 arch/sparc/mm/srmmu.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/sparc/mm/srmmu.c b/arch/sparc/mm/srmmu.c
index 6cb1ea2d2b5c..3d9690d940a3 100644
--- a/arch/sparc/mm/srmmu.c
+++ b/arch/sparc/mm/srmmu.c
@@ -302,9 +302,9 @@ static void __init srmmu_nocache_init(void)
 
 	while (vaddr < srmmu_nocache_end) {
 		pgd = pgd_offset_k(vaddr);
-		p4d = p4d_offset(__nocache_fix(pgd), vaddr);
-		pud = pud_offset(__nocache_fix(p4d), vaddr);
-		pmd = pmd_offset(__nocache_fix(pgd), vaddr);
+		p4d = p4d_offset(pgd, vaddr);
+		pud = pud_offset(p4d, vaddr);
+		pmd = pmd_offset(__nocache_fix(pud), vaddr);
 		pte = pte_offset_kernel(__nocache_fix(pmd), vaddr);
 
 		pteval = ((paddr >> 4) | SRMMU_ET_PTE | SRMMU_PRIV);
-- 
2.26.2

