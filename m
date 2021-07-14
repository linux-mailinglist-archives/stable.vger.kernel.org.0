Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C8783C93F7
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 00:42:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236744AbhGNWpT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 18:45:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:58830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231394AbhGNWpT (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 18:45:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D98D2613CB;
        Wed, 14 Jul 2021 22:42:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1626302546;
        bh=1/7uLkCqp07fZVl9qXmwhpDoT0IS1Jw1h/+H5YPK/N8=;
        h=Date:From:To:Subject:From;
        b=zg37cOIoZ6RNBBhWUloMXmb5zXLMHW9GkhTAzXHe0Y9W35pa5BTTEZ+Pi2IBp1otq
         5yDfUzxI3v4Y3ZCzE6wArQ2GWULXwPsxneKLQwFqBqcgMINPTBd2qj+kS44AcUu5JW
         7tZte6Dp1JAnwNBs4/bQH0mNx6XPrgcgwNhvRj6Y=
Date:   Wed, 14 Jul 2021 15:42:25 -0700
From:   akpm@linux-foundation.org
To:     dvyukov@google.com, elver@google.com, glider@google.com,
        gregkh@linuxfoundation.org, jrdr.linux@gmail.com,
        mm-commits@vger.kernel.org, stable@vger.kernel.org
Subject:  + kfence-skip-all-gfp_zonemask-allocations.patch added to
 -mm tree
Message-ID: <20210714224225.Gmo7sht2E%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: kfence: skip all GFP_ZONEMASK allocations
has been added to the -mm tree.  Its filename is
     kfence-skip-all-gfp_zonemask-allocations.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kfence-skip-all-gfp_zonemask-allocations.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kfence-skip-all-gfp_zonemask-allocations.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexander Potapenko <glider@google.com>
Subject: kfence: skip all GFP_ZONEMASK allocations

Allocation requests outside ZONE_NORMAL (MOVABLE, HIGHMEM or DMA) cannot
be fulfilled by KFENCE, because KFENCE memory pool is located in a zone
different from the requested one.

Because callers of kmem_cache_alloc() may actually rely on the allocation
to reside in the requested zone (e.g.  memory allocations done with
__GFP_DMA must be DMAable), skip all allocations done with GFP_ZONEMASK
and/or respective SLAB flags (SLAB_CACHE_DMA and SLAB_CACHE_DMA32).

Link: https://lkml.kernel.org/r/20210714092222.1890268-2-glider@google.com
Fixes: 0ce20dd84089 ("mm: add Kernel Electric-Fence infrastructure")
Signed-off-by: Alexander Potapenko <glider@google.com>
Reviewed-by: Marco Elver <elver@google.com>
Acked-by: Souptick Joarder <jrdr.linux@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Souptick Joarder <jrdr.linux@gmail.com>
Cc: <stable@vger.kernel.org>	[5.12+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kfence/core.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/mm/kfence/core.c~kfence-skip-all-gfp_zonemask-allocations
+++ a/mm/kfence/core.c
@@ -741,6 +741,15 @@ void *__kfence_alloc(struct kmem_cache *
 		return NULL;
 
 	/*
+	 * Skip allocations from non-default zones, including DMA. We cannot
+	 * guarantee that pages in the KFENCE pool will have the requested
+	 * properties (e.g. reside in DMAable memory).
+	 */
+	if ((flags & GFP_ZONEMASK) ||
+	    (s->flags & (SLAB_CACHE_DMA | SLAB_CACHE_DMA32)))
+		return NULL;
+
+	/*
 	 * allocation_gate only needs to become non-zero, so it doesn't make
 	 * sense to continue writing to it and pay the associated contention
 	 * cost, in case we have a large number of concurrent allocations.
_

Patches currently in -mm which might be from glider@google.com are

kfence-move-the-size-check-to-the-beginning-of-__kfence_alloc.patch
kfence-skip-all-gfp_zonemask-allocations.patch

