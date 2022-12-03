Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29B0F641984
	for <lists+stable@lfdr.de>; Sat,  3 Dec 2022 23:37:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229542AbiLCWhC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 3 Dec 2022 17:37:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbiLCWhB (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 3 Dec 2022 17:37:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 293691A227
        for <stable@vger.kernel.org>; Sat,  3 Dec 2022 14:37:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CAC69B80189
        for <stable@vger.kernel.org>; Sat,  3 Dec 2022 22:36:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCE6DC433C1;
        Sat,  3 Dec 2022 22:36:56 +0000 (UTC)
Date:   Sat, 3 Dec 2022 17:36:55 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     <gregkh@linuxfoundation.org>
Cc:     akpm@linux-foundation.org, mhiramat@kernel.org,
        yujie.liu@intel.com, zhengyejian1@huawei.com,
        <stable@vger.kernel.org>
Subject: Re: FAILED: patch "[PATCH] tracing: Free buffers when a used
 dynamic event is removed" failed to apply to 4.19-stable tree
Message-ID: <20221203173655.1b1b2fac@gandalf.local.home>
In-Reply-To: <167006641591124@kroah.com>
References: <167006641591124@kroah.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, 03 Dec 2022 12:20:15 +0100
<gregkh@linuxfoundation.org> wrote:

> The patch below does not apply to the 4.19-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 
> Possible dependencies:
> 
> 4313e5a61304 ("tracing: Free buffers when a used dynamic event is removed")

Hmm, isn't the above the patch that failed to apply?

> 5448d44c3855 ("tracing: Add unified dynamic event framework")

And this is mentioned below.

[..]

> If any dynamic event that is being removed was enabled, then make sure the
> buffers they were enabled in are now cleared.
> 
> Link: https://lkml.kernel.org/r/20221123171434.545706e3@gandalf.local.home
> Link: https://lore.kernel.org/all/20221110020319.1259291-1-zhengyejian1@huawei.com/
> 
> Cc: stable@vger.kernel.org
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Depends-on: e18eb8783ec49 ("tracing: Add tracing_reset_all_online_cpus_unlocked() function")

> Depends-on: 5448d44c38557 ("tracing: Add unified dynamic event framework")

^^^

-- Steve

> Depends-on: 6212dd29683ee ("tracing/kprobes: Use dyn_event framework for kprobe events")
> Depends-on: 065e63f951432 ("tracing: Only have rmmod clear buffers that its events were active in")
> Depends-on: 575380da8b469 ("tracing: Only clear trace buffer on module unload if event was traced")
> Fixes: 77b44d1b7c283 ("tracing/kprobes: Rename Kprobe-tracer to kprobe-event")
> Reported-by: Zheng Yejian <zhengyejian1@huawei.com>
> Reported-by: Yujie Liu <yujie.liu@intel.com>
> Reported-by: kernel test robot <yujie.liu@intel.com>
> Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
> Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
> 
> diff --git a/kernel/trace/trace_dynevent.c b/kernel/trace/trace_dynevent.c
> index 154996684fb5..4376887e0d8a 100644
> --- a/kernel/trace/trace_dynevent.c
> +++ b/kernel/trace/trace_dynevent.c
> @@ -118,6 +118,7 @@ int dyn_event_release(const char *raw_command, struct dyn_event_operations *type
>  		if (ret)
>  			break;
>  	}
> +	tracing_reset_all_online_cpus();
>  	mutex_unlock(&event_mutex);
>  out:
>  	argv_free(argv);
> @@ -214,6 +215,7 @@ int dyn_events_release_all(struct dyn_event_operations *type)
>  			break;
>  	}
>  out:
> +	tracing_reset_all_online_cpus();
>  	mutex_unlock(&event_mutex);
>  
>  	return ret;
> diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
> index 78cd19e31dba..f71ea6e79b3c 100644
> --- a/kernel/trace/trace_events.c
> +++ b/kernel/trace/trace_events.c
> @@ -2880,7 +2880,10 @@ static int probe_remove_event_call(struct trace_event_call *call)
>  		 * TRACE_REG_UNREGISTER.
>  		 */
>  		if (file->flags & EVENT_FILE_FL_ENABLED)
> -			return -EBUSY;
> +			goto busy;
> +
> +		if (file->flags & EVENT_FILE_FL_WAS_ENABLED)
> +			tr->clear_trace = true;
>  		/*
>  		 * The do_for_each_event_file_safe() is
>  		 * a double loop. After finding the call for this
> @@ -2893,6 +2896,12 @@ static int probe_remove_event_call(struct trace_event_call *call)
>  	__trace_remove_event_call(call);
>  
>  	return 0;
> + busy:
> +	/* No need to clear the trace now */
> +	list_for_each_entry(tr, &ftrace_trace_arrays, list) {
> +		tr->clear_trace = false;
> +	}
> +	return -EBUSY;
>  }
>  
>  /* Remove an event_call */

