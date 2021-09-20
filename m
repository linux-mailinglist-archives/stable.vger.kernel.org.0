Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F04334122B2
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:15:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358436AbhITSQ6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:16:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:35786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1376728AbhITSOW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:14:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B930D60EB2;
        Mon, 20 Sep 2021 17:21:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158497;
        bh=YcGaJkAlIlcC2i4SObD2N6Q3x/v2GSFf6fGkp3Z1bPQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rjxZ0/mwRb0vgMHHkurcyiBZBZLmz5tk2tmzh0ejpyOTlonJmeKHDxTRbMUFB2JM9
         23uR5pqhBIJPtGEDrg+npginaD/U5e9w447DR2eAahfc3thynZeYlMd7pYAM8J+1H1
         7xUaz7/PaZkKcvJT8VcGnt3DVjwjc+o7g6ozjK8s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rik van Riel <riel@surriel.com>,
        Roman Gushchin <guro@fb.com>, Michal Hocko <mhocko@suse.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Chris Down <chris@chrisdown.name>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.4 182/260] mm,vmscan: fix divide by zero in get_scan_count
Date:   Mon, 20 Sep 2021 18:43:20 +0200
Message-Id: <20210920163937.302237520@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163931.123590023@linuxfoundation.org>
References: <20210920163931.123590023@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rik van Riel <riel@surriel.com>

commit 32d4f4b782bb8f0ceb78c6b5dc46eb577ae25bf7 upstream.

Commit f56ce412a59d ("mm: memcontrol: fix occasional OOMs due to
proportional memory.low reclaim") introduced a divide by zero corner
case when oomd is being used in combination with cgroup memory.low
protection.

When oomd decides to kill a cgroup, it will force the cgroup memory to
be reclaimed after killing the tasks, by writing to the memory.max file
for that cgroup, forcing the remaining page cache and reclaimable slab
to be reclaimed down to zero.

Previously, on cgroups with some memory.low protection that would result
in the memory being reclaimed down to the memory.low limit, or likely
not at all, having the page cache reclaimed asynchronously later.

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
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2513,7 +2513,7 @@ out:
 			cgroup_size = max(cgroup_size, protection);
 
 			scan = lruvec_size - lruvec_size * protection /
-				cgroup_size;
+				(cgroup_size + 1);
 
 			/*
 			 * Minimally target SWAP_CLUSTER_MAX pages to keep


