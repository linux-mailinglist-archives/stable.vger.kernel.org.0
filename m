Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 574A14F2664
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 10:04:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233327AbiDEIGL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:06:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233662AbiDEH5V (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 03:57:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3B6C4ECE1;
        Tue,  5 Apr 2022 00:51:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 267CCB81B14;
        Tue,  5 Apr 2022 07:51:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81B54C340EE;
        Tue,  5 Apr 2022 07:51:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145074;
        bh=ZkPn8vgZSn8lvUhyYRFLomT1I0yuLZJEQIoFr4nuX4s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ngY7JyZ/aqQTOqTbaO04p/xajA/mrIccupgsc2ZVt4kFlSbKQi/dlNEr04dImgPXE
         Wst9eHeVwAuOiWlaNefnGC+LECWekwMd/S2nFvSgu23oNGO9eyHBFNKNygdHWEjphd
         XpzxAhCvzMpDpCxr4Ll8FD6grgatcFrzI3vQzMwI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mel Gorman <mgorman@techsingularity.net>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        "Gautham R. Shenoy" <gautham.shenoy@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0276/1126] sched/fair: Improve consistency of allowed NUMA balance calculations
Date:   Tue,  5 Apr 2022 09:17:03 +0200
Message-Id: <20220405070415.711225372@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
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

[ Upstream commit 2cfb7a1b031b0e816af7a6ee0c6ab83b0acdf05a ]

There are inconsistencies when determining if a NUMA imbalance is allowed
that should be corrected.

o allow_numa_imbalance changes types and is not always examining
  the destination group so both the type should be corrected as
  well as the naming.
o find_idlest_group uses the sched_domain's weight instead of the
  group weight which is different to find_busiest_group
o find_busiest_group uses the source group instead of the destination
  which is different to task_numa_find_cpu
o Both find_idlest_group and find_busiest_group should account
  for the number of running tasks if a move was allowed to be
  consistent with task_numa_find_cpu

Fixes: 7d2b5dd0bcc4 ("sched/numa: Allow a floating imbalance between NUMA nodes")
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Gautham R. Shenoy <gautham.shenoy@amd.com>
Link: https://lore.kernel.org/r/20220208094334.16379-2-mgorman@techsingularity.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 5146163bfabb..cddcf2f4f525 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -9040,9 +9040,10 @@ static bool update_pick_idlest(struct sched_group *idlest,
  * This is an approximation as the number of running tasks may not be
  * related to the number of busy CPUs due to sched_setaffinity.
  */
-static inline bool allow_numa_imbalance(int dst_running, int dst_weight)
+static inline bool
+allow_numa_imbalance(unsigned int running, unsigned int weight)
 {
-	return (dst_running < (dst_weight >> 2));
+	return (running < (weight >> 2));
 }
 
 /*
@@ -9176,12 +9177,13 @@ find_idlest_group(struct sched_domain *sd, struct task_struct *p, int this_cpu)
 				return idlest;
 #endif
 			/*
-			 * Otherwise, keep the task on this node to stay close
-			 * its wakeup source and improve locality. If there is
-			 * a real need of migration, periodic load balance will
-			 * take care of it.
+			 * Otherwise, keep the task close to the wakeup source
+			 * and improve locality if the number of running tasks
+			 * would remain below threshold where an imbalance is
+			 * allowed. If there is a real need of migration,
+			 * periodic load balance will take care of it.
 			 */
-			if (allow_numa_imbalance(local_sgs.sum_nr_running, sd->span_weight))
+			if (allow_numa_imbalance(local_sgs.sum_nr_running + 1, local_sgs.group_weight))
 				return NULL;
 		}
 
@@ -9387,7 +9389,7 @@ static inline void calculate_imbalance(struct lb_env *env, struct sd_lb_stats *s
 		/* Consider allowing a small imbalance between NUMA groups */
 		if (env->sd->flags & SD_NUMA) {
 			env->imbalance = adjust_numa_imbalance(env->imbalance,
-				busiest->sum_nr_running, busiest->group_weight);
+				local->sum_nr_running + 1, local->group_weight);
 		}
 
 		return;
-- 
2.34.1



