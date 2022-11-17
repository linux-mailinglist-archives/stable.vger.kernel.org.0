Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A00A862D24C
	for <lists+stable@lfdr.de>; Thu, 17 Nov 2022 05:28:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233725AbiKQE2c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Nov 2022 23:28:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233477AbiKQE2b (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Nov 2022 23:28:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4041D6464;
        Wed, 16 Nov 2022 20:28:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9D46D61FF8;
        Thu, 17 Nov 2022 04:28:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 369D6C433D6;
        Thu, 17 Nov 2022 04:28:23 +0000 (UTC)
From:   Huacai Chen <chenhuacai@loongson.cn>
To:     Huacai Chen <chenhuacai@kernel.org>
Cc:     loongarch@lists.linux.dev, Xuefeng Li <lixuefeng@loongson.cn>,
        Guo Ren <guoren@kernel.org>, Xuerui Wang <kernel@xen0n.name>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        "David S . Miller" <davem@davemloft.net>,
        sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
        Huacai Chen <chenhuacai@loongson.cn>, stable@vger.kernel.org,
        Peter Xu <peterx@redhat.com>
Subject: [PATCH 04/47] LoongArch: Set _PAGE_DIRTY only if _PAGE_WRITE is set in {pmd,pte}_mkdirty()
Date:   Thu, 17 Nov 2022 12:25:32 +0800
Message-Id: <20221117042532.4064448-1-chenhuacai@loongson.cn>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Now {pmd,pte}_mkdirty() set _PAGE_DIRTY bit unconditionally, this causes
random segmentation fault after commit 0ccf7f168e17bb7e ("mm/thp: carry
over dirty bit when thp splits on pmd").

The reason is: when fork(), parent process use pmd_wrprotect() to clear
huge page's _PAGE_WRITE and _PAGE_DIRTY (for COW); then pte_mkdirty() set
_PAGE_DIRTY as well as _PAGE_MODIFIED while splitting dirty huge pages;
once _PAGE_DIRTY is set, there will be no tlb modify exception so the COW
machanism fails; and at last memory corruption occurred between parent
and child processes.

So, we should set _PAGE_DIRTY only when _PAGE_WRITE is set in {pmd,pte}_
mkdirty().

Cc: stable@vger.kernel.org
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
---
Note: CC sparc maillist because they have similar issues.
 
 arch/loongarch/include/asm/pgtable.h | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/loongarch/include/asm/pgtable.h b/arch/loongarch/include/asm/pgtable.h
index 946704bee599..debbe116f105 100644
--- a/arch/loongarch/include/asm/pgtable.h
+++ b/arch/loongarch/include/asm/pgtable.h
@@ -349,7 +349,9 @@ static inline pte_t pte_mkclean(pte_t pte)
 
 static inline pte_t pte_mkdirty(pte_t pte)
 {
-	pte_val(pte) |= (_PAGE_DIRTY | _PAGE_MODIFIED);
+	pte_val(pte) |= _PAGE_MODIFIED;
+	if (pte_val(pte) & _PAGE_WRITE)
+		pte_val(pte) |= _PAGE_DIRTY;
 	return pte;
 }
 
@@ -478,7 +480,9 @@ static inline pmd_t pmd_mkclean(pmd_t pmd)
 
 static inline pmd_t pmd_mkdirty(pmd_t pmd)
 {
-	pmd_val(pmd) |= (_PAGE_DIRTY | _PAGE_MODIFIED);
+	pmd_val(pmd) |= _PAGE_MODIFIED;
+	if (pmd_val(pmd) & _PAGE_WRITE)
+		pmd_val(pmd) |= _PAGE_DIRTY;
 	return pmd;
 }
 
-- 
2.31.1

