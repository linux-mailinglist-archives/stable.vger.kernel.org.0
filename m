Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA399169B52
	for <lists+stable@lfdr.de>; Mon, 24 Feb 2020 01:44:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727187AbgBXAow (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Feb 2020 19:44:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:40052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727151AbgBXAow (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 23 Feb 2020 19:44:52 -0500
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9AA992071C;
        Mon, 24 Feb 2020 00:44:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582505091;
        bh=ftUcGE2ki8CQMvuJXwSfhOk7Z6n2zgFPpeiCt04ONjg=;
        h=Date:From:To:Subject:From;
        b=h30lfurM9+NDUEkcjU6SnjBHUwGuB/dYMeDPnGubEauNxYzeTqDBe2haAa+Ao5HOD
         9ToRtYGAzhHiVsTtGGbU547t3nBgh0x799dsN1QmmPVEXHR271AyrHPfU8tzrmJKwN
         rMfdq/ATTymXb3vCJa8AgAFI7Z+2KBnI2OT9QGtc=
Date:   Sun, 23 Feb 2020 16:44:51 -0800
From:   akpm@linux-foundation.org
To:     guro@fb.com, hannes@cmpxchg.org, ktkhai@virtuozzo.com,
        mhocko@suse.com, mm-commits@vger.kernel.org,
        stable@vger.kernel.org, vdavydov.dev@gmail.com, vvs@virtuozzo.com
Subject:  [merged]
 memcg-lost-css_put-in-memcg_expand_shrinker_maps.patch removed from -mm
 tree
Message-ID: <20200224004451.X_6MoBtQa%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/memcontrol.c: lost css_put in memcg_expand_shrinker_maps()
has been removed from the -mm tree.  Its filename was
     memcg-lost-css_put-in-memcg_expand_shrinker_maps.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vasily Averin <vvs@virtuozzo.com>
Subject: mm/memcontrol.c: lost css_put in memcg_expand_shrinker_maps()

for_each_mem_cgroup() increases css reference counter for memory cgroup
and requires to use mem_cgroup_iter_break() if the walk is cancelled.

Link: http://lkml.kernel.org/r/c98414fb-7e1f-da0f-867a-9340ec4bd30b@virtuozzo.com
Fixes: 0a4465d34028 ("mm, memcg: assign memcg-aware shrinkers bitmap to memcg")
Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
Acked-by: Kirill Tkhai <ktkhai@virtuozzo.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Roman Gushchin <guro@fb.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/memcontrol.c~memcg-lost-css_put-in-memcg_expand_shrinker_maps
+++ a/mm/memcontrol.c
@@ -409,8 +409,10 @@ int memcg_expand_shrinker_maps(int new_i
 		if (mem_cgroup_is_root(memcg))
 			continue;
 		ret = memcg_expand_one_shrinker_map(memcg, size, old_size);
-		if (ret)
+		if (ret) {
+			mem_cgroup_iter_break(NULL, memcg);
 			goto unlock;
+		}
 	}
 unlock:
 	if (!ret)
_

Patches currently in -mm which might be from vvs@virtuozzo.com are


