Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6E304F29DC
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 12:50:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343765AbiDEJMr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:12:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244865AbiDEIwo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:52:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DECF7237EF;
        Tue,  5 Apr 2022 01:45:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8F0C8B81BC5;
        Tue,  5 Apr 2022 08:45:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8FB4C385A1;
        Tue,  5 Apr 2022 08:45:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649148301;
        bh=f7lk/uatWZehCCEatvm6qnumEhlCGUuUHdGZqbrb3Fw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vgrS8Vp4HRlWT7ZdRtE3HtqgUW+0JzTrgs4O+zOjaJnTDzSYCD8woN6W9wG0ocbU/
         wREti6KD0araK0Ewmq+e4WClou+Mm7WwmyHulR6PL1VnqB2z0KOiL/BQCcN6IAr/sJ
         Jjqw1K2/MGqj/I0/TG5g+E//Sk21KS83KnkvWJDg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Minye Zhu <zhuminye@bytedance.com>,
        Chengming Zhou <zhouchengming@bytedance.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Tejun Heo <tj@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0269/1017] sched/cpuacct: Fix charge percpu cpuusage
Date:   Tue,  5 Apr 2022 09:19:42 +0200
Message-Id: <20220405070402.249536522@linuxfoundation.org>
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

From: Chengming Zhou <zhouchengming@bytedance.com>

[ Upstream commit 248cc9993d1cc12b8e9ed716cc3fc09f6c3517dd ]

The cpuacct_account_field() is always called by the current task
itself, so it's ok to use __this_cpu_add() to charge the tick time.

But cpuacct_charge() maybe called by update_curr() in load_balance()
on a random CPU, different from the CPU on which the task is running.
So __this_cpu_add() will charge that cputime to a random incorrect CPU.

Fixes: 73e6aafd9ea8 ("sched/cpuacct: Simplify the cpuacct code")
Reported-by: Minye Zhu <zhuminye@bytedance.com>
Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Tejun Heo <tj@kernel.org>
Link: https://lore.kernel.org/r/20220220051426.5274-1-zhouchengming@bytedance.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/cpuacct.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/cpuacct.c b/kernel/sched/cpuacct.c
index ab67d97a8442..cacc2076ad21 100644
--- a/kernel/sched/cpuacct.c
+++ b/kernel/sched/cpuacct.c
@@ -328,12 +328,13 @@ static struct cftype files[] = {
  */
 void cpuacct_charge(struct task_struct *tsk, u64 cputime)
 {
+	unsigned int cpu = task_cpu(tsk);
 	struct cpuacct *ca;
 
 	rcu_read_lock();
 
 	for (ca = task_ca(tsk); ca; ca = parent_ca(ca))
-		__this_cpu_add(*ca->cpuusage, cputime);
+		*per_cpu_ptr(ca->cpuusage, cpu) += cputime;
 
 	rcu_read_unlock();
 }
-- 
2.34.1



