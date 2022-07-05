Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EFE7566BF5
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:10:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234849AbiGEMKW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:10:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235055AbiGEMI0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:08:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA3091836D;
        Tue,  5 Jul 2022 05:07:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 62E35B817C7;
        Tue,  5 Jul 2022 12:07:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF238C341C7;
        Tue,  5 Jul 2022 12:07:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657022855;
        bh=CdltY3YtFYtmK68cdI/9Kb2Y0PHRiuO7d/0xZbESO4Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gy9x8pHOmfmrL8HtXmuWehix3ZHkZPYH1xzRrrQDiTazzNZe9ZPipqMI0dLd/fWHj
         9wpsoHy+U+Ab5a6ClPqLZgerQxYri/DWQpfwHXrmMttu12i/qerMTdXwJKLJEhNigO
         DRIL7lq6v6P7J+pVZVSLqkmhmSPkO2Ijim6rhsZw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.10 06/84] powerpc/book3e: Fix PUD allocation size in map_kernel_page()
Date:   Tue,  5 Jul 2022 13:57:29 +0200
Message-Id: <20220705115615.512409993@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220705115615.323395630@linuxfoundation.org>
References: <20220705115615.323395630@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@csgroup.eu>

commit 986481618023e18e187646b0fff05a3c337531cb upstream.

Commit 2fb4706057bc ("powerpc: add support for folded p4d page tables")
erroneously changed PUD setup to a mix of PMD and PUD. Fix it.

While at it, use PTE_TABLE_SIZE instead of PAGE_SIZE for PTE tables
in order to avoid any confusion.

Fixes: 2fb4706057bc ("powerpc: add support for folded p4d page tables")
Cc: stable@vger.kernel.org # v5.8+
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Acked-by: Mike Rapoport <rppt@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/95ddfd6176d53e6c85e13bd1c358359daa56775f.1655974558.git.christophe.leroy@csgroup.eu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/mm/nohash/book3e_pgtable.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/arch/powerpc/mm/nohash/book3e_pgtable.c
+++ b/arch/powerpc/mm/nohash/book3e_pgtable.c
@@ -95,8 +95,8 @@ int __ref map_kernel_page(unsigned long
 		pgdp = pgd_offset_k(ea);
 		p4dp = p4d_offset(pgdp, ea);
 		if (p4d_none(*p4dp)) {
-			pmdp = early_alloc_pgtable(PMD_TABLE_SIZE);
-			p4d_populate(&init_mm, p4dp, pmdp);
+			pudp = early_alloc_pgtable(PUD_TABLE_SIZE);
+			p4d_populate(&init_mm, p4dp, pudp);
 		}
 		pudp = pud_offset(p4dp, ea);
 		if (pud_none(*pudp)) {
@@ -105,7 +105,7 @@ int __ref map_kernel_page(unsigned long
 		}
 		pmdp = pmd_offset(pudp, ea);
 		if (!pmd_present(*pmdp)) {
-			ptep = early_alloc_pgtable(PAGE_SIZE);
+			ptep = early_alloc_pgtable(PTE_TABLE_SIZE);
 			pmd_populate_kernel(&init_mm, pmdp, ptep);
 		}
 		ptep = pte_offset_kernel(pmdp, ea);


