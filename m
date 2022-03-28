Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18EBE4E9374
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 13:22:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240875AbiC1LYZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Mar 2022 07:24:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240999AbiC1LXD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 07:23:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FB2A56219;
        Mon, 28 Mar 2022 04:19:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0BE3BB81058;
        Mon, 28 Mar 2022 11:19:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA3FCC34100;
        Mon, 28 Mar 2022 11:19:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648466395;
        bh=TzN9S2c1jJpI9v8G0EpdcxObJsrqJKiqIfBV48VR++4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QWb47MVqqOrbWmsOejZHe0cYnXjrcqD9BzoK6BGnNnNvNElEJ8XL7jru7VMNja99p
         360R92JMZvozOrWuqkWvcGsCiNglIDfgrM3pMBLg2cd74Ln7enLHPlRKcHVzyqt4tr
         BHLGM9/D8Cps/2iw8XENtCK1fB0+ctWoytISrjop3grfBRSnnx4lQYT2EnRJNt/Goj
         XOye7MoARZAQSpu4NKR62RtsoqKzi5aAFmeoJQwl6ul0hQeHP8VvBW/eW96aqokpbk
         cgqAkHssLJiUxcQKcapHJg9w2WH32ikqBuQipRx+KEoWpvXfXlp0yFhpoC16+Q+fuj
         Z5VKD32jMdjHg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     John David Anglin <dave.anglin@bell.net>,
        Helge Deller <deller@gmx.de>, Sasha Levin <sashal@kernel.org>,
        James.Bottomley@HansenPartnership.com, svens@stackframe.org,
        ira.weiny@intel.com, akpm@linux-foundation.org,
        linux-parisc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 38/43] parisc: Fix non-access data TLB cache flush faults
Date:   Mon, 28 Mar 2022 07:18:22 -0400
Message-Id: <20220328111828.1554086-38-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220328111828.1554086-1-sashal@kernel.org>
References: <20220328111828.1554086-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

