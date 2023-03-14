Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E86986B9F4F
	for <lists+stable@lfdr.de>; Tue, 14 Mar 2023 20:04:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231270AbjCNTE6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Mar 2023 15:04:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229720AbjCNTE5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Mar 2023 15:04:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B75F636FC8;
        Tue, 14 Mar 2023 12:04:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C90B4B81903;
        Tue, 14 Mar 2023 19:03:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90949C433A8;
        Tue, 14 Mar 2023 19:03:11 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.96)
        (envelope-from <rostedt@goodmis.org>)
        id 1pc9vS-009tzl-2A;
        Tue, 14 Mar 2023 15:03:10 -0400
Message-ID: <20230314190310.486609095@goodmis.org>
User-Agent: quilt/0.66
Date:   Tue, 14 Mar 2023 15:02:41 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Masami Hiramatsu <mhiramat@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org, Dave Hansen <dave.hansen@linux.intel.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Joel Fernandes <joel@joelfernandes.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [for-linus][PATCH 5/5] tracing: Make tracepoint lockdep check actually test something
References: <20230314190236.203370742@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

A while ago where the trace events had the following:

   rcu_read_lock_sched_notrace();
   rcu_dereference_sched(...);
   rcu_read_unlock_sched_notrace();

If the tracepoint is enabled, it could trigger RCU issues if called in
the wrong place. And this warning was only triggered if lockdep was
enabled. If the tracepoint was never enabled with lockdep, the bug would
not be caught. To handle this, the above sequence was done when lockdep
was enabled regardless if the tracepoint was enabled or not (although the
always enabled code really didn't do anything, it would still trigger a
warning).

But a lot has changed since that lockdep code was added. One is, that
sequence no longer triggers any warning. Another is, the tracepoint when
enabled doesn't even do that sequence anymore.

The main check we care about today is whether RCU is "watching" or not.
So if lockdep is enabled, always check if rcu_is_watching() which will
trigger a warning if it is not (tracepoints require RCU to be watching).

Note, that old sequence did add a bit of overhead when lockdep was enabled,
and with the latest kernel updates, would cause the system to slow down
enough to trigger kernel "stalled" warnings.

Link: http://lore.kernel.org/lkml/20140806181801.GA4605@redhat.com
Link: http://lore.kernel.org/lkml/20140807175204.C257CAC5@viggo.jf.intel.com
Link: https://lore.kernel.org/lkml/20230307184645.521db5c9@gandalf.local.home/
Link: https://lore.kernel.org/linux-trace-kernel/20230310172856.77406446@gandalf.local.home

Cc: stable@vger.kernel.org
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Joel Fernandes <joel@joelfernandes.org>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Fixes: e6753f23d961 ("tracepoint: Make rcuidle tracepoint callers use SRCU")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 include/linux/tracepoint.h | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
index fa1004fcf810..2083f2d2f05b 100644
--- a/include/linux/tracepoint.h
+++ b/include/linux/tracepoint.h
@@ -231,12 +231,11 @@ static inline struct tracepoint *tracepoint_ptr_deref(tracepoint_ptr_t *p)
  * not add unwanted padding between the beginning of the section and the
  * structure. Force alignment to the same alignment as the section start.
  *
- * When lockdep is enabled, we make sure to always do the RCU portions of
- * the tracepoint code, regardless of whether tracing is on. However,
- * don't check if the condition is false, due to interaction with idle
- * instrumentation. This lets us find RCU issues triggered with tracepoints
- * even when this tracepoint is off. This code has no purpose other than
- * poking RCU a bit.
+ * When lockdep is enabled, we make sure to always test if RCU is
+ * "watching" regardless if the tracepoint is enabled or not. Tracepoints
+ * require RCU to be active, and it should always warn at the tracepoint
+ * site if it is not watching, as it will need to be active when the
+ * tracepoint is enabled.
  */
 #define __DECLARE_TRACE(name, proto, args, cond, data_proto)		\
 	extern int __traceiter_##name(data_proto);			\
@@ -249,9 +248,7 @@ static inline struct tracepoint *tracepoint_ptr_deref(tracepoint_ptr_t *p)
 				TP_ARGS(args),				\
 				TP_CONDITION(cond), 0);			\
 		if (IS_ENABLED(CONFIG_LOCKDEP) && (cond)) {		\
-			rcu_read_lock_sched_notrace();			\
-			rcu_dereference_sched(__tracepoint_##name.funcs);\
-			rcu_read_unlock_sched_notrace();		\
+			WARN_ON_ONCE(!rcu_is_watching());		\
 		}							\
 	}								\
 	__DECLARE_TRACE_RCU(name, PARAMS(proto), PARAMS(args),		\
-- 
2.39.1
