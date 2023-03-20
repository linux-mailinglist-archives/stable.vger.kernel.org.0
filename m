Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D3116C16DB
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:09:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232307AbjCTPJm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:09:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232024AbjCTPJY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:09:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EE5F303C6
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:04:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7817FB80EBE
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 14:59:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7AEAC433EF;
        Mon, 20 Mar 2023 14:59:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679324359;
        bh=PYKl2p9x8LzqiYUjc00/bMQ1npPgmr1QZT64TRi7qZI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wir2FRpZ0el/J69qCbl0gkHgnMiVxB+50Pu4v7KFtMnk/vrmbj7/+4xNZzq9wE7c1
         nY4zgMtUTuWtedA7WpCJU+8POVw/Kv4z9N7zTGuLI3jmpIRmBjWG0OULYi8MpuLrJh
         /Ey1Hf6jSPtiqHoXK75URhCLstIDab2VhXJTf/0c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Masami Hiramatsu <mhiramat@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Joel Fernandes <joel@joelfernandes.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 4.19 29/36] tracing: Make tracepoint lockdep check actually test something
Date:   Mon, 20 Mar 2023 15:54:55 +0100
Message-Id: <20230320145425.324846463@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145424.191578432@linuxfoundation.org>
References: <20230320145424.191578432@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steven Rostedt (Google) <rostedt@goodmis.org>

commit c2679254b9c9980d9045f0f722cf093a2b1f7590 upstream.

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
Acked-by: Paul E. McKenney <paulmck@kernel.org>
Fixes: e6753f23d961 ("tracepoint: Make rcuidle tracepoint callers use SRCU")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/tracepoint.h |   15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

--- a/include/linux/tracepoint.h
+++ b/include/linux/tracepoint.h
@@ -233,12 +233,11 @@ static inline struct tracepoint *tracepo
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
 #define __DECLARE_TRACE(name, proto, args, cond, data_proto, data_args) \
 	extern struct tracepoint __tracepoint_##name;			\
@@ -250,9 +249,7 @@ static inline struct tracepoint *tracepo
 				TP_ARGS(data_args),			\
 				TP_CONDITION(cond), 0);			\
 		if (IS_ENABLED(CONFIG_LOCKDEP) && (cond)) {		\
-			rcu_read_lock_sched_notrace();			\
-			rcu_dereference_sched(__tracepoint_##name.funcs);\
-			rcu_read_unlock_sched_notrace();		\
+			WARN_ON_ONCE(!rcu_is_watching());		\
 		}							\
 	}								\
 	__DECLARE_TRACE_RCU(name, PARAMS(proto), PARAMS(args),		\


