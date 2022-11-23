Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AB87635938
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 11:09:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236806AbiKWKIf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 05:08:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236867AbiKWKGy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 05:06:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C514959C
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:57:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 001D2B81EE5
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:57:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CB01C433D6;
        Wed, 23 Nov 2022 09:57:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669197446;
        bh=rZqd3JSc/e78fE4qKHRM3n5UtErFT1QOMI+SDjRe4EM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N7n6DeajiHquuFdRe2K1haPVKOFXmYsGhqb8kQpMzNJc7lcpwVzo5UJXaTIIMKE6z
         z7loecoZsXvCPuWJAlJNE5M7VbWNFmXv/+ghH55a0ywN7li7pp5JlalIcpDlLjDif0
         oQRqC0JAlTSrlzHKq9sU+thqsx6M+oWvdqZ3iBN8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Denys Vlasenko <dvlasenk@redhat.com>,
        Liu Shixin <liushixin2@huawei.com>,
        David Hildenbrand <david@redhat.com>,
        Pasha Tatashin <pasha.tatashin@soleen.com>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 296/314] arm64/mm: fix incorrect file_map_count for non-leaf pmd/pud
Date:   Wed, 23 Nov 2022 09:52:21 +0100
Message-Id: <20221123084638.945320968@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liu Shixin <liushixin2@huawei.com>

[ Upstream commit 5b47348fc0b18a78c96f8474cc90b7525ad1bbfe ]

The page table check trigger BUG_ON() unexpectedly when collapse hugepage:

 ------------[ cut here ]------------
 kernel BUG at mm/page_table_check.c:82!
 Internal error: Oops - BUG: 00000000f2000800 [#1] SMP
 Dumping ftrace buffer:
    (ftrace buffer empty)
 Modules linked in:
 CPU: 6 PID: 68 Comm: khugepaged Not tainted 6.1.0-rc3+ #750
 Hardware name: linux,dummy-virt (DT)
 pstate: 60000005 (nZCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
 pc : page_table_check_clear.isra.0+0x258/0x3f0
 lr : page_table_check_clear.isra.0+0x240/0x3f0
[...]
 Call trace:
  page_table_check_clear.isra.0+0x258/0x3f0
  __page_table_check_pmd_clear+0xbc/0x108
  pmdp_collapse_flush+0xb0/0x160
  collapse_huge_page+0xa08/0x1080
  hpage_collapse_scan_pmd+0xf30/0x1590
  khugepaged_scan_mm_slot.constprop.0+0x52c/0xac8
  khugepaged+0x338/0x518
  kthread+0x278/0x2f8
  ret_from_fork+0x10/0x20
[...]

Since pmd_user_accessible_page() doesn't check if a pmd is leaf, it
decrease file_map_count for a non-leaf pmd comes from collapse_huge_page().
and so trigger BUG_ON() unexpectedly.

Fix this problem by using pmd_leaf() insteal of pmd_present() in
pmd_user_accessible_page(). Moreover, use pud_leaf() for
pud_user_accessible_page() too.

Fixes: 42b2547137f5 ("arm64/mm: enable ARCH_SUPPORTS_PAGE_TABLE_CHECK")
Reported-by: Denys Vlasenko <dvlasenk@redhat.com>
Signed-off-by: Liu Shixin <liushixin2@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Acked-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Acked-by: Will Deacon <will@kernel.org>
Link: https://lore.kernel.org/r/20221117075602.2904324-2-liushixin2@huawei.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/pgtable.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index b5df82aa99e6..d78e69293d12 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -863,12 +863,12 @@ static inline bool pte_user_accessible_page(pte_t pte)
 
 static inline bool pmd_user_accessible_page(pmd_t pmd)
 {
-	return pmd_present(pmd) && (pmd_user(pmd) || pmd_user_exec(pmd));
+	return pmd_leaf(pmd) && (pmd_user(pmd) || pmd_user_exec(pmd));
 }
 
 static inline bool pud_user_accessible_page(pud_t pud)
 {
-	return pud_present(pud) && pud_user(pud);
+	return pud_leaf(pud) && pud_user(pud);
 }
 #endif
 
-- 
2.35.1



