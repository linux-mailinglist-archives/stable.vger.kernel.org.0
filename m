Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19CD44329A9
	for <lists+stable@lfdr.de>; Tue, 19 Oct 2021 00:16:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229529AbhJRWSU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 18:18:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:37440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233600AbhJRWSS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 18:18:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 962CD610FB;
        Mon, 18 Oct 2021 22:16:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1634595367;
        bh=FQO3/artqDNMfwd2Y8MSjvc/OYRcYxGEuGudqkf7YZU=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=ZLlRUt5FQE4PDhLfpRTl2vUUmHtoOrcgjZ2dXpVbVrljjf+FciAIQ/WWU2OAombhr
         yzQO5lvbvFvGVmnPECdfeG6zQAApIbzNz0SJQSPJr6bD3whm7JjL4fjznXEeKLsWMA
         r9uxe7Y4FlLrxb6eLle+BuLqbmbx7EwbRBygLEKE=
Date:   Mon, 18 Oct 2021 15:16:06 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andreyknvl@gmail.com,
        bharata@linux.ibm.com, cl@linux.com, faiyazm@codeaurora.org,
        gregkh@linuxfoundation.org, guro@fb.com, iamjoonsoo.kim@lge.com,
        keescook@chromium.org, linmiaohe@huawei.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, penberg@kernel.org,
        rientjes@google.com, ryabinin.a.a@gmail.com,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        vbabka@suse.cz
Subject:  [patch 14/19] mm, slub: fix incorrect memcg slab count
 for bulk free
Message-ID: <20211018221606.0wZ3nwZSc%akpm@linux-foundation.org>
In-Reply-To: <20211018151438.f2246e2656c041b6753a8bdd@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
