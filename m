Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71200499A08
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:48:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345454AbiAXVja (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:39:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1453875AbiAXVbH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:31:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0712C0AD1A5;
        Mon, 24 Jan 2022 12:19:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5B8A561496;
        Mon, 24 Jan 2022 20:19:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3904BC340E5;
        Mon, 24 Jan 2022 20:19:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055582;
        bh=EJZBgQ2DExYn0jf+mQ9xSJ8Ik+LpQLT9pEL3+xAQ1yk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gxcEy1GyPiDM33zBNqqgDeJI9UV+jzY5OO8N+0RqVVI2zNScpyB/JpUIKnSsYfLCV
         J3NIxRTva54qBWc+cyeqo4V9lKHdQ81mltVVYWGjq0mYphLPyuwD7kxQgzrqbzXv38
         c3susrLcPHl2NShzdL1LYCKD7FxpcKoKzn7XExJ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vincent Donnefort <vincent.donnefort@arm.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Valentin Schneider <valentin.schneider@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 199/846] sched/fair: Fix detection of per-CPU kthreads waking a task
Date:   Mon, 24 Jan 2022 19:35:16 +0100
Message-Id: <20220124184107.804854195@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vincent Donnefort <vincent.donnefort@arm.com>

[ Upstream commit 8b4e74ccb582797f6f0b0a50372ebd9fd2372a27 ]

select_idle_sibling() has a special case for tasks woken up by a per-CPU
kthread, where the selected CPU is the previous one. However, the current
condition for this exit path is incomplete. A task can wake up from an
interrupt context (e.g. hrtimer), while a per-CPU kthread is running. A
such scenario would spuriously trigger the special case described above.
Also, a recent change made the idle task like a regular per-CPU kthread,
hence making that situation more likely to happen
(is_per_cpu_kthread(swapper) being true now).

Checking for task context makes sure select_idle_sibling() will not
interpret a wake up from any other context as a wake up by a per-CPU
kthread.

Fixes: 52262ee567ad ("sched/fair: Allow a per-CPU kthread waking a task to stack on the same CPU, to fix XFS performance regression")
Signed-off-by: Vincent Donnefort <vincent.donnefort@arm.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Vincent Guittot <vincent.guittot@linaro.org>
Reviewed-by: Valentin Schneider <valentin.schneider@arm.com>
Link: https://lore.kernel.org/r/20211201143450.479472-1-vincent.donnefort@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 6f16dfb742462..c6cb8832796b5 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -6429,6 +6429,7 @@ static int select_idle_sibling(struct task_struct *p, int prev, int target)
 	 * pattern is IO completions.
 	 */
 	if (is_per_cpu_kthread(current) &&
+	    in_task() &&
 	    prev == smp_processor_id() &&
 	    this_rq()->nr_running <= 1) {
 		return prev;
-- 
2.34.1



