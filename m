Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C06331F53A
	for <lists+stable@lfdr.de>; Fri, 19 Feb 2021 07:46:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229524AbhBSGqU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Feb 2021 01:46:20 -0500
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:39046 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229498AbhBSGqU (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Feb 2021 01:46:20 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=alimailimapcm10staff010182156082;MF=wenyang@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0UOwxD-P_1613717127;
Received: from localhost(mailfrom:wenyang@linux.alibaba.com fp:SMTPD_---0UOwxD-P_1613717127)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 19 Feb 2021 14:45:33 +0800
From:   Wen Yang <simon.wy@alibaba-inc.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     Peter Zijlstra <peterz@infradead.org>, luferry <luferry@163.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        stable <stable@vger.kernel.org>,
        Wen Yang <simon.wy@alibaba-inc.com>
Subject: [PATCH 4.19] smp: Warn on function calls from softirq context
Date:   Fri, 19 Feb 2021 14:45:26 +0800
Message-Id: <20210219064526.69529-1-simon.wy@alibaba-inc.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

commit 19dbdcb8039cff16669a05136a29180778d16d0a upstream.

It's clearly documented that smp function calls cannot be invoked from
softirq handling context. Unfortunately nothing enforces that or emits a
warning.

A single function call can be invoked from softirq context only via
smp_call_function_single_async().

The only legit context is task context, so add a warning to that effect.

Reported-by: luferry <luferry@163.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lkml.kernel.org/r/20190718160601.GP3402@hirez.programming.kicks-ass.net
Cc: stable <stable@vger.kernel.org> # 4.19.x
Signed-off-by: Wen Yang <simon.wy@alibaba-inc.com>
---
 kernel/smp.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/kernel/smp.c b/kernel/smp.c
index 084c8b3..9afcbb4 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -290,6 +290,14 @@ int smp_call_function_single(int cpu, smp_call_func_t func, void *info,
 	WARN_ON_ONCE(cpu_online(this_cpu) && irqs_disabled()
 		     && !oops_in_progress);
 
+	/*
+	 * When @wait we can deadlock when we interrupt between llist_add() and
+	 * arch_send_call_function_ipi*(); when !@wait we can deadlock due to
+	 * csd_lock() on because the interrupt context uses the same csd
+	 * storage.
+	 */
+	WARN_ON_ONCE(!in_task());
+
 	csd = &csd_stack;
 	if (!wait) {
 		csd = this_cpu_ptr(&csd_data);
@@ -415,6 +423,14 @@ void smp_call_function_many(const struct cpumask *mask,
 	WARN_ON_ONCE(cpu_online(this_cpu) && irqs_disabled()
 		     && !oops_in_progress && !early_boot_irqs_disabled);
 
+	/*
+	 * When @wait we can deadlock when we interrupt between llist_add() and
+	 * arch_send_call_function_ipi*(); when !@wait we can deadlock due to
+	 * csd_lock() on because the interrupt context uses the same csd
+	 * storage.
+	 */
+	WARN_ON_ONCE(!in_task());
+
 	/* Try to fastpath.  So, what's a CPU they want? Ignoring this one. */
 	cpu = cpumask_first_and(mask, cpu_online_mask);
 	if (cpu == this_cpu)
-- 
1.8.3.1

