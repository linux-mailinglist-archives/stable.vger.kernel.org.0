Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A975404290
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 03:10:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348963AbhIIBLS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Sep 2021 21:11:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:60488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232144AbhIIBLR (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 8 Sep 2021 21:11:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0A4FD6115B;
        Thu,  9 Sep 2021 01:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631149809;
        bh=jX/+qe+mshe9NQpY4nv0hiSuyosD7KUERle9R5zkFIM=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=RLch+0XeeuFu40/c2xQWm/8lmGUT5b8L93bgKIn7LyGAgi0pAxqR3e7sQgy87s8xZ
         XIbE+VfeQgzoauSJs4syOtBqif3uY/SVedTQ5hV/W8SBQZjNfCgQYoL/yCER66P2yP
         uiPiNHfPuBFgnRVmNEK4pXJYYBiG3PLcGX+eeltg=
Date:   Wed, 08 Sep 2021 18:10:08 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, chris@chrisdown.name, guro@fb.com,
        hannes@cmpxchg.org, linux-mm@kvack.org, mhocko@suse.com,
        mm-commits@vger.kernel.org, riel@surriel.com,
        stable@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 3/8] mm,vmscan: fix divide by zero in
 get_scan_count
Message-ID: <20210909011008.OFzJhcuDA%akpm@linux-foundation.org>
In-Reply-To: <20210908180859.d523d4bb4ad8eec11c61500d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
