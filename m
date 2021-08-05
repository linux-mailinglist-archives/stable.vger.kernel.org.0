Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0B663E1BCC
	for <lists+stable@lfdr.de>; Thu,  5 Aug 2021 20:56:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241242AbhHES4y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Aug 2021 14:56:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:44074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241061AbhHES4x (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 5 Aug 2021 14:56:53 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9AB9460EE9;
        Thu,  5 Aug 2021 18:56:38 +0000 (UTC)
Date:   Thu, 5 Aug 2021 14:56:31 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc:     Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Stefan Metzmacher <metze@samba.org>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] Fix: tracepoint: static call function vs data state
 mismatch (v2)
Message-ID: <20210805145631.609e0a80@oasis.local.home>
In-Reply-To: <20210805132717.23813-3-mathieu.desnoyers@efficios.com>
References: <20210805132717.23813-1-mathieu.desnoyers@efficios.com>
        <20210805132717.23813-3-mathieu.desnoyers@efficios.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Note, there shouldn't be a "(v2)" outside the "[PATCH ]" part.
Otherwise it gets added into the git commit during "git am".

On Thu,  5 Aug 2021 09:27:16 -0400
Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:

> On a 1->0->1 callbacks transition, there is an issue with the new
> callback using the old callback's data.
> 
> Considering __DO_TRACE_CALL:
> 
>         do {                                                            \
>                 struct tracepoint_func *it_func_ptr;                    \
>                 void *__data;                                           \
>                 it_func_ptr =                                           \
>                         rcu_dereference_raw((&__tracepoint_##name)->funcs); \
>                 if (it_func_ptr) {                                      \
>                         __data = (it_func_ptr)->data;                   \
> 
> ----> [ delayed here on one CPU (e.g. vcpu preempted by the host) ]  
> 
>                         static_call(tp_func_##name)(__data, args);      \
>                 }                                                       \
>         } while (0)
> 
> It has loaded the tp->funcs of the old callback, so it will try to use the old
> data. This can be fixed by adding a RCU sync anywhere in the 1->0->1
> transition chain.
> 
> On a N->2->1 transition, we need an rcu-sync because you may have a
> sequence of 3->2->1 (or 1->2->1) where the element 0 data is unchanged
> between 2->1, but was changed from 3->2 (or from 1->2), which may be
> observed by the static call. This can be fixed by adding an
> unconditional RCU sync in transition 2->1.
> 
> A follow up fix will introduce a more lightweight scheme based on RCU
> get_state and cond_sync.

I'll add here that this patch will cause a huge performance regression
on disabling the trace events, but the follow up patch will fix that.

Before this patch:

  # trace-cmd start -e all
  # time trace-cmd start -p nop

  real	0m0.778s
  user	0m0.000s
  sys	0m0.061s

After this patch:

  # trace-cmd start -e all
  # time trace-cmd start -p nop

  real	0m10.593s
  user	0m0.017s
  sys	0m0.259s


That's more than 10x slow down. Just under a second to disable all
events now goes to over 10 seconds!

But after the next patch:

  # trace-cmd start -e all
  # time trace-cmd start -p nop

  real	0m0.878s
  user	0m0.000s
  sys	0m0.103s

Which is in the noise from before this patch.

This is a big enough regression, I'll even add a Fixes tag to the next
patch on the final sha1 of this patch! Such that this patch won't be
backported without the next patch.

> 
> Link: https://lore.kernel.org/io-uring/4ebea8f0-58c9-e571-fd30-0ce4f6f09c70@samba.org/
> Fixes: d25e37d89dd2 ("tracepoint: Optimize using static_call()")

For this patch, I would say the above is what this fixes.

-- Steve

> Fixes: 547305a64632 ("tracepoint: Fix out of sync data passing by static caller")
> Fixes: 352384d5c84e ("tracepoints: Update static_call before tp_funcs when adding a tracepoint")
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: "Paul E. McKenney" <paulmck@kernel.org>
> Cc: Stefan Metzmacher <metze@samba.org>
> Cc: <stable@vger.kernel.org> # 5.10+
> ---
