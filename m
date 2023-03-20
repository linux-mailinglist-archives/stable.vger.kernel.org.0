Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D61216C0700
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 01:53:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229705AbjCTAxn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Mar 2023 20:53:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229588AbjCTAxV (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 19 Mar 2023 20:53:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD6921A66C;
        Sun, 19 Mar 2023 17:53:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B54F6611EA;
        Mon, 20 Mar 2023 00:53:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09454C4339E;
        Mon, 20 Mar 2023 00:53:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679273592;
        bh=CWlBYcUlEtV2WK9oxcnRHyaRYGfQvTSR1XBD+I+3xUE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NPG4zu7HkNjOBVxzQ37UQwEDHHjLZEiMIiMWfZRr2Qqqa40rQVrGRWDv6x6okg2Y8
         EACPi939NN1XsQ/OoQ4Piob36yl13efw+ozJ1AywF7gGCNWoTUaOq40u+M/zBclwA9
         62jj+RZoiaZqjdAlhz6xEe75NHPcluPQF9YUSJFrf3QyrDAHDxZ7sD8CrO1PaaXC+w
         U/6TqYYTZHTIzQGjRmGHceXJrM6zLlc66rXGsivfMpuhW9gjmG9GiXRaL8m3A93pXt
         1R6osYUziM9pTte0ug6jchwIlMJRqAefmE3bs+f2z2yVVityT7Bk66oDpz2HqKo+DC
         40kRUnE1Kyurw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kars de Jong <jongk@linux-m68k.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Sasha Levin <sashal@kernel.org>, gerg@linux-m68k.org,
        tiwai@suse.de, ulf.hansson@linaro.org, akpm@linux-foundation.org,
        anshuman.khandual@arm.com, arnd@arndb.de,
        linux-m68k@lists.linux-m68k.org
Subject: [PATCH AUTOSEL 6.2 06/30] m68k: mm: Fix systems with memory at end of 32-bit address space
Date:   Sun, 19 Mar 2023 20:52:31 -0400
Message-Id: <20230320005258.1428043-6-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230320005258.1428043-1-sashal@kernel.org>
References: <20230320005258.1428043-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kars de Jong <jongk@linux-m68k.org>

[ Upstream commit 0d9fad91abfd723ea5070a46d98a9f4496c93ba9 ]

The calculation of end addresses of memory chunks overflowed to 0 when
a memory chunk is located at the end of 32-bit address space.
This is the case for the HP300 architecture.

Link: https://lore.kernel.org/linux-m68k/CACz-3rhUo5pgNwdWHaPWmz+30Qo9xCg70wNxdf7o5x-6tXq8QQ@mail.gmail.com/
Signed-off-by: Kars de Jong <jongk@linux-m68k.org>
Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>
Link: https://lore.kernel.org/r/20230223112349.26675-1-jongk@linux-m68k.org
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/m68k/mm/motorola.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/m68k/mm/motorola.c b/arch/m68k/mm/motorola.c
index 2a375637e0077..9113012240789 100644
--- a/arch/m68k/mm/motorola.c
+++ b/arch/m68k/mm/motorola.c
@@ -437,7 +437,7 @@ void __init paging_init(void)
 	}
 
 	min_addr = m68k_memory[0].addr;
-	max_addr = min_addr + m68k_memory[0].size;
+	max_addr = min_addr + m68k_memory[0].size - 1;
 	memblock_add_node(m68k_memory[0].addr, m68k_memory[0].size, 0,
 			  MEMBLOCK_NONE);
 	for (i = 1; i < m68k_num_memory;) {
@@ -452,21 +452,21 @@ void __init paging_init(void)
 		}
 		memblock_add_node(m68k_memory[i].addr, m68k_memory[i].size, i,
 				  MEMBLOCK_NONE);
-		addr = m68k_memory[i].addr + m68k_memory[i].size;
+		addr = m68k_memory[i].addr + m68k_memory[i].size - 1;
 		if (addr > max_addr)
 			max_addr = addr;
 		i++;
 	}
 	m68k_memoffset = min_addr - PAGE_OFFSET;
-	m68k_virt_to_node_shift = fls(max_addr - min_addr - 1) - 6;
+	m68k_virt_to_node_shift = fls(max_addr - min_addr) - 6;
 
 	module_fixup(NULL, __start_fixup, __stop_fixup);
 	flush_icache();
 
-	high_memory = phys_to_virt(max_addr);
+	high_memory = phys_to_virt(max_addr) + 1;
 
 	min_low_pfn = availmem >> PAGE_SHIFT;
-	max_pfn = max_low_pfn = max_addr >> PAGE_SHIFT;
+	max_pfn = max_low_pfn = (max_addr >> PAGE_SHIFT) + 1;
 
 	/* Reserve kernel text/data/bss and the memory allocated in head.S */
 	memblock_reserve(m68k_memory[0].addr, availmem - m68k_memory[0].addr);
-- 
2.39.2

