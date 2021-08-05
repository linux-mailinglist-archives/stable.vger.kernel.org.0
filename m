Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F1A13E18A4
	for <lists+stable@lfdr.de>; Thu,  5 Aug 2021 17:49:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242439AbhHEPtw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Aug 2021 11:49:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:51792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242386AbhHEPtv (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 5 Aug 2021 11:49:51 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6CE026113B;
        Thu,  5 Aug 2021 15:49:37 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94.2)
        (envelope-from <rostedt@goodmis.org>)
        id 1mBfcm-0037y5-F2; Thu, 05 Aug 2021 11:49:36 -0400
Message-ID: <20210805154936.305848149@goodmis.org>
User-Agent: quilt/0.66
Date:   Thu, 05 Aug 2021 11:43:41 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org, Hui Su <suhui@zeku.com>
Subject: [for-linus][PATCH 5/6] scripts/tracing: fix the bug that cant parse raw_trace_func
References: <20210805154336.208362117@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hui Su <suhui@zeku.com>

Since commit 77271ce4b2c0 ("tracing: Add irq, preempt-count and need resched info
to default trace output"), the default trace output format has been changed to:
          <idle>-0       [009] d.h. 22420.068695: _raw_spin_lock_irqsave <-hrtimer_interrupt
          <idle>-0       [000] ..s. 22420.068695: _nohz_idle_balance <-run_rebalance_domains
          <idle>-0       [011] d.h. 22420.068695: account_process_tick <-update_process_times

origin trace output format:(before v3.2.0)
     # tracer: nop
     #
     #           TASK-PID    CPU#    TIMESTAMP  FUNCTION
     #              | |       |          |         |
          migration/0-6     [000]    50.025810: rcu_note_context_switch <-__schedule
          migration/0-6     [000]    50.025812: trace_rcu_utilization <-rcu_note_context_switch
          migration/0-6     [000]    50.025813: rcu_sched_qs <-rcu_note_context_switch
          migration/0-6     [000]    50.025815: rcu_preempt_qs <-rcu_note_context_switch
          migration/0-6     [000]    50.025817: trace_rcu_utilization <-rcu_note_context_switch
          migration/0-6     [000]    50.025818: debug_lockdep_rcu_enabled <-__schedule
          migration/0-6     [000]    50.025820: debug_lockdep_rcu_enabled <-__schedule

The draw_functrace.py(introduced in v2.6.28) can't parse the new version format trace_func,
So we need modify draw_functrace.py to adapt the new version trace output format.

Link: https://lkml.kernel.org/r/20210611022107.608787-1-suhui@zeku.com

Cc: stable@vger.kernel.org
Fixes: 77271ce4b2c0 tracing: Add irq, preempt-count and need resched info to default trace output
Signed-off-by: Hui Su <suhui@zeku.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 scripts/tracing/draw_functrace.py | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/scripts/tracing/draw_functrace.py b/scripts/tracing/draw_functrace.py
index 74f8aadfd4cb..7011fbe003ff 100755
--- a/scripts/tracing/draw_functrace.py
+++ b/scripts/tracing/draw_functrace.py
@@ -17,7 +17,7 @@ Usage:
 	$ cat /sys/kernel/debug/tracing/trace_pipe > ~/raw_trace_func
 	Wait some times but not too much, the script is a bit slow.
 	Break the pipe (Ctrl + Z)
-	$ scripts/draw_functrace.py < raw_trace_func > draw_functrace
+	$ scripts/tracing/draw_functrace.py < ~/raw_trace_func > draw_functrace
 	Then you have your drawn trace in draw_functrace
 """
 
@@ -103,10 +103,10 @@ def parseLine(line):
 	line = line.strip()
 	if line.startswith("#"):
 		raise CommentLineException
-	m = re.match("[^]]+?\\] +([0-9.]+): (\\w+) <-(\\w+)", line)
+	m = re.match("[^]]+?\\] +([a-z.]+) +([0-9.]+): (\\w+) <-(\\w+)", line)
 	if m is None:
 		raise BrokenLineException
-	return (m.group(1), m.group(2), m.group(3))
+	return (m.group(2), m.group(3), m.group(4))
 
 
 def main():
-- 
2.30.2
