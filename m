Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33E3F521FED
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 17:49:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346637AbiEJPwu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 11:52:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346695AbiEJPvS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 11:51:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 764C928ED3F;
        Tue, 10 May 2022 08:45:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 23CA7B81DB5;
        Tue, 10 May 2022 15:45:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DB89C385A6;
        Tue, 10 May 2022 15:45:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652197535;
        bh=21bwpjNudExl89E+GWay/earnO1hhomI8Dv+7vwzFGE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aOPNYzQvvzBufEVhvzQHVOPv0YDwb/gsnMX+kv0XJG52Tl4zERvm2cpmpoZBwg/81
         Ytlt8vqPz/BDAIupNQISdVi7o1KQ8lu5WfgAf0rqkXr9S4y/dw/RUfP/Qi9iKzsqBC
         zz/0rKmkW0kJ0AC6el2HlkPCCW3qjgeRpPDz3u7iMM5YMepCctJ0ioToAqLW/Qyf1y
         D1pOb9S5lWlbnZZTw5Wrw8U9ndEv6WTFz1Gu5q2SzJvXRg6o7HX7E+GfLzn94CS8rw
         VF61e2UgEAw0P38Xlbu6mtl7YnMkTPojqhr3060LRvaMalhAE3d7pGBSzhldkTYkRm
         9LXBgIPXdlJYg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Helge Deller <deller@gmx.de>, Sasha Levin <sashal@kernel.org>,
        James.Bottomley@HansenPartnership.com, dave.anglin@bell.net,
        linux-parisc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 9/9] Revert "parisc: Fix patch code locking and flushing"
Date:   Tue, 10 May 2022 11:45:12 -0400
Message-Id: <20220510154512.153945-9-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220510154512.153945-1-sashal@kernel.org>
References: <20220510154512.153945-1-sashal@kernel.org>
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

From: Helge Deller <deller@gmx.de>

[ Upstream commit 6c800d7f55fcd78e17deae5ae4374d8e73482c13 ]

This reverts commit a9fe7fa7d874a536e0540469f314772c054a0323.

Leads to segfaults on 32bit kernel.

Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/parisc/kernel/patch.c | 25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff --git a/arch/parisc/kernel/patch.c b/arch/parisc/kernel/patch.c
index e59574f65e64..80a0ab372802 100644
--- a/arch/parisc/kernel/patch.c
+++ b/arch/parisc/kernel/patch.c
@@ -40,7 +40,10 @@ static void __kprobes *patch_map(void *addr, int fixmap, unsigned long *flags,
 
 	*need_unmap = 1;
 	set_fixmap(fixmap, page_to_phys(page));
-	raw_spin_lock_irqsave(&patch_lock, *flags);
+	if (flags)
+		raw_spin_lock_irqsave(&patch_lock, *flags);
+	else
+		__acquire(&patch_lock);
 
 	return (void *) (__fix_to_virt(fixmap) + (uintaddr & ~PAGE_MASK));
 }
@@ -49,7 +52,10 @@ static void __kprobes patch_unmap(int fixmap, unsigned long *flags)
 {
 	clear_fixmap(fixmap);
 
-	raw_spin_unlock_irqrestore(&patch_lock, *flags);
+	if (flags)
+		raw_spin_unlock_irqrestore(&patch_lock, *flags);
+	else
+		__release(&patch_lock);
 }
 
 void __kprobes __patch_text_multiple(void *addr, u32 *insn, unsigned int len)
@@ -61,9 +67,8 @@ void __kprobes __patch_text_multiple(void *addr, u32 *insn, unsigned int len)
 	int mapped;
 
 	/* Make sure we don't have any aliases in cache */
-	flush_kernel_dcache_range_asm(start, end);
-	flush_kernel_icache_range_asm(start, end);
-	flush_tlb_kernel_range(start, end);
+	flush_kernel_vmap_range(addr, len);
+	flush_icache_range(start, end);
 
 	p = fixmap = patch_map(addr, FIX_TEXT_POKE0, &flags, &mapped);
 
@@ -76,10 +81,8 @@ void __kprobes __patch_text_multiple(void *addr, u32 *insn, unsigned int len)
 			 * We're crossing a page boundary, so
 			 * need to remap
 			 */
-			flush_kernel_dcache_range_asm((unsigned long)fixmap,
-						      (unsigned long)p);
-			flush_tlb_kernel_range((unsigned long)fixmap,
-					       (unsigned long)p);
+			flush_kernel_vmap_range((void *)fixmap,
+						(p-fixmap) * sizeof(*p));
 			if (mapped)
 				patch_unmap(FIX_TEXT_POKE0, &flags);
 			p = fixmap = patch_map(addr, FIX_TEXT_POKE0, &flags,
@@ -87,10 +90,10 @@ void __kprobes __patch_text_multiple(void *addr, u32 *insn, unsigned int len)
 		}
 	}
 
-	flush_kernel_dcache_range_asm((unsigned long)fixmap, (unsigned long)p);
-	flush_tlb_kernel_range((unsigned long)fixmap, (unsigned long)p);
+	flush_kernel_vmap_range((void *)fixmap, (p-fixmap) * sizeof(*p));
 	if (mapped)
 		patch_unmap(FIX_TEXT_POKE0, &flags);
+	flush_icache_range(start, end);
 }
 
 void __kprobes __patch_text(void *addr, u32 insn)
-- 
2.35.1

