Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 158AE337F69
	for <lists+stable@lfdr.de>; Thu, 11 Mar 2021 22:13:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230411AbhCKVLs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Mar 2021 16:11:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:34430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230526AbhCKVLI (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Mar 2021 16:11:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 15DA164EC6;
        Thu, 11 Mar 2021 21:10:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1615497051;
        bh=p/LAD5mxuJvydhNO6HIysiUu1It4goou/tga1HYaLxc=;
        h=Date:From:To:Subject:From;
        b=kpo4UwPOwwXPuV+qvmmmAVjTpbQpyyZf1zdj1206BSUknlEfg4IutPWvU7a0fP5gm
         IM8GUHBLNz0ABr7SLskiL+Z6tK8bQ5MCYScxaUfuEPdfCZxCglQ9bY+MNBYf09boTq
         hr5ickMiHLw4bYYlRTMpc9qwaRKKldAoClb7Cyq4=
Date:   Thu, 11 Mar 2021 13:10:50 -0800
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, aryabinin@virtuozzo.com,
        Branislav.Rankov@arm.com, catalin.marinas@arm.com,
        dvyukov@google.com, elver@google.com, eugenis@google.com,
        glider@google.com, kevin.brodsky@arm.com,
        mm-commits@vger.kernel.org, pcc@google.com, stable@vger.kernel.org,
        vincenzo.frascino@arm.com, will.deacon@arm.com
Subject:  + kasan-fix-per-page-tags-for-non-page_alloc-pages.patch
 added to -mm tree
Message-ID: <20210311211050.QKMbrcVtE%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: kasan: fix per-page tags for non-page_alloc pages
has been added to the -mm tree.  Its filename is
     kasan-fix-per-page-tags-for-non-page_alloc-pages.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kasan-fix-per-page-tags-for-non-page_alloc-pages.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kasan-fix-per-page-tags-for-non-page_alloc-pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: fix per-page tags for non-page_alloc pages

To allow performing tag checks on page_alloc addresses obtained via
page_address(), tag-based KASAN modes store tags for page_alloc
allocations in page->flags.

Currently, the default tag value stored in page->flags is 0x00. 
Therefore, page_address() returns a 0x00ffff...  address for pages that
were not allocated via page_alloc.

This might cause problems.  A particular case we encountered is a conflict
with KFENCE.  If a KFENCE-allocated slab object is being freed via
kfree(page_address(page) + offset), the address passed to kfree() will get
tagged with 0x00 (as slab pages keep the default per-page tags).  This
leads to is_kfence_address() check failing, and a KFENCE object ending up
in normal slab freelist, which causes memory corruptions.

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
---

 include/linux/mm.h |   18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

--- a/include/linux/mm.h~kasan-fix-per-page-tags-for-non-page_alloc-pages
+++ a/include/linux/mm.h
@@ -1440,16 +1440,28 @@ static inline bool cpupid_match_pid(stru
 
 #if defined(CONFIG_KASAN_SW_TAGS) || defined(CONFIG_KASAN_HW_TAGS)
 
+/*
+ * KASAN per-page tags are stored xor'ed with 0xff. This allows to avoid
+ * setting tags for all pages to native kernel tag value 0xff, as the default
+ * value 0x00 maps to 0xff.
+ */
+
 static inline u8 page_kasan_tag(const struct page *page)
 {
-	if (kasan_enabled())
-		return (page->flags >> KASAN_TAG_PGSHIFT) & KASAN_TAG_MASK;
-	return 0xff;
+	u8 tag = 0xff;
+
+	if (kasan_enabled()) {
+		tag = (page->flags >> KASAN_TAG_PGSHIFT) & KASAN_TAG_MASK;
+		tag ^= 0xff;
+	}
+
+	return tag;
 }
 
 static inline void page_kasan_tag_set(struct page *page, u8 tag)
 {
 	if (kasan_enabled()) {
+		tag ^= 0xff;
 		page->flags &= ~(KASAN_TAG_MASK << KASAN_TAG_PGSHIFT);
 		page->flags |= (tag & KASAN_TAG_MASK) << KASAN_TAG_PGSHIFT;
 	}
_

Patches currently in -mm which might be from andreyknvl@google.com are

kasan-mm-fix-crash-with-hw_tags-and-debug_pagealloc.patch
kasan-fix-kasan_stack-dependency-for-hw_tags.patch
kasan-fix-per-page-tags-for-non-page_alloc-pages.patch
kasan-initialize-shadow-to-tag_invalid-for-sw_tags.patch
mm-kasan-dont-poison-boot-memory-with-tag-based-modes.patch

