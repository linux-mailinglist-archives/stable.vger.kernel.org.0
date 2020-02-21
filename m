Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C064D166E36
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 05:04:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729608AbgBUEET (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Feb 2020 23:04:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:35166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729229AbgBUEET (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Feb 2020 23:04:19 -0500
Received: from X1 (nat-ab2241.sltdut.senawave.net [162.218.216.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 885ED207FD;
        Fri, 21 Feb 2020 04:04:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582257858;
        bh=5mIJtpI46Oskh+IAg3n6Md+XF3NXccWhtLrcbhRYqA4=;
        h=Date:From:To:Subject:From;
        b=0zeqLBsCRyDrz7bAiso+vKVtSmiepm/FEsHxRBYVsxbF1nLT+DrrhW1UDKS45e3XF
         B2g+MqmgHjvCnwe/fSkqEtOE31pBrkEFzh1pOKYCcybhmBGALKAvfE1zCedeLZQ+9n
         3U5rDY/gQH83qQt/nQ9nysgdocwlAetviuhymHV0=
Date:   Thu, 20 Feb 2020 20:04:18 -0800
From:   akpm@linux-foundation.org
To:     vdavydov.dev@gmail.com, stable@vger.kernel.org, mhocko@suse.com,
        ktkhai@virtuozzo.com, hannes@cmpxchg.org, guro@fb.com,
        vvs@virtuozzo.com, akpm@linux-foundation.org,
        mm-commits@vger.kernel.org, linux-mm@kvack.org,
        torvalds@linux-foundation.org
Subject:  [patch 10/15] mm/memcontrol.c: lost css_put in
 memcg_expand_shrinker_maps()
Message-ID: <20200221040418.LZDCt%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
