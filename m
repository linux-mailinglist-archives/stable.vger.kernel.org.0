Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E25C090078
	for <lists+stable@lfdr.de>; Fri, 16 Aug 2019 13:06:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727018AbfHPLGf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Aug 2019 07:06:35 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:61533 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726981AbfHPLGe (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Aug 2019 07:06:34 -0400
X-UUID: cd793b558f0942f691fd8eb225d0e317-20190816
X-UUID: cd793b558f0942f691fd8eb225d0e317-20190816
Received: from mtkmrs01.mediatek.inc [(172.21.131.159)] by mailgw01.mediatek.com
        (envelope-from <miles.chen@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0707 with TLS)
        with ESMTP id 52482549; Fri, 16 Aug 2019 19:06:25 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs01n2.mediatek.inc (172.21.101.79) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Fri, 16 Aug 2019 19:06:29 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Fri, 16 Aug 2019 19:06:29 +0800
Message-ID: <1565953586.26404.3.camel@mtkswgap22>
Subject: Re: FAILED: patch "[PATCH] mm/memcontrol.c: fix use after free in
 mem_cgroup_iter()" failed to apply to 4.9-stable tree
From:   Miles Chen <miles.chen@mediatek.com>
To:     <gregkh@linuxfoundation.org>
CC:     <akpm@linux-foundation.org>, <cai@lca.pw>, <hannes@cmpxchg.org>,
        <mhocko@suse.com>, <stable@vger.kernel.org>,
        <torvalds@linux-foundation.org>, <vdavydov.dev@gmail.com>
Date:   Fri, 16 Aug 2019 19:06:26 +0800
In-Reply-To: <156594986424362@kroah.com>
References: <156594986424362@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-TM-SNTS-SMTP: AA29D158DC8AE9E3A25CD8DA13CF6DF96282DB20484D8A7870887E8394AC4B942000:8
X-MTK:  N
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 2019-08-16 at 12:04 +0200, gregkh@linuxfoundation.org wrote:
> The patch below does not apply to the 4.9-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 
> thanks,
> 
> greg k-h
> 

Hi Greg,

Below this the backport for 4.9

cheers,
Miles

From e4d7e8ef4d279216930bd7f651e97db64c928b23 Mon Sep 17 00:00:00 2001
From: Miles Chen <miles.chen@mediatek.com>
Date: Fri, 16 Aug 2019 18:31:58 +0800
Subject: [PATCH] BACKPORT: mm/memcontrol.c: fix use after free in
 mem_cgroup_iter()

original commit id: 54a83d6bcbf8f4700013766b974bf9190d40b689
(this is 

This patch is sent to report an use after free in mem_cgroup_iter()
after
merging commit be2657752e9e ("mm: memcg: fix use after free in
mem_cgroup_iter()").

I work with android kernel tree (4.9 & 4.14), and commit be2657752e9e
("mm: memcg: fix use after free in mem_cgroup_iter()") has been merged
to
the trees.  However, I can still observe use after free issues addressed
in the commit be2657752e9e.  (on low-end devices, a few times this
month)

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

0xdbbc2a00:     0xdbbc2e00      0x00000000      0xdbbc2800
0x00000100
0xdbbc2a10:     0x00000200      0x78787878      0x00026218
0x00000000
0xdbbc2a20:     0xdcad6000      0x00000001      0x78787800
0x00000000
0xdbbc2a30:     0x78780000      0x00000000      0x0068fb84
0x78787878
0xdbbc2a40:     0x78787878      0x78787878      0x78787878
0xe3fa5cc0
0xdbbc2a50:     0x78787878      0x78787878      0x00000000
0x00000000
0xdbbc2a60:     0x00000000      0x00000000      0x00000000
0x00000000
0xdbbc2a70:     0x00000000      0x00000000      0x00000000
0x00000000
0xdbbc2a80:     0x00000000      0x00000000      0x00000000
0x00000000
0xdbbc2a90:     0x00000001      0x00000000      0x00000000
0x00100000
0xdbbc2aa0:     0x00000001      0xdbbc2ac8      0x00000000
0x00000000
0xdbbc2ab0:     0x00000000      0x00000000      0x00000000
0x00000000
0xdbbc2ac0:     0x00000000      0x00000000      0xe5b02618
0x00001000
0xdbbc2ad0:     0x00000000      0x78787878      0x78787878
0x78787878
0xdbbc2ae0:     0x78787878      0x78787878      0x78787878
0x78787878
0xdbbc2af0:     0x78787878      0x78787878      0x78787878
0x78787878
0xdbbc2b00:     0x78787878      0x78787878      0x78787878
0x78787878
0xdbbc2b10:     0x78787878      0x78787878      0x78787878
0x78787878
0xdbbc2b20:     0x78787878      0x78787878      0x78787878
0x78787878
0xdbbc2b30:     0x78787878      0x78787878      0x78787878
0x78787878
0xdbbc2b40:     0x78787878      0x78787878      0x78787878
0x78787878
0xdbbc2b50:     0x78787878      0x78787878      0x78787878
0x78787878
0xdbbc2b60:     0x78787878      0x78787878      0x78787878
0x78787878
0xdbbc2b70:     0x78787878      0x78787878      0x78787878
0x78787878
0xdbbc2b80:     0x78787878      0x78787878      0x00000000
0x78787878
0xdbbc2b90:     0x78787878      0x78787878      0x78787878
0x78787878
0xdbbc2ba0:     0x78787878      0x78787878      0x78787878
0x78787878

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

To avoid this, we should also invalidate root_mem_cgroup.nodeinfo.iter
in
invalidate_reclaim_iterators().

[cai@lca.pw: fix -Wparentheses compilation warning]
  Link:
http://lkml.kernel.org/r/1564580753-17531-1-git-send-email-cai@lca.pw
Link:
http://lkml.kernel.org/r/20190730015729.4406-1-miles.chen@mediatek.com
Fixes: 5ac8fb31ad2e ("mm: memcontrol: convert reclaim iterator to simple
css refcounting")
Signed-off-by: Miles Chen <miles.chen@mediatek.com>
Signed-off-by: Qian Cai <cai@lca.pw>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 mm/memcontrol.c | 39 +++++++++++++++++++++++++++++----------
 1 file changed, 29 insertions(+), 10 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 661f046ad318..6bbe556b2155 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -871,26 +871,45 @@ void mem_cgroup_iter_break(struct mem_cgroup
*root,
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
 
-	while ((memcg = parent_mem_cgroup(memcg))) {
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
+	} while ((memcg = parent_mem_cgroup(memcg)));
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
 /*
  * Iteration constructs for visiting all cgroups (under a tree).  If
  * loops are exited prematurely (break), mem_cgroup_iter_break() must
-- 
2.18.0



