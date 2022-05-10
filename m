Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D345522005
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 17:49:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346601AbiEJPxJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 11:53:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346933AbiEJPvp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 11:51:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 626BD62BE5;
        Tue, 10 May 2022 08:46:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AD98161373;
        Tue, 10 May 2022 15:46:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DF5FC385C9;
        Tue, 10 May 2022 15:46:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652197573;
        bh=21bwpjNudExl89E+GWay/earnO1hhomI8Dv+7vwzFGE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nlPITQTXIBFL3WQdkOw5g8It6pvqP4pu03cmobfFQ7DDOM0F9+/V9fmtx2sqEL5mb
         9dXK3XcWurCon0AfNP1ClK7uPGnRQHv/yggW46N44EQ746UScW1kuxTtSF20t97NHE
         rJxA4Qu/9cgZjpuc30cJWNSFvDB+HoJ1g6pq3e2lxvv+3q1jKPW3yKTstZdHAsAXXu
         pVnMGG8EY5tS7l0oV92SP5FvV9SJNoZawU4NXuHnGxm8KTZlERRPRPpWJNNCWX3+CJ
         UMrYTRx0U4GaGvj1ZUxjRjsieaG9kmR5fODCB66fLyhiCOMkFw/4+S9xnWlJPD2r+Y
         PR+eNYsnVM4Bg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Helge Deller <deller@gmx.de>, Sasha Levin <sashal@kernel.org>,
        James.Bottomley@HansenPartnership.com, dave.anglin@bell.net,
        linux-parisc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 8/8] Revert "parisc: Fix patch code locking and flushing"
Date:   Tue, 10 May 2022 11:45:36 -0400
Message-Id: <20220510154536.154070-8-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220510154536.154070-1-sashal@kernel.org>
References: <20220510154536.154070-1-sashal@kernel.org>
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

