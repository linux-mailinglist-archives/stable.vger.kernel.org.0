Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11EEE6655B
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 05:52:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729557AbfGLDwN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Jul 2019 23:52:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:59408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728721AbfGLDwN (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Jul 2019 23:52:13 -0400
Received: from localhost.localdomain (c-73-223-200-170.hsd1.ca.comcast.net [73.223.200.170])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0650A20644;
        Fri, 12 Jul 2019 03:52:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562903532;
        bh=LoAAkD77zQcSYHDSL5urkPOKFSrNup8O5E0NKtPp6oo=;
        h=Date:From:To:Subject:From;
        b=KYJl6udmpC2FEL5sKtjltK3f5m3bU7CCXkLjHm1yFsVs3+Qofn94flA4MzMZoPlGy
         N3ssE7otO1zBhdIHamw9M9/kAgaqmfGRPloB+Up92uIvv+RYjamnGVMiw+43Q5UZ0n
         U0+jertgqEt6FN8LIfz4lZPnyY++Mba2iAcUumd0=
Date:   Thu, 11 Jul 2019 20:52:11 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, hannes@cmpxchg.org,
        laoar.shao@gmail.com, mhocko@suse.com, mm-commits@vger.kernel.org,
        shakeelb@google.com, shaoyafang@didiglobal.com,
        stable@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 003/147] mm/memcontrol: fix wrong statistics in
 memory.stat
Message-ID: <20190712035211.YHW54P0M3%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
