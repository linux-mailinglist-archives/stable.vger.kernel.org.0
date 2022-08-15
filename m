Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3ED70594DF6
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 03:35:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345085AbiHPAsS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 20:48:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240319AbiHPAoE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 20:44:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC5E0AED99;
        Mon, 15 Aug 2022 13:40:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 79B56B8114A;
        Mon, 15 Aug 2022 20:40:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A66C6C433C1;
        Mon, 15 Aug 2022 20:40:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660596034;
        bh=tFMruD26R0zJmsKIkmvOkf54yAsxhFD3bcYpfWVgLpc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n1Nfu9NYR1fctv/FDsZbh5nKas72CguQ7zUlgVziDe1ZotECg3MNQuu3Kgr9hHwKX
         FYDQ4EfWCLXdigLs6z46n3dRSL+srviBUvahM2/RSXfbjYde6gCn0fYKeqpEDKwMgF
         A/I0UqBZ1WzIfb1iWmA8djToma7c5EFoUBgYaB48=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tiezhu Yang <yangtiezhu@loongson.cn>,
        Huacai Chen <chenhuacai@kernel.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0935/1157] MIPS: Loongson64: Fix section mismatch warning
Date:   Mon, 15 Aug 2022 20:04:51 +0200
Message-Id: <20220815180516.905931442@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tiezhu Yang <yangtiezhu@loongson.cn>

[ Upstream commit 08472f6ebdc23334ad11dcd761d2d52c32897793 ]

prom_init_numa_memory() is annotated __init and not used by any module,
thus don't export it.

Remove not needed EXPORT_SYMBOL for prom_init_numa_memory() to fix the
following section mismatch warning:

  LD      vmlinux.o
  MODPOST vmlinux.symvers
WARNING: modpost: vmlinux.o(___ksymtab+prom_init_numa_memory+0x0): Section mismatch in reference
from the variable __ksymtab_prom_init_numa_memory to the function .init.text:prom_init_numa_memory()
The symbol prom_init_numa_memory is exported and annotated __init
Fix this by removing the __init annotation of prom_init_numa_memory or drop the export.

This is build on Linux 5.19-rc4.

Fixes: 6fbde6b492df ("MIPS: Loongson64: Move files to the top-level directory")
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Reviewed-by: Huacai Chen <chenhuacai@kernel.org>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/loongson64/numa.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/mips/loongson64/numa.c b/arch/mips/loongson64/numa.c
index 69a533148efd..8f61e93c0c5b 100644
--- a/arch/mips/loongson64/numa.c
+++ b/arch/mips/loongson64/numa.c
@@ -196,7 +196,6 @@ void __init prom_init_numa_memory(void)
 	pr_info("CP0_PageGrain: CP0 5.1 (0x%x)\n", read_c0_pagegrain());
 	prom_meminit();
 }
-EXPORT_SYMBOL(prom_init_numa_memory);
 
 pg_data_t * __init arch_alloc_nodedata(int nid)
 {
-- 
2.35.1



