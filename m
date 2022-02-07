Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61FBA4AC128
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 15:31:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344865AbiBGOXN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 09:23:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1389301AbiBGNwK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 08:52:10 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4701AC0401C8;
        Mon,  7 Feb 2022 05:52:09 -0800 (PST)
Date:   Mon, 07 Feb 2022 13:52:05 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1644241926;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NrTTwpwn5bIp2YK7PszkaXMvna76qOYCB+KkaAB6N+c=;
        b=F/H2AaUCfMsk8jcztYvXMetU8hqaWq45VrA4c8wKxAawFIlMo7NU0fMyGarNgchSbkhWgL
        /zeoArw5hhEERlo2F/rUf29tWUhDBWYhSNP9zKmmmTSIIKSJ7XHa2jxVThjXRRvIO0zTy0
        9iimwWNjA0dNVZQsyyd+Ry5Ixuw+Y2ztoNK0xcqQGSuivbUYaput/vOjEtwvWBDHGaPr9q
        9iDlrGxFBBEYj288SYVcB/p/YYi7f552+WKsbT+NsW1pw5brVHxE/uFwtKKqHHZ5CFfl8W
        SFJHZTlakZvRNiphmyFUlg9zHkVy7E0u+7TVsgBbXGQ/bJvNHfNDVuSZSbVvKA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1644241926;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NrTTwpwn5bIp2YK7PszkaXMvna76qOYCB+KkaAB6N+c=;
        b=Flk8l8A+rrGLENRcgfS4Ug4q8GEJPax2QwzIDDvKiwweICYrLpuv0i8XaVzBYMcCNBv4VK
        BKHaBwfflP8+MsDg==
From:   "tip-bot2 for Tadeusz Struk" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: sched/urgent] sched/fair: Fix fault in reweight_entity
Cc:     syzbot+af7a719bc92395ee41b3@syzkaller.appspotmail.com,
        Tadeusz Struk <tadeusz.struk@linaro.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        stable@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20220203161846.1160750-1-tadeusz.struk@linaro.org>
References: <20220203161846.1160750-1-tadeusz.struk@linaro.org>
MIME-Version: 1.0
Message-ID: <164424192533.16921.7865952180431807276.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the sched/urgent branch of tip:

Commit-ID:     13765de8148f71fa795e0a6607de37c49ea5915a
Gitweb:        https://git.kernel.org/tip/13765de8148f71fa795e0a6607de37c49ea=
5915a
Author:        Tadeusz Struk <tadeusz.struk@linaro.org>
AuthorDate:    Thu, 03 Feb 2022 08:18:46 -08:00
Committer:     Peter Zijlstra <peterz@infradead.org>
CommitterDate: Sun, 06 Feb 2022 22:37:26 +01:00

sched/fair: Fix fault in reweight_entity

Syzbot found a GPF in reweight_entity. This has been bisected to
commit 4ef0c5c6b5ba ("kernel/sched: Fix sched_fork() access an invalid
sched_task_group")

There=C2=A0is a race between sched_post_fork() and setpriority(PRIO_PGRP)
within a thread group that causes a null-ptr-deref=C2=A0in
reweight_entity() in CFS. The scenario is that the main process spawns
number of new threads, which then call setpriority(PRIO_PGRP, 0, -20),
wait, and exit.  For each of the new threads the copy_process() gets
invoked, which adds the new task_struct and calls sched_post_fork()
for it.

In the above scenario there is a possibility that
setpriority(PRIO_PGRP) and set_one_prio() will be called for a thread
in the group that is just being created by copy_process(), and for
which the sched_post_fork() has not been executed yet. This will
trigger a null pointer dereference in reweight_entity(),=C2=A0as it will
try to access the run queue pointer, which hasn't been set.

Before the mentioned change the cfs_rq pointer for the task  has been
set in sched_fork(), which is called much earlier in copy_process(),
before the new task is added to the thread_group.  Now it is done in
the sched_post_fork(), which is called after that.  To fix the issue
the remove the update_load param from the update_load param() function
and call reweight_task() only if the task flag doesn't have the
TASK_NEW flag set.

Fixes: 4ef0c5c6b5ba ("kernel/sched: Fix sched_fork() access an invalid sched_=
task_group")
Reported-by: syzbot+af7a719bc92395ee41b3@syzkaller.appspotmail.com
Signed-off-by: Tadeusz Struk <tadeusz.struk@linaro.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20220203161846.1160750-1-tadeusz.struk@linaro=
.org
---
 kernel/sched/core.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 848eaa0..fcf0c18 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1214,8 +1214,9 @@ int tg_nop(struct task_group *tg, void *data)
 }
 #endif
=20
-static void set_load_weight(struct task_struct *p, bool update_load)
+static void set_load_weight(struct task_struct *p)
 {
+	bool update_load =3D !(READ_ONCE(p->__state) & TASK_NEW);
 	int prio =3D p->static_prio - MAX_RT_PRIO;
 	struct load_weight *load =3D &p->se.load;
=20
@@ -4406,7 +4407,7 @@ int sched_fork(unsigned long clone_flags, struct task_s=
truct *p)
 			p->static_prio =3D NICE_TO_PRIO(0);
=20
 		p->prio =3D p->normal_prio =3D p->static_prio;
-		set_load_weight(p, false);
+		set_load_weight(p);
=20
 		/*
 		 * We don't need the reset flag anymore after the fork. It has
@@ -6921,7 +6922,7 @@ void set_user_nice(struct task_struct *p, long nice)
 		put_prev_task(rq, p);
=20
 	p->static_prio =3D NICE_TO_PRIO(nice);
-	set_load_weight(p, true);
+	set_load_weight(p);
 	old_prio =3D p->prio;
 	p->prio =3D effective_prio(p);
=20
@@ -7212,7 +7213,7 @@ static void __setscheduler_params(struct task_struct *p,
 	 */
 	p->rt_priority =3D attr->sched_priority;
 	p->normal_prio =3D normal_prio(p);
-	set_load_weight(p, true);
+	set_load_weight(p);
 }
=20
 /*
@@ -9445,7 +9446,7 @@ void __init sched_init(void)
 #endif
 	}
=20
-	set_load_weight(&init_task, false);
+	set_load_weight(&init_task);
=20
 	/*
 	 * The boot idle thread does lazy MMU switching as well:
