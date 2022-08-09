Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD34858DA9A
	for <lists+stable@lfdr.de>; Tue,  9 Aug 2022 16:56:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244637AbiHIO4u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Aug 2022 10:56:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243505AbiHIO4t (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Aug 2022 10:56:49 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CB3C1B7B8
        for <stable@vger.kernel.org>; Tue,  9 Aug 2022 07:56:44 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id j1so14651040wrw.1
        for <stable@vger.kernel.org>; Tue, 09 Aug 2022 07:56:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=enfstd6XO27dG5QbFM634BTZNPGRgl8/GhZdf9CtEgQ=;
        b=DRxumZHOF1fB/N57jv7NwXjXE5aarH3IwsIo8eH9ffEH8QmXw5aMytz/6d6bt3g3ld
         NfMbVonr/+vtmQrkZACUMwnmtGwKObZ4VixAk2G25Hn9tevksu3xRiSW/Wv37nXZVr9G
         TXC7AePaXnX9b2F1HXE68pxzPLvRjBaV492e1HtV8D/XBRmSQ5YtQD93BAK1V+oUzFFN
         Zv9iWeUQSqjJJcn9sQxG4YnFwJ1YsdoP4St4fU7vDmlbPHRWFwSXX/Uy6UW3JLLKikVY
         /8v+nVC1fLoH4tYutqmbpsqfJoDXjxmpGgcZoDxnpiB6IBuQZXDR6Bn3cxVkef6gprJI
         TBxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=enfstd6XO27dG5QbFM634BTZNPGRgl8/GhZdf9CtEgQ=;
        b=Kv6gEgCuzjytZLBGHBuoT6y02lKvPdN5NkJhsKpwDUeMg/vJKUGw0I9vP1isXceoWC
         d+AEYMifdvrShmR43dL6/6NEe/VovjTPBsGvHYBEwjuUUI6MPtM478fjlMtG0r4xFqG9
         gP15sgjHk3wVIe4xP6Cj2IY0lrDh+81CZzlB5yjo4XXehZLk17fRDdpic6M6G7voEuhA
         K0wnkjRO8dnGoMEyWUWSl87o/zCqacjN7EImrs6KCdVA6qUDqzO7CEopvDWeZL3UhTVf
         WLRqbWHwoGM6cGGYb0YaWY9TcSxiPaK2XbdcA7hBUS5/Wm4LekHSrHvMyYw/7VK4LG1a
         iClQ==
X-Gm-Message-State: ACgBeo2G6bcb+Nd0BrzB33dsJBO9hHk8OJgOB6sJxjHbSQOjjSYyIKiA
        IEYHFBPx9weSKpgcrUwPRuLQbu6+dcX89Gk7
X-Google-Smtp-Source: AA6agR6LDwWdeRNJCxnLogebQvXAcWYjYjhPNJkVatFXyICF7V9CNNFRpwg7Tv/3rGG4rD1wDoKlVg==
X-Received: by 2002:adf:fc88:0:b0:220:61dc:d297 with SMTP id g8-20020adffc88000000b0022061dcd297mr13959048wrr.660.1660057002662;
        Tue, 09 Aug 2022 07:56:42 -0700 (PDT)
Received: from localhost.localdomain (109-178-233-54.pat.ren.cosmote.net. [109.178.233.54])
        by smtp.gmail.com with ESMTPSA id r3-20020a05600c424300b003a53de38c0dsm8216029wmm.14.2022.08.09.07.56.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Aug 2022 07:56:42 -0700 (PDT)
From:   Michael Bestas <mkbestas@gmail.com>
To:     stable@vger.kernel.org
Cc:     Hsin-Yi Wang <hsinyi@chromium.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Will Deacon <will@kernel.org>,
        Michael Bestas <mkbestas@gmail.com>
Subject: [PATCH] arm64: map FDT as RW for early_init_dt_scan()
Date:   Tue,  9 Aug 2022 17:56:24 +0300
Message-Id: <20220809145624.1819905-1-mkbestas@gmail.com>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hsin-Yi Wang <hsinyi@chromium.org>

commit e112b032a72c78f15d0c803c5dc6be444c2e6c66 upstream.

Currently in arm64, FDT is mapped to RO before it's passed to
early_init_dt_scan(). However, there might be some codes
(eg. commit "fdt: add support for rng-seed") that need to modify FDT
during init. Map FDT to RO after early fixups are done.

Cc: stable@vger.kernel.org # 4.9+
Signed-off-by: Hsin-Yi Wang <hsinyi@chromium.org>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Reviewed-by: Mike Rapoport <rppt@linux.ibm.com>
Signed-off-by: Will Deacon <will@kernel.org>
[mkbestas: fixed trivial conflicts for 4.9 backport]
Signed-off-by: Michael Bestas <mkbestas@gmail.com>
---
 arch/arm64/include/asm/mmu.h |  2 +-
 arch/arm64/kernel/kaslr.c    |  5 +----
 arch/arm64/kernel/setup.c    |  9 ++++++++-
 arch/arm64/mm/mmu.c          | 15 +--------------
 4 files changed, 11 insertions(+), 20 deletions(-)

diff --git a/arch/arm64/include/asm/mmu.h b/arch/arm64/include/asm/mmu.h
index f4377b005cba90..c944253b3a4b63 100644
--- a/arch/arm64/include/asm/mmu.h
+++ b/arch/arm64/include/asm/mmu.h
@@ -90,7 +90,7 @@ extern void init_mem_pgprot(void);
 extern void create_pgd_mapping(struct mm_struct *mm, phys_addr_t phys,
 			       unsigned long virt, phys_addr_t size,
 			       pgprot_t prot, bool allow_block_mappings);
-extern void *fixmap_remap_fdt(phys_addr_t dt_phys);
+extern void *fixmap_remap_fdt(phys_addr_t dt_phys, int *size, pgprot_t prot);
 
 #endif	/* !__ASSEMBLY__ */
 #endif
diff --git a/arch/arm64/kernel/kaslr.c b/arch/arm64/kernel/kaslr.c
index c9ca903462a68d..6a9668f6e933f3 100644
--- a/arch/arm64/kernel/kaslr.c
+++ b/arch/arm64/kernel/kaslr.c
@@ -65,9 +65,6 @@ static __init const u8 *kaslr_get_cmdline(void *fdt)
 	return default_cmdline;
 }
 
-extern void *__init __fixmap_remap_fdt(phys_addr_t dt_phys, int *size,
-				       pgprot_t prot);
-
 /*
  * This routine will be executed with the kernel mapped at its default virtual
  * address, and if it returns successfully, the kernel will be remapped, and
@@ -96,7 +93,7 @@ u64 __init kaslr_early_init(u64 dt_phys, u64 modulo_offset)
 	 * attempt at mapping the FDT in setup_machine()
 	 */
 	early_fixmap_init();
-	fdt = __fixmap_remap_fdt(dt_phys, &size, PAGE_KERNEL);
+	fdt = fixmap_remap_fdt(dt_phys, &size, PAGE_KERNEL);
 	if (!fdt)
 		return 0;
 
diff --git a/arch/arm64/kernel/setup.c b/arch/arm64/kernel/setup.c
index f534f492a26874..ae82d9694542cd 100644
--- a/arch/arm64/kernel/setup.c
+++ b/arch/arm64/kernel/setup.c
@@ -178,7 +178,11 @@ static void __init smp_build_mpidr_hash(void)
 
 static void __init setup_machine_fdt(phys_addr_t dt_phys)
 {
-	void *dt_virt = fixmap_remap_fdt(dt_phys);
+	int size;
+	void *dt_virt = fixmap_remap_fdt(dt_phys, &size, PAGE_KERNEL);
+
+	if (dt_virt)
+		memblock_reserve(dt_phys, size);
 
 	if (!dt_virt || !early_init_dt_scan(dt_virt)) {
 		pr_crit("\n"
@@ -191,6 +195,9 @@ static void __init setup_machine_fdt(phys_addr_t dt_phys)
 			cpu_relax();
 	}
 
+	/* Early fixups are done, map the FDT as read-only now */
+	fixmap_remap_fdt(dt_phys, &size, PAGE_KERNEL_RO);
+
 	dump_stack_set_arch_desc("%s (DT)", of_flat_dt_get_machine_name());
 }
 
diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index 36bd50091c4bbc..784ea7c8d99667 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -718,7 +718,7 @@ void __set_fixmap(enum fixed_addresses idx,
 	}
 }
 
-void *__init __fixmap_remap_fdt(phys_addr_t dt_phys, int *size, pgprot_t prot)
+void *__init fixmap_remap_fdt(phys_addr_t dt_phys, int *size, pgprot_t prot)
 {
 	const u64 dt_virt_base = __fix_to_virt(FIX_FDT);
 	int offset;
@@ -771,19 +771,6 @@ void *__init __fixmap_remap_fdt(phys_addr_t dt_phys, int *size, pgprot_t prot)
 	return dt_virt;
 }
 
-void *__init fixmap_remap_fdt(phys_addr_t dt_phys)
-{
-	void *dt_virt;
-	int size;
-
-	dt_virt = __fixmap_remap_fdt(dt_phys, &size, PAGE_KERNEL_RO);
-	if (!dt_virt)
-		return NULL;
-
-	memblock_reserve(dt_phys, size);
-	return dt_virt;
-}
-
 int __init arch_ioremap_pud_supported(void)
 {
 	/*
-- 
2.37.1

