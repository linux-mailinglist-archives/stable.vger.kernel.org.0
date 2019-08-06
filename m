Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1565983A04
	for <lists+stable@lfdr.de>; Tue,  6 Aug 2019 22:07:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726340AbfHFUHT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Aug 2019 16:07:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:58564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725948AbfHFUHT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Aug 2019 16:07:19 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C2C0D2070C;
        Tue,  6 Aug 2019 20:07:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565122038;
        bh=0p8jow74uAoPFTgfTe1taRKC8YGTEF1NqdDsk6DN5Ko=;
        h=Date:From:To:Subject:From;
        b=j6MiG3MAKSujR12zWYg3kkxpkxCGaJmFrXkkY6aGhReOz/N3Nd5j2GhWmjqgxGNm4
         EVd5OyamOznvr/9tPedPeqrygwYVLHB+4XCe5vcLQQs0QoabNmr8i59E8tQPWtQKl5
         U3wuCb4KiiFnUCSgZW0Ihr2/B7hAiVPYRz80rth0=
Date:   Tue, 06 Aug 2019 13:07:17 -0700
From:   akpm@linux-foundation.org
To:     cai@lca.pw, guro@fb.com, had@kam.mff.cuni.cz, hannes@cmpxchg.org,
        hughd@google.com, kirill.shutemov@linux.intel.com,
        ktkhai@virtuozzo.com, mhocko@suse.com, mm-commits@vger.kernel.org,
        shakeelb@google.com, stable@vger.kernel.org,
        vdavydov.dev@gmail.com, yang.shi@linux.alibaba.com
Subject:  [merged]
 =?US-ASCII?Q?mm-vmscan-check-if-mem-cgroup-is-disabled-or-not-before-c?=
 =?US-ASCII?Q?alling-memcg-slab-shrinker.patch?= removed from -mm tree
Message-ID: <20190806200717.0MK1ICwsm%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm: vmscan: check if mem cgroup is disabled or not before calling memcg slab shrinker
has been removed from the -mm tree.  Its filename was
     mm-vmscan-check-if-mem-cgroup-is-disabled-or-not-before-calling-memcg-slab-shrinker.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Jan Hadrava <had@kam.mff.cuni.cz>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
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

mm-mempolicy-make-the-behavior-consistent-when-mpol_mf_move-and-mpol_mf_strict-were-specified.patch
mm-mempolicy-make-the-behavior-consistent-when-mpol_mf_move-and-mpol_mf_strict-were-specified-v4.patch
mm-mempolicy-handle-vma-with-unmovable-pages-mapped-correctly-in-mbind.patch
mm-mempolicy-handle-vma-with-unmovable-pages-mapped-correctly-in-mbind-v4.patch

