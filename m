Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCCB9169B53
	for <lists+stable@lfdr.de>; Mon, 24 Feb 2020 01:44:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727202AbgBXAo5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Feb 2020 19:44:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:40112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727188AbgBXAo5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 23 Feb 2020 19:44:57 -0500
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9CA8E2071C;
        Mon, 24 Feb 2020 00:44:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582505096;
        bh=owTlVHrBOcN82GbzLHfXwjgriJ3efU6wTZtNPkfJsL0=;
        h=Date:From:To:Subject:From;
        b=Rd0nRQHahvhrN8QlZZQ55sZwSPMaZX4KPwNlVZLq1M0/1cK4O66qkGQXXL9ICMQxO
         kHs+csmDcsv9dAT9WTgdgMm5SrezwUPJ7LOoBfS0CMWM+scFDCxgRQpQhFI6dPfP2E
         SvUUFKGcDTzHxYUZwuc+WYB6/665OUFzlkfblDCw=
Date:   Sun, 23 Feb 2020 16:44:56 -0800
From:   akpm@linux-foundation.org
To:     gshan@redhat.com, guro@fb.com, mm-commits@vger.kernel.org,
        stable@vger.kernel.org
Subject:  [merged]
 mm-vmscan-dont-round-up-scan-size-for-online-memory-cgroup.patch removed
 from -mm tree
Message-ID: <20200224004456.22rPmLEjv%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/vmscan.c: don't round up scan size for online memory cgroup
has been removed from the -mm tree.  Its filename was
     mm-vmscan-dont-round-up-scan-size-for-online-memory-cgroup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Gavin Shan <gshan@redhat.com>
Subject: mm/vmscan.c: don't round up scan size for online memory cgroup

commit 68600f623d69 ("mm: don't miss the last page because of round-off
error") makes the scan size round up to @denominator regardless of the
memory cgroup's state, online or offline.  This affects the overall
reclaiming behavior: The corresponding LRU list is eligible for reclaiming
only when its size logically right shifted by @sc->priority is bigger than
zero in the former formula.  For example, the inactive anonymous LRU list
should have at least 0x4000 pages to be eligible for reclaiming when we
have 60/12 for swappiness/priority and without taking scan/rotation ratio
into account.  After the roundup is applied, the inactive anonymous LRU
list becomes eligible for reclaiming when its size is bigger than or equal
to 0x1000 in the same condition.

    (0x4000 >> 12) * 60 / (60 + 140 + 1) = 1
    ((0x1000 >> 12) * 60) + 200) / (60 + 140 + 1) = 1

aarch64 has 512MB huge page size when the base page size is 64KB.  The
memory cgroup that has a huge page is always eligible for reclaiming in
that case.  The reclaiming is likely to stop after the huge page is
reclaimed, meaing the further iteration on @sc->priority and the silbing
and child memory cgroups will be skipped.  The overall behaviour has been
changed.  This fixes the issue by applying the roundup to offlined memory
cgroups only, to give more preference to reclaim memory from offlined
memory cgroup.  It sounds reasonable as those memory is unlikedly to be
used by anyone.

The issue was found by starting up 8 VMs on a Ampere Mustang machine,
which has 8 CPUs and 16 GB memory.  Each VM is given with 2 vCPUs and 2GB
memory.  It took 264 seconds for all VMs to be completely up and 784MB
swap is consumed after that.  With this patch applied, it took 236 seconds
and 60MB swap to do same thing.  So there is 10% performance improvement
for my case.  Note that KSM is disable while THP is enabled in the
testing.

         total     used    free   shared  buff/cache   available
   Mem:  16196    10065    2049       16        4081        3749
   Swap:  8175      784    7391
         total     used    free   shared  buff/cache   available
   Mem:  16196    11324    3656       24        1215        2936
   Swap:  8175       60    8115

Link: http://lkml.kernel.org/r/20200211024514.8730-1-gshan@redhat.com
Fixes: 68600f623d69 ("mm: don't miss the last page because of round-off error")
Signed-off-by: Gavin Shan <gshan@redhat.com>
Acked-by: Roman Gushchin <guro@fb.com>
Cc: <stable@vger.kernel.org>	[4.20+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-dont-round-up-scan-size-for-online-memory-cgroup
+++ a/mm/vmscan.c
@@ -2415,10 +2415,13 @@ out:
 			/*
 			 * Scan types proportional to swappiness and
 			 * their relative recent reclaim efficiency.
-			 * Make sure we don't miss the last page
-			 * because of a round-off error.
+			 * Make sure we don't miss the last page on
+			 * the offlined memory cgroups because of a
+			 * round-off error.
 			 */
-			scan = DIV64_U64_ROUND_UP(scan * fraction[file],
+			scan = mem_cgroup_online(memcg) ?
+			       div64_u64(scan * fraction[file], denominator) :
+			       DIV64_U64_ROUND_UP(scan * fraction[file],
 						  denominator);
 			break;
 		case SCAN_FILE:
_

Patches currently in -mm which might be from gshan@redhat.com are


