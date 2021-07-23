Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 756863D4319
	for <lists+stable@lfdr.de>; Sat, 24 Jul 2021 00:50:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233040AbhGWWJm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Jul 2021 18:09:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:49280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231954AbhGWWJl (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 23 Jul 2021 18:09:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 88CCC60F38;
        Fri, 23 Jul 2021 22:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1627080614;
        bh=sJhcHAJQXX9/g/lQZhnBn3+SvS8+7TbLziKr6aEHuUA=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=EwuNlVuM9QS55jgeq+/orAiqSaUxPSwGRicfLZgRb+dW6O34m6eMS8hJSvFfdbSyx
         cbLDXw3B0/o3NsdA2gS/KGZuOVmOY81+jmuoUs43SKJe4pcE13Ozx7ya6ImCfzwIeq
         WBLFqBSDUwIocMzlaBr9gYVsXJuor8rnI8WG5hzc=
Date:   Fri, 23 Jul 2021 15:50:14 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, dvyukov@google.com, elver@google.com,
        glider@google.com, gregkh@linuxfoundation.org,
        jrdr.linux@gmail.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 05/15] kfence: skip all GFP_ZONEMASK allocations
Message-ID: <20210723225014.XVYds8s7E%akpm@linux-foundation.org>
In-Reply-To: <20210723154926.c6cda0f262b1990b950a5886@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
