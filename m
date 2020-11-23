Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67F1E2C0A31
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:19:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732632AbgKWMmS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:42:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:53844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732575AbgKWMk6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:40:58 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 31C14208FE;
        Mon, 23 Nov 2020 12:40:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135258;
        bh=vcHKR/V4bgCOZFiB5PWRCL90ggMqMg4rXt+HijycRJo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kmjITSNH+dpzw2wj5ejS6SUb6BPnzu30BUUIK2j2T/n+rZwqb/MoB9uSiEmiD1nsm
         OYq/NX4+4d5RpKTJZ4tRPJtpT+sHWS9x/mseyemKd21GIJVSMu8DQWEmQlRmitCb/Z
         +7wGYAXM8ek83caSKINlM4aW04X2PxwRV0hggp7k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Muchun Song <songmuchun@bytedance.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Shakeel Butt <shakeelb@google.com>,
        Roman Gushchin <guro@fb.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        David Rientjes <rientjes@google.com>,
        Michal Hocko <mhocko@kernel.org>,
        Vladimir Davydov <vdavydov.dev@gmail.com>,
        Christopher Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Yafang Shao <laoar.shao@gmail.com>,
        Chris Down <chris@chrisdown.name>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.4 155/158] mm: memcg/slab: fix root memcg vmstats
Date:   Mon, 23 Nov 2020 13:23:03 +0100
Message-Id: <20201123121827.411498013@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121819.943135899@linuxfoundation.org>
References: <20201123121819.943135899@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Muchun Song <songmuchun@bytedance.com>

commit 8faeb1ffd79593c9cd8a2a80ecdda371e3b826cb upstream.

If we reparent the slab objects to the root memcg, when we free the slab
object, we need to update the per-memcg vmstats to keep it correct for
the root memcg.  Now this at least affects the vmstat of
NR_KERNEL_STACK_KB for !CONFIG_VMAP_STACK when the thread stack size is
smaller than the PAGE_SIZE.

David said:
 "I assume that without this fix that the root memcg's vmstat would
  always be inflated if we reparented"

Fixes: ec9f02384f60 ("mm: workingset: fix vmstat counters for shadow nodes")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Roman Gushchin <guro@fb.com>
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
Link: https://lkml.kernel.org/r/20201110031015.15715-1-songmuchun@bytedance.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/memcontrol.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -776,8 +776,13 @@ void __mod_lruvec_slab_state(void *p, en
 	rcu_read_lock();
 	memcg = memcg_from_slab_page(page);
 
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
 		lruvec = mem_cgroup_lruvec(pgdat, memcg);


