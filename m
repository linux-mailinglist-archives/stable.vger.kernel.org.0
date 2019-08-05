Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A93681D43
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 15:31:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729881AbfHENTs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 09:19:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:55928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729838AbfHENTr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Aug 2019 09:19:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 58A662147A;
        Mon,  5 Aug 2019 13:19:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565011186;
        bh=17d/w8H4pfT3UR1Cm/mPukUrGlkmJQSgqyJ4ttorKlk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iQvNU42+GaazK0JrtSn4N9jNgC5PG1IMe2mrQykV6KW3IbPm7IErNYvApa++NDzgQ
         cGaKWaZ5cjjtobkA/ijn19GZ/AAhwPOt6VqSKHZ5jYzTnU9dUKb3tG1L6mUIrYnwrT
         nebQzVcPjpIkwWqb7pOp3Ee/iZaRMe8PxK2zfi8s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yang Shi <yang.shi@linux.alibaba.com>,
        Shakeel Butt <shakeelb@google.com>,
        Kirill Tkhai <ktkhai@virtuozzo.com>,
        Michal Hocko <mhocko@suse.com>,
        Jan Hadrava <had@kam.mff.cuni.cz>,
        Vladimir Davydov <vdavydov.dev@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Roman Gushchin <guro@fb.com>, Hugh Dickins <hughd@google.com>,
        Qian Cai <cai@lca.pw>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.19 53/74] mm: vmscan: check if mem cgroup is disabled or not before calling memcg slab shrinker
Date:   Mon,  5 Aug 2019 15:03:06 +0200
Message-Id: <20190805124940.171405840@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190805124935.819068648@linuxfoundation.org>
References: <20190805124935.819068648@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Shi <yang.shi@linux.alibaba.com>

commit fa1e512fac717f34e7c12d7a384c46e90a647392 upstream.

Shakeel Butt reported premature oom on kernel with
"cgroup_disable=memory" since mem_cgroup_is_root() returns false even
though memcg is actually NULL.  The drop_caches is also broken.

It is because commit aeed1d325d42 ("mm/vmscan.c: generalize
shrink_slab() calls in shrink_node()") removed the !memcg check before
!mem_cgroup_is_root().  And, surprisingly root memcg is allocated even
though memory cgroup is disabled by kernel boot parameter.

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
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/vmscan.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -670,7 +670,14 @@ static unsigned long shrink_slab(gfp_t g
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


