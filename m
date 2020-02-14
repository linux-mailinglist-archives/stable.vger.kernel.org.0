Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA63015D16F
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 06:22:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726049AbgBNFWb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 00:22:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:48760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725775AbgBNFWb (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 00:22:31 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C3891222C4;
        Fri, 14 Feb 2020 05:22:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581657748;
        bh=/vtfwswc40NS8lK08a1AAwRS9rZHgQOcV3kwcVVlDU8=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=teMMnk774MwcOJ4ZljfstVfOXcw2sVh6MwWW1IWqr5m9LSwVvDqfYiVX78g5rTi2H
         eGXiHUrpTfcBA+2lNwOvFK4o9bqzcG6Hr3evzcanV69KQSHjwimJIq9sudo0V5jZpS
         gk/exmwkl08Az2/Rdgvy7D2piqNnbyafQYaniutk=
Date:   Thu, 13 Feb 2020 21:22:28 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     gshan@redhat.com, guro@fb.com, mm-commits@vger.kernel.org,
        stable@vger.kernel.org
Subject:  +
 mm-vmscan-dont-round-up-scan-size-for-online-memory-cgroup.patch added to
 -mm tree
Message-ID: <20200214052228.qry-CKsYL%akpm@linux-foundation.org>
In-Reply-To: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/vmscan.c: don't round up scan size for online memory cgroup
has been added to the -mm tree.  Its filename is
     mm-vmscan-dont-round-up-scan-size-for-online-memory-cgroup.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmscan-dont-round-up-scan-size-for-online-memory-cgroup.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmscan-dont-round-up-scan-size-for-online-memory-cgroup.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-vmscan-dont-round-up-scan-size-for-online-memory-cgroup.patch

