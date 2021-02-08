Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F38B313392
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 14:44:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231321AbhBHNn1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 08:43:27 -0500
Received: from mx2.suse.de ([195.135.220.15]:41610 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230412AbhBHNmI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 08:42:08 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id E6A94AD24;
        Mon,  8 Feb 2021 13:41:25 +0000 (UTC)
From:   Vlastimil Babka <vbabka@suse.cz>
To:     vbabka@suse.cz
Cc:     Catalin.Marinas@arm.com, akpm@linux-foundation.org,
        aneesh.kumar@linux.ibm.com, bharata@linux.ibm.com, cl@linux.com,
        guro@fb.com, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com,
        jannh@google.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        mhocko@kernel.org, rientjes@google.com, shakeelb@google.com,
        vincent.guittot@linaro.org, will@kernel.org,
        Mel Gorman <mgorman@techsingularity.net>,
        stable@vger.kernel.org
Subject: [PATCH] mm, slub: better heuristic for number of cpus when calculating slab order
Date:   Mon,  8 Feb 2021 14:41:08 +0100
Message-Id: <20210208134108.22286-1-vbabka@suse.cz>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <aac07668-99a0-4c7e-5f8b-10751af364c5@suse.cz>
References: <aac07668-99a0-4c7e-5f8b-10751af364c5@suse.cz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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

We could use num_present_cpus() that should be the number of physically present
CPUs even before they are onlined. That would for for PowerPC [3], which
triggered the original commit,  but that still doesn't work on arm64 [4] as
explained in [5].

So this patch tries to determine the best available value without specific arch
knowledge.
- num_present_cpus() if the number is larger than 1, as that means the arch is
likely setting it properly
- nr_cpu_ids otherwise

This should fix the reported regressions while also keeping the effect of
045ab8c9487b for PowerPC systems. It's possible there are configurations where
num_present_cpus() is 1 during boot while nr_cpu_ids is at the same time
bloated, so these (if they exist) would keep the large orders based on
nr_cpu_ids as was before 045ab8c9487b.

[1] https://lore.kernel.org/linux-mm/CAKfTPtA_JgMf_+zdFbcb_V9rM7JBWNPjAz9irgwFj7Rou=xzZg@mail.gmail.com/
[2] https://lore.kernel.org/linux-mm/20210128134512.GF3592@techsingularity.net/
[3] https://lore.kernel.org/linux-mm/20210123051607.GC2587010@in.ibm.com/
[4] https://lore.kernel.org/linux-mm/CAKfTPtAjyVmS5VYvU6DBxg4-JEo5bdmWbngf-03YsY18cmWv_g@mail.gmail.com/
[5] https://lore.kernel.org/linux-mm/20210126230305.GD30941@willie-the-truck/

Fixes: 045ab8c9487b ("mm/slub: let number of online CPUs determine the slub page order")
Reported-by: Vincent Guittot <vincent.guittot@linaro.org>
Reported-by: Mel Gorman <mgorman@techsingularity.net>
Cc: <stable@vger.kernel.org>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---

OK, this is a 5.11 regression, so we should try to it by 5.12. I've also
Cc'd stable for that reason although it's not a crash fix.
We can still try later to replace this with a safe order update in hotplug
callbacks, but that's infeasible for 5.12.

 mm/slub.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 176b1cb0d006..8fc9190e6cb3 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3454,6 +3454,7 @@ static inline int calculate_order(unsigned int size)
 	unsigned int order;
 	unsigned int min_objects;
 	unsigned int max_objects;
+	unsigned int nr_cpus;
 
 	/*
 	 * Attempt to find best configuration for a slab. This
@@ -3464,8 +3465,21 @@ static inline int calculate_order(unsigned int size)
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
 
-- 
2.30.0

