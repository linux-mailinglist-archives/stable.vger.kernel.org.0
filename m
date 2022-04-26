Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0656950F7B5
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 11:40:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239095AbiDZJLY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 05:11:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343942AbiDZJID (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 05:08:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06470177D47;
        Tue, 26 Apr 2022 01:49:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B10FDB81CB3;
        Tue, 26 Apr 2022 08:49:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00C34C385AC;
        Tue, 26 Apr 2022 08:48:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650962939;
        bh=ZES7E+0Y2TILibhjpllfjIl6JKZW3P1Y1LfNzA7CmSk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f2C9zNQ3H4k899jy/IHOilmS+76pWTRjvbjt25u4uX+zvGe4BebEQwM3RyDDACA/b
         B6K1QMtq4tWuX/0J6fRxq5ZfvlDfyteve9Jl3CCLiz9uFOrlPQ5C/fx/tUMiYhVc4L
         Xu62PpuZMlZdG9J/D+E721vFnjsdUmBvkbHiI7oE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kuyo chang <kuyo.chang@mediatek.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 102/146] sched/pelt: Fix attach_entity_load_avg() corner case
Date:   Tue, 26 Apr 2022 10:21:37 +0200
Message-Id: <20220426081752.925631276@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081750.051179617@linuxfoundation.org>
References: <20220426081750.051179617@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: kuyo chang <kuyo.chang@mediatek.com>

[ Upstream commit 40f5aa4c5eaebfeaca4566217cb9c468e28ed682 ]

The warning in cfs_rq_is_decayed() triggered:

    SCHED_WARN_ON(cfs_rq->avg.load_avg ||
		  cfs_rq->avg.util_avg ||
		  cfs_rq->avg.runnable_avg)

There exists a corner case in attach_entity_load_avg() which will
cause load_sum to be zero while load_avg will not be.

Consider se_weight is 88761 as per the sched_prio_to_weight[] table.
Further assume the get_pelt_divider() is 47742, this gives:
se->avg.load_avg is 1.

However, calculating load_sum:

  se->avg.load_sum = div_u64(se->avg.load_avg * se->avg.load_sum, se_weight(se));
  se->avg.load_sum = 1*47742/88761 = 0.

Then enqueue_load_avg() adds this to the cfs_rq totals:

  cfs_rq->avg.load_avg += se->avg.load_avg;
  cfs_rq->avg.load_sum += se_weight(se) * se->avg.load_sum;

Resulting in load_avg being 1 with load_sum is 0, which will trigger
the WARN.

Fixes: f207934fb79d ("sched/fair: Align PELT windows between cfs_rq and its se")
Signed-off-by: kuyo chang <kuyo.chang@mediatek.com>
[peterz: massage changelog]
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Vincent Guittot <vincent.guittot@linaro.org>
Tested-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
Link: https://lkml.kernel.org/r/20220414090229.342-1-kuyo.chang@mediatek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index cddcf2f4f525..2f461f059278 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3776,11 +3776,11 @@ static void attach_entity_load_avg(struct cfs_rq *cfs_rq, struct sched_entity *s
 
 	se->avg.runnable_sum = se->avg.runnable_avg * divider;
 
-	se->avg.load_sum = divider;
-	if (se_weight(se)) {
-		se->avg.load_sum =
-			div_u64(se->avg.load_avg * se->avg.load_sum, se_weight(se));
-	}
+	se->avg.load_sum = se->avg.load_avg * divider;
+	if (se_weight(se) < se->avg.load_sum)
+		se->avg.load_sum = div_u64(se->avg.load_sum, se_weight(se));
+	else
+		se->avg.load_sum = 1;
 
 	enqueue_load_avg(cfs_rq, se);
 	cfs_rq->avg.util_avg += se->avg.util_avg;
-- 
2.35.1



