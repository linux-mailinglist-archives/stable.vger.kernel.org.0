Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEC094B4C36
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 11:44:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348455AbiBNKh5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 05:37:57 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350109AbiBNKgv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 05:36:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADD2FA66C5;
        Mon, 14 Feb 2022 02:03:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C0BB560C78;
        Mon, 14 Feb 2022 10:02:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B63FC340E9;
        Mon, 14 Feb 2022 10:02:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644832979;
        bh=YzWY9DyK/NtUaJJtUxtgpppL0Zx34Zk2t0AZEQEWWjc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TdOFCHeYQaf10RHHHNEYxqS47Fq/vyLrNkccTlfBC/jtdDqgX4eak3iWfjlfj52oC
         sIaBKvL0uGCnG/QHDPQjk51fahidjbs5oYJ4jkytikqga+DMMomBLUMHQBZn+/nRfk
         aN4t475WxPlzlfcAVs/E/SiScBL1KYeCTY6txeBs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mel Gorman <mgorman@suse.de>,
        Vlastimil Babka <vbabka@suse.cz>,
        Michal Hocko <mhocko@suse.com>,
        David Rientjes <rientjes@google.com>,
        Hugh Dickins <hughd@google.com>,
        Rik van Riel <riel@surriel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.16 186/203] mm: vmscan: remove deadlock due to throttling failing to make progress
Date:   Mon, 14 Feb 2022 10:27:10 +0100
Message-Id: <20220214092516.564535162@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092510.221474733@linuxfoundation.org>
References: <20220214092510.221474733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mel Gorman <mgorman@suse.de>

commit b485c6f1f9f54b81443efda5f3d8a5036ba2cd91 upstream.

A soft lockup bug in kcompactd was reported in a private bugzilla with
the following visible in dmesg;

  watchdog: BUG: soft lockup - CPU#33 stuck for 26s! [kcompactd0:479]
  watchdog: BUG: soft lockup - CPU#33 stuck for 52s! [kcompactd0:479]
  watchdog: BUG: soft lockup - CPU#33 stuck for 78s! [kcompactd0:479]
  watchdog: BUG: soft lockup - CPU#33 stuck for 104s! [kcompactd0:479]

The machine had 256G of RAM with no swap and an earlier failed
allocation indicated that node 0 where kcompactd was run was potentially
unreclaimable;

  Node 0 active_anon:29355112kB inactive_anon:2913528kB active_file:0kB
    inactive_file:0kB unevictable:64kB isolated(anon):0kB isolated(file):0kB
    mapped:8kB dirty:0kB writeback:0kB shmem:26780kB shmem_thp:
    0kB shmem_pmdmapped: 0kB anon_thp: 23480320kB writeback_tmp:0kB
    kernel_stack:2272kB pagetables:24500kB all_unreclaimable? yes

Vlastimil Babka investigated a crash dump and found that a task
migrating pages was trying to drain PCP lists;

  PID: 52922  TASK: ffff969f820e5000  CPU: 19  COMMAND: "kworker/u128:3"
  Call Trace:
     __schedule
     schedule
     schedule_timeout
     wait_for_completion
     __flush_work
     __drain_all_pages
     __alloc_pages_slowpath.constprop.114
     __alloc_pages
     alloc_migration_target
     migrate_pages
     migrate_to_node
     do_migrate_pages
     cpuset_migrate_mm_workfn
     process_one_work
     worker_thread
     kthread
     ret_from_fork

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
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/vmscan.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/vmscan.c
+++ b/mm/vmscan.c
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


