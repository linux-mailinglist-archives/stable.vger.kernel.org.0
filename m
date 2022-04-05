Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87FBA4F3C11
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 17:24:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382310AbiDEMEQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 08:04:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358194AbiDEK2F (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:28:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 739F7140DD;
        Tue,  5 Apr 2022 03:16:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0FE6661562;
        Tue,  5 Apr 2022 10:16:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CD65C385A1;
        Tue,  5 Apr 2022 10:16:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649153807;
        bh=8JSgkcY2Q8LqRXihDMYt28L+69omj67mJtw6txZf4x0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q4PIVyP7H8qWuhZVm95tivoLb18lbbQRpFtwUmTGK/a4pk/OGOHuXtqff+hhKjh6X
         3BPfu1owfecFYPqFk8Lqfo3LJXU33s0TJCeiXtrzig67t9fYw/1Snujl46Atis4LA3
         glQrg2mVpJ4VTr6/tHDej6IsLNUhOplV+2TwkryE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yaliang Wang <Yaliang.Wang@windriver.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 353/599] MIPS: pgalloc: fix memory leak caused by pgd_free()
Date:   Tue,  5 Apr 2022 09:30:47 +0200
Message-Id: <20220405070309.330432374@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070258.802373272@linuxfoundation.org>
References: <20220405070258.802373272@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yaliang Wang <Yaliang.Wang@windriver.com>

[ Upstream commit 2bc5bab9a763d520937e4f3fe8df51c6a1eceb97 ]

pgd page is freed by generic implementation pgd_free() since commit
f9cb654cb550 ("asm-generic: pgalloc: provide generic pgd_free()"),
however, there are scenarios that the system uses more than one page as
the pgd table, in such cases the generic implementation pgd_free() won't
be applicable anymore. For example, when PAGE_SIZE_4KB is enabled and
MIPS_VA_BITS_48 is not enabled in a 64bit system, the macro "PGD_ORDER"
will be set as "1", which will cause allocating two pages as the pgd
table. Well, at the same time, the generic implementation pgd_free()
just free one pgd page, which will result in the memory leak.

The memory leak can be easily detected by executing shell command:
"while true; do ls > /dev/null; grep MemFree /proc/meminfo; done"

Fixes: f9cb654cb550 ("asm-generic: pgalloc: provide generic pgd_free()")
Signed-off-by: Yaliang Wang <Yaliang.Wang@windriver.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/include/asm/pgalloc.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/mips/include/asm/pgalloc.h b/arch/mips/include/asm/pgalloc.h
index 139b4050259f..71153c369f29 100644
--- a/arch/mips/include/asm/pgalloc.h
+++ b/arch/mips/include/asm/pgalloc.h
@@ -15,6 +15,7 @@
 
 #define __HAVE_ARCH_PMD_ALLOC_ONE
 #define __HAVE_ARCH_PUD_ALLOC_ONE
+#define __HAVE_ARCH_PGD_FREE
 #include <asm-generic/pgalloc.h>
 
 static inline void pmd_populate_kernel(struct mm_struct *mm, pmd_t *pmd,
@@ -49,6 +50,11 @@ static inline void pud_populate(struct mm_struct *mm, pud_t *pud, pmd_t *pmd)
 extern void pgd_init(unsigned long page);
 extern pgd_t *pgd_alloc(struct mm_struct *mm);
 
+static inline void pgd_free(struct mm_struct *mm, pgd_t *pgd)
+{
+	free_pages((unsigned long)pgd, PGD_ORDER);
+}
+
 #define __pte_free_tlb(tlb,pte,address)			\
 do {							\
 	pgtable_pte_page_dtor(pte);			\
-- 
2.34.1



