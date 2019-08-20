Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1F59958E4
	for <lists+stable@lfdr.de>; Tue, 20 Aug 2019 09:51:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729210AbfHTHvg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Aug 2019 03:51:36 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:29630 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728595AbfHTHvf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Aug 2019 03:51:35 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7K7njSI029594
        for <stable@vger.kernel.org>; Tue, 20 Aug 2019 00:51:35 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=NdN+ZDMV6cVKAsWdTWSaLrD9VOB5N6fSXCo/EOCkxFQ=;
 b=YeDYM8WAG3No/5UtcvOxnM31qeYGu3zCPpWpcFoxyjehF3LmYVMqebhG8fBuWF3t+N24
 wV3pAeo8mct0Zp1R2KTVymmuZ7jTyBwj+LGthGU8KOap4QrVAIMgVKJbW9A5xDpjOTWh
 vQNnPEuJqRM+pdqksRK/jcwIK0PREaU9Pv4= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2ug9stgk52-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Tue, 20 Aug 2019 00:51:34 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::127) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Tue, 20 Aug 2019 00:51:33 -0700
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id 0559462E2CCB; Tue, 20 Aug 2019 00:51:31 -0700 (PDT)
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
Subject: [PATCH] x86/mm/pti: in pti_clone_pgtable() don't increase addr by PUD_SIZE
Date:   Tue, 20 Aug 2019 00:51:28 -0700
Message-ID: <20190820075128.2912224-1-songliubraving@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-20_02:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=571 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908200084
X-FB-Internal: deliver
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

pti_clone_pgtable() increases addr by PUD_SIZE for pud_none(*pud) case.
This is not accurate because addr may not be PUD_SIZE aligned.

In our x86_64 kernel, pti_clone_pgtable() fails to clone 7 PMDs because
of this issuse, including PMD for the irq entry table. For a memcache
like workload, this introduces about 4.5x more iTLB-load and about 2.5x
more iTLB-load-misses on a Skylake CPU.

This patch fixes this issue by adding PMD_SIZE to addr for pud_none()
case.

Cc: stable@vger.kernel.org # v4.19+
Fixes: 16a3fe634f6a ("x86/mm/pti: Clone kernel-image on PTE level for 32 bit")
Signed-off-by: Song Liu <songliubraving@fb.com>
Cc: Joerg Roedel <jroedel@suse.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
---
 arch/x86/mm/pti.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/mm/pti.c b/arch/x86/mm/pti.c
index b196524759ec..5a67c3015f59 100644
--- a/arch/x86/mm/pti.c
+++ b/arch/x86/mm/pti.c
@@ -330,7 +330,7 @@ pti_clone_pgtable(unsigned long start, unsigned long end,
 
 		pud = pud_offset(p4d, addr);
 		if (pud_none(*pud)) {
-			addr += PUD_SIZE;
+			addr += PMD_SIZE;
 			continue;
 		}
 
-- 
2.17.1

