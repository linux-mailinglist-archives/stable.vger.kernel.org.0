Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A43B6C1750
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:12:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232357AbjCTPMx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:12:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232231AbjCTPMR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:12:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 151B031E1E
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:07:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E5D77614CA
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:07:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02EAFC433D2;
        Mon, 20 Mar 2023 15:07:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679324832;
        bh=IraFu/fq8oG1pTCyMLnNatARRbTw8FwiudOzUZAy4bQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qZw4QNNWycxscShav8hIQa6xFE8LMDtpm/rsRgRVQT9juKVji/IPJtuAfrl3w7mRo
         v0lfK6cMfoADTCoFZ4S8zYdR/DmXITgfRj/YfYJUQz1Y0hWk43aCR8jB0/cJ9V2+sd
         zzqLsOdYwbzPVNY1qdWTknUB5Kbw05iSIzTxUFz8=
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
Subject: [PATCH 5.10 63/99] tracing: Make tracepoint lockdep check actually test something
Date:   Mon, 20 Mar 2023 15:54:41 +0100
Message-Id: <20230320145446.027878085@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145443.333824603@linuxfoundation.org>
References: <20230320145443.333824603@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
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
@@ -234,12 +234,11 @@ static inline struct tracepoint *tracepo
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
 	extern int __traceiter_##name(data_proto);			\
@@ -253,9 +252,7 @@ static inline struct tracepoint *tracepo
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


