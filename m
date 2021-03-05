Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2D2C32F6CA
	for <lists+stable@lfdr.de>; Sat,  6 Mar 2021 00:49:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230183AbhCEXsY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 18:48:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:57066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229854AbhCEXsW (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 18:48:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 021D6650A3;
        Fri,  5 Mar 2021 23:48:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614988102;
        bh=P/8qxXp7Abe49LBUzhGvlTmuKVIyiM7eSPOA8YxiGm8=;
        h=Date:From:To:Subject:From;
        b=i4UvloCLoNLv4AwqNTclUgOruQqsfBb5vQzWuLFjNfZU60wqjQDn9XRdbc2AYiOpO
         +LaueucDPP1jMGePDdWOelskNBXiufVaciY/eZjvFMnNWfvM24z7YdC9PYO2CS+ftX
         5yEeWgATxn5KTlL3rOvWodqxbrgYVQalaPnmE/LA=
Date:   Fri, 05 Mar 2021 15:48:21 -0800
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, aryabinin@virtuozzo.com,
        Branislav.Rankov@arm.com, catalin.marinas@arm.com,
        dvyukov@google.com, elver@google.com, eugenis@google.com,
        glider@google.com, hch@infradead.org, kevin.brodsky@arm.com,
        mm-commits@vger.kernel.org, pcc@google.com, stable@vger.kernel.org,
        vincenzo.frascino@arm.com, will.deacon@arm.com
Subject:  +
 kasan-mm-fix-crash-with-hw_tags-and-debug_pagealloc.patch added to -mm tree
Message-ID: <20210305234821.7QZ-DAuia%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: kasan, mm: fix crash with HW_TAGS and DEBUG_PAGEALLOC
has been added to the -mm tree.  Its filename is
     kasan-mm-fix-crash-with-hw_tags-and-debug_pagealloc.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kasan-mm-fix-crash-with-hw_tags-and-debug_pagealloc.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kasan-mm-fix-crash-with-hw_tags-and-debug_pagealloc.patch

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

kasan-mm-fix-crash-with-hw_tags-and-debug_pagealloc.patch

