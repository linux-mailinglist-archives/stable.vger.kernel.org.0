Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97223328F42
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:50:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242124AbhCATsH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:48:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:53010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241746AbhCATix (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:38:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E2EA265024;
        Mon,  1 Mar 2021 17:13:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618805;
        bh=LnrRwunVVuJN7kpAjRecKWe5vL2hsaQBUSt4wEzMUnk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VfZWMD6s5IAnG41RDKLA3yTjfjgsxpavmNHcErXvg7OOdacKSt7qU4Owknrr889oZ
         kHOekadtciQVky7AQ+/7oQ7Z3uBoKwNLunQfSFcKbZd5vJRug5GvrYrYFNKHJTExNH
         l0ciPVnhRVpvBJSiptBAA6RrQTIlF/fspd6r6530=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qais Yousef <qais.yousef@arm.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Quentin Perret <qperret@google.com>,
        Valentin Schneider <valentin.schneider@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 196/663] sched/eas: Dont update misfit status if the task is pinned
Date:   Mon,  1 Mar 2021 17:07:24 +0100
Message-Id: <20210301161151.479380154@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qais Yousef <qais.yousef@arm.com>

[ Upstream commit 0ae78eec8aa64e645866e75005162603a77a0f49 ]

If the task is pinned to a cpu, setting the misfit status means that
we'll unnecessarily continuously attempt to migrate the task but fail.

This continuous failure will cause the balance_interval to increase to
a high value, and eventually cause unnecessary significant delays in
balancing the system when real imbalance happens.

Caught while testing uclamp where rt-app calibration loop was pinned to
cpu 0, shortly after which we spawn another task with high util_clamp
value. The task was failing to migrate after over 40ms of runtime due to
balance_interval unnecessary expanded to a very high value from the
calibration loop.

Not done here, but it could be useful to extend the check for pinning to
verify that the affinity of the task has a cpu that fits. We could end
up in a similar situation otherwise.

Fixes: 3b1baa6496e6 ("sched/fair: Add 'group_misfit_task' load-balance type")
Signed-off-by: Qais Yousef <qais.yousef@arm.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Quentin Perret <qperret@google.com>
Acked-by: Valentin Schneider <valentin.schneider@arm.com>
Link: https://lkml.kernel.org/r/20210119120755.2425264-1-qais.yousef@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index f3a1b7ac4458b..3486053060276 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4049,7 +4049,7 @@ static inline void update_misfit_status(struct task_struct *p, struct rq *rq)
 	if (!static_branch_unlikely(&sched_asym_cpucapacity))
 		return;
 
-	if (!p) {
+	if (!p || p->nr_cpus_allowed == 1) {
 		rq->misfit_task_load = 0;
 		return;
 	}
-- 
2.27.0



