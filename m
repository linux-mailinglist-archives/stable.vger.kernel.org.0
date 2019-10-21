Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 750C9DF813
	for <lists+stable@lfdr.de>; Tue, 22 Oct 2019 00:37:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730350AbfJUWh3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Oct 2019 18:37:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:60216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729620AbfJUWh3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Oct 2019 18:37:29 -0400
Received: from akpm3.svl.corp.google.com (unknown [104.133.8.65])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 40D3120700;
        Mon, 21 Oct 2019 22:37:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571697446;
        bh=9RSmFckSxl0LM+8wLyz4g3+tean2D+twDKer9hd0CPQ=;
        h=Date:From:To:Subject:From;
        b=0NrAYmKYLgIujGzP6XzNJ1npux82AI291vq/GWlfbqcuRpDms3/hJt1ug+rmzObp8
         /9GOI6K7TYOVhvUF/KSP6i9X1UOLCNOTah7+0NE3o5JP/pLV7DDFeHcLwABQbPmeyI
         uxxh+/DLehfxX5taXSwkcrBaMEUw2pQl0lkZUiwE=
Date:   Mon, 21 Oct 2019 15:37:25 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, tglx@linutronix.de,
        stable@vger.kernel.org, mhocko@suse.com, matt@codeblueprint.co.uk,
        cai@lca.pw, bp@alien8.de, mgorman@techsingularity.net
Subject:  +
 mm-meminit-recalculate-pcpu-batch-and-high-limits-after-init-completes.patch
 added to -mm tree
Message-ID: <20191021223725.uB__L%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.11
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm, meminit: recalculate pcpu batch and high limits after init completes
has been added to the -mm tree.  Its filename is
     mm-meminit-recalculate-pcpu-batch-and-high-limits-after-init-completes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-meminit-recalculate-pcpu-batch-and-high-limits-after-init-completes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-meminit-recalculate-pcpu-batch-and-high-limits-after-init-completes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
initialisation completes for every populated zone in the system.  It was
tested on a 2-socket AMD EPYC 2 machine using a kernel compilation
workload -- allmodconfig and all available CPUs.

mmtests configuration: config-workload-kernbench-max Configuration was
modified to build on a fresh XFS partition.

kernbench
                                5.4.0-rc3              5.4.0-rc3
                                  vanilla           resetpcpu-v2
Amean     user-256    13249.50 (   0.00%)    16401.31 * -23.79%*
Amean     syst-256    14760.30 (   0.00%)     4448.39 *  69.86%*
Amean     elsp-256      162.42 (   0.00%)      119.13 *  26.65%*
Stddev    user-256       42.97 (   0.00%)       19.15 (  55.43%)
Stddev    syst-256      336.87 (   0.00%)        6.71 (  98.01%)
Stddev    elsp-256        2.46 (   0.00%)        0.39 (  84.03%)

                   5.4.0-rc3    5.4.0-rc3
                     vanilla resetpcpu-v2
Duration User       39766.24     49221.79
Duration System     44298.10     13361.67
Duration Elapsed      519.11       388.87

The patch reduces system CPU usage by 69.86% and total build time by
26.65%. The variance of system CPU usage is also much reduced.

Before, this was the breakdown of batch and high values over all zones was.

    256               batch: 1
    256               batch: 63
    512               batch: 7
    256               high:  0
    256               high:  378
    512               high:  42

512 pcpu pagesets had a batch limit of 7 and a high limit of 42.  After
the patch:

    256               batch: 1
    768               batch: 63
    256               high:  0
    768               high:  378

Link: http://lkml.kernel.org/r/20191021094808.28824-2-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Qian Cai <cai@lca.pw>
Cc: <stable@vger.kernel.org>	[4.1+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/mm/page_alloc.c~mm-meminit-recalculate-pcpu-batch-and-high-limits-after-init-completes
+++ a/mm/page_alloc.c
@@ -1948,6 +1948,14 @@ void __init page_alloc_init_late(void)
 	wait_for_completion(&pgdat_init_all_done_comp);
 
 	/*
+	 * The number of managed pages has changed due to the initialisation
+	 * so the pcpu batch and high limits needs to be updated or the limits
+	 * will be artificially small.
+	 */
+	for_each_populated_zone(zone)
+		zone_pcp_update(zone);
+
+	/*
 	 * We initialized the rest of the deferred pages.  Permanently disable
 	 * on-demand struct page initialization.
 	 */
_

Patches currently in -mm which might be from mgorman@techsingularity.net are

mm-meminit-recalculate-pcpu-batch-and-high-limits-after-init-completes.patch
mm-pcp-share-common-code-between-memory-hotplug-and-percpu-sysctl-handler.patch
mm-pcpu-make-zone-pcp-updates-and-reset-internal-to-the-mm.patch

