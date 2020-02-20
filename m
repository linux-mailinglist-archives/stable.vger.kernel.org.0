Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1387165973
	for <lists+stable@lfdr.de>; Thu, 20 Feb 2020 09:43:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726865AbgBTInC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Feb 2020 03:43:02 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:39474 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726764AbgBTInC (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Feb 2020 03:43:02 -0500
Received: by mail-pl1-f193.google.com with SMTP id g6so1280629plp.6
        for <stable@vger.kernel.org>; Thu, 20 Feb 2020 00:43:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fossix-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3gKgbuQ+qyW6cSoObrFJbrpeEDkVLaM+BEDocK6BCUQ=;
        b=s94zVd+qdhp6grErmY5Om0h7V3Zf02oLkoMoLb2t/AQywv7xojk7BWN7lnaefzDX4V
         fAy7b+AZfMB+PzeQJ0ZkzxrGXZJS6KOoo0X4sUuiDZUO6fxM8XfOafVJ3w+N7VtrJgzH
         FQ3BuAczsNhmzctG/kdf+0e2Yu9zAS1NkMyVvHt9GzDXEdhAOIOjVUMeVhpfwLO4M5E7
         +VXpM7/rrYU+E2+Vz+PgJIZ8/4hOX0wHm3nI+Tb1gLD59Toer402jVvaBH/tee1eRrhB
         XcaW0MLfEaeLPuTf2Z5kxMPV3huqDBJyPVW0/F77Te52Fmtbj2mXO18AvjKeVPURj7bB
         btrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3gKgbuQ+qyW6cSoObrFJbrpeEDkVLaM+BEDocK6BCUQ=;
        b=YNorxmZsmcZExrI3cW0f2JqeMfYKDz6ggmcR3dGAt/6JAwNUpDq0eKSz9RpcV0ZCwC
         06xHCLBbnDTijJnyDlQ0gEIMkc8JQ86ZRKBc13JZ4TYJzXNkNuDRxDdLu7qC0pLV6f2l
         pgXkXhQKQaztu56QgYD3Xm3gwjsuTDUDDsH9TwE590Lkd+qxh9Gr1nor7pXd60EgnrhH
         mAJZmNeEbf140aDrYgirdJtZYGQXR1tJxjtlPYkcfJzpnwwySZDVZn/HoeL+Qv+llMRU
         iMjRpU5AosKa0tRLvCyTCIkSXhPTuu+B/M8B5nMCMrVsXo4xYA23DHYtCKUw7INChzSU
         9xeA==
X-Gm-Message-State: APjAAAU8Xt2/IkG//+zJcK/b8AUq7nSYw5ZUbjTYE0CaR3epzz6qnUE5
        r/uyMajckXnQ+QdsyWPX2qvLOAnv/Qo=
X-Google-Smtp-Source: APXvYqyRBfvUbgHm/BRv3pVhx5sTcraF9XyZo4Mho4MdiH1Tp0615HezjwCAFENHyx5dXPgJ8yqeMg==
X-Received: by 2002:a17:90b:30c9:: with SMTP id hi9mr2250522pjb.81.1582188181592;
        Thu, 20 Feb 2020 00:43:01 -0800 (PST)
Received: from santosiv.in.ibm.com ([129.41.84.72])
        by smtp.gmail.com with ESMTPSA id r145sm2512381pfr.5.2020.02.20.00.42.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Feb 2020 00:43:01 -0800 (PST)
From:   Santosh Sivaraj <santosh@fossix.org>
To:     linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        stable@vger.kernel.org
Cc:     peterz@infradead.org, aneesh.kumar@linux.ibm.com,
        akshay.adiga@linux.ibm.com, gregkh@linuxfoundation.org
Subject: [PATCH 4/6] powerpc/mmu_gather: enable RCU_TABLE_FREE even for !SMP case
Date:   Thu, 20 Feb 2020 14:12:27 +0530
Message-Id: <20200220084229.1278137-5-santosh@fossix.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200220084229.1278137-1-santosh@fossix.org>
References: <20200220084229.1278137-1-santosh@fossix.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>

Patch series "Fixup page directory freeing", v4.

This is a repost of patch series from Peter with the arch specific changes
except ppc64 dropped.  ppc64 changes are added here because we are redoing
the patch series on top of ppc64 changes.  This makes it easy to backport
these changes.  Only the first 2 patches need to be backported to stable.

The thing is, on anything SMP, freeing page directories should observe the
exact same order as normal page freeing:

 1) unhook page/directory
 2) TLB invalidate
 3) free page/directory

Without this, any concurrent page-table walk could end up with a
Use-after-Free.  This is esp.  trivial for anything that has software
page-table walkers (HAVE_FAST_GUP / software TLB fill) or the hardware
caches partial page-walks (ie.  caches page directories).

Even on UP this might give issues since mmu_gather is preemptible these
days.  An interrupt or preempted task accessing user pages might stumble
into the free page if the hardware caches page directories.

This patch series fixes ppc64 and add generic MMU_GATHER changes to
support the conversion of other architectures.  I haven't added patches
w.r.t other architecture because they are yet to be acked.

This patch (of 9):

A followup patch is going to make sure we correctly invalidate page walk
cache before we free page table pages.  In order to keep things simple
enable RCU_TABLE_FREE even for !SMP so that we don't have to fixup the
!SMP case differently in the followup patch

!SMP case is right now broken for radix translation w.r.t page walk
cache flush.  We can get interrupted in between page table free and
that would imply we have page walk cache entries pointing to tables
which got freed already.  Michael said "both our platforms that run on
Power9 force SMP on in Kconfig, so the !SMP case is unlikely to be a
problem for anyone in practice, unless they've hacked their kernel to
build it !SMP."

12e4d53f3f04e in upstream.

Link: http://lkml.kernel.org/r/20200116064531.483522-2-aneesh.kumar@linux.ibm.com
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: <stable@vger.kernel.org> # 4.19
Signed-off-by: Santosh Sivaraj <santosh@fossix.org>
[santosh: backported for 4.19 stable]
---
 arch/powerpc/Kconfig                         | 2 +-
 arch/powerpc/include/asm/book3s/32/pgalloc.h | 8 --------
 arch/powerpc/include/asm/book3s/64/pgalloc.h | 2 --
 arch/powerpc/mm/pgtable-book3s64.c           | 7 -------
 4 files changed, 1 insertion(+), 18 deletions(-)

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index f7f046ff6407..fa231130eee1 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -215,7 +215,7 @@ config PPC
 	select HAVE_HARDLOCKUP_DETECTOR_PERF	if PERF_EVENTS && HAVE_PERF_EVENTS_NMI && !HAVE_HARDLOCKUP_DETECTOR_ARCH
 	select HAVE_PERF_REGS
 	select HAVE_PERF_USER_STACK_DUMP
-	select HAVE_RCU_TABLE_FREE		if SMP
+	select HAVE_RCU_TABLE_FREE
 	select HAVE_RCU_TABLE_NO_INVALIDATE	if HAVE_RCU_TABLE_FREE
 	select HAVE_REGS_AND_STACK_ACCESS_API
 	select HAVE_RELIABLE_STACKTRACE		if PPC64 && CPU_LITTLE_ENDIAN
diff --git a/arch/powerpc/include/asm/book3s/32/pgalloc.h b/arch/powerpc/include/asm/book3s/32/pgalloc.h
index 82e44b1a00ae..79ba3fbb512e 100644
--- a/arch/powerpc/include/asm/book3s/32/pgalloc.h
+++ b/arch/powerpc/include/asm/book3s/32/pgalloc.h
@@ -110,7 +110,6 @@ static inline void pgtable_free(void *table, unsigned index_size)
 #define check_pgt_cache()	do { } while (0)
 #define get_hugepd_cache_index(x)  (x)
 
-#ifdef CONFIG_SMP
 static inline void pgtable_free_tlb(struct mmu_gather *tlb,
 				    void *table, int shift)
 {
@@ -127,13 +126,6 @@ static inline void __tlb_remove_table(void *_table)
 
 	pgtable_free(table, shift);
 }
-#else
-static inline void pgtable_free_tlb(struct mmu_gather *tlb,
-				    void *table, int shift)
-{
-	pgtable_free(table, shift);
-}
-#endif
 
 static inline void __pte_free_tlb(struct mmu_gather *tlb, pgtable_t table,
 				  unsigned long address)
diff --git a/arch/powerpc/include/asm/book3s/64/pgalloc.h b/arch/powerpc/include/asm/book3s/64/pgalloc.h
index f9019b579903..1013c0214213 100644
--- a/arch/powerpc/include/asm/book3s/64/pgalloc.h
+++ b/arch/powerpc/include/asm/book3s/64/pgalloc.h
@@ -47,9 +47,7 @@ extern pmd_t *pmd_fragment_alloc(struct mm_struct *, unsigned long);
 extern void pte_fragment_free(unsigned long *, int);
 extern void pmd_fragment_free(unsigned long *);
 extern void pgtable_free_tlb(struct mmu_gather *tlb, void *table, int shift);
-#ifdef CONFIG_SMP
 extern void __tlb_remove_table(void *_table);
-#endif
 
 static inline pgd_t *radix__pgd_alloc(struct mm_struct *mm)
 {
diff --git a/arch/powerpc/mm/pgtable-book3s64.c b/arch/powerpc/mm/pgtable-book3s64.c
index 297db665d953..5b4e9fd8990c 100644
--- a/arch/powerpc/mm/pgtable-book3s64.c
+++ b/arch/powerpc/mm/pgtable-book3s64.c
@@ -432,7 +432,6 @@ static inline void pgtable_free(void *table, int index)
 	}
 }
 
-#ifdef CONFIG_SMP
 void pgtable_free_tlb(struct mmu_gather *tlb, void *table, int index)
 {
 	unsigned long pgf = (unsigned long)table;
@@ -449,12 +448,6 @@ void __tlb_remove_table(void *_table)
 
 	return pgtable_free(table, index);
 }
-#else
-void pgtable_free_tlb(struct mmu_gather *tlb, void *table, int index)
-{
-	return pgtable_free(table, index);
-}
-#endif
 
 #ifdef CONFIG_PROC_FS
 atomic_long_t direct_pages_count[MMU_PAGE_COUNT];
-- 
2.24.1

