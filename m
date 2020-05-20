Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C6F21DAD8B
	for <lists+stable@lfdr.de>; Wed, 20 May 2020 10:33:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726801AbgETIdY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 May 2020 04:33:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726436AbgETIdX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 May 2020 04:33:23 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5143EC061A0E
        for <stable@vger.kernel.org>; Wed, 20 May 2020 01:33:23 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id 23so1203310pfy.8
        for <stable@vger.kernel.org>; Wed, 20 May 2020 01:33:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fossix-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0WrLFXSRKQDZy0BVrG6fpwzhIiirPXa1ZZ2+F23h/xo=;
        b=RJoZ4Xg9ChrLjboaatcLi11P3/BfFu9/06Ez954FemKONvyNrhGgP9Qs0LwpVeg4qN
         aQc42ZbQuHmOm6vfNKmslrKcoNmzYWzJgnf+MSOsyRFXUKBm2ltW+iBqFX+IzgD514ru
         WkQM+Uka+sWIrwtQFdTJWmE/HOaxEIYUlmkZS5mpah7gmVboRk8vsfQ2q4eXk2/XJRn2
         CD29DRxhipU3EnBWYRAXu6BGi6hGiibdb2YMIg2Nnhqru+Ys70dG7VjAnO+HPGmfwmyn
         ctTyAitOLgjZbdz7rDX7qPfPXe3r7n7U6eRQH/XkQdB9gWS0EXlYHc1NvyAjTqtBkBD/
         tT2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0WrLFXSRKQDZy0BVrG6fpwzhIiirPXa1ZZ2+F23h/xo=;
        b=dEIdlbErkYl+YwQzj1RQUfU3DaXdKD61u/fVoC19mZ3F7Nao6a2z8MaERo+edXArFL
         uBJd5slilFyekwPwuBSAlaSsIDe+eJI8P5QGNkrJ0p9rBel413DTSc8wuvlpDAnQnOje
         K4aJU5Tp7AkArrfpQHbdlqMOxeZBTCOUsVSOCbU4LHJ7c2J7ipSJon8iTtluMUrgNJOx
         k1RFmTY4j/PGEAZ2W8ebCpJjoiC/6OAJR0lJroyr5j2TGQb3dFAzdHcPxBbBd/tTuA+1
         GQaVHDQu/1x5V83/0i5gEqpuDGWqctE2JHGdxpBuu3VK5I/TUGp8SglI/fZtH/MdV5er
         480g==
X-Gm-Message-State: AOAM532D+aBj3TRsEW41hC2GEHocWJYFwbTKZnQOIUrQPcZwtrh2ocZc
        UdbmtjnFUoiDrCkTYu2YahoOSrNFCOU=
X-Google-Smtp-Source: ABdhPJxZ9CDZanXwI00iKof052hSihO6c0Z7hLztBSZhU7r7znhPh7idsoGP8V6L4cp8OvOwqhZk1w==
X-Received: by 2002:a63:4c1d:: with SMTP id z29mr2968658pga.243.1589963602568;
        Wed, 20 May 2020 01:33:22 -0700 (PDT)
Received: from santosiv.in.ibm.com.com ([223.181.246.139])
        by smtp.gmail.com with ESMTPSA id 2sm1553980pfz.39.2020.05.20.01.33.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2020 01:33:22 -0700 (PDT)
From:   Santosh Sivaraj <santosh@fossix.org>
To:     <stable@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
Cc:     Michael Ellerman <mpe@ellerman.id.au>, Greg KH <greg@kroah.com>,
        Sasha Levin <sashal@kernel.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        Santosh Sivaraj <santosh@fossix.org>
Subject: [PATCH v4 4/6] powerpc/mmu_gather: enable RCU_TABLE_FREE even for !SMP case
Date:   Wed, 20 May 2020 14:00:23 +0530
Message-Id: <20200520083025.229011-5-santosh@fossix.org>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200520083025.229011-1-santosh@fossix.org>
References: <20200520083025.229011-1-santosh@fossix.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>

commit 12e4d53f3f04e81f9e83d6fc10edc7314ab9f6b9 upstream

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
 arch/powerpc/mm/pgtable-book3s64.c           | 7 -------
 5 files changed, 1 insertion(+), 26 deletions(-)

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
2.25.4

