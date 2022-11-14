Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6607627EA1
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 13:49:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237248AbiKNMtt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 07:49:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237380AbiKNMts (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 07:49:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D62702AF2
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 04:49:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 724A461154
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 12:49:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53977C433D7;
        Mon, 14 Nov 2022 12:49:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668430186;
        bh=YnaSHKFbIshoO9+bOSUe3RvsKn81p/tl9zRdqedM/8E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oYNnRf9gjR8U2EgUR2cvot9ZQTQ10FhFz5X4V3VqHp3YFPHP/zfERgZ8dZFpgkmfQ
         JmdY3uYy+buBajnt1Pa6ShdsnbfMJO4aTQrcclc7igKShCNUsDXkuNQVBHPMdocukT
         bJepPCGA57k3xx26l74d2QkKbNIakXm2kWuHnbik=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Kefeng Wang <wangkefeng.wang@huawei.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 52/95] riscv: Enable CMA support
Date:   Mon, 14 Nov 2022 13:45:46 +0100
Message-Id: <20221114124444.693709445@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124442.530286937@linuxfoundation.org>
References: <20221114124442.530286937@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kefeng Wang <wangkefeng.wang@huawei.com>

[ Upstream commit da815582cf4594e96defa1cddb72cd00b1e7aac5 ]

riscv has selected HAVE_DMA_CONTIGUOUS, but doesn't call
dma_contiguous_reserve().  This calls dma_contiguous_reserve(), which
enables CMA.

Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>
Stable-dep-of: 50e63dd8ed92 ("riscv: fix reserved memory setup")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/mm/init.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/mm/init.c b/arch/riscv/mm/init.c
index e8921e78a292..56314e82f051 100644
--- a/arch/riscv/mm/init.c
+++ b/arch/riscv/mm/init.c
@@ -13,6 +13,7 @@
 #include <linux/of_fdt.h>
 #include <linux/libfdt.h>
 #include <linux/set_memory.h>
+#include <linux/dma-map-ops.h>
 
 #include <asm/fixmap.h>
 #include <asm/tlbflush.h>
@@ -41,13 +42,14 @@ struct pt_alloc_ops {
 #endif
 };
 
+static phys_addr_t dma32_phys_limit __ro_after_init;
+
 static void __init zone_sizes_init(void)
 {
 	unsigned long max_zone_pfns[MAX_NR_ZONES] = { 0, };
 
 #ifdef CONFIG_ZONE_DMA32
-	max_zone_pfns[ZONE_DMA32] = PFN_DOWN(min(4UL * SZ_1G,
-			(unsigned long) PFN_PHYS(max_low_pfn)));
+	max_zone_pfns[ZONE_DMA32] = PFN_DOWN(dma32_phys_limit);
 #endif
 	max_zone_pfns[ZONE_NORMAL] = max_low_pfn;
 
@@ -193,6 +195,7 @@ void __init setup_bootmem(void)
 
 	max_pfn = PFN_DOWN(dram_end);
 	max_low_pfn = max_pfn;
+	dma32_phys_limit = min(4UL * SZ_1G, (unsigned long)PFN_PHYS(max_low_pfn));
 	set_max_mapnr(max_low_pfn);
 
 #ifdef CONFIG_BLK_DEV_INITRD
@@ -206,6 +209,7 @@ void __init setup_bootmem(void)
 	memblock_reserve(dtb_early_pa, fdt_totalsize(dtb_early_va));
 
 	early_init_fdt_scan_reserved_mem();
+	dma_contiguous_reserve(dma32_phys_limit);
 	memblock_allow_resize();
 	memblock_dump_all();
 }
-- 
2.35.1



