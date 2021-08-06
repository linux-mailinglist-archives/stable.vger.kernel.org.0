Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BBF83E2CF8
	for <lists+stable@lfdr.de>; Fri,  6 Aug 2021 16:54:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238683AbhHFOyZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Aug 2021 10:54:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:32828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230302AbhHFOyZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Aug 2021 10:54:25 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 37921610FF;
        Fri,  6 Aug 2021 14:54:09 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94.2)
        (envelope-from <rostedt@goodmis.org>)
        id 1mC1Ed-003EUE-Vz; Fri, 06 Aug 2021 10:54:07 -0400
Message-ID: <20210806145407.819812399@goodmis.org>
User-Agent: quilt/0.66
Date:   Fri, 06 Aug 2021 10:53:00 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Stefan Metzmacher <metze@samba.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [for-linus][PATCH 1/3] tracepoint: static call: Compare data on transition from 2->1 callees
References: <20210806145259.240934834@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

On transition from 2->1 callees, we should be comparing .data rather
than .func, because the same callback can be registered twice with
different data, and what we care about here is that the data of array
element 0 is unchanged to skip rcu sync.

Link: https://lkml.kernel.org/r/20210805132717.23813-2-mathieu.desnoyers@efficios.com
Link: https://lore.kernel.org/io-uring/4ebea8f0-58c9-e571-fd30-0ce4f6f09c70@samba.org/

Cc: stable@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Stefan Metzmacher <metze@samba.org>
Fixes: 547305a64632 ("tracepoint: Fix out of sync data passing by static caller")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 kernel/tracepoint.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
index fc32821f8240..133b6454b287 100644
--- a/kernel/tracepoint.c
+++ b/kernel/tracepoint.c
@@ -338,7 +338,7 @@ static int tracepoint_remove_func(struct tracepoint *tp,
 	} else {
 		rcu_assign_pointer(tp->funcs, tp_funcs);
 		tracepoint_update_call(tp, tp_funcs,
-				       tp_funcs[0].func != old[0].func);
+				       tp_funcs[0].data != old[0].data);
 	}
 	release_probes(old);
 	return 0;
-- 
2.30.2
