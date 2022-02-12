Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C3CF4B3206
	for <lists+stable@lfdr.de>; Sat, 12 Feb 2022 01:32:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354407AbiBLAci (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Feb 2022 19:32:38 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231404AbiBLAcd (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Feb 2022 19:32:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36BF0D7E;
        Fri, 11 Feb 2022 16:32:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C740461D1F;
        Sat, 12 Feb 2022 00:32:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21B7AC340EB;
        Sat, 12 Feb 2022 00:32:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1644625950;
        bh=oeJKDJ1bkgfhW/gRKDnHsKnyYro9XJZrr1UCVplP8x8=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=JI3CFhY5yd/fKS0RMJJ43TIpMsBrIjlKm0fg/i4g7G2JOnoYMHJubValwr7wiK0lx
         735CPj/Tu1mHo3FB2qJhe05aF37W+8TyPywe3O5HbSVdXO9TWfkTmisgzz/0cpZbyG
         rrOrWwpAXj0uy1EHYSW38hJPq2kNhhBJ43bemFVU=
Date:   Fri, 11 Feb 2022 16:32:29 -0800
To:     vbabka@suse.cz, stable@vger.kernel.org, rientjes@google.com,
        riel@surriel.com, mhocko@suse.com, hughd@google.com,
        mgorman@suse.de, akpm@linux-foundation.org,
        patches@lists.linux.dev, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220211162756.9f8e8baef81183041ccfc16f@linux-foundation.org>
Subject: [patch 3/5] mm: vmscan: remove deadlock due to throttling failing to make progress
Message-Id: <20220212003230.21B7AC340EB@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Acked-by: David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


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
