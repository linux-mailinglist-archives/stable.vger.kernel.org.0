Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B11BB323512
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 02:21:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231843AbhBXBPD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Feb 2021 20:15:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:36618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231584AbhBXBGF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Feb 2021 20:06:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BF7B764E6F;
        Tue, 23 Feb 2021 23:51:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614124289;
        bh=gV6a7K8qS0Eb0Gjlw4jCWxf4rD3FsbE2BT5mGOfBmHk=;
        h=Date:From:To:Subject:From;
        b=ycJRJR3fwm1WPXnGb9mb/1kiuEvZ15vEYqx6wGcYtGMNkZys79yRqkzbmLcYki8Yv
         9ROF0QTEohADeuxYBJwWcBr9KOTDFSo76vOjH1s/03WpUBiCyqUI9mbQvXeR3pM+F2
         8UhYFUcQW4/dJKOY3SlPWXJFYvnm8ZtwjLuPnl8A=
Date:   Tue, 23 Feb 2021 15:51:28 -0800
From:   akpm@linux-foundation.org
To:     guro@fb.com, hannes@cmpxchg.org, mhocko@kernel.org,
        mm-commits@vger.kernel.org, shakeelb@google.com,
        songmuchun@bytedance.com, stable@vger.kernel.org,
        vdavydov.dev@gmail.com
Subject:  + mm-memcontrol-fix-get_active_memcg-return-value.patch
 added to -mm tree
Message-ID: <20210223235128.Eey1x63a9%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: fix get_active_memcg return value
has been added to the -mm tree.  Its filename is
     mm-memcontrol-fix-get_active_memcg-return-value.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-fix-get_active_memcg-return-value.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-fix-get_active_memcg-return-value.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-memcontrol-optimize-per-lruvec-stats-counter-memory-usage.patch
mm-memcontrol-fix-nr_anon_thps-accounting-in-charge-moving.patch
mm-memcontrol-convert-nr_anon_thps-account-to-pages.patch
mm-memcontrol-convert-nr_file_thps-account-to-pages.patch
mm-memcontrol-convert-nr_shmem_thps-account-to-pages.patch
mm-memcontrol-convert-nr_shmem_pmdmapped-account-to-pages.patch
mm-memcontrol-convert-nr_file_pmdmapped-account-to-pages.patch
mm-memcontrol-make-the-slab-calculation-consistent.patch
mm-memcontrol-replace-the-loop-with-a-list_for_each_entry.patch
mm-memcontrol-fix-swap-undercounting-in-cgroup2.patch
mm-memcontrol-fix-get_active_memcg-return-value.patch
hugetlb-convert-page_huge_active-hpagemigratable-flag-fix.patch

