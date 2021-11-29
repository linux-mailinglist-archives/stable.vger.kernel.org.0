Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D0E14616B2
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 14:37:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243999AbhK2Nkb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 08:40:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348866AbhK2Nia (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 08:38:30 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73485C09B121
        for <stable@vger.kernel.org>; Mon, 29 Nov 2021 04:16:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 88D60CE1112
        for <stable@vger.kernel.org>; Mon, 29 Nov 2021 12:16:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B80CC004E1;
        Mon, 29 Nov 2021 12:16:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638188167;
        bh=6kLJYy8ME1RbuoYp3Mg2WlRoNyjwXLTn0mcry+qt9ZM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OmCDlUX1Y3iGHH6NGw1N449OtViQDb/n7M5AaYJUmPqQ98pTpzPHfHj0LKtr/vHfA
         +oDdiKkA08y7LC4WqQLSQZk5V6Zi7ItWiUPsuIHM9g45cOBldZ4f4VtmBq6sFu379V
         9nYmHc97p2lhj240QFS0rSrXwKmLK4ncWdFls++c=
Date:   Mon, 29 Nov 2021 13:16:05 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] tracing: Check pid filtering when
 creating events" failed to apply to 5.10-stable tree
Message-ID: <YaTEhY4puqeOWClJ@kroah.com>
References: <1638099841130160@kroah.com>
 <20211128134805.1b4501b6@oasis.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211128134805.1b4501b6@oasis.local.home>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Nov 28, 2021 at 01:48:05PM -0500, Steven Rostedt wrote:
> On Sun, 28 Nov 2021 12:44:01 +0100
> <gregkh@linuxfoundation.org> wrote:
> 
> > The patch below does not apply to the 5.10-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> This is a funny case, where I actually found the bug in the 5.15 kernel
> that I was using to do my cut and paste screen shots for the upcoming
> Embedded Fest conference I'll be giving a talk at on Friday.
> 
> I wrote this fix for 5.15 first (to continue working on my
> presentation), and since stable requires upstream to have the fix, I
> forward ported it to 5.16-rc. As 5.16 introduced changes in this code,
> the forward port had to do things differently, and my forward port
> added a bug which the fix has just been added:
> 
>   https://git.kernel.org/torvalds/c/f8132d62a2deedca1b7558028cfe72f93ad5ba2d
> 
> That fix does not need to be backported, as the origin 5.15 patch did
> not have that bug.
> 
> This is the original 5.15 patch I used to create the 5.16 version with,
> and it should also fix 5.10. Kernels before 5.7 will need a different
> patch, as it did not have the "no_pid" feature yet. I'll send out the
> fix for those kernels later.
> 
> -- Steve
> 
> Upstream commit: 6cb206508b621a9a0a2c35b60540e399225c8243
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
> diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
> index 830b3b9940f4..e760e078c733 100644
> --- a/kernel/trace/trace_events.c
> +++ b/kernel/trace/trace_events.c
> @@ -2677,12 +2677,23 @@ static struct trace_event_file *
>  trace_create_new_event(struct trace_event_call *call,
>  		       struct trace_array *tr)
>  {
> +	struct trace_pid_list *no_pid_list;
> +	struct trace_pid_list *pid_list;
>  	struct trace_event_file *file;
> +	unsigned int first;
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
> -- 
> 2.33.0

Why did you add the first variable here?

I get the build failure:

kernel/trace/trace_events.c: In function ‘trace_create_new_event’:
kernel/trace/trace_events.c:2684:22: error: unused variable ‘first’ [-Werror=unused-variable]
 2684 |         unsigned int first;
      |                      ^~~~~
cc1: all warnings being treated as errors

because of that.

I'll go remove that line, but please, test-build your patches at the
very least :)

thanks,

greg k-h
