Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3EE4A71C2
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 19:35:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728113AbfICRf5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 13:35:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:55208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726973AbfICRf4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Sep 2019 13:35:56 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A241B22D6D;
        Tue,  3 Sep 2019 17:35:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567532155;
        bh=dw+hhKAW5tQSyo+nfNeAdkzgRD3T65p0mOdmv6ZwBpM=;
        h=Date:From:To:Subject:From;
        b=FQKHjqi/Zc3BGRNFbKoYY8dB0G22tNtG9egKqxLhPo9S8d5/6aieUBRVaA1SzbWOg
         U6RjSmLwRr3uHeMQZ8XTOpTByTYFsJjT7NkMlySB9LOv4jaTldw+UjUonYP17ff7XC
         1AFLHcqaqHbm0gfodu48gOjOHusopO8KWkCQ24hw=
Date:   Tue, 03 Sep 2019 10:35:55 -0700
From:   akpm@linux-foundation.org
To:     guro@fb.com, hannes@cmpxchg.org, mhocko@suse.com,
        mm-commits@vger.kernel.org, shakeelb@google.com,
        stable@vger.kernel.org, vdavydov.dev@gmail.com
Subject:  [merged]
 mm-memcontrol-fix-percpu-vmstats-and-vmevents-flush.patch removed from -mm
 tree
Message-ID: <20190903173555.jZKvr7DXt%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: fix percpu vmstats and vmevents flush
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-fix-percpu-vmstats-and-vmevents-flush.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Shakeel Butt <shakeelb@google.com>
Subject: mm: memcontrol: fix percpu vmstats and vmevents flush

Instead of using raw_cpu_read() use per_cpu() to read the actual data of
the corresponding cpu otherwise we will be reading the data of the current
cpu for the number of online CPUs.

Link: http://lkml.kernel.org/r/20190829203110.129263-1-shakeelb@google.com
Fixes: bb65f89b7d3d ("mm: memcontrol: flush percpu vmevents before releasing memcg")
Fixes: c350a99ea2b1 ("mm: memcontrol: flush percpu vmstats before releasing memcg")
Signed-off-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Roman Gushchin <guro@fb.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/mm/memcontrol.c~mm-memcontrol-fix-percpu-vmstats-and-vmevents-flush
+++ a/mm/memcontrol.c
@@ -3278,7 +3278,7 @@ static void memcg_flush_percpu_vmstats(s
 
 	for_each_online_cpu(cpu)
 		for (i = min_idx; i < max_idx; i++)
-			stat[i] += raw_cpu_read(memcg->vmstats_percpu->stat[i]);
+			stat[i] += per_cpu(memcg->vmstats_percpu->stat[i], cpu);
 
 	for (mi = memcg; mi; mi = parent_mem_cgroup(mi))
 		for (i = min_idx; i < max_idx; i++)
@@ -3296,8 +3296,8 @@ static void memcg_flush_percpu_vmstats(s
 
 		for_each_online_cpu(cpu)
 			for (i = min_idx; i < max_idx; i++)
-				stat[i] += raw_cpu_read(
-					pn->lruvec_stat_cpu->count[i]);
+				stat[i] += per_cpu(
+					pn->lruvec_stat_cpu->count[i], cpu);
 
 		for (pi = pn; pi; pi = parent_nodeinfo(pi, node))
 			for (i = min_idx; i < max_idx; i++)
@@ -3316,8 +3316,8 @@ static void memcg_flush_percpu_vmevents(
 
 	for_each_online_cpu(cpu)
 		for (i = 0; i < NR_VM_EVENT_ITEMS; i++)
-			events[i] += raw_cpu_read(
-				memcg->vmstats_percpu->events[i]);
+			events[i] += per_cpu(memcg->vmstats_percpu->events[i],
+					     cpu);
 
 	for (mi = memcg; mi; mi = parent_mem_cgroup(mi))
 		for (i = 0; i < NR_VM_EVENT_ITEMS; i++)
_

Patches currently in -mm which might be from shakeelb@google.com are


