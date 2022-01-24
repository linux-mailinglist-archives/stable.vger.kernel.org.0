Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29A0D499A07
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:48:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378388AbiAXVjZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:39:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1453881AbiAXVbI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:31:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35349C0AD1A7;
        Mon, 24 Jan 2022 12:19:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C656C611CD;
        Mon, 24 Jan 2022 20:19:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35B77C340E5;
        Mon, 24 Jan 2022 20:19:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055586;
        bh=OUU0ni4RrGf06bexgTK8WS2wIiGIBZIlooOZq1StkTM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OoSpB1TiuN1fQHnYH+whVOB5+XxQ1YoXZi+jXCeYRhZkWlNmuQF8ivWj0eQftbSVL
         N8gW5P2QtFo+YEdkwWUt4ZQuBzatGh/2FZ9JcAP0pKLgueG6deoDoEBBoFZvVtP4nB
         BKGiP6dc42rtrEgkgIbJq+kcDRcw93jecNFYOU5U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vincent Donnefort <vincent.donnefort@arm.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Valentin Schneider <valentin.schneider@arm.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 200/846] sched/fair: Fix per-CPU kthread and wakee stacking for asym CPU capacity
Date:   Mon, 24 Jan 2022 19:35:17 +0100
Message-Id: <20220124184107.835018014@linuxfoundation.org>
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

[ Upstream commit 014ba44e8184e1acf93e0cbb7089ee847802f8f0 ]

select_idle_sibling() has a special case for tasks woken up by a per-CPU
kthread where the selected CPU is the previous one. For asymmetric CPU
capacity systems, the assumption was that the wakee couldn't have a
bigger utilization during task placement than it used to have during the
last activation. That was not considering uclamp.min which can completely
change between two task activations and as a consequence mandates the
fitness criterion asym_fits_capacity(), even for the exit path described
above.

Fixes: b4c9c9f15649 ("sched/fair: Prefer prev cpu in asymmetric wakeup path")
Signed-off-by: Vincent Donnefort <vincent.donnefort@arm.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Valentin Schneider <valentin.schneider@arm.com>
Reviewed-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
Link: https://lkml.kernel.org/r/20211129173115.4006346-1-vincent.donnefort@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index c6cb8832796b5..d41f966f5866a 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -6431,7 +6431,8 @@ static int select_idle_sibling(struct task_struct *p, int prev, int target)
 	if (is_per_cpu_kthread(current) &&
 	    in_task() &&
 	    prev == smp_processor_id() &&
-	    this_rq()->nr_running <= 1) {
+	    this_rq()->nr_running <= 1 &&
+	    asym_fits_capacity(task_util, prev)) {
 		return prev;
 	}
 
-- 
2.34.1



