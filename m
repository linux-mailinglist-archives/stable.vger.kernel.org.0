Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37410594525
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 01:00:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232306AbiHOV46 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:56:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346968AbiHOVyy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:54:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55653108FB5;
        Mon, 15 Aug 2022 12:33:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 318E16114B;
        Mon, 15 Aug 2022 19:33:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3715BC433C1;
        Mon, 15 Aug 2022 19:33:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660592014;
        bh=jahaXvlamd6CWdDN+U8JYYu8gmqVURZdg6CocvUtzAw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b//HfzCSyUmR1wZQA/j001g6X+/pwIk3oCTcgUSibpkTcNk7ymNhr1JB32EvC32sp
         mpJBmbegNxbjhYhU0e9SEsIohPp6wrQwcGYmaxqzyUxgbBwaRTS1RD1+9i/4Azl9Bd
         lSH2bO6r+JqdnPZm33J7cGN7W+DEnwAMB9UkIEcM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrey Konovalov <andreyknvl@google.com>,
        Marco Elver <elver@google.com>,
        Alexander Potapenko <glider@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Andrey Ryabinin <ryabinin.a.a@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0718/1095] kasan: fix zeroing vmalloc memory with HW_TAGS
Date:   Mon, 15 Aug 2022 20:01:57 +0200
Message-Id: <20220815180459.099775057@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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

From: Andrey Konovalov <andreyknvl@google.com>

[ Upstream commit 6c2f761dad7851d8088b91063ccaea3c970efe78 ]

HW_TAGS KASAN skips zeroing page_alloc allocations backing vmalloc
mappings via __GFP_SKIP_ZERO.  Instead, these pages are zeroed via
kasan_unpoison_vmalloc() by passing the KASAN_VMALLOC_INIT flag.

The problem is that __kasan_unpoison_vmalloc() does not zero pages when
either kasan_vmalloc_enabled() or is_vmalloc_or_module_addr() fail.

Thus:

1. Change __vmalloc_node_range() to only set KASAN_VMALLOC_INIT when
   __GFP_SKIP_ZERO is set.

2. Change __kasan_unpoison_vmalloc() to always zero pages when the
   KASAN_VMALLOC_INIT flag is set.

3. Add WARN_ON() asserts to check that KASAN_VMALLOC_INIT cannot be set
   in other early return paths of __kasan_unpoison_vmalloc().

Also clean up the comment in __kasan_unpoison_vmalloc.

Link: https://lkml.kernel.org/r/4bc503537efdc539ffc3f461c1b70162eea31cf6.1654798516.git.andreyknvl@google.com
Fixes: 23689e91fb22 ("kasan, vmalloc: add vmalloc tagging for HW_TAGS")
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/kasan/hw_tags.c | 32 +++++++++++++++++++++++---------
 mm/vmalloc.c       | 10 +++++-----
 2 files changed, 28 insertions(+), 14 deletions(-)

diff --git a/mm/kasan/hw_tags.c b/mm/kasan/hw_tags.c
index 9e1b6544bfa8..9ad8eff71b28 100644
--- a/mm/kasan/hw_tags.c
+++ b/mm/kasan/hw_tags.c
@@ -257,27 +257,37 @@ static void unpoison_vmalloc_pages(const void *addr, u8 tag)
 	}
 }
 
+static void init_vmalloc_pages(const void *start, unsigned long size)
+{
+	const void *addr;
+
+	for (addr = start; addr < start + size; addr += PAGE_SIZE) {
+		struct page *page = virt_to_page(addr);
+
+		clear_highpage_kasan_tagged(page);
+	}
+}
+
 void *__kasan_unpoison_vmalloc(const void *start, unsigned long size,
 				kasan_vmalloc_flags_t flags)
 {
 	u8 tag;
 	unsigned long redzone_start, redzone_size;
 
-	if (!kasan_vmalloc_enabled())
-		return (void *)start;
-
-	if (!is_vmalloc_or_module_addr(start))
+	if (!kasan_vmalloc_enabled() || !is_vmalloc_or_module_addr(start)) {
+		if (flags & KASAN_VMALLOC_INIT)
+			init_vmalloc_pages(start, size);
 		return (void *)start;
+	}
 
 	/*
-	 * Skip unpoisoning and assigning a pointer tag for non-VM_ALLOC
-	 * mappings as:
+	 * Don't tag non-VM_ALLOC mappings, as:
 	 *
 	 * 1. Unlike the software KASAN modes, hardware tag-based KASAN only
 	 *    supports tagging physical memory. Therefore, it can only tag a
 	 *    single mapping of normal physical pages.
 	 * 2. Hardware tag-based KASAN can only tag memory mapped with special
-	 *    mapping protection bits, see arch_vmalloc_pgprot_modify().
+	 *    mapping protection bits, see arch_vmap_pgprot_tagged().
 	 *    As non-VM_ALLOC mappings can be mapped outside of vmalloc code,
 	 *    providing these bits would require tracking all non-VM_ALLOC
 	 *    mappers.
@@ -289,15 +299,19 @@ void *__kasan_unpoison_vmalloc(const void *start, unsigned long size,
 	 *
 	 * For non-VM_ALLOC allocations, page_alloc memory is tagged as usual.
 	 */
-	if (!(flags & KASAN_VMALLOC_VM_ALLOC))
+	if (!(flags & KASAN_VMALLOC_VM_ALLOC)) {
+		WARN_ON(flags & KASAN_VMALLOC_INIT);
 		return (void *)start;
+	}
 
 	/*
 	 * Don't tag executable memory.
 	 * The kernel doesn't tolerate having the PC register tagged.
 	 */
-	if (!(flags & KASAN_VMALLOC_PROT_NORMAL))
+	if (!(flags & KASAN_VMALLOC_PROT_NORMAL)) {
+		WARN_ON(flags & KASAN_VMALLOC_INIT);
 		return (void *)start;
+	}
 
 	tag = kasan_random_tag();
 	start = set_tag(start, tag);
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index cadfbb5155ea..06c555fc5be0 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -3170,15 +3170,15 @@ void *__vmalloc_node_range(unsigned long size, unsigned long align,
 
 	/*
 	 * Mark the pages as accessible, now that they are mapped.
-	 * The init condition should match the one in post_alloc_hook()
-	 * (except for the should_skip_init() check) to make sure that memory
-	 * is initialized under the same conditions regardless of the enabled
-	 * KASAN mode.
+	 * The condition for setting KASAN_VMALLOC_INIT should complement the
+	 * one in post_alloc_hook() with regards to the __GFP_SKIP_ZERO check
+	 * to make sure that memory is initialized under the same conditions.
 	 * Tag-based KASAN modes only assign tags to normal non-executable
 	 * allocations, see __kasan_unpoison_vmalloc().
 	 */
 	kasan_flags |= KASAN_VMALLOC_VM_ALLOC;
-	if (!want_init_on_free() && want_init_on_alloc(gfp_mask))
+	if (!want_init_on_free() && want_init_on_alloc(gfp_mask) &&
+	    (gfp_mask & __GFP_SKIP_ZERO))
 		kasan_flags |= KASAN_VMALLOC_INIT;
 	/* KASAN_VMALLOC_PROT_NORMAL already set if required. */
 	area->addr = kasan_unpoison_vmalloc(area->addr, real_size, kasan_flags);
-- 
2.35.1



