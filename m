Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85DAC5A878B
	for <lists+stable@lfdr.de>; Wed, 31 Aug 2022 22:31:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229498AbiHaUbP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 31 Aug 2022 16:31:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230078AbiHaUbO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 31 Aug 2022 16:31:14 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A70ABDD777
        for <stable@vger.kernel.org>; Wed, 31 Aug 2022 13:31:12 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id nc14so25750935ejc.4
        for <stable@vger.kernel.org>; Wed, 31 Aug 2022 13:31:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=5sNXe7ttAzy6eFAgYbY4aDZhT4hUcOCsVcj/haerTok=;
        b=AsITPviGKNvMGDW1yDKPFO+nSFNktYJXlUkfsrS4WTAjFewxA199SSwc07j443xpd/
         2t6iiiWdfxz8lSX/sGzDHkgcW1IUNB7SSeCWpYV8Vz+UvC7uWap0RS+traWo7cXE22vl
         9hd3S7Iv1DuTTuRWsXFtHoFwcmG82RHYcBG78kE8EFhCuioH6VM33TPL8MTwQoICwTO0
         8nAYtR85rhYE280Jm+C3dOcEDHwBVpXpvCpVltHougyD7B1VzGJ1xGIBrkQdMIu/E0lw
         TqHPiSc2afSkTSJO54BdGdhe3hLLffYfhXeZKzbXnhgBWn3/dtnpnqwWNhxNwiqUwRyh
         CJgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=5sNXe7ttAzy6eFAgYbY4aDZhT4hUcOCsVcj/haerTok=;
        b=EgHledTaUYA+ehnrtYmpbvskU6FiiDnyo6HaoVFM7sy/zNHKMR85MzC2opfdGlNcsX
         K6CjfxP4mPsT0xXkPamVRw7nKS3LA9OSywIbwqhZZMEao1l7wwYNZ7Txnjp/bVk5WunI
         vUzbqwSCpEcK5kcsnBgABlZP54UvFcYOpqWyYr1Yxo165G+8NLdhyqQlC+PduwUr5dBh
         JnW8pvbpGl0tCSDNxzpaI0607C+nr4Qgy0lbQBX+kTIdW94nSWz7qxFbKFGSw9q/u2vp
         7ahsNwPepQK8zASL0PVDlFAl35+qk8B/zhf2CzUNNVqWGimGZnM/u2IvLw6HOy6eoHNO
         /rRA==
X-Gm-Message-State: ACgBeo1TFi1WvXiQAbeyV/bwPDF+lRNSwDW8CAZstIcwb+EnyjQItvbl
        9uXYYP+dGLyL7iVSpZxp+4K1hma5EaR7zA==
X-Google-Smtp-Source: AA6agR4ikYz1WQ1HMk7oUYjBnR5JZAVldTWe43KwtX5nFKhZYEbd0mpW8MWKuh0US2dTl8S9vUO3IQ==
X-Received: by 2002:a17:907:6e18:b0:73d:63d9:945f with SMTP id sd24-20020a1709076e1800b0073d63d9945fmr21633523ejc.12.1661977871013;
        Wed, 31 Aug 2022 13:31:11 -0700 (PDT)
Received: from localhost.localdomain (109-178-192-105.pat.ren.cosmote.net. [109.178.192.105])
        by smtp.gmail.com with ESMTPSA id ee15-20020a056402290f00b00445d760fc69sm126342edb.50.2022.08.31.13.31.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Aug 2022 13:31:10 -0700 (PDT)
From:   Michael Bestas <mkbestas@gmail.com>
To:     stable@vger.kernel.org
Cc:     Hsin-Yi Wang <hsinyi@chromium.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Will Deacon <will@kernel.org>,
        Michael Bestas <mkbestas@gmail.com>
Subject: [PATCH] arm64: map FDT as RW for early_init_dt_scan()
Date:   Wed, 31 Aug 2022 23:30:38 +0300
Message-Id: <20220831203038.1677630-1-mkbestas@gmail.com>
X-Mailer: git-send-email 2.37.3
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

Cc: stable@vger.kernel.org # 4.19
Signed-off-by: Hsin-Yi Wang <hsinyi@chromium.org>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Reviewed-by: Mike Rapoport <rppt@linux.ibm.com>
Signed-off-by: Will Deacon <will@kernel.org>
[mkbestas: fixed trivial conflicts for 4.19 backport]
Signed-off-by: Michael Bestas <mkbestas@gmail.com>
---
 arch/arm64/include/asm/mmu.h |  2 +-
 arch/arm64/kernel/kaslr.c    |  5 +----
 arch/arm64/kernel/setup.c    |  9 ++++++++-
 arch/arm64/mm/mmu.c          | 15 +--------------
 4 files changed, 11 insertions(+), 20 deletions(-)

diff --git a/arch/arm64/include/asm/mmu.h b/arch/arm64/include/asm/mmu.h
index b37d185e0e841c..3dda6ff32efd7f 100644
--- a/arch/arm64/include/asm/mmu.h
+++ b/arch/arm64/include/asm/mmu.h
@@ -98,7 +98,7 @@ extern void init_mem_pgprot(void);
 extern void create_pgd_mapping(struct mm_struct *mm, phys_addr_t phys,
 			       unsigned long virt, phys_addr_t size,
 			       pgprot_t prot, bool page_mappings_only);
-extern void *fixmap_remap_fdt(phys_addr_t dt_phys);
+extern void *fixmap_remap_fdt(phys_addr_t dt_phys, int *size, pgprot_t prot);
 extern void mark_linear_text_alias_ro(void);
 
 #endif	/* !__ASSEMBLY__ */
diff --git a/arch/arm64/kernel/kaslr.c b/arch/arm64/kernel/kaslr.c
index 06941c1fe418e0..92bb53460401c0 100644
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
@@ -96,7 +93,7 @@ u64 __init kaslr_early_init(u64 dt_phys)
 	 * attempt at mapping the FDT in setup_machine()
 	 */
 	early_fixmap_init();
-	fdt = __fixmap_remap_fdt(dt_phys, &size, PAGE_KERNEL);
+	fdt = fixmap_remap_fdt(dt_phys, &size, PAGE_KERNEL);
 	if (!fdt)
 		return 0;
 
diff --git a/arch/arm64/kernel/setup.c b/arch/arm64/kernel/setup.c
index b3354ff94e7984..43e9786f1d6044 100644
--- a/arch/arm64/kernel/setup.c
+++ b/arch/arm64/kernel/setup.c
@@ -183,9 +183,13 @@ static void __init smp_build_mpidr_hash(void)
 
 static void __init setup_machine_fdt(phys_addr_t dt_phys)
 {
-	void *dt_virt = fixmap_remap_fdt(dt_phys);
+	int size;
+	void *dt_virt = fixmap_remap_fdt(dt_phys, &size, PAGE_KERNEL);
 	const char *name;
 
+	if (dt_virt)
+		memblock_reserve(dt_phys, size);
+
 	if (!dt_virt || !early_init_dt_scan(dt_virt)) {
 		pr_crit("\n"
 			"Error: invalid device tree blob at physical address %pa (virtual address 0x%p)\n"
@@ -197,6 +201,9 @@ static void __init setup_machine_fdt(phys_addr_t dt_phys)
 			cpu_relax();
 	}
 
+	/* Early fixups are done, map the FDT as read-only now */
+	fixmap_remap_fdt(dt_phys, &size, PAGE_KERNEL_RO);
+
 	name = of_flat_dt_get_machine_name();
 	if (!name)
 		return;
diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index b0a83dbed2dc44..7042fbb6d92bac 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -859,7 +859,7 @@ void __set_fixmap(enum fixed_addresses idx,
 	}
 }
 
-void *__init __fixmap_remap_fdt(phys_addr_t dt_phys, int *size, pgprot_t prot)
+void *__init fixmap_remap_fdt(phys_addr_t dt_phys, int *size, pgprot_t prot)
 {
 	const u64 dt_virt_base = __fix_to_virt(FIX_FDT);
 	int offset;
@@ -912,19 +912,6 @@ void *__init __fixmap_remap_fdt(phys_addr_t dt_phys, int *size, pgprot_t prot)
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
2.37.3

