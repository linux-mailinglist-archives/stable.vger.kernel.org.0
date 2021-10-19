Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CC07433E9D
	for <lists+stable@lfdr.de>; Tue, 19 Oct 2021 20:39:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234876AbhJSSlk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Oct 2021 14:41:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:52594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234909AbhJSSlj (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Oct 2021 14:41:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C86E7611AE;
        Tue, 19 Oct 2021 18:39:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1634668766;
        bh=VmWR9noKoRmdF8lzwFBoiumi3GWOPpTfU0CQ65iULbM=;
        h=Date:From:To:Subject:From;
        b=h+/9iZMI1W52F9fP4u9DJHsnBzzVk974sZzKZXjZDXmB+4Pk/02D7FMkfffWSxDnx
         wwnUYXBDGG/HJqAb4HdzdR+NAmyeD0CckVVG5e5ETPVWNdJhAFu9RxjDyhgU9AYY0p
         v1gf5QsxSV6BlcTLn3fySGSPaXyfXiZGarh5Jp6Y=
Date:   Tue, 19 Oct 2021 11:39:25 -0700
From:   akpm@linux-foundation.org
To:     andreyknvl@gmail.com, bharata@linux.ibm.com, cl@linux.com,
        faiyazm@codeaurora.org, gregkh@linuxfoundation.org, guro@fb.com,
        iamjoonsoo.kim@lge.com, keescook@chromium.org,
        linmiaohe@huawei.com, mm-commits@vger.kernel.org,
        penberg@kernel.org, rientjes@google.com, ryabinin.a.a@gmail.com,
        stable@vger.kernel.org, vbabka@suse.cz
Subject:  [merged]
 mm-slub-fix-mismatch-between-reconstructed-freelist-depth-and-cnt.patch
 removed from -mm tree
Message-ID: <20211019183925.C-IiClkhl%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm, slub: fix mismatch between reconstructed freelist depth and cnt
has been removed from the -mm tree.  Its filename was
     mm-slub-fix-mismatch-between-reconstructed-freelist-depth-and-cnt.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm, slub: fix mismatch between reconstructed freelist depth and cnt

If object's reuse is delayed, it will be excluded from the reconstructed
freelist.  But we forgot to adjust the cnt accordingly.  So there will be
a mismatch between reconstructed freelist depth and cnt.  This will lead
to free_debug_processing() complaining about freelist count or a incorrect
slub inuse count.

Link: https://lkml.kernel.org/r/20210916123920.48704-3-linmiaohe@huawei.com
Fixes: c3895391df38 ("kasan, slub: fix handling of kasan_slab_free hook")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Bharata B Rao <bharata@linux.ibm.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Faiyaz Mohammed <faiyazm@codeaurora.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Roman Gushchin <guro@fb.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/mm/slub.c~mm-slub-fix-mismatch-between-reconstructed-freelist-depth-and-cnt
+++ a/mm/slub.c
@@ -1701,7 +1701,8 @@ static __always_inline bool slab_free_ho
 }
 
 static inline bool slab_free_freelist_hook(struct kmem_cache *s,
-					   void **head, void **tail)
+					   void **head, void **tail,
+					   int *cnt)
 {
 
 	void *object;
@@ -1728,6 +1729,12 @@ static inline bool slab_free_freelist_ho
 			*head = object;
 			if (!*tail)
 				*tail = object;
+		} else {
+			/*
+			 * Adjust the reconstructed freelist depth
+			 * accordingly if object's reuse is delayed.
+			 */
+			--(*cnt);
 		}
 	} while (object != old_tail);
 
@@ -3480,7 +3487,7 @@ static __always_inline void slab_free(st
 	 * With KASAN enabled slab_free_freelist_hook modifies the freelist
 	 * to remove objects, whose reuse must be delayed.
 	 */
-	if (slab_free_freelist_hook(s, &head, &tail))
+	if (slab_free_freelist_hook(s, &head, &tail, &cnt))
 		do_slab_free(s, page, head, tail, cnt, addr);
 }
 
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-page_allocc-remove-meaningless-vm_bug_on-in-pindex_to_order.patch
mm-page_allocc-simplify-the-code-by-using-macro-k.patch
mm-page_allocc-fix-obsolete-comment-in-free_pcppages_bulk.patch
mm-page_allocc-use-helper-function-zone_spans_pfn.patch
mm-page_allocc-avoid-allocating-highmem-pages-via-alloc_pages_exact.patch
mm-page_isolation-fix-potential-missing-call-to-unset_migratetype_isolate.patch
mm-page_isolation-guard-against-possible-putback-unisolated-page.patch
mm-memory_hotplug-make-hwpoisoned-dirty-swapcache-pages-unmovable.patch
mm-zsmallocc-close-race-window-between-zs_pool_dec_isolated-and-zs_unregister_migration.patch
mm-zsmallocc-combine-two-atomic-ops-in-zs_pool_dec_isolated.patch

