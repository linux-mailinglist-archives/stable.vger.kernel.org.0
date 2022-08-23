Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BBFD59DF6A
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:35:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354156AbiHWKYv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 06:24:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354681AbiHWKV7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 06:21:59 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 747DA2DED;
        Tue, 23 Aug 2022 02:03:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 97C02CE1B40;
        Tue, 23 Aug 2022 09:03:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91142C433C1;
        Tue, 23 Aug 2022 09:03:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661245399;
        bh=RZW52RKR3Uudu0bjrdyowQavWiTMX177M9w5TtGXDzg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WWqKQTp89OIXzI5vkTS97YxnUbNF93d9wiqXyzAnRYPRppWFXyYRgTaqPkue1GAp4
         O98PTbXFu3TJ0M202Z2IY+WPfYtgYe0Bg3jcYLxHItyNTIX+PWmFqM2HpBWsDxk6/a
         4QQ2Ki64JlSOX6hi1wyLlW6oaeIcxGCJI7B1KmdQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicolas Saenz Julienne <nsaenzju@redhat.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Valentin Schneider <vschneid@redhat.com>,
        Phil Auld <pauld@redhat.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 065/287] nohz/full, sched/rt: Fix missed tick-reenabling bug in dequeue_task_rt()
Date:   Tue, 23 Aug 2022 10:23:54 +0200
Message-Id: <20220823080102.425385618@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080100.268827165@linuxfoundation.org>
References: <20220823080100.268827165@linuxfoundation.org>
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

From: Nicolas Saenz Julienne <nsaenzju@redhat.com>

[ Upstream commit 5c66d1b9b30f737fcef85a0b75bfe0590e16b62a ]

dequeue_task_rt() only decrements 'rt_rq->rt_nr_running' after having
called sched_update_tick_dependency() preventing it from re-enabling the
tick on systems that no longer have pending SCHED_RT tasks but have
multiple runnable SCHED_OTHER tasks:

  dequeue_task_rt()
    dequeue_rt_entity()
      dequeue_rt_stack()
        dequeue_top_rt_rq()
	  sub_nr_running()	// decrements rq->nr_running
	    sched_update_tick_dependency()
	      sched_can_stop_tick()	// checks rq->rt.rt_nr_running,
	      ...
        __dequeue_rt_entity()
          dec_rt_tasks()	// decrements rq->rt.rt_nr_running
	  ...

Every other scheduler class performs the operation in the opposite
order, and sched_update_tick_dependency() expects the values to be
updated as such. So avoid the misbehaviour by inverting the order in
which the above operations are performed in the RT scheduler.

Fixes: 76d92ac305f2 ("sched: Migrate sched to use new tick dependency mask model")
Signed-off-by: Nicolas Saenz Julienne <nsaenzju@redhat.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Valentin Schneider <vschneid@redhat.com>
Reviewed-by: Phil Auld <pauld@redhat.com>
Link: https://lore.kernel.org/r/20220628092259.330171-1-nsaenzju@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/rt.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 70e8cd395474..9c6c3572b131 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -434,7 +434,7 @@ static inline void rt_queue_push_tasks(struct rq *rq)
 #endif /* CONFIG_SMP */
 
 static void enqueue_top_rt_rq(struct rt_rq *rt_rq);
-static void dequeue_top_rt_rq(struct rt_rq *rt_rq);
+static void dequeue_top_rt_rq(struct rt_rq *rt_rq, unsigned int count);
 
 static inline int on_rt_rq(struct sched_rt_entity *rt_se)
 {
@@ -516,7 +516,7 @@ static void sched_rt_rq_dequeue(struct rt_rq *rt_rq)
 	rt_se = rt_rq->tg->rt_se[cpu];
 
 	if (!rt_se) {
-		dequeue_top_rt_rq(rt_rq);
+		dequeue_top_rt_rq(rt_rq, rt_rq->rt_nr_running);
 		/* Kick cpufreq (see the comment in kernel/sched/sched.h). */
 		cpufreq_update_util(rq_of_rt_rq(rt_rq), 0);
 	}
@@ -602,7 +602,7 @@ static inline void sched_rt_rq_enqueue(struct rt_rq *rt_rq)
 
 static inline void sched_rt_rq_dequeue(struct rt_rq *rt_rq)
 {
-	dequeue_top_rt_rq(rt_rq);
+	dequeue_top_rt_rq(rt_rq, rt_rq->rt_nr_running);
 }
 
 static inline int rt_rq_throttled(struct rt_rq *rt_rq)
@@ -1001,7 +1001,7 @@ static void update_curr_rt(struct rq *rq)
 }
 
 static void
-dequeue_top_rt_rq(struct rt_rq *rt_rq)
+dequeue_top_rt_rq(struct rt_rq *rt_rq, unsigned int count)
 {
 	struct rq *rq = rq_of_rt_rq(rt_rq);
 
@@ -1012,7 +1012,7 @@ dequeue_top_rt_rq(struct rt_rq *rt_rq)
 
 	BUG_ON(!rq->nr_running);
 
-	sub_nr_running(rq, rt_rq->rt_nr_running);
+	sub_nr_running(rq, count);
 	rt_rq->rt_queued = 0;
 
 }
@@ -1291,18 +1291,21 @@ static void __dequeue_rt_entity(struct sched_rt_entity *rt_se, unsigned int flag
 static void dequeue_rt_stack(struct sched_rt_entity *rt_se, unsigned int flags)
 {
 	struct sched_rt_entity *back = NULL;
+	unsigned int rt_nr_running;
 
 	for_each_sched_rt_entity(rt_se) {
 		rt_se->back = back;
 		back = rt_se;
 	}
 
-	dequeue_top_rt_rq(rt_rq_of_se(back));
+	rt_nr_running = rt_rq_of_se(back)->rt_nr_running;
 
 	for (rt_se = back; rt_se; rt_se = rt_se->back) {
 		if (on_rt_rq(rt_se))
 			__dequeue_rt_entity(rt_se, flags);
 	}
+
+	dequeue_top_rt_rq(rt_rq_of_se(back), rt_nr_running);
 }
 
 static void enqueue_rt_entity(struct sched_rt_entity *rt_se, unsigned int flags)
-- 
2.35.1



