Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6643433E9F
	for <lists+stable@lfdr.de>; Tue, 19 Oct 2021 20:39:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234891AbhJSSlq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Oct 2021 14:41:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:52714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234909AbhJSSlp (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Oct 2021 14:41:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C26826138F;
        Tue, 19 Oct 2021 18:39:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1634668772;
        bh=iaHOxkbh72KTiEBxarvrSysHEuKSmqHsoFSbJWpmLvQ=;
        h=Date:From:To:Subject:From;
        b=aQpHrfiKcLcxTi4hvazuwQC5oGfLYe6+asfMN+OGKNa5CgkQAG7+PaOlwoepEJSsE
         It+oHwcIS4+WnsZUwoWk+qFPVZ6mtpN36/zUckTjAEowUr5YM7hCNbUcxUkGmPrVSX
         70AGV1AASlhgdnz7a5PeBhGysQDmtcPvtC6EjQ3g=
Date:   Tue, 19 Oct 2021 11:39:31 -0700
From:   akpm@linux-foundation.org
To:     andreyknvl@gmail.com, bharata@linux.ibm.com, cl@linux.com,
        faiyazm@codeaurora.org, gregkh@linuxfoundation.org, guro@fb.com,
        iamjoonsoo.kim@lge.com, keescook@chromium.org,
        linmiaohe@huawei.com, mm-commits@vger.kernel.org,
        penberg@kernel.org, rientjes@google.com, ryabinin.a.a@gmail.com,
        stable@vger.kernel.org, vbabka@suse.cz
Subject:  [merged]
 mm-slub-fix-potential-use-after-free-in-slab_debugfs_fops.patch removed
 from -mm tree
Message-ID: <20211019183931.4EGfApbcI%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm, slub: fix potential use-after-free in slab_debugfs_fops
has been removed from the -mm tree.  Its filename was
     mm-slub-fix-potential-use-after-free-in-slab_debugfs_fops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm, slub: fix potential use-after-free in slab_debugfs_fops

When sysfs_slab_add failed, we shouldn't call debugfs_slab_add() for s
because s will be freed soon.  And slab_debugfs_fops will use s later
leading to a use-after-free.

Link: https://lkml.kernel.org/r/20210916123920.48704-5-linmiaohe@huawei.com
Fixes: 64dd68497be7 ("mm: slub: move sysfs slab alloc/free interfaces to debugfs")
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

 mm/slub.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/mm/slub.c~mm-slub-fix-potential-use-after-free-in-slab_debugfs_fops
+++ a/mm/slub.c
@@ -4887,13 +4887,15 @@ int __kmem_cache_create(struct kmem_cach
 		return 0;
 
 	err = sysfs_slab_add(s);
-	if (err)
+	if (err) {
 		__kmem_cache_release(s);
+		return err;
+	}
 
 	if (s->flags & SLAB_STORE_USER)
 		debugfs_slab_add(s);
 
-	return err;
+	return 0;
 }
 
 void *__kmalloc_track_caller(size_t size, gfp_t gfpflags, unsigned long caller)
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

