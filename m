Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4887331925D
	for <lists+stable@lfdr.de>; Thu, 11 Feb 2021 19:35:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230059AbhBKSfR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Feb 2021 13:35:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:56566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231743AbhBKSdK (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Feb 2021 13:33:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8194E64E95;
        Thu, 11 Feb 2021 18:31:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1613068267;
        bh=ZFYjRxffH5VITQ5PwRMIFEhRcM9nYfP8GWk7skRhAJo=;
        h=Date:From:To:Subject:From;
        b=X3PuJ1penYC7gbdek2rIxkZjMrbMVebl9cIyGfbR4PJsyAaYVwTJcEmvQAoFjVxvn
         TJ6Uo65N4wIa9Bgohvf6vzvbcQ3uD2zBbwXSNBRL20tjtXEr2633WlA0FjVttFv8Jf
         pHYQ2hPKvWfEMroJmq9QPJ6uPoU6jTvpx3IFfbmI=
Date:   Thu, 11 Feb 2021 10:31:06 -0800
From:   akpm@linux-foundation.org
To:     aneesh.kumar@linux.ibm.com, bharata@linux.ibm.com,
        catalin.marinas@arm.com, cl@linux.com, guro@fb.com,
        hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, jannh@google.com,
        mgorman@techsingularity.net, mhocko@kernel.org,
        mm-commits@vger.kernel.org, rientjes@google.com,
        shakeelb@google.com, stable@vger.kernel.org, vbabka@suse.cz,
        vincent.guittot@linaro.org, will@kernel.org
Subject:  [merged]
 =?US-ASCII?Q?mm-slub-better-heuristic-for-number-of-cpus-when-calculat?=
 =?US-ASCII?Q?ing-slab-order.patch?= removed from -mm tree
Message-ID: <20210211183106.-JulMkHdp%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm, slub: better heuristic for number of cpus when calculating slab order
has been removed from the -mm tree.  Its filename was
     mm-slub-better-heuristic-for-number-of-cpus-when-calculating-slab-order.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, slub: better heuristic for number of cpus when calculating slab order

When creating a new kmem cache, SLUB determines how large the slab pages will
based on number of inputs, including the number of CPUs in the system. Larger
slab pages mean that more objects can be allocated/free from per-cpu slabs
before accessing shared structures, but also potentially more memory can be
wasted due to low slab usage and fragmentation.
The rough idea of using number of CPUs is that larger systems will be more
likely to benefit from reduced contention, and also should have enough memory
to spare.

Number of CPUs used to be determined as nr_cpu_ids, which is number of possible
cpus, but on some systems many will never be onlined, thus commit 045ab8c9487b
("mm/slub: let number of online CPUs determine the slub page order") changed it
to nr_online_cpus(). However, for kmem caches created early before CPUs are
onlined, this may lead to permamently low slab page sizes.

Vincent reports a regression [1] of hackbench on arm64 systems:

> I'm facing significant performances regression on a large arm64 server
> system (224 CPUs). Regressions is also present on small arm64 system
> (8 CPUs) but in a far smaller order of magnitude

> On 224 CPUs system : 9 iterations of hackbench -l 16000 -g 16
> v5.11-rc4 : 9.135sec (+/- 0.45%)
> v5.11-rc4 + revert this patch: 3.173sec (+/- 0.48%)
> v5.10: 3.136sec (+/- 0.40%)

Mel reports a regression [2] of hackbench on x86_64, with lockstat suggesting
page allocator contention:

> i.e. the patch incurs a 7% to 32% performance penalty. This bisected
> cleanly yesterday when I was looking for the regression and then found
> the thread.

> Numerous caches change size. For example, kmalloc-512 goes from order-0
> (vanilla) to order-2 with the revert.

> So mostly this is down to the number of times SLUB calls into the page
> allocator which only caches order-0 pages on a per-cpu basis.

Clearly num_online_cpus() doesn't work too early in bootup. We could change
the order dynamically in a memory hotplug callback, but runtime order changing
for existing kmem caches has been already shown as dangerous, and removed in
32a6f409b693 ("mm, slub: remove runtime allocation order changes"). It could be
resurrected in a safe manner with some effort, but to fix the regression we
need something simpler.

We could use num_present_cpus() that should be the number of physically
present CPUs even before they are onlined.  That would work for PowerPC
[3], which triggered the original commit, but that still doesn't work on
arm64 [4] as explained in [5].

So this patch tries to determine the best available value without specific
arch knowledge.

- num_present_cpus() if the number is larger than 1, as that means the
  arch is likely setting it properly

- nr_cpu_ids otherwise

This should fix the reported regressions while also keeping the effect of
045ab8c9487b for PowerPC systems.  It's possible there are configurations
where num_present_cpus() is 1 during boot while nr_cpu_ids is at the same
time bloated, so these (if they exist) would keep the large orders based
on nr_cpu_ids as was before 045ab8c9487b.

[1] https://lore.kernel.org/linux-mm/CAKfTPtA_JgMf_+zdFbcb_V9rM7JBWNPjAz9irgwFj7Rou=xzZg@mail.gmail.com/
[2] https://lore.kernel.org/linux-mm/20210128134512.GF3592@techsingularity.net/
[3] https://lore.kernel.org/linux-mm/20210123051607.GC2587010@in.ibm.com/
[4] https://lore.kernel.org/linux-mm/CAKfTPtAjyVmS5VYvU6DBxg4-JEo5bdmWbngf-03YsY18cmWv_g@mail.gmail.com/
[5] https://lore.kernel.org/linux-mm/20210126230305.GD30941@willie-the-truck/

Link: https://lkml.kernel.org/r/20210208134108.22286-1-vbabka@suse.cz
Fixes: 045ab8c9487b ("mm/slub: let number of online CPUs determine the slub page order")
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reported-by: Vincent Guittot <vincent.guittot@linaro.org>
Reported-by: Mel Gorman <mgorman@techsingularity.net>
Tested-by: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Bharata B Rao <bharata@linux.ibm.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Jann Horn <jannh@google.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Will Deacon <will@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

--- a/mm/slub.c~mm-slub-better-heuristic-for-number-of-cpus-when-calculating-slab-order
+++ a/mm/slub.c
@@ -3423,6 +3423,7 @@ static inline int calculate_order(unsign
 	unsigned int order;
 	unsigned int min_objects;
 	unsigned int max_objects;
+	unsigned int nr_cpus;
 
 	/*
 	 * Attempt to find best configuration for a slab. This
@@ -3433,8 +3434,21 @@ static inline int calculate_order(unsign
 	 * we reduce the minimum objects required in a slab.
 	 */
 	min_objects = slub_min_objects;
-	if (!min_objects)
-		min_objects = 4 * (fls(num_online_cpus()) + 1);
+	if (!min_objects) {
+		/*
+		 * Some architectures will only update present cpus when
+		 * onlining them, so don't trust the number if it's just 1. But
+		 * we also don't want to use nr_cpu_ids always, as on some other
+		 * architectures, there can be many possible cpus, but never
+		 * onlined. Here we compromise between trying to avoid too high
+		 * order on systems that appear larger than they are, and too
+		 * low order on systems that appear smaller than they are.
+		 */
+		nr_cpus = num_present_cpus();
+		if (nr_cpus <= 1)
+			nr_cpus = nr_cpu_ids;
+		min_objects = 4 * (fls(nr_cpus) + 1);
+	}
 	max_objects = order_objects(slub_max_order, size);
 	min_objects = min(min_objects, max_objects);
 
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-slub-stop-freeing-kmem_cache_node-structures-on-node-offline.patch
mm-slab-slub-stop-taking-memory-hotplug-lock.patch
mm-slab-slub-stop-taking-cpu-hotplug-lock.patch
mm-slub-splice-cpu-and-page-freelists-in-deactivate_slab.patch
mm-slub-remove-slub_memcg_sysfs-boot-param-and-config_slub_memcg_sysfs_on.patch

