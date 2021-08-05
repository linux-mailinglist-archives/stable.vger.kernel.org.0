Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90C613E19FC
	for <lists+stable@lfdr.de>; Thu,  5 Aug 2021 19:07:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236801AbhHERHR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Aug 2021 13:07:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:60794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235799AbhHERHR (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 5 Aug 2021 13:07:17 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 24BA960F02;
        Thu,  5 Aug 2021 17:07:02 +0000 (UTC)
Date:   Thu, 5 Aug 2021 13:07:00 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc:     Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Stefan Metzmacher <metze@samba.org>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] Fix: tracepoint: static call: compare data on
 transition from 2->1 callees
Message-ID: <20210805130700.0bc7e52a@oasis.local.home>
In-Reply-To: <20210805132717.23813-2-mathieu.desnoyers@efficios.com>
References: <20210805132717.23813-1-mathieu.desnoyers@efficios.com>
        <20210805132717.23813-2-mathieu.desnoyers@efficios.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu,  5 Aug 2021 09:27:15 -0400
Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:

> On transition from 2->1 callees, we should be comparing .data rather
> than .func, because the same callback can be registered twice with
> different data, and what we care about here is that the data of array
> element 0 is unchanged to skip rcu sync.
> 
> Link: https://lore.kernel.org/io-uring/4ebea8f0-58c9-e571-fd30-0ce4f6f09c70@samba.org/

FYI, You only need to show one Fixes.

> Fixes: d25e37d89dd2 ("tracepoint: Optimize using static_call()")

The above is fixed by the one below. Which means all the stable kernels
that have the above, will also have the below, and thus the above is
just redundant.

> Fixes: 547305a64632 ("tracepoint: Fix out of sync data passing by static caller")

The above is what the patch actually fixes.

> Fixes: 352384d5c84e ("tracepoints: Update static_call before tp_funcs when adding a tracepoint")

How does this patch fix the above? Perhaps the above did not go enough
to fix the issue, but it's unrelated.

I'll remove the first and last Fixes tag.

> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: "Paul E. McKenney" <paulmck@kernel.org>
> Cc: Stefan Metzmacher <metze@samba.org>
> Cc: <stable@vger.kernel.org> # 5.10+

The "# 5.10+" is now obsolete, and not needed. The Fixes tag is used to
determine where this gets backported to.

Other than that. This patch looks good.

-- Steve

> ---
>  kernel/tracepoint.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
> index fc32821f8240..133b6454b287 100644
> --- a/kernel/tracepoint.c
> +++ b/kernel/tracepoint.c
> @@ -338,7 +338,7 @@ static int tracepoint_remove_func(struct tracepoint *tp,
>  	} else {
>  		rcu_assign_pointer(tp->funcs, tp_funcs);
>  		tracepoint_update_call(tp, tp_funcs,
> -				       tp_funcs[0].func != old[0].func);
> +				       tp_funcs[0].data != old[0].data);
>  	}
>  	release_probes(old);
>  	return 0;

