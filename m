Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8624D14DD35
	for <lists+stable@lfdr.de>; Thu, 30 Jan 2020 15:49:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727364AbgA3OsM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jan 2020 09:48:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:33500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727247AbgA3OsM (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jan 2020 09:48:12 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D926824681;
        Thu, 30 Jan 2020 14:48:11 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.93)
        (envelope-from <rostedt@goodmis.org>)
        id 1ixB74-001CL9-Pb; Thu, 30 Jan 2020 09:48:10 -0500
Message-Id: <20200130144810.669688514@goodmis.org>
User-Agent: quilt/0.65
Date:   Thu, 30 Jan 2020 09:47:46 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org,
        "Joel Fernandes (Google)" <joel@joelfernandes.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.ibm.com>,
        syzbot+774fddf07b7ab29a1e55@syzkaller.appspotmail.com,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [for-next][PATCH 03/21] tracing: Fix sched switch start/stop refcount racy updates
References: <20200130144743.527378179@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

Reading the sched_cmdline_ref and sched_tgid_ref initial state within
tracing_start_sched_switch without holding the sched_register_mutex is
racy against concurrent updates, which can lead to tracepoint probes
being registered more than once (and thus trigger warnings within
tracepoint.c).

[ May be the fix for this bug ]
Link: https://lore.kernel.org/r/000000000000ab6f84056c786b93@google.com

Link: http://lkml.kernel.org/r/20190817141208.15226-1-mathieu.desnoyers@efficios.com

Cc: stable@vger.kernel.org
CC: Steven Rostedt (VMware) <rostedt@goodmis.org>
CC: Joel Fernandes (Google) <joel@joelfernandes.org>
CC: Peter Zijlstra <peterz@infradead.org>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Paul E. McKenney <paulmck@linux.ibm.com>
Reported-by: syzbot+774fddf07b7ab29a1e55@syzkaller.appspotmail.com
Fixes: d914ba37d7145 ("tracing: Add support for recording tgid of tasks")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 kernel/trace/trace_sched_switch.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/trace_sched_switch.c b/kernel/trace/trace_sched_switch.c
index e288168661e1..e304196d7c28 100644
--- a/kernel/trace/trace_sched_switch.c
+++ b/kernel/trace/trace_sched_switch.c
@@ -89,8 +89,10 @@ static void tracing_sched_unregister(void)
 
 static void tracing_start_sched_switch(int ops)
 {
-	bool sched_register = (!sched_cmdline_ref && !sched_tgid_ref);
+	bool sched_register;
+
 	mutex_lock(&sched_register_mutex);
+	sched_register = (!sched_cmdline_ref && !sched_tgid_ref);
 
 	switch (ops) {
 	case RECORD_CMDLINE:
-- 
2.24.1


