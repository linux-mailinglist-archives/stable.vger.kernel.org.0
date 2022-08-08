Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E539358BEC3
	for <lists+stable@lfdr.de>; Mon,  8 Aug 2022 03:32:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241853AbiHHBcP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Aug 2022 21:32:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241988AbiHHBcF (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Aug 2022 21:32:05 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 438AEB85F;
        Sun,  7 Aug 2022 18:31:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 7AC3BCE0FDC;
        Mon,  8 Aug 2022 01:31:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F862C433D7;
        Mon,  8 Aug 2022 01:31:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659922312;
        bh=M8tgTeIXH/X67VpqjvwYuPRwGg0JWAjfCSGH3QwPtlw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Noa0M+CXTD0z3HCKkY58T+GPZUkyZ+0oQT9PxI0E4zlrl7weS+aXNcBO6sFtulMBt
         koVql3CakU4GSUsgS+NfUZayeX8FvtMXJbgCA6VkpFasiL5vWLjqJwZjxaBf4VyX7J
         XjUBWNco2yOT+gMMMsUVtTwyhS1P7qqlMoCq5e1uB2+UkJu7mJKJWHtV7fP4LOr7Ob
         8lO9OjA5GvBS0Xfars3HvEN7uHgH8SA2PPtvatJu0fRRDefNrRwjdoAMKvIs5hCyEm
         VRJsmEjn0UISbCSq1wC9jdNhsyl2QAfObYIH7QifnBmtsEx9RejA9sukTjkqn4or7B
         G5F8Sx+50ewkg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>, Will Deacon <will@kernel.org>,
        Sasha Levin <sashal@kernel.org>, catalin.marinas@arm.com,
        bp@suse.de, mpe@ellerman.id.au, mark.rutland@arm.com,
        Jason@zx2c4.com, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.19 07/58] arm64: kaslr: defer initialization to initcall where permitted
Date:   Sun,  7 Aug 2022 21:30:25 -0400
Message-Id: <20220808013118.313965-7-sashal@kernel.org>
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

[ Upstream commit fc5a89f75d2aad3e566e030675ac420aee49729c ]

The early KASLR init code runs extremely early, and anything that could
be deferred until later should be. So let's defer the randomization of
the module region until much later - this also simplifies the
arithmetic, given that we no longer have to reason about the link time
vs load time placement of the core kernel explicitly. Also get rid of
the global status variable, and infer the status reported by the
diagnostic print from other KASLR related context.

While at it, get rid of the special case for KASAN without
KASAN_VMALLOC, which never occurs in practice.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Link: https://lore.kernel.org/r/20220624150651.1358849-20-ardb@kernel.org
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/kaslr.c | 95 +++++++++++++++++----------------------
 1 file changed, 40 insertions(+), 55 deletions(-)

diff --git a/arch/arm64/kernel/kaslr.c b/arch/arm64/kernel/kaslr.c
index d5542666182f..3edee81d8ea7 100644
--- a/arch/arm64/kernel/kaslr.c
+++ b/arch/arm64/kernel/kaslr.c
@@ -20,14 +20,6 @@
 #include <asm/sections.h>
 #include <asm/setup.h>
 
-enum kaslr_status {
-	KASLR_ENABLED,
-	KASLR_DISABLED_CMDLINE,
-	KASLR_DISABLED_NO_SEED,
-	KASLR_DISABLED_FDT_REMAP,
-};
-
-static enum kaslr_status __initdata kaslr_status;
 u64 __ro_after_init module_alloc_base;
 u16 __initdata memstart_offset_seed;
 
@@ -63,15 +55,9 @@ struct arm64_ftr_override kaslr_feature_override __initdata;
 u64 __init kaslr_early_init(void)
 {
 	void *fdt;
-	u64 seed, offset, mask, module_range;
+	u64 seed, offset, mask;
 	unsigned long raw;
 
-	/*
-	 * Set a reasonable default for module_alloc_base in case
-	 * we end up running with module randomization disabled.
-	 */
-	module_alloc_base = (u64)_etext - MODULES_VSIZE;
-
 	/*
 	 * Try to map the FDT early. If this fails, we simply bail,
 	 * and proceed with KASLR disabled. We will make another
@@ -79,7 +65,6 @@ u64 __init kaslr_early_init(void)
 	 */
 	fdt = get_early_fdt_ptr();
 	if (!fdt) {
-		kaslr_status = KASLR_DISABLED_FDT_REMAP;
 		return 0;
 	}
 
@@ -93,7 +78,6 @@ u64 __init kaslr_early_init(void)
 	 * return 0 if that is the case.
 	 */
 	if (kaslr_feature_override.val & kaslr_feature_override.mask & 0xf) {
-		kaslr_status = KASLR_DISABLED_CMDLINE;
 		return 0;
 	}
 
@@ -106,7 +90,6 @@ u64 __init kaslr_early_init(void)
 		seed ^= raw;
 
 	if (!seed) {
-		kaslr_status = KASLR_DISABLED_NO_SEED;
 		return 0;
 	}
 
@@ -126,19 +109,43 @@ u64 __init kaslr_early_init(void)
 	/* use the top 16 bits to randomize the linear region */
 	memstart_offset_seed = seed >> 48;
 
-	if (!IS_ENABLED(CONFIG_KASAN_VMALLOC) &&
-	    (IS_ENABLED(CONFIG_KASAN_GENERIC) ||
-	     IS_ENABLED(CONFIG_KASAN_SW_TAGS)))
-		/*
-		 * KASAN without KASAN_VMALLOC does not expect the module region
-		 * to intersect the vmalloc region, since shadow memory is
-		 * allocated for each module at load time, whereas the vmalloc
-		 * region is shadowed by KASAN zero pages. So keep modules
-		 * out of the vmalloc region if KASAN is enabled without
-		 * KASAN_VMALLOC, and put the kernel well within 4 GB of the
-		 * module region.
-		 */
-		return offset % SZ_2G;
+	return offset;
+}
+
+static int __init kaslr_init(void)
+{
+	u64 module_range;
+	u32 seed;
+
+	/*
+	 * Set a reasonable default for module_alloc_base in case
+	 * we end up running with module randomization disabled.
+	 */
+	module_alloc_base = (u64)_etext - MODULES_VSIZE;
+
+	if (kaslr_feature_override.val & kaslr_feature_override.mask & 0xf) {
+		pr_info("KASLR disabled on command line\n");
+		return 0;
+	}
+
+	if (!kaslr_offset()) {
+		pr_warn("KASLR disabled due to lack of seed\n");
+		return 0;
+	}
+
+	pr_info("KASLR enabled\n");
+
+	/*
+	 * KASAN without KASAN_VMALLOC does not expect the module region to
+	 * intersect the vmalloc region, since shadow memory is allocated for
+	 * each module at load time, whereas the vmalloc region will already be
+	 * shadowed by KASAN zero pages.
+	 */
+	BUILD_BUG_ON((IS_ENABLED(CONFIG_KASAN_GENERIC) ||
+	              IS_ENABLED(CONFIG_KASAN_SW_TAGS)) &&
+		     !IS_ENABLED(CONFIG_KASAN_VMALLOC));
+
+	seed = get_random_u32();
 
 	if (IS_ENABLED(CONFIG_RANDOMIZE_MODULE_REGION_FULL)) {
 		/*
@@ -150,8 +157,7 @@ u64 __init kaslr_early_init(void)
 		 * resolved normally.)
 		 */
 		module_range = SZ_2G - (u64)(_end - _stext);
-		module_alloc_base = max((u64)_end + offset - SZ_2G,
-					(u64)MODULES_VADDR);
+		module_alloc_base = max((u64)_end - SZ_2G, (u64)MODULES_VADDR);
 	} else {
 		/*
 		 * Randomize the module region by setting module_alloc_base to
@@ -163,33 +169,12 @@ u64 __init kaslr_early_init(void)
 		 * when ARM64_MODULE_PLTS is enabled.
 		 */
 		module_range = MODULES_VSIZE - (u64)(_etext - _stext);
-		module_alloc_base = (u64)_etext + offset - MODULES_VSIZE;
 	}
 
 	/* use the lower 21 bits to randomize the base of the module region */
 	module_alloc_base += (module_range * (seed & ((1 << 21) - 1))) >> 21;
 	module_alloc_base &= PAGE_MASK;
 
-	return offset;
-}
-
-static int __init kaslr_init(void)
-{
-	switch (kaslr_status) {
-	case KASLR_ENABLED:
-		pr_info("KASLR enabled\n");
-		break;
-	case KASLR_DISABLED_CMDLINE:
-		pr_info("KASLR disabled on command line\n");
-		break;
-	case KASLR_DISABLED_NO_SEED:
-		pr_warn("KASLR disabled due to lack of seed\n");
-		break;
-	case KASLR_DISABLED_FDT_REMAP:
-		pr_warn("KASLR disabled due to FDT remapping failure\n");
-		break;
-	}
-
 	return 0;
 }
-core_initcall(kaslr_init)
+subsys_initcall(kaslr_init)
-- 
2.35.1

