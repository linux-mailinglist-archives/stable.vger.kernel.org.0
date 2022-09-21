Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82E6E5C0339
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 18:01:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232177AbiIUQA4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 12:00:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232468AbiIUP7k (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 11:59:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91A4DA1D69;
        Wed, 21 Sep 2022 08:53:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 83E416315F;
        Wed, 21 Sep 2022 15:51:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79795C433C1;
        Wed, 21 Sep 2022 15:51:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663775505;
        bh=K/vbOOLXz+bkdNR0K8xtc/tnoLZdRLzs6vj2b/igVbo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MgfsokOofoU/qBhkCg+1MrijiETzs12lqe3vLPMnPauVDGB0v1R/hm0TudsGY8mVR
         ylV2OHMmtCDwZACvXtGrZnbPXa6F1o2LDYYsIFFnt3I3WesVFAgHzNMNfHgTDKL7Ez
         71Xo8MGrDT2dh99TSzMYnnIV7GmrtxVrdVl7w/I4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John David Anglin <dave.anglin@bell.net>,
        Helge Deller <deller@gmx.de>, Sasha Levin <sashal@kernel.org>,
        stable@kernel.org
Subject: [PATCH 5.10 05/39] parisc: Flush kernel data mapping in set_pte_at() when installing pte for user page
Date:   Wed, 21 Sep 2022 17:46:10 +0200
Message-Id: <20220921153645.891734199@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220921153645.663680057@linuxfoundation.org>
References: <20220921153645.663680057@linuxfoundation.org>
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

From: John David Anglin <dave.anglin@bell.net>

[ Upstream commit 38860b2c8bb1b92f61396eb06a63adff916fc31d ]

For years, there have been random segmentation faults in userspace on
SMP PA-RISC machines.  It occurred to me that this might be a problem in
set_pte_at().  MIPS and some other architectures do cache flushes when
installing PTEs with the present bit set.

Here I have adapted the code in update_mmu_cache() to flush the kernel
mapping when the kernel flush is deferred, or when the kernel mapping
may alias with the user mapping.  This simplifies calls to
update_mmu_cache().

I also changed the barrier in set_pte() from a compiler barrier to a
full memory barrier.  I know this change is not sufficient to fix the
problem.  It might not be needed.

I have had a few days of operation with 5.14.16 to 5.15.1 and haven't
seen any random segmentation faults on rp3440 or c8000 so far.

Signed-off-by: John David Anglin <dave.anglin@bell.net>
Signed-off-by: Helge Deller <deller@gmx.de>
Cc: stable@kernel.org # 5.12+
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/parisc/include/asm/pgtable.h | 10 ++++++++--
 arch/parisc/kernel/cache.c        |  4 ++--
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/arch/parisc/include/asm/pgtable.h b/arch/parisc/include/asm/pgtable.h
index 39017210dbf0..8964798b8274 100644
--- a/arch/parisc/include/asm/pgtable.h
+++ b/arch/parisc/include/asm/pgtable.h
@@ -76,6 +76,8 @@ static inline void purge_tlb_entries(struct mm_struct *mm, unsigned long addr)
 	purge_tlb_end(flags);
 }
 
+extern void __update_cache(pte_t pte);
+
 /* Certain architectures need to do special things when PTEs
  * within a page table are directly modified.  Thus, the following
  * hook is made available.
@@ -83,11 +85,14 @@ static inline void purge_tlb_entries(struct mm_struct *mm, unsigned long addr)
 #define set_pte(pteptr, pteval)			\
 	do {					\
 		*(pteptr) = (pteval);		\
-		barrier();			\
+		mb();				\
 	} while(0)
 
 #define set_pte_at(mm, addr, pteptr, pteval)	\
 	do {					\
+		if (pte_present(pteval) &&	\
+		    pte_user(pteval))		\
+			__update_cache(pteval);	\
 		*(pteptr) = (pteval);		\
 		purge_tlb_entries(mm, addr);	\
 	} while (0)
@@ -305,6 +310,7 @@ extern unsigned long *empty_zero_page;
 
 #define pte_none(x)     (pte_val(x) == 0)
 #define pte_present(x)	(pte_val(x) & _PAGE_PRESENT)
+#define pte_user(x)	(pte_val(x) & _PAGE_USER)
 #define pte_clear(mm, addr, xp)  set_pte_at(mm, addr, xp, __pte(0))
 
 #define pmd_flag(x)	(pmd_val(x) & PxD_FLAG_MASK)
@@ -412,7 +418,7 @@ extern void paging_init (void);
 
 #define PG_dcache_dirty         PG_arch_1
 
-extern void update_mmu_cache(struct vm_area_struct *, unsigned long, pte_t *);
+#define update_mmu_cache(vms,addr,ptep) __update_cache(*ptep)
 
 /* Encode and de-code a swap entry */
 
diff --git a/arch/parisc/kernel/cache.c b/arch/parisc/kernel/cache.c
index 86a1a63563fd..c81ab0cb8925 100644
--- a/arch/parisc/kernel/cache.c
+++ b/arch/parisc/kernel/cache.c
@@ -83,9 +83,9 @@ EXPORT_SYMBOL(flush_cache_all_local);
 #define pfn_va(pfn)	__va(PFN_PHYS(pfn))
 
 void
-update_mmu_cache(struct vm_area_struct *vma, unsigned long address, pte_t *ptep)
+__update_cache(pte_t pte)
 {
-	unsigned long pfn = pte_pfn(*ptep);
+	unsigned long pfn = pte_pfn(pte);
 	struct page *page;
 
 	/* We don't have pte special.  As a result, we can be called with
-- 
2.35.1



