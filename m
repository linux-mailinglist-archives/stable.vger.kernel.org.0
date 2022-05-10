Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88AA25218D6
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:39:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243654AbiEJNkl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:40:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245202AbiEJNii (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:38:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9F092980A;
        Tue, 10 May 2022 06:28:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 644EB60C1C;
        Tue, 10 May 2022 13:28:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70378C385A6;
        Tue, 10 May 2022 13:28:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652189325;
        bh=iGVnxWxoOhBcJQqdzfpfv49ak3HYriGUEF0owT0UMQs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h+mGm2KvLp20rrWfzZ0I0nYZ5E/bv0/uLRjYcuyyFAuKcfFQdpxImTAAShFHkkAHN
         Ipik3pswvOdPvtZ2UIGjuxpMRSlgnKTTl8v/9xBwusTNK5Sa/d4nzK0B1vW+HY1Mx4
         fuI/DgVrPXVJVY+a1rt/4e+EuYHBbrhkZKU3sr6k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nick Kossifidis <mick@ics.forth.gr>,
        Conor Dooley <conor.dooley@microchip.com>,
        Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 5.15 015/135] RISC-V: relocate DTB if its outside memory region
Date:   Tue, 10 May 2022 15:06:37 +0200
Message-Id: <20220510130740.836495192@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130740.392653815@linuxfoundation.org>
References: <20220510130740.392653815@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nick Kossifidis <mick@ics.forth.gr>

commit c6fe81191bd74f7e6ae9ce96a4837df9485f3ab8 upstream.

In case the DTB provided by the bootloader/BootROM is before the kernel
image or outside /memory, we won't be able to access it through the
linear mapping, and get a segfault on setup_arch(). Currently OpenSBI
relocates DTB but that's not always the case (e.g. if FW_JUMP_FDT_ADDR
is not specified), and it's also not the most portable approach since
the default FW_JUMP_FDT_ADDR of the generic platform relocates the DTB
at a specific offset that may not be available. To avoid this situation
copy DTB so that it's visible through the linear mapping.

Signed-off-by: Nick Kossifidis <mick@ics.forth.gr>
Link: https://lore.kernel.org/r/20220322132839.3653682-1-mick@ics.forth.gr
Tested-by: Conor Dooley <conor.dooley@microchip.com>
Fixes: f105aa940e78 ("riscv: add BUILTIN_DTB support for MMU-enabled targets")
Cc: stable@vger.kernel.org
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/mm/init.c |   21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

--- a/arch/riscv/mm/init.c
+++ b/arch/riscv/mm/init.c
@@ -218,8 +218,25 @@ static void __init setup_bootmem(void)
 	 * early_init_fdt_reserve_self() since __pa() does
 	 * not work for DTB pointers that are fixmap addresses
 	 */
-	if (!IS_ENABLED(CONFIG_BUILTIN_DTB))
-		memblock_reserve(dtb_early_pa, fdt_totalsize(dtb_early_va));
+	if (!IS_ENABLED(CONFIG_BUILTIN_DTB)) {
+		/*
+		 * In case the DTB is not located in a memory region we won't
+		 * be able to locate it later on via the linear mapping and
+		 * get a segfault when accessing it via __va(dtb_early_pa).
+		 * To avoid this situation copy DTB to a memory region.
+		 * Note that memblock_phys_alloc will also reserve DTB region.
+		 */
+		if (!memblock_is_memory(dtb_early_pa)) {
+			size_t fdt_size = fdt_totalsize(dtb_early_va);
+			phys_addr_t new_dtb_early_pa = memblock_phys_alloc(fdt_size, PAGE_SIZE);
+			void *new_dtb_early_va = early_memremap(new_dtb_early_pa, fdt_size);
+
+			memcpy(new_dtb_early_va, dtb_early_va, fdt_size);
+			early_memunmap(new_dtb_early_va, fdt_size);
+			_dtb_early_pa = new_dtb_early_pa;
+		} else
+			memblock_reserve(dtb_early_pa, fdt_totalsize(dtb_early_va));
+	}
 
 	early_init_fdt_scan_reserved_mem();
 	dma_contiguous_reserve(dma32_phys_limit);


