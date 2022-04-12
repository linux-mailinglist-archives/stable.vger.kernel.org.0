Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB9B24FD7FD
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:34:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356531AbiDLHiw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:38:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353474AbiDLHZn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:25:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 011A2434AA;
        Tue, 12 Apr 2022 00:00:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9A978B81B35;
        Tue, 12 Apr 2022 07:00:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C9F1C385A8;
        Tue, 12 Apr 2022 07:00:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649746838;
        bh=mR2O/g+rjFObtLuc8qXfsCZ+aho+SVwU90zDb6t0Px0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wbqoXxG45ZClwVuJjd/KGPUj5C+SllKpxLU2XAuuLR7LmeJMnDwoeEIpsfC9WJEy4
         nHo8M48jFoR13xKYwWWg+N+ddQWWfDiqDGFW4cbUHdrYD8BgqEM76yeW3dZBdAZiEI
         gjBHv0cS+XDXlvtzFP9l6TeRqQSVSr//gTnqzJPs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John David Anglin <dave.anglin@bell.net>,
        Helge Deller <deller@gmx.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 147/285] parisc: Fix patch code locking and flushing
Date:   Tue, 12 Apr 2022 08:30:04 +0200
Message-Id: <20220412062947.912980153@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062943.670770901@linuxfoundation.org>
References: <20220412062943.670770901@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: John David Anglin <dave.anglin@bell.net>

[ Upstream commit a9fe7fa7d874a536e0540469f314772c054a0323 ]

This change fixes the following:

1) The flags variable is not initialized. Always use raw_spin_lock_irqsave
and raw_spin_unlock_irqrestore to serialize patching.

2) flush_kernel_vmap_range is primarily intended for DMA flushes. Since
__patch_text_multiple is often called with interrupts disabled, it is
better to directly call flush_kernel_dcache_range_asm and
flush_kernel_icache_range_asm. This avoids an extra call.

3) The final call to flush_icache_range is unnecessary.

Signed-off-by: John David Anglin <dave.anglin@bell.net>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/parisc/kernel/patch.c | 25 +++++++++++--------------
 1 file changed, 11 insertions(+), 14 deletions(-)

diff --git a/arch/parisc/kernel/patch.c b/arch/parisc/kernel/patch.c
index 80a0ab372802..e59574f65e64 100644
--- a/arch/parisc/kernel/patch.c
+++ b/arch/parisc/kernel/patch.c
@@ -40,10 +40,7 @@ static void __kprobes *patch_map(void *addr, int fixmap, unsigned long *flags,
 
 	*need_unmap = 1;
 	set_fixmap(fixmap, page_to_phys(page));
-	if (flags)
-		raw_spin_lock_irqsave(&patch_lock, *flags);
-	else
-		__acquire(&patch_lock);
+	raw_spin_lock_irqsave(&patch_lock, *flags);
 
 	return (void *) (__fix_to_virt(fixmap) + (uintaddr & ~PAGE_MASK));
 }
@@ -52,10 +49,7 @@ static void __kprobes patch_unmap(int fixmap, unsigned long *flags)
 {
 	clear_fixmap(fixmap);
 
-	if (flags)
-		raw_spin_unlock_irqrestore(&patch_lock, *flags);
-	else
-		__release(&patch_lock);
+	raw_spin_unlock_irqrestore(&patch_lock, *flags);
 }
 
 void __kprobes __patch_text_multiple(void *addr, u32 *insn, unsigned int len)
@@ -67,8 +61,9 @@ void __kprobes __patch_text_multiple(void *addr, u32 *insn, unsigned int len)
 	int mapped;
 
 	/* Make sure we don't have any aliases in cache */
-	flush_kernel_vmap_range(addr, len);
-	flush_icache_range(start, end);
+	flush_kernel_dcache_range_asm(start, end);
+	flush_kernel_icache_range_asm(start, end);
+	flush_tlb_kernel_range(start, end);
 
 	p = fixmap = patch_map(addr, FIX_TEXT_POKE0, &flags, &mapped);
 
@@ -81,8 +76,10 @@ void __kprobes __patch_text_multiple(void *addr, u32 *insn, unsigned int len)
 			 * We're crossing a page boundary, so
 			 * need to remap
 			 */
-			flush_kernel_vmap_range((void *)fixmap,
-						(p-fixmap) * sizeof(*p));
+			flush_kernel_dcache_range_asm((unsigned long)fixmap,
+						      (unsigned long)p);
+			flush_tlb_kernel_range((unsigned long)fixmap,
+					       (unsigned long)p);
 			if (mapped)
 				patch_unmap(FIX_TEXT_POKE0, &flags);
 			p = fixmap = patch_map(addr, FIX_TEXT_POKE0, &flags,
@@ -90,10 +87,10 @@ void __kprobes __patch_text_multiple(void *addr, u32 *insn, unsigned int len)
 		}
 	}
 
-	flush_kernel_vmap_range((void *)fixmap, (p-fixmap) * sizeof(*p));
+	flush_kernel_dcache_range_asm((unsigned long)fixmap, (unsigned long)p);
+	flush_tlb_kernel_range((unsigned long)fixmap, (unsigned long)p);
 	if (mapped)
 		patch_unmap(FIX_TEXT_POKE0, &flags);
-	flush_icache_range(start, end);
 }
 
 void __kprobes __patch_text(void *addr, u32 insn)
-- 
2.35.1



