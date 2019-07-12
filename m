Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57362675F5
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 22:36:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727561AbfGLUgf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 16:36:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:56102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727118AbfGLUgf (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Jul 2019 16:36:35 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9E7DD217D4;
        Fri, 12 Jul 2019 20:36:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562963794;
        bh=vJU5FAH4tG8BCiKiIzzL/ErKvVmGRqLWGMrIucnfuNc=;
        h=Date:From:To:Subject:From;
        b=M6jYs+2B0kA0aLhNTI1ev9EsQGGQ35ycdSc8D3nwo4xXaEk4hJSeUCjLge1pNz3gm
         Z069FpsN7LR0q+vVqUWRMbiFAOLvUJGFxSw/D2B6ndxkp30JtHE31fF4lHo5xzcHv6
         vg6gGUG0UNr5IqYAWWwzWBt13V6weZs5oT4lorpo=
Date:   Fri, 12 Jul 2019 13:36:34 -0700
From:   akpm@linux-foundation.org
To:     hannes@cmpxchg.org, laoar.shao@gmail.com, mhocko@suse.com,
        mm-commits@vger.kernel.org, shakeelb@google.com,
        shaoyafang@didiglobal.com, stable@vger.kernel.org
Subject:  [merged]
 mm-memcontrol-fix-wrong-statistics-in-memorystat.patch removed from -mm
 tree
Message-ID: <20190712203634.wogAkdpIe%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/memcontrol: fix wrong statistics in memory.stat
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-fix-wrong-statistics-in-memorystat.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yafang Shao <laoar.shao@gmail.com>
Subject: mm/memcontrol: fix wrong statistics in memory.stat

When we calculate total statistics for memcg1_stats and memcg1_events, we
use the the index 'i' in the for loop as the events index.  Actually we
should use memcg1_stats[i] and memcg1_events[i] as the events index.

Link: http://lkml.kernel.org/r/1562116978-19539-1-git-send-email-laoar.shao@gmail.com
Fixes: 42a300353577 ("mm: memcontrol: fix recursive statistics correctness & scalabilty").
Signed-off-by: Yafang Shao <laoar.shao@gmail.com
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Yafang Shao <shaoyafang@didiglobal.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/memcontrol.c~mm-memcontrol-fix-wrong-statistics-in-memorystat
+++ a/mm/memcontrol.c
@@ -3523,12 +3523,13 @@ static int memcg_stat_show(struct seq_fi
 		if (memcg1_stats[i] == MEMCG_SWAP && !do_memsw_account())
 			continue;
 		seq_printf(m, "total_%s %llu\n", memcg1_stat_names[i],
-			   (u64)memcg_page_state(memcg, i) * PAGE_SIZE);
+			   (u64)memcg_page_state(memcg, memcg1_stats[i]) *
+			   PAGE_SIZE);
 	}
 
 	for (i = 0; i < ARRAY_SIZE(memcg1_events); i++)
 		seq_printf(m, "total_%s %llu\n", memcg1_event_names[i],
-			   (u64)memcg_events(memcg, i));
+			   (u64)memcg_events(memcg, memcg1_events[i]));
 
 	for (i = 0; i < NR_LRU_LISTS; i++)
 		seq_printf(m, "total_%s %llu\n", mem_cgroup_lru_names[i],
_

Patches currently in -mm which might be from laoar.shao@gmail.com are

mm-vmscan-expose-cgroup_ino-for-memcg-reclaim-tracepoints.patch
mm-memcontrol-keep-local-vm-counters-in-sync-with-the-hierarchical-ones.patch
mm-vmscan-add-a-new-member-reclaim_state-in-struct-shrink_control.patch
mm-vmscan-add-a-new-member-reclaim_state-in-struct-shrink_control-fix.patch
mm-vmscan-calculate-reclaimed-slab-caches-in-all-reclaim-paths.patch

