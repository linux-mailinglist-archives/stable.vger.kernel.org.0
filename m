Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62E6258BEBB
	for <lists+stable@lfdr.de>; Mon,  8 Aug 2022 03:31:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241948AbiHHBbw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Aug 2022 21:31:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241882AbiHHBbt (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Aug 2022 21:31:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56B5AB7EC;
        Sun,  7 Aug 2022 18:31:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B3C8C60DDA;
        Mon,  8 Aug 2022 01:31:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6277C433D6;
        Mon,  8 Aug 2022 01:31:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659922300;
        bh=m0hTkEbkuaXphWWnC/gxMUIwGj3LqHqY6oqSiCR51TA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fwe78hh7sY/zfPysrHoiFQf+E0Hml2Yu06XapvElwS7X0FU9ix8Tz/OAHPk+Mt6Vb
         Z7/2BDYhnyS4NHzGejFPdq7dTn+A2V+Ac2qY0a7D0yI9xHK8OZNogFSVV+YmXtFtfo
         YbNs6r8bKKuADN/DVG1KEQ8trF3BFTlbLfbfhEBw2gUcmLl12GCvMokuy3Un1pbvas
         b8ZLyUAmi0hl8XjPGsvdS96lVL5eZHgX+GfM3nTtO6JfLl7DjO2x8fSR0nRnLTd49M
         g7JeDNZsBrXvuEO0lDzk5SlBJSe5ecqmP17DSOt3BwsA6/F0eG0RSn22EHVPRb6RqZ
         W01TLpG0Yr/mg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>,
        catalin.marinas@arm.com, bp@suse.de, Jason@zx2c4.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.19 05/58] arm64: kernel: drop unnecessary PoC cache clean+invalidate
Date:   Sun,  7 Aug 2022 21:30:23 -0400
Message-Id: <20220808013118.313965-5-sashal@kernel.org>
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

[ Upstream commit 2e945851e26836c0f2d34be3763ddf55870e49fe ]

Some early boot code runs before the virtual placement of the kernel is
finalized, and we used to go back to the very start and recreate the ID
map along with the page tables describing the virtual kernel mapping,
and this involved setting some global variables with the caches off.

In order to ensure that global state created by the KASLR code is not
corrupted by the cache invalidation that occurs in that case, we needed
to clean those global variables to the PoC explicitly.

This is no longer needed now that the ID map is created only once (and
the associated global variable updates are no longer repeated). So drop
the cache maintenance that is no longer necessary.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Link: https://lore.kernel.org/r/20220624150651.1358849-9-ardb@kernel.org
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/kaslr.c | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/arch/arm64/kernel/kaslr.c b/arch/arm64/kernel/kaslr.c
index 418b2bba1521..d5542666182f 100644
--- a/arch/arm64/kernel/kaslr.c
+++ b/arch/arm64/kernel/kaslr.c
@@ -13,7 +13,6 @@
 #include <linux/pgtable.h>
 #include <linux/random.h>
 
-#include <asm/cacheflush.h>
 #include <asm/fixmap.h>
 #include <asm/kernel-pgtable.h>
 #include <asm/memory.h>
@@ -72,9 +71,6 @@ u64 __init kaslr_early_init(void)
 	 * we end up running with module randomization disabled.
 	 */
 	module_alloc_base = (u64)_etext - MODULES_VSIZE;
-	dcache_clean_inval_poc((unsigned long)&module_alloc_base,
-			    (unsigned long)&module_alloc_base +
-				    sizeof(module_alloc_base));
 
 	/*
 	 * Try to map the FDT early. If this fails, we simply bail,
@@ -174,13 +170,6 @@ u64 __init kaslr_early_init(void)
 	module_alloc_base += (module_range * (seed & ((1 << 21) - 1))) >> 21;
 	module_alloc_base &= PAGE_MASK;
 
-	dcache_clean_inval_poc((unsigned long)&module_alloc_base,
-			    (unsigned long)&module_alloc_base +
-				    sizeof(module_alloc_base));
-	dcache_clean_inval_poc((unsigned long)&memstart_offset_seed,
-			    (unsigned long)&memstart_offset_seed +
-				    sizeof(memstart_offset_seed));
-
 	return offset;
 }
 
-- 
2.35.1

