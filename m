Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA8927B148
	for <lists+stable@lfdr.de>; Tue, 30 Jul 2019 20:10:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726900AbfG3SKl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Jul 2019 14:10:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:48134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726255AbfG3SKk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Jul 2019 14:10:40 -0400
Received: from X1 (216.sub-174-222-135.myvzw.com [174.222.135.216])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6DDEE20693;
        Tue, 30 Jul 2019 18:10:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564510239;
        bh=p/rM5Hp6Y/yhEX8Ao1oENLyCl2fcVGbrb4V4RrgQ0zo=;
        h=Date:From:To:Subject:From;
        b=bZSSGruHkhyfxk6WDWSKblhhzA7XkKkngCYsKFYaGGDpY9zQY8ymaxO2KqnpiMTvH
         8z3Gl7oiYMNKqrKUKNg9KKzD8c4RhCde0kbWfVF4gftk08/JdLm15/90eozwIUxdKz
         pCIAKZIKLT+NyFH/Q2gojP6kvbkr8DYXezvx3TxQ=
Date:   Tue, 30 Jul 2019 11:10:32 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, vdavydov.dev@gmail.com,
        stable@vger.kernel.org, mhocko@suse.com, hannes@cmpxchg.org,
        miles.chen@mediatek.com
Subject:  + mm-memcontrol-fix-use-after-free-in-mem_cgroup_iter.patch
 added to -mm tree
Message-ID: <20190730181032.hko-1%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/memcontrol.c: fix use after free in mem_cgroup_iter()
has been added to the -mm tree.  Its filename is
     mm-memcontrol-fix-use-after-free-in-mem_cgroup_iter.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-fix-use-after-free-in-mem_cgroup_iter.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-fix-use-after-free-in-mem_cgroup_iter.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Miles Chen <miles.chen@mediatek.com>
Subject: mm/memcontrol.c: fix use after free in mem_cgroup_iter()

This patch is sent to report an use after free in mem_cgroup_iter() after
merging commit be2657752e9e ("mm: memcg: fix use after free in
mem_cgroup_iter()").

I work with android kernel tree (4.9 & 4.14), and commit be2657752e9e
("mm: memcg: fix use after free in mem_cgroup_iter()") has been merged to
the trees.  However, I can still observe use after free issues addressed
in the commit be2657752e9e.  (on low-end devices, a few times this month)

backtrace:
	css_tryget <- crash here
	mem_cgroup_iter
	shrink_node
	shrink_zones
	do_try_to_free_pages
	try_to_free_pages
	__perform_reclaim
	__alloc_pages_direct_reclaim
	__alloc_pages_slowpath
	__alloc_pages_nodemask

To debug, I poisoned mem_cgroup before freeing it:

static void __mem_cgroup_free(struct mem_cgroup *memcg)
	for_each_node(node)
	free_mem_cgroup_per_node_info(memcg, node);
	free_percpu(memcg->stat);
+       /* poison memcg before freeing it */
+       memset(memcg, 0x78, sizeof(struct mem_cgroup));
	kfree(memcg);
}

The coredump shows the position=0xdbbc2a00 is freed.

(gdb) p/x ((struct mem_cgroup_per_node *)0xe5009e00)->iter[8]
$13 = {position = 0xdbbc2a00, generation = 0x2efd}

0xdbbc2a00:     0xdbbc2e00      0x00000000      0xdbbc2800      0x00000100
0xdbbc2a10:     0x00000200      0x78787878      0x00026218      0x00000000
0xdbbc2a20:     0xdcad6000      0x00000001      0x78787800      0x00000000
0xdbbc2a30:     0x78780000      0x00000000      0x0068fb84      0x78787878
0xdbbc2a40:     0x78787878      0x78787878      0x78787878      0xe3fa5cc0
0xdbbc2a50:     0x78787878      0x78787878      0x00000000      0x00000000
0xdbbc2a60:     0x00000000      0x00000000      0x00000000      0x00000000
0xdbbc2a70:     0x00000000      0x00000000      0x00000000      0x00000000
0xdbbc2a80:     0x00000000      0x00000000      0x00000000      0x00000000
0xdbbc2a90:     0x00000001      0x00000000      0x00000000      0x00100000
0xdbbc2aa0:     0x00000001      0xdbbc2ac8      0x00000000      0x00000000
0xdbbc2ab0:     0x00000000      0x00000000      0x00000000      0x00000000
0xdbbc2ac0:     0x00000000      0x00000000      0xe5b02618      0x00001000
0xdbbc2ad0:     0x00000000      0x78787878      0x78787878      0x78787878
0xdbbc2ae0:     0x78787878      0x78787878      0x78787878      0x78787878
0xdbbc2af0:     0x78787878      0x78787878      0x78787878      0x78787878
0xdbbc2b00:     0x78787878      0x78787878      0x78787878      0x78787878
0xdbbc2b10:     0x78787878      0x78787878      0x78787878      0x78787878
0xdbbc2b20:     0x78787878      0x78787878      0x78787878      0x78787878
0xdbbc2b30:     0x78787878      0x78787878      0x78787878      0x78787878
0xdbbc2b40:     0x78787878      0x78787878      0x78787878      0x78787878
0xdbbc2b50:     0x78787878      0x78787878      0x78787878      0x78787878
0xdbbc2b60:     0x78787878      0x78787878      0x78787878      0x78787878
0xdbbc2b70:     0x78787878      0x78787878      0x78787878      0x78787878
0xdbbc2b80:     0x78787878      0x78787878      0x00000000      0x78787878
0xdbbc2b90:     0x78787878      0x78787878      0x78787878      0x78787878
0xdbbc2ba0:     0x78787878      0x78787878      0x78787878      0x78787878

In the reclaim path, try_to_free_pages() does not setup
sc.target_mem_cgroup and sc is passed to do_try_to_free_pages(), ...,
shrink_node().

In mem_cgroup_iter(), root is set to root_mem_cgroup because
sc->target_mem_cgroup is NULL.  It is possible to assign a memcg to
root_mem_cgroup.nodeinfo.iter in mem_cgroup_iter().

	try_to_free_pages
		struct scan_control sc = {...}, target_mem_cgroup is 0x0;
	do_try_to_free_pages
	shrink_zones
	shrink_node
		 mem_cgroup *root = sc->target_mem_cgroup;
		 memcg = mem_cgroup_iter(root, NULL, &reclaim);
	mem_cgroup_iter()
		if (!root)
			root = root_mem_cgroup;
		...

		css = css_next_descendant_pre(css, &root->css);
		memcg = mem_cgroup_from_css(css);
		cmpxchg(&iter->position, pos, memcg);

My device uses memcg non-hierarchical mode.  When we release a memcg:
invalidate_reclaim_iterators() reaches only dead_memcg and its parents. 
If non-hierarchical mode is used, invalidate_reclaim_iterators() never
reaches root_mem_cgroup.

static void invalidate_reclaim_iterators(struct mem_cgroup *dead_memcg)
{
	struct mem_cgroup *memcg = dead_memcg;

	for (; memcg; memcg = parent_mem_cgroup(memcg)
	...
}

So the use after free scenario looks like:

CPU1						CPU2

try_to_free_pages
do_try_to_free_pages
shrink_zones
shrink_node
mem_cgroup_iter()
    if (!root)
    	root = root_mem_cgroup;
    ...
    css = css_next_descendant_pre(css, &root->css);
    memcg = mem_cgroup_from_css(css);
    cmpxchg(&iter->position, pos, memcg);

					invalidate_reclaim_iterators(memcg);
					...
					__mem_cgroup_free()
						kfree(memcg);

try_to_free_pages
do_try_to_free_pages
shrink_zones
shrink_node
mem_cgroup_iter()
    if (!root)
    	root = root_mem_cgroup;
    ...
    mz = mem_cgroup_nodeinfo(root, reclaim->pgdat->node_id);
    iter = &mz->iter[reclaim->priority];
    pos = READ_ONCE(iter->position);
    css_tryget(&pos->css) <- use after free

To avoid this, we should also invalidate root_mem_cgroup.nodeinfo.iter in
invalidate_reclaim_iterators().

Link: http://lkml.kernel.org/r/20190730015729.4406-1-miles.chen@mediatek.com
Fixes: 5ac8fb31ad2e ("mm: memcontrol: convert reclaim iterator to simple css refcounting")
Signed-off-by: Miles Chen <miles.chen@mediatek.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   39 +++++++++++++++++++++++++++++----------
 1 file changed, 29 insertions(+), 10 deletions(-)

--- a/mm/memcontrol.c~mm-memcontrol-fix-use-after-free-in-mem_cgroup_iter
+++ a/mm/memcontrol.c
@@ -1130,26 +1130,45 @@ void mem_cgroup_iter_break(struct mem_cg
 		css_put(&prev->css);
 }
 
-static void invalidate_reclaim_iterators(struct mem_cgroup *dead_memcg)
+static void __invalidate_reclaim_iterators(struct mem_cgroup *from,
+					struct mem_cgroup *dead_memcg)
 {
-	struct mem_cgroup *memcg = dead_memcg;
 	struct mem_cgroup_reclaim_iter *iter;
 	struct mem_cgroup_per_node *mz;
 	int nid;
 	int i;
 
-	for (; memcg; memcg = parent_mem_cgroup(memcg)) {
-		for_each_node(nid) {
-			mz = mem_cgroup_nodeinfo(memcg, nid);
-			for (i = 0; i <= DEF_PRIORITY; i++) {
-				iter = &mz->iter[i];
-				cmpxchg(&iter->position,
-					dead_memcg, NULL);
-			}
+	for_each_node(nid) {
+		mz = mem_cgroup_nodeinfo(from, nid);
+		for (i = 0; i <= DEF_PRIORITY; i++) {
+			iter = &mz->iter[i];
+			cmpxchg(&iter->position,
+				dead_memcg, NULL);
 		}
 	}
 }
 
+static void invalidate_reclaim_iterators(struct mem_cgroup *dead_memcg)
+{
+	struct mem_cgroup *memcg = dead_memcg;
+	struct mem_cgroup *last;
+
+	do {
+		__invalidate_reclaim_iterators(memcg, dead_memcg);
+		last = memcg;
+	} while (memcg = parent_mem_cgroup(memcg));
+
+	/*
+	 * When cgruop1 non-hierarchy mode is used,
+	 * parent_mem_cgroup() does not walk all the way up to the
+	 * cgroup root (root_mem_cgroup). So we have to handle
+	 * dead_memcg from cgroup root separately.
+	 */
+	if (last != root_mem_cgroup)
+		__invalidate_reclaim_iterators(root_mem_cgroup,
+						dead_memcg);
+}
+
 /**
  * mem_cgroup_scan_tasks - iterate over tasks of a memory cgroup hierarchy
  * @memcg: hierarchy root
_

Patches currently in -mm which might be from miles.chen@mediatek.com are

mm-memcontrol-fix-use-after-free-in-mem_cgroup_iter.patch

