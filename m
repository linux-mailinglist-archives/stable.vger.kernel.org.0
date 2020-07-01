Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66369210343
	for <lists+stable@lfdr.de>; Wed,  1 Jul 2020 07:22:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725783AbgGAFWW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jul 2020 01:22:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725771AbgGAFWU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Jul 2020 01:22:20 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FF32C061755
        for <stable@vger.kernel.org>; Tue, 30 Jun 2020 22:22:20 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id p1so173694pls.4
        for <stable@vger.kernel.org>; Tue, 30 Jun 2020 22:22:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fossix-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JwzS/oVv9S6l1kcjEkWV8SvZAflWcaMFizOPAE3TmCo=;
        b=JyOIDVWT+r+Rz06fqljLh6v2um5m92lM3YdGmC5N/gy+22d2QyHvK729z1+7mtB5kl
         RMSvo9EVuXd/tjBYp6G/ALcAmx638OzSpIyEefA+7ETAbxlTTrNOxV6fE75QbshONw6x
         vzy4/4gUjGG9xttuf3OdPqucn/3MkUsP1oludjeVXI9SKZEMEMUVPDk3SCSgZDjkqaNW
         YEecOlB9KX1sjsPDP2GRSefOq5OKEcPocLBk+cyBY3UmneXgVXYehGHu3CE+D4vgkMoC
         gJyrD5wIkv0byLjUpgdEEqzMD9e7cvjKOkUt5jFxD6hXObvlAjKy5smG7nMDQ/gaN2V1
         Lrow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JwzS/oVv9S6l1kcjEkWV8SvZAflWcaMFizOPAE3TmCo=;
        b=ihr1Gjz9dTKE/pMwz0twA4mbPu4CPLsMLh8FmipRSof5sgUM8n1Dz8FTZY1cUvjngZ
         +sKKmXW9FlBl2XCIcbOMpGDm2fJWJ0lLS32UfCyfCCB8ii5qP1thc654MWrXjX4lrBwd
         VIqq4Vkc6ypFwSB9KZhDujPy8Gsl8o5aw6myN1P9anrfkuKQETkHBZCDUw7LHVwLE7PC
         a+fHFHB1N7XrfqNtRVDveBmTCmk16JStciLcTn3ggXxdSMo0jjkZ+01Cnq43qS0n6Yis
         txqEJ0wmPvmh/JUDsiGTtf8QOGd6R1gdhWr7rJ/lAwjfNxhaspsBn/7tFceCJBCYXvKT
         nEXA==
X-Gm-Message-State: AOAM530jdMo/Hjjk7i8wMQ57e6kEZujYnalVqF0m51WUo8zJd2UMx8b1
        9fxe7nEDt6plkyfYSChWlqL6blNTYE0=
X-Google-Smtp-Source: ABdhPJyPvCUSmPdUlq+wotyfFaC/k7YHm0LZFMOAHDDVtTmGsZtEAgEW49GFsVCFCVD+Y8HkRN4cDA==
X-Received: by 2002:a17:90a:778c:: with SMTP id v12mr26412331pjk.34.1593580938600;
        Tue, 30 Jun 2020 22:22:18 -0700 (PDT)
Received: from santosiv.in.ibm.com.com ([203.223.190.240])
        by smtp.gmail.com with ESMTPSA id y80sm4375201pfb.165.2020.06.30.22.22.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2020 22:22:17 -0700 (PDT)
From:   Santosh Sivaraj <santosh@fossix.org>
To:     <stable@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
Cc:     Greg KH <greg@kroah.com>, Sasha Levin <sashal@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        Santosh Sivaraj <santosh@fossix.org>
Subject: [PATCH 1/2] powerpc/mmu_gather: enable RCU_TABLE_FREE even for !SMP case
Date:   Wed,  1 Jul 2020 10:51:46 +0530
Message-Id: <20200701052147.1698510-1-santosh@fossix.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>

commit 12e4d53f3f04e81f9e83d6fc10edc7314ab9f6b9 upstream

The TLB flush optimisation (a46cc7a90f: powerpc/mm/radix: Improve TLB/PWC
flushes) may result in random memory corruption.

On any SMP system, freeing page directories should observe the exact same
order as normal page freeing:

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
---
 arch/powerpc/Kconfig                         | 2 +-
 arch/powerpc/include/asm/book3s/32/pgalloc.h | 8 --------
 arch/powerpc/include/asm/book3s/64/pgalloc.h | 2 --
 arch/powerpc/include/asm/nohash/32/pgalloc.h | 8 --------
 arch/powerpc/mm/pgtable-book3s64.c           | 7 -------
 5 files changed, 1 insertion(+), 26 deletions(-)

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index f38d153d25861..4863fc0dd945a 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -215,7 +215,7 @@ config PPC
 	select HAVE_HARDLOCKUP_DETECTOR_PERF	if PERF_EVENTS && HAVE_PERF_EVENTS_NMI && !HAVE_HARDLOCKUP_DETECTOR_ARCH
 	select HAVE_PERF_REGS
 	select HAVE_PERF_USER_STACK_DUMP
-	select HAVE_RCU_TABLE_FREE		if SMP
+	select HAVE_RCU_TABLE_FREE
 	select HAVE_REGS_AND_STACK_ACCESS_API
 	select HAVE_RELIABLE_STACKTRACE		if PPC64 && CPU_LITTLE_ENDIAN
 	select HAVE_SYSCALL_TRACEPOINTS
diff --git a/arch/powerpc/include/asm/book3s/32/pgalloc.h b/arch/powerpc/include/asm/book3s/32/pgalloc.h
index 82e44b1a00ae9..79ba3fbb512e3 100644
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
index f9019b579903a..1013c02142139 100644
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
index 8825953c225b2..96eed46d56842 100644
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
index 297db665d953c..5b4e9fd8990c2 100644
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
2.26.2

