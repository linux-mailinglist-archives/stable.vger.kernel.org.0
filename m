Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BB371AC418
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 15:54:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407288AbgDPNyN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 09:54:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:40634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2898669AbgDPNyI (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:54:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 425DE2076D;
        Thu, 16 Apr 2020 13:54:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587045246;
        bh=m34EV4u497pdWfdKRzmO7og1J4bNyHyupnt3lFY+C/4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mePSvAvqK84Hs+bBY1lMVp85VXzBwkx1vcdaFT2SUOksHbPI+uJXboNwKRmV/9T02
         g8TSNIQlQYm39yNReufgdwBGyprhSuk8DG0NTBwF8JtousgAHJg6iQvjjkk/Gr1ZjP
         vwCEaZu5aaVWhH+1/7PQBqJU+YMb4sKDw8ny+WII=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>,
        Frederic Weisbecker <frederic@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 015/254] sched/vtime: Prevent unstable evaluation of WARN(vtime->state)
Date:   Thu, 16 Apr 2020 15:21:44 +0200
Message-Id: <20200416131327.722023294@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131325.804095985@linuxfoundation.org>
References: <20200416131325.804095985@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Wilson <chris@chris-wilson.co.uk>

[ Upstream commit f1dfdab694eb3838ac26f4b73695929c07d92a33 ]

As the vtime is sampled under loose seqcount protection by kcpustat, the
vtime fields may change as the code flows. Where logic dictates a field
has a static value, use a READ_ONCE.

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Fixes: 74722bb223d0 ("sched/vtime: Bring up complete kcpustat accessor")
Link: https://lkml.kernel.org/r/20200123180849.28486-1-frederic@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/cputime.c | 41 ++++++++++++++++++++++-------------------
 1 file changed, 22 insertions(+), 19 deletions(-)

diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
index cff3e656566d6..dac9104d126f7 100644
--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -909,8 +909,10 @@ void task_cputime(struct task_struct *t, u64 *utime, u64 *stime)
 	} while (read_seqcount_retry(&vtime->seqcount, seq));
 }
 
-static int vtime_state_check(struct vtime *vtime, int cpu)
+static int vtime_state_fetch(struct vtime *vtime, int cpu)
 {
+	int state = READ_ONCE(vtime->state);
+
 	/*
 	 * We raced against a context switch, fetch the
 	 * kcpustat task again.
@@ -927,10 +929,10 @@ static int vtime_state_check(struct vtime *vtime, int cpu)
 	 *
 	 * Case 1) is ok but 2) is not. So wait for a safe VTIME state.
 	 */
-	if (vtime->state == VTIME_INACTIVE)
+	if (state == VTIME_INACTIVE)
 		return -EAGAIN;
 
-	return 0;
+	return state;
 }
 
 static u64 kcpustat_user_vtime(struct vtime *vtime)
@@ -949,14 +951,15 @@ static int kcpustat_field_vtime(u64 *cpustat,
 {
 	struct vtime *vtime = &tsk->vtime;
 	unsigned int seq;
-	int err;
 
 	do {
+		int state;
+
 		seq = read_seqcount_begin(&vtime->seqcount);
 
-		err = vtime_state_check(vtime, cpu);
-		if (err < 0)
-			return err;
+		state = vtime_state_fetch(vtime, cpu);
+		if (state < 0)
+			return state;
 
 		*val = cpustat[usage];
 
@@ -969,7 +972,7 @@ static int kcpustat_field_vtime(u64 *cpustat,
 		 */
 		switch (usage) {
 		case CPUTIME_SYSTEM:
-			if (vtime->state == VTIME_SYS)
+			if (state == VTIME_SYS)
 				*val += vtime->stime + vtime_delta(vtime);
 			break;
 		case CPUTIME_USER:
@@ -981,11 +984,11 @@ static int kcpustat_field_vtime(u64 *cpustat,
 				*val += kcpustat_user_vtime(vtime);
 			break;
 		case CPUTIME_GUEST:
-			if (vtime->state == VTIME_GUEST && task_nice(tsk) <= 0)
+			if (state == VTIME_GUEST && task_nice(tsk) <= 0)
 				*val += vtime->gtime + vtime_delta(vtime);
 			break;
 		case CPUTIME_GUEST_NICE:
-			if (vtime->state == VTIME_GUEST && task_nice(tsk) > 0)
+			if (state == VTIME_GUEST && task_nice(tsk) > 0)
 				*val += vtime->gtime + vtime_delta(vtime);
 			break;
 		default:
@@ -1036,23 +1039,23 @@ static int kcpustat_cpu_fetch_vtime(struct kernel_cpustat *dst,
 {
 	struct vtime *vtime = &tsk->vtime;
 	unsigned int seq;
-	int err;
 
 	do {
 		u64 *cpustat;
 		u64 delta;
+		int state;
 
 		seq = read_seqcount_begin(&vtime->seqcount);
 
-		err = vtime_state_check(vtime, cpu);
-		if (err < 0)
-			return err;
+		state = vtime_state_fetch(vtime, cpu);
+		if (state < 0)
+			return state;
 
 		*dst = *src;
 		cpustat = dst->cpustat;
 
 		/* Task is sleeping, dead or idle, nothing to add */
-		if (vtime->state < VTIME_SYS)
+		if (state < VTIME_SYS)
 			continue;
 
 		delta = vtime_delta(vtime);
@@ -1061,15 +1064,15 @@ static int kcpustat_cpu_fetch_vtime(struct kernel_cpustat *dst,
 		 * Task runs either in user (including guest) or kernel space,
 		 * add pending nohz time to the right place.
 		 */
-		if (vtime->state == VTIME_SYS) {
+		if (state == VTIME_SYS) {
 			cpustat[CPUTIME_SYSTEM] += vtime->stime + delta;
-		} else if (vtime->state == VTIME_USER) {
+		} else if (state == VTIME_USER) {
 			if (task_nice(tsk) > 0)
 				cpustat[CPUTIME_NICE] += vtime->utime + delta;
 			else
 				cpustat[CPUTIME_USER] += vtime->utime + delta;
 		} else {
-			WARN_ON_ONCE(vtime->state != VTIME_GUEST);
+			WARN_ON_ONCE(state != VTIME_GUEST);
 			if (task_nice(tsk) > 0) {
 				cpustat[CPUTIME_GUEST_NICE] += vtime->gtime + delta;
 				cpustat[CPUTIME_NICE] += vtime->gtime + delta;
@@ -1080,7 +1083,7 @@ static int kcpustat_cpu_fetch_vtime(struct kernel_cpustat *dst,
 		}
 	} while (read_seqcount_retry(&vtime->seqcount, seq));
 
-	return err;
+	return 0;
 }
 
 void kcpustat_cpu_fetch(struct kernel_cpustat *dst, int cpu)
-- 
2.20.1



