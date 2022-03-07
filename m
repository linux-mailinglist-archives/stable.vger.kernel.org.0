Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85A2E4CF8F7
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 11:02:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239165AbiCGKDK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 05:03:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240552AbiCGKBG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 05:01:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB18E41327;
        Mon,  7 Mar 2022 01:50:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2382060AD4;
        Mon,  7 Mar 2022 09:50:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 237D0C340F7;
        Mon,  7 Mar 2022 09:50:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646646623;
        bh=Zui8ECPQw1oRdjCitPElBm7a/khE+cS65N3yjxUWZyk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mq7DsQ3o1lUfLxAcne0VD+VF186wDOdEZDlUK1TxrxZTIHmUM/hvXy/EDoOISSHSD
         656t8MHtwUGub9mLNfADbK7vu7J66aA3MLkytgcYQxupznZTICEzmnxE4ZQ9kvR+/x
         LKDHlGadiCFDZiQAPW0H4vPktPcUtqlYjgwI7W+U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+af7a719bc92395ee41b3@syzkaller.appspotmail.com,
        Tadeusz Struk <tadeusz.struk@linaro.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 040/186] sched/fair: Fix fault in reweight_entity
Date:   Mon,  7 Mar 2022 10:17:58 +0100
Message-Id: <20220307091655.217627420@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091654.092878898@linuxfoundation.org>
References: <20220307091654.092878898@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tadeusz Struk <tadeusz.struk@linaro.org>

[ Upstream commit 13765de8148f71fa795e0a6607de37c49ea5915a ]

Syzbot found a GPF in reweight_entity. This has been bisected to
commit 4ef0c5c6b5ba ("kernel/sched: Fix sched_fork() access an invalid
sched_task_group")

There is a race between sched_post_fork() and setpriority(PRIO_PGRP)
within a thread group that causes a null-ptr-deref in
reweight_entity() in CFS. The scenario is that the main process spawns
number of new threads, which then call setpriority(PRIO_PGRP, 0, -20),
wait, and exit.  For each of the new threads the copy_process() gets
invoked, which adds the new task_struct and calls sched_post_fork()
for it.

In the above scenario there is a possibility that
setpriority(PRIO_PGRP) and set_one_prio() will be called for a thread
in the group that is just being created by copy_process(), and for
which the sched_post_fork() has not been executed yet. This will
trigger a null pointer dereference in reweight_entity(), as it will
try to access the run queue pointer, which hasn't been set.

Before the mentioned change the cfs_rq pointer for the task  has been
set in sched_fork(), which is called much earlier in copy_process(),
before the new task is added to the thread_group.  Now it is done in
the sched_post_fork(), which is called after that.  To fix the issue
the remove the update_load param from the update_load param() function
and call reweight_task() only if the task flag doesn't have the
TASK_NEW flag set.

Fixes: 4ef0c5c6b5ba ("kernel/sched: Fix sched_fork() access an invalid sched_task_group")
Reported-by: syzbot+af7a719bc92395ee41b3@syzkaller.appspotmail.com
Signed-off-by: Tadeusz Struk <tadeusz.struk@linaro.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20220203161846.1160750-1-tadeusz.struk@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/core.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index d24823b3c3f9f..35b256b789680 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1203,8 +1203,9 @@ int tg_nop(struct task_group *tg, void *data)
 }
 #endif
 
-static void set_load_weight(struct task_struct *p, bool update_load)
+static void set_load_weight(struct task_struct *p)
 {
+	bool update_load = !(READ_ONCE(p->__state) & TASK_NEW);
 	int prio = p->static_prio - MAX_RT_PRIO;
 	struct load_weight *load = &p->se.load;
 
@@ -4392,7 +4393,7 @@ int sched_fork(unsigned long clone_flags, struct task_struct *p)
 			p->static_prio = NICE_TO_PRIO(0);
 
 		p->prio = p->normal_prio = p->static_prio;
-		set_load_weight(p, false);
+		set_load_weight(p);
 
 		/*
 		 * We don't need the reset flag anymore after the fork. It has
@@ -6879,7 +6880,7 @@ void set_user_nice(struct task_struct *p, long nice)
 		put_prev_task(rq, p);
 
 	p->static_prio = NICE_TO_PRIO(nice);
-	set_load_weight(p, true);
+	set_load_weight(p);
 	old_prio = p->prio;
 	p->prio = effective_prio(p);
 
@@ -7170,7 +7171,7 @@ static void __setscheduler_params(struct task_struct *p,
 	 */
 	p->rt_priority = attr->sched_priority;
 	p->normal_prio = normal_prio(p);
-	set_load_weight(p, true);
+	set_load_weight(p);
 }
 
 /*
@@ -9409,7 +9410,7 @@ void __init sched_init(void)
 #endif
 	}
 
-	set_load_weight(&init_task, false);
+	set_load_weight(&init_task);
 
 	/*
 	 * The boot idle thread does lazy MMU switching as well:
-- 
2.34.1



