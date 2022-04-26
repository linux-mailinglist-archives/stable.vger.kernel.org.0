Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DBA650F607
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 10:55:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345630AbiDZInH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 04:43:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345478AbiDZIll (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 04:41:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67943158F6C;
        Tue, 26 Apr 2022 01:33:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DB890B81A2F;
        Tue, 26 Apr 2022 08:33:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 233F4C385A4;
        Tue, 26 Apr 2022 08:33:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650961983;
        bh=DMCYpmbUYHI9Ux/XT1Qs2k/p3ox5E4gI9mXm9J3vDx4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w/qwzGownsQFF3RK5jEirW7E0RkgNIlxq8AUsN9d0UctDmw41fvaLwaLP9vYjTPK6
         haSKpx+jHL88KYboFplWvyS5dF2d1L5tYUBD/OHruk3GavtxbOs2eAopkgRo5qwtwK
         dkfiLWoQIVb1kNluHm5FJe3xUC/S3TbBll+A/AIc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 32/86] arm64/mm: Remove [PUD|PMD]_TABLE_BIT from [pud|pmd]_bad()
Date:   Tue, 26 Apr 2022 10:21:00 +0200
Message-Id: <20220426081742.134773645@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081741.202366502@linuxfoundation.org>
References: <20220426081741.202366502@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anshuman Khandual <anshuman.khandual@arm.com>

[ Upstream commit e377ab82311af95c99648c6424a6b888a0ccb102 ]

Semantics wise, [pud|pmd]_bad() have always implied that a given [PUD|PMD]
entry does not have a pointer to the next level page table. This had been
made clear in the commit a1c76574f345 ("arm64: mm: use *_sect to check for
section maps"). Hence explicitly check for a table entry rather than just
testing a single bit. This basically redefines [pud|pmd]_bad() in terms of
[pud|pmd]_table() making the semantics clear.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Link: https://lore.kernel.org/r/1620644871-26280-1-git-send-email-anshuman.khandual@arm.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/pgtable.h | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index f3a70dc7c594..9cf8e304bb56 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -512,13 +512,12 @@ extern pgprot_t phys_mem_access_prot(struct file *file, unsigned long pfn,
 
 #define pmd_none(pmd)		(!pmd_val(pmd))
 
-#define pmd_bad(pmd)		(!(pmd_val(pmd) & PMD_TABLE_BIT))
-
 #define pmd_table(pmd)		((pmd_val(pmd) & PMD_TYPE_MASK) == \
 				 PMD_TYPE_TABLE)
 #define pmd_sect(pmd)		((pmd_val(pmd) & PMD_TYPE_MASK) == \
 				 PMD_TYPE_SECT)
 #define pmd_leaf(pmd)		pmd_sect(pmd)
+#define pmd_bad(pmd)		(!pmd_table(pmd))
 
 #if defined(CONFIG_ARM64_64K_PAGES) || CONFIG_PGTABLE_LEVELS < 3
 static inline bool pud_sect(pud_t pud) { return false; }
@@ -602,7 +601,7 @@ static inline unsigned long pmd_page_vaddr(pmd_t pmd)
 	pr_err("%s:%d: bad pmd %016llx.\n", __FILE__, __LINE__, pmd_val(e))
 
 #define pud_none(pud)		(!pud_val(pud))
-#define pud_bad(pud)		(!(pud_val(pud) & PUD_TABLE_BIT))
+#define pud_bad(pud)		(!pud_table(pud))
 #define pud_present(pud)	pte_present(pud_pte(pud))
 #define pud_leaf(pud)		pud_sect(pud)
 #define pud_valid(pud)		pte_valid(pud_pte(pud))
-- 
2.35.1



