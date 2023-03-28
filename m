Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 298DB6CC33D
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 16:52:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233403AbjC1Ow3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 10:52:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233357AbjC1OwL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 10:52:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EDE3E1BD
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 07:51:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BFF1FB80976
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 14:51:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EA19C4339B;
        Tue, 28 Mar 2023 14:51:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680015110;
        bh=CWlBYcUlEtV2WK9oxcnRHyaRYGfQvTSR1XBD+I+3xUE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BA6sWbHapOxXA8817LMVQxNkAgBfjlAqcvCBU+vsBx+vP5HOODYWBO9dicKCgYVEq
         Gb39tT2FntFJtQSL/OpCg+JDqaSW9Oz8I1V/2mcNWujH8Anu7qdpBXzzenljfvDB4o
         V08HObasBHL7KMYcXNbErg4JHXcj2ilktAlB0QDw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Kars de Jong <jongk@linux-m68k.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 138/240] m68k: mm: Fix systems with memory at end of 32-bit address space
Date:   Tue, 28 Mar 2023 16:41:41 +0200
Message-Id: <20230328142625.506327581@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142619.643313678@linuxfoundation.org>
References: <20230328142619.643313678@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
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



