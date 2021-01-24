Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E5C5301993
	for <lists+stable@lfdr.de>; Sun, 24 Jan 2021 06:02:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725788AbhAXFCH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 24 Jan 2021 00:02:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:46946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725803AbhAXFBx (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 24 Jan 2021 00:01:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 084F522CA1;
        Sun, 24 Jan 2021 05:01:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1611464472;
        bh=FkiLU/WmDYLQY4MiLVnp0Ktv+tyu/HSt87z34o/Qym0=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=D3aqysaWHqmWFFrfmqT4KTB6QWuftjORv1Togx/DYzLquQkHKJ+lTx4n/0UO6ASbr
         6THdUdLHSDsHDn4Jnk1WVYoJU/+eLEasaFNiZlQ3JpEl8APTEJWiG7GnxK9lwVBVMF
         K6V5nUu56qrh4gm7BJX9oDu2EmsR7FLSCbKomWCQ=
Date:   Sat, 23 Jan 2021 21:01:11 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, guro@fb.com, hannes@cmpxchg.org,
        linux-mm@kvack.org, mhocko@kernel.org, mm-commits@vger.kernel.org,
        shakeelb@google.com, shy828301@gmail.com, songmuchun@bytedance.com,
        stable@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 04/19] mm: memcg: fix memcg file_dirty numa stat
Message-ID: <20210124050111.gKSNEIDmu%akpm@linux-foundation.org>
In-Reply-To: <20210123210029.a7c704d0cab204683e41ad10@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
