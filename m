Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38949601335
	for <lists+stable@lfdr.de>; Mon, 17 Oct 2022 18:13:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230162AbiJQQND (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Oct 2022 12:13:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229775AbiJQQNB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Oct 2022 12:13:01 -0400
Received: from mx0a-00230701.pphosted.com (mx0a-00230701.pphosted.com [148.163.156.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 601E565E9
        for <stable@vger.kernel.org>; Mon, 17 Oct 2022 09:13:01 -0700 (PDT)
Received: from pps.filterd (m0297266.ppops.net [127.0.0.1])
        by mx0a-00230701.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29HF8XxM026263;
        Mon, 17 Oct 2022 09:12:44 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=pfptdkimsnps; bh=s0XINOAQXbIBhI7TzY3k8hGNCjNSg/n9SIwYo7AVQ9Q=;
 b=L3gJfnx1uspFWtlTnJXbAXn4/PqqgaMmTdmkKTBdL79elMRRbKr/GrgI0bdlTKpAy+vE
 mQf08m19v2QIROpZcAKssXra+iwFYKG+JepiYbvv+kbSDSiI0E7a+aq+Bz8l8OQPJDHS
 WR7D/ZzrB/MAIAsXLp5tQVxGBRLrPDdgKnB8D1UVqkYcgr9XXPq/YLd/dsQSIpX5y7uK
 /0zDSotckV3JGXyBp3/KxUGBTsq/dbVwWSwvddyvjJXY7uqxGpzbI5SI4C4laKhtGZE2
 tszVtWPlDZrG2uV3nYP/DHfvG4GHKb1L6Iyhc+FV8/mLXyim8/UQdlBwwONW10lFiCxk Eg== 
Received: from smtprelay-out1.synopsys.com (smtprelay-out1.synopsys.com [149.117.87.133])
        by mx0a-00230701.pphosted.com (PPS) with ESMTPS id 3k7v452hh8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 17 Oct 2022 09:12:44 -0700
Received: from mailhost.synopsys.com (sv1-mailhost2.synopsys.com [10.205.2.132])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "mailhost.synopsys.com", Issuer "SNPSica2" (verified OK))
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 40639C0103;
        Mon, 17 Oct 2022 16:12:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1666023163; bh=p5wijw1rO0bbKpnIWS6HHP+bomgJdjtj0aFWkbKLQUo=;
        h=From:To:Cc:Subject:Date:From;
        b=JOIa4HI8Kx7W7w7e+/MHRLjMAt7Ndnlr/tXiIsjuFZ4bZ92iAmp+bm9CS7Wb9BFq0
         UYoN89s+UgJSZ2YoekQgG5nOv7x0dBtQKsLe0Rsw5G1Upc0S3YRjUNRtqp6Gma0Nge
         HKATY3QeQMVL6fpANFVZAARa/Yzf27rbUQo7CHelcYoURE0dzfXiOywblhMrbTzUDX
         PtR3d9GpItBcEgsgEHuL8D5TUhJgPiJsE9UwUn4Buzll4SzQeki0dmIECwY026YbAt
         TQvw1J0nDBHe6QLzqKMwYG2nYWYQvbekGhRcXEHDaOAyXJxLimtWrPF/5JFEgWpyFf
         Kjiq3sz82BTyQ==
Received: from SNPS-o0WHuHJU73.internal.synopsys.com (snps-o0whuhju73.internal.synopsys.com [10.116.107.23])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client did not present a certificate)
        by mailhost.synopsys.com (Postfix) with ESMTPSA id 43F09A0078;
        Mon, 17 Oct 2022 16:12:38 +0000 (UTC)
X-SNPS-Relay: synopsys.com
From:   Pavel.Kozlov@synopsys.com
To:     linux-snps-arc@lists.infradead.org
Cc:     Pavel Kozlov <Pavel.Kozlov@synopsys.com>,
        Vineet Gupta <vgupta@kernel.org>,
        Mike Rapoport <rppt@kernel.org>, stable@vger.kernel.org
Subject: [PATCH] ARC: mm: fix leakage of memory allocated for PTE
Date:   Mon, 17 Oct 2022 20:11:27 +0400
Message-Id: <20221017161127.24351-1-kozlov@synopsys.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: NHSJDF_iY1PTgTcLq7tfPEjkQ6vgUwHo
X-Proofpoint-ORIG-GUID: NHSJDF_iY1PTgTcLq7tfPEjkQ6vgUwHo
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-17_13,2022-10-17_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_active_cloned_notspam policy=outbound_active_cloned score=0
 priorityscore=1501 adultscore=0 clxscore=1011 malwarescore=0 bulkscore=0
 mlxlogscore=999 mlxscore=0 lowpriorityscore=0 phishscore=0 spamscore=0
 suspectscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2209130000 definitions=main-2210170094
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Kozlov <pavel.kozlov@synopsys.com>

Since commit d9820ff ("ARC: mm: switch pgtable_t back to struct page *")
a memory leakage problem occurs. Memory allocated for page table entries
not released during process termination. This issue can be reproduced by
a small program that allocates a large amount of memory. After several
runs, you'll see that the amount of free memory has reduced and will
continue to reduce after each run. All ARC CPUs are effected by this
issue. The issue was introduced since the kernel stable release v5.15-rc1.

As described in commit d9820ff after switch pgtable_t back to struct
page *, a pointer to "struct page" and appropriate functions are used to
allocate and free a memory page for PTEs, but the pmd_pgtable macro hasn't
changed and returns the direct virtual address from the PMD (PGD) entry.
Than this address used as a parameter in the __pte_free() and as a result
this function couldn't release memory page allocated for PTEs.

Fix this issue by changing the pmd_pgtable macro and returning pointer to
struct page.

Fixes: d9820ff76f95 ("ARC: mm: switch pgtable_t back to struct page *")
Signed-off-by: Pavel Kozlov <pavel.kozlov@synopsys.com>
Cc: Vineet Gupta <vgupta@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: <stable@vger.kernel.org> # 4.15.x
---
 arch/arc/include/asm/pgtable-levels.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arc/include/asm/pgtable-levels.h b/arch/arc/include/asm/pgtable-levels.h
index 64ca25d199be..ef68758b69f7 100644
--- a/arch/arc/include/asm/pgtable-levels.h
+++ b/arch/arc/include/asm/pgtable-levels.h
@@ -161,7 +161,7 @@
 #define pmd_pfn(pmd)		((pmd_val(pmd) & PAGE_MASK) >> PAGE_SHIFT)
 #define pmd_page(pmd)		virt_to_page(pmd_page_vaddr(pmd))
 #define set_pmd(pmdp, pmd)	(*(pmdp) = pmd)
-#define pmd_pgtable(pmd)	((pgtable_t) pmd_page_vaddr(pmd))
+#define pmd_pgtable(pmd)	((pgtable_t) pmd_page(pmd))
 
 /*
  * 4th level paging: pte
-- 
2.25.1

