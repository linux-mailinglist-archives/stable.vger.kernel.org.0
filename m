Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 495892700A8
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 17:15:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726156AbgIRPPq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Sep 2020 11:15:46 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:39598 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725955AbgIRPPq (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Sep 2020 11:15:46 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08IF1thr114503;
        Fri, 18 Sep 2020 11:15:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 content-transfer-encoding : in-reply-to; s=pp1;
 bh=x/smr8g3weNVHvemqAdc4cubNEAnByCfBd2/ycOL8cA=;
 b=W7fszXkE9KRdrntYw1MuUk+SsyjtKfrE0ieYdadTb3jAWFP6doV+sbn6XHt6pLVXgsVa
 2QGVRbcYFoFR0SsTFa1p37xSMwrUN+fu+gX2iHOsn11O/wZlX75jRC0cojQv/uj6VrOh
 gHktKGIWjAvEY7x4KtcbUUuY2grxkELCjxCQyFCdcVr75dp9+Xh7oQZ2wTrVPWEE415d
 5ubOsDXfmpcbkIeb2tcUnZ8/sDO30B/pcQ6qkvxKfcT8DLuVIWbPl8YxjG0ai767wGdQ
 eed1iPt5NMy6W8GO9gl4dd2AXqmQ75NWKPdacaYDWAtUQujEvQ2aVIXg0S0tELl0/jj6 fQ== 
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0b-001b2d01.pphosted.com with ESMTP id 33mxvrh36h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 18 Sep 2020 11:15:39 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08IFDZAh005120;
        Fri, 18 Sep 2020 15:15:37 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma01fra.de.ibm.com with ESMTP id 33k5v99qcg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 18 Sep 2020 15:15:37 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08IFFZQk23003442
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Sep 2020 15:15:35 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 271CE52051;
        Fri, 18 Sep 2020 15:15:35 +0000 (GMT)
Received: from localhost (unknown [9.145.8.164])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTPS id BF73F52054;
        Fri, 18 Sep 2020 15:15:34 +0000 (GMT)
Date:   Fri, 18 Sep 2020 17:15:33 +0200
From:   Vasily Gorbik <gor@linux.ibm.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] mm/gup: fix gup_fast with dynamic page table folding
Message-ID: <cover.thread-41918b.your-ad-here.call-01600439945-ext-8991@work.hours>
References: <20200917155334.09651208E4@mail.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200917155334.09651208E4@mail.kernel.org>
X-Patchwork-Bot: notify
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-18_14:2020-09-16,2020-09-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 adultscore=0
 impostorscore=0 priorityscore=1501 mlxscore=0 clxscore=1011 spamscore=0
 mlxlogscore=999 bulkscore=0 lowpriorityscore=0 malwarescore=0
 suspectscore=1 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009180119
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 17, 2020 at 03:53:33PM +0000, Sasha Levin wrote:
> Hi
> 
> [This is an automated email]
> 
> This commit has been processed because it contains a "Fixes:" tag
> fixing commit: 1a42010cdc26 ("s390/mm: convert to the generic get_user_pages_fast code").
> 
> The bot has tested the following trees: v5.8.9, v5.4.65.
> 
> v5.8.9: Build OK!
> v5.4.65: Failed to apply! Possible dependencies:
>     051a7a94aaa9 ("arm64: hibernate: use get_safe_page directly")
>     13373f0e6580 ("arm64: hibernate: rename dst to page in create_safe_exec_page")
>     48c963e31bc6 ("KVM: arm/arm64: Release kvm->mmu_lock in loop to prevent starvation")
>     68ecabd0e680 ("arm64/mm: Use phys_to_page() to access pgtable memory")
>     8a0af66b35f8 ("arm: mm: add p?d_leaf() definitions")
>     974b9b2c68f3 ("mm: consolidate pte_index() and pte_offset_*() definitions")
>     a2c2e67923ec ("arm64: hibernate: add trans_pgd public functions")
>     a89d7ff933b0 ("arm64: hibernate: remove gotos as they are not needed")
>     d234332c2815 ("arm64: hibernate: pass the allocated pgdp to ttbr0")
>     e9f6376858b9 ("arm64: add support for folded p4d page tables")
> 
> 
> NOTE: The patch will not be queued to stable trees until it is upstream.
> 
> How should we proceed with this patch?

Patch contains Cc: <stable@vger.kernel.org> [5.2+], so a stable backport to
v5.4.y is also desired once upstream. A patch is self contained and has no
dependencies.

 arch/s390/include/asm/pgtable.h | 42 +++++++++++++++++++++++----------
 include/asm-generic/pgtable.h   | 10 ++++++++
 mm/gup.c                        | 18 +++++++-------
 3 files changed, 49 insertions(+), 21 deletions(-)

There are 2 trivial merge conflicts both for include/asm-generic/pgtable.h.
1. commit ca5999fde0a1 ("mm: introduce include/linux/pgtable.h")
   since v5.8
   it renamed include/asm-generic/pgtable.h => include/linux/pgtable.h

2. commit 93fab1b22ef7 ("mm: add generic p?d_leaf() macros")
   since v5.6
   introduced p?d_leaf() macros after mm_pmd_folded, so the bottom context
   of the hunk mismatch here:

diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index e8cbc2e795d5..90654cb63e9e 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -1427,6 +1427,16 @@ typedef unsigned int pgtbl_mod_mask;
 #define mm_pmd_folded(mm)჻·····__is_defined(__PAGETABLE_PMD_FOLDED)
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
 /*
  * p?d_leaf() - true if this entry is a final mapping to a physical address.
  * This differs from p?d_huge() by the fact that they are always available (if

Patch for a stable-5.4.y backport sent as a follow on.

Thank you,
Vasily

