Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62EDDF7F35
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 20:10:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727535AbfKKSeG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:34:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:51568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728263AbfKKSeD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:34:03 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 711C221783;
        Mon, 11 Nov 2019 18:34:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573497242;
        bh=mE/nS207YufMKFuIMK9dIrjyXCW4fod9tY0f4+tnK3c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=avfk0/1Epm0z7I9IsAxZoF5G4Z2icvfQBGeSiQUOSBeGDsihPWhIJ6GwuxNVSwdfc
         IBiWflhrDeyCDj+s6dH2iSjhzdSHmLHaGWP4196nimtOAgyFLWGJjNGojd3RThCCEO
         xaunL4gYClzBgIskIJ881NpbnajYxSyU1aeN/xBY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mel Gorman <mgorman@techsingularity.net>,
        Michal Hocko <mhocko@suse.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        David Hildenbrand <david@redhat.com>,
        Matt Fleming <matt@codeblueprint.co.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, Qian Cai <cai@lca.pw>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.9 12/65] mm, meminit: recalculate pcpu batch and high limits after init completes
Date:   Mon, 11 Nov 2019 19:28:12 +0100
Message-Id: <20191111181343.283339357@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181331.917659011@linuxfoundation.org>
References: <20191111181331.917659011@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mel Gorman <mgorman@techsingularity.net>

commit 3e8fc0075e24338b1117cdff6a79477427b8dbed upstream.

Deferred memory initialisation updates zone->managed_pages during the
initialisation phase but before that finishes, the per-cpu page
allocator (pcpu) calculates the number of pages allocated/freed in
batches as well as the maximum number of pages allowed on a per-cpu
list.  As zone->managed_pages is not up to date yet, the pcpu
initialisation calculates inappropriately low batch and high values.

This increases zone lock contention quite severely in some cases with
the degree of severity depending on how many CPUs share a local zone and
the size of the zone.  A private report indicated that kernel build
times were excessive with extremely high system CPU usage.  A perf
profile indicated that a large chunk of time was lost on zone->lock
contention.

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
26.65%.  The variance of system CPU usage is also much reduced.

Before, this was the breakdown of batch and high values over all zones
was:

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

[mgorman@techsingularity.net: fix merge/linkage snafu]
  Link: http://lkml.kernel.org/r/20191023084705.GD3016@techsingularity.netLink: http://lkml.kernel.org/r/20191021094808.28824-2-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Qian Cai <cai@lca.pw>
Cc: <stable@vger.kernel.org>	[4.1+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/page_alloc.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2051,6 +2051,14 @@ static void reserve_highatomic_pageblock
 	unsigned long max_managed, flags;
 
 	/*
+	 * The number of managed pages has changed due to the initialisation
+	 * so the pcpu batch and high limits needs to be updated or the limits
+	 * will be artificially small.
+	 */
+	for_each_populated_zone(zone)
+		zone_pcp_update(zone);
+
+	/*
 	 * Limit the number reserved to 1 pageblock or roughly 1% of a zone.
 	 * Check is race-prone but harmless.
 	 */
@@ -7385,7 +7393,6 @@ void free_contig_range(unsigned long pfn
 }
 #endif
 
-#ifdef CONFIG_MEMORY_HOTPLUG
 /*
  * The zone indicated has a new number of managed_pages; batch sizes and percpu
  * page high values need to be recalulated.
@@ -7399,7 +7406,6 @@ void __meminit zone_pcp_update(struct zo
 				per_cpu_ptr(zone->pageset, cpu));
 	mutex_unlock(&pcp_batch_high_lock);
 }
-#endif
 
 void zone_pcp_reset(struct zone *zone)
 {


