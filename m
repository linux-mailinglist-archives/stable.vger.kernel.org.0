Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C205405E92
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 23:06:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348501AbhIIVHd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 17:07:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:57260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348301AbhIIVHV (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 17:07:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 96B9A6109F;
        Thu,  9 Sep 2021 21:06:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631221571;
        bh=82C2QbFYSOZ/IYcjkBxd1eEpaUudBiDxc7r17NPP32U=;
        h=Date:From:To:Subject:From;
        b=kqrdWIMEwGo0Y5c5u/9CvqW+6j76cK2E8kIclhy8RjyJv2sBwoqfXubc/JuearEUo
         Q3WSgDRac1OsgNscpVRrkEoZlhNdUf/Nef8NR7kGrcrDRspZkmAoBv8d9Ir+kvgmr6
         JdrrPSaGIJfkYSyISZRshn07Vttxi/w9Sh+5ToT4=
Date:   Thu, 09 Sep 2021 14:06:11 -0700
From:   akpm@linux-foundation.org
To:     chris@chrisdown.name, guro@fb.com, hannes@cmpxchg.org,
        mhocko@suse.com, mm-commits@vger.kernel.org, riel@surriel.com,
        stable@vger.kernel.org
Subject:  [merged]
 mmvmscan-fix-divide-by-zero-in-get_scan_count.patch removed from -mm tree
Message-ID: <20210909210611.MPmhnhuu6%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm,vmscan: fix divide by zero in get_scan_count
has been removed from the -mm tree.  Its filename was
     mmvmscan-fix-divide-by-zero-in-get_scan_count.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rik van Riel <riel@surriel.com>
Subject: mm,vmscan: fix divide by zero in get_scan_count

Changeset f56ce412a59d ("mm: memcontrol: fix occasional OOMs due to
proportional memory.low reclaim") introduced a divide by zero corner case
when oomd is being used in combination with cgroup memory.low protection.

When oomd decides to kill a cgroup, it will force the cgroup memory to be
reclaimed after killing the tasks, by writing to the memory.max file for
that cgroup, forcing the remaining page cache and reclaimable slab to be
reclaimed down to zero.

Previously, on cgroups with some memory.low protection that would result
in the memory being reclaimed down to the memory.low limit, or likely not
at all, having the page cache reclaimed asynchronously later.

With f56ce412a59d the oomd write to memory.max tries to reclaim all the
way down to zero, which may race with another reclaimer, to the point of
ending up with the divide by zero below.

This patch implements the obvious fix.

Link: https://lkml.kernel.org/r/20210826220149.058089c6@imladris.surriel.com
Fixes: f56ce412a59d ("mm: memcontrol: fix occasional OOMs due to proportional memory.low reclaim")
Signed-off-by: Rik van Riel <riel@surriel.com>
Acked-by: Roman Gushchin <guro@fb.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Chris Down <chris@chrisdown.name>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmscan.c~mmvmscan-fix-divide-by-zero-in-get_scan_count
+++ a/mm/vmscan.c
@@ -2715,7 +2715,7 @@ out:
 			cgroup_size = max(cgroup_size, protection);
 
 			scan = lruvec_size - lruvec_size * protection /
-				cgroup_size;
+				(cgroup_size + 1);
 
 			/*
 			 * Minimally target SWAP_CLUSTER_MAX pages to keep
_

Patches currently in -mm which might be from riel@surriel.com are


