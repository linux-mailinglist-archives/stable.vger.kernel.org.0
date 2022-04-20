Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49ADA508861
	for <lists+stable@lfdr.de>; Wed, 20 Apr 2022 14:44:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233048AbiDTMqo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Apr 2022 08:46:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240154AbiDTMqj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Apr 2022 08:46:39 -0400
Received: from alexa-out-sd-01.qualcomm.com (alexa-out-sd-01.qualcomm.com [199.106.114.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8ED71FA6F
        for <stable@vger.kernel.org>; Wed, 20 Apr 2022 05:43:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1650458633; x=1681994633;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=WYlzvWhWMwfjBhcYElEw1ViQilDVHsjuAmB2VCyVd2Y=;
  b=YLoghJKsaQdFG10o+Hj5OnimnqXZwvqfRTCLXvPlUt7sH6E3Qbn/pYDe
   lzjsEsI76Qp9zpEt+m6bmOPgVQlWx/ZdMU2sQQBbs7LBqQWGHiqM1i/W6
   YFDvlf2r1gJJtCiBmlBbB9a6xZyzRVvHaJ7ifT3Q+jh32kS9E6dqadG89
   Q=;
Received: from unknown (HELO ironmsg03-sd.qualcomm.com) ([10.53.140.143])
  by alexa-out-sd-01.qualcomm.com with ESMTP; 20 Apr 2022 05:43:53 -0700
X-QCInternal: smtphost
Received: from unknown (HELO nasanex01a.na.qualcomm.com) ([10.52.223.231])
  by ironmsg03-sd.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2022 05:43:53 -0700
Received: from hu-c-gdjako-lv.qualcomm.com (10.49.16.6) by
 nasanex01a.na.qualcomm.com (10.52.223.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Wed, 20 Apr 2022 05:43:52 -0700
From:   Georgi Djakov <quic_c_gdjako@quicinc.com>
To:     <stable@vger.kernel.org>
CC:     <rppt@linux.ibm.com>, <anshuman.khandual@arm.com>,
        <david@redhat.com>, <will@kernel.org>, <catalin.marinas@arm.com>,
        <hch@lst.de>, <akpm@linux-foundation.org>, <surenb@google.com>,
        <quic_sudaraja@quicinc.com>, <djakov@kernel.org>
Subject: [PATCH 5.15 2/2] arm64/mm: drop HAVE_ARCH_PFN_VALID
Date:   Wed, 20 Apr 2022 05:43:41 -0700
Message-ID: <20220420124341.14982-2-quic_c_gdjako@quicinc.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220420124341.14982-1-quic_c_gdjako@quicinc.com>
References: <20220420124341.14982-1-quic_c_gdjako@quicinc.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.49.16.6]
X-ClientProxiedBy: nalasex01c.na.qualcomm.com (10.47.97.35) To
 nasanex01a.na.qualcomm.com (10.52.223.231)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anshuman Khandual <anshuman.khandual@arm.com>

[ Upstream commit 3de360c3fdb34fbdbaf6da3af94367d3fded95d3 ]

CONFIG_SPARSEMEM_VMEMMAP is now the only available memory model on arm64
platforms and free_unused_memmap() would just return without creating any
holes in the memmap mapping.  There is no need for any special handling in
pfn_valid() and HAVE_ARCH_PFN_VALID can just be dropped.  This also moves
the pfn upper bits sanity check into generic pfn_valid().

[rppt: rebased on v5.15-rc3]

Link: https://lkml.kernel.org/r/1621947349-25421-1-git-send-email-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Mike Rapoport <rppt@linux.ibm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Mike Rapoport <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Link: https://lore.kernel.org/r/20210930013039.11260-3-rppt@kernel.org
Signed-off-by: Will Deacon <will@kernel.org>
Fixes: 859a85ddf90e ("mm: remove pfn_valid_within() and CONFIG_HOLES_IN_ZONE")
Link: https://lore.kernel.org/r/Yl0IZWT2nsiYtqBT@linux.ibm.com
Signed-off-by: Georgi Djakov <quic_c_gdjako@quicinc.com>
---
 arch/arm64/Kconfig            |  1 -
 arch/arm64/include/asm/page.h |  1 -
 arch/arm64/mm/init.c          | 37 -----------------------------------
 3 files changed, 39 deletions(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 1a18c9045773..8b6f090e0364 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -154,7 +154,6 @@ config ARM64
 	select HAVE_ARCH_KGDB
 	select HAVE_ARCH_MMAP_RND_BITS
 	select HAVE_ARCH_MMAP_RND_COMPAT_BITS if COMPAT
-	select HAVE_ARCH_PFN_VALID
 	select HAVE_ARCH_PREL32_RELOCATIONS
 	select HAVE_ARCH_RANDOMIZE_KSTACK_OFFSET
 	select HAVE_ARCH_SECCOMP_FILTER
diff --git a/arch/arm64/include/asm/page.h b/arch/arm64/include/asm/page.h
index f98c91bbd7c1..993a27ea6f54 100644
--- a/arch/arm64/include/asm/page.h
+++ b/arch/arm64/include/asm/page.h
@@ -41,7 +41,6 @@ void tag_clear_highpage(struct page *to);
 
 typedef struct page *pgtable_t;
 
-int pfn_valid(unsigned long pfn);
 int pfn_is_map_memory(unsigned long pfn);
 
 #include <asm/memory.h>
diff --git a/arch/arm64/mm/init.c b/arch/arm64/mm/init.c
index c59cb2efd554..3b269c756798 100644
--- a/arch/arm64/mm/init.c
+++ b/arch/arm64/mm/init.c
@@ -184,43 +184,6 @@ static void __init zone_sizes_init(unsigned long min, unsigned long max)
 	free_area_init(max_zone_pfns);
 }
 
-int pfn_valid(unsigned long pfn)
-{
-	phys_addr_t addr = PFN_PHYS(pfn);
-	struct mem_section *ms;
-
-	/*
-	 * Ensure the upper PAGE_SHIFT bits are clear in the
-	 * pfn. Else it might lead to false positives when
-	 * some of the upper bits are set, but the lower bits
-	 * match a valid pfn.
-	 */
-	if (PHYS_PFN(addr) != pfn)
-		return 0;
-
-	if (pfn_to_section_nr(pfn) >= NR_MEM_SECTIONS)
-		return 0;
-
-	ms = __pfn_to_section(pfn);
-	if (!valid_section(ms))
-		return 0;
-
-	/*
-	 * ZONE_DEVICE memory does not have the memblock entries.
-	 * memblock_is_map_memory() check for ZONE_DEVICE based
-	 * addresses will always fail. Even the normal hotplugged
-	 * memory will never have MEMBLOCK_NOMAP flag set in their
-	 * memblock entries. Skip memblock search for all non early
-	 * memory sections covering all of hotplug memory including
-	 * both normal and ZONE_DEVICE based.
-	 */
-	if (!early_section(ms))
-		return pfn_section_valid(ms, pfn);
-
-	return memblock_is_memory(addr);
-}
-EXPORT_SYMBOL(pfn_valid);
-
 int pfn_is_map_memory(unsigned long pfn)
 {
 	phys_addr_t addr = PFN_PHYS(pfn);
