Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D2C58046D
	for <lists+stable@lfdr.de>; Sat,  3 Aug 2019 06:48:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726295AbfHCEsq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 3 Aug 2019 00:48:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:35472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725283AbfHCEsq (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 3 Aug 2019 00:48:46 -0400
Received: from X1 (unknown [76.191.170.112])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C2D232067D;
        Sat,  3 Aug 2019 04:48:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564807725;
        bh=AoIc8Z45p1DjNmIcX4blC1xUE04WgYIieK/9+7+hTik=;
        h=Date:From:To:Subject:From;
        b=JAZVlXb3SfBN2e4KfR9DAD8imAJzE3PJFS+xGhc/4DwoqfKzv+QOra8KLNox5TBfr
         E41YaRKlvzD4YYioLmVzKenu6MRsj6VukuCUtC3IW84pbtHU8q4yHE3SBAl9lkoU/y
         +3IZIbmm8M1VPXi9c6BrtcUDZo6LdfrFKVGIN0lg=
Date:   Fri, 02 Aug 2019 21:48:44 -0700
From:   akpm@linux-foundation.org
To:     vdavydov.dev@gmail.com, stable@vger.kernel.org,
        shakeelb@google.com, mhocko@suse.com, ktkhai@virtuozzo.com,
        kirill.shutemov@linux.intel.com, hughd@google.com,
        hannes@cmpxchg.org, had@kam.mff.cuni.cz, guro@fb.com, cai@lca.pw,
        yang.shi@linux.alibaba.com, akpm@linux-foundation.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 04/17] mm: vmscan: check if mem cgroup is disabled
 or not before calling memcg slab shrinker
Message-ID: <20190803044844.qTSA9%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
