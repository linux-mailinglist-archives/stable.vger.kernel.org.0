Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 317A82BC445
	for <lists+stable@lfdr.de>; Sun, 22 Nov 2020 07:18:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727330AbgKVGRO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Nov 2020 01:17:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:55750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726957AbgKVGRN (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Nov 2020 01:17:13 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B1C2620885;
        Sun, 22 Nov 2020 06:17:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1606025833;
        bh=V4UvNIFEgSB4f61jE+1hR5zA9b8uKcCSOXQu58krr8I=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Rf78JHKQyePOpA8S+2V96F1CMPyZBTCz2A/4NZqlK7gNkRnyQIs38EwsdChQWn+SB
         VsBQh9BVKHYXwao14XKxG5TPaI2+HWmv+x1hBjSmxLdWrVZqnP3wKdOYbAE+cWgscn
         Vi8FB4XCckmT/1n30ir42vZRBDajcLbjvXNi/f+0=
Date:   Sat, 21 Nov 2020 22:17:12 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, chris@chrisdown.name, cl@linux.com,
        guro@fb.com, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com,
        laoar.shao@gmail.com, linux-mm@kvack.org, mhocko@kernel.org,
        mm-commits@vger.kernel.org, penberg@kernel.org,
        rientjes@google.com, shakeelb@google.com, songmuchun@bytedance.com,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        vbabka@suse.cz, vdavydov.dev@gmail.com
Subject:  [patch 5/8] mm: memcg/slab: fix root memcg vmstats
Message-ID: <20201122061712.pLjLif6pl%akpm@linux-foundation.org>
In-Reply-To: <20201121221631.948ae4655e913a319d61700a@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: memcg/slab: fix root memcg vmstats

If we reparent the slab objects to the root memcg, when we free the slab
object, we need to update the per-memcg vmstats to keep it correct for the
root memcg.  Now this at least affects the vmstat of NR_KERNEL_STACK_KB
for !CONFIG_VMAP_STACK when the thread stack size is smaller than the
PAGE_SIZE.

David said: "I assume that without this fix that the root memcg's
vmstat would always be inflated if we reparented."

Link: https://lkml.kernel.org/r/20201110031015.15715-1-songmuchun@bytedance.com
Fixes: ec9f02384f60 ("mm: workingset: fix vmstat counters for shadow nodes")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Roman Gushchin <guro@fb.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Christopher Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yafang Shao <laoar.shao@gmail.com>
Cc: Chris Down <chris@chrisdown.name>
Cc: <stable@vger.kernel.org>	[5.3+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/mm/memcontrol.c~mm-memcg-slab-fix-root-memcg-vmstats
+++ a/mm/memcontrol.c
@@ -867,8 +867,13 @@ void __mod_lruvec_slab_state(void *p, en
 	rcu_read_lock();
 	memcg = mem_cgroup_from_obj(p);
 
-	/* Untracked pages have no memcg, no lruvec. Update only the node */
-	if (!memcg || memcg == root_mem_cgroup) {
+	/*
+	 * Untracked pages have no memcg, no lruvec. Update only the
+	 * node. If we reparent the slab objects to the root memcg,
+	 * when we free the slab object, we need to update the per-memcg
+	 * vmstats to keep it correct for the root memcg.
+	 */
+	if (!memcg) {
 		__mod_node_page_state(pgdat, idx, val);
 	} else {
 		lruvec = mem_cgroup_lruvec(memcg, pgdat);
_
