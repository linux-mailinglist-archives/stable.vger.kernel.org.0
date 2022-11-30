Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0671A63E008
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:53:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231522AbiK3SxF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:53:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231514AbiK3Sw5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:52:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 547241EC6A
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:52:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0FEB261D76
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:52:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20657C433D6;
        Wed, 30 Nov 2022 18:52:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669834367;
        bh=Ffrg4MH1kKEzpy9NhJ2ONABLjMus7mc83yJw2bCzBfM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XAx9dxK6YAzb8L7/9nfap4XZI7R5nOQOU6vW/pbhiuujvSd1wXux7p5gsRaoE0WoW
         eSHRWnOUQtWMnCJzrRchTQ4XCz8h6PSn32+s7DuddwsmOXODMUtBuW1miIDoVihI4t
         Vq3J7K0dvgMr2iv3+w+4uhCUgHYbj6rXSp+nZfdI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Tejun Heo <tj@kernel.org>, zefan li <lizefan.x@bytedance.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.0 200/289] mm/cgroup/reclaim: fix dirty pages throttling on cgroup v1
Date:   Wed, 30 Nov 2022 19:23:05 +0100
Message-Id: <20221130180548.654898585@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>

commit 81a70c21d9170de67a45843bdd627f4cce9c4215 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/vmscan.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2472,8 +2472,20 @@ shrink_inactive_list(unsigned long nr_to
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


