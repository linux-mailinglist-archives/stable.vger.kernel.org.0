Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35CE9302F38
	for <lists+stable@lfdr.de>; Mon, 25 Jan 2021 23:42:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732149AbhAYWlL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 17:41:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:35492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732888AbhAYVfi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 16:35:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 90D362100A;
        Mon, 25 Jan 2021 21:34:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1611610497;
        bh=aPSMxaWNjcVsS+ARGA7XSskULWNbU22EwqzceQmQ0ys=;
        h=Date:From:To:Subject:From;
        b=QctdVjkyo070QsCRGx4P314K1u7msJs3s+sGrJzN0jWAk6uFeutS7PaTxNf65j3xh
         yGZcsPiZbsBIPI6tFnwr98T7PRmUJtSIGVjsAqvXhrD34cGIk943z4dQxy+NXlDgMJ
         oEd+44Nu6d1nKL+Jb9LAA6aTlL9lJ9SgT33EEiXk=
Date:   Mon, 25 Jan 2021 13:34:57 -0800
From:   akpm@linux-foundation.org
To:     guro@fb.com, hannes@cmpxchg.org, mhocko@kernel.org,
        mm-commits@vger.kernel.org, shakeelb@google.com,
        shy828301@gmail.com, songmuchun@bytedance.com,
        stable@vger.kernel.org
Subject:  [merged] mm-memcg-fix-memcg-file_dirty-numa-stat.patch
 removed from -mm tree
Message-ID: <20210125213457.pO-MRDr3i%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm: memcg: fix memcg file_dirty numa stat
has been removed from the -mm tree.  Its filename was
     mm-memcg-fix-memcg-file_dirty-numa-stat.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Shakeel Butt <shakeelb@google.com>
Subject: mm: memcg: fix memcg file_dirty numa stat

The kernel updates the per-node NR_FILE_DIRTY stats on page migration but
not the memcg numa stats.  That was not an issue until recently the commit
5f9a4f4a7096 ("mm: memcontrol: add the missing numa_stat interface for
cgroup v2") exposed numa stats for the memcg.  So fix the file_dirty
per-memcg numa stat.

Link: https://lkml.kernel.org/r/20210108155813.2914586-1-shakeelb@google.com
Fixes: 5f9a4f4a7096 ("mm: memcontrol: add the missing numa_stat interface for cgroup v2")
Signed-off-by: Shakeel Butt <shakeelb@google.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Yang Shi <shy828301@gmail.com>
Reviewed-by: Roman Gushchin <guro@fb.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/migrate.c~mm-memcg-fix-memcg-file_dirty-numa-stat
+++ a/mm/migrate.c
@@ -500,9 +500,9 @@ int migrate_page_move_mapping(struct add
 			__inc_lruvec_state(new_lruvec, NR_SHMEM);
 		}
 		if (dirty && mapping_can_writeback(mapping)) {
-			__dec_node_state(oldzone->zone_pgdat, NR_FILE_DIRTY);
+			__dec_lruvec_state(old_lruvec, NR_FILE_DIRTY);
 			__dec_zone_state(oldzone, NR_ZONE_WRITE_PENDING);
-			__inc_node_state(newzone->zone_pgdat, NR_FILE_DIRTY);
+			__inc_lruvec_state(new_lruvec, NR_FILE_DIRTY);
 			__inc_zone_state(newzone, NR_ZONE_WRITE_PENDING);
 		}
 	}
_

Patches currently in -mm which might be from shakeelb@google.com are

mm-memcg-add-swapcache-stat-for-memcg-v2.patch

