Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3DE43FE798
	for <lists+stable@lfdr.de>; Thu,  2 Sep 2021 04:22:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233122AbhIBCXR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 22:23:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:39034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232666AbhIBCXQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 22:23:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D4CAB60F91;
        Thu,  2 Sep 2021 02:22:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630549339;
        bh=lC59UuP1uX1V0XEOkIEDjdHyY5dfujfBvEd2WvmYgts=;
        h=Date:From:To:Subject:From;
        b=pwOI6OByCziTayXJKmu86Nrti3GdHaBKV4V4ZpXvJkyz5nncHwstNuJOJtwiif7wx
         Om/0u6zZiiRe/LL+jASKnNBH40ZsaXiqtv4tmb+mp6GudDdMQYg/PnZBwp+divqXfk
         yNWXl2tBEJXcarHyRh4m0tSqZNyvCjD8DUWT+q3o=
Date:   Wed, 01 Sep 2021 19:22:18 -0700
From:   akpm@linux-foundation.org
To:     chris@chrisdown.name, guro@fb.com, hannes@cmpxchg.org,
        mhocko@suse.com, mm-commits@vger.kernel.org, riel@surriel.com,
        stable@vger.kernel.org
Subject:  + mmvmscan-fix-divide-by-zero-in-get_scan_count.patch
 added to -mm tree
Message-ID: <20210902022218.d3eY8D0fC%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm,vmscan: fix divide by zero in get_scan_count
has been added to the -mm tree.  Its filename is
     mmvmscan-fix-divide-by-zero-in-get_scan_count.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mmvmscan-fix-divide-by-zero-in-get_scan_count.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mmvmscan-fix-divide-by-zero-in-get_scan_count.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -2592,7 +2592,7 @@ out:
 			cgroup_size = max(cgroup_size, protection);
 
 			scan = lruvec_size - lruvec_size * protection /
-				cgroup_size;
+				(cgroup_size + 1);
 
 			/*
 			 * Minimally target SWAP_CLUSTER_MAX pages to keep
_

Patches currently in -mm which might be from riel@surriel.com are

mmvmscan-fix-divide-by-zero-in-get_scan_count.patch

