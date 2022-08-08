Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24D5658BEC1
	for <lists+stable@lfdr.de>; Mon,  8 Aug 2022 03:32:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242045AbiHHBcM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Aug 2022 21:32:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241832AbiHHBby (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Aug 2022 21:31:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC97AB7FD;
        Sun,  7 Aug 2022 18:31:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4837A60DDD;
        Mon,  8 Aug 2022 01:31:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06567C433D6;
        Mon,  8 Aug 2022 01:31:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659922309;
        bh=qQUbmiRkpj8z8IxYvP5jFkhihFG2Xg0KKDonGA2yK1Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fhFWLbzOa+yAiQVRlE0YOU7dXGbYReHgT+wvU8vw1m3Q+3JBAzocRPo70nlkAizdZ
         UvLYMbmn8z1IbuabhsyO1Xf66C3XHlWEKzki5L0naGsJCIrKr+y2kNQ7enTA6S+73D
         rVCQm5UpQNY2nJ9axiaO8W5F4pVQsU2hqvbZA9sLuKRfhrI2hvANETUnHzkFupByJR
         QlQAeK4vHcy2ag1CPcT0jL9x9HpZUOp99D+h+WI9YquhUFVcN+i8QrqL6jAF77rUIi
         sfeQIH+oI7v7lyg419pS+DQqOfTHFl7L9zO2VlyZdQfkFRB7fqWOzw9riGxS1Qrbev
         3o+Gn8oAAXltw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>, Will Deacon <will@kernel.org>,
        Sasha Levin <sashal@kernel.org>, catalin.marinas@arm.com,
        ryabinin.a.a@gmail.com, pasha.tatashin@soleen.com,
        peterz@infradead.org, broonie@kernel.org, maz@kernel.org,
        suzuki.poulose@arm.com, james.morse@arm.com,
        vladimir.murzin@arm.com, Julia.Lawall@inria.fr,
        anshuman.khandual@arm.com, akpm@linux-foundation.org,
        vijayb@linux.microsoft.com, quic_sudaraja@quicinc.com,
        jianyong.wu@arm.com, rppt@kernel.org, david@redhat.com,
        linux-arm-kernel@lists.infradead.org, kasan-dev@googlegroups.com
Subject: [PATCH AUTOSEL 5.19 06/58] arm64: mm: provide idmap pointer to cpu_replace_ttbr1()
Date:   Sun,  7 Aug 2022 21:30:24 -0400
Message-Id: <20220808013118.313965-6-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220808013118.313965-1-sashal@kernel.org>
References: <20220808013118.313965-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ard Biesheuvel <ardb@kernel.org>

[ Upstream commit 1682c45b920643cbde31d8a5b7ca7c2be92d6928 ]

In preparation for changing the way we initialize the permanent ID map,
update cpu_replace_ttbr1() so we can use it with the initial ID map as
well.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Link: https://lore.kernel.org/r/20220624150651.1358849-11-ardb@kernel.org
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/mmu_context.h | 13 +++++++++----
 arch/arm64/kernel/cpufeature.c       |  2 +-
 arch/arm64/kernel/suspend.c          |  2 +-
 arch/arm64/mm/kasan_init.c           |  4 ++--
 arch/arm64/mm/mmu.c                  |  2 +-
 5 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/include/asm/mmu_context.h b/arch/arm64/include/asm/mmu_context.h
index 6770667b34a3..f47e7ced3ff9 100644
--- a/arch/arm64/include/asm/mmu_context.h
+++ b/arch/arm64/include/asm/mmu_context.h
@@ -106,13 +106,18 @@ static inline void cpu_uninstall_idmap(void)
 		cpu_switch_mm(mm->pgd, mm);
 }
 
-static inline void cpu_install_idmap(void)
+static inline void __cpu_install_idmap(pgd_t *idmap)
 {
 	cpu_set_reserved_ttbr0();
 	local_flush_tlb_all();
 	cpu_set_idmap_tcr_t0sz();
 
-	cpu_switch_mm(lm_alias(idmap_pg_dir), &init_mm);
+	cpu_switch_mm(lm_alias(idmap), &init_mm);
+}
+
+static inline void cpu_install_idmap(void)
+{
+	__cpu_install_idmap(idmap_pg_dir);
 }
 
 /*
@@ -143,7 +148,7 @@ static inline void cpu_install_ttbr0(phys_addr_t ttbr0, unsigned long t0sz)
  * Atomically replaces the active TTBR1_EL1 PGD with a new VA-compatible PGD,
  * avoiding the possibility of conflicting TLB entries being allocated.
  */
-static inline void __nocfi cpu_replace_ttbr1(pgd_t *pgdp)
+static inline void __nocfi cpu_replace_ttbr1(pgd_t *pgdp, pgd_t *idmap)
 {
 	typedef void (ttbr_replace_func)(phys_addr_t);
 	extern ttbr_replace_func idmap_cpu_replace_ttbr1;
@@ -166,7 +171,7 @@ static inline void __nocfi cpu_replace_ttbr1(pgd_t *pgdp)
 
 	replace_phys = (void *)__pa_symbol(function_nocfi(idmap_cpu_replace_ttbr1));
 
-	cpu_install_idmap();
+	__cpu_install_idmap(idmap);
 	replace_phys(ttbr1);
 	cpu_uninstall_idmap();
 }
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 8d88433de81d..a97913d19709 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -3218,7 +3218,7 @@ subsys_initcall_sync(init_32bit_el0_mask);
 
 static void __maybe_unused cpu_enable_cnp(struct arm64_cpu_capabilities const *cap)
 {
-	cpu_replace_ttbr1(lm_alias(swapper_pg_dir));
+	cpu_replace_ttbr1(lm_alias(swapper_pg_dir), idmap_pg_dir);
 }
 
 /*
diff --git a/arch/arm64/kernel/suspend.c b/arch/arm64/kernel/suspend.c
index 2b0887e58a7c..9135fe0f3df5 100644
--- a/arch/arm64/kernel/suspend.c
+++ b/arch/arm64/kernel/suspend.c
@@ -52,7 +52,7 @@ void notrace __cpu_suspend_exit(void)
 
 	/* Restore CnP bit in TTBR1_EL1 */
 	if (system_supports_cnp())
-		cpu_replace_ttbr1(lm_alias(swapper_pg_dir));
+		cpu_replace_ttbr1(lm_alias(swapper_pg_dir), idmap_pg_dir);
 
 	/*
 	 * PSTATE was not saved over suspend/resume, re-enable any detected
diff --git a/arch/arm64/mm/kasan_init.c b/arch/arm64/mm/kasan_init.c
index c12cd700598f..e969e68de005 100644
--- a/arch/arm64/mm/kasan_init.c
+++ b/arch/arm64/mm/kasan_init.c
@@ -236,7 +236,7 @@ static void __init kasan_init_shadow(void)
 	 */
 	memcpy(tmp_pg_dir, swapper_pg_dir, sizeof(tmp_pg_dir));
 	dsb(ishst);
-	cpu_replace_ttbr1(lm_alias(tmp_pg_dir));
+	cpu_replace_ttbr1(lm_alias(tmp_pg_dir), idmap_pg_dir);
 
 	clear_pgds(KASAN_SHADOW_START, KASAN_SHADOW_END);
 
@@ -280,7 +280,7 @@ static void __init kasan_init_shadow(void)
 				PAGE_KERNEL_RO));
 
 	memset(kasan_early_shadow_page, KASAN_SHADOW_INIT, PAGE_SIZE);
-	cpu_replace_ttbr1(lm_alias(swapper_pg_dir));
+	cpu_replace_ttbr1(lm_alias(swapper_pg_dir), idmap_pg_dir);
 }
 
 static void __init kasan_init_depth(void)
diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index 626ec32873c6..903745ea801a 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -771,7 +771,7 @@ void __init paging_init(void)
 
 	pgd_clear_fixmap();
 
-	cpu_replace_ttbr1(lm_alias(swapper_pg_dir));
+	cpu_replace_ttbr1(lm_alias(swapper_pg_dir), idmap_pg_dir);
 	init_mm.pgd = swapper_pg_dir;
 
 	memblock_phys_free(__pa_symbol(init_pg_dir),
-- 
2.35.1

