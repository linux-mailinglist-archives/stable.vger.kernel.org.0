Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B136529B690
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:31:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1797085AbgJ0PVe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:21:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:36104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1797074AbgJ0PV3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:21:29 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B816B22275;
        Tue, 27 Oct 2020 15:21:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812089;
        bh=sLuJdl4lodoqFsG4UXG02/750QkLsgLur3NhU0yisbI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ETBrtVPyk6VJZs/NbVyRzvfvvzDMGPkYLan0XiWNfCO4tj6OMpMZiuDSNKTlXq5We
         50UwITlZVbFvngCJQm1alzzzN7M5f9G/uBk0fsnAt7ELbX2AKJuHnJ3ng8VCVmgc5K
         /r+Xz7G1TrAfyP2oqcJ+/I4MTHWimm8relmUuxZc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lukasz Luba <lukasz.luba@arm.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Valentin Schneider <valentin.schneider@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 089/757] sched/fair: Fix wrong negative conversion in find_energy_efficient_cpu()
Date:   Tue, 27 Oct 2020 14:45:39 +0100
Message-Id: <20201027135454.727876389@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lukasz Luba <lukasz.luba@arm.com>

[ Upstream commit da0777d35f47892f359c3f73ea155870bb595700 ]

In find_energy_efficient_cpu() 'cpu_cap' could be less that 'util'.
It might be because of RT, DL (so higher sched class than CFS), irq or
thermal pressure signal, which reduce the capacity value.
In such situation the result of 'cpu_cap - util' might be negative but
stored in the unsigned long. Then it might be compared with other unsigned
long when uclamp_rq_util_with() reduced the 'util' such that is passes the
fits_capacity() check.

Prevent this situation and make the arithmetic more safe.

Fixes: 1d42509e475cd ("sched/fair: Make EAS wakeup placement consider uclamp restrictions")
Signed-off-by: Lukasz Luba <lukasz.luba@arm.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Valentin Schneider <valentin.schneider@arm.com>
Link: https://lkml.kernel.org/r/20200810083004.26420-1-lukasz.luba@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 1a68a0536adda..51408ebd76c27 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -6594,7 +6594,8 @@ static int find_energy_efficient_cpu(struct task_struct *p, int prev_cpu)
 
 			util = cpu_util_next(cpu, p, cpu);
 			cpu_cap = capacity_of(cpu);
-			spare_cap = cpu_cap - util;
+			spare_cap = cpu_cap;
+			lsub_positive(&spare_cap, util);
 
 			/*
 			 * Skip CPUs that cannot satisfy the capacity request.
-- 
2.25.1



