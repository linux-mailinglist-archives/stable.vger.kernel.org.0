Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8AE283A06
	for <lists+stable@lfdr.de>; Tue,  6 Aug 2019 22:07:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726414AbfHFUHY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Aug 2019 16:07:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:58642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725948AbfHFUHY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Aug 2019 16:07:24 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A5B3F216F4;
        Tue,  6 Aug 2019 20:07:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565122042;
        bh=VZj6bWiUUIO0yyXH3mGw8dljrV9XeMq+9Ab6tGKmhgw=;
        h=Date:From:To:Subject:From;
        b=F51EsjVRXvmqaV6H8xTlV6CFBjkQbnM39UI2aulmBPiwYfUaQGgMA/Ap+5Jm23oYI
         tZDNMAtMb0OOyJEhqaWWZZ30VRe9Bku8IB2nCoPDfqqzo5qTCXjY4KRb/xeyxnICWx
         odwrr5xvabwyRAEkc5oi9rsCSZpv5BFeS1e6eHxE=
Date:   Tue, 06 Aug 2019 13:07:22 -0700
From:   akpm@linux-foundation.org
To:     mgorman@techsingularity.net, mm-commits@vger.kernel.org,
        stable@vger.kernel.org, vbabka@suse.cz
Subject:  [merged]
 =?US-ASCII?Q?mm-compaction-avoid-100%-cpu-usage-during-compaction-when-a-?=
 =?US-ASCII?Q?task-is-killed.patch?= removed from -mm tree
Message-ID: <20190806200722.7ox86bCBy%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm: compaction: avoid 100% CPU usage during compaction when a task is killed
has been removed from the -mm tree.  Its filename was
     mm-compaction-avoid-100%-cpu-usage-during-compaction-when-a-task-is-killed.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm: compaction: avoid 100% CPU usage during compaction when a task is killed

"howaboutsynergy" reported via kernel buzilla number 204165 that
compact_zone_order was consuming 100% CPU during a stress test for
prolonged periods of time.  Specifically the following command, which
should exit in 10 seconds, was taking an excessive time to finish while
the CPU was pegged at 100%.

  stress -m 220 --vm-bytes 1000000000 --timeout 10

Tracing indicated a pattern as follows

          stress-3923  [007]   519.106208: mm_compaction_isolate_migratepages: range=(0x70bb80 ~ 0x70bb80) nr_scanned=0 nr_taken=0
          stress-3923  [007]   519.106212: mm_compaction_isolate_migratepages: range=(0x70bb80 ~ 0x70bb80) nr_scanned=0 nr_taken=0
          stress-3923  [007]   519.106216: mm_compaction_isolate_migratepages: range=(0x70bb80 ~ 0x70bb80) nr_scanned=0 nr_taken=0
          stress-3923  [007]   519.106219: mm_compaction_isolate_migratepages: range=(0x70bb80 ~ 0x70bb80) nr_scanned=0 nr_taken=0
          stress-3923  [007]   519.106223: mm_compaction_isolate_migratepages: range=(0x70bb80 ~ 0x70bb80) nr_scanned=0 nr_taken=0
          stress-3923  [007]   519.106227: mm_compaction_isolate_migratepages: range=(0x70bb80 ~ 0x70bb80) nr_scanned=0 nr_taken=0
          stress-3923  [007]   519.106231: mm_compaction_isolate_migratepages: range=(0x70bb80 ~ 0x70bb80) nr_scanned=0 nr_taken=0
          stress-3923  [007]   519.106235: mm_compaction_isolate_migratepages: range=(0x70bb80 ~ 0x70bb80) nr_scanned=0 nr_taken=0
          stress-3923  [007]   519.106238: mm_compaction_isolate_migratepages: range=(0x70bb80 ~ 0x70bb80) nr_scanned=0 nr_taken=0
          stress-3923  [007]   519.106242: mm_compaction_isolate_migratepages: range=(0x70bb80 ~ 0x70bb80) nr_scanned=0 nr_taken=0

Note that compaction is entered in rapid succession while scanning and
isolating nothing.  The problem is that when a task that is compacting
receives a fatal signal, it retries indefinitely instead of exiting while
making no progress as a fatal signal is pending.

It's not easy to trigger this condition although enabling zswap helps on
the basis that the timing is altered.  A very small window has to be hit
for the problem to occur (signal delivered while compacting and isolating
a PFN for migration that is not aligned to SWAP_CLUSTER_MAX).

This was reproduced locally -- 16G single socket system, 8G swap, 30%
zswap configured, vm-bytes 22000000000 using Colin Kings stress-ng
implementation from github running in a loop until the problem hits). 
Tracing recorded the problem occurring almost 200K times in a short
window.  With this patch, the problem hit 4 times but the task existed
normally instead of consuming CPU.

This problem has existed for some time but it was made worse by
cf66f0700c8f ("mm, compaction: do not consider a need to reschedule as
contention").  Before that commit, if the same condition was hit then
locks would be quickly contended and compaction would exit that way.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=204165
Link: http://lkml.kernel.org/r/20190718085708.GE24383@techsingularity.net
Fixes: cf66f0700c8f ("mm, compaction: do not consider a need to reschedule as contention")
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>	[5.1+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/mm/compaction.c~mm-compaction-avoid-100%-cpu-usage-during-compaction-when-a-task-is-killed
+++ a/mm/compaction.c
@@ -842,13 +842,15 @@ isolate_migratepages_block(struct compac
 
 		/*
 		 * Periodically drop the lock (if held) regardless of its
-		 * contention, to give chance to IRQs. Abort async compaction
-		 * if contended.
+		 * contention, to give chance to IRQs. Abort completely if
+		 * a fatal signal is pending.
 		 */
 		if (!(low_pfn % SWAP_CLUSTER_MAX)
 		    && compact_unlock_should_abort(&pgdat->lru_lock,
-					    flags, &locked, cc))
-			break;
+					    flags, &locked, cc)) {
+			low_pfn = 0;
+			goto fatal_pending;
+		}
 
 		if (!pfn_valid_within(low_pfn))
 			goto isolate_fail;
@@ -1060,6 +1062,7 @@ isolate_abort:
 	trace_mm_compaction_isolate_migratepages(start_pfn, low_pfn,
 						nr_scanned, nr_isolated);
 
+fatal_pending:
 	cc->total_migrate_scanned += nr_scanned;
 	if (nr_isolated)
 		count_compact_events(COMPACTISOLATED, nr_isolated);
_

Patches currently in -mm which might be from mgorman@techsingularity.net are


