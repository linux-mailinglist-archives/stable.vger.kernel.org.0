Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B57634C82C
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:21:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232160AbhC2IUN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:20:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:36552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233302AbhC2ITo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:19:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 833A161554;
        Mon, 29 Mar 2021 08:19:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617005973;
        bh=blM/HcstuGTb7V1jjnIT6GkDK30Tg7+4tk/syW629ZM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ji8IWZX6fx7noOqevGQYXm4Nn2vdLoSCYDsouQJl7vQKfWKWC2c0Yr/xTjqn1HAU+
         KvrPFMBug/RJXhAlCrsc93kiVFKUpnacoqXr848xYQ5UuYZ08pS5FDh6pl2pdpVyhn
         v/woDJGFyahPfjnVxGa1KnPbEin83OfvtJLSvBVE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrey Konovalov <andreyknvl@google.com>,
        Marco Elver <elver@google.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Alexander Potapenko <glider@google.com>,
        Peter Collingbourne <pcc@google.com>,
        Evgenii Stepanov <eugenis@google.com>,
        Branislav Rankov <Branislav.Rankov@arm.com>,
        Kevin Brodsky <kevin.brodsky@arm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.10 072/221] kasan: fix per-page tags for non-page_alloc pages
Date:   Mon, 29 Mar 2021 09:56:43 +0200
Message-Id: <20210329075631.591382590@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075629.172032742@linuxfoundation.org>
References: <20210329075629.172032742@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrey Konovalov <andreyknvl@google.com>

commit cf10bd4c4aff8dd64d1aa7f2a529d0c672bc16af upstream.

To allow performing tag checks on page_alloc addresses obtained via
page_address(), tag-based KASAN modes store tags for page_alloc
allocations in page->flags.

Currently, the default tag value stored in page->flags is 0x00.
Therefore, page_address() returns a 0x00ffff...  address for pages that
were not allocated via page_alloc.

This might cause problems.  A particular case we encountered is a
conflict with KFENCE.  If a KFENCE-allocated slab object is being freed
via kfree(page_address(page) + offset), the address passed to kfree()
will get tagged with 0x00 (as slab pages keep the default per-page
tags).  This leads to is_kfence_address() check failing, and a KFENCE
object ending up in normal slab freelist, which causes memory
corruptions.

This patch changes the way KASAN stores tag in page-flags: they are now
stored xor'ed with 0xff.  This way, KASAN doesn't need to initialize
per-page flags for every created page, which might be slow.

With this change, page_address() returns natively-tagged (with 0xff)
pointers for pages that didn't have tags set explicitly.

This patch fixes the encountered conflict with KFENCE and prevents more
similar issues that can occur in the future.

Link: https://lkml.kernel.org/r/1a41abb11c51b264511d9e71c303bb16d5cb367b.1615475452.git.andreyknvl@google.com
Fixes: 2813b9c02962 ("kasan, mm, arm64: tag non slab memory allocated via pagealloc")
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Peter Collingbourne <pcc@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Branislav Rankov <Branislav.Rankov@arm.com>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/mm.h |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1414,13 +1414,26 @@ static inline bool cpupid_match_pid(stru
 #endif /* CONFIG_NUMA_BALANCING */
 
 #ifdef CONFIG_KASAN_SW_TAGS
+
+/*
+ * KASAN per-page tags are stored xor'ed with 0xff. This allows to avoid
+ * setting tags for all pages to native kernel tag value 0xff, as the default
+ * value 0x00 maps to 0xff.
+ */
+
 static inline u8 page_kasan_tag(const struct page *page)
 {
-	return (page->flags >> KASAN_TAG_PGSHIFT) & KASAN_TAG_MASK;
+	u8 tag;
+
+	tag = (page->flags >> KASAN_TAG_PGSHIFT) & KASAN_TAG_MASK;
+	tag ^= 0xff;
+
+	return tag;
 }
 
 static inline void page_kasan_tag_set(struct page *page, u8 tag)
 {
+	tag ^= 0xff;
 	page->flags &= ~(KASAN_TAG_MASK << KASAN_TAG_PGSHIFT);
 	page->flags |= (tag & KASAN_TAG_MASK) << KASAN_TAG_PGSHIFT;
 }


