Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D9FB5FE04
	for <lists+stable@lfdr.de>; Thu,  4 Jul 2019 23:02:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727452AbfGDVCY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Jul 2019 17:02:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:49506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726038AbfGDVCY (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Jul 2019 17:02:24 -0400
Received: from localhost.localdomain (c-73-223-200-170.hsd1.ca.comcast.net [73.223.200.170])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BD3092083B;
        Thu,  4 Jul 2019 21:02:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562274143;
        bh=yt8qHZPrK152bgyBACrAUdI567ylE6jX60v0AVkX5HE=;
        h=Date:From:To:Subject:From;
        b=Y3cyEY1HY+AEC8sBPrfie4GdT9dt61bhZ+9r+zuM4rciQgZFwVU9U2YYAFWsm7pr3
         ydFP4rADFimhj3SPCL8FwcaEdBcMvKxgrYJ/kwjpv6KFAk6PyAtklcxgijlykWoc7P
         p9iEy1ZtA8ZcMmJCfQdix26Ht1JAXLg5nZvueg3w=
Date:   Thu, 04 Jul 2019 14:02:22 -0700
From:   akpm@linux-foundation.org
To:     hannes@cmpxchg.org, laoar.shao@gmail.com, mhocko@suse.com,
        mm-commits@vger.kernel.org, shakeelb@google.com,
        shaoyafang@didiglobal.com, stable@vger.kernel.org
Subject:  + mm-memcontrol-fix-wrong-statistics-in-memorystat.patch
 added to -mm tree
Message-ID: <20190704210222.D8psCcsKb%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/memcontrol: fix wrong statistics in memory.stat
has been added to the -mm tree.  Its filename is
     mm-memcontrol-fix-wrong-statistics-in-memorystat.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-fix-wrong-statistics-in-memorystat.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-fix-wrong-statistics-in-memorystat.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yafang Shao <laoar.shao@gmail.com>
Subject: mm/memcontrol: fix wrong statistics in memory.stat

When we calculate total statistics for memcg1_stats and memcg1_events, we
use the the index 'i' in the for loop as the events index.  Actually we
should use memcg1_stats[i] and memcg1_events[i] as the events index.

Link: http://lkml.kernel.org/r/1562116978-19539-1-git-send-email-laoar.shao@gmail.com
Fixes: 42a300353577 ("mm: memcontrol: fix recursive statistics correctness & scalabilty").
Cc: Shakeel Butt <shakeelb@google.com>
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
@@ -3530,12 +3530,13 @@ static int memcg_stat_show(struct seq_fi
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

mm-memcontrol-fix-wrong-statistics-in-memorystat.patch
mm-vmscan-expose-cgroup_ino-for-memcg-reclaim-tracepoints.patch
mm-vmscan-add-a-new-member-reclaim_state-in-struct-shrink_control.patch
mm-vmscan-add-a-new-member-reclaim_state-in-struct-shrink_control-fix.patch
mm-vmscan-calculate-reclaimed-slab-caches-in-all-reclaim-paths.patch

