Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 845716A8418
	for <lists+stable@lfdr.de>; Thu,  2 Mar 2023 15:24:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229538AbjCBOY4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Mar 2023 09:24:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbjCBOYz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Mar 2023 09:24:55 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 52E293669F;
        Thu,  2 Mar 2023 06:24:54 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 57E061FB;
        Thu,  2 Mar 2023 06:25:37 -0800 (PST)
Received: from FVFF77S0Q05N.cambridge.arm.com (FVFF77S0Q05N.cambridge.arm.com [10.1.26.133])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 305DF3F587;
        Thu,  2 Mar 2023 06:24:53 -0800 (PST)
Date:   Thu, 2 Mar 2023 14:24:50 +0000
From:   Mark Rutland <mark.rutland@arm.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/2] tracing: Do not let histogram values have some
 modifiers
Message-ID: <ZACxsje6oGZWUs7m@FVFF77S0Q05N.cambridge.arm.com>
References: <20230302010051.044209550@goodmis.org>
 <20230302020810.559462599@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230302020810.559462599@goodmis.org>
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 01, 2023 at 08:00:52PM -0500, Steven Rostedt wrote:
> From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
> 
> Histogram values can not be strings, stacktraces, graphs, symbols,
> syscalls, or grouped in buckets or log. Give an error if a value is set to
> do so.
> 
> Note, the histogram code was not prepared to handle these modifiers for
> histograms and caused a bug.
 
> Cc: stable@vger.kernel.org
> Fixes: c6afad49d127f ("tracing: Add hist trigger 'sym' and 'sym-offset' modifiers")
> Reported-by: Mark Rutland <mark.rutland@arm.com>
> Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>

Tested-by: Mark Rutland <mark.rutland@arm.com>

I gave this a spin, and I see that the buckets modifier gerts rejected for
hitcount, but is usable for other values as it should be:

| # echo 'p:copy_to_user __arch_copy_to_user n=$arg3' >> /sys/kernel/tracing/kprobe_events
| # echo 'hist:keys=n:vals=hitcount.buckets=8:sort=hitcount' > /sys/kernel/tracing/events/kprobes/copy_to_user/trigger
| sh: write error: Invalid argument
| # echo 'hist:keys=n.buckets=8:vals=hitcount:sort=hitcount' > /sys/kernel/tracing/events/kprobes/copy_to_user/trigger
| # cat /sys/kernel/tracing/events/kprobes/copy_to_user/hist
| # event histogram
| #
| # trigger info: hist:keys=n.buckets=8:vals=hitcount:sort=hitcount:size=2048 [active]
| #
| 
| { n: ~ 336-343 } hitcount:          1
| { n: ~ 16-23 } hitcount:          2
| { n: ~ 32-39 } hitcount:          2
| { n: ~ 832-839 } hitcount:          3
| { n: ~ 8-15 } hitcount:          3
| { n: ~ 128-135 } hitcount:          5
| { n: ~ 0-7 } hitcount:         57
| 
| Totals:
|     Hits: 73
|     Entries: 7
|     Dropped: 0

Thanks,
Mark.

> ---
>  kernel/trace/trace_events_hist.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/kernel/trace/trace_events_hist.c b/kernel/trace/trace_events_hist.c
> index 89877a18f933..6e8ab726a7b5 100644
> --- a/kernel/trace/trace_events_hist.c
> +++ b/kernel/trace/trace_events_hist.c
> @@ -4235,6 +4235,15 @@ static int __create_val_field(struct hist_trigger_data *hist_data,
>  		goto out;
>  	}
>  
> +	/* Some types cannot be a value */
> +	if (hist_field->flags & (HIST_FIELD_FL_GRAPH | HIST_FIELD_FL_PERCENT |
> +				 HIST_FIELD_FL_BUCKET | HIST_FIELD_FL_LOG2 |
> +				 HIST_FIELD_FL_SYM | HIST_FIELD_FL_SYM_OFFSET |
> +				 HIST_FIELD_FL_SYSCALL | HIST_FIELD_FL_STACKTRACE)) {
> +		hist_err(file->tr, HIST_ERR_BAD_FIELD_MODIFIER, errpos(field_str));
> +		ret = -EINVAL;
> +	}
> +
>  	hist_data->fields[val_idx] = hist_field;
>  
>  	++hist_data->n_vals;
> -- 
> 2.39.1
