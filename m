Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CD1B521FCD
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 17:48:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346562AbiEJPwe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 11:52:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346496AbiEJPvA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 11:51:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 015B228B696;
        Tue, 10 May 2022 08:45:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5BE27614E8;
        Tue, 10 May 2022 15:45:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4D06C385CB;
        Tue, 10 May 2022 15:45:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652197511;
        bh=21bwpjNudExl89E+GWay/earnO1hhomI8Dv+7vwzFGE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aGQHn3PhinxxrPmgBQONV3sx1z3It5AS/LMDw1STNIOxOdPZsfkjPwl1PLYfD6FQ5
         YxxuQuYrGf4hB/2kt5d86kcYdUvFynlzR+T919Iw91s1lapqvBxYHstDALK4jugub9
         E6Y0XDtTMWrcs5HeA3Ny2AWveiC8jUqp+nxK7Q26BMpgL78z/cK/6IlffyXiU8E+yF
         Vc1c8YaFrNrsty9Kmy/oD5WI4b7g0wt8GVTsWpL6KHrrLbyq3hPBoLkqkoTRBkagYW
         VBU2fUUVmmKqNZ6jZj4lpmVOfUrM8Yy8YwYyPWytr63lkYPx+CGN1ZyGay5/UTPhDT
         WTM5XcLyyGZrA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Helge Deller <deller@gmx.de>, Sasha Levin <sashal@kernel.org>,
        James.Bottomley@HansenPartnership.com, dave.anglin@bell.net,
        linux-parisc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 19/19] Revert "parisc: Fix patch code locking and flushing"
Date:   Tue, 10 May 2022 11:44:29 -0400
Message-Id: <20220510154429.153677-19-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220510154429.153677-1-sashal@kernel.org>
References: <20220510154429.153677-1-sashal@kernel.org>
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

