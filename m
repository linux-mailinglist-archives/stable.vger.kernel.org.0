Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3673FDF804
	for <lists+stable@lfdr.de>; Tue, 22 Oct 2019 00:32:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730203AbfJUWcR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Oct 2019 18:32:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:59608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727264AbfJUWcR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Oct 2019 18:32:17 -0400
Received: from akpm3.svl.corp.google.com (unknown [104.133.8.65])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BF1052067B;
        Mon, 21 Oct 2019 22:32:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571697135;
        bh=hmEoB7gaRz12GzXgBYeN2pNHgY7Xx4XTV03KVerTLw4=;
        h=Date:From:To:Subject:From;
        b=USR2CFvOODc+Pm+FZJUAZVCFQysYUMxQolv2OPkOOrNO3ur91vdvvWidoN2ozdOM1
         KSBDsuwfxJr2A4toVfcxiyI8b7PMEDWSNItSo/J2vm0wSr/pOGdBzaMNb+jrWEKYa2
         eBku4jUeMJR0FHxbHio5gzgvfJ/Rom3t5aXoNC1s=
Date:   Mon, 21 Oct 2019 15:32:14 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, tglx@linutronix.de,
        stable@vger.kernel.org, mhocko@suse.com, matt@codeblueprint.co.uk,
        bp@alien8.de, mgorman@techsingularity.net
Subject:  [to-be-updated]
 mm-meminit-recalculate-pcpu-batch-and-high-limits-after-init-completes.patch
 removed from -mm tree
Message-ID: <20191021223214.mg0T6%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.11
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm, meminit: recalculate pcpu batch and high limits after init completes
has been removed from the -mm tree.  Its filename was
     mm-meminit-recalculate-pcpu-batch-and-high-limits-after-init-completes.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm, meminit: recalculate pcpu batch and high limits after init completes

Deferred memory initialisation updates zone->managed_pages during the
initialisation phase but before that finishes, the per-cpu page allocator
(pcpu) calculates the number of pages allocated/freed in batches as well
as the maximum number of pages allowed on a per-cpu list.  As
zone->managed_pages is not up to date yet, the pcpu initialisation
calculates inappropriately low batch and high values.

This increases zone lock contention quite severely in some cases with the
degree of severity depending on how many CPUs share a local zone and the
size of the zone.  A private report indicated that kernel build times were
excessive with extremely high system CPU usage.  A perf profile indicated
that a large chunk of time was lost on zone->lock contention.

This patch recalculates the pcpu batch and high values after deferred
initialisation completes on each node.  It was tested on a 2-socket AMD
EPYC 2 machine using a kernel compilation workload -- allmodconfig and all
available CPUs.

mmtests configuration: config-workload-kernbench-max Configuration was
modified to build on a fresh XFS partition.

kernbench
                                5.4.0-rc3              5.4.0-rc3
                                  vanilla         resetpcpu-v1r1
Amean     user-256    13249.50 (   0.00%)    15928.40 * -20.22%*
Amean     syst-256    14760.30 (   0.00%)     4551.77 *  69.16%*
Amean     elsp-256      162.42 (   0.00%)      118.46 *  27.06%*
Stddev    user-256       42.97 (   0.00%)       50.83 ( -18.30%)
Stddev    syst-256      336.87 (   0.00%)       33.70 (  90.00%)
Stddev    elsp-256        2.46 (   0.00%)        0.81 (  67.01%)

                   5.4.0-rc3   5.4.0-rc3
                     vanillaresetpcpu-v1r1
Duration User       39766.24    47802.92
Duration System     44298.10    13671.93
Duration Elapsed      519.11      387.65

The patch reduces system CPU usage by 69.16% and total build time by
27.06%.  The variance of system CPU usage is also much reduced.

Link: http://lkml.kernel.org/r/20191018105606.3249-3-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Tested-by: Matt Fleming <matt@codeblueprint.co.uk>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Borislav Petkov <bp@alien8.de>
Cc: <stable@vger.kernel.org>	[4.1+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/mm/page_alloc.c~mm-meminit-recalculate-pcpu-batch-and-high-limits-after-init-completes
+++ a/mm/page_alloc.c
@@ -1818,6 +1818,14 @@ static int __init deferred_init_memmap(v
 	 */
 	while (spfn < epfn)
 		nr_pages += deferred_init_maxorder(&i, zone, &spfn, &epfn);
+
+	/*
+	 * The number of managed pages has changed due to the initialisation
+	 * so the pcpu batch and high limits needs to be updated or the limits
+	 * will be artificially small.
+	 */
+	zone_pcp_update(zone);
+
 zone_empty:
 	pgdat_resize_unlock(pgdat, &flags);
 
@@ -8514,7 +8522,6 @@ void free_contig_range(unsigned long pfn
 	WARN(count != 0, "%d pages are still in use!\n", count);
 }
 
-#ifdef CONFIG_MEMORY_HOTPLUG
 /*
  * The zone indicated has a new number of managed_pages; batch sizes and percpu
  * page high values need to be recalulated.
@@ -8528,7 +8535,6 @@ void __meminit zone_pcp_update(struct zo
 				per_cpu_ptr(zone->pageset, cpu));
 	mutex_unlock(&pcp_batch_high_lock);
 }
-#endif
 
 void zone_pcp_reset(struct zone *zone)
 {
_

Patches currently in -mm which might be from mgorman@techsingularity.net are

mm-pcp-share-common-code-between-memory-hotplug-and-percpu-sysctl-handler.patch
mm-pcpu-make-zone-pcp-updates-and-reset-internal-to-the-mm.patch

