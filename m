Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E0CC339BE8
	for <lists+stable@lfdr.de>; Sat, 13 Mar 2021 06:08:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232230AbhCMFIM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Mar 2021 00:08:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:42176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232023AbhCMFIL (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 13 Mar 2021 00:08:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AC18164F94;
        Sat, 13 Mar 2021 05:08:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1615612091;
        bh=CESRd6SNLsaOY2RX7+AT+TjD+Ud3fDWanSkhqCBWjIg=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=PdldyS3trAOVSGdcJ/vSyxcigYafByIrYREXBqfKO9CWcPb+CWEFmLQoA0Vms8ojK
         +1+9icXjWTlVmTNeEKRNomOzuASDLDT4zcuwPfsPtxGTSuELZuQpd/14smfNmhfk7c
         lpPqRD1nihnu2VRxSBSZLgeezRW9ut8+G0XcXJIY=
Date:   Fri, 12 Mar 2021 21:08:10 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andreyknvl@google.com,
        aryabinin@virtuozzo.com, Branislav.Rankov@arm.com,
        catalin.marinas@arm.com, dvyukov@google.com, elver@google.com,
        eugenis@google.com, glider@google.com, hch@infradead.org,
        kevin.brodsky@arm.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, pcc@google.com, stable@vger.kernel.org,
        torvalds@linux-foundation.org, vincenzo.frascino@arm.com,
        will.deacon@arm.com
Subject:  [patch 20/29] kasan, mm: fix crash with HW_TAGS and
 DEBUG_PAGEALLOC
Message-ID: <20210313050810.cdPfxpuDx%akpm@linux-foundation.org>
In-Reply-To: <20210312210632.9b7d62973d72a56fb13c7a03@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
