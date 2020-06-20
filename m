Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1148420264B
	for <lists+stable@lfdr.de>; Sat, 20 Jun 2020 22:04:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728692AbgFTUEF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 20 Jun 2020 16:04:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:34266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728640AbgFTUEE (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 20 Jun 2020 16:04:04 -0400
Received: from X1 (nat-ab2241.sltdut.senawave.net [162.218.216.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8EE9D24680;
        Sat, 20 Jun 2020 20:04:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592683443;
        bh=UaBKgxjUoKLkGYfGcRVJEasCL6YtvmrnZ+fFuusrC/o=;
        h=Date:From:To:Subject:From;
        b=aODgCXDgHubg5JVeAhWX3w+zKiu+z4+3GESmfP+As/vGpMDNs71Q18LIBBwJbdTUR
         9ZI0kN1xBNcIBXDlosGH9gFA293eoDclWIkQExjHQxzvOGc6bhgrIQmpIzvAd3x8uA
         vWEv/vlIemOyyN/pMmQwDaR5P+Rd+BbhwekSok1U=
Date:   Sat, 20 Jun 2020 13:04:02 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, vdavydov.dev@gmail.com,
        stable@vger.kernel.org, shakeelb@google.com, rientjes@google.com,
        penberg@kernel.org, mhocko@kernel.org, iamjoonsoo.kim@lge.com,
        hannes@cmpxchg.org, guro@fb.com, cl@linux.com, longman@redhat.com
Subject:  +
 mm-slab-fix-sign-conversion-problem-in-memcg_uncharge_slab.patch added to -mm
 tree
Message-ID: <20200620200402.Cd06t%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm, slab: fix sign conversion problem in memcg_uncharge_slab()
has been added to the -mm tree.  Its filename is
     mm-slab-fix-sign-conversion-problem-in-memcg_uncharge_slab.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-slab-fix-sign-conversion-problem-in-memcg_uncharge_slab.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-slab-fix-sign-conversion-problem-in-memcg_uncharge_slab.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-slab-use-memzero_explicit-in-kzfree.patch
mm-slab-fix-sign-conversion-problem-in-memcg_uncharge_slab.patch
mm-treewide-rename-kzfree-to-kfree_sensitive.patch

