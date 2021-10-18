Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21FB64329A6
	for <lists+stable@lfdr.de>; Tue, 19 Oct 2021 00:15:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233559AbhJRWSJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 18:18:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:37214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229524AbhJRWSI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 18:18:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 601D260F57;
        Mon, 18 Oct 2021 22:15:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1634595356;
        bh=roSzT3AvId2L5VA5dSV6E9afZsvcls7kpafRy9EfZCE=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=J7RyugNbnFMhdc9Fcd5I7pwOVtd3wuPihtKx6agEzlK/5ztrhfmffabbmWSNYL6gW
         MqnWJIaBbQzBsZBGJp0lQnpoUzxRBoTVuqAFLrHFrnifdXqr8NLRsVLoMKj3eQ4VBa
         HNyeuVHB36kBNg+dJc5XJ8aZJiIpdsurJtJumveo=
Date:   Mon, 18 Oct 2021 15:15:55 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andreyknvl@gmail.com,
        bharata@linux.ibm.com, cl@linux.com, faiyazm@codeaurora.org,
        gregkh@linuxfoundation.org, guro@fb.com, iamjoonsoo.kim@lge.com,
        keescook@chromium.org, linmiaohe@huawei.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, penberg@kernel.org,
        rientjes@google.com, ryabinin.a.a@gmail.com,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        vbabka@suse.cz
Subject:  [patch 11/19] mm, slub: fix mismatch between
 reconstructed freelist depth and cnt
Message-ID: <20211018221555.hXUCjmz1Z%akpm@linux-foundation.org>
In-Reply-To: <20211018151438.f2246e2656c041b6753a8bdd@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
