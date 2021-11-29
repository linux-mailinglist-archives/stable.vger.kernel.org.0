Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD8BF4614DE
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 13:18:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238459AbhK2MWB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 07:22:01 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:37948 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235236AbhK2MUB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 07:20:01 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E360BCE114B
        for <stable@vger.kernel.org>; Mon, 29 Nov 2021 12:16:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85776C53FAD;
        Mon, 29 Nov 2021 12:16:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638188201;
        bh=lJGbxd3sPwDHnm3oMWrjTEf79MFQeqhcQv1vkShqICA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hwxPhIdcnZxTiJEJS569YeZbbdj+W4VZigtLoHrAUfbNQ19E/6LZGCCwMNuHul9uC
         j9NCi1tlwlAiydS40a3NiCKafLcyuHBMpkrUs6zBHhNT/WXZURqZHWZJLbUoWSMeFn
         r1feUUTLMgiJA2wMtDlV5VTUbDbIUjryHJNFzSdk=
Date:   Mon, 29 Nov 2021 13:16:38 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] tracing: Check pid filtering when
 creating events" failed to apply to 5.10-stable tree
Message-ID: <YaTEpnO0qlEstwZ3@kroah.com>
References: <1638099841130160@kroah.com>
 <20211128134805.1b4501b6@oasis.local.home>
 <20211128141016.107f29c7@oasis.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211128141016.107f29c7@oasis.local.home>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Nov 28, 2021 at 02:10:15PM -0500, Steven Rostedt wrote:
> On Sun, 28 Nov 2021 13:48:05 -0500
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > +++ b/kernel/trace/trace_events.c
> > @@ -2677,12 +2677,23 @@ static struct trace_event_file *
> >  trace_create_new_event(struct trace_event_call *call,
> >  		       struct trace_array *tr)
> >  {
> > +	struct trace_pid_list *no_pid_list;
> > +	struct trace_pid_list *pid_list;
> >  	struct trace_event_file *file;
> > +	unsigned int first;
> >  
> 
> And even though this was the first fix, I somehow got a bit of the 5.16
> patch in here, as the "first" variable is only used for that.
> 
> Take two:
> 
> From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
> Subject: [PATCH] tracing: Check pid filtering when creating events
> 
> When pid filtering is activated in an instance, all of the events trace
> files for that instance has the PID_FILTER flag set. This determines
> whether or not pid filtering needs to be done on the event, otherwise the
> event is executed as normal.
> 
> If pid filtering is enabled when an event is created (via a dynamic event
> or modules), its flag is not updated to reflect the current state, and the
> events are not filtered properly.
> 
> Cc: stable@vger.kernel.org
> Fixes: 3fdaf80f4a836 ("tracing: Implement event pid filtering")
> Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> ---
>  kernel/trace/trace_events.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> Index: linux-test.git/kernel/trace/trace_events.c
> ===================================================================
> --- linux-test.git.orig/kernel/trace/trace_events.c
> +++ linux-test.git/kernel/trace/trace_events.c
> @@ -2462,12 +2462,22 @@ static struct trace_event_file *
>  trace_create_new_event(struct trace_event_call *call,
>  		       struct trace_array *tr)
>  {
> +	struct trace_pid_list *no_pid_list;
> +	struct trace_pid_list *pid_list;
>  	struct trace_event_file *file;
>  
>  	file = kmem_cache_alloc(file_cachep, GFP_TRACE);
>  	if (!file)
>  		return NULL;
>  
> +	pid_list = rcu_dereference_protected(tr->filtered_pids,
> +					     lockdep_is_held(&event_mutex));
> +	no_pid_list = rcu_dereference_protected(tr->filtered_no_pids,
> +					     lockdep_is_held(&event_mutex));
> +
> +	if (pid_list || no_pid_list)
> +		file->flags |= EVENT_FILE_FL_PID_FILTER;
> +
>  	file->event_call = call;
>  	file->tr = tr;
>  	atomic_set(&file->sm_ref, 0);

Oops, now I see this one, thanks...

greg "read the whole thread before reponding" k-h
