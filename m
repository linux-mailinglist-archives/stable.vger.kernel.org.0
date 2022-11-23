Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8075C634E0E
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 03:53:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235618AbiKWCx5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Nov 2022 21:53:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235619AbiKWCxo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Nov 2022 21:53:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5517713DFC;
        Tue, 22 Nov 2022 18:53:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 06F54B81E5C;
        Wed, 23 Nov 2022 02:53:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95A60C433D6;
        Wed, 23 Nov 2022 02:53:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669172010;
        bh=VBIdbsv1gZpQJ2FTebTStYzW5jcXQpOPHBseZDBvLXg=;
        h=Date:To:From:Subject:From;
        b=SkIsVuwgxB25uWzWzEJVb42o9XTb0Ge7C+ZJC7QXaAL/xx5FG25jJYNvlJRfclZ7N
         xk618jyxcHA78PO0zEqnalZiF4pfjtFXU59uAvpqBs3IUNMFAD1NzGkmjtxmZaFzTo
         cP7NCZt2/gtRt3Twp2ZG23K6Dvv11IMHuHpgrB7U=
Date:   Tue, 22 Nov 2022 18:53:29 -0800
To:     mm-commits@vger.kernel.org, tj@kernel.org, stable@vger.kernel.org,
        lizefan.x@bytedance.com, hannes@cmpxchg.org,
        aneesh.kumar@linux.ibm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-cgroup-reclaim-fix-dirty-pages-throttling-on-cgroup-v1.patch removed from -mm tree
Message-Id: <20221123025330.95A60C433D6@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: mm/cgroup/reclaim: fix dirty pages throttling on cgroup v1
has been removed from the -mm tree.  Its filename was
     mm-cgroup-reclaim-fix-dirty-pages-throttling-on-cgroup-v1.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: mm/cgroup/reclaim: fix dirty pages throttling on cgroup v1
Date: Fri, 18 Nov 2022 12:36:03 +0530

balance_dirty_pages doesn't do the required dirty throttling on cgroupv1. 
See commit 9badce000e2c ("cgroup, writeback: don't enable cgroup writeback
on traditional hierarchies").  Instead, the kernel depends on writeback
throttling in shrink_folio_list to achieve the same goal.  With large
memory systems, the flusher may not be able to writeback quickly enough
such that we will start finding pages in the shrink_folio_list already in
writeback.  Hence for cgroupv1 let's do a reclaim throttle after waking up
the flusher.

The below test which used to fail on a 256GB system completes till the the
file system is full with this change.

root@lp2:/sys/fs/cgroup/memory# mkdir test
root@lp2:/sys/fs/cgroup/memory# cd test/
root@lp2:/sys/fs/cgroup/memory/test# echo 120M > memory.limit_in_bytes
root@lp2:/sys/fs/cgroup/memory/test# echo $$ > tasks
root@lp2:/sys/fs/cgroup/memory/test# dd if=/dev/zero of=/home/kvaneesh/test bs=1M
Killed

Link: https://lkml.kernel.org/r/20221118070603.84081-1-aneesh.kumar@linux.ibm.com
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: zefan li <lizefan.x@bytedance.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

--- a/mm/vmscan.c~mm-cgroup-reclaim-fix-dirty-pages-throttling-on-cgroup-v1
+++ a/mm/vmscan.c
@@ -2514,8 +2514,20 @@ static unsigned long shrink_inactive_lis
 	 * the flushers simply cannot keep up with the allocation
 	 * rate. Nudge the flusher threads in case they are asleep.
 	 */
-	if (stat.nr_unqueued_dirty == nr_taken)
+	if (stat.nr_unqueued_dirty == nr_taken) {
 		wakeup_flusher_threads(WB_REASON_VMSCAN);
+		/*
+		 * For cgroupv1 dirty throttling is achieved by waking up
+		 * the kernel flusher here and later waiting on folios
+		 * which are in writeback to finish (see shrink_folio_list()).
+		 *
+		 * Flusher may not be able to issue writeback quickly
+		 * enough for cgroupv1 writeback throttling to work
+		 * on a large system.
+		 */
+		if (!writeback_throttling_sane(sc))
+			reclaim_throttle(pgdat, VMSCAN_THROTTLE_WRITEBACK);
+	}
 
 	sc->nr.dirty += stat.nr_dirty;
 	sc->nr.congested += stat.nr_congested;
_

Patches currently in -mm which might be from aneesh.kumar@linux.ibm.com are


