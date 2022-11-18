Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C332962FFCB
	for <lists+stable@lfdr.de>; Fri, 18 Nov 2022 23:10:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231410AbiKRWKz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Nov 2022 17:10:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231593AbiKRWKb (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Nov 2022 17:10:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E54B2CCB6;
        Fri, 18 Nov 2022 14:10:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3C401B8244B;
        Fri, 18 Nov 2022 22:10:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5001C433D6;
        Fri, 18 Nov 2022 22:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668809409;
        bh=zmafu9SY9SBWuNfFRAYFdCnk9NhjPBb2UiuyBYRsJaU=;
        h=Date:To:From:Subject:From;
        b=Q8fq01HyHfr6fNZOG057QCJvUp55AT4OQceyLUTSNRD5qZm3H96XekEoYQxZQkXLK
         Zgdy39nz9S5QDah+MmFRlBEZF4PIlbo1xZrjwI4SwjsclrolVJXhd17Kkekuv+3Hs5
         G4o0I2427WLgSHMvODEO2p/NW6c6/o+zyWRf8okg=
Date:   Fri, 18 Nov 2022 14:10:08 -0800
To:     mm-commits@vger.kernel.org, tj@kernel.org, stable@vger.kernel.org,
        lizefan.x@bytedance.com, hannes@cmpxchg.org,
        aneesh.kumar@linux.ibm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-cgroup-reclaim-fix-dirty-pages-throttling-on-cgroup-v1.patch added to mm-hotfixes-unstable branch
Message-Id: <20221118221008.D5001C433D6@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/cgroup/reclaim: fix dirty pages throttling on cgroup v1
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-cgroup-reclaim-fix-dirty-pages-throttling-on-cgroup-v1.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-cgroup-reclaim-fix-dirty-pages-throttling-on-cgroup-v1.patch

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

mm-cgroup-reclaim-fix-dirty-pages-throttling-on-cgroup-v1.patch

