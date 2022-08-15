Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 825675946DF
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 01:04:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344667AbiHOXC5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:02:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352997AbiHOXBu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:01:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D68D13F207;
        Mon, 15 Aug 2022 12:58:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DF337612BC;
        Mon, 15 Aug 2022 19:58:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0AAFC433D6;
        Mon, 15 Aug 2022 19:58:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660593481;
        bh=pSqFm/F+9c2KAa07HAvyYA0Ppsjj8HHDA+WUMgJeHDU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DTiPLbAX0T4AfNg6X8gIBYSfF9rDJHxcc2exgmTh0zuSlwtD2QTRgyKAB9DpRS/QI
         S3AAAumMDg0Wz/FZOgykVLPRu/+eMjlfA9d72I7rAf72ZtYqvJkDqV35xK6xDstVZd
         24lVKL9Qjtp6IlehHrpxyL8eoVWjGuKfrOKZZ3ng=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mel Gorman <mgorman@techsingularity.net>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0952/1095] sched/core: Do not requeue task on CPU excluded from cpus_mask
Date:   Mon, 15 Aug 2022 20:05:51 +0200
Message-Id: <20220815180508.490711459@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mel Gorman <mgorman@techsingularity.net>

[ Upstream commit 751d4cbc43879229dbc124afefe240b70fd29a85 ]

The following warning was triggered on a large machine early in boot on
a distribution kernel but the same problem should also affect mainline.

   WARNING: CPU: 439 PID: 10 at ../kernel/workqueue.c:2231 process_one_work+0x4d/0x440
   Call Trace:
    <TASK>
    rescuer_thread+0x1f6/0x360
    kthread+0x156/0x180
    ret_from_fork+0x22/0x30
    </TASK>

Commit c6e7bd7afaeb ("sched/core: Optimize ttwu() spinning on p->on_cpu")
optimises ttwu by queueing a task that is descheduling on the wakelist,
but does not check if the task descheduling is still allowed to run on that CPU.

In this warning, the problematic task is a workqueue rescue thread which
checks if the rescue is for a per-cpu workqueue and running on the wrong CPU.
While this is early in boot and it should be possible to create workers,
the rescue thread may still used if the MAYDAY_INITIAL_TIMEOUT is reached
or MAYDAY_INTERVAL and on a sufficiently large machine, the rescue
thread is being used frequently.

Tracing confirmed that the task should have migrated properly using the
stopper thread to handle the migration. However, a parallel wakeup from udev
running on another CPU that does not share CPU cache observes p->on_cpu and
uses task_cpu(p), queues the task on the old CPU and triggers the warning.

Check that the wakee task that is descheduling is still allowed to run
on its current CPU and if not, wait for the descheduling to complete
and select an allowed CPU.

Fixes: c6e7bd7afaeb ("sched/core: Optimize ttwu() spinning on p->on_cpu")
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://lore.kernel.org/r/20220804092119.20137-1-mgorman@techsingularity.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/core.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index df4a8c9d1070..9671796a11cc 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3811,7 +3811,7 @@ bool cpus_share_cache(int this_cpu, int that_cpu)
 	return per_cpu(sd_llc_id, this_cpu) == per_cpu(sd_llc_id, that_cpu);
 }
 
-static inline bool ttwu_queue_cond(int cpu)
+static inline bool ttwu_queue_cond(struct task_struct *p, int cpu)
 {
 	/*
 	 * Do not complicate things with the async wake_list while the CPU is
@@ -3820,6 +3820,10 @@ static inline bool ttwu_queue_cond(int cpu)
 	if (!cpu_active(cpu))
 		return false;
 
+	/* Ensure the task will still be allowed to run on the CPU. */
+	if (!cpumask_test_cpu(cpu, p->cpus_ptr))
+		return false;
+
 	/*
 	 * If the CPU does not share cache, then queue the task on the
 	 * remote rqs wakelist to avoid accessing remote data.
@@ -3849,7 +3853,7 @@ static inline bool ttwu_queue_cond(int cpu)
 
 static bool ttwu_queue_wakelist(struct task_struct *p, int cpu, int wake_flags)
 {
-	if (sched_feat(TTWU_QUEUE) && ttwu_queue_cond(cpu)) {
+	if (sched_feat(TTWU_QUEUE) && ttwu_queue_cond(p, cpu)) {
 		sched_clock_cpu(cpu); /* Sync clocks across CPUs */
 		__ttwu_queue_wakelist(p, cpu, wake_flags);
 		return true;
-- 
2.35.1



