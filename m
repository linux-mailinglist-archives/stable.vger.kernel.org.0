Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E36850F57E
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 10:54:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345349AbiDZInP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 04:43:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345516AbiDZIl5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 04:41:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABB64158F84;
        Tue, 26 Apr 2022 01:33:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2D7766185D;
        Tue, 26 Apr 2022 08:33:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E370C385A0;
        Tue, 26 Apr 2022 08:33:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650961986;
        bh=EGbn0DdCYwtJ3+c4oJdDYP5vjRTc9aYEwtto72wo0VU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rzp1M/9YPMg/Jw3VrV530uL3STcRG6QwJ7PEe7H0lIVNNDcIwsQvJfYzmR3AUxjq9
         qp/TZA2lNTN+iM9GD86qpSmybw6Ii4HvTZvGQg9kPaM4nUQpANrgQ7GJKUIg9d+Dg3
         SKmeAci1fZyxPFuOMAsE9dgb/xJxbnhu+yFTx3nI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qian Cai <quic_qiancai@quicinc.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 33/86] arm64: mm: fix p?d_leaf()
Date:   Tue, 26 Apr 2022 10:21:01 +0200
Message-Id: <20220426081742.162293381@linuxfoundation.org>
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

From: Muchun Song <songmuchun@bytedance.com>

[ Upstream commit 23bc8f69f0eceecbb87c3801d2e48827d2dca92b ]

The pmd_leaf() is used to test a leaf mapped PMD, however, it misses
the PROT_NONE mapped PMD on arm64.  Fix it.  A real world issue [1]
caused by this was reported by Qian Cai. Also fix pud_leaf().

Link: https://patchwork.kernel.org/comment/24798260/ [1]
Fixes: 8aa82df3c123 ("arm64: mm: add p?d_leaf() definitions")
Reported-by: Qian Cai <quic_qiancai@quicinc.com>
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Link: https://lore.kernel.org/r/20220422060033.48711-1-songmuchun@bytedance.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/pgtable.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 9cf8e304bb56..3f74db7b0a31 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -516,7 +516,7 @@ extern pgprot_t phys_mem_access_prot(struct file *file, unsigned long pfn,
 				 PMD_TYPE_TABLE)
 #define pmd_sect(pmd)		((pmd_val(pmd) & PMD_TYPE_MASK) == \
 				 PMD_TYPE_SECT)
-#define pmd_leaf(pmd)		pmd_sect(pmd)
+#define pmd_leaf(pmd)		(pmd_present(pmd) && !pmd_table(pmd))
 #define pmd_bad(pmd)		(!pmd_table(pmd))
 
 #if defined(CONFIG_ARM64_64K_PAGES) || CONFIG_PGTABLE_LEVELS < 3
@@ -603,7 +603,7 @@ static inline unsigned long pmd_page_vaddr(pmd_t pmd)
 #define pud_none(pud)		(!pud_val(pud))
 #define pud_bad(pud)		(!pud_table(pud))
 #define pud_present(pud)	pte_present(pud_pte(pud))
-#define pud_leaf(pud)		pud_sect(pud)
+#define pud_leaf(pud)		(pud_present(pud) && !pud_table(pud))
 #define pud_valid(pud)		pte_valid(pud_pte(pud))
 
 static inline void set_pud(pud_t *pudp, pud_t pud)
-- 
2.35.1



