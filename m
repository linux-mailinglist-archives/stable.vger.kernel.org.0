Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19894589151
	for <lists+stable@lfdr.de>; Wed,  3 Aug 2022 19:25:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236279AbiHCRZt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Aug 2022 13:25:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238097AbiHCRZs (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Aug 2022 13:25:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F22C71F638;
        Wed,  3 Aug 2022 10:25:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8C97F60C4D;
        Wed,  3 Aug 2022 17:25:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D195BC433D6;
        Wed,  3 Aug 2022 17:25:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1659547545;
        bh=UWK7+9FoRkpMi8D5h8T5IguDSFDH5O7semtd3mRA06s=;
        h=Date:To:From:Subject:From;
        b=Ddv2a4zFnpotbQUbvILclVXxVXUCGAP1WmiEkYJ/MvudzkUtmNKbLd6b+rW3xqsuq
         aTIlja4PA8GMbtDmm+0PtXSGXN63p7OBk4r2ERMP13k+8P39ZBfcxNNMO1cSDcauRi
         RxDbvWhWtF4akmFuoJvV6SzksqCN6iSb2lB97yVw=
Date:   Wed, 03 Aug 2022 10:25:45 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        mgorman@techsingularity.net, iamjoonsoo.kim@lge.com,
        hughd@google.com, hannes@cmpxchg.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-fix-extreme-overreclaim-and-swap-floods.patch added to mm-hotfixes-unstable branch
Message-Id: <20220803172545.D195BC433D6@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm: vmscan: fix extreme overreclaim and swap floods
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-vmscan-fix-extreme-overreclaim-and-swap-floods.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmscan-fix-extreme-overreclaim-and-swap-floods.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: vmscan: fix extreme overreclaim and swap floods
Date: Tue, 2 Aug 2022 12:28:11 -0400

During proactive reclaim, we sometimes observe severe overreclaim, with
several thousand times more pages reclaimed than requested.

This trace was obtained from shrink_lruvec() during such an instance:

    prio:0 anon_cost:1141521 file_cost:7767
    nr_reclaimed:4387406 nr_to_reclaim:1047 (or_factor:4190)
    nr=[7161123 345 578 1111]

While he reclaimer requested 4M, vmscan reclaimed close to 16G, most of it
by swapping.  These requests take over a minute, during which the write()
to memory.reclaim is unkillably stuck inside the kernel.

Digging into the source, this is caused by the proportional reclaim
bailout logic.  This code tries to resolve a fundamental conflict: to
reclaim roughly what was requested, while also aging all LRUs fairly and
in accordance to their size, swappiness, refault rates etc.  The way it
attempts fairness is that once the reclaim goal has been reached, it stops
scanning the LRUs with the smaller remaining scan targets, and adjusts the
remainder of the bigger LRUs according to how much of the smaller LRUs was
scanned.  It then finishes scanning that remainder regardless of the
reclaim goal.

This works fine if priority levels are low and the LRU lists are
comparable in size.  However, in this instance, the cgroup that is
targeted by proactive reclaim has almost no files left - they've already
been squeezed out by proactive reclaim earlier - and the remaining anon
pages are hot.  Anon rotations cause the priority level to drop to 0,
which results in reclaim targeting all of anon (a lot) and all of file
(almost nothing).  By the time reclaim decides to bail, it has scanned
most or all of the file target, and therefor must also scan most or all of
the enormous anon target.  This target is thousands of times larger than
the reclaim goal, thus causing the overreclaim.

The bailout code hasn't changed in years, why is this failing now?  The
most likely explanations are two other recent changes in anon reclaim:

1. Before the series starting with commit 5df741963d52 ("mm: fix LRU
   balancing effect of new transparent huge pages"), the VM was
   overall relatively reluctant to swap at all, even if swap was
   configured. This means the LRU balancing code didn't come into play
   as often as it does now, and mostly in high pressure situations
   where pronounced swap activity wouldn't be as surprising.

2. For historic reasons, shrink_lruvec() loops on the scan targets of
   all LRU lists except the active anon one, meaning it would bail if
   the only remaining pages to scan were active anon - even if there
   were a lot of them.

   Before the series starting with commit ccc5dc67340c ("mm/vmscan:
   make active/inactive ratio as 1:1 for anon lru"), most anon pages
   would live on the active LRU; the inactive one would contain only a
   handful of preselected reclaim candidates. After the series, anon
   gets aged similarly to file, and the inactive list is the default
   for new anon pages as well, making it often the much bigger list.

   As a result, the VM is now more likely to actually finish large
   anon targets than before.

Change the code such that only one SWAP_CLUSTER_MAX-sized nudge toward the
larger LRU lists is made before bailing out on a met reclaim goal.

This fixes the extreme overreclaim problem.

Fairness is more subtle and harder to evaluate.  No obvious misbehavior
was observed on the test workload, in any case.  Conceptually, fairness
should primarily be a cumulative effect from regular, lower priority
scans.  Once the VM is in trouble and needs to escalate scan targets to
make forward progress, fairness needs to take a backseat.  This is also
acknowledged by the myriad exceptions in get_scan_count().  This patch
makes fairness decrease gradually, as it keeps fairness work static over
increasing priority levels with growing scan targets.  This should make
more sense - although we may have to re-visit the exact values.

Link: https://lkml.kernel.org/r/20220802162811.39216-1-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Hugh Dickins <hughd@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-fix-extreme-overreclaim-and-swap-floods
+++ a/mm/vmscan.c
@@ -2897,8 +2897,8 @@ static void shrink_lruvec(struct lruvec
 	enum lru_list lru;
 	unsigned long nr_reclaimed = 0;
 	unsigned long nr_to_reclaim = sc->nr_to_reclaim;
+	bool proportional_reclaim;
 	struct blk_plug plug;
-	bool scan_adjusted;
 
 	get_scan_count(lruvec, sc, nr);
 
@@ -2916,8 +2916,8 @@ static void shrink_lruvec(struct lruvec
 	 * abort proportional reclaim if either the file or anon lru has already
 	 * dropped to zero at the first pass.
 	 */
-	scan_adjusted = (!cgroup_reclaim(sc) && !current_is_kswapd() &&
-			 sc->priority == DEF_PRIORITY);
+	proportional_reclaim = (!cgroup_reclaim(sc) && !current_is_kswapd() &&
+				sc->priority == DEF_PRIORITY);
 
 	blk_start_plug(&plug);
 	while (nr[LRU_INACTIVE_ANON] || nr[LRU_ACTIVE_FILE] ||
@@ -2937,7 +2937,7 @@ static void shrink_lruvec(struct lruvec
 
 		cond_resched();
 
-		if (nr_reclaimed < nr_to_reclaim || scan_adjusted)
+		if (nr_reclaimed < nr_to_reclaim || proportional_reclaim)
 			continue;
 
 		/*
@@ -2988,8 +2988,6 @@ static void shrink_lruvec(struct lruvec
 		nr_scanned = targets[lru] - nr[lru];
 		nr[lru] = targets[lru] * (100 - percentage) / 100;
 		nr[lru] -= min(nr[lru], nr_scanned);
-
-		scan_adjusted = true;
 	}
 	blk_finish_plug(&plug);
 	sc->nr_reclaimed += nr_reclaimed;
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-vmscan-fix-extreme-overreclaim-and-swap-floods.patch

