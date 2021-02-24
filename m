Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF5D53244E0
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 21:07:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234364AbhBXUGS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Feb 2021 15:06:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:56140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234906AbhBXUFv (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Feb 2021 15:05:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 31F4764F11;
        Wed, 24 Feb 2021 20:04:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614197063;
        bh=G31EBYnGYWA+9ziOs13ui7hLFTA9Ds66VuzLUR1+Iv4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=si5bUio5hFqsEjKRig7n4vmR60gzC42liNYSxQ6OQc3feQk003GyrD0TmiSURD3DK
         NqjymUnrfzPZHB1usvHOdEf13vscSZfoeV6hQINEKMuno0e5H0/KG4D1aFDvMsr/Te
         MmT+prNuBlA4QG+t3+FVRVtGntzQenx+rTuRsyWI=
Date:   Wed, 24 Feb 2021 12:04:22 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, guro@fb.com, hannes@cmpxchg.org,
        linux-mm@kvack.org, mhocko@kernel.org, mm-commits@vger.kernel.org,
        shakeelb@google.com, songmuchun@bytedance.com,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        vdavydov.dev@gmail.com
Subject:  [patch 074/173] mm: memcontrol: fix get_active_memcg
 return value
Message-ID: <20210224200422.mMBuJs4L_%akpm@linux-foundation.org>
In-Reply-To: <20210224115824.1e289a6895087f10c41dd8d6@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: memcontrol: fix get_active_memcg return value

We use a global percpu int_active_memcg variable to store the remote memcg
when we are in the interrupt context.  But get_active_memcg always return
the current->active_memcg or root_mem_cgroup.  The remote memcg (set in
the interrupt context) is ignored.  This is not what we want.  So fix it.

Link: https://lkml.kernel.org/r/20210223091101.42150-1-songmuchun@bytedance.com
Fixes: 37d5985c003d ("mm: kmem: prepare remote memcg charging infra for interrupt contexts")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Reviewed-by: Roman Gushchin <guro@fb.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

--- a/mm/memcontrol.c~mm-memcontrol-fix-get_active_memcg-return-value
+++ a/mm/memcontrol.c
@@ -1061,13 +1061,9 @@ static __always_inline struct mem_cgroup
 
 	rcu_read_lock();
 	memcg = active_memcg();
-	if (memcg) {
-		/* current->active_memcg must hold a ref. */
-		if (WARN_ON_ONCE(!css_tryget(&memcg->css)))
-			memcg = root_mem_cgroup;
-		else
-			memcg = current->active_memcg;
-	}
+	/* remote memcg must hold a ref. */
+	if (memcg && WARN_ON_ONCE(!css_tryget(&memcg->css)))
+		memcg = root_mem_cgroup;
 	rcu_read_unlock();
 
 	return memcg;
_
