Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00E264A9096
	for <lists+stable@lfdr.de>; Thu,  3 Feb 2022 23:20:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355767AbiBCWUP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Feb 2022 17:20:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229910AbiBCWUP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Feb 2022 17:20:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2300C061714;
        Thu,  3 Feb 2022 14:20:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4798EB835DB;
        Thu,  3 Feb 2022 22:20:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0C12C340E8;
        Thu,  3 Feb 2022 22:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643926812;
        bh=i4v7hZDD9ywDByBUn1XanxjIvJKlM913PCZVLBQ0JJo=;
        h=Date:To:From:Subject:From;
        b=bumKYSZfnjOS16K4zws6nKGUEODGVfuQBhiig7Y9/CuzeBWLk0eLEQ3hHKeDGa3dm
         CzDIf3FwQvauo7sic/f1TuHqCR1Fj+uIsltbXwc69RGtWaqsOpjW0D+4g8oLIyiGew
         LsGee9fbT67Uh+sNmamUwCRabNiM16r56mEYq9wo=
Received: by hp1 (sSMTP sendmail emulation); Thu, 03 Feb 2022 14:20:10 -0800
Date:   Thu, 03 Feb 2022 14:20:10 -0800
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, stable@vger.kernel.org,
        riel@surriel.com, mhocko@suse.com, hughd@google.com,
        mgorman@suse.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-remove-deadlock-due-to-throttling-failing-to-make-progress.patch added to -mm tree
Message-Id: <20220203222010.D0C12C340E8@smtp.kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm: vmscan: remove deadlock due to throttling failing to make progress
has been added to the -mm tree.  Its filename is
     mm-vmscan-remove-deadlock-due-to-throttling-failing-to-make-progress.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-vmscan-remove-deadlock-due-to-throttling-failing-to-make-progress.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-vmscan-remove-deadlock-due-to-throttling-failing-to-make-progress.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: vmscan: remove deadlock due to throttling failing to make progress

A soft lockup bug in kcompactd was reported in a private bugzilla with
the following visible in dmesg;

[15980.045209][   C33] watchdog: BUG: soft lockup - CPU#33 stuck for 26s! [kcompactd0:479]
[16008.044989][   C33] watchdog: BUG: soft lockup - CPU#33 stuck for 52s! [kcompactd0:479]
[16036.044768][   C33] watchdog: BUG: soft lockup - CPU#33 stuck for 78s! [kcompactd0:479]
[16064.044548][   C33] watchdog: BUG: soft lockup - CPU#33 stuck for 104s! [kcompactd0:479]

The machine had 256G of RAM with no swap and an earlier failed allocation
indicated that node 0 where kcompactd was run was potentially
unreclaimable;

Node 0 active_anon:29355112kB inactive_anon:2913528kB active_file:0kB
  inactive_file:0kB unevictable:64kB isolated(anon):0kB isolated(file):0kB
  mapped:8kB dirty:0kB writeback:0kB shmem:26780kB shmem_thp:
  0kB shmem_pmdmapped: 0kB anon_thp: 23480320kB writeback_tmp:0kB
  kernel_stack:2272kB pagetables:24500kB all_unreclaimable? yes

Vlastimil Babka investigated a crash dump and found that a task migrating pages
was trying to drain PCP lists;

PID: 52922  TASK: ffff969f820e5000  CPU: 19  COMMAND: "kworker/u128:3"
 #0 [ffffaf4e4f4c3848] __schedule at ffffffffb840116d
 #1 [ffffaf4e4f4c3908] schedule at ffffffffb8401e81
 #2 [ffffaf4e4f4c3918] schedule_timeout at ffffffffb84066e8
 #3 [ffffaf4e4f4c3990] wait_for_completion at ffffffffb8403072
 #4 [ffffaf4e4f4c39d0] __flush_work at ffffffffb7ac3e4d
 #5 [ffffaf4e4f4c3a48] __drain_all_pages at ffffffffb7cb707c
 #6 [ffffaf4e4f4c3a80] __alloc_pages_slowpath.constprop.114 at ffffffffb7cbd9dd
 #7 [ffffaf4e4f4c3b60] __alloc_pages at ffffffffb7cbe4f5
 #8 [ffffaf4e4f4c3bc0] alloc_migration_target at ffffffffb7cf329c
 #9 [ffffaf4e4f4c3bf0] migrate_pages at ffffffffb7cf6d15
 10 [ffffaf4e4f4c3cb0] migrate_to_node at ffffffffb7cdb5aa
 11 [ffffaf4e4f4c3da8] do_migrate_pages at ffffffffb7cdcf26
 12 [ffffaf4e4f4c3e88] cpuset_migrate_mm_workfn at ffffffffb7b859d2
 13 [ffffaf4e4f4c3e98] process_one_work at ffffffffb7ac45f3
 14 [ffffaf4e4f4c3ed8] worker_thread at ffffffffb7ac47fd
 15 [ffffaf4e4f4c3f10] kthread at ffffffffb7acbdc6
 16 [ffffaf4e4f4c3f50] ret_from_fork at ffffffffb7a047e2

This failure is specific to CONFIG_PREEMPT=n builds.  The root of the
problem is that kcompact0 is not rescheduling on a CPU while a task that
has isolated a large number of the pages from the LRU is waiting on
kcompact0 to reschedule so the pages can be released.  While
shrink_inactive_list() only loops once around too_many_isolated, reclaim
can continue without rescheduling if sc->skipped_deactivate == 1 which
could happen if there was no file LRU and the inactive anon list was not
low.

Link: https://lkml.kernel.org/r/20220203100326.GD3301@suse.de
Fixes: d818fca1cac3 ("mm/vmscan: throttle reclaim and compaction when too may pages are isolated")
Signed-off-by: Mel Gorman <mgorman@suse.de>
Debugged-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/vmscan.c~mm-vmscan-remove-deadlock-due-to-throttling-failing-to-make-progress
+++ a/mm/vmscan.c
@@ -1066,8 +1066,10 @@ void reclaim_throttle(pg_data_t *pgdat,
 	 * forward progress (e.g. journalling workqueues or kthreads).
 	 */
 	if (!current_is_kswapd() &&
-	    current->flags & (PF_IO_WORKER|PF_KTHREAD))
+	    current->flags & (PF_IO_WORKER|PF_KTHREAD)) {
+		cond_resched();
 		return;
+	}
 
 	/*
 	 * These figures are pulled out of thin air.
_

Patches currently in -mm which might be from mgorman@suse.de are

mm-vmscan-remove-deadlock-due-to-throttling-failing-to-make-progress.patch

