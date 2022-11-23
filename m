Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDE0B6357B8
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:46:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238145AbiKWJpS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:45:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238248AbiKWJo7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:44:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AC5C10579
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:42:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E77A4B81EF0
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:42:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AC1EC433D6;
        Wed, 23 Nov 2022 09:42:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669196552;
        bh=FOH9V6sTon2UB/EUH/j7qS5FK+cZfzbzoXKUKQ6sG1o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hjh0yWWFQYEn/Onj8Tm+vFKL/lMyxbz2v83QozL6zTGLkhi/gWC/2iF1sW2sFc8u1
         muuBY+FzFFEvfNU1xAPNlsvn9eqa2FFCcv/EQQYKQNtI4/NGVhxBN/HBUZh8xX/7By
         ZNN4DhJzYILs84sxA520c0EJqQIrALODY5IL9jx8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Mike Rapoport <rppt@linux.ibm.com>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 063/314] arm64/mm: fold check for KFENCE into can_set_direct_map()
Date:   Wed, 23 Nov 2022 09:48:28 +0100
Message-Id: <20221123084628.338225237@linuxfoundation.org>
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

From: Mike Rapoport <rppt@linux.ibm.com>

[ Upstream commit b9dd04a20f81333e4b99662f1bbaf7c9e3a1e137 ]

KFENCE requires linear map to be mapped at page granularity, so that it
is possible to protect/unprotect single pages, just like with
rodata_full and DEBUG_PAGEALLOC.

Instead of repating

	can_set_direct_map() || IS_ENABLED(CONFIG_KFENCE)

make can_set_direct_map() handle the KFENCE case.

This also prevents potential false positives in kernel_page_present()
that may return true for non-present page if CONFIG_KFENCE is enabled.

Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Link: https://lore.kernel.org/r/20220921074841.382615-1-rppt@kernel.org
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Stable-dep-of: 2081b3bd0c11 ("arm64: fix rodata=full again")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/mm/mmu.c      | 8 ++------
 arch/arm64/mm/pageattr.c | 8 +++++++-
 2 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index eb489302c28a..e8de94dd5a60 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -539,7 +539,7 @@ static void __init map_mem(pgd_t *pgdp)
 	 */
 	BUILD_BUG_ON(pgd_index(direct_map_end - 1) == pgd_index(direct_map_end));
 
-	if (can_set_direct_map() || IS_ENABLED(CONFIG_KFENCE))
+	if (can_set_direct_map())
 		flags |= NO_BLOCK_MAPPINGS | NO_CONT_MAPPINGS;
 
 	/*
@@ -1551,11 +1551,7 @@ int arch_add_memory(int nid, u64 start, u64 size,
 
 	VM_BUG_ON(!mhp_range_allowed(start, size, true));
 
-	/*
-	 * KFENCE requires linear map to be mapped at page granularity, so that
-	 * it is possible to protect/unprotect single pages in the KFENCE pool.
-	 */
-	if (can_set_direct_map() || IS_ENABLED(CONFIG_KFENCE))
+	if (can_set_direct_map())
 		flags |= NO_BLOCK_MAPPINGS | NO_CONT_MAPPINGS;
 
 	__create_pgd_mapping(swapper_pg_dir, start, __phys_to_virt(start),
diff --git a/arch/arm64/mm/pageattr.c b/arch/arm64/mm/pageattr.c
index 64e985eaa52d..d107c3d434e2 100644
--- a/arch/arm64/mm/pageattr.c
+++ b/arch/arm64/mm/pageattr.c
@@ -21,7 +21,13 @@ bool rodata_full __ro_after_init = IS_ENABLED(CONFIG_RODATA_FULL_DEFAULT_ENABLED
 
 bool can_set_direct_map(void)
 {
-	return rodata_full || debug_pagealloc_enabled();
+	/*
+	 * rodata_full, DEBUG_PAGEALLOC and KFENCE require linear map to be
+	 * mapped at page granularity, so that it is possible to
+	 * protect/unprotect single pages.
+	 */
+	return rodata_full || debug_pagealloc_enabled() ||
+		IS_ENABLED(CONFIG_KFENCE);
 }
 
 static int change_page_range(pte_t *ptep, unsigned long addr, void *data)
-- 
2.35.1



