Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A13D118315F
	for <lists+stable@lfdr.de>; Thu, 12 Mar 2020 14:28:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727240AbgCLN2X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Mar 2020 09:28:23 -0400
Received: from mail-pj1-f65.google.com ([209.85.216.65]:38997 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726558AbgCLN2X (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Mar 2020 09:28:23 -0400
Received: by mail-pj1-f65.google.com with SMTP id d8so2664277pje.4
        for <stable@vger.kernel.org>; Thu, 12 Mar 2020 06:28:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fossix-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=h2xq/K+3WzENoJ8KwsXlKORLR95m5NFG5cGAyvZPyKg=;
        b=f3zl+M1TJ+orpZE/K+/8x+s1IdDwdXJ+28NmE2K2aCuAGqrcu9PmE5QFartUSTJZKW
         Jm0P0696/z9XjxWE/Pnl8WkZvlLwTp3Wydtr01NOS3aYObWxQbisVwjGWICVs/whOhUU
         15PHycP0kQFgPj/3xYuKqttv9guxNB/2pmjPez/eiWZZ/S6mawdJQT12EF92/wwbCRPg
         CQhwiNTLcGQQteCfdRgin+CGHyDLqmBJ59LDZZE7wS/MkJMwWki+LHriZRYlKjcWX0IM
         MiPVYStwN2wWZNtgWkZOgIr+Ff6YD3Mfp3mOhnJd79nS9VlCUhPxhdyK7LPqvJDOhFog
         7mxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=h2xq/K+3WzENoJ8KwsXlKORLR95m5NFG5cGAyvZPyKg=;
        b=U9ttm1OArNcDUalVbXFVMNzSdIeFTHi1PpeIKd/ZgkY9BzNmesSLLrkFK/dehKeJzL
         4YIQSMH+muz/rSRfCXvIlqDV8Jn7kBXnHh7m9y+qFbsF8Kvq4bDf/s5mG4I7OwUemx1+
         RknILd9USf1fc3jmKcHixH2PYd83uf/FceEbWZzMSVA6ycnXjqS7D/s7Bnct5FwDcEBx
         1NGttLpmv36DQn0lU5Y3jkvi+LuLZkzdd3OMj9lL3A+FTbaGDtK8bBkzhW3eGScrxEiN
         qSIQ7pvd+ZckrvRPv6oVv2+ELsQwgJz3XL4go+XgDZ3bNaDMwtibBeyP4lrx6CrxnbVs
         JYiw==
X-Gm-Message-State: ANhLgQ0z6zgNz5q2x3L9v6cdBudXnNSDnta9A7hz6wCzpvxYHMd8kZid
        0vixbychONUfaaeaSfb3jiCQ9QC3+zE=
X-Google-Smtp-Source: ADFU+vtIGIduLEP33hS97iQ8OdyhXw5d1sUcPS0i9I+mQHEE0pDH/7KRjE176lAzQ46fB3TogMHOYQ==
X-Received: by 2002:a17:90b:151:: with SMTP id em17mr3517670pjb.51.1584019699901;
        Thu, 12 Mar 2020 06:28:19 -0700 (PDT)
Received: from santosiv.in.ibm.com ([111.125.206.208])
        by smtp.gmail.com with ESMTPSA id w206sm13007435pfc.54.2020.03.12.06.28.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Mar 2020 06:28:18 -0700 (PDT)
From:   Santosh Sivaraj <santosh@fossix.org>
To:     <stable@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
Cc:     Michael Ellerman <mpe@ellerman.id.au>, Greg KH <greg@kroah.com>,
        Sasha Levin <sashal@kernel.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: [PATCH v3 4/6] powerpc/mmu_gather: enable RCU_TABLE_FREE even for !SMP case
Date:   Thu, 12 Mar 2020 18:57:38 +0530
Message-Id: <20200312132740.225241-5-santosh@fossix.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200312132740.225241-1-santosh@fossix.org>
References: <20200312132740.225241-1-santosh@fossix.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>

commit 12e4d53f3f04e81f9e83d6fc10edc7314ab9f6b9 upstream.

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

Link: http://lkml.kernel.org/r/20200116064531.483522-2-aneesh.kumar@linux.ibm.com
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: <stable@vger.kernel.org> # 4.19
Signed-off-by: Santosh Sivaraj <santosh@fossix.org>
[santosh: backported for 4.19 stable]
---
 arch/powerpc/Kconfig                         | 2 +-
 arch/powerpc/include/asm/book3s/32/pgalloc.h | 8 --------
 arch/powerpc/include/asm/book3s/64/pgalloc.h | 2 --
 arch/powerpc/include/asm/nohash/32/pgalloc.h | 8 --------
 arch/powerpc/include/asm/nohash/64/pgalloc.h | 9 +--------
 arch/powerpc/mm/pgtable-book3s64.c           | 7 -------
 6 files changed, 2 insertions(+), 34 deletions(-)

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index e09cfb109b8c..1a00ce4b0040 100644
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
diff --git a/arch/powerpc/include/asm/nohash/32/pgalloc.h b/arch/powerpc/include/asm/nohash/32/pgalloc.h
index 8825953c225b..96eed46d5684 100644
--- a/arch/powerpc/include/asm/nohash/32/pgalloc.h
+++ b/arch/powerpc/include/asm/nohash/32/pgalloc.h
@@ -111,7 +111,6 @@ static inline void pgtable_free(void *table, unsigned index_size)
 #define check_pgt_cache()	do { } while (0)
 #define get_hugepd_cache_index(x)	(x)
 
-#ifdef CONFIG_SMP
 static inline void pgtable_free_tlb(struct mmu_gather *tlb,
 				    void *table, int shift)
 {
@@ -128,13 +127,6 @@ static inline void __tlb_remove_table(void *_table)
 
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
diff --git a/arch/powerpc/include/asm/nohash/64/pgalloc.h b/arch/powerpc/include/asm/nohash/64/pgalloc.h
index e2d62d033708..e3a0caba65f4 100644
--- a/arch/powerpc/include/asm/nohash/64/pgalloc.h
+++ b/arch/powerpc/include/asm/nohash/64/pgalloc.h
@@ -142,7 +142,7 @@ static inline void pgtable_free(void *table, int shift)
 }
 
 #define get_hugepd_cache_index(x)	(x)
-#ifdef CONFIG_SMP
+
 static inline void pgtable_free_tlb(struct mmu_gather *tlb, void *table, int shift)
 {
 	unsigned long pgf = (unsigned long)table;
@@ -160,13 +160,6 @@ static inline void __tlb_remove_table(void *_table)
 	pgtable_free(table, shift);
 }
 
-#else
-static inline void pgtable_free_tlb(struct mmu_gather *tlb, void *table, int shift)
-{
-	pgtable_free(table, shift);
-}
-#endif
-
 static inline void __pte_free_tlb(struct mmu_gather *tlb, pgtable_t table,
 				  unsigned long address)
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

