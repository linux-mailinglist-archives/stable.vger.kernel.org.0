Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7DF6CA198
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 17:58:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730951AbfJCP52 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 11:57:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:39874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729870AbfJCP51 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 11:57:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 414B2222BE;
        Thu,  3 Oct 2019 15:57:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570118246;
        bh=kO0edMERiMK1zTYPPeg2W8nnKeWuXmPCqlnwYezt6do=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CE3SoDT8ONWV9+1oB7hjp0BE4cyQgjy7BTzfGlyET2+10V218BP3u81T3fi/O+lDu
         C1UKgZpZ97+7P3/hUju5XrzzfOrEis7oJwnF7RXOLOlHXi6xm/6tGnkYB5GSGRBMPb
         eJdZFerVkL+o+IBKdXvjQDMiTY1TMCyyvdKI8BuI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Juri Lelli <juri.lelli@redhat.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Tejun Heo <tj@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, lizefan@huawei.com,
        longman@redhat.com, luca.abeni@santannapisa.it,
        rostedt@goodmis.org, Ingo Molnar <mingo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 40/99] sched/core: Fix CPU controller for !RT_GROUP_SCHED
Date:   Thu,  3 Oct 2019 17:53:03 +0200
Message-Id: <20191003154314.889222769@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154252.297991283@linuxfoundation.org>
References: <20191003154252.297991283@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Juri Lelli <juri.lelli@redhat.com>

[ Upstream commit a07db5c0865799ebed1f88be0df50c581fb65029 ]

On !CONFIG_RT_GROUP_SCHED configurations it is currently not possible to
move RT tasks between cgroups to which CPU controller has been attached;
but it is oddly possible to first move tasks around and then make them
RT (setschedule to FIFO/RR).

E.g.:

  # mkdir /sys/fs/cgroup/cpu,cpuacct/group1
  # chrt -fp 10 $$
  # echo $$ > /sys/fs/cgroup/cpu,cpuacct/group1/tasks
  bash: echo: write error: Invalid argument
  # chrt -op 0 $$
  # echo $$ > /sys/fs/cgroup/cpu,cpuacct/group1/tasks
  # chrt -fp 10 $$
  # cat /sys/fs/cgroup/cpu,cpuacct/group1/tasks
  2345
  2598
  # chrt -p 2345
  pid 2345's current scheduling policy: SCHED_FIFO
  pid 2345's current scheduling priority: 10

Also, as Michal noted, it is currently not possible to enable CPU
controller on unified hierarchy with !CONFIG_RT_GROUP_SCHED (if there
are any kernel RT threads in root cgroup, they can't be migrated to the
newly created CPU controller's root in cgroup_update_dfl_csses()).

Existing code comes with a comment saying the "we don't support RT-tasks
being in separate groups". Such comment is however stale and belongs to
pre-RT_GROUP_SCHED times. Also, it doesn't make much sense for
!RT_GROUP_ SCHED configurations, since checks related to RT bandwidth
are not performed at all in these cases.

Make moving RT tasks between CPU controller groups viable by removing
special case check for RT (and DEADLINE) tasks.

Signed-off-by: Juri Lelli <juri.lelli@redhat.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Michal Koutný <mkoutny@suse.com>
Reviewed-by: Daniel Bristot de Oliveira <bristot@redhat.com>
Acked-by: Tejun Heo <tj@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: lizefan@huawei.com
Cc: longman@redhat.com
Cc: luca.abeni@santannapisa.it
Cc: rostedt@goodmis.org
Link: https://lkml.kernel.org/r/20190719063455.27328-1-juri.lelli@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/core.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 0e70bfeded7fd..d81bcc6362fff 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -8339,10 +8339,6 @@ static int cpu_cgroup_can_attach(struct cgroup_taskset *tset)
 #ifdef CONFIG_RT_GROUP_SCHED
 		if (!sched_rt_can_attach(css_tg(css), task))
 			return -EINVAL;
-#else
-		/* We don't support RT-tasks being in separate groups */
-		if (task->sched_class != &fair_sched_class)
-			return -EINVAL;
 #endif
 	}
 	return 0;
-- 
2.20.1



