Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C346A29B3C7
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:56:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1752542AbgJ0OzG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:55:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:52604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1740625AbgJ0Owk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:52:40 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D62BD20773;
        Tue, 27 Oct 2020 14:52:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603810358;
        bh=83pEo1S7D1IwnxpOqE7t6gjf+YFk9V8DIqqxSYYN6Hk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S+suT2qufEQmfHKSrdrkKpkoxdNVfKj+pVYhjk1MXmv2HvscLv9GC4nRjmRyfWDEP
         aXwwVfz0Z7FLhGBzn0jATyAoLMaVKi2lraILJwryNoj3qS+W3/JMlLr5O2KTQAboEI
         m+t/9xKH+MKER8hl3GZUJocLUaUG9EpWbrh59JZ8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lukasz Luba <lukasz.luba@arm.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Valentin Schneider <valentin.schneider@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 080/633] sched/fair: Fix wrong negative conversion in find_energy_efficient_cpu()
Date:   Tue, 27 Oct 2020 14:47:03 +0100
Message-Id: <20201027135526.447517817@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
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
index 6b3b59cc51d6c..f71e8b0e0346a 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -6586,7 +6586,8 @@ static int find_energy_efficient_cpu(struct task_struct *p, int prev_cpu)
 
 			util = cpu_util_next(cpu, p, cpu);
 			cpu_cap = capacity_of(cpu);
-			spare_cap = cpu_cap - util;
+			spare_cap = cpu_cap;
+			lsub_positive(&spare_cap, util);
 
 			/*
 			 * Skip CPUs that cannot satisfy the capacity request.
-- 
2.25.1



