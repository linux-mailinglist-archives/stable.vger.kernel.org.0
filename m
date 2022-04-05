Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F2A24F3452
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 15:26:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238154AbiDEKHJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:07:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344275AbiDEJTD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:19:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FC02DC9;
        Tue,  5 Apr 2022 02:06:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B9AE8B81BBF;
        Tue,  5 Apr 2022 09:06:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12AD5C385A0;
        Tue,  5 Apr 2022 09:06:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649149616;
        bh=TzN9S2c1jJpI9v8G0EpdcxObJsrqJKiqIfBV48VR++4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N+d4YF2nTX/oV7e0RKqfS67JUVC1eGPgcYBTu4mAN4aHu3/0SrYQeB6avua4bufT9
         1bBfSWipP87m740iP3/zpVLKnehPP7Tln9PI++n9EoXE+so1K5EbQCraDQQtu82P6G
         zc2BmMCO7huiYvwXWMmckN1JMN/UoxoN6tB9WLqA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John David Anglin <dave.anglin@bell.net>,
        Helge Deller <deller@gmx.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0779/1017] parisc: Fix non-access data TLB cache flush faults
Date:   Tue,  5 Apr 2022 09:28:12 +0200
Message-Id: <20220405070417.381378238@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
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

[ Upstream commit f839e5f1cef36ce268950c387129b1bfefdaebc9 ]

When a page is not present, we get non-access data TLB faults from
the fdc and fic instructions in flush_user_dcache_range_asm and
flush_user_icache_range_asm. When these occur, the cache line is
not invalidated and potentially we get memory corruption. The
problem was hidden by the nullification of the flush instructions.

These faults also affect performance. With pa8800/pa8900 processors,
there will be 32 faults per 4 KB page since the cache line is 128
bytes.  There will be more faults with earlier processors.

The problem is fixed by using flush_cache_pages(). It does the flush
using a tmp alias mapping.

The flush_cache_pages() call in flush_cache_range() flushed too
large a range.

V2: Remove unnecessary preempt_disable() and preempt_enable() calls.

Signed-off-by: John David Anglin <dave.anglin@bell.net>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/parisc/kernel/cache.c | 28 +---------------------------
 1 file changed, 1 insertion(+), 27 deletions(-)

diff --git a/arch/parisc/kernel/cache.c b/arch/parisc/kernel/cache.c
index 94150b91c96f..bce71cefe572 100644
--- a/arch/parisc/kernel/cache.c
+++ b/arch/parisc/kernel/cache.c
@@ -558,15 +558,6 @@ static void flush_cache_pages(struct vm_area_struct *vma, struct mm_struct *mm,
 	}
 }
 
-static void flush_user_cache_tlb(struct vm_area_struct *vma,
-				 unsigned long start, unsigned long end)
-{
-	flush_user_dcache_range_asm(start, end);
-	if (vma->vm_flags & VM_EXEC)
-		flush_user_icache_range_asm(start, end);
-	flush_tlb_range(vma, start, end);
-}
-
 void flush_cache_mm(struct mm_struct *mm)
 {
 	struct vm_area_struct *vma;
@@ -581,17 +572,8 @@ void flush_cache_mm(struct mm_struct *mm)
 		return;
 	}
 
-	preempt_disable();
-	if (mm->context == mfsp(3)) {
-		for (vma = mm->mmap; vma; vma = vma->vm_next)
-			flush_user_cache_tlb(vma, vma->vm_start, vma->vm_end);
-		preempt_enable();
-		return;
-	}
-
 	for (vma = mm->mmap; vma; vma = vma->vm_next)
 		flush_cache_pages(vma, mm, vma->vm_start, vma->vm_end);
-	preempt_enable();
 }
 
 void flush_cache_range(struct vm_area_struct *vma,
@@ -605,15 +587,7 @@ void flush_cache_range(struct vm_area_struct *vma,
 		return;
 	}
 
-	preempt_disable();
-	if (vma->vm_mm->context == mfsp(3)) {
-		flush_user_cache_tlb(vma, start, end);
-		preempt_enable();
-		return;
-	}
-
-	flush_cache_pages(vma, vma->vm_mm, vma->vm_start, vma->vm_end);
-	preempt_enable();
+	flush_cache_pages(vma, vma->vm_mm, start, end);
 }
 
 void
-- 
2.34.1



