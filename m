Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8836D20BDF1
	for <lists+stable@lfdr.de>; Sat, 27 Jun 2020 05:33:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725957AbgF0DdY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jun 2020 23:33:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:45038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725913AbgF0DdX (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jun 2020 23:33:23 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B134620CC7;
        Sat, 27 Jun 2020 03:33:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593228803;
        bh=TvQ3MZYCb+nzDtLp8y5E7FBB+5b5q2N6VeEB3pe1SLE=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=hXuCOikHNmGLQsAwOlZKtuA1IUIqC2hwYUwE2hUaq1WT3GbTbRH9cNeqiaNR58Szr
         Ytoz3g2jhPoiSZGL/vFLx4DtGtUtQiv6tAYOozeCzn/xPMwgX7J71Uvl+s/0mMnOt/
         m1G6C+eSy/0YewhmSobLCPi8NCX11s41TKBui3fo=
Date:   Fri, 26 Jun 2020 20:33:22 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     cl@linux.com, guro@fb.com, hannes@cmpxchg.org,
        iamjoonsoo.kim@lge.com, longman@redhat.com, mhocko@kernel.org,
        mm-commits@vger.kernel.org, penberg@kernel.org,
        rientjes@google.com, shakeelb@google.com, stable@vger.kernel.org,
        vdavydov.dev@gmail.com
Subject:  [merged]
 mm-slab-fix-sign-conversion-problem-in-memcg_uncharge_slab.patch removed
 from -mm tree
Message-ID: <20200627033322.fMNqLPJU8%akpm@linux-foundation.org>
In-Reply-To: <20200625202807.b630829d6fa55388148bee7d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm, slab: fix sign conversion problem in memcg_uncharge_slab()
has been removed from the -mm tree.  Its filename was
     mm-slab-fix-sign-conversion-problem-in-memcg_uncharge_slab.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Waiman Long <longman@redhat.com>
Subject: mm, slab: fix sign conversion problem in memcg_uncharge_slab()

It was found that running the LTP test on a PowerPC system could produce
erroneous values in /proc/meminfo, like:

  MemTotal:       531915072 kB
  MemFree:        507962176 kB
  MemAvailable:   1100020596352 kB

Using bisection, the problem is tracked down to commit 9c315e4d7d8c ("mm:
memcg/slab: cache page number in memcg_(un)charge_slab()").

In memcg_uncharge_slab() with a "int order" argument:

  unsigned int nr_pages = 1 << order;
    :
  mod_lruvec_state(lruvec, cache_vmstat_idx(s), -nr_pages);

The mod_lruvec_state() function will eventually call the
__mod_zone_page_state() which accepts a long argument.  Depending on the
compiler and how inlining is done, "-nr_pages" may be treated as a
negative number or a very large positive number.  Apparently, it was
treated as a large positive number in that PowerPC system leading to
incorrect stat counts.  This problem hasn't been seen in x86-64 yet,
perhaps the gcc compiler there has some slight difference in behavior.

It is fixed by making nr_pages a signed value.  For consistency, a similar
change is applied to memcg_charge_slab() as well.

Link: http://lkml.kernel.org/r/20200620184719.10994-1-longman@redhat.com
Fixes: 9c315e4d7d8c ("mm: memcg/slab: cache page number in memcg_(un)charge_slab()").
Signed-off-by: Waiman Long <longman@redhat.com>
Acked-by: Roman Gushchin <guro@fb.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/slab.h~mm-slab-fix-sign-conversion-problem-in-memcg_uncharge_slab
+++ a/mm/slab.h
@@ -348,7 +348,7 @@ static __always_inline int memcg_charge_
 					     gfp_t gfp, int order,
 					     struct kmem_cache *s)
 {
-	unsigned int nr_pages = 1 << order;
+	int nr_pages = 1 << order;
 	struct mem_cgroup *memcg;
 	struct lruvec *lruvec;
 	int ret;
@@ -388,7 +388,7 @@ out:
 static __always_inline void memcg_uncharge_slab(struct page *page, int order,
 						struct kmem_cache *s)
 {
-	unsigned int nr_pages = 1 << order;
+	int nr_pages = 1 << order;
 	struct mem_cgroup *memcg;
 	struct lruvec *lruvec;
 
_

Patches currently in -mm which might be from longman@redhat.com are

mm-treewide-rename-kzfree-to-kfree_sensitive.patch
sched-mm-optimize-current_gfp_context.patch

