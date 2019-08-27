Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D0F29E0E0
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 10:10:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733061AbfH0IGp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 04:06:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:36764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732635AbfH0IGo (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Aug 2019 04:06:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 01301206BF;
        Tue, 27 Aug 2019 08:06:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566893203;
        bh=3xvGz0//4v6/Aw45avb0487WgKXitcKzbVzpdel9nek=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MsXaUbJLZJgDox64qlBS5KysZ8To2Qjmr39J1DR9Mtwo3gSLBdXDsDO54fDyoQF1D
         X/jsxcMaCafoEsjekGsVc5+jT8RLcCsP+e9jMAyi4Ey3Ti4TYcusljo+CBybwbg2wt
         TmZbTn02LJ/zBkE1W46FwPON+yZfLG4QWgbiQbUg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Roman Gushchin <guro@fb.com>,
        Michal Hocko <mhocko@suse.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Vladimir Davydov <vdavydov.dev@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.2 149/162] mm: memcontrol: flush percpu vmevents before releasing memcg
Date:   Tue, 27 Aug 2019 09:51:17 +0200
Message-Id: <20190827072743.933362060@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190827072738.093683223@linuxfoundation.org>
References: <20190827072738.093683223@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roman Gushchin <guro@fb.com>

commit bb65f89b7d3d305c14951f49860711fbcae70692 upstream.

Similar to vmstats, percpu caching of local vmevents leads to an
accumulation of errors on non-leaf levels.  This happens because some
leftovers may remain in percpu caches, so that they are never propagated
up by the cgroup tree and just disappear into nonexistence with on
releasing of the memory cgroup.

To fix this issue let's accumulate and propagate percpu vmevents values
before releasing the memory cgroup similar to what we're doing with
vmstats.

Since on cpu hotplug we do flush percpu vmstats anyway, we can iterate
only over online cpus.

Link: http://lkml.kernel.org/r/20190819202338.363363-4-guro@fb.com
Fixes: 42a300353577 ("mm: memcontrol: fix recursive statistics correctness & scalabilty")
Signed-off-by: Roman Gushchin <guro@fb.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/memcontrol.c |   22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3185,6 +3185,25 @@ static void memcg_flush_percpu_vmstats(s
 	}
 }
 
+static void memcg_flush_percpu_vmevents(struct mem_cgroup *memcg)
+{
+	unsigned long events[NR_VM_EVENT_ITEMS];
+	struct mem_cgroup *mi;
+	int cpu, i;
+
+	for (i = 0; i < NR_VM_EVENT_ITEMS; i++)
+		events[i] = 0;
+
+	for_each_online_cpu(cpu)
+		for (i = 0; i < NR_VM_EVENT_ITEMS; i++)
+			events[i] += raw_cpu_read(
+				memcg->vmstats_percpu->events[i]);
+
+	for (mi = memcg; mi; mi = parent_mem_cgroup(mi))
+		for (i = 0; i < NR_VM_EVENT_ITEMS; i++)
+			atomic_long_add(events[i], &mi->vmevents[i]);
+}
+
 #ifdef CONFIG_MEMCG_KMEM
 static int memcg_online_kmem(struct mem_cgroup *memcg)
 {
@@ -4587,10 +4606,11 @@ static void __mem_cgroup_free(struct mem
 	int node;
 
 	/*
-	 * Flush percpu vmstats to guarantee the value correctness
+	 * Flush percpu vmstats and vmevents to guarantee the value correctness
 	 * on parent's and all ancestor levels.
 	 */
 	memcg_flush_percpu_vmstats(memcg);
+	memcg_flush_percpu_vmevents(memcg);
 	for_each_node(node)
 		free_mem_cgroup_per_node_info(memcg, node);
 	free_percpu(memcg->vmstats_percpu);


