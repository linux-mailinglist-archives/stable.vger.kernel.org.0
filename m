Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9C493EB868
	for <lists+stable@lfdr.de>; Fri, 13 Aug 2021 17:25:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242061AbhHMPN1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Aug 2021 11:13:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:56586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241915AbhHMPM2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Aug 2021 11:12:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5C4AD61101;
        Fri, 13 Aug 2021 15:12:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628867521;
        bh=CKykmzahHhMXt9m0NrdblO10om6+KNmQ7qwbpRTb4xQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lYb7DdlXWbqE2ZXxBB7z7jqHD+1fOj8zXNU6asLnoVQf1saLYvSq8zKkGNvkykIfF
         gGbGavBulGEWPf9JwZqmyykxLKRKYopf3ZCNB2rMKMSK+i9kwHhpA9YJ9jjrxN34P4
         d9gnu4yLmyIofQzMC4MHb4Gv9nKsTHtcPfvTWsyw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hui Su <suhui@zeku.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 4.14 23/42] scripts/tracing: fix the bug that cant parse raw_trace_func
Date:   Fri, 13 Aug 2021 17:06:49 +0200
Message-Id: <20210813150525.875419773@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210813150525.098817398@linuxfoundation.org>
References: <20210813150525.098817398@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hui Su <suhui@zeku.com>

commit 1c0cec64a7cc545eb49f374a43e9f7190a14defa upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/tracing/draw_functrace.py |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

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


