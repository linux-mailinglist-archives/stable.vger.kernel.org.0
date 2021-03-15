Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BDD733C4DE
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 18:56:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230467AbhCOR4F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 13:56:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:44182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236552AbhCORsm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 13:48:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BBC1764F3A;
        Mon, 15 Mar 2021 17:48:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1615830515;
        bh=hSgBwnWXm8tUzyv7EdEws2TpMZWaFvYVeijdNqc+4FY=;
        h=Date:From:To:Subject:From;
        b=y2NbyDCaMQJErYg7CFjFoBNkIyS3EUrFcx1JpLgmzpwF9kv1WXLbTzxJvdnug2EIs
         X0zJY2aOIjmwtImGtJoFpTUqoVVwFNrX8ksJKbG2LIbVPUdesRT8hBPG7pH470hmAd
         8iS5+OteT1wwGCSc+/SrXBkaoNakTzGU2IiPwSOI=
Date:   Mon, 15 Mar 2021 10:48:34 -0700
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, aryabinin@virtuozzo.com,
        Branislav.Rankov@arm.com, catalin.marinas@arm.com,
        dvyukov@google.com, elver@google.com, eugenis@google.com,
        glider@google.com, hch@infradead.org, kevin.brodsky@arm.com,
        mm-commits@vger.kernel.org, pcc@google.com, stable@vger.kernel.org,
        vincenzo.frascino@arm.com, will.deacon@arm.com
Subject:  [merged]
 kasan-mm-fix-crash-with-hw_tags-and-debug_pagealloc.patch removed from -mm
 tree
Message-ID: <20210315174834.c9ExIqJ3U%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: kasan, mm: fix crash with HW_TAGS and DEBUG_PAGEALLOC
has been removed from the -mm tree.  Its filename was
     kasan-mm-fix-crash-with-hw_tags-and-debug_pagealloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan, mm: fix crash with HW_TAGS and DEBUG_PAGEALLOC

Currently, kasan_free_nondeferred_pages()->kasan_free_pages() is called
after debug_pagealloc_unmap_pages(). This causes a crash when
debug_pagealloc is enabled, as HW_TAGS KASAN can't set tags on an
unmapped page.

This patch puts kasan_free_nondeferred_pages() before
debug_pagealloc_unmap_pages() and arch_free_page(), which can also make
the page unavailable.

Link: https://lkml.kernel.org/r/24cd7db274090f0e5bc3adcdc7399243668e3171.1614987311.git.andreyknvl@google.com
Fixes: 94ab5b61ee16 ("kasan, arm64: enable CONFIG_KASAN_HW_TAGS")
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Peter Collingbourne <pcc@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Branislav Rankov <Branislav.Rankov@arm.com>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/mm/page_alloc.c~kasan-mm-fix-crash-with-hw_tags-and-debug_pagealloc
+++ a/mm/page_alloc.c
@@ -1282,6 +1282,12 @@ static __always_inline bool free_pages_p
 	kernel_poison_pages(page, 1 << order);
 
 	/*
+	 * With hardware tag-based KASAN, memory tags must be set before the
+	 * page becomes unavailable via debug_pagealloc or arch_free_page.
+	 */
+	kasan_free_nondeferred_pages(page, order);
+
+	/*
 	 * arch_free_page() can make the page's contents inaccessible.  s390
 	 * does this.  So nothing which can access the page's contents should
 	 * happen after this.
@@ -1290,8 +1296,6 @@ static __always_inline bool free_pages_p
 
 	debug_pagealloc_unmap_pages(page, 1 << order);
 
-	kasan_free_nondeferred_pages(page, order);
-
 	return true;
 }
 
_

Patches currently in -mm which might be from andreyknvl@google.com are

kasan-fix-per-page-tags-for-non-page_alloc-pages.patch
kasan-initialize-shadow-to-tag_invalid-for-sw_tags.patch
mm-kasan-dont-poison-boot-memory-with-tag-based-modes.patch
arm64-kasan-allow-to-init-memory-when-setting-tags.patch
kasan-init-memory-in-kasan_unpoison-for-hw_tags.patch
kasan-mm-integrate-page_alloc-init-with-hw_tags.patch
kasan-mm-integrate-slab-init_on_alloc-with-hw_tags.patch
kasan-mm-integrate-slab-init_on_free-with-hw_tags.patch
kasan-docs-clean-up-sections.patch
kasan-docs-update-overview-section.patch
kasan-docs-update-usage-section.patch
kasan-docs-update-error-reports-section.patch
kasan-docs-update-boot-parameters-section.patch
kasan-docs-update-generic-implementation-details-section.patch
kasan-docs-update-sw_tags-implementation-details-section.patch
kasan-docs-update-hw_tags-implementation-details-section.patch
kasan-docs-update-shadow-memory-section.patch
kasan-docs-update-ignoring-accesses-section.patch
kasan-docs-update-tests-section.patch

