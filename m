Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 057416A3269
	for <lists+stable@lfdr.de>; Sun, 26 Feb 2023 16:38:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229758AbjBZPiS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Feb 2023 10:38:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbjBZPiM (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Feb 2023 10:38:12 -0500
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 901BA6195;
        Sun, 26 Feb 2023 07:37:56 -0800 (PST)
Received: by mail-lf1-x12f.google.com with SMTP id r27so5363839lfe.10;
        Sun, 26 Feb 2023 07:37:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AU8fbmkzw6fJ/9/3WpmqHnvxujK+M1whKxViRm0r9mg=;
        b=PtDR6RKJG4wxI5mHCRv7xDve6+yWo2w8RwXvuCokGANC3b1tvnenSHUCDlHR1Bx3D8
         m4dB+zV0p8VeYO5BjwWiJtUD+SYC/SSsLEFuNq5bZxnTrSTjwlnv7CZf6KWWZ0EMCrZi
         Db0vJmN20CHiHEZVFzprEzu04lPD2JHkNyJt78jmUvcEUinSm3kFfyJAZGNbbGtS5tPw
         F7nQm39KjQPs1PFasKzN/cL2IVIJvbTfZOhxV6QB3hRL/ihwhxP2p/Go8YD0CSiQVpx8
         9mN4BWqm8eL3l4dRoI4fmBT475LdtPSBsED3rkwxnX86cztoPiU1P6ZGqAJmBQgXzseS
         vyrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AU8fbmkzw6fJ/9/3WpmqHnvxujK+M1whKxViRm0r9mg=;
        b=TxUPnwblcx7bAXpZydSWwiZ+3WPTBKVUkFkmb4UYBe2pBDOjxyFkqM/7WL48eQmwRp
         VPlOlXkLCS9Nf+1hqR0ieplTCWQKcNpShPn2bYU5aS5EjM45IipjUp/V3N5YA3lWeChe
         J063WTRaH646dgWoqJySKv/eJhIH5wfjhP9mZkuENAgG5CWwKA7PwFLvW/VIMU7VFKuK
         qjaQS8ja4RjmKFZlCD6s3xFCPxLJKw16B18e6wsJqY0kLWcNpu7JSEAmEcvrkVJ3DHPv
         lt5KDagIJKj/Zh7m+Y5Hcx0ChVqDYid6+vjXUn+lLVANY5AlP/C5t3QaD+murryzB87A
         LoNA==
X-Gm-Message-State: AO0yUKWk0ejZBSTdas8kSVgd8sGNZmGz9O1Lu3i1TxLAmtZwilRfOsnf
        Y+S9gHQh2Mw3ikmU7W1nmU1LaYeoqUYmuuP3XWs=
X-Google-Smtp-Source: AK7set9hBGR0JAbPzigbHaqMspFiDSaFSBYwBSZSE/LcKnWZyxKjGuEPrk+fZeuuAlRKWFSLlwAz+Q==
X-Received: by 2002:ac2:59c4:0:b0:4dd:cef0:c27c with SMTP id x4-20020ac259c4000000b004ddcef0c27cmr1945798lfn.33.1677423721791;
        Sun, 26 Feb 2023 07:02:01 -0800 (PST)
Received: from localhost.localdomain ([5.188.167.245])
        by smtp.googlemail.com with ESMTPSA id z7-20020ac25de7000000b004db44dfd888sm580715lfq.30.2023.02.26.07.02.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Feb 2023 07:02:01 -0800 (PST)
From:   Sergey Matyukevich <geomatsi@gmail.com>
To:     linux-riscv@lists.infradead.org, linux-arch@vger.kernel.org
Cc:     Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Zong Li <zong.li@sifive.com>, Guo Ren <guoren@kernel.org>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Sergey Matyukevich <geomatsi@gmail.com>,
        Sergey Matyukevich <sergey.matyukevich@syntacore.com>,
        stable@vger.kernel.org
Subject: [PATCH 1/2] Revert "riscv: mm: notify remote harts about mmu cache updates"
Date:   Sun, 26 Feb 2023 18:01:36 +0300
Message-Id: <20230226150137.1919750-2-geomatsi@gmail.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230226150137.1919750-1-geomatsi@gmail.com>
References: <20230226150137.1919750-1-geomatsi@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sergey Matyukevich <sergey.matyukevich@syntacore.com>

This reverts the remaining bits of commit 4bd1d80efb5a ("riscv: mm:
notify remote harts harts about mmu cache updates").

According to bug reports, suggested approach to fix stale TLB entries
is not sufficient. It needs to be replaced by a more robust solution.

Fixes: 4bd1d80efb5a ("riscv: mm: notify remote harts about mmu cache updates")
Reported-by: Zong Li <zong.li@sifive.com>
Reported-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Signed-off-by: Sergey Matyukevich <sergey.matyukevich@syntacore.com>
Cc: stable@vger.kernel.org

---
 arch/riscv/include/asm/mmu.h      |  2 --
 arch/riscv/include/asm/tlbflush.h | 18 ------------------
 arch/riscv/mm/context.c           | 10 ----------
 arch/riscv/mm/tlbflush.c          | 28 +++++++++++++++++-----------
 4 files changed, 17 insertions(+), 41 deletions(-)

diff --git a/arch/riscv/include/asm/mmu.h b/arch/riscv/include/asm/mmu.h
index 5ff1f19fd45c..0099dc116168 100644
--- a/arch/riscv/include/asm/mmu.h
+++ b/arch/riscv/include/asm/mmu.h
@@ -19,8 +19,6 @@ typedef struct {
 #ifdef CONFIG_SMP
 	/* A local icache flush is needed before user execution can resume. */
 	cpumask_t icache_stale_mask;
-	/* A local tlb flush is needed before user execution can resume. */
-	cpumask_t tlb_stale_mask;
 #endif
 } mm_context_t;
 
diff --git a/arch/riscv/include/asm/tlbflush.h b/arch/riscv/include/asm/tlbflush.h
index 907b9efd39a8..801019381dea 100644
--- a/arch/riscv/include/asm/tlbflush.h
+++ b/arch/riscv/include/asm/tlbflush.h
@@ -22,24 +22,6 @@ static inline void local_flush_tlb_page(unsigned long addr)
 {
 	ALT_FLUSH_TLB_PAGE(__asm__ __volatile__ ("sfence.vma %0" : : "r" (addr) : "memory"));
 }
-
-static inline void local_flush_tlb_all_asid(unsigned long asid)
-{
-	__asm__ __volatile__ ("sfence.vma x0, %0"
-			:
-			: "r" (asid)
-			: "memory");
-}
-
-static inline void local_flush_tlb_page_asid(unsigned long addr,
-		unsigned long asid)
-{
-	__asm__ __volatile__ ("sfence.vma %0, %1"
-			:
-			: "r" (addr), "r" (asid)
-			: "memory");
-}
-
 #else /* CONFIG_MMU */
 #define local_flush_tlb_all()			do { } while (0)
 #define local_flush_tlb_page(addr)		do { } while (0)
diff --git a/arch/riscv/mm/context.c b/arch/riscv/mm/context.c
index 80ce9caba8d2..7acbfbd14557 100644
--- a/arch/riscv/mm/context.c
+++ b/arch/riscv/mm/context.c
@@ -196,16 +196,6 @@ static void set_mm_asid(struct mm_struct *mm, unsigned int cpu)
 
 	if (need_flush_tlb)
 		local_flush_tlb_all();
-#ifdef CONFIG_SMP
-	else {
-		cpumask_t *mask = &mm->context.tlb_stale_mask;
-
-		if (cpumask_test_cpu(cpu, mask)) {
-			cpumask_clear_cpu(cpu, mask);
-			local_flush_tlb_all_asid(cntx & asid_mask);
-		}
-	}
-#endif
 }
 
 static void set_mm_noasid(struct mm_struct *mm)
diff --git a/arch/riscv/mm/tlbflush.c b/arch/riscv/mm/tlbflush.c
index ce7dfc81bb3f..37ed760d007c 100644
--- a/arch/riscv/mm/tlbflush.c
+++ b/arch/riscv/mm/tlbflush.c
@@ -5,7 +5,23 @@
 #include <linux/sched.h>
 #include <asm/sbi.h>
 #include <asm/mmu_context.h>
-#include <asm/tlbflush.h>
+
+static inline void local_flush_tlb_all_asid(unsigned long asid)
+{
+	__asm__ __volatile__ ("sfence.vma x0, %0"
+			:
+			: "r" (asid)
+			: "memory");
+}
+
+static inline void local_flush_tlb_page_asid(unsigned long addr,
+		unsigned long asid)
+{
+	__asm__ __volatile__ ("sfence.vma %0, %1"
+			:
+			: "r" (addr), "r" (asid)
+			: "memory");
+}
 
 void flush_tlb_all(void)
 {
@@ -15,7 +31,6 @@ void flush_tlb_all(void)
 static void __sbi_tlb_flush_range(struct mm_struct *mm, unsigned long start,
 				  unsigned long size, unsigned long stride)
 {
-	struct cpumask *pmask = &mm->context.tlb_stale_mask;
 	struct cpumask *cmask = mm_cpumask(mm);
 	unsigned int cpuid;
 	bool broadcast;
@@ -29,15 +44,6 @@ static void __sbi_tlb_flush_range(struct mm_struct *mm, unsigned long start,
 	if (static_branch_unlikely(&use_asid_allocator)) {
 		unsigned long asid = atomic_long_read(&mm->context.id);
 
-		/*
-		 * TLB will be immediately flushed on harts concurrently
-		 * executing this MM context. TLB flush on other harts
-		 * is deferred until this MM context migrates there.
-		 */
-		cpumask_setall(pmask);
-		cpumask_clear_cpu(cpuid, pmask);
-		cpumask_andnot(pmask, pmask, cmask);
-
 		if (broadcast) {
 			sbi_remote_sfence_vma_asid(cmask, start, size, asid);
 		} else if (size <= stride) {
-- 
2.39.2

