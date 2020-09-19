Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DAA2270A86
	for <lists+stable@lfdr.de>; Sat, 19 Sep 2020 06:20:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726170AbgISEUL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 19 Sep 2020 00:20:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:54500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726009AbgISEUK (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 19 Sep 2020 00:20:10 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D975520874;
        Sat, 19 Sep 2020 04:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600489210;
        bh=41YxocmAsZxH5HSeesZDPmKWXspsdtu9QFhZ4cINIiI=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=f48y29IGXBGqYz4BRglywcvewToQmfymmgbkxC3jqTRpE/uxKcrWyo/piw/cW2m81
         QPylw6B9hxJTYSrv5ctbn1WSaJQvbApzB7U/ELkhKn4My1aeKprRvH89aDSi8iaAAl
         Y9ryj4hmTE7sDcOJlmGGejKkWRwt5RIJ6Syr7veI=
Date:   Fri, 18 Sep 2020 21:20:09 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, alex.shi@linux.alibaba.com, cai@lca.pw,
        hannes@cmpxchg.org, hughd@google.com, linux-mm@kvack.org,
        mhocko@suse.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, shakeelb@google.com,
        shy828301@gmail.com, stable@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 04/15] shmem: shmem_writepage() split unlikely
 i915 THP
Message-ID: <20200919042009.bomzxmrg7%akpm@linux-foundation.org>
In-Reply-To: <20200918211925.7e97f0ef63d92f5cfe5ccbc5@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Cc: <stable@vger.kernel.org>	[5.3+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/mm/shmem.c~shmem-shmem_writepage-split-unlikely-i915-thp
+++ a/mm/shmem.c
@@ -1362,7 +1362,15 @@ static int shmem_writepage(struct page *
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
