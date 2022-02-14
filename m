Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F0844B4AF8
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 11:40:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346259AbiBNKRz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 05:17:55 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347184AbiBNKQV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 05:16:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EB8E6D86F;
        Mon, 14 Feb 2022 01:53:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3F99CB80DBF;
        Mon, 14 Feb 2022 09:53:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E053C340E9;
        Mon, 14 Feb 2022 09:53:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644832416;
        bh=J4TfmdW9SmmCxPVvKGSAjHUPbDY8uIQC53QynwaK9Pk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yIVHU0ziXghpd8yCMWVcRqb2iNzGNBXQvI69r/0RZZeSX1vPPPGrqXAJvyDWEJGYU
         RTXG3hL9sJ8WD2Wvv1kYFM/C0q36ghY4zczIVMJcVR+Wwih4st3R6Ihrwlyqa6/ZEq
         8BL6fYbCKM5t7/AG95LdUeGIG1ET9aULQRf1bY6A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+af7a719bc92395ee41b3@syzkaller.appspotmail.com,
        Tadeusz Struk <tadeusz.struk@linaro.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>
Subject: [PATCH 5.15 165/172] sched/fair: Fix fault in reweight_entity
Date:   Mon, 14 Feb 2022 10:27:03 +0100
Message-Id: <20220214092512.081826010@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092506.354292783@linuxfoundation.org>
References: <20220214092506.354292783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tadeusz Struk <tadeusz.struk@linaro.org>

commit 13765de8148f71fa795e0a6607de37c49ea5915a upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/core.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1199,8 +1199,9 @@ int tg_nop(struct task_group *tg, void *
 }
 #endif
 
-static void set_load_weight(struct task_struct *p, bool update_load)
+static void set_load_weight(struct task_struct *p)
 {
+	bool update_load = !(READ_ONCE(p->__state) & TASK_NEW);
 	int prio = p->static_prio - MAX_RT_PRIO;
 	struct load_weight *load = &p->se.load;
 
@@ -4358,7 +4359,7 @@ int sched_fork(unsigned long clone_flags
 			p->static_prio = NICE_TO_PRIO(0);
 
 		p->prio = p->normal_prio = p->static_prio;
-		set_load_weight(p, false);
+		set_load_weight(p);
 
 		/*
 		 * We don't need the reset flag anymore after the fork. It has
@@ -6902,7 +6903,7 @@ void set_user_nice(struct task_struct *p
 		put_prev_task(rq, p);
 
 	p->static_prio = NICE_TO_PRIO(nice);
-	set_load_weight(p, true);
+	set_load_weight(p);
 	old_prio = p->prio;
 	p->prio = effective_prio(p);
 
@@ -7193,7 +7194,7 @@ static void __setscheduler_params(struct
 	 */
 	p->rt_priority = attr->sched_priority;
 	p->normal_prio = normal_prio(p);
-	set_load_weight(p, true);
+	set_load_weight(p);
 }
 
 /*
@@ -9431,7 +9432,7 @@ void __init sched_init(void)
 #endif
 	}
 
-	set_load_weight(&init_task, false);
+	set_load_weight(&init_task);
 
 	/*
 	 * The boot idle thread does lazy MMU switching as well:


