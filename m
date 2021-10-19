Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDA47433E9E
	for <lists+stable@lfdr.de>; Tue, 19 Oct 2021 20:39:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234941AbhJSSln (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Oct 2021 14:41:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:52652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234891AbhJSSlm (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Oct 2021 14:41:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BD07C61212;
        Tue, 19 Oct 2021 18:39:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1634668769;
        bh=Y3htAeRGyg0VJhDQntEFTmW1YkDLBNMRsRAeFdOvT7o=;
        h=Date:From:To:Subject:From;
        b=A0fna+fRa0Tsgmo1q6oabdwIffprjH9HxCXF479f7N1ll4vRv+cRjWY6fgd9RmPI6
         SCSpt1QZXtt/52ek4rPvExT4jUA1P8BCJt7qH6mZ4FeNS7+12t/VTj49YNeqyIKWZv
         xO5NVBU3eiXSNTnqOb7/5plLZzNT+8KWWucQkdcc=
Date:   Tue, 19 Oct 2021 11:39:28 -0700
From:   akpm@linux-foundation.org
To:     andreyknvl@gmail.com, bharata@linux.ibm.com, cl@linux.com,
        faiyazm@codeaurora.org, gregkh@linuxfoundation.org, guro@fb.com,
        iamjoonsoo.kim@lge.com, keescook@chromium.org,
        linmiaohe@huawei.com, mm-commits@vger.kernel.org,
        penberg@kernel.org, rientjes@google.com, ryabinin.a.a@gmail.com,
        stable@vger.kernel.org, vbabka@suse.cz
Subject:  [merged]
 mm-slub-fix-potential-memoryleak-in-kmem_cache_open.patch removed from -mm
 tree
Message-ID: <20211019183928.DQoWqiCR_%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm, slub: fix potential memoryleak in kmem_cache_open()
has been removed from the -mm tree.  Its filename was
     mm-slub-fix-potential-memoryleak-in-kmem_cache_open.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm, slub: fix potential memoryleak in kmem_cache_open()

In error path, the random_seq of slub cache might be leaked.  Fix this by
using __kmem_cache_release() to release all the relevant resources.

Link: https://lkml.kernel.org/r/20210916123920.48704-4-linmiaohe@huawei.com
Fixes: 210e7a43fa90 ("mm: SLUB freelist randomization")
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

 mm/slub.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/slub.c~mm-slub-fix-potential-memoryleak-in-kmem_cache_open
+++ a/mm/slub.c
@@ -4210,8 +4210,8 @@ static int kmem_cache_open(struct kmem_c
 	if (alloc_kmem_cache_cpus(s))
 		return 0;
 
-	free_kmem_cache_nodes(s);
 error:
+	__kmem_cache_release(s);
 	return -EINVAL;
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

