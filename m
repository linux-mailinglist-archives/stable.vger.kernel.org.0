Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B72E20BDF5
	for <lists+stable@lfdr.de>; Sat, 27 Jun 2020 05:33:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726008AbgF0Ddu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jun 2020 23:33:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:45402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725913AbgF0Ddu (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jun 2020 23:33:50 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8546920857;
        Sat, 27 Jun 2020 03:33:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593228829;
        bh=9aCY+fs856WbCobIwLtg6Sdo5vaEx5w2kdSz5ZqKKaI=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Q5Q/6CvnXTfgEOkWScDUEMhRfkuibLVchJYnUFWPVkE98b85nIVXIVq0jEAVf0Whv
         CCJePwEmu6QCSbVG0eNeguPy5lRcbNSwB0Oa5KPDSK1RrCKqTqqMPrbTOqaN840YhL
         rl88slw/zsQW3n40ORSyJZsn55D0h0mlHcu8iE+k=
Date:   Fri, 26 Jun 2020 20:33:49 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     cai@lca.pw, guro@fb.com, hannes@cmpxchg.org, mhocko@suse.com,
        mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        stable@vger.kernel.org, vdavydov.dev@gmail.com
Subject:  [merged]
 mm-memcontrol-fix-do-not-put-the-css-reference.patch removed from -mm tree
Message-ID: <20200627033349.GJZiEpfqJ%akpm@linux-foundation.org>
In-Reply-To: <20200625202807.b630829d6fa55388148bee7d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/memcontrol.c: add missed css_put()
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-fix-do-not-put-the-css-reference.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm/memcontrol.c: add missed css_put()

We should put the css reference when memory allocation failed.

Link: http://lkml.kernel.org/r/20200614122653.98829-1-songmuchun@bytedance.com
Fixes: f0a3a24b532d ("mm: memcg/slab: rework non-root kmem_cache lifecycle management")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Roman Gushchin <guro@fb.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Qian Cai <cai@lca.pw>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/memcontrol.c~mm-memcontrol-fix-do-not-put-the-css-reference
+++ a/mm/memcontrol.c
@@ -2772,8 +2772,10 @@ static void memcg_schedule_kmem_cache_cr
 		return;
 
 	cw = kmalloc(sizeof(*cw), GFP_NOWAIT | __GFP_NOWARN);
-	if (!cw)
+	if (!cw) {
+		css_put(&memcg->css);
 		return;
+	}
 
 	cw->memcg = memcg;
 	cw->cachep = cachep;
_

Patches currently in -mm which might be from songmuchun@bytedance.com are


