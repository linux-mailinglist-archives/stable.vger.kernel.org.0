Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5962B6BA191
	for <lists+stable@lfdr.de>; Tue, 14 Mar 2023 22:49:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbjCNVty (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Mar 2023 17:49:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229666AbjCNVtx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Mar 2023 17:49:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 907B851C89;
        Tue, 14 Mar 2023 14:49:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 27BEC61A04;
        Tue, 14 Mar 2023 21:49:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94B21C433EF;
        Tue, 14 Mar 2023 21:49:50 +0000 (UTC)
Date:   Tue, 14 Mar 2023 17:49:48 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Paul E. McKenney" <paulmck@kernel.org>
Cc:     linux-kernel@vger.kernel.org,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org, Dave Hansen <dave.hansen@linux.intel.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Joel Fernandes <joel@joelfernandes.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: Re: [for-linus][PATCH 5/5] tracing: Make tracepoint lockdep check
 actually test something
Message-ID: <20230314174948.17a01cd4@gandalf.local.home>
In-Reply-To: <f4f52692-9f6c-467a-8988-113aced754eb@paulmck-laptop>
References: <20230314190236.203370742@goodmis.org>
        <20230314190310.486609095@goodmis.org>
        <f4f52692-9f6c-467a-8988-113aced754eb@paulmck-laptop>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 14 Mar 2023 14:08:28 -0700
"Paul E. McKenney" <paulmck@kernel.org> wrote:

> On Tue, Mar 14, 2023 at 03:02:41PM -0400, Steven Rostedt wrote:
> > From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
> > 
> > A while ago where the trace events had the following:
> > 
> >    rcu_read_lock_sched_notrace();
> >    rcu_dereference_sched(...);
> >    rcu_read_unlock_sched_notrace();
> > 
> > If the tracepoint is enabled, it could trigger RCU issues if called in
> > the wrong place. And this warning was only triggered if lockdep was
> > enabled. If the tracepoint was never enabled with lockdep, the bug would
> > not be caught. To handle this, the above sequence was done when lockdep
> > was enabled regardless if the tracepoint was enabled or not (although the
> > always enabled code really didn't do anything, it would still trigger a
> > warning).
> > 
> > But a lot has changed since that lockdep code was added. One is, that
> > sequence no longer triggers any warning. Another is, the tracepoint when
> > enabled doesn't even do that sequence anymore.
> > 
> > The main check we care about today is whether RCU is "watching" or not.
> > So if lockdep is enabled, always check if rcu_is_watching() which will
> > trigger a warning if it is not (tracepoints require RCU to be watching).
> > 
> > Note, that old sequence did add a bit of overhead when lockdep was enabled,
> > and with the latest kernel updates, would cause the system to slow down
> > enough to trigger kernel "stalled" warnings.
> > 
> > Link: http://lore.kernel.org/lkml/20140806181801.GA4605@redhat.com
> > Link: http://lore.kernel.org/lkml/20140807175204.C257CAC5@viggo.jf.intel.com
> > Link: https://lore.kernel.org/lkml/20230307184645.521db5c9@gandalf.local.home/
> > Link: https://lore.kernel.org/linux-trace-kernel/20230310172856.77406446@gandalf.local.home
> > 
> > Cc: stable@vger.kernel.org
> > Cc: Masami Hiramatsu <mhiramat@kernel.org>
> > Cc: Dave Hansen <dave.hansen@linux.intel.com>
> > Cc: "Paul E. McKenney" <paulmck@kernel.org>
> > Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> > Cc: Joel Fernandes <joel@joelfernandes.org>
> > Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> > Fixes: e6753f23d961 ("tracepoint: Make rcuidle tracepoint callers use SRCU")
> > Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>  
> 
> Acked-by: Paul E. McKenney <paulmck@kernel.org>
> 

Thanks Paul!

-- Steve
