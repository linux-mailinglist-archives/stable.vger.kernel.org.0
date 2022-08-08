Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EEC758BF69
	for <lists+stable@lfdr.de>; Mon,  8 Aug 2022 03:39:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242618AbiHHBjM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Aug 2022 21:39:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242507AbiHHBiR (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Aug 2022 21:38:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EED6E0D2;
        Sun,  7 Aug 2022 18:34:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BE403B80E0E;
        Mon,  8 Aug 2022 01:34:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69DF4C433C1;
        Mon,  8 Aug 2022 01:34:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659922441;
        bh=m0hTkEbkuaXphWWnC/gxMUIwGj3LqHqY6oqSiCR51TA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fx/oLxxB3mn9nKWGnwxYgZhwfpefqaKwIUUmcbqwq+8EAiMLJhzZO+09Qxgrzldsv
         mWBvXwoc+0/pLzGEkbJpMIlNy6sLVUSFakBHa/5vlbG+AQLFS+ZYalPGKd6j+Td0ua
         4hAeOmb8UYB8PooB/FrRd/j1SjHy/7tEOhoAzMguINhqWJzcKujfgHf0N5Td0GU/3n
         rdrM8SitRs0utx0b9dHCh9VJVrKXnUygpvPwT7TInWsr0xB9tpNnMwdwoIlJLmkogl
         yYN6u/d6KZFZCTgsn2Yv/BZnXodqYHI7YsIu4IIPi4Nh1Wp3dD/o2dpc5+K7oJARoV
         m7KQojQPFTvXA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>,
        catalin.marinas@arm.com, hca@linux.ibm.com, Jason@zx2c4.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.18 03/53] arm64: kernel: drop unnecessary PoC cache clean+invalidate
Date:   Sun,  7 Aug 2022 21:32:58 -0400
Message-Id: <20220808013350.314757-3-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220808013350.314757-1-sashal@kernel.org>
References: <20220808013350.314757-1-sashal@kernel.org>
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

