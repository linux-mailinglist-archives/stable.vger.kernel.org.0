Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54E9A433E9C
	for <lists+stable@lfdr.de>; Tue, 19 Oct 2021 20:39:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234159AbhJSSlh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Oct 2021 14:41:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:52530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232144AbhJSSlg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Oct 2021 14:41:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CF97B610E5;
        Tue, 19 Oct 2021 18:39:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1634668763;
        bh=hLOHci2ZAhpUCX/9HBTxrgTttEf0N9HBj19xszBnWcs=;
        h=Date:From:To:Subject:From;
        b=ZJ0m9ggIkyYxC0cbkiv9oXNpyrV9tzue+e+tbMI8k4H1I6wq0577UrzdAO9fg1/dm
         evinOMVOt62BX8jJWdmWZhibD/pZU/CcBAa/G7wSbld+irCgmo/Rb0OiRqZgRtUnAz
         wK/UgG+/QdAxuSXygbYgD4hq/ndK+TlAVFLTMshs=
Date:   Tue, 19 Oct 2021 11:39:22 -0700
From:   akpm@linux-foundation.org
To:     andreyknvl@gmail.com, bharata@linux.ibm.com, cl@linux.com,
        faiyazm@codeaurora.org, gregkh@linuxfoundation.org, guro@fb.com,
        iamjoonsoo.kim@lge.com, keescook@chromium.org,
        linmiaohe@huawei.com, mm-commits@vger.kernel.org,
        penberg@kernel.org, rientjes@google.com, ryabinin.a.a@gmail.com,
        stable@vger.kernel.org, vbabka@suse.cz
Subject:  [merged]
 mm-slub-fix-two-bugs-in-slab_debug_trace_open.patch removed from -mm tree
Message-ID: <20211019183922.tsainDXdu%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm, slub: fix two bugs in slab_debug_trace_open()
has been removed from the -mm tree.  Its filename was
     mm-slub-fix-two-bugs-in-slab_debug_trace_open.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm, slub: fix two bugs in slab_debug_trace_open()

Patch series "Fixups for slub".

This series contains various bug fixes for slub.  We fix memoryleak,
use-afer-free, NULL pointer dereferencing and so on in slub.  More details
can be found in the respective changelogs.


This patch (of 5):

It's possible that __seq_open_private() will return NULL.  So we should
check it before using lest dereferencing NULL pointer.  And in error
paths, we forgot to release private buffer via seq_release_private(). 
Memory will leak in these paths.

Link: https://lkml.kernel.org/r/20210916123920.48704-1-linmiaohe@huawei.com
Link: https://lkml.kernel.org/r/20210916123920.48704-2-linmiaohe@huawei.com
Fixes: 64dd68497be7 ("mm: slub: move sysfs slab alloc/free interfaces to debugfs")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Faiyaz Mohammed <faiyazm@codeaurora.org>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Bharata B Rao <bharata@linux.ibm.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/mm/slub.c~mm-slub-fix-two-bugs-in-slab_debug_trace_open
+++ a/mm/slub.c
@@ -6108,9 +6108,14 @@ static int slab_debug_trace_open(struct
 	struct kmem_cache *s = file_inode(filep)->i_private;
 	unsigned long *obj_map;
 
+	if (!t)
+		return -ENOMEM;
+
 	obj_map = bitmap_alloc(oo_objects(s->oo), GFP_KERNEL);
-	if (!obj_map)
+	if (!obj_map) {
+		seq_release_private(inode, filep);
 		return -ENOMEM;
+	}
 
 	if (strcmp(filep->f_path.dentry->d_name.name, "alloc_traces") == 0)
 		alloc = TRACK_ALLOC;
@@ -6119,6 +6124,7 @@ static int slab_debug_trace_open(struct
 
 	if (!alloc_loc_track(t, PAGE_SIZE / sizeof(struct location), GFP_KERNEL)) {
 		bitmap_free(obj_map);
+		seq_release_private(inode, filep);
 		return -ENOMEM;
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

