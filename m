Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69CEE6D5D3
	for <lists+stable@lfdr.de>; Thu, 18 Jul 2019 22:35:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391553AbfGRUcn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jul 2019 16:32:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:42130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391523AbfGRUcn (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 18 Jul 2019 16:32:43 -0400
Received: from akpm3.svl.corp.google.com (unknown [104.133.8.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E28E621019;
        Thu, 18 Jul 2019 20:32:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563481962;
        bh=D3t3IJeVvtDxa8uDE0ErhRRNryuhfAZQjXfAFCAAoww=;
        h=Date:From:To:Subject:From;
        b=ujYzIb1fArU22rvPvIJLuQ5ktGSb8gsE1HK6iIhpl8vZWOAz7jpyFcqfep5m8qZ9n
         wc+tmGH5HSgtTqLDsuXTIoxgXnsyiMVd2eFHZ2fzMU/soZ9pJDHI5mdxmIWUXKIK+E
         IFj5yGaD6118jYgn6X6HP7lDt89Z/p5FF5SkQOvw=
Date:   Thu, 18 Jul 2019 13:32:41 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, vdavydov.dev@gmail.com,
        stable@vger.kernel.org, shakeelb@google.com, mhocko@suse.com,
        ktkhai@virtuozzo.com, kirill.shutemov@linux.intel.com,
        hughd@google.com, hannes@cmpxchg.org, guro@fb.com, cai@lca.pw,
        yang.shi@linux.alibaba.com
Subject:  +
 =?us-ascii?Q?mm-vmscan-check-if-mem-cgroup-is-disabled-or-not-before-c?=
 =?us-ascii?Q?alling-memcg-slab-shrinker.patch?= added to -mm tree
Message-ID: <20190718203241.iQ4C6%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm: vmscan: check if mem cgroup is disabled or not before calling memcg slab shrinker
has been added to the -mm tree.  Its filename is
     mm-vmscan-check-if-mem-cgroup-is-disabled-or-not-before-calling-memcg-slab-shrinker.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmscan-check-if-mem-cgroup-is-disabled-or-not-before-calling-memcg-slab-shrinker.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmscan-check-if-mem-cgroup-is-disabled-or-not-before-calling-memcg-slab-shrinker.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yang Shi <yang.shi@linux.alibaba.com>
Subject: mm: vmscan: check if mem cgroup is disabled or not before calling memcg slab shrinker

Shakeel Butt reported premature oom on kernel with "cgroup_disable=memory"
since mem_cgroup_is_root() returns false even though memcg is actually
NULL.  The drop_caches is also broken.

It is because aeed1d325d42 ("mm/vmscan.c: generalize shrink_slab() calls
in shrink_node()") removed the !memcg check before !mem_cgroup_is_root(). 
And, surprisingly root memcg is allocated even though memory cgroup is
disabled by kernel boot parameter.

Add mem_cgroup_disabled() check to make reclaimer work as expected.

Link: http://lkml.kernel.org/r/1563385526-20805-1-git-send-email-yang.shi@linux.alibaba.com
Fixes: aeed1d325d42 ("mm/vmscan.c: generalize shrink_slab() calls in shrink_node()")
Signed-off-by: Yang Shi <yang.shi@linux.alibaba.com>
Reported-by: Shakeel Butt <shakeelb@google.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Reviewed-by: Kirill Tkhai <ktkhai@virtuozzo.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Qian Cai <cai@lca.pw>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: <stable@vger.kernel.org>	[4.19+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/mm/vmscan.c~mm-vmscan-check-if-mem-cgroup-is-disabled-or-not-before-calling-memcg-slab-shrinker
+++ a/mm/vmscan.c
@@ -699,7 +699,14 @@ static unsigned long shrink_slab(gfp_t g
 	unsigned long ret, freed = 0;
 	struct shrinker *shrinker;
 
-	if (!mem_cgroup_is_root(memcg))
+	/*
+	 * The root memcg might be allocated even though memcg is disabled
+	 * via "cgroup_disable=memory" boot parameter.  This could make
+	 * mem_cgroup_is_root() return false, then just run memcg slab
+	 * shrink, but skip global shrink.  This may result in premature
+	 * oom.
+	 */
+	if (!mem_cgroup_disabled() && !mem_cgroup_is_root(memcg))
 		return shrink_slab_memcg(gfp_mask, nid, memcg, priority);
 
 	if (!down_read_trylock(&shrinker_rwsem))
_

Patches currently in -mm which might be from yang.shi@linux.alibaba.com are

revert-kmemleak-allow-to-coexist-with-fault-injection.patch
mm-vmscan-check-if-mem-cgroup-is-disabled-or-not-before-calling-memcg-slab-shrinker.patch
mm-mempolicy-make-the-behavior-consistent-when-mpol_mf_move-and-mpol_mf_strict-were-specified.patch
mm-mempolicy-handle-vma-with-unmovable-pages-mapped-correctly-in-mbind.patch
mm-thp-make-transhuge_vma_suitable-available-for-anonymous-thp.patch
mm-thp-make-transhuge_vma_suitable-available-for-anonymous-thp-v4.patch
mm-thp-fix-false-negative-of-shmem-vmas-thp-eligibility.patch

