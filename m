Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9AB015586C
	for <lists+stable@lfdr.de>; Fri,  7 Feb 2020 14:28:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726899AbgBGN2p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Feb 2020 08:28:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:48970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726874AbgBGN2p (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 7 Feb 2020 08:28:45 -0500
Received: from oasis.local.home (50-202-129-130-static.hfc.comcastbusiness.net [50.202.129.130])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4A4EE20661;
        Fri,  7 Feb 2020 13:28:44 +0000 (UTC)
Date:   Fri, 7 Feb 2020 08:28:42 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     <gregkh@linuxfoundation.org>
Cc:     joel@joelfernandes.org, paulmck@kernel.org,
        <stable@vger.kernel.org>
Subject: Re: FAILED: patch "[PATCH] ftrace: Protect ftrace_graph_hash with
 ftrace_sync" failed to apply to 5.5-stable tree
Message-ID: <20200207082842.1ce4bf32@oasis.local.home>
In-Reply-To: <15810705761598@kroah.com>
References: <15810705761598@kroah.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Hi Greg,

On Fri, 07 Feb 2020 11:16:16 +0100
<gregkh@linuxfoundation.org> wrote:

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

Ah, I updated that patch to insert these comments, which makes it
dependent on 16052dd5bdfa ("ftrace: Add comment to why
rcu_dereference_sched() is open coded"). This is just adding comments
and should have a very lower risk of breaking anything. If you add that
patch first, then this patch should apply cleanly. Would it be OK to
add that comment patch? It should fix most the conflicts.

-- Steve
