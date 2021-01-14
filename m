Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 641062F5908
	for <lists+stable@lfdr.de>; Thu, 14 Jan 2021 04:32:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725902AbhANDNw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Jan 2021 22:13:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:53434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725890AbhANDNu (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 Jan 2021 22:13:50 -0500
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 21578235FA;
        Thu, 14 Jan 2021 03:13:09 +0000 (UTC)
Date:   Wed, 13 Jan 2021 22:13:07 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     ChunyouTang <tangchunyou@163.com>
Cc:     tangchunyou@yulong.com, Masami Hiramatsu <mhiramat@kernel.org>,
        stable@vger.kernel.org,
        "Naveen N . Rao" <naveen.n.rao@linux.vnet.ibm.com>
Subject: Re: [PATCH] tracing/kprobes: Do the notrace functions check without
 kprobes on ftrace
Message-ID: <20210113221307.5456f7fc@oasis.local.home>
In-Reply-To: <20210114023627.1555-1-tangchunyou@163.com>
References: <20210114023627.1555-1-tangchunyou@163.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 14 Jan 2021 10:36:27 +0800
ChunyouTang <tangchunyou@163.com> wrote:

> From: Masami Hiramatsu <mhiramat@kernel.org>
> 
> Enable the notrace function check on the architecture which doesn't
> support kprobes on ftrace but support dynamic ftrace. This notrace
> function check is not only for the kprobes on ftrace but also
> sw-breakpoint based kprobes.
> Thus there is no reason to limit this check for the arch which
> supports kprobes on ftrace.
> 
> This also changes the dependency of Kconfig. Because kprobe event
> uses the function tracer's address list for identifying notrace
> function, if the CONFIG_DYNAMIC_FTRACE=n, it can not check whether
> the target function is notrace or not.
> 

Please be careful to how you send internal patches, and not
automatically Cc everyone in the Cc list of the patch.

-- Steve


> Link: https://lkml.kernel.org/r/20210105065730.2634785-1-naveen.n.rao@linux.vnet.ibm.com
> Link: https://lkml.kernel.org/r/161007957862.114704.4512260007555399463.stgit@devnote2
> 
> Cc: stable@vger.kernel.org
> Fixes: 45408c4f92506 ("tracing: kprobes: Prohibit probing on notrace function")
> Acked-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
> Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
> Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> ---
>  kernel/trace/Kconfig        | 2 +-
>  kernel/trace/trace_kprobe.c | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
> index d5a19413d4f8..c1a62ae7e812 100644
> --- a/kernel/trace/Kconfig
> +++ b/kernel/trace/Kconfig
> @@ -538,7 +538,7 @@ config KPROBE_EVENTS
>  config KPROBE_EVENTS_ON_NOTRACE
>  	bool "Do NOT protect notrace function from kprobe events"
>  	depends on KPROBE_EVENTS
> -	depends on KPROBES_ON_FTRACE
> +	depends on DYNAMIC_FTRACE
>  	default n
>  	help
>  	  This is only for the developers who want to debug ftrace itself
> diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
> index 9c31f42245e9..e6fba1798771 100644
> --- a/kernel/trace/trace_kprobe.c
> +++ b/kernel/trace/trace_kprobe.c
> @@ -434,7 +434,7 @@ static int disable_trace_kprobe(struct trace_event_call *call,
>  	return 0;
>  }
>  
> -#if defined(CONFIG_KPROBES_ON_FTRACE) && \
> +#if defined(CONFIG_DYNAMIC_FTRACE) && \
>  	!defined(CONFIG_KPROBE_EVENTS_ON_NOTRACE)
>  static bool __within_notrace_func(unsigned long addr)
>  {

