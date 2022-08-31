Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C913B5A878C
	for <lists+stable@lfdr.de>; Wed, 31 Aug 2022 22:32:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230338AbiHaUcL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 31 Aug 2022 16:32:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiHaUcK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 31 Aug 2022 16:32:10 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD662DF0B0
        for <stable@vger.kernel.org>; Wed, 31 Aug 2022 13:32:08 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id b44so19892712edf.9
        for <stable@vger.kernel.org>; Wed, 31 Aug 2022 13:32:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=nhZQAxpTJRR+h+b4la73g7IspvP0PnepXoa+PWz6iPs=;
        b=bnZx0xkK8l5sYuidFJi682wacSgAOOQzEKQkcFuCQ/wPTVLmB0fep4dMyHB6YQ4v5Q
         KoQxXgRdSI0EGDgrpHHxX8XYGtQ5wbalcJvzb2so9FxkHxjO6GeAgfwoTUT/2pQ2OUjN
         XzBiXwPPMXeSG6Tv8CbuhfgOQYeOd0zP5d14j/DpWl0cc6cYHhLPHXWUAuNpZ3R2tzEk
         i18HgH/GhINJebUsMn6UvPeMs6H+Blw4kueML5dDYgRsNh+SkkKl89Ts2Lhn4ku9VHVJ
         5hegTE3dte3TVox8kHJbRwHbD0aD3c5kMVW5rvmkf+heEisPY/t73qWH4PXfgYl+lavG
         b5yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=nhZQAxpTJRR+h+b4la73g7IspvP0PnepXoa+PWz6iPs=;
        b=g8tZj87+IpjqPiRqV0VL7mslRq8DiAYuhj4gdzLRnXO69vcpkUFFp71e77sTa+3B1V
         SSOxsoZRvzmFPac9nPXIjMbE3+0dM/OiSLkwPS/m8r+0yown4r2oWkgGKxBnm/MPX677
         y8M5r+ibcaU6om3NoW+/quwHYtfO2BtZk6Xc7FlJSZf2WWzKvQev5ZOrHIZm0Y17W76q
         1ZtnB9KKEWxjBYqTo+ww1SGskssV5OhlcJQpoMRZxYYhX4kF85qZw2Offrn6q6ofIQV4
         rYONhZZNBWzek245iKGrVR4ue7u1NJKbNfALjDpFR7p+ubrHGt2OngmU6RB+JFarvZ6h
         Yf4w==
X-Gm-Message-State: ACgBeo2nhYXDrPzUuJ0WISZuxYP7gH3FRKrhmbpLs3AOcbkYBzYHCL9U
        5OdLMDZbIHi/TNuNAJu9JAaTa1bQreEaJw==
X-Google-Smtp-Source: AA6agR5tyPW9bstkcZHaFnW4BxiX4VouhQSYGYQjdGaJ9+MWXdCbKcOY8ZLjBVJoKXRQuvKjs3d+/w==
X-Received: by 2002:a05:6402:518b:b0:448:f30:38b0 with SMTP id q11-20020a056402518b00b004480f3038b0mr19423413edd.164.1661977927376;
        Wed, 31 Aug 2022 13:32:07 -0700 (PDT)
Received: from localhost.localdomain (109-178-192-105.pat.ren.cosmote.net. [109.178.192.105])
        by smtp.gmail.com with ESMTPSA id a12-20020a50ff0c000000b00447d4109e16sm106380edu.87.2022.08.31.13.32.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Aug 2022 13:32:07 -0700 (PDT)
From:   Michael Bestas <mkbestas@gmail.com>
To:     stable@vger.kernel.org
Cc:     Hsin-Yi Wang <hsinyi@chromium.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Will Deacon <will@kernel.org>,
        Michael Bestas <mkbestas@gmail.com>
Subject: [PATCH] arm64: map FDT as RW for early_init_dt_scan()
Date:   Wed, 31 Aug 2022 23:32:00 +0300
Message-Id: <20220831203200.1684696-1-mkbestas@gmail.com>
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

Cc: stable@vger.kernel.org # 4.14
Signed-off-by: Hsin-Yi Wang <hsinyi@chromium.org>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Reviewed-by: Mike Rapoport <rppt@linux.ibm.com>
Signed-off-by: Will Deacon <will@kernel.org>
[mkbestas: fixed trivial conflicts for 4.14 backport]
Signed-off-by: Michael Bestas <mkbestas@gmail.com>
---
 arch/arm64/include/asm/mmu.h |  2 +-
 arch/arm64/kernel/kaslr.c    |  5 +----
 arch/arm64/kernel/setup.c    |  9 ++++++++-
 arch/arm64/mm/mmu.c          | 15 +--------------
 4 files changed, 11 insertions(+), 20 deletions(-)

diff --git a/arch/arm64/include/asm/mmu.h b/arch/arm64/include/asm/mmu.h
index 5a77dc775cc3c4..9494e35bf3a2a7 100644
--- a/arch/arm64/include/asm/mmu.h
+++ b/arch/arm64/include/asm/mmu.h
@@ -91,7 +91,7 @@ extern void init_mem_pgprot(void);
 extern void create_pgd_mapping(struct mm_struct *mm, phys_addr_t phys,
 			       unsigned long virt, phys_addr_t size,
 			       pgprot_t prot, bool page_mappings_only);
-extern void *fixmap_remap_fdt(phys_addr_t dt_phys);
+extern void *fixmap_remap_fdt(phys_addr_t dt_phys, int *size, pgprot_t prot);
 extern void mark_linear_text_alias_ro(void);
 
 #endif	/* !__ASSEMBLY__ */
diff --git a/arch/arm64/kernel/kaslr.c b/arch/arm64/kernel/kaslr.c
index ae727828609491..17fa1d363fff2c 100644
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
index d4b740538ad574..01b15d9dd8d62d 100644
--- a/arch/arm64/kernel/setup.c
+++ b/arch/arm64/kernel/setup.c
@@ -179,9 +179,13 @@ static void __init smp_build_mpidr_hash(void)
 
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
@@ -193,6 +197,9 @@ static void __init setup_machine_fdt(phys_addr_t dt_phys)
 			cpu_relax();
 	}
 
+	/* Early fixups are done, map the FDT as read-only now */
+	fixmap_remap_fdt(dt_phys, &size, PAGE_KERNEL_RO);
+
 	name = of_flat_dt_get_machine_name();
 	if (!name)
 		return;
diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index 4d472907194dd3..ce8c57d70e5fc7 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -836,7 +836,7 @@ void __set_fixmap(enum fixed_addresses idx,
 	}
 }
 
-void *__init __fixmap_remap_fdt(phys_addr_t dt_phys, int *size, pgprot_t prot)
+void *__init fixmap_remap_fdt(phys_addr_t dt_phys, int *size, pgprot_t prot)
 {
 	const u64 dt_virt_base = __fix_to_virt(FIX_FDT);
 	int offset;
@@ -889,19 +889,6 @@ void *__init __fixmap_remap_fdt(phys_addr_t dt_phys, int *size, pgprot_t prot)
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

