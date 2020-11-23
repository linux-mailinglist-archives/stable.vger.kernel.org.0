Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD9072C093D
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:17:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388475AbgKWNFT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 08:05:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:35210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387586AbgKWMuc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:50:32 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1242E20657;
        Mon, 23 Nov 2020 12:50:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135825;
        bh=MAc+WNZZZ1hzwgejSuwAHA9LY+zCNzoPtXauup4b8Zw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s36Lv7gN5WP2L/xd4gnL/c5qwvzWPmMAhNN4v6iRLO3/2LikoxirE0Nn4ZEsIWY/o
         EqIr+zLIOKdqkzOydkqxbydgV04VGXLl/mLz99BtDhryPsaZufv2wtwHvtuEySVpoc
         5qzbvK3CKeodmSDVKTjZ6iJCuostt9AUvy9d2n24=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rick Yiu <rickyiu@google.com>,
        Quentin Perret <qperret@google.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Valentin Schneider <valentin.schneider@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 180/252] sched/fair: Fix overutilized update in enqueue_task_fair()
Date:   Mon, 23 Nov 2020 13:22:10 +0100
Message-Id: <20201123121844.282273364@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121835.580259631@linuxfoundation.org>
References: <20201123121835.580259631@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Quentin Perret <qperret@google.com>

[ Upstream commit 8e1ac4299a6e8726de42310d9c1379f188140c71 ]

enqueue_task_fair() attempts to skip the overutilized update for new
tasks as their util_avg is not accurate yet. However, the flag we check
to do so is overwritten earlier on in the function, which makes the
condition pretty much a nop.

Fix this by saving the flag early on.

Fixes: 2802bf3cd936 ("sched/fair: Add over-utilization/tipping point indicator")
Reported-by: Rick Yiu <rickyiu@google.com>
Signed-off-by: Quentin Perret <qperret@google.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Vincent Guittot <vincent.guittot@linaro.org>
Reviewed-by: Valentin Schneider <valentin.schneider@arm.com>
Link: https://lkml.kernel.org/r/20201112111201.2081902-1-qperret@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 48a6d442b4443..c0c4d9ad7da8e 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5473,6 +5473,7 @@ enqueue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 	struct cfs_rq *cfs_rq;
 	struct sched_entity *se = &p->se;
 	int idle_h_nr_running = task_has_idle_policy(p);
+	int task_new = !(flags & ENQUEUE_WAKEUP);
 
 	/*
 	 * The code below (indirectly) updates schedutil which looks at
@@ -5545,7 +5546,7 @@ enqueue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 	 * into account, but that is not straightforward to implement,
 	 * and the following generally works well enough in practice.
 	 */
-	if (flags & ENQUEUE_WAKEUP)
+	if (!task_new)
 		update_overutilized_status(rq);
 
 enqueue_throttle:
-- 
2.27.0



