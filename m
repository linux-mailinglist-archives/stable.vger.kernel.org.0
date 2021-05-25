Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFF0B39018F
	for <lists+stable@lfdr.de>; Tue, 25 May 2021 15:01:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233022AbhEYNDX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 May 2021 09:03:23 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:13036 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232957AbhEYNDU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 May 2021 09:03:20 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14PCXVYx114734;
        Tue, 25 May 2021 09:01:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=zIkVztrnPmlK/T8hJBotAxR4HEjLOirSp4kgEg6fN5c=;
 b=IZvOmcjyxaco8w5x7a4nbXccFb35V8r5iDNZKXFR6wZf39zf+fTw4KZOr8eXoV78ZQkp
 ywtC6sW0Yhl+9xId1LcvixBMXYF86T7Jj03VMJINoCN0Oz1Qe1HelEfzgD0VI421E6bX
 C9uNWFO/jCuiaLaWkrBU918Ka6szXyCzLEF9UA/FoxY3W2au4XdtCbVO2Xk+sE/1TRzf
 mbzlypg3reB/1Nrz37HTZkerdB4YViafiBq2ydMvfX29hxkpcvgFs6cjyX/Z7NjI9QUG
 H6WmZb+iOpUBFVnmnLzAEB4b2y84biihqdIyUM2B/16aU68oWYDQO/7u8MNOY4W5QVb7 Rw== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38rxhvxwb6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 May 2021 09:01:37 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 14PCrE8C020940;
        Tue, 25 May 2021 13:01:35 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03ams.nl.ibm.com with ESMTP id 38s1jn80et-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 May 2021 13:01:34 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14PD1Wia30146888
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 May 2021 13:01:32 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BDE69AE055;
        Tue, 25 May 2021 13:01:32 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 77EAAAE053;
        Tue, 25 May 2021 13:01:32 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 25 May 2021 13:01:32 +0000 (GMT)
From:   Gerald Schaefer <gerald.schaefer@linux.ibm.com>
To:     Andrew Morton <akpm@linux-foundation.org>,
        Anshuman Khandual <anshuman.khandual@arm.com>
Cc:     linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        linux-sparc <sparclinux@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        stable@vger.kernel.org
Subject: [PATCH 1/1] mm/debug_vm_pgtable: fix alignment for pmd/pud_advanced_tests()
Date:   Tue, 25 May 2021 15:00:43 +0200
Message-Id: <20210525130043.186290-2-gerald.schaefer@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210525130043.186290-1-gerald.schaefer@linux.ibm.com>
References: <20210525130043.186290-1-gerald.schaefer@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: vrHywXj5uRP7xuHWWp7JNYeHqoBJuFrN
X-Proofpoint-ORIG-GUID: vrHywXj5uRP7xuHWWp7JNYeHqoBJuFrN
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-25_06:2021-05-25,2021-05-25 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 bulkscore=0
 impostorscore=0 mlxscore=0 malwarescore=0 suspectscore=0 mlxlogscore=999
 spamscore=0 lowpriorityscore=0 adultscore=0 priorityscore=1501
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105250077
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In pmd/pud_advanced_tests(), the vaddr is aligned up to the next pmd/pud
entry, and so it does not match the given pmdp/pudp and (aligned down) pfn
any more.

For s390, this results in memory corruption, because the IDTE instruction
used e.g. in xxx_get_and_clear() will take the vaddr for some calculations,
in combination with the given pmdp. It will then end up with a wrong table
origin, ending on ...ff8, and some of those wrongly set low-order bits will
also select a wrong pagetable level for the index addition. IDTE could
therefore invalidate (or 0x20) something outside of the page tables,
depending on the wrongly picked index, which in turn depends on the random
vaddr.

As result, we sometimes see "BUG task_struct (Not tainted): Padding
overwritten" on s390, where one 0x5a padding value got overwritten with
0x7a.

Fix this by aligning down, similar to how the pmd/pud_aligned pfns are
calculated.

Fixes: a5c3b9ffb0f40 ("mm/debug_vm_pgtable: add tests validating advanced arch page table helpers")
Cc: <stable@vger.kernel.org> # v5.9+
Signed-off-by: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
---
 mm/debug_vm_pgtable.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/debug_vm_pgtable.c b/mm/debug_vm_pgtable.c
index 6ff92c8b0a00..f7b23565a04f 100644
--- a/mm/debug_vm_pgtable.c
+++ b/mm/debug_vm_pgtable.c
@@ -193,7 +193,7 @@ static void __init pmd_advanced_tests(struct mm_struct *mm,
 
 	pr_debug("Validating PMD advanced\n");
 	/* Align the address wrt HPAGE_PMD_SIZE */
-	vaddr = (vaddr & HPAGE_PMD_MASK) + HPAGE_PMD_SIZE;
+	vaddr &= HPAGE_PMD_MASK;
 
 	pgtable_trans_huge_deposit(mm, pmdp, pgtable);
 
@@ -318,7 +318,7 @@ static void __init pud_advanced_tests(struct mm_struct *mm,
 
 	pr_debug("Validating PUD advanced\n");
 	/* Align the address wrt HPAGE_PUD_SIZE */
-	vaddr = (vaddr & HPAGE_PUD_MASK) + HPAGE_PUD_SIZE;
+	vaddr &= HPAGE_PUD_MASK;
 
 	pud = pfn_pud(pfn, prot);
 	set_pud_at(mm, vaddr, pudp, pud);
-- 
2.25.1

