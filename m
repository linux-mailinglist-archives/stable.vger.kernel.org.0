Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BCF12EFC36
	for <lists+stable@lfdr.de>; Sat,  9 Jan 2021 01:32:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725844AbhAIAcA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Jan 2021 19:32:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:57220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725817AbhAIAcA (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Jan 2021 19:32:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 54A9023A79;
        Sat,  9 Jan 2021 00:31:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1610152279;
        bh=U/efYcnH/eEvynzRHOVxEFCTc0EDiWWRL7rlqn22YNo=;
        h=Date:From:To:Subject:From;
        b=mBlm1+KF2ISr23RE9auFwF6Wm9Adq8hV6nZ1Oaw0zJ5ZScUvURDQmmydsFhNlPSJZ
         eTaNfH52gnbHVcU5rXnFf36F/qKc/vOPZMaFv/W441Ojgh0fhT/ZW+Xd79NSS+Oj1I
         6aYTqkLnbQnnch4271O4oolnBRQvnY2TQXP+dxLo=
Date:   Fri, 08 Jan 2021 16:31:18 -0800
From:   akpm@linux-foundation.org
To:     guro@fb.com, hannes@cmpxchg.org, mhocko@kernel.org,
        mm-commits@vger.kernel.org, shakeelb@google.com,
        shy828301@gmail.com, songmuchun@bytedance.com,
        stable@vger.kernel.org
Subject:  + mm-memcg-fix-memcg-file_dirty-numa-stat.patch added to
 -mm tree
Message-ID: <20210109003118.n6j35Rw7q%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm: memcg: fix memcg file_dirty numa stat
has been added to the -mm tree.  Its filename is
     mm-memcg-fix-memcg-file_dirty-numa-stat.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memcg-fix-memcg-file_dirty-numa-stat.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memcg-fix-memcg-file_dirty-numa-stat.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-memcg-fix-memcg-file_dirty-numa-stat.patch
mm-fix-numa-stats-for-thp-migration.patch
mm-memcg-add-swapcache-stat-for-memcg-v2.patch

