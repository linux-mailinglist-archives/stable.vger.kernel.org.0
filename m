Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D487B153AF0
	for <lists+stable@lfdr.de>; Wed,  5 Feb 2020 23:28:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727116AbgBEW2L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Feb 2020 17:28:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:46212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727106AbgBEW2L (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 Feb 2020 17:28:11 -0500
Received: from paulmck-ThinkPad-P72.home (50-39-105-78.bvtn.or.frontiernet.net [50.39.105.78])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A5F45214AF;
        Wed,  5 Feb 2020 22:28:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580941689;
        bh=mhFskXW68cjm8ngJsjNtNIsLZErDvTn4apWGcjHiQ7A=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=gbiYizyBE01xlOjsK4iCwW06pKI+hMYA6qlXF679HJDAScyMlGZKmHMGlX1n0j6zp
         yf1QiYOaNIASXqy4VTRMSlQvNkUu23rwBg9cqKi8wJB336WLwAwub0Lwd/KvA9P0rp
         Kliz7v9+iKQTCWUJIwzX3XeI1BfiySM4qVsQX2d8=
Received: by paulmck-ThinkPad-P72.home (Postfix, from userid 1000)
        id 7108035227EB; Wed,  5 Feb 2020 14:28:09 -0800 (PST)
Date:   Wed, 5 Feb 2020 14:28:09 -0800
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org,
        "Joel Fernandes (Google)" <joel@joelfernandes.org>
Subject: Re: [for-next][PATCH 1/5] ftrace: Protect ftrace_graph_hash with
 ftrace_sync
Message-ID: <20200205222809.GD2935@paulmck-ThinkPad-P72>
Reply-To: paulmck@kernel.org
References: <20200205222110.912457436@goodmis.org>
 <20200205222142.810675558@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200205222142.810675558@goodmis.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 05, 2020 at 05:21:11PM -0500, Steven Rostedt wrote:
> From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
> 
> As function_graph tracer can run when RCU is not "watching", it can not be
> protected by synchronize_rcu() it requires running a task on each CPU before
> it can be freed. Calling schedule_on_each_cpu(ftrace_sync) needs to be used.
> 
> Link: https://lore.kernel.org/r/20200205131110.GT2935@paulmck-ThinkPad-P72
> 
> Cc: stable@vger.kernel.org
> Fixes: b9b0c831bed26 ("ftrace: Convert graph filter to use hash tables")
> Reported-by: "Paul E. McKenney" <paulmck@kernel.org>
> Reviewed-by: Joel Fernandes (Google) <joel@joelfernandes.org>
> Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>

Nice!  If there is much more call for this, perhaps I should take a hint
from the ftrace_sync() comment and add synchronize_rcu_rude().  ;-)

Reviewed-by: "Paul E. McKenney" <paulmck@kernel.org>

> ---
>  kernel/trace/ftrace.c | 11 +++++++++--
>  kernel/trace/trace.h  |  2 ++
>  2 files changed, 11 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index 481ede3eac13..3f7ee102868a 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -5867,8 +5867,15 @@ ftrace_graph_release(struct inode *inode, struct file *file)
>  
>  		mutex_unlock(&graph_lock);
>  
> -		/* Wait till all users are no longer using the old hash */
> -		synchronize_rcu();
> +		/*
> +		 * We need to do a hard force of sched synchronization.
> +		 * This is because we use preempt_disable() to do RCU, but
> +		 * the function tracers can be called where RCU is not watching
> +		 * (like before user_exit()). We can not rely on the RCU
> +		 * infrastructure to do the synchronization, thus we must do it
> +		 * ourselves.
> +		 */
> +		schedule_on_each_cpu(ftrace_sync);
>  
>  		free_ftrace_hash(old_hash);
>  	}
> diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
> index 8c52f5de9384..3c75d29bd861 100644
> --- a/kernel/trace/trace.h
> +++ b/kernel/trace/trace.h
> @@ -979,6 +979,7 @@ static inline int ftrace_graph_addr(struct ftrace_graph_ent *trace)
>  	 * Have to open code "rcu_dereference_sched()" because the
>  	 * function graph tracer can be called when RCU is not
>  	 * "watching".
> +	 * Protected with schedule_on_each_cpu(ftrace_sync)
>  	 */
>  	hash = rcu_dereference_protected(ftrace_graph_hash, !preemptible());
>  
> @@ -1031,6 +1032,7 @@ static inline int ftrace_graph_notrace_addr(unsigned long addr)
>  	 * Have to open code "rcu_dereference_sched()" because the
>  	 * function graph tracer can be called when RCU is not
>  	 * "watching".
> +	 * Protected with schedule_on_each_cpu(ftrace_sync)
>  	 */
>  	notrace_hash = rcu_dereference_protected(ftrace_graph_notrace_hash,
>  						 !preemptible());
> -- 
> 2.24.1
> 
> 
