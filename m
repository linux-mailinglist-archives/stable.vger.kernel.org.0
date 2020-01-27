Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77DBA14A9DD
	for <lists+stable@lfdr.de>; Mon, 27 Jan 2020 19:36:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725893AbgA0SgY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jan 2020 13:36:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:55620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725845AbgA0SgY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jan 2020 13:36:24 -0500
Received: from tzanussi-mobl (c-98-220-238-81.hsd1.il.comcast.net [98.220.238.81])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A9AAC214D8;
        Mon, 27 Jan 2020 18:36:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580150183;
        bh=4Jv1bz1IfjMS8uuE2F+6lHYB2szU7cXZTH13JKTr9Uc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=DCt0zij1omKjyIkb6h5uls2cobG6sRe6Rp5nsoq/7/wyZqyWPC+UbnxKpiKkNoxAy
         ckr1TH7Gf9hBbtvdg3AD5FFvKVMjaPzYQlG9x7d6JUYPmZtqYKnzbxGoDeJqRribIz
         fJHlBsyxgQtYn030HHqg+2dAmHSjngpYca68tiAo=
Message-ID: <1580150181.5072.5.camel@kernel.org>
Subject: Re: FAILED: patch "[PATCH] tracing: Fix histogram code when
 expression has same var as" failed to apply to 4.19-stable tree
From:   Tom Zanussi <zanussi@kernel.org>
To:     gregkh@linuxfoundation.org, rostedt@goodmis.org
Cc:     stable@vger.kernel.org
Date:   Mon, 27 Jan 2020 12:36:21 -0600
In-Reply-To: <15801394743854@kroah.com>
References: <15801394743854@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.1-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Steve,

For 4.19, this patch applies if these patches are applied first:

commit 656fe2ba85e81d00e4447bf77b8da2be3c47acb2
Author: Tom Zanussi <tom.zanussi@linux.intel.com>
Date:   Tue Dec 18 14:33:24 2018 -0600

    tracing: Use hist trigger's var_ref array to destroy var_refs

commit de40f033d4e84e843d6a12266e3869015ea9097c
Author: Tom Zanussi <tom.zanussi@linux.intel.com>
Date:   Tue Dec 18 14:33:23 2018 -0600

    tracing: Remove open-coding of hist trigger var_ref management

After applying all 3 to 4.19, I built and ran the ftrace/trigger
selftests and didn't see any problems.

Tom


On Mon, 2020-01-27 at 16:37 +0100, gregkh@linuxfoundation.org wrote:
> The patch below does not apply to the 4.19-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git
> commit
> id to <stable@vger.kernel.org>.
> 
> thanks,
> 
> greg k-h
> 
> ------------------ original commit in Linus's tree ------------------
> 
> From 8bcebc77e85f3d7536f96845a0fe94b1dddb6af0 Mon Sep 17 00:00:00
> 2001
> From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
> Date: Mon, 20 Jan 2020 13:07:31 -0500
> Subject: [PATCH] tracing: Fix histogram code when expression has same
> var as
>  value
> 
> While working on a tool to convert SQL syntex into the histogram
> language of
> the kernel, I discovered the following bug:
> 
>  # echo 'first u64 start_time u64 end_time pid_t pid u64 delta' >>
> synthetic_events
>  # echo 'hist:keys=pid:start=common_timestamp' >
> events/sched/sched_waking/trigger
>  # echo 'hist:keys=next_pid:delta=common_timestamp-
> $start,start2=$start:onmatch(sched.sched_waking).trace(first,$start2,
> common_timestamp,next_pid,$delta)' >
> events/sched/sched_switch/trigger
> 
> Would not display any histograms in the sched_switch histogram side.
> 
> But if I were to swap the location of
> 
>   "delta=common_timestamp-$start" with "start2=$start"
> 
> Such that the last line had:
> 
>  # echo 'hist:keys=next_pid:start2=$start,delta=common_timestamp-
> $start:onmatch(sched.sched_waking).trace(first,$start2,common_timesta
> mp,next_pid,$delta)' > events/sched/sched_switch/trigger
> 
> The histogram works as expected.
> 
> What I found out is that the expressions clear out the value once it
> is
> resolved. As the variables are resolved in the order listed, when
> processing:
> 
>   delta=common_timestamp-$start
> 
> The $start is cleared. When it gets to "start2=$start", it errors out
> with
> "unresolved symbol" (which is silent as this happens at the location
> of the
> trace), and the histogram is dropped.
> 
> When processing the histogram for variable references, instead of
> adding a
> new reference for a variable used twice, use the same reference. That
> way,
> not only is it more efficient, but the order will no longer matter in
> processing of the variables.
> 
> From Tom Zanussi:
> 
>  "Just to clarify some more about what the problem was is that
> without
>   your patch, we would have two separate references to the same
> variable,
>   and during resolve_var_refs(), they'd both want to be resolved
>   separately, so in this case, since the first reference to start
> wasn't
>   part of an expression, it wouldn't get the read-once flag set, so
> would
>   be read normally, and then the second reference would do the read-
> once
>   read and also be read but using read-once.  So everything worked
> and
>   you didn't see a problem:
> 
>    from: start2=$start,delta=common_timestamp-$start
> 
>   In the second case, when you switched them around, the first
> reference
>   would be resolved by doing the read-once, and following that the
> second
>   reference would try to resolve and see that the variable had
> already
>   been read, so failed as unset, which caused it to short-circuit out
> and
>   not do the trigger action to generate the synthetic event:
> 
>    to: delta=common_timestamp-$start,start2=$start
> 
>   With your patch, we only have the single resolution which happens
>   correctly the one time it's resolved, so this can't happen."
> 
> Link: https://lore.kernel.org/r/20200116154216.58ca08eb@gandalf.local
> .home
> 
> Cc: stable@vger.kernel.org
> Fixes: 067fe038e70f6 ("tracing: Add variable reference handling to
> hist triggers")
> Reviewed-by: Tom Zanuss <zanussi@kernel.org>
> Tested-by: Tom Zanussi <zanussi@kernel.org>
> Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> 
> diff --git a/kernel/trace/trace_events_hist.c
> b/kernel/trace/trace_events_hist.c
> index d33b046f985a..6ac35b9e195d 100644
> --- a/kernel/trace/trace_events_hist.c
> +++ b/kernel/trace/trace_events_hist.c
> @@ -116,6 +116,7 @@ struct hist_field {
>  	struct ftrace_event_field	*field;
>  	unsigned long			flags;
>  	hist_field_fn_t			fn;
> +	unsigned int			ref;
>  	unsigned int			size;
>  	unsigned int			offset;
>  	unsigned int                    is_signed;
> @@ -2427,8 +2428,16 @@ static int contains_operator(char *str)
>  	return field_op;
>  }
>  
> +static void get_hist_field(struct hist_field *hist_field)
> +{
> +	hist_field->ref++;
> +}
> +
>  static void __destroy_hist_field(struct hist_field *hist_field)
>  {
> +	if (--hist_field->ref > 1)
> +		return;
> +
>  	kfree(hist_field->var.name);
>  	kfree(hist_field->name);
>  	kfree(hist_field->type);
> @@ -2470,6 +2479,8 @@ static struct hist_field
> *create_hist_field(struct hist_trigger_data *hist_data,
>  	if (!hist_field)
>  		return NULL;
>  
> +	hist_field->ref = 1;
> +
>  	hist_field->hist_data = hist_data;
>  
>  	if (flags & HIST_FIELD_FL_EXPR || flags &
> HIST_FIELD_FL_ALIAS)
> @@ -2665,6 +2676,17 @@ static struct hist_field
> *create_var_ref(struct hist_trigger_data *hist_data,
>  {
>  	unsigned long flags = HIST_FIELD_FL_VAR_REF;
>  	struct hist_field *ref_field;
> +	int i;
> +
> +	/* Check if the variable already exists */
> +	for (i = 0; i < hist_data->n_var_refs; i++) {
> +		ref_field = hist_data->var_refs[i];
> +		if (ref_field->var.idx == var_field->var.idx &&
> +		    ref_field->var.hist_data == var_field-
> >hist_data) {
> +			get_hist_field(ref_field);
> +			return ref_field;
> +		}
> +	}
>  
>  	ref_field = create_hist_field(var_field->hist_data, NULL,
> flags, NULL);
>  	if (ref_field) {
> 
