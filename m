Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53E403C5329
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:51:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350440AbhGLHxt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:53:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:51092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242613AbhGLHrV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:47:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8AED96140C;
        Mon, 12 Jul 2021 07:42:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626075750;
        bh=9ihMQHP7o6q1GMgwWuLyMCJZgOUuh4C+mvgR1YUPZ44=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1Rv8OaDX33d00WNfEbRSfVOi1XpSUM3dbTFOPrnmKjMyMMJbgsds6nljdS/GtojPt
         1VYlEQCeTCnlNawzzTIR6WKrEQqr3n0KaRksRrZZINNhjEyuhFdvS72e+tBNRULnBL
         l6P6v3vsXZnJXYH4CmNcGPGeO/t4I5pQLZ/7HG54=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "ziwei.dai" <ziwei.dai@unisoc.com>,
        "ke.wang" <ke.wang@unisoc.com>,
        Zhaoyang Huang <zhaoyang.huang@unisoc.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Suren Baghdasaryan <surenb@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 349/800] psi: Fix race between psi_trigger_create/destroy
Date:   Mon, 12 Jul 2021 08:06:12 +0200
Message-Id: <20210712061004.167008322@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhaoyang Huang <zhaoyang.huang@unisoc.com>

[ Upstream commit 8f91efd870ea5d8bc10b0fcc9740db51cd4c0c83 ]

Race detected between psi_trigger_destroy/create as shown below, which
cause panic by accessing invalid psi_system->poll_wait->wait_queue_entry
and psi_system->poll_timer->entry->next. Under this modification, the
race window is removed by initialising poll_wait and poll_timer in
group_init which are executed only once at beginning.

  psi_trigger_destroy()                   psi_trigger_create()

  mutex_lock(trigger_lock);
  rcu_assign_pointer(poll_task, NULL);
  mutex_unlock(trigger_lock);
					  mutex_lock(trigger_lock);
					  if (!rcu_access_pointer(group->poll_task)) {
					    timer_setup(poll_timer, poll_timer_fn, 0);
					    rcu_assign_pointer(poll_task, task);
					  }
					  mutex_unlock(trigger_lock);

  synchronize_rcu();
  del_timer_sync(poll_timer); <-- poll_timer has been reinitialized by
                                  psi_trigger_create()

So, trigger_lock/RCU correctly protects destruction of
group->poll_task but misses this race affecting poll_timer and
poll_wait.

Fixes: 461daba06bdc ("psi: eliminate kthread_worker from psi trigger scheduling mechanism")
Co-developed-by: ziwei.dai <ziwei.dai@unisoc.com>
Signed-off-by: ziwei.dai <ziwei.dai@unisoc.com>
Co-developed-by: ke.wang <ke.wang@unisoc.com>
Signed-off-by: ke.wang <ke.wang@unisoc.com>
Signed-off-by: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Link: https://lkml.kernel.org/r/1623371374-15664-1-git-send-email-huangzhaoyang@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/psi.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/kernel/sched/psi.c b/kernel/sched/psi.c
index cc25a3cff41f..58b36d17a09a 100644
--- a/kernel/sched/psi.c
+++ b/kernel/sched/psi.c
@@ -182,6 +182,8 @@ struct psi_group psi_system = {
 
 static void psi_avgs_work(struct work_struct *work);
 
+static void poll_timer_fn(struct timer_list *t);
+
 static void group_init(struct psi_group *group)
 {
 	int cpu;
@@ -201,6 +203,8 @@ static void group_init(struct psi_group *group)
 	memset(group->polling_total, 0, sizeof(group->polling_total));
 	group->polling_next_update = ULLONG_MAX;
 	group->polling_until = 0;
+	init_waitqueue_head(&group->poll_wait);
+	timer_setup(&group->poll_timer, poll_timer_fn, 0);
 	rcu_assign_pointer(group->poll_task, NULL);
 }
 
@@ -1157,9 +1161,7 @@ struct psi_trigger *psi_trigger_create(struct psi_group *group,
 			return ERR_CAST(task);
 		}
 		atomic_set(&group->poll_wakeup, 0);
-		init_waitqueue_head(&group->poll_wait);
 		wake_up_process(task);
-		timer_setup(&group->poll_timer, poll_timer_fn, 0);
 		rcu_assign_pointer(group->poll_task, task);
 	}
 
@@ -1211,6 +1213,7 @@ static void psi_trigger_destroy(struct kref *ref)
 					group->poll_task,
 					lockdep_is_held(&group->trigger_lock));
 			rcu_assign_pointer(group->poll_task, NULL);
+			del_timer(&group->poll_timer);
 		}
 	}
 
@@ -1223,17 +1226,14 @@ static void psi_trigger_destroy(struct kref *ref)
 	 */
 	synchronize_rcu();
 	/*
-	 * Destroy the kworker after releasing trigger_lock to prevent a
+	 * Stop kthread 'psimon' after releasing trigger_lock to prevent a
 	 * deadlock while waiting for psi_poll_work to acquire trigger_lock
 	 */
 	if (task_to_destroy) {
 		/*
 		 * After the RCU grace period has expired, the worker
 		 * can no longer be found through group->poll_task.
-		 * But it might have been already scheduled before
-		 * that - deschedule it cleanly before destroying it.
 		 */
-		del_timer_sync(&group->poll_timer);
 		kthread_stop(task_to_destroy);
 	}
 	kfree(t);
-- 
2.30.2



