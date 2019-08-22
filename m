Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8975C99D18
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:41:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404222AbfHVRYb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:24:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:46036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404047AbfHVRYa (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:24:30 -0400
Received: from localhost (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0D86D2341A;
        Thu, 22 Aug 2019 17:24:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566494670;
        bh=zMjLqjHkQP6YEj55vt24IX18hBz9ajdl1eYp8pKxUho=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O+Ss3Z93vSQ9dfd/W94MLk71BLz3KIC17/x2Xjn+LsZVtlnKa5fdNEhVCBus5WSM8
         bDwp07rxJ0baJTYdAbVhtc/gzbxJ5nKkxJebvE0LHy+asBLKVTUSvsjL0hXsREuFKQ
         oBinirwzs49dKC6rKYV8L+gYsNoRj9SejBMreMr8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miles Chen <miles.chen@mediatek.com>,
        Qian Cai <cai@lca.pw>, Michal Hocko <mhocko@suse.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Vladimir Davydov <vdavydov.dev@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.14 04/71] mm/memcontrol.c: fix use after free in mem_cgroup_iter()
Date:   Thu, 22 Aug 2019 10:18:39 -0700
Message-Id: <20190822171726.481743286@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190822171726.131957995@linuxfoundation.org>
References: <20190822171726.131957995@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miles Chen <miles.chen@mediatek.com>

commit 54a83d6bcbf8f4700013766b974bf9190d40b689 upstream.

This patch is sent to report an use after free in mem_cgroup_iter()
after merging commit be2657752e9e ("mm: memcg: fix use after free in
mem_cgroup_iter()").

I work with android kernel tree (4.9 & 4.14), and commit be2657752e9e
("mm: memcg: fix use after free in mem_cgroup_iter()") has been merged
to the trees.  However, I can still observe use after free issues
addressed in the commit be2657752e9e.  (on low-end devices, a few times
this month)

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
  +     /* poison memcg before freeing it */
  +     memset(memcg, 0x78, sizeof(struct mem_cgroup));
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

To avoid this, we should also invalidate root_mem_cgroup.nodeinfo.iter
in invalidate_reclaim_iterators().

[cai@lca.pw: fix -Wparentheses compilation warning]
  Link: http://lkml.kernel.org/r/1564580753-17531-1-git-send-email-cai@lca.pw
Link: http://lkml.kernel.org/r/20190730015729.4406-1-miles.chen@mediatek.com
Fixes: 5ac8fb31ad2e ("mm: memcontrol: convert reclaim iterator to simple css refcounting")
Signed-off-by: Miles Chen <miles.chen@mediatek.com>
Signed-off-by: Qian Cai <cai@lca.pw>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 mm/memcontrol.c |   39 +++++++++++++++++++++++++++++----------
 1 file changed, 29 insertions(+), 10 deletions(-)

--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -871,26 +871,45 @@ void mem_cgroup_iter_break(struct mem_cg
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


