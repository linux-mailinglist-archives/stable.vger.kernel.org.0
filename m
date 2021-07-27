Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E5833D7E8A
	for <lists+stable@lfdr.de>; Tue, 27 Jul 2021 21:35:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231193AbhG0TfP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Jul 2021 15:35:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:33508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230454AbhG0TfP (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Jul 2021 15:35:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9283560FC0;
        Tue, 27 Jul 2021 19:35:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1627414513;
        bh=b4dMsyqucEuRM+AnbCDh5Aeejld1Xu4ALcyg8KoBYlo=;
        h=Date:From:To:Subject:From;
        b=Ddnpc244wTpFjfahB8Rua8nvNxt560bLcpwdpPUoeWIc5e5KGoOM2SVCGpEzGkT9v
         PuoOmf++yEzP92Jwms5TIX2TYCQSCSZWFXXr2F0UOZ4tJAzQDZx1+TOvGrugTkDrWn
         3PUaSpSd3k3XmH9YmXNTm4UyHVquwa3eD1dYg6bk=
Date:   Tue, 27 Jul 2021 12:35:13 -0700
From:   akpm@linux-foundation.org
To:     dvyukov@google.com, elver@google.com, glider@google.com,
        gregkh@linuxfoundation.org, jrdr.linux@gmail.com,
        mm-commits@vger.kernel.org, stable@vger.kernel.org
Subject:  [merged] kfence-skip-all-gfp_zonemask-allocations.patch
 removed from -mm tree
Message-ID: <20210727193513.7sGW9cB0m%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: kfence: skip all GFP_ZONEMASK allocations
has been removed from the -mm tree.  Its filename was
     kfence-skip-all-gfp_zonemask-allocations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


