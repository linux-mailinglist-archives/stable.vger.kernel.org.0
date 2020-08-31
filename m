Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 468A425718E
	for <lists+stable@lfdr.de>; Mon, 31 Aug 2020 03:30:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727813AbgHaBaj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 30 Aug 2020 21:30:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:56434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727784AbgHaBaW (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 30 Aug 2020 21:30:22 -0400
Received: from X1 (unknown [65.49.58.28])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 05A612076D;
        Mon, 31 Aug 2020 01:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598837422;
        bh=7+p+Io5ZRf+HW37PZfH3O30h9pXNKs7fjQxr0jbf/xc=;
        h=Date:From:To:Subject:From;
        b=tvVCNSVDSpb2CHCkb2uwgzPc0+yNDp6N8J7z+6OlmKAIfGrNXSr60/2DtNWoh8zDY
         fZVwTXf7VbmRyV+k1q0STuOPeupTnkPOW+WIx5Q2pBEdwjY45eKEA2LjOFLwNdVbDg
         dcKMgzjnVokVpToswY8AzIPOGynnx3zeJmKw3Mcg=
Date:   Sun, 30 Aug 2020 18:30:21 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        shakeelb@google.com, mike.kravetz@oracle.com, mhocko@suse.com,
        hannes@cmpxchg.org, cai@lca.pw, alex.shi@linux.alibaba.com,
        hughd@google.com
Subject:  + shmem-shmem_writepage-split-unlikely-i915-thp.patch added
 to -mm tree
Message-ID: <20200831013021.iDuAW%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: shmem: shmem_writepage() split unlikely i915 THP
has been added to the -mm tree.  Its filename is
     shmem-shmem_writepage-split-unlikely-i915-thp.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/shmem-shmem_writepage-split-unlikely-i915-thp.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/shmem-shmem_writepage-split-unlikely-i915-thp.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Qian Cai <cai@lca.pw>
Cc: Shakeel Butt <shakeelb@google.com>
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

Patches currently in -mm which might be from hughd@google.com are

ksm-reinstate-memcg-charge-on-copied-pages.patch
mm-migration-of-hugetlbfs-page-skip-memcg.patch
shmem-shmem_writepage-split-unlikely-i915-thp.patch
mm-fix-check_move_unevictable_pages-on-thp.patch
mlock-fix-unevictable_pgs-event-counts-on-thp.patch

