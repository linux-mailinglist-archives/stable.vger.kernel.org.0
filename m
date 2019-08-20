Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D949D96A32
	for <lists+stable@lfdr.de>; Tue, 20 Aug 2019 22:24:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729950AbfHTUXw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Aug 2019 16:23:52 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:19148 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730088AbfHTUXv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Aug 2019 16:23:51 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7KKMvtY010130
        for <stable@vger.kernel.org>; Tue, 20 Aug 2019 13:23:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=jObesXKggt5JGXaZ0VMUjP8B5+A1J+eZwFaxZ+FinwI=;
 b=NodbgSEs2ODM30qAs9QTTUsFXeTNrDR6nvYyarRKl+ZfeH/Ps2Yw4vGhQUBC6JR2pbr/
 S0X9KEHHGM39wA0R//5xWUxoPM8yG4gCJL4uoUq4+ozRzX3S7h9YVb3k72IRm0gPY5ua
 qeMqitv0hsFOZTwqqIlhrDfmxqJdBgkpw/I= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2ugqcn84mc-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <stable@vger.kernel.org>; Tue, 20 Aug 2019 13:23:50 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 20 Aug 2019 13:23:47 -0700
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id 4A47362E2A14; Tue, 20 Aug 2019 13:23:47 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Song Liu <songliubraving@fb.com>
Smtp-Origin-Hostname: devbig006.ftw2.facebook.com
To:     <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
CC:     <kernel-team@fb.com>, Song Liu <songliubraving@fb.com>,
        <stable@vger.kernel.org>, Joerg Roedel <jroedel@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2] x86/mm/pti: in pti_clone_pgtable(), increase addr properly
Date:   Tue, 20 Aug 2019 13:23:14 -0700
Message-ID: <20190820202314.1083149-1-songliubraving@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-20_09:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=804 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908200182
X-FB-Internal: deliver
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Before 32-bit support, pti_clone_pmds() always adds PMD_SIZE to addr.
This behavior changes after the 32-bit support:  pti_clone_pgtable()
increases addr by PUD_SIZE for pud_none(*pud) case, and increases addr by
PMD_SIZE for pmd_none(*pmd) case. However, this is not accurate because
addr may not be PUD_SIZE/PMD_SIZE aligned.

Fix this issue by properly rounding up addr to next PUD_SIZE/PMD_SIZE
in these two cases.

The following explains how we debugged this issue:

We use huge page for hot text and thus reduces iTLB misses. As we
benchmark 5.2 based kernel (vs. 4.16 based), we found ~2.5x more
iTLB misses.

To figure out the issue, I use a debug patch that dumps page table for
a pid. The following are information from the workload pid.

For the 4.16 based kernel:

host-4.16 # grep "x  pmd" /sys/kernel/debug/page_tables/dump_pid
0x0000000000600000-0x0000000000e00000           8M USR ro         PSE         x  pmd
0xffffffff81a00000-0xffffffff81c00000           2M     ro         PSE         x  pmd

For the 5.2 based kernel before this patch:

host-5.2-before # grep "x  pmd" /sys/kernel/debug/page_tables/dump_pid
0x0000000000600000-0x0000000000e00000           8M USR ro         PSE         x  pmd

The 8MB text in pmd is from user space. 4.16 kernel has 1 pmd for the
irq entry table; while 4.16 kernel doesn't have it.

For the 5.2 based kernel after this patch:

host-5.2-after # grep "x  pmd" /sys/kernel/debug/page_tables/dump_pid
0x0000000000600000-0x0000000000e00000           8M USR ro         PSE         x  pmd
0xffffffff81000000-0xffffffff81e00000          14M     ro         PSE     GLB x  pmd

So after this patch, the 5.2 based kernel has 7 PMDs instead of 1 PMD
in 4.16 kernel. This further reduces iTLB miss rate

Cc: stable@vger.kernel.org # v4.19+
Fixes: 16a3fe634f6a ("x86/mm/pti: Clone kernel-image on PTE level for 32 bit")
Reviewed-by: Rik van Riel <riel@surriel.com>
Signed-off-by: Song Liu <songliubraving@fb.com>
Cc: Joerg Roedel <jroedel@suse.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
---
 arch/x86/mm/pti.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/pti.c b/arch/x86/mm/pti.c
index b196524759ec..1337494e22ef 100644
--- a/arch/x86/mm/pti.c
+++ b/arch/x86/mm/pti.c
@@ -330,13 +330,13 @@ pti_clone_pgtable(unsigned long start, unsigned long end,
 
 		pud = pud_offset(p4d, addr);
 		if (pud_none(*pud)) {
-			addr += PUD_SIZE;
+			addr = round_up(addr + 1, PUD_SIZE);
 			continue;
 		}
 
 		pmd = pmd_offset(pud, addr);
 		if (pmd_none(*pmd)) {
-			addr += PMD_SIZE;
+			addr = round_up(addr + 1, PMD_SIZE);
 			continue;
 		}
 
-- 
2.17.1

