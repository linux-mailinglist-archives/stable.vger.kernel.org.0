Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8783F5921C5
	for <lists+stable@lfdr.de>; Sun, 14 Aug 2022 17:40:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240758AbiHNPj0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Aug 2022 11:39:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240793AbiHNPhh (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Aug 2022 11:37:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F69C20F69;
        Sun, 14 Aug 2022 08:32:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AF4B660C41;
        Sun, 14 Aug 2022 15:32:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CBA7C433D6;
        Sun, 14 Aug 2022 15:32:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660491146;
        bh=MWnYgLY5zU2YWGkXf3/KfDv1cw42WwuopIXFevHqSEo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PWWhl7jIRTGYTiMzqEbTL4gBQIWzvhRERSJbvC5XczsoxOfubpsxy5aXh9lfTKRip
         PI/P/lrS8Q5BdOletUdEpKMHu7FyfcFWCTZzkAHCDTeIgSXG5V1NoBHb3yFCtEHddV
         uG2dBNTSbI5Neq4FSeSsKeKDD+qmvsfQe8dZuxtPZkn6GEEqfk6/xzG9rwj6hLuOUO
         S3oLkykCj1pyRjmz5ms+GZ4hPDeTVb7HE2D9ZducxJwlzZnvS4zo52S5VjRIH7wHWc
         PLPCM1DcXU9HmiBGRC7NqVI3NfenHvoy0MmLS/mTJ9HQ27VL9zMxVp1ro9MRJIyFUu
         q9NBeb09s9dlw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lecopzer Chen <lecopzer.chen@mediatek.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Sasha Levin <sashal@kernel.org>, linux@armlinux.org.uk,
        ryabinin.a.a@gmail.com, matthias.bgg@gmail.com, arnd@arndb.de,
        ardb@kernel.org, rostedt@goodmis.org, nick.hawkins@hpe.com,
        john@phrozen.org, linux-arm-kernel@lists.infradead.org,
        kasan-dev@googlegroups.com, linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.18 46/56] ARM: 9202/1: kasan: support CONFIG_KASAN_VMALLOC
Date:   Sun, 14 Aug 2022 11:30:16 -0400
Message-Id: <20220814153026.2377377-46-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220814153026.2377377-1-sashal@kernel.org>
References: <20220814153026.2377377-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lecopzer Chen <lecopzer.chen@mediatek.com>

[ Upstream commit 565cbaad83d83e288927b96565211109bc984007 ]

Simply make shadow of vmalloc area mapped on demand.

Since the virtual address of vmalloc for Arm is also between
MODULE_VADDR and 0x100000000 (ZONE_HIGHMEM), which means the shadow
address has already included between KASAN_SHADOW_START and
KASAN_SHADOW_END.
Thus we need to change nothing for memory map of Arm.

This can fix ARM_MODULE_PLTS with KASan, support KASan for higmem
and support CONFIG_VMAP_STACK with KASan.

Signed-off-by: Lecopzer Chen <lecopzer.chen@mediatek.com>
Tested-by: Linus Walleij <linus.walleij@linaro.org>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/Kconfig         | 1 +
 arch/arm/mm/kasan_init.c | 6 +++++-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 2e8091e2d8a8..f440cf59cea1 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -75,6 +75,7 @@ config ARM
 	select HAVE_ARCH_KFENCE if MMU && !XIP_KERNEL
 	select HAVE_ARCH_KGDB if !CPU_ENDIAN_BE32 && MMU
 	select HAVE_ARCH_KASAN if MMU && !XIP_KERNEL
+	select HAVE_ARCH_KASAN_VMALLOC if HAVE_ARCH_KASAN
 	select HAVE_ARCH_MMAP_RND_BITS if MMU
 	select HAVE_ARCH_PFN_VALID
 	select HAVE_ARCH_SECCOMP
diff --git a/arch/arm/mm/kasan_init.c b/arch/arm/mm/kasan_init.c
index 5ad0d6c56d56..29caee9c79ce 100644
--- a/arch/arm/mm/kasan_init.c
+++ b/arch/arm/mm/kasan_init.c
@@ -236,7 +236,11 @@ void __init kasan_init(void)
 
 	clear_pgds(KASAN_SHADOW_START, KASAN_SHADOW_END);
 
-	kasan_populate_early_shadow(kasan_mem_to_shadow((void *)VMALLOC_START),
+	if (!IS_ENABLED(CONFIG_KASAN_VMALLOC))
+		kasan_populate_early_shadow(kasan_mem_to_shadow((void *)VMALLOC_START),
+					    kasan_mem_to_shadow((void *)VMALLOC_END));
+
+	kasan_populate_early_shadow(kasan_mem_to_shadow((void *)VMALLOC_END),
 				    kasan_mem_to_shadow((void *)-1UL) + 1);
 
 	for_each_mem_range(i, &pa_start, &pa_end) {
-- 
2.35.1

