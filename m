Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7390433EA0
	for <lists+stable@lfdr.de>; Tue, 19 Oct 2021 20:39:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234931AbhJSSls (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Oct 2021 14:41:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:52762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234909AbhJSSls (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Oct 2021 14:41:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C6BB161212;
        Tue, 19 Oct 2021 18:39:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1634668775;
        bh=LQLWPuZqK0qnIZkEZMVikyXiZK7C71YY9oBOO2JhIvo=;
        h=Date:From:To:Subject:From;
        b=zjRqEu9elj6QTMylsL3sWOimH0GnOIAM9gegvesqxWveV47Vm+whnDfuWICpR/Qwp
         0Uy8lEKMKvHD6LVEgGqj1uLeVPtyJJzkslYSZZsHyj32kIA5+Qd/dB7nyrnDP1zIuP
         8DSZlg3q2fZi20g8yKIF/Mlj3SCbkLAgMLEksOgQ=
Date:   Tue, 19 Oct 2021 11:39:34 -0700
From:   akpm@linux-foundation.org
To:     andreyknvl@gmail.com, bharata@linux.ibm.com, cl@linux.com,
        faiyazm@codeaurora.org, gregkh@linuxfoundation.org, guro@fb.com,
        iamjoonsoo.kim@lge.com, keescook@chromium.org,
        linmiaohe@huawei.com, mm-commits@vger.kernel.org,
        penberg@kernel.org, rientjes@google.com, ryabinin.a.a@gmail.com,
        stable@vger.kernel.org, vbabka@suse.cz
Subject:  [merged]
 mm-slub-fix-incorrect-memcg-slab-count-for-bulk-free.patch removed from -mm
 tree
Message-ID: <20211019183934.dWWVcSyH1%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm, slub: fix incorrect memcg slab count for bulk free
has been removed from the -mm tree.  Its filename was
     mm-slub-fix-incorrect-memcg-slab-count-for-bulk-free.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm, slub: fix incorrect memcg slab count for bulk free

kmem_cache_free_bulk() will call memcg_slab_free_hook() for all objects
when doing bulk free.  So we shouldn't call memcg_slab_free_hook() again
for bulk free to avoid incorrect memcg slab count.

Link: https://lkml.kernel.org/r/20210916123920.48704-6-linmiaohe@huawei.com
Fixes: d1b2cf6cb84a ("mm: memcg/slab: uncharge during kmem_cache_free_bulk()")
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

 mm/slub.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/slub.c~mm-slub-fix-incorrect-memcg-slab-count-for-bulk-free
+++ a/mm/slub.c
@@ -3420,7 +3420,9 @@ static __always_inline void do_slab_free
 	struct kmem_cache_cpu *c;
 	unsigned long tid;
 
-	memcg_slab_free_hook(s, &head, 1);
+	/* memcg_slab_free_hook() is already called for bulk free. */
+	if (!tail)
+		memcg_slab_free_hook(s, &head, 1);
 redo:
 	/*
 	 * Determine the currently cpus per cpu slab.
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

