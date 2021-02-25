Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F13B3256A2
	for <lists+stable@lfdr.de>; Thu, 25 Feb 2021 20:28:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232403AbhBYT1f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Feb 2021 14:27:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:36870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234143AbhBYTZe (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Feb 2021 14:25:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AECA264F74;
        Thu, 25 Feb 2021 19:14:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614280482;
        bh=7nadox+r47+BVDCG036tc+UO1XtcYQwh4+mbxk/QSWA=;
        h=Date:From:To:Subject:From;
        b=ysglZFPIL638fol3vcsRLqAPugyV40i0BkqpY5dMoRWdJ63QsZMAP43aQoQQW96Q9
         uZ3ySLcKsTZ7Q40RdAygVcRLKU/Gj2u9O70jpKdHKyDVrAxFY7p5VgqJ2/bthYep4C
         gk8iNWzXY3FjTq9u50DDVJOQrtyJDWs7s82JdRI8=
Date:   Thu, 25 Feb 2021 11:14:41 -0800
From:   akpm@linux-foundation.org
To:     guro@fb.com, hannes@cmpxchg.org, mhocko@kernel.org,
        mm-commits@vger.kernel.org, shakeelb@google.com,
        songmuchun@bytedance.com, stable@vger.kernel.org,
        vdavydov.dev@gmail.com
Subject:  [merged]
 mm-memcontrol-fix-get_active_memcg-return-value.patch removed from -mm tree
Message-ID: <20210225191441.qO40JqBXH%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: fix get_active_memcg return value
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-fix-get_active_memcg-return-value.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from songmuchun@bytedance.com are


