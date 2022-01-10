Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 496E1489085
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 08:06:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237921AbiAJHG4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 02:06:56 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:49886 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235008AbiAJHG4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 02:06:56 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5CC5EB80E86;
        Mon, 10 Jan 2022 07:06:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63E04C36AE9;
        Mon, 10 Jan 2022 07:06:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641798414;
        bh=IDSLWMBRPTW+QPK5RFdFWFvyU2BK4SFonxsYZFRkU3E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OJOXT+SwIF+bptrKESa017VwLQADElDl1NuJEtjouRQHPUmvNwqvqTabcaUR9S/vh
         Dj8YCceNYAmWtCyYwr8bW+BPB9eG5r7SNL4JpcJ0YRPVBySnn8sQa+7mlwzGTEhIlZ
         O5NBoNq4sKN+1HtjB1V2bp26ru5UP+FXpZuLu9hRK08GczwEMI+fHE/dFwxcbtISjs
         ZVhruXPBze4y2kmepdVsr0IZLgQJGYWq+Koi0zy3hSEAks2PoXSBwUf+Nt776arUei
         Ww+IAkOFILecgFy/Rsx8/cZs4nlZMfIY10UZNsqKYXqRUHj6Gh279Vqn/IcCSCGN4/
         Y02exmCRNdlpw==
Date:   Mon, 10 Jan 2022 16:06:49 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Tom Zanussi <zanussi@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] tracing: Have syscall trace events use
 trace_event_buffer_lock_reserve()
Message-Id: <20220110160649.996b79e9153ab8add26f7fc6@kernel.org>
In-Reply-To: <20220107225839.823118570@goodmis.org>
References: <20220107225655.647376947@goodmis.org>
        <20220107225839.823118570@goodmis.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 07 Jan 2022 17:56:56 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> From: Steven Rostedt <rostedt@goodmis.org>
> 
> Currently, the syscall trace events call trace_buffer_lock_reserve()
> directly, which means that it misses out on some of the filtering
> optimizations provided by the helper function
> trace_event_buffer_lock_reserve(). Have the syscall trace events call that
> instead, as it was missed when adding the update to use the temp buffer
> when filtering.

Looks good to me.

Reviewed-by: Masami Hiramatsu <mhiramat@kernel.org>

Thank you,

> 
> Cc: stable@vger.kernel.org
> Fixes: 0fc1b09ff1ff4 ("tracing: Use temp buffer when filtering events")
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  kernel/trace/trace_syscalls.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
> index 8bfcd3b09422..f755bde42fd0 100644
> --- a/kernel/trace/trace_syscalls.c
> +++ b/kernel/trace/trace_syscalls.c
> @@ -323,8 +323,7 @@ static void ftrace_syscall_enter(void *data, struct pt_regs *regs, long id)
>  
>  	trace_ctx = tracing_gen_ctx();
>  
> -	buffer = tr->array_buffer.buffer;
> -	event = trace_buffer_lock_reserve(buffer,
> +	event = trace_event_buffer_lock_reserve(&buffer, trace_file,
>  			sys_data->enter_event->event.type, size, trace_ctx);
>  	if (!event)
>  		return;
> @@ -367,8 +366,7 @@ static void ftrace_syscall_exit(void *data, struct pt_regs *regs, long ret)
>  
>  	trace_ctx = tracing_gen_ctx();
>  
> -	buffer = tr->array_buffer.buffer;
> -	event = trace_buffer_lock_reserve(buffer,
> +	event = trace_event_buffer_lock_reserve(&buffer, trace_file,
>  			sys_data->exit_event->event.type, sizeof(*entry),
>  			trace_ctx);
>  	if (!event)
> -- 
> 2.33.0


-- 
Masami Hiramatsu <mhiramat@kernel.org>
