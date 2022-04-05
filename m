Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 651224F31CA
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:46:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343755AbiDEJMo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:12:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244854AbiDEIwn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:52:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C892237D5;
        Tue,  5 Apr 2022 01:44:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CB70860FFC;
        Tue,  5 Apr 2022 08:44:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD01CC385A1;
        Tue,  5 Apr 2022 08:44:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649148293;
        bh=Fw5yvEs8qrDdncDvk2Na5/mnNyK7AlzuICs41EhKw+s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xsRUJl8IIipRNtBHXRaVcul1S29hLkypBroLr8PWXEx1jHQdj3XWvSM5oMgH6/g6+
         yYxgu+cjvAWCHbDpK5/CJdr9xszV4Q8xSFCr7Mw40LNdS+fc2YvPEycJ1O36LkkdZW
         ERfUm88Ka1mf0QtUVqqr1Ji5Ij4U1M0k0cDyaFrI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mel Gorman <mgorman@techsingularity.net>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        "Gautham R. Shenoy" <gautham.shenoy@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0266/1017] sched/fair: Improve consistency of allowed NUMA balance calculations
Date:   Tue,  5 Apr 2022 09:19:39 +0200
Message-Id: <20220405070402.159610553@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
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
index 069e01772d92..9637766e220d 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -9062,9 +9062,10 @@ static bool update_pick_idlest(struct sched_group *idlest,
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
@@ -9198,12 +9199,13 @@ find_idlest_group(struct sched_domain *sd, struct task_struct *p, int this_cpu)
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
 
@@ -9409,7 +9411,7 @@ static inline void calculate_imbalance(struct lb_env *env, struct sd_lb_stats *s
 		/* Consider allowing a small imbalance between NUMA groups */
 		if (env->sd->flags & SD_NUMA) {
 			env->imbalance = adjust_numa_imbalance(env->imbalance,
-				busiest->sum_nr_running, busiest->group_weight);
+				local->sum_nr_running + 1, local->group_weight);
 		}
 
 		return;
-- 
2.34.1



