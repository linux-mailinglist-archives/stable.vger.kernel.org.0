Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 256682749A4
	for <lists+stable@lfdr.de>; Tue, 22 Sep 2020 21:58:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726615AbgIVT6Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Sep 2020 15:58:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:52928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726589AbgIVT6Z (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Sep 2020 15:58:25 -0400
Received: from X1 (unknown [216.241.194.61])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B2263221E8;
        Tue, 22 Sep 2020 19:58:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600804704;
        bh=9EHhEKB6W7yiZCj2Gb+fnnKUKfFmwBX2UOuEkCy0w7E=;
        h=Date:From:To:Subject:From;
        b=rgYodkQDbASsTowYK7DdEqU6MJF8D/L/srEr9B0QPDgD30Q92s8aK0Vz4FUihtC2S
         qmv7gPZW6LMPgAzOPJe6Ssr46g6OLnD3R57gw4V+nUCf8ppaT9bd0nTRu62C515LkP
         6SveUjUAEaqFJpQpEcPt5HPRInZOVTa305W6WWyw=
Date:   Tue, 22 Sep 2020 12:58:22 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        stable@vger.kernel.org, shy828301@gmail.com, shakeelb@google.com,
        mike.kravetz@oracle.com, mhocko@suse.com, hannes@cmpxchg.org,
        cai@lca.pw, alex.shi@linux.alibaba.com, hughd@google.com
Subject:  [to-be-updated]
 shmem-shmem_writepage-split-unlikely-i915-thp.patch removed from -mm tree
Message-ID: <20200922195822.34qJx%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: shmem: shmem_writepage() split unlikely i915 THP
has been removed from the -mm tree.  Its filename was
     shmem-shmem_writepage-split-unlikely-i915-thp.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: shmem: shmem_writepage() split unlikely i915 THP

drivers/gpu/drm/i915/gem/i915_gem_shmem.c contains a shmem_writeback()
which calls shmem_writepage() from a shrinker: that usually works well
enough; but if /sys/kernel/mm/transparent_hugepage/shmem_enabled has been
set to "force" (documented as "Force the huge option on for all - very
useful for testing"), shmem_writepage() is surprised to be called with a
huge page, and crashes on the VM_BUG_ON_PAGE(PageCompound) (I did not find
out where the crash happens when CONFIG_DEBUG_VM is off).

LRU page reclaim always splits the shmem huge page first: I'd prefer not
to demand that of i915, so check and split compound in shmem_writepage().

Link: http://lkml.kernel.org/r/alpine.LSU.2.11.2008301401390.5954@eggly.anvils
Fixes: 2d6692e642e7 ("drm/i915: Start writeback from the shrinker")
Signed-off-by: Hugh Dickins <hughd@google.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Yang Shi <shy828301@gmail.com>
Cc: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Qian Cai <cai@lca.pw>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: <stable@vger.kernel.org>	[5.3+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/mm/shmem.c~shmem-shmem_writepage-split-unlikely-i915-thp
+++ a/mm/shmem.c
@@ -1364,7 +1364,15 @@ static int shmem_writepage(struct page *
 	swp_entry_t swap;
 	pgoff_t index;
 
-	VM_BUG_ON_PAGE(PageCompound(page), page);
+	/*
+	 * If /sys/kernel/mm/transparent_hugepage/shmem_enabled is "force",
+	 * then drivers/gpu/drm/i915/gem/i915_gem_shmem.c gets huge pages,
+	 * and its shmem_writeback() needs them to be split when swapping.
+	 */
+	if (PageTransCompound(page))
+		if (split_huge_page(page) < 0)
+			goto redirty;
+
 	BUG_ON(!PageLocked(page));
 	mapping = page->mapping;
 	index = page->index;
_

Patches currently in -mm which might be from hughd@google.com are


