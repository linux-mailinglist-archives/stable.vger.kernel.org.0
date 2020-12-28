Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7984D2E3880
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:11:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731386AbgL1NKZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:10:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:37570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731359AbgL1NKY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:10:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3513E206ED;
        Mon, 28 Dec 2020 13:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609161008;
        bh=nj+NmGE7U71wUz78H1Oy3HfJp5mchXSgi7jywc5oPlg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2XHUY5x2IPKk1/l0I/l+S23EQlnLmlvWlsDX51fS/YiU4edo1e6Rd6GqWYqo0/ygY
         rPhp1ynLoczfJj/JubsnVSOAnSgLPPlOhqAz3IgGIGYMYhOsteggzdJvSc7PWAdTFX
         IhVGqUNBGNlxVuRV8TXM1n5MYdYJja1q0wq8dbvc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 042/242] kernel/cpu: add arch override for clear_tasks_mm_cpumask() mm handling
Date:   Mon, 28 Dec 2020 13:47:27 +0100
Message-Id: <20201228124906.744876546@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124904.654293249@linuxfoundation.org>
References: <20201228124904.654293249@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Piggin <npiggin@gmail.com>

[ Upstream commit 8ff00399b153440c1c83e20c43020385b416415b ]

powerpc/64s keeps a counter in the mm which counts bits set in
mm_cpumask as well as other things. This means it can't use generic code
to clear bits out of the mask and doesn't adjust the arch specific
counter.

Add an arch override that allows powerpc/64s to use
clear_tasks_mm_cpumask().

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20201126102530.691335-4-npiggin@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cpu.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/kernel/cpu.c b/kernel/cpu.c
index d8c77bfb6e7e4..e1d10629022a5 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -772,6 +772,10 @@ void __init cpuhp_threads_init(void)
 }
 
 #ifdef CONFIG_HOTPLUG_CPU
+#ifndef arch_clear_mm_cpumask_cpu
+#define arch_clear_mm_cpumask_cpu(cpu, mm) cpumask_clear_cpu(cpu, mm_cpumask(mm))
+#endif
+
 /**
  * clear_tasks_mm_cpumask - Safely clear tasks' mm_cpumask for a CPU
  * @cpu: a CPU id
@@ -807,7 +811,7 @@ void clear_tasks_mm_cpumask(int cpu)
 		t = find_lock_task_mm(p);
 		if (!t)
 			continue;
-		cpumask_clear_cpu(cpu, mm_cpumask(t->mm));
+		arch_clear_mm_cpumask_cpu(cpu, t->mm);
 		task_unlock(t);
 	}
 	rcu_read_unlock();
-- 
2.27.0



