Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37D1E20D99E
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 22:11:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387763AbgF2TtO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 15:49:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:47706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387756AbgF2Tki (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:40:38 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3CD8D248E4;
        Mon, 29 Jun 2020 15:27:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444438;
        bh=TJrWSuxOiDvcM9/5Ii7LFvS+uNhA52liC/S6Nrw3aG0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TfZ5DBBm+qM+o8oGXIXVbespzRtmUQ5LDSZY45ATc8WuEwId3QOroK6KdrpYLnqQ0
         P6N20SfVDuWf8slLfu2ryqBZn2gDTJkwmdyxoo61IxfD1s1zMuChZDMTuT8v+MFbew
         DfAufzvPdqzkQzmPfN4FVDSpLL1zF1PyfV7seneA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Juri Lelli <juri.lelli@redhat.com>,
        syzbot+119ba87189432ead09b4@syzkaller.appspotmail.com,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Daniel Wagner <dwagner@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 116/178] sched/core: Fix PI boosting between RT and DEADLINE tasks
Date:   Mon, 29 Jun 2020 11:24:21 -0400
Message-Id: <20200629152523.2494198-117-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629152523.2494198-1-sashal@kernel.org>
References: <20200629152523.2494198-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.50-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.50-rc1
X-KernelTest-Deadline: 2020-07-01T15:25+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Juri Lelli <juri.lelli@redhat.com>

[ Upstream commit 740797ce3a124b7dd22b7fb832d87bc8fba1cf6f ]

syzbot reported the following warning:

 WARNING: CPU: 1 PID: 6351 at kernel/sched/deadline.c:628
 enqueue_task_dl+0x22da/0x38a0 kernel/sched/deadline.c:1504

At deadline.c:628 we have:

 623 static inline void setup_new_dl_entity(struct sched_dl_entity *dl_se)
 624 {
 625 	struct dl_rq *dl_rq = dl_rq_of_se(dl_se);
 626 	struct rq *rq = rq_of_dl_rq(dl_rq);
 627
 628 	WARN_ON(dl_se->dl_boosted);
 629 	WARN_ON(dl_time_before(rq_clock(rq), dl_se->deadline));
        [...]
     }

Which means that setup_new_dl_entity() has been called on a task
currently boosted. This shouldn't happen though, as setup_new_dl_entity()
is only called when the 'dynamic' deadline of the new entity
is in the past w.r.t. rq_clock and boosted tasks shouldn't verify this
condition.

Digging through the PI code I noticed that what above might in fact happen
if an RT tasks blocks on an rt_mutex hold by a DEADLINE task. In the
first branch of boosting conditions we check only if a pi_task 'dynamic'
deadline is earlier than mutex holder's and in this case we set mutex
holder to be dl_boosted. However, since RT 'dynamic' deadlines are only
initialized if such tasks get boosted at some point (or if they become
DEADLINE of course), in general RT 'dynamic' deadlines are usually equal
to 0 and this verifies the aforementioned condition.

Fix it by checking that the potential donor task is actually (even if
temporary because in turn boosted) running at DEADLINE priority before
using its 'dynamic' deadline value.

Fixes: 2d3d891d3344 ("sched/deadline: Add SCHED_DEADLINE inheritance logic")
Reported-by: syzbot+119ba87189432ead09b4@syzkaller.appspotmail.com
Signed-off-by: Juri Lelli <juri.lelli@redhat.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Daniel Bristot de Oliveira <bristot@redhat.com>
Tested-by: Daniel Wagner <dwagner@suse.de>
Link: https://lkml.kernel.org/r/20181119153201.GB2119@localhost.localdomain
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 361cbc2dc9667..7238ef445dafb 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4447,7 +4447,8 @@ void rt_mutex_setprio(struct task_struct *p, struct task_struct *pi_task)
 	 */
 	if (dl_prio(prio)) {
 		if (!dl_prio(p->normal_prio) ||
-		    (pi_task && dl_entity_preempt(&pi_task->dl, &p->dl))) {
+		    (pi_task && dl_prio(pi_task->prio) &&
+		     dl_entity_preempt(&pi_task->dl, &p->dl))) {
 			p->dl.dl_boosted = 1;
 			queue_flag |= ENQUEUE_REPLENISH;
 		} else
-- 
2.25.1

