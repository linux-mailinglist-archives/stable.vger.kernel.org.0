Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 259701694E9
	for <lists+stable@lfdr.de>; Sun, 23 Feb 2020 03:34:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728206AbgBWCeK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Feb 2020 21:34:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:51726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728235AbgBWCWk (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 22 Feb 2020 21:22:40 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6B42022464;
        Sun, 23 Feb 2020 02:22:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582424560;
        bh=CzPNV9CXaZc0F2Z9A7VI8Xj2e4/spUA3pvhhstB0ESY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=upMfglOdcjwD8WLgfYUzcNptrC3gpwUBrwDS8NzWLFVlWPaGAE3gEVsU4zHDMS2gt
         1/PebLQEeG/p6eDpNyjzEn3oNszBQoyRcQDyydKq0tKbua8v1LIM3mZGVIVCJuIyhp
         bt7FHB8Q1l/jhscSuAmKCBNAiR4ulfKTXAcwHYo0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Scott Wood <swood@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 03/50] sched/core: Don't skip remote tick for idle CPUs
Date:   Sat, 22 Feb 2020 21:21:48 -0500
Message-Id: <20200223022235.1404-3-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200223022235.1404-1-sashal@kernel.org>
References: <20200223022235.1404-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Scott Wood <swood@redhat.com>

[ Upstream commit 488603b815a7514c7009e6fc339d74ed4a30f343 ]

This will be used in the next patch to get a loadavg update from
nohz cpus.  The delta check is skipped because idle_sched_class
doesn't update se.exec_start.

Signed-off-by: Scott Wood <swood@redhat.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://lkml.kernel.org/r/1578736419-14628-2-git-send-email-swood@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/core.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index dfaefb175ba05..5cbf64db4e0a3 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3667,22 +3667,24 @@ static void sched_tick_remote(struct work_struct *work)
 	 * statistics and checks timeslices in a time-independent way, regardless
 	 * of when exactly it is running.
 	 */
-	if (idle_cpu(cpu) || !tick_nohz_tick_stopped_cpu(cpu))
+	if (!tick_nohz_tick_stopped_cpu(cpu))
 		goto out_requeue;
 
 	rq_lock_irq(rq, &rf);
 	curr = rq->curr;
-	if (is_idle_task(curr) || cpu_is_offline(cpu))
+	if (cpu_is_offline(cpu))
 		goto out_unlock;
 
 	update_rq_clock(rq);
-	delta = rq_clock_task(rq) - curr->se.exec_start;
 
-	/*
-	 * Make sure the next tick runs within a reasonable
-	 * amount of time.
-	 */
-	WARN_ON_ONCE(delta > (u64)NSEC_PER_SEC * 3);
+	if (!is_idle_task(curr)) {
+		/*
+		 * Make sure the next tick runs within a reasonable
+		 * amount of time.
+		 */
+		delta = rq_clock_task(rq) - curr->se.exec_start;
+		WARN_ON_ONCE(delta > (u64)NSEC_PER_SEC * 3);
+	}
 	curr->sched_class->task_tick(rq, curr, 0);
 
 out_unlock:
-- 
2.20.1

