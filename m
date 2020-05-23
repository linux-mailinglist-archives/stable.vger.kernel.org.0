Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AC5B1DFAD4
	for <lists+stable@lfdr.de>; Sat, 23 May 2020 21:57:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387883AbgEWT5d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 May 2020 15:57:33 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:44954 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387593AbgEWT5c (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 May 2020 15:57:32 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04NJWrRK024867;
        Sat, 23 May 2020 15:57:26 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 316xn3bngw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 23 May 2020 15:57:26 -0400
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 04NJX1CY025141;
        Sat, 23 May 2020 15:57:26 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 316xn3bngh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 23 May 2020 15:57:26 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 04NJtBhi018545;
        Sat, 23 May 2020 19:57:24 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma04ams.nl.ibm.com with ESMTP id 316uf8s5r5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 23 May 2020 19:57:24 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 04NJvMT816842838
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 23 May 2020 19:57:22 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1A820A4054;
        Sat, 23 May 2020 19:57:22 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3EEBBA405F;
        Sat, 23 May 2020 19:57:20 +0000 (GMT)
Received: from hump (unknown [9.148.201.18])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Sat, 23 May 2020 19:57:20 +0000 (GMT)
Received: by hump (sSMTP sendmail emulation); Sat, 23 May 2020 22:57:19 +0300
From:   Mike Rapoport <rppt@linux.ibm.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        Linux-MM <linux-mm@kvack.org>, kernel test robot <lkp@intel.com>,
        Anatoly Pugachev <matorola@gmail.com>,
        mm-commits@vger.kernel.org, stable <stable@vger.kernel.org>,
        Mike Rapoport <rppt@linux.ibm.com>
Subject: [PATCH] sparc32: fix page table traversal in srmmu_nocache_init()
Date:   Sat, 23 May 2020 22:57:18 +0300
Message-Id: <20200523195718.1479419-1-rppt@linux.ibm.com>
X-Mailer: git-send-email 2.25.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-23_11:2020-05-22,2020-05-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 adultscore=0
 malwarescore=0 priorityscore=1501 clxscore=1015 impostorscore=0
 lowpriorityscore=0 cotscore=-2147483648 phishscore=0 spamscore=0
 mlxscore=0 mlxlogscore=999 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005230163
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The srmmu_nocache_init() uses __nocache_fix() macro to add an offset to
page table entry to access srmmu_nocache_pool.

But since sparc32 has only three actual page table levels, pgd, p4d and
pud are essentially the same thing and pgd_offset() and p4d_offset() are
no-ops, the __nocache_fix() should be done only at PUD level.

Remove __nocache_fix() for p4d_offset() and pud_offset() and keep it only
for PUD and lower levels.

Fixes: c2bc26f7ca1f ("sparc32: use PUD rather than PGD to get PMD in srmmu_nocache_init()")
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Anatoly Pugachev <matorola@gmail.com>
Cc: <stable@vger.kernel.org>
---
 arch/sparc/mm/srmmu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/sparc/mm/srmmu.c b/arch/sparc/mm/srmmu.c
index e9f7af32da07..a8c2f2615fc6 100644
--- a/arch/sparc/mm/srmmu.c
+++ b/arch/sparc/mm/srmmu.c
@@ -331,8 +331,8 @@ static void __init srmmu_nocache_init(void)
 
 	while (vaddr < srmmu_nocache_end) {
 		pgd = pgd_offset_k(vaddr);
-		p4d = p4d_offset(__nocache_fix(pgd), vaddr);
-		pud = pud_offset(__nocache_fix(p4d), vaddr);
+		p4d = p4d_offset(pgd, vaddr);
+		pud = pud_offset(p4d, vaddr);
 		pmd = pmd_offset(__nocache_fix(pud), vaddr);
 		pte = pte_offset_kernel(__nocache_fix(pmd), vaddr);
 
-- 
2.26.2

